# {{PROJECT_NAME}} Template: Start Here

This folder is the project-agnostic baseline for an agentic workflow.

## 5-Minute Setup

1. Create a new repo from this template (or copy template root docs/folders into your repo).
2. Run template preflight in the new repo and fix missing assets: `./scripts/template_preflight.sh`.
3. Replace all required tokens before any implementation work.
4. Create project planning docs from templates:
   - `docs/template/PROJECT_SETUP.md`
   - `docs/template/VERTICAL_SLICE_SPEC.md`
   - `docs/template/SCAFFOLD_KICKOFF.md`
5. Pin runtime/toolchain versions (for example Node/Python) and align local + CI.
6. Confirm verify commands run locally and in CI.
7. Start work through GitHub Issues by default: `Task -> PR`; use `Spec -> Task -> PR` only when scope/risk requires it. Use `fast` mode only when explicitly requested and criteria are met.

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

## Planning Artifact Convention

All new planning files should use:
- `plans/YYYY-MM-DD/<type>-<slug>.md`

Examples:
- `plans/2026-03-18/spec-auth-flow.md`
- `plans/2026-03-18/task-auth-refresh-01.md`

## Workflow Metadata (Recommended)

In downstream repos, record:
- template baseline version used at initialization
- adoption date (`YYYY-MM-DD`)

Suggested locations:
- `AGENTS.md`
- `WORKFLOW.md`
- `ISSUES_WORKFLOW.md`
- `MIGRATION_GUIDE.md`

## Makefile Verify Contract (Recommended)

If your repo uses `make` as the verification entrypoint, define:

- `make verify`
- `make backend-verify`
- `make frontend-verify`
- `make db-verify` (if applicable)
- `make template-verify` (for template checks, for example unresolved-token guard)

Keep these targets deterministic, non-interactive, and CI-aligned with local usage.

## Workflow Source of Truth

- Execution control plane: `ISSUES_WORKFLOW.md`
- Kickoff/reviewer prompt contract: `docs/template/KICKOFF.md`
- Engineering workflow summary: `WORKFLOW.md`
- Agent constraints/onboarding: `AGENTS.md`
- Greenfield baseline: `GREENFIELD_BLUEPRINT.md`

Default must-read order for agents:
1. `AGENTS.md`
2. `ISSUES_WORKFLOW.md`
3. `docs/template/KICKOFF.md`
4. `WORKFLOW.md`

`TASKS.md` (if present) is a local scratchpad only.

## Optional Later

MCP is intentionally out of scope for v1. Add it later only to automate issue creation/labeling/CI summaries.

## CI Notes

- `{{CI_LINKS_OR_NOTES}}`
