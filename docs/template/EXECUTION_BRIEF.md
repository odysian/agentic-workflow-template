# Execution Brief Template

Use this brief only when a GitHub Task issue already exists.

- **The GitHub Task issue is the source of truth** for scope, acceptance criteria, and verification.
- **This brief is task-local only**: a compressed working handoff for the next execution pass (human or agent). It does not override the issue.
- **Compressed-handoff boundary**: capture deltas, concrete file scope, analog pointers, and task-specific decisions. Do **not** paste stable repo rules or full issue bodies here—**reference** canonical docs instead (`AGENTS.md`, `ISSUES_WORKFLOW.md`, `WORKFLOW.md`, `docs/template/KICKOFF.md`).

## Task

- Task issue: `#<task-id>`
- Task title: `<copy issue title>`
- Source of truth link: `<GitHub issue URL>`

## Goal

`<What this task should accomplish in 1-3 sentences.>`

## Non-goals

- `<Explicitly out-of-scope behavior or files>`
- `<Anything this brief should not silently expand into>`

## Files In Scope

- `<path>` — `<why this file matters>`
- `<path>` — `<why this file matters>`

## Analog Files / Docs

- `<path>` — `<how this analog applies>`
- `<path>` — `<which contract or pattern to follow>`

Downstream repos: replace placeholders with real paths after adoption; see `docs/analogs/*` for reusable shapes.

## Locked Decisions

- `<Decision that should not be reopened during implementation>`
- `<Decision or constraint inherited from the issue/spec>`

## Acceptance Criteria Delta

- Issue acceptance criteria live in the Task. Only list task-specific **deltas**, clarifications, or parity checks here.
- `<Delta or added assertion>`
- `<Delta or added assertion>`

## Verification

- `<exact command>`
- `<exact command>`
- `<manual check if needed>`

## Open Product Decisions / Blockers

- `<Decision the implementation should not silently lock in>`
- `<Missing dependency, approval, or runtime detail>`

## Do Not Include

- Large pasted excerpts from `AGENTS.md`, `ISSUES_WORKFLOW.md`, `WORKFLOW.md`, or `docs/template/KICKOFF.md`
- Full control-plane essays unless this task introduces a **task-specific** exception (then state the exception briefly and link the canonical rule)
- Long pasted acceptance-criteria lists or full issue bodies; link the issue and capture **delta** only
- Reviewer prompt, PR boilerplate, or learning handoff text unless this task is explicitly changing that workflow
- Broad repo summaries unrelated to the files and behavior in scope

## Example (Sanitized, Non-Authoritative)

Use this only as a **shape** reference. Do not treat it as issue truth.

- Task issue: `#123`
- Task title: `Task: Add optional CC on transactional send`
- Source of truth link: `https://github.com/example-org/example-repo/issues/123`

### Goal

Allow an optional CC list on a user-triggered transactional send without changing the primary recipient contract or the mail provider integration.

### Non-goals

- No provider swap
- No changes to unrelated document types or surfaces

### Files In Scope

- `backend/app/features/<feature>/email_service.py` — extend orchestration and validation
- `frontend/src/features/<feature>/components/SendPanel.tsx` — pass CC from the confirm/send flow

### Analog Files / Docs

- `docs/analogs/transactional-email-flow.md` — ordering, idempotency, and error semantics
- `docs/ARCHITECTURE.md` — keep API and error shapes aligned with documented contracts

### Locked Decisions

- Maximum 5 CC addresses
- Empty CC is omitted from the payload
- No provider or env configuration change in this Task

### Acceptance Criteria Delta

- Preserve existing primary-recipient behavior
- Invalid CC addresses return the documented validation error

### Verification

- `make backend-verify` (or project equivalent)
- `make frontend-verify` (or project equivalent)

### Open Product Decisions / Blockers

- None
