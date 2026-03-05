# ISSUES_WORKFLOW.md

GitHub issues are the execution control plane.

## Core Rules

1. Source of truth is GitHub Issues (`TASKS.md` is scratch only).
2. Default path: `1 feature -> 1 Task -> 1 PR`.
3. PRs close Task issues (`Closes #...`), not Specs.
4. Specs close only when child Tasks are complete or explicitly deferred.
5. For `single`/`gated`, create a dedicated Task branch before coding.
6. Backend-coupled work requires Decision Locks before implementation.
7. Run fresh-context review before finalize (separate session).
8. Keep review/patch loop bounded (`max_review_rounds=2`, `max_auto_patch_commits=2`).
9. Document each review round (findings, severity, disposition, patch SHA/follow-up).

## Execution Modes

### `single` (default)

- One Task issue per feature.
- One PR closes that Task.
- Best for most feature work.

### `gated` (Spec + Tasks)

- One Spec issue + child Task issue(s).
- Use for higher-risk feature sets.
- Child Tasks remain PR-sized.

### `fast` (quick fix)

Allowed only when all are true:

- one logical low-risk fix
- no schema/API/realtime contract changes
- no auth/security model changes
- no migrations/dependency changes
- no ADR-level architectural decision

If scope grows, switch to `single` or `gated`.

## Split Criteria

Split into multiple Tasks only when it improves risk/delivery:

- too large for one PR (~600+ LOC or hard to review)
- backend contract must land before frontend integration
- migration/realtime contract risk needs staged delivery
- parallel work or rollout staging required

## Definition of Ready

A Task is ready when:

- acceptance criteria are explicit
- verification commands are listed
- dependencies/links are documented
- Decision Locks are checked for backend-coupled work

## Definition of Done

A Task is done when:

- PR merged
- verification passes
- tests/docs updated for in-scope changes
- deferred work captured as follow-up issue(s)
- required fresh-context review completed and documented
- auto-review patches stayed within loop caps

## Fresh-Context Automation (Local First)

Canonical flow:

1. Implement + verify.
2. Open PR with `Closes #<task-id>`.
3. Run review round `r1` (fresh session).
4. Patch high/critical findings now.
5. Defer low/medium unless trivial and low-risk.
6. Run round `r2` only if a patch commit was added in `r1`.
7. Stop on clean/cap/churn.

Canonical local command:

```bash
scripts/fresh_review_loop.sh --task-id <id> --base origin/main --verify-cmd "<verify-command>"
```

Optional PR comment mirroring:

```bash
scripts/fresh_review_loop.sh --task-id <id> --base origin/main --verify-cmd "<verify-command>" --post-pr-comments --pr <number>
```

Local audit source of truth:

- `.codex/audit/task-<id>-<utc-timestamp>/`
- round review/patch artifacts
- `summary.md`

## GH Reliability (Fail-Open)

Use resilient wrappers:

```bash
scripts/create_pr.sh --title "Task #<id>: <short-title>" --body-file <pr-body.md> --base main --head <task-branch> --task-id <id>
```

Behavior:

- run preflight (`scripts/gh_preflight.sh`)
- if GH fails (auth/DNS/API), queue GH actions as JSON to `.codex/outbox/pending/`
- continue implementation/review flow without blocking
- queue replay is lock-protected and idempotent
- in CI, PR creation defaults to strict mode (queued action fails job unless `--no-strict`)
- replay queued GH actions after recovery:

```bash
scripts/gh_outbox_replay.sh
```
