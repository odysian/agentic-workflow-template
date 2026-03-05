#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/fresh_review_loop.sh --task-id <id> [options]

Options:
  --task-id <id>           Task issue id (required)
  --base <branch>          Base branch for diff review (default: origin/main)
  --verify-cmd <command>   Verification command to run after each patch commit
  --audit-root <path>      Audit root directory (default: .codex/audit)
  --outbox-root <path>     GH outbox directory (default: .codex/outbox)
  --pr <number>            PR number for optional comment mirroring
  --post-pr-comments       Post round summaries to PR via gh
  --strict-gh              Fail instead of queue/disable when GH comment mirroring is unavailable
  --no-strict-gh           Disable strict GH mode even in CI
  -h, --help               Show this help
EOF
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

escape_sed() {
  printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'
}

TASK_ID=""
BASE_BRANCH="origin/main"
VERIFY_CMD=""
AUDIT_ROOT=".codex/audit"
OUTBOX_ROOT=".codex/outbox"
PR_NUMBER=""
POST_PR_COMMENTS=0
STRICT_GH=0
STRICT_GH_SET=0

if [[ -n "${CI:-}" ]]; then
  STRICT_GH=1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --task-id)
      TASK_ID="${2:-}"
      shift 2
      ;;
    --base)
      BASE_BRANCH="${2:-}"
      shift 2
      ;;
    --verify-cmd)
      VERIFY_CMD="${2:-}"
      shift 2
      ;;
    --audit-root)
      AUDIT_ROOT="${2:-}"
      shift 2
      ;;
    --outbox-root)
      OUTBOX_ROOT="${2:-}"
      shift 2
      ;;
    --pr)
      PR_NUMBER="${2:-}"
      shift 2
      ;;
    --post-pr-comments)
      POST_PR_COMMENTS=1
      shift
      ;;
    --strict-gh)
      STRICT_GH=1
      STRICT_GH_SET=1
      shift
      ;;
    --no-strict-gh)
      STRICT_GH=0
      STRICT_GH_SET=1
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

if [[ -z "$TASK_ID" ]]; then
  echo "--task-id is required." >&2
  usage
  exit 1
fi

require_cmd git
require_cmd codex
require_cmd jq

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Must run inside a git repository." >&2
  exit 1
fi

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$CURRENT_BRANCH" == "HEAD" ]]; then
  echo "Detached HEAD is not supported for this workflow." >&2
  exit 1
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Working tree must be clean before running fresh review loop." >&2
  echo "Commit/stash local changes first." >&2
  exit 1
fi

if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
  echo "Working tree has untracked files. Clean/stash before running fresh review loop." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_DIR="$SCRIPT_DIR/prompts"
SCHEMA_DIR="$SCRIPT_DIR/schemas"
GH_PREFLIGHT="$SCRIPT_DIR/gh_preflight.sh"
GH_OUTBOX_APPEND="$SCRIPT_DIR/gh_outbox_append.sh"

REVIEW_TEMPLATE="$PROMPT_DIR/review-round.md"
PATCH_TEMPLATE="$PROMPT_DIR/patch-round.md"
REVIEW_SCHEMA="$SCHEMA_DIR/review-round.schema.json"
PATCH_SCHEMA="$SCHEMA_DIR/patch-round.schema.json"
GH_COMMENT_MODE="disabled"
GH_COMMENT_NOTE=""

for required_file in "$REVIEW_TEMPLATE" "$PATCH_TEMPLATE" "$REVIEW_SCHEMA" "$PATCH_SCHEMA"; do
  if [[ ! -f "$required_file" ]]; then
    echo "Missing required file: $required_file" >&2
    exit 1
  fi
done

if [[ "$POST_PR_COMMENTS" -eq 1 ]]; then
  if [[ ! -x "$GH_OUTBOX_APPEND" || ! -x "$GH_PREFLIGHT" ]]; then
    echo "Missing GH helper scripts. Disable --post-pr-comments or restore helpers." >&2
    exit 1
  fi

  if [[ -n "${CI:-}" && "$STRICT_GH_SET" -eq 0 ]]; then
    GH_COMMENT_NOTE="CI detected: strict GH mode enabled by default."
  fi

  if [[ -z "$PR_NUMBER" ]] && command -v gh >/dev/null 2>&1 && "$GH_PREFLIGHT" --quiet; then
    PR_NUMBER="$(gh pr view --json number --jq .number 2>/dev/null || true)"
  fi

  if [[ -z "$PR_NUMBER" ]]; then
    GH_COMMENT_MODE="disabled"
    GH_COMMENT_NOTE="${GH_COMMENT_NOTE:+$GH_COMMENT_NOTE }comment mirroring unavailable: PR number missing (pass --pr to enable queueing)."
    if [[ "$STRICT_GH" -eq 1 ]]; then
      echo "Strict GH mode: PR comment mirroring requested but PR number unavailable." >&2
      exit 1
    fi
    POST_PR_COMMENTS=0
  elif command -v gh >/dev/null 2>&1 && "$GH_PREFLIGHT" --quiet; then
    GH_COMMENT_MODE="online"
  else
    GH_COMMENT_MODE="queued"
    GH_COMMENT_NOTE="${GH_COMMENT_NOTE:+$GH_COMMENT_NOTE }gh unavailable; PR comments queued to outbox."
  fi
