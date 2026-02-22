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
- Choose execution mode: `single` (default), `gated` (PRD + Tasks), or `fast` (tiny low-risk fixes).
- Default sizing is 1 feature -> 1 Task -> 1 PR unless split criteria apply.
- PRs close Tasks.
- PRDs close only when all child Tasks are done or deferred.
- Backend-coupled work must have Decision Locks checked before implementation.

Definition of Ready and Definition of Done are defined in `ISSUES_WORKFLOW.md` and are mandatory gates.

## Planning and Scope

- One issue at a time.
- Default to one end-to-end Task per feature.
- Split Tasks only when `ISSUES_WORKFLOW.md` split criteria apply.
- Keep changes surgical.

## Mentorship Output Requirement

Agents must explain reasoning, not only output code. For each non-trivial change, include:

- system design context (where the change fits)
- pattern choice rationale (why this pattern over others)
- security and performance best-practice considerations
- tradeoffs and at least one alternative considered

For tiny quick fixes, a short explanation is sufficient, but this requirement still applies.

## Learning Acceleration Checkpoints

To maximize learning speed while using AI assistance, apply these checkpoints:

1. Predict before implementation: write a short plan (files, data flow, risk).
2. Choose deliberately: when multiple approaches exist, compare 2-3 and record the chosen one.
3. Explain-back before completion: summarize design fit, pattern rationale, security/performance baseline, and tradeoffs.
4. Do one manual rep per feature: implement one small unit manually (test/query/handler/hook/component logic).
5. Log the lesson: add a short note on reusable pattern + what to improve next iteration.

For quick-fix fast-lane work, use a lightweight version of checkpoints 1-3 plus a one-line lesson note.

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
