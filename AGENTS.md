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
10. `skills/prd-workflow-gh.md` (if present)

## Unit of Work Rule

- **Unit of work is a GitHub Issue.**
- Choose an execution mode from `ISSUES_WORKFLOW.md` before coding:
  - `single` (default): one feature -> one Task issue -> one PR
  - `gated`: PRD issue + child Task issue(s) for feature sets or higher-risk work
  - `fast`: quick-fix path for tiny low-risk changes (if project policy allows)
- Convert freeform requests into the selected issue mode before implementation.
- Work one Task issue at a time.
- PRs close Task issues (`Closes #123`), not PRDs.
- PRDs close only when all child Tasks are done or explicitly deferred.
- Detailed control-plane rules are canonical in `ISSUES_WORKFLOW.md`.
- For one-shot issue body + `gh` command generation, use `skills/prd-workflow-gh.md`.

## Agent Operating Loop

1. Whiteboard scope in `plans/*.md` or spec docs (scratch only).
2. Choose execution mode (`single` default, `gated`, or `fast`) and create required issue(s).
3. Restate goal and acceptance criteria.
4. Plan minimal files and scope.
5. Implement with tight, surgical changes.
6. Run verification commands.
7. Update tests/docs if required.
8. Open PR that closes the Task issue; close PRD after child Tasks are done/deferred.

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
