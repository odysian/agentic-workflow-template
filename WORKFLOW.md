# WORKFLOW.md — {{PROJECT_NAME}}

## Project Context

- **Project:** `{{PROJECT_NAME}}`
- **Stack:** `{{STACK_SUMMARY}}`
- **Repo layout:** `{{REPO_STRUCTURE_OVERVIEW}}`

## Source Of Truth (By Rule Type)

- Execution control plane (modes, DoR/DoD, branching, issue lifecycle): `ISSUES_WORKFLOW.md` (authoritative)
- Kickoff prompts and reviewer output contract: `docs/template/KICKOFF.md` (authoritative)
- This file (`WORKFLOW.md`) summarizes the implementation loop and engineering defaults.

## Greenfield Baseline (Default)

For new repositories, use `GREENFIELD_BLUEPRINT.md` as the baseline.

Core defaults:

- Backend structure: feature-first modules with explicit layering `api -> services -> repositories -> integrations/libs`.
- Frontend structure: feature-first under `src/features/<feature>` with shared modules in `src/shared`.
- Route/page modules stay thin; orchestration belongs in services/hooks.
- No-contract refactors must pass the parity lock checklist.
- Runtime/toolchain contracts are explicit and pinned.

## Development Loop

Every feature follows:

1. Whiteboard
2. Document
3. Implement
4. Verify
5. Review handoff
6. Patch (if needed)
7. Finalize

## Operator Flow Optimization

Use this as the default human-in-the-loop sequence to reduce handoff overhead:

1. Plan scope and choose mode (`single` by default; `gated`/`fast` only when explicitly requested).
2. For issue-backed work (`single`/`gated`), run execution kickoff from `docs/template/KICKOFF.md` on the planned Task.
3. Open PR with `Closes #<task-id>`.
4. Run one reviewer pass using the standardized prompt from `docs/template/KICKOFF.md`.
5. If verdict is `ACTIONABLE`, patch in the implementation branch and rerun targeted verification only.
6. Merge PR and sync local branch.

## Issues Workflow (Control Plane)

Read `ISSUES_WORKFLOW.md` before implementation.

Core rule:

- GitHub issues are the execution source of truth.
- Choose execution mode: `single` by default; use `gated` or `fast` only when explicitly requested.
- Default sizing is 1 feature -> 1 Task -> 1 PR unless split criteria apply.
- PRs close Tasks.
- Specs close only when all child Tasks are done or deferred.
- For `single` and `gated` modes, create a dedicated Task branch before implementation.
- Backend-coupled work must have Decision Locks checked before implementation.
- After major refactors, open one docs-only Task for readability hardening (comments + `docs/PATTERNS.md` updates), with no behavior changes.

Definition of Ready and Definition of Done are defined in `ISSUES_WORKFLOW.md` and are mandatory gates.

## Canonical Kickoff Prompts

Use `docs/template/KICKOFF.md` for copy-paste kickoff prompts.

- Planning kickoff (feature -> issue planning only): no code changes, no PR.
- Execution kickoff (existing Task -> implement/verify/PR): run only when Task issue already exists.

## Boundary And Dependency Rules

- Allowed: `api -> services -> repositories -> integrations/libs`.
- Disallowed: reverse imports or cross-layer shortcuts.
- Public service functions must add value (orchestration, policy, validation, transactions), not argument pass-through.
- Repositories own persistence/query logic only and should not raise transport-layer errors.
- Enforce boundary direction with lightweight guardrail checks/tests where possible.

## Refactor Parity Lock (No Contract Change)

If a Task claims "no API/contract change", verify and report:

1. Status code parity (success + error paths).
2. Response schema parity (fields/types/envelope shape).
3. Error semantics parity (externally visible behavior).
4. Side-effect parity (DB writes, queue, storage, notifications).

## Lean Review Mode (Default)

After implementation and PR creation, run one focused reviewer follow-up pass:

- Reviewer scope: major correctness bugs, regressions, and missing tests/docs.
- Reviewer output: `APPROVED` or `ACTIONABLE`.
- If `ACTIONABLE`, patch findings and rerun only relevant verification.
- Default to one review pass; run a second pass only when explicitly requested.

Default reviewer constraints:

