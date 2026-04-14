# {{PROJECT_NAME}} Template: Start Here

This folder is the project-agnostic baseline for an agentic workflow.

## 5-Minute Setup

1. Create a new repo from this template (or copy template root docs/folders into your repo).
2. Run template preflight and fix missing assets: `./scripts/template_preflight.sh`.
3. Replace all required tokens before implementation.
4. Create project planning docs from templates:
   - `docs/template/PROJECT_SETUP.md`
   - `docs/template/VERTICAL_SLICE_SPEC.md`
   - `docs/template/SCAFFOLD_KICKOFF.md`
5. Pin runtime/toolchain versions and align local + CI commands.
6. Confirm verification commands run locally.
7. Start work through GitHub Issues by default (`single` mode: Task -> PR).

## Required Tokens

Replace these in base files:

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

## Workflow Metadata (Recommended)

In downstream repos, record:
- template baseline version used at initialization
- adoption date (`YYYY-MM-DD`)

## Workflow Source Of Truth

- Onboarding and mode routing: `AGENTS.md`
- Execution control plane: `docs/ISSUES_WORKFLOW.md`
- Kickoff/reviewer prompt contract: `docs/template/KICKOFF.md`
- Workflow index: `docs/WORKFLOW.md`
- Implementation defaults: `docs/workflow/IMPLEMENT.md`
- Review defaults: `docs/workflow/REVIEW.md`
- Verification tiers: `docs/workflow/VERIFY.md`
- Greenfield baseline: `docs/GREENFIELD_BLUEPRINT.md`

Default behavior is mode-routed startup via `AGENTS.md`; avoid universal preloading of all workflow docs.

## Template Verification

```bash
./scripts/template_preflight.sh
./scripts/check-unresolved-template-tokens.sh
```

## Optional Later

MCP is intentionally out of scope for v1. Add it later only for issue/CI automation.

## CI Notes

- `{{CI_LINKS_OR_NOTES}}`
