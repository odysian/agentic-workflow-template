# Verification Workflow — {{PROJECT_NAME}}

Use this document to pick the right verification tier for planning, implementation, and PR gating.

## Verification Tiers

- Tier 1: Targeted change checks (single module / narrow behavior)
- Tier 2: Surface checks (backend-only or frontend-only slice)
- Tier 3: Cross-layer checks for changed surfaces (default for most Task PRs)
- Tier 4: Full verification suite (release-level confidence or broad refactor)

Task issue templates and Execution Briefs should explicitly select the intended tier.

## Tier Selection Guidance

- Start with the lowest tier that proves changed behavior.
- Raise tiers when changes cross boundaries, touch contracts, or increase blast radius.
- If scope expands during implementation, update the selected tier and rerun appropriate checks.

## Canonical Commands

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

## Makefile Contract (When Present)

Prefer stable make targets when available:

- `make verify`
- `make frontend-verify`
- `make backend-verify`
- `make db-verify`
- `make template-verify`

Targets should be deterministic, non-interactive, and CI-aligned.

## Template Maintenance Gate

For template-only changes, the minimum gate is:

```bash
./scripts/template_preflight.sh
./scripts/check-unresolved-template-tokens.sh
```

## Verification Reporting

Report:

- chosen tier
- exact commands run
- pass/fail result
- any deferred verification with reason
