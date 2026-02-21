# {{PROJECT_NAME}} Template: Start Here

This folder is the project-agnostic baseline for an agentic workflow.

## 5-Minute Setup

1. Copy `template/base/` into a new repo root.
2. Replace all required tokens before any implementation work.
3. Confirm verify commands run locally and in CI.
4. Start work through GitHub Issues: PRD -> Task -> PR.

## Required Tokens

Replace these in the base files:

- `{{PROJECT_NAME}}`
- `{{STACK_SUMMARY}}`
- `{{REPO_STRUCTURE_OVERVIEW}}`
- `{{VERIFY_COMMANDS}}`
- `{{FRONTEND_VERIFY_COMMANDS}}`
- `{{BACKEND_VERIFY_COMMANDS}}`
- `{{DB_VERIFY_COMMANDS}}`
- `{{DOCS_PATHS}}`
- `{{CI_LINKS_OR_NOTES}}`

## Workflow Source of Truth

- Execution control plane: `ISSUES_WORKFLOW.md`
- Engineering workflow: `WORKFLOW.md`
- Agent constraints: `AGENTS.md`

`TASKS.md` (if present) is a local scratchpad only.

## Optional Later

MCP is intentionally out of scope for v1. Add it later only to automate issue creation/labeling/CI summaries.

## CI Notes

- `{{CI_LINKS_OR_NOTES}}`
