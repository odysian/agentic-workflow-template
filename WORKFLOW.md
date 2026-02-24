# WORKFLOW.md — {{PROJECT_NAME}}

## Project Context

- **Project:** `{{PROJECT_NAME}}`
- **Stack:** `{{STACK_SUMMARY}}`
- **Repo layout:** `{{REPO_STRUCTURE_OVERVIEW}}`

## Development Loop

Every feature follows:

1. Whiteboard
2. Document
3. Implement
4. Finalize

## Issues Workflow (Control Plane)

Read `ISSUES_WORKFLOW.md` before implementation.

Core rule:

- GitHub issues are the execution source of truth.
- Choose execution mode: `single` (default), `gated` (Spec + Tasks), or `fast` (tiny low-risk fixes).
- Default sizing is 1 feature -> 1 Task -> 1 PR unless split criteria apply.
- PRs close Tasks.
- Specs close only when all child Tasks are done or deferred.
- For `single` and `gated` modes, create a dedicated Task branch before implementation.
- Backend-coupled work must have Decision Locks checked before implementation.
- After major refactors, open one docs-only Task for readability hardening (comments + `docs/PATTERNS.md` updates), with no behavior changes.

Definition of Ready and Definition of Done are defined in `ISSUES_WORKFLOW.md` and are mandatory gates.

## Planning and Scope

- One issue at a time.
- Default to one end-to-end Task per feature.
- Split Tasks only when `ISSUES_WORKFLOW.md` split criteria apply.
- Keep changes surgical.

## Decision Brief Requirement

For each non-trivial change, include a short decision brief:

- chosen approach
- one alternative considered
- tradeoff behind the choice (complexity/risk/perf/security)
- revisit trigger for when the alternative becomes preferable

For quick-fix fast-lane work, a one-line brief is sufficient.

## Verification

Run the relevant checks before claiming completion.

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

## Documentation

Update docs when behavior/contracts/patterns change.

Docs paths:

- `{{DOCS_PATHS}}`

## CI

- `{{CI_LINKS_OR_NOTES}}`

## Optional Later

MCP is optional and not part of v1. Introduce it only when you need automation for issue operations or CI summaries.
