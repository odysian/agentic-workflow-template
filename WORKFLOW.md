# WORKFLOW.md — {{PROJECT_NAME}}

## Development Loop

Every feature follows:

1. Whiteboard
2. Document as issue(s)
3. Implement
4. Fresh-context review
5. Patch review findings (bounded)
6. Finalize

## Control Plane

`ISSUES_WORKFLOW.md` is the source of truth for execution mode, split criteria, and DoR/DoD.

## Bounded Review/Patch Loop

For `single` and `gated` Task work:

1. Implement Task acceptance criteria and verify.
2. Commit and open PR (`Closes #<task-id>`).
3. Run fresh-context review round `r1` in a separate session.
4. Patch notable findings on same branch (`fix(review-r<round>): ...`).
5. Re-verify.
6. Run `r2` only if round `r1` produced a patch commit.
7. Stop when clean, capped, or churn repeats.

Caps:

- `max_review_rounds=2`
- `max_auto_patch_commits=2`

## Canonical Local Commands

PR create (resilient):

```bash
scripts/create_pr.sh --title "Task #<id>: <short-title>" --body-file <pr-body.md> --base main --head <task-branch> --task-id <id>
```

Fresh-context review loop:

```bash
scripts/fresh_review_loop.sh --task-id <id> --base origin/main --verify-cmd "<verify-command>"
```

Replay queued GH actions after connectivity/auth recovery:

```bash
scripts/gh_outbox_replay.sh
```

## GH Reliability Policy

- Always use `--body-file` for issue/PR content.
- Run `scripts/gh_preflight.sh` before GH write actions.
- If GH preflight fails, queue JSON action to outbox and continue implementation flow locally.
- Do not loop indefinitely on failing GH calls.
- In CI, strict mode is default for PR creation (`scripts/create_pr.sh`) so queued actions fail the job.
- Replay queue is lock-protected and idempotent (`scripts/gh_outbox_replay.sh`).

## Required Audit Trail

Per review round, keep evidence in local audit artifacts and PR (when available):

- findings + severity
- disposition (`patched`, `deferred`, `dismissed`)
- patch commit SHA(s) or follow-up issue link(s)

Local audit path:

- `.codex/audit/task-<id>-<utc-timestamp>/`

## Verification

### Full

```bash
{{VERIFY_COMMANDS}}
```

### Frontend

```bash
{{FRONTEND_VERIFY_COMMANDS}}
```

### Backend

```bash
{{BACKEND_VERIFY_COMMANDS}}
```

### DB

```bash
{{DB_VERIFY_COMMANDS}}
```
