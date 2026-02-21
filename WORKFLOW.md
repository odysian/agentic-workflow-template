# WORKFLOW.md — {{PROJECT_NAME}}

## Project Context

- **Project:** `{{PROJECT_NAME}}`
- **Stack:** `{{STACK_SUMMARY}}`
- **Repo layout:** `{{REPO_STRUCTURE_OVERVIEW}}`

## Development Loop

Every feature follows:

1. Design
2. Test
3. Implement
4. Review
5. Document

## Issues Workflow (Control Plane)

Read `ISSUES_WORKFLOW.md` before implementation.

Core rule:

- PRDs create Tasks.
- PRs close Tasks.
- PRDs close only when all child Tasks are done.
- Quick-fix fast lane is allowed only when `ISSUES_WORKFLOW.md` criteria are met.

For backend-coupled/Phase 3 work, all Decision Locks must be checked before implementation starts.

Definition of Ready and Definition of Done are defined in `ISSUES_WORKFLOW.md` and are mandatory gates.

## Planning and Scope

- One issue at a time.
- Keep Tasks PR-sized (target 1-4 hours).
- If a Task is larger, split it before coding.
- Keep changes surgical.

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
