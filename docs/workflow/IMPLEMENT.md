# Implementation Workflow — {{PROJECT_NAME}}

Use this document for implementation defaults. Issue control-plane rules remain authoritative in `docs/ISSUES_WORKFLOW.md`.

## Development Loop

1. Whiteboard scope in `plans/YYYY-MM-DD/*.md` when needed.
2. Confirm execution mode (`single` by default).
3. Restate goal, non-goals, acceptance criteria, and exact verification commands from the Task.
4. Implement minimally and surgically.
5. Run relevant verification once per code change set.
6. Open PR that closes the Task issue.
7. Hand off for one reviewer pass (`APPROVED` or `ACTIONABLE`).

## Brief-First Execution

For existing Task execution:

- Task issue is the source of truth.
- Execution Brief is optional and task-local (`docs/template/EXECUTION_BRIEF.md`).
- Use `docs/template/KICKOFF.md` section 1 for kickoff execution details.

## Stateful And Cross-Layer Hardening

When the Task touches state transitions, action availability, side effects, or contract/error semantics, include a short Behavior Matrix before implementation:

- states and allowed actions
- success/error semantics
- side effects per path
- failure-path outcomes

Keep unresolved product decisions explicit as follow-up candidates instead of silently locking behavior.

## Boundary Rules

- Allowed direction: `api -> services -> repositories -> integrations/libs`
- Disallowed: reverse imports and cross-layer shortcuts.
- Public services must add orchestration/policy/validation value.
- Repositories own persistence/query logic only.

## No-Contract Refactor Parity Lock

When scope claims no external contract change, verify and report parity for:

1. status codes
2. response schema shape
3. error semantics
4. side effects

## Scope And Modularity Defaults

- One Task issue at a time.
- Default sizing is one feature -> one Task -> one PR unless split criteria in `docs/ISSUES_WORKFLOW.md` apply.
- Frontend leaf components target `<=250` LOC.
- Frontend hooks/services target `<=180` LOC.
- Backend route/service/repository modules target `<=220` LOC.

## Selective Test-First Guidance

For bug fixes, backend business logic, contract-sensitive behavior, and stateful/cross-layer changes, identify the first test/assertion to add before implementation when practical.

## Decision Brief (Conditional)

For non-trivial behavior/contract/architecture changes, include:

- chosen approach
- one alternative considered
- main tradeoff
- revisit trigger

## Toolchain And Docs Discipline

- Keep runtime/toolchain contracts explicit and aligned across README, local verify commands, and CI.
- Update docs only when behavior/contracts/patterns changed.
- Follow `docs/CODE_COMMENTING_CONTRACT.md` for touched code documentation quality.

## Related References

- `docs/ISSUES_WORKFLOW.md`
- `docs/template/KICKOFF.md`
- `docs/workflow/VERIFY.md`
- `docs/workflow/REVIEW.md`
