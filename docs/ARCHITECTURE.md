# Architecture — {{PROJECT_NAME}}

## Overview

Describe what `{{PROJECT_NAME}}` does and who it serves.

## Stack

- `{{STACK_SUMMARY}}`

## Recommended Repo Structure (Greenfield)

Use this as the default structure for new repos:

```text
{{PROJECT_NAME}}/
  AGENTS.md
  WORKFLOW.md
  ISSUES_WORKFLOW.md
  GREENFIELD_BLUEPRINT.md
  docs/
    ARCHITECTURE.md
    PATTERNS.md
    REVIEW_CHECKLIST.md
    adr/
  plans/
  backend/
    app/
      api/
      features/
      integrations/
      shared/
    tests/
  frontend/
    src/
      app/
      features/
      shared/
    tests/
```

## Backend Boundary Model

- `api -> services -> repositories -> integrations/libs`
- no reverse imports
- no cross-layer shortcuts

## Frontend Boundary Model

- route shells in `src/app`
- feature logic in `src/features/<feature>`
- shared utilities in `src/shared`
- avoid direct cross-feature internal imports

## Core Data Model

Document tables/entities and relationships.

## API / Interface Contracts

Document each endpoint/event/interface with request/response/error contracts.

## Key Decisions

Track architectural decisions with rationale and alternatives considered.

## Operational Notes

- Verification commands:

```bash
{{VERIFY_COMMANDS}}
```

- CI notes:
- `{{CI_LINKS_OR_NOTES}}`
