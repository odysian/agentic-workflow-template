#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/create_pr.sh --title "<title>" --body-file <path> [options]

Options:
  --title <text>           PR title (required)
  --body-file <path>       Markdown file for PR body (required)
  --base <branch>          Base branch (default: main)
  --head <branch>          Head branch (default: current git branch)
  --task-id <id>           Optional Task issue id for logging context
  --max-attempts <n>       Number of gh pr create attempts (default: 3)
  --outbox-root <path>     GH outbox root (default: .codex/outbox)
  --strict                 Exit non-zero when PR is queued instead of created
  --no-strict              Force non-strict mode even in CI
  -h, --help               Show help
USAGE
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

parse_repo_slug() {
  local url="$1"
  url="${url%.git}"
  if [[ "$url" =~ github\.com[:/]([^/]+/[^/]+)$ ]]; then
    printf '%s\n' "${BASH_REMATCH[1]}"
    return 0
  fi
  return 1
}

queue_action() {
  local queue_path
  queue_path="$($GH_OUTBOX_APPEND \
    --type pr-create \
    --outbox-root "$OUTBOX_ROOT" \
    --task-id "$TASK_ID" \
    --title "$TITLE" \
    --base "$BASE" \
    --head "$HEAD" \
    --body-file "$BODY_FILE")"

  echo "Queued GH action: $queue_path" >&2
}

manual_pr_url() {
  local origin_url repo_slug
  origin_url="$(git remote get-url origin 2>/dev/null || true)"
  if [[ -z "$origin_url" ]]; then
    return 1
  fi

  repo_slug="$(parse_repo_slug "$origin_url" || true)"
  if [[ -z "$repo_slug" ]]; then
    return 1
  fi

  printf 'https://github.com/%s/pull/new/%s\n' "$repo_slug" "$HEAD"
}

finalize_queued() {
  local fallback_url

  queue_action

  fallback_url="$(manual_pr_url || true)"
  if [[ -n "$fallback_url" ]]; then
    echo "Open PR manually (or use queued replay later): $fallback_url" >&2
  fi

  echo "Replay queued GH actions later with: scripts/gh_outbox_replay.sh" >&2
  if [[ "$STRICT" -eq 1 ]]; then
    exit 1
  fi
  exit 0
}

TITLE=""
BODY_FILE=""
BASE="main"
HEAD=""
TASK_ID=""
MAX_ATTEMPTS=3
OUTBOX_ROOT=".codex/outbox"
STRICT=0
STRICT_SET=0

if [[ -n "${CI:-}" ]]; then
  STRICT=1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title)
      TITLE="${2:-}"
      shift 2
      ;;
    --body-file)
      BODY_FILE="${2:-}"
      shift 2
      ;;
    --base)
      BASE="${2:-}"
      shift 2
      ;;
    --head)
      HEAD="${2:-}"
      shift 2
      ;;
    --task-id)
      TASK_ID="${2:-}"
      shift 2
      ;;
    --max-attempts)
      MAX_ATTEMPTS="${2:-}"
      shift 2
      ;;
    --outbox-root)
      OUTBOX_ROOT="${2:-}"
      shift 2
      ;;
    --strict)
      STRICT=1
      STRICT_SET=1
      shift
      ;;
    --no-strict)
      STRICT=0
      STRICT_SET=1
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

if [[ -z "$TITLE" || -z "$BODY_FILE" ]]; then
  echo "--title and --body-file are required." >&2
  usage
  exit 1
fi

if [[ ! -f "$BODY_FILE" ]]; then
  echo "Body file not found: $BODY_FILE" >&2
  exit 1
fi

if ! [[ "$MAX_ATTEMPTS" =~ ^[0-9]+$ ]] || [[ "$MAX_ATTEMPTS" -lt 1 ]]; then
  echo "--max-attempts must be a positive integer." >&2
  exit 1
fi

require_cmd git
require_cmd jq

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Must run inside a git repository." >&2
  exit 1
fi

if [[ -z "$HEAD" ]]; then
  HEAD="$(git rev-parse --abbrev-ref HEAD)"
fi

if [[ "$HEAD" == "HEAD" ]]; then
  echo "Detached HEAD is not supported." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GH_PREFLIGHT="$SCRIPT_DIR/gh_preflight.sh"
GH_OUTBOX_APPEND="$SCRIPT_DIR/gh_outbox_append.sh"

if [[ ! -x "$GH_PREFLIGHT" || ! -x "$GH_OUTBOX_APPEND" ]]; then
  echo "Missing required helper scripts in $SCRIPT_DIR" >&2
  exit 1
fi

if [[ -n "$TASK_ID" ]]; then
  echo "Task context: #$TASK_ID"
fi
if [[ -n "${CI:-}" && "$STRICT_SET" -eq 0 ]]; then
  echo "CI detected: strict mode enabled by default." >&2
fi

echo "Preparing PR create: base=$BASE head=$HEAD title=$TITLE"

CREATE_CMD=(
  gh pr create
  --base "$BASE"
  --head "$HEAD"
  --title "$TITLE"
  --body-file "$BODY_FILE"
)

if ! "$GH_PREFLIGHT" --quiet; then
  echo "GH preflight failed. Deferring PR creation to outbox." >&2
  finalize_queued
fi

attempt=1
while [[ "$attempt" -le "$MAX_ATTEMPTS" ]]; do
  set +e
  create_output="$("${CREATE_CMD[@]}" 2>&1)"
  create_status=$?
  set -e

  if [[ "$create_status" -eq 0 ]]; then
    echo "$create_output"
    exit 0
  fi

  echo "gh pr create failed (attempt $attempt/$MAX_ATTEMPTS)." >&2
  echo "$create_output" >&2
  if [[ "$attempt" -lt "$MAX_ATTEMPTS" ]]; then
    sleep_seconds=$((attempt * 2))
    echo "Retrying in ${sleep_seconds}s..." >&2
    sleep "$sleep_seconds"
  fi
  attempt=$((attempt + 1))
done

echo "gh pr create failed after $MAX_ATTEMPTS attempts. Deferring to outbox." >&2
finalize_queued
