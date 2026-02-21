# AGENTS.md — {{PROJECT_NAME}}

## Project Context

- **Project:** `{{PROJECT_NAME}}`
- **Stack:** `{{STACK_SUMMARY}}`
- **Repo layout:** `{{REPO_STRUCTURE_OVERVIEW}}`

## Operating Rules

- Keep solutions simple and explicit.
- Make surgical changes only.
- Match existing style and conventions.
- Do not install dependencies without approval.
- Do not change unrelated files.
- Do not modify applied migrations; create a new migration.

## Unit of Work

When working agentically, the GitHub issue is the unit of work.

- Follow issue templates.
- Keep one issue per PR.
- Keep scope tight.
- `TASKS.md` (if present) is scratchpad only and not source of truth.

## Workflow Order

1. Read `WORKFLOW.md`
2. Read `ISSUES_WORKFLOW.md`
3. Read project docs in `{{DOCS_PATHS}}`
4. Execute one ready Task issue

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

## Documentation Discipline

Treat doc updates like failing tests. Keep architecture, patterns, checklists, and ADRs current.

## Skills Note

`skills/*.md` are portable procedural playbooks unless your runtime explicitly loads them.

## Optional Later

MCP is out of scope for v1. It can be added later to automate issue creation/labeling/CI summaries.
