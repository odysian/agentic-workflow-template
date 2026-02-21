# AGENTS.md — {{PROJECT_NAME}}

## Start Here (Canonical Entrypoint)

`AGENTS.md` is the canonical entrypoint for agents and contributors in this repository.

Read in this order:
1. `AGENTS.md` (this file)
2. `WORKFLOW.md`
3. `ISSUES_WORKFLOW.md`
4. `ARCHITECTURE.md` (if present)
5. `PATTERNS.md` (if present)
6. `REVIEW_CHECKLIST.md` (if present)
7. `skills/write-prd.md` (if present)
8. `skills/prd-to-issues.md` (if present)
9. `skills/issue-to-pr.md` (if present)

## Unit of Work Rule

- **Unit of work is a GitHub Issue.**
- Convert freeform requests into (default path):
  - PRD issue (new features or multi-step work)
  - Task issue (PR-sized implementation work)
- Work one Task issue at a time.
- PRs close Task issues (`Closes #123`), not PRDs.
- PRDs close only when all child Tasks are done.
- Quick-fix fast lane is allowed for tiny low-risk changes; use the criteria in `ISSUES_WORKFLOW.md`.
- Detailed control-plane rules are canonical in `ISSUES_WORKFLOW.md`.

## Agent Operating Loop

1. Choose execution path: default issue flow or quick-fix fast lane.
2. Restate goal and acceptance criteria.
3. Plan minimal files and scope.
4. Implement with tight, surgical changes.
5. Run verification commands.
6. Update tests/docs if required.
7. If using issue flow, open PR that closes the Task issue.
8. Move status forward (Ready -> In Progress -> Review -> Done) when using issue flow.

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
