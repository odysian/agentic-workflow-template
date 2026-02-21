# Issues Workflow

This repository uses a PRD -> Task -> PR execution model.

## Objects

- **PRD** (`type:prd`): feature spec, decision locks, acceptance criteria, and verification plan.
- **Task** (`type:task`): PR-sized unit of work.
- **Decision** (`type:decision`): short-term decision lock with rationale.

## Control Plane Rules

1. GitHub Issues are the default source of truth for execution. `TASKS.md` (if present) remains scratchpad only.
2. PRD -> Task -> PR is the default execution model.
3. PRs close Task issues (`Closes #...`), not PRDs.
4. PRDs are closed only when all linked Tasks are complete.
5. Default sizing rule: **1 PRD -> 1 Task -> 1 PR**.
6. Tasks are PR-sized; in this workflow, PR-sized usually means end-to-end feature delivery.
7. Phase 3/backend-coupled work cannot start until PRD Decision Locks are checked.

## When to Split Into Multiple Tasks

Split only when it clearly improves delivery or risk control:

- change is too large for one PR (guideline: ~600+ LOC or hard to review)
- backend contract should land before frontend integration
- migrations or realtime contract changes increase risk
- parallel work or staged rollout is needed

## Fast Lane (Quick Fix Flexibility)

For low-risk maintenance, a direct quick-fix path can be allowed (if project policy allows) without mandatory PRD/PR when all are true:

- the change is a single logical fix
- no schema/API/realtime contract change
- no auth/security model change
- no migration/dependency changes
- no ADR-worthy architecture decision

When using Fast Lane:

- run relevant verification
- use a clear quick-fix commit message
- if scope grows, switch back to PRD -> Task -> PR

## Decision Records and ADRs

Use PRD checkbox locks by default.

Use a separate Decision issue only for non-trivial or cross-PRD discussion.

If a decision has lasting architecture, security, or performance impact:

- create an ADR (`NNN-*.md`)
- link it from the PRD
- link it from the implementing PR

## Definition of Ready

A Task is ready when:

- acceptance criteria are explicit
- verification commands are listed
- dependencies/links are included
- for Phase 3/backend-coupled work: PRD Decision Locks are checked

## Definition of Done

A Task is done when:

- PR is merged
- verification commands pass
- tests and docs for the feature are included in the same Task by default
- follow-up issues are created for deferred work

## Verification Template

Use project commands:

```bash
{{VERIFY_COMMANDS}}
```

## Codex + GitHub CLI Playbook

If using Codex in VS Code with GitHub CLI, follow `skills/prd-workflow-gh.md` for the end-to-end flow:

- PRD draft
- one default end-to-end Task issue body (optional splits only when criteria apply)
- `gh issue create` command generation
- optional Task execution and PR creation

## Common GitHub CLI Commands

```bash
gh issue create --title "PRD: <feature>" --label "type:prd" --body-file prd-<feature>.md
gh issue create --title "Task: <feature> end-to-end" --label "type:task,area:frontend" --body-file task-<feature>-01.md
gh issue list --label type:task
gh issue view <id>
```

## Optional Later

MCP is not required for v1. Add it later only for automation (issue creation/labeling/CI summaries).
