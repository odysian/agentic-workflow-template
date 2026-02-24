# Migration Guide

This guide explains how to use this template as the foundation for a new project and how to adopt it in an existing repo.

## What this template provides

- Agent operating rules (`AGENTS.md`)
- Core workflow (`WORKFLOW.md`)
- Issue-driven execution control plane (`ISSUES_WORKFLOW.md`)
- Documentation skeletons (`ARCHITECTURE.md`, `PATTERNS.md`, `REVIEW_CHECKLIST.md`)
- GitHub issue templates and PR template (`.github/`)
- Portable playbooks in `skills/`

## Part 1: New Project Setup (recommended)

1. Create a new repo from this template repository.
2. Replace all token placeholders before implementation:
- `{{PROJECT_NAME}}`
- `{{STACK_SUMMARY}}`
- `{{REPO_STRUCTURE_OVERVIEW}}`
- `{{VERIFY_COMMANDS}}`
- `{{FRONTEND_VERIFY_COMMANDS}}`
- `{{BACKEND_VERIFY_COMMANDS}}`
- `{{DB_VERIFY_COMMANDS}}`
- `{{DOCS_PATHS}}`
- `{{CI_LINKS_OR_NOTES}}`
3. Confirm verification commands run locally.
4. Configure GitHub labels and board.
5. Start with a Spec issue, then split into Task issues.

## Part 2: Existing Project Adoption

1. Copy the template files into the existing repo.
2. Merge carefully with existing docs (do not overwrite project-specific rules).
3. Reconcile contradictions first (verification commands, auth pattern statements, test plan claims).
4. Decide source of truth:
- GitHub Issues = execution control plane
- `TASKS.md` = optional scratchpad only
5. Roll out in two phases:
- Phase A: docs/templates only
- Phase B: enforce in active work (Specs -> Tasks -> PRs)

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