- use local branch diff/repo context first
- skip broad environment triage unless blocked
- do not create worktrees by default
- do not rerun full verification already reported green
- report findings first; no command-by-command transcript unless a command failed

## Canonical Reviewer Follow-Up Prompt

Use the robust standard prompt from `docs/template/KICKOFF.md` after opening a Task PR.
Do not redefine the format in this file; keep `docs/template/KICKOFF.md` as the single source of truth.

## Planning And Scope

- One issue at a time.
- Default to one end-to-end Task per feature.
- Keep changes surgical.
- Split Tasks only when `ISSUES_WORKFLOW.md` split criteria apply.

### Default Modularity

- Frontend greenfield default: `src/features/<feature>/*` plus `src/shared/*`.
- Backend greenfield default: `backend/app/features/<feature>/*` with explicit api/service/repository boundaries.
- For existing repos, preserve current structure unless a dedicated migration task scopes restructuring.

### Practical File-Size Budgets

- Frontend leaf components: target `<=250` LOC.
- Frontend single-purpose hooks/services: target `<=180` LOC.
- Backend route/service/repository modules: target `<=220` LOC.
- `300-400` LOC can be acceptable when cohesive; split or create linked follow-up when:
  - frontend component exceeds `450` LOC
  - frontend hook/service exceeds `300` LOC
  - backend route/service/repository exceeds `350` LOC

## Decision Brief Requirement

For non-trivial changes that modify behavior/contracts/architecture, include a short decision brief:

- chosen approach
- one alternative considered
- tradeoff behind the choice (complexity/risk/perf/security)
- revisit trigger for when the alternative becomes preferable

For small tasks with no contract/behavior change, decision brief is optional.

## Toolchain Contract (Mandatory)

- Pin runtime versions in-repo (for example `.nvmrc`, `.python-version`, or equivalent).
- Declare Node requirements in `package.json` `engines` when frontend tooling depends on specific Node versions.
- Keep README prerequisites, local verify commands, and CI runtime versions aligned.
- Verification should fail fast on version mismatch.

## Verification

Run the relevant checks before claiming completion.

### Makefile Verification Contract (Recommended)

If the repo uses `make` for verification, standardize on these targets:

- `make verify` (full verification aggregator)
- `make backend-verify` (backend lint/type-check/tests/security checks as applicable)
- `make frontend-verify` (frontend type-check/tests/lint/build as applicable)
- `make db-verify` (migrations/schema checks when applicable)
- `make template-verify` (template-level checks such as unresolved-token guard)

Contract rules:

- Targets must be deterministic, non-interactive, and fail-fast (non-zero exit on failure).
- CI should run the same `make` targets used locally.
- Keep target names and scope stable; if changed, update README + workflow docs in the same Task.

### Full Verification

```bash
{{VERIFY_COMMANDS}}
```

### Frontend Verification

```bash
{{FRONTEND_VERIFY_COMMANDS}}
```

### Backend Verification

```bash
{{BACKEND_VERIFY_COMMANDS}}
```

### Database Verification

```bash
{{DB_VERIFY_COMMANDS}}
```

### Verification Baseline Expectations

- Backend: boundary guardrail check + lint + type-check + tests + security scan.
- Frontend: type-check + tests + lint + production build.
- No-contract refactors: include parity lock results in final verification summary.
- Template maintenance: unresolved-token guard passes (`./scripts/check-unresolved-template-tokens.sh`).

## Documentation

Update docs only when behavior/contracts/patterns changed.

For in-code documentation and comment quality requirements, follow `docs/CODE_COMMENTING_CONTRACT.md`.

Docs paths:

- `{{DOCS_PATHS}}`

## CI

- `{{CI_LINKS_OR_NOTES}}`

## Documentation Layout Recommendation

For clean traversal, keep root docs minimal and move detailed docs under `docs/`:

- Root: `AGENTS.md`, `WORKFLOW.md`, `ISSUES_WORKFLOW.md`, `GREENFIELD_BLUEPRINT.md`.
- `docs/`: `ARCHITECTURE.md`, `PATTERNS.md`, `REVIEW_CHECKLIST.md`, ADRs, runbooks.
- `skills/`: procedural playbooks only.

## Optional Later

MCP is optional and not part of v1. Introduce it only when you need automation for issue operations or CI summaries.