fi

TIMESTAMP="$(date -u +%Y%m%d-%H%M%S)"
AUDIT_DIR="$AUDIT_ROOT/task-${TASK_ID}-${TIMESTAMP}"
mkdir -p "$AUDIT_DIR"

SUMMARY_FILE="$AUDIT_DIR/summary.md"
META_FILE="$AUDIT_DIR/metadata.env"

cat > "$META_FILE" <<EOF
task_id=$TASK_ID
base_branch=$BASE_BRANCH
current_branch=$CURRENT_BRANCH
timestamp_utc=$TIMESTAMP
max_review_rounds=2
max_auto_patch_commits=2
EOF

cat > "$SUMMARY_FILE" <<EOF
# Fresh-Context Review Loop Summary

- Task: #$TASK_ID
- Branch: \`$CURRENT_BRANCH\`
- Base branch: \`$BASE_BRANCH\`
- Timestamp (UTC): \`$TIMESTAMP\`
- Max review rounds: \`2\`
- Max auto patch commits: \`2\`

## Rounds

EOF

render_template() {
  local template_file="$1"
  local output_file="$2"
  local round="$3"
  local review_json_file="$4"
  local prior_review_file="$5"
  local rendered

  rendered="$(cat "$template_file")"
  rendered="$(printf '%s' "$rendered" | sed "s/{{TASK_ID}}/$(escape_sed "$TASK_ID")/g")"
  rendered="$(printf '%s' "$rendered" | sed "s/{{BASE_BRANCH}}/$(escape_sed "$BASE_BRANCH")/g")"
  rendered="$(printf '%s' "$rendered" | sed "s/{{ROUND}}/$(escape_sed "$round")/g")"
  rendered="$(printf '%s' "$rendered" | sed "s#{{REVIEW_JSON_FILE}}#$(escape_sed "$review_json_file")#g")"
  rendered="$(printf '%s' "$rendered" | sed "s#{{PRIOR_REVIEW_FILE}}#$(escape_sed "$prior_review_file")#g")"
  printf '%s\n' "$rendered" > "$output_file"
}

write_review_markdown() {
  local round="$1"
  local review_json="$2"
  local md_file="$3"

  {
    echo "# Task $TASK_ID Review Round r$round"
    echo
    echo "- Patch required: \`$(jq -r '.patch_required' "$review_json")\`"
    echo "- Repeat/churn signal: \`$(jq -r '.repeat_signal' "$review_json")\`"
    echo "- Summary: $(jq -r '.summary' "$review_json")"
    echo
    echo "## Findings"
    if [[ "$(jq '.findings | length' "$review_json")" -eq 0 ]]; then
      echo "- None."
    else
      jq -r '.findings[] | "- [\(.severity)] \(.id): \(.title) (\(.disposition)) | files: \((.files | if length == 0 then "n/a" else join(", ") end))"' "$review_json"
    fi
    echo
    echo "## Deferred Follow-Ups"
    if [[ "$(jq '.deferred_followups | length' "$review_json")" -eq 0 ]]; then
      echo "- None."
    else
      jq -r '.deferred_followups[] | "- \(.title): \(.reason)"' "$review_json"
    fi
  } > "$md_file"
}

write_patch_markdown() {
  local round="$1"
  local patch_json="$2"
  local md_file="$3"

  {
    echo "# Task $TASK_ID Patch Round r$round"
    echo
    echo "- Applied: \`$(jq -r '.applied' "$patch_json")\`"
    echo "- Commit SHA: \`$(jq -r '.commit_sha' "$patch_json")\`"
    echo "- Commit message: \`$(jq -r '.commit_message' "$patch_json")\`"
    echo "- Summary: $(jq -r '.summary' "$patch_json")"
    echo
    echo "## Patched Finding IDs"
    if [[ "$(jq '.patched_finding_ids | length' "$patch_json")" -eq 0 ]]; then
      echo "- None."
    else
      jq -r '.patched_finding_ids[] | "- \(.)"' "$patch_json"
    fi
    echo
    echo "## Deferred Finding IDs"
    if [[ "$(jq '.deferred_finding_ids | length' "$patch_json")" -eq 0 ]]; then
      echo "- None."
    else
      jq -r '.deferred_finding_ids[] | "- \(.)"' "$patch_json"
    fi
  } > "$md_file"
}

post_pr_comment() {
  local body_file="$1"
  local queue_path
  if [[ "$POST_PR_COMMENTS" -ne 1 ]]; then
    return 0
  fi

  if [[ "$GH_COMMENT_MODE" == "online" ]]; then
    if gh pr comment "$PR_NUMBER" --body-file "$body_file" >/dev/null 2>&1; then
      return 0
    fi
    GH_COMMENT_MODE="queued"
    GH_COMMENT_NOTE="${GH_COMMENT_NOTE:+$GH_COMMENT_NOTE }gh comment failed during run; switched to queued mode."
  fi

  if [[ "$GH_COMMENT_MODE" == "queued" ]]; then
    queue_path="$("$GH_OUTBOX_APPEND" \
      --type pr-comment \
      --outbox-root "$OUTBOX_ROOT" \
      --task-id "$TASK_ID" \
      --pr-number "$PR_NUMBER" \
      --body-file "$body_file")"
    GH_COMMENT_NOTE="${GH_COMMENT_NOTE:+$GH_COMMENT_NOTE }queued=$queue_path"
    if [[ "$STRICT_GH" -eq 1 ]]; then
      echo "Strict GH mode: queued PR comment action instead of posting immediately." >&2
      exit 1
    fi
  fi
}

run_verify() {
  local round="$1"
  local verify_log="$AUDIT_DIR/task-${TASK_ID}-r${round}-verify.log"
  if [[ -z "$VERIFY_CMD" ]]; then
    echo "skipped" > "$verify_log"
    return 0
  fi

  set +e
  bash -lc "$VERIFY_CMD" > "$verify_log" 2>&1
  local verify_status=$?
  set -e

  if [[ $verify_status -ne 0 ]]; then
    echo "- r$round verify failed. See \`$(basename "$verify_log")\`" >> "$SUMMARY_FILE"
    echo "Verification failed for round r$round. See: $verify_log" >&2
    exit 1
  fi
  echo "- r$round verify passed. See \`$(basename "$verify_log")\`" >> "$SUMMARY_FILE"
}

run_review_round() {
  local round="$1"
  local prior_review_file="$2"
  local prompt_file="$AUDIT_DIR/task-${TASK_ID}-r${round}-review-prompt.md"
  local review_json="$AUDIT_DIR/task-${TASK_ID}-r${round}-review.json"
  local review_log="$AUDIT_DIR/task-${TASK_ID}-r${round}-review.log"
  local review_md="$AUDIT_DIR/task-${TASK_ID}-r${round}-review.md"
  local comment_md="$AUDIT_DIR/task-${TASK_ID}-r${round}-pr-comment.md"

  render_template "$REVIEW_TEMPLATE" "$prompt_file" "$round" "" "$prior_review_file"

  codex exec \
    --ephemeral \
    --full-auto \
    --color never \
    -s read-only \
    --output-schema "$REVIEW_SCHEMA" \
    -o "$review_json" \
    "$(cat "$prompt_file")" > "$review_log" 2>&1

  jq empty "$review_json" >/dev/null
  write_review_markdown "$round" "$review_json" "$review_md"

  {
    echo "## Fresh-Context Review r$round (Task #$TASK_ID)"
    echo
    cat "$review_md"
  } > "$comment_md"
  post_pr_comment "$comment_md"

  echo "$review_json"
}

run_patch_round() {
  local round="$1"
  local review_json="$2"
  local prompt_file="$AUDIT_DIR/task-${TASK_ID}-r${round}-patch-prompt.md"
  local patch_json="$AUDIT_DIR/task-${TASK_ID}-r${round}-patch.json"
  local patch_log="$AUDIT_DIR/task-${TASK_ID}-r${round}-patch.log"
  local patch_md="$AUDIT_DIR/task-${TASK_ID}-r${round}-patch.md"
  local comment_md="$AUDIT_DIR/task-${TASK_ID}-r${round}-patch-pr-comment.md"
  local head_before
  local head_after
  local commits_added
  local latest_subject

  render_template "$PATCH_TEMPLATE" "$prompt_file" "$round" "$review_json" ""
  head_before="$(git rev-parse HEAD)"

  codex exec \
    --ephemeral \
    --full-auto \
    --color never \
    -s workspace-write \
    --output-schema "$PATCH_SCHEMA" \
    -o "$patch_json" \
    "$(cat "$prompt_file")" > "$patch_log" 2>&1

  jq empty "$patch_json" >/dev/null
  head_after="$(git rev-parse HEAD)"
  write_patch_markdown "$round" "$patch_json" "$patch_md"

  {
    echo "## Fresh-Context Patch r$round (Task #$TASK_ID)"
    echo
    cat "$patch_md"
  } > "$comment_md"
  post_pr_comment "$comment_md"

  if [[ "$head_before" != "$head_after" ]]; then
    commits_added="$(git rev-list --count "$head_before..$head_after")"
    if [[ "$commits_added" -ne 1 ]]; then
      echo "Patch round r$round produced $commits_added commits; expected exactly 1." >&2
      exit 1
    fi

    latest_subject="$(git log -1 --pretty=%s)"
    if [[ "$latest_subject" != "fix(review-r${round}):"* ]]; then
      echo "Latest commit subject does not match required prefix fix(review-r${round}):" >&2
      echo "Found: $latest_subject" >&2
      exit 1
    fi
    echo "commit_added"
  else
    if ! git diff --quiet || ! git diff --cached --quiet; then
      echo "Patch round r$round changed files but did not create a commit." >&2
      exit 1
    fi
    echo "no_commit"
  fi
}

REVIEW_ROUNDS=0
PATCH_COMMITS=0
REPEAT_SIGNAL="false"

REVIEW1_JSON="$(run_review_round 1 "")"
REVIEW_ROUNDS=1

PATCH_REQUIRED_R1="$(jq -r '.patch_required' "$REVIEW1_JSON")"
REPEAT_SIGNAL="$(jq -r '.repeat_signal' "$REVIEW1_JSON")"
echo "- r1 review complete: patch_required=\`$PATCH_REQUIRED_R1\`, repeat_signal=\`$REPEAT_SIGNAL\`" >> "$SUMMARY_FILE"

PATCH1_STATUS="no_patch"
if [[ "$PATCH_REQUIRED_R1" == "true" && "$PATCH_COMMITS" -lt 2 && "$REPEAT_SIGNAL" != "true" ]]; then
  PATCH1_STATUS="$(run_patch_round 1 "$REVIEW1_JSON")"
  echo "- r1 patch status: \`$PATCH1_STATUS\`" >> "$SUMMARY_FILE"
  if [[ "$PATCH1_STATUS" == "commit_added" ]]; then
    PATCH_COMMITS=$((PATCH_COMMITS + 1))
    run_verify 1
  fi
fi

if [[ "$PATCH1_STATUS" == "commit_added" && "$REVIEW_ROUNDS" -lt 2 ]]; then
  REVIEW2_JSON="$(run_review_round 2 "$REVIEW1_JSON")"
  REVIEW_ROUNDS=2
  PATCH_REQUIRED_R2="$(jq -r '.patch_required' "$REVIEW2_JSON")"
  REPEAT_SIGNAL_R2="$(jq -r '.repeat_signal' "$REVIEW2_JSON")"
  echo "- r2 review complete: patch_required=\`$PATCH_REQUIRED_R2\`, repeat_signal=\`$REPEAT_SIGNAL_R2\`" >> "$SUMMARY_FILE"

  if [[ "$PATCH_REQUIRED_R2" == "true" && "$PATCH_COMMITS" -lt 2 && "$REPEAT_SIGNAL_R2" != "true" ]]; then
    PATCH2_STATUS="$(run_patch_round 2 "$REVIEW2_JSON")"
    echo "- r2 patch status: \`$PATCH2_STATUS\`" >> "$SUMMARY_FILE"
    if [[ "$PATCH2_STATUS" == "commit_added" ]]; then
      PATCH_COMMITS=$((PATCH_COMMITS + 1))
      run_verify 2
    fi
  fi
fi

{
  echo
  echo "## Final State"
  echo
  echo "- Review rounds executed: \`$REVIEW_ROUNDS\`"
  echo "- Patch commits added: \`$PATCH_COMMITS\`"
  echo "- Audit directory: \`$AUDIT_DIR\`"
  if [[ "$POST_PR_COMMENTS" -eq 1 && "$GH_COMMENT_MODE" == "online" ]]; then
    echo "- PR comment mode: \`online\` (PR #$PR_NUMBER)"
  elif [[ "$POST_PR_COMMENTS" -eq 1 && "$GH_COMMENT_MODE" == "queued" ]]; then
    echo "- PR comment mode: \`queued\` (PR #$PR_NUMBER)"
    echo "- Replay queue command: \`scripts/gh_outbox_replay.sh --outbox-root $OUTBOX_ROOT\`"
  else
    echo "- PR comment mode: \`disabled\`"
  fi
  if [[ -n "$GH_COMMENT_NOTE" ]]; then
    echo "- PR comment note: $GH_COMMENT_NOTE"
  fi
} >> "$SUMMARY_FILE"

echo "Fresh-context review loop complete."
echo "Summary: $SUMMARY_FILE"
