#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/gh_outbox_replay.sh [options]

Options:
  --outbox-root <path>   Outbox root (default: .codex/outbox)
  --max <n>              Max actions to replay this run (default: all)
  --dry-run              Print queued action files without executing
USAGE
}

OUTBOX_ROOT=".codex/outbox"
MAX_COUNT=""
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --outbox-root)
      OUTBOX_ROOT="${2:-}"
      shift 2
      ;;
    --max)
      MAX_COUNT="${2:-}"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -n "$MAX_COUNT" ]] && { ! [[ "$MAX_COUNT" =~ ^[0-9]+$ ]] || [[ "$MAX_COUNT" -lt 1 ]]; }; then
  echo "--max must be a positive integer." >&2
  exit 1
fi

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require_cmd jq
require_cmd gh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GH_PREFLIGHT="$SCRIPT_DIR/gh_preflight.sh"

PENDING_DIR="$OUTBOX_ROOT/pending"
DONE_DIR="$OUTBOX_ROOT/done"
LOG_DIR="$OUTBOX_ROOT/logs"
LOCK_DIR="$OUTBOX_ROOT/.lock"
mkdir -p "$PENDING_DIR" "$DONE_DIR" "$LOG_DIR"

shopt -s nullglob
actions=("$PENDING_DIR"/*.json)
shopt -u nullglob

if [[ "${#actions[@]}" -eq 0 ]]; then
  echo "No pending GH outbox actions."
  exit 0
fi

if [[ "$DRY_RUN" -eq 1 ]]; then
  printf '%s\n' "${actions[@]}"
  exit 0
fi

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  echo "Replay already in progress (lock exists: $LOCK_DIR)." >&2
  exit 3
fi

cleanup_lock() {
  rmdir "$LOCK_DIR" >/dev/null 2>&1 || true
}
trap cleanup_lock EXIT

if ! "$GH_PREFLIGHT" --quiet; then
  echo "GH preflight failed; leaving queued actions untouched." >&2
  exit 2
fi

repo_slug="$(gh repo view --json nameWithOwner --jq .nameWithOwner)"

already_done() {
  local action_id="$1"
  [[ -f "$DONE_DIR/${action_id}.json" ]]
}

is_duplicate_pr_for_head() {
  local base="$1"
  local head="$2"
  local existing

  existing="$(gh pr list --state all --base "$base" --head "$head" --json number --jq '.[0].number' 2>/dev/null || true)"
  [[ -n "$existing" && "$existing" != "null" ]]
}

comment_marker_exists() {
  local pr_number="$1"
  local marker="$2"
  local bodies

  bodies="$(gh pr view "$pr_number" --json comments --jq '.comments[].body' 2>/dev/null || true)"
  if printf '%s\n' "$bodies" | grep -Fq "$marker"; then
    return 0
  fi
  return 1
}

execute_action() {
  local action_file="$1"
  local action_id action_type body_file
  action_id="$(jq -r '.id' "$action_file")"
  action_type="$(jq -r '.type' "$action_file")"

  if [[ "$action_id" == "null" || "$action_type" == "null" ]]; then
    echo "Invalid action file (missing id/type): $action_file" >&2
    return 1
  fi

  if already_done "$action_id"; then
    echo "Skipping already-done action id=$action_id"
    mv "$action_file" "$DONE_DIR/${action_id}.json"
    return 0
  fi

  case "$action_type" in
    pr-create)
      local title base head
      title="$(jq -r '.payload.title' "$action_file")"
      base="$(jq -r '.payload.base' "$action_file")"
      head="$(jq -r '.payload.head' "$action_file")"
      body_file="$(jq -r '.payload.body_file' "$action_file")"

      if [[ "$title" == "null" || "$base" == "null" || "$head" == "null" || "$body_file" == "null" ]]; then
        echo "Invalid pr-create payload in $action_file" >&2
        return 1
      fi
      if [[ ! -f "$body_file" ]]; then
        echo "Missing body snapshot for action $action_id: $body_file" >&2
        return 1
      fi

      if is_duplicate_pr_for_head "$base" "$head"; then
        echo "Action $action_id already satisfied by existing PR for head=$head base=$base"
        return 0
      fi

      gh pr create --base "$base" --head "$head" --title "$title" --body-file "$body_file"
      ;;
    pr-comment)
      local pr_number marker temp_body
      pr_number="$(jq -r '.payload.pr_number' "$action_file")"
      body_file="$(jq -r '.payload.body_file' "$action_file")"

      if [[ "$pr_number" == "null" || "$body_file" == "null" ]]; then
        echo "Invalid pr-comment payload in $action_file" >&2
        return 1
      fi
      if [[ ! -f "$body_file" ]]; then
        echo "Missing comment body snapshot for action $action_id: $body_file" >&2
        return 1
      fi

      marker="<!-- gh-outbox-action:$action_id -->"
      if comment_marker_exists "$pr_number" "$marker"; then
        echo "Action $action_id already satisfied (comment marker exists on PR #$pr_number)"
        return 0
      fi

      temp_body="$(mktemp)"
      {
        cat "$body_file"
        echo
        echo "$marker"
      } > "$temp_body"
      gh pr comment "$pr_number" --body-file "$temp_body"
      rm -f "$temp_body"
      ;;
    *)
      echo "Unsupported action type in $action_file: $action_type" >&2
      return 1
      ;;
  esac
}

executed=0
for action in "${actions[@]}"; do
  if [[ -n "$MAX_COUNT" && "$executed" -ge "$MAX_COUNT" ]]; then
    break
  fi

  base_name="$(basename "$action")"
  action_id="$(jq -r '.id' "$action")"
  if [[ "$action_id" == "null" || -z "$action_id" ]]; then
    action_id="${base_name%.json}"
  fi

  log_file="$LOG_DIR/${action_id}.log"
  done_file="$DONE_DIR/${action_id}.json"

  set +e
  {
    echo "repo=$repo_slug"
    echo "action_file=$action"
    execute_action "$action"
  } > "$log_file" 2>&1
  rc=$?
  set -e

  if [[ "$rc" -ne 0 ]]; then
    echo "Replay failed for $action (see $log_file). Stopping to preserve order." >&2
    exit 1
  fi

  mv "$action" "$done_file"
  executed=$((executed + 1))
  echo "Replayed: ${action_id}"
done

echo "Replay complete. Executed $executed action(s)."
