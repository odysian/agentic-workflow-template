# Migration Guide

This guide explains how to use this template as the foundation for a new project and how to adopt it in an existing repo.

## What this template provides

- Agent operating rules (`AGENTS.md`)
- Core workflow (`WORKFLOW.md`)
- Issue-driven execution control plane (`ISSUES_WORKFLOW.md`)
- Canonical kickoff/review prompts (`docs/template/KICKOFF.md`)
- Planning templates:
  - `docs/template/PROJECT_SETUP.md`
  - `docs/template/VERTICAL_SLICE_SPEC.md`
  - `docs/template/SCAFFOLD_KICKOFF.md`
- Documentation skeletons (`docs/ARCHITECTURE.md`, `docs/PATTERNS.md`, `docs/REVIEW_CHECKLIST.md`)
- GitHub issue templates and PR template (`.github/`)
- Workflow helper scripts (`scripts/gh_preflight.sh`, `scripts/create_pr.sh`)
- Template integrity checks (`scripts/template_preflight.sh`, `scripts/check-unresolved-template-tokens.sh`)
- Portable playbooks in `skills/`

## Part 1: New Project Setup (recommended)

1. Create a new repo from this template repository.
2. Run `./scripts/template_preflight.sh` and resolve any missing assets.
3. Replace all token placeholders before implementation: `{{PROJECT_NAME}}`, `{{STACK_SUMMARY}}`, `{{REPO_STRUCTURE_OVERVIEW}}`, `{{VERIFY_COMMANDS}}`, `{{FRONTEND_VERIFY_COMMANDS}}`, `{{BACKEND_VERIFY_COMMANDS}}`, `{{DB_VERIFY_COMMANDS}}`, `{{DOCS_PATHS}}`, `{{CI_LINKS_OR_NOTES}}`.
4. Create project-specific planning docs from templates:
   - `PROJECT_SETUP.md` (stack/runtime/dependencies/env/contracts)
   - `VERTICAL_SLICE_SPEC.md` (narrow validation scope)
   - `SCAFFOLD_KICKOFF.md` (scaffolding-only execution constraints)
5. Confirm verification commands run locally.
6. Configure GitHub labels and board.
7. Record template baseline version and adoption date in repo docs.
8. Use planning artifact paths as `plans/YYYY-MM-DD/<type>-<slug>.md`.
9. Start with a Task issue by default (`single` mode); use Spec + Tasks only when scope/risk requires `gated` mode.

## Part 2: Existing Project Adoption

1. Copy template files into the existing repo.
2. Merge carefully with existing docs (do not overwrite project-specific rules).
3. Reconcile contradictions first (verification commands, auth pattern statements, test plan claims).
4. Decide source of truth: for issue-backed work (`single`/`gated`), GitHub Issues = execution control plane, `TASKS.md` = optional scratchpad only.
5. Roll out in two phases: Phase A = docs/templates only, Phase B = enforce in active work (`Task -> PR` by default; `Spec -> Task -> PR` when needed).
6. Keep execution mode defaults strict: default to `single`; use `gated`/`fast` only when explicitly requested.
7. Keep ceremony conditional: second review pass only when explicitly requested; decision briefs and doc updates only when behavior/contracts/architecture changed.

Recommended onboarding order for agents:
1. `AGENTS.md`
2. `ISSUES_WORKFLOW.md`
3. `docs/template/KICKOFF.md`
4. `WORKFLOW.md`

Kickoff split:
- Planning kickoff (`feature -> issue artifacts`) is planning-only: no code changes, no PR.
- Execution kickoff (`existing Task -> implementation`) performs branch/implement/verify/PR flow.

## Definition of Ready and Done

Use `ISSUES_WORKFLOW.md` as the authoritative gate for:

- Definition of Ready (DoR)
- Definition of Done (DoD)

No implementation should begin for backend-coupled work until Decision Locks are checked.

## ADR Rule

Use Decision issues/checkboxes for short-term locking.
If a decision has lasting architecture/security/performance impact, create an ADR (`NNN-*.md`) and link it from the Spec and PR.

## Optional Later: MCP

MCP is intentionally out of scope for v1.
Add MCP later only if you want automation for issue creation/labeling/CI summaries.

## Suggested Release Discipline for this template repo

1. Tag versions (`v0.1.0`, `v0.2.0`, ...).
2. Keep a short changelog or release notes.
3. In downstream repos, record which template version they started from.
