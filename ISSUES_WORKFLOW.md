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
5. Phase 3/backend-coupled work cannot start until PRD Decision Locks are checked.
6. Tasks target 1-4 hours. If bigger, split before implementation.

## Fast Lane (Quick Fix Flexibility)

For personal projects or low-risk maintenance, a direct quick-fix path is allowed without mandatory PRD/PR when all are true:

- the change is a single logical fix
- no schema/API/realtime contract change
- no auth/security model change
- no migration/dependency changes
- no ADR-worthy architecture decision

When using Fast Lane:

- run relevant verification
- use a clear quick-fix commit message
- direct push to main is allowed for personal workflows
- if scope grows, switch back to PRD -> Task -> PR

## Decision Records and ADRs

Use Decision issues/checkboxes for short-term locking.

If a decision has lasting architecture, security, or performance impact:

- create an ADR (`NNN-*.md`)
- link it from the PRD
- link it from the implementing PR

## Definition of Ready

A Task is ready when:

- scope is clear and bounded
- acceptance criteria are explicit
- verification commands are listed
- dependencies are resolved
- for Phase 3/backend-coupled work: PRD Decision Locks are all checked

## Definition of Done

A Task is done when:

- PR is merged
- verification commands pass
- tests are added/updated where needed
- documentation is updated where needed
- follow-up issues are created for deferred work

## Verification Template

Use project commands:

```bash
{{VERIFY_COMMANDS}}
```

## Optional Later

MCP is not required for v1. Add it later only for automation (issue creation/labeling/CI summaries).
