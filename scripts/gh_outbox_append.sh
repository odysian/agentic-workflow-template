#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/gh_outbox_append.sh --type <pr-create|pr-comment> [options]

Required by type:
  pr-create:
    --title <text> --base <branch> --head <branch> --body-file <path>
  pr-comment:
    --pr-number <number> --body-file <path>

Common options:
  --outbox-root <path>      Outbox root (default: .codex/outbox)
  --task-id <id>            Optional task id for audit context
USAGE
}

require_file() {
  if [[ ! -f "$1" ]]; then
    echo "File not found: $1" >&2
    exit 1
  fi
}

sanitize() {
  printf '%s' "$1" | tr -cs 'a-zA-Z0-9._-' '-'
}

TYPE=""
OUTBOX_ROOT=".codex/outbox"
TASK_ID=""

TITLE=""
BASE=""
HEAD=""
PR_NUMBER=""
BODY_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --type)
      TYPE="${2:-}"
      shift 2
      ;;
    --outbox-root)
      OUTBOX_ROOT="${2:-}"
      shift 2
      ;;
    --task-id)
      TASK_ID="${2:-}"
      shift 2
      ;;
    --title)
      TITLE="${2:-}"
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
    --pr-number)
      PR_NUMBER="${2:-}"
      shift 2
      ;;
    --body-file)
      BODY_FILE="${2:-}"
      shift 2
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

if [[ -z "$TYPE" ]]; then
  echo "--type is required." >&2
  usage
  exit 1
fi

if [[ "$TYPE" != "pr-create" && "$TYPE" != "pr-comment" ]]; then
  echo "Unsupported --type: $TYPE" >&2
  exit 1
fi

if [[ -z "$BODY_FILE" ]]; then
  echo "--body-file is required." >&2
  exit 1
fi
require_file "$BODY_FILE"

case "$TYPE" in
  pr-create)
    if [[ -z "$TITLE" || -z "$BASE" || -z "$HEAD" ]]; then
      echo "pr-create requires --title, --base, --head, and --body-file." >&2
      exit 1
    fi
    ;;
  pr-comment)
    if [[ -z "$PR_NUMBER" ]]; then
      echo "pr-comment requires --pr-number and --body-file." >&2
      exit 1
    fi
    if ! [[ "$PR_NUMBER" =~ ^[0-9]+$ ]]; then
      echo "--pr-number must be numeric." >&2
      exit 1
    fi
    ;;
esac

TS_TAG="$(date -u +%Y%m%d-%H%M%S)"
TS_ISO="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
RAND_SUFFIX="$(printf '%04d' "$((RANDOM % 10000))")"
ACTION_ID="${TS_TAG}-${TYPE}-${RAND_SUFFIX}"

PENDING_DIR="$OUTBOX_ROOT/pending"
DONE_DIR="$OUTBOX_ROOT/done"
LOG_DIR="$OUTBOX_ROOT/logs"
DATA_DIR="$OUTBOX_ROOT/data"
mkdir -p "$PENDING_DIR" "$DONE_DIR" "$LOG_DIR" "$DATA_DIR"

BODY_SNAPSHOT="$DATA_DIR/${ACTION_ID}-body.md"
cp "$BODY_FILE" "$BODY_SNAPSHOT"

ACTION_JSON="$PENDING_DIR/${ACTION_ID}.json"

if [[ "$TYPE" == "pr-create" ]]; then
  jq -n \
    --arg id "$ACTION_ID" \
    --arg created_at "$TS_ISO" \
    --arg type "$TYPE" \
    --arg task_id "$TASK_ID" \
    --arg title "$TITLE" \
    --arg base "$BASE" \
    --arg head "$HEAD" \
    --arg body_file "$BODY_SNAPSHOT" \
    '{
      version: 1,
      id: $id,
      created_at_utc: $created_at,
      type: $type,
      context: { task_id: ($task_id | if . == "" then null else . end) },
      payload: {
        title: $title,
        base: $base,
        head: $head,
        body_file: $body_file
      }
    }' > "$ACTION_JSON"
else
  jq -n \
    --arg id "$ACTION_ID" \
    --arg created_at "$TS_ISO" \
    --arg type "$TYPE" \
    --arg task_id "$TASK_ID" \
    --arg pr_number "$PR_NUMBER" \
    --arg body_file "$BODY_SNAPSHOT" \
    '{
      version: 1,
      id: $id,
      created_at_utc: $created_at,
      type: $type,
      context: { task_id: ($task_id | if . == "" then null else . end) },
      payload: {
        pr_number: ($pr_number | tonumber),
        body_file: $body_file
      }
    }' > "$ACTION_JSON"
fi

printf '%s\n' "$ACTION_JSON"
