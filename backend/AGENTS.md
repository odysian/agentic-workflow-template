# Backend AGENTS

Downstream note: if your repo does not have a backend surface, you can delete this file or keep it as scaffold guidance.

Apply this file only when touched scope includes `backend/`.

## Boundaries

- Allowed direction: `api -> services -> repositories -> integrations/libs`.
- Keep route modules thin.
- Keep service modules orchestration-first.
- Keep repositories persistence/query-only.

## Backend Safety Rules

- Preserve transport contracts unless explicitly scoped.
- Do not modify applied migrations; create new migration files.
- For no-contract refactors, report parity for status/shape/error/side-effects.
- For stateful or side-effecting changes, include/refresh a Behavior Matrix.

## Tests And Verification

- Add targeted assertions for changed behavior when practical.
- Default to tiered verification from `docs/workflow/VERIFY.md`.

Examples:
- Tier 1: focused unit tests/lint for touched backend module
- Tier 3: `{{BACKEND_VERIFY_COMMANDS}}`
- Tier 4: `{{VERIFY_COMMANDS}}`

## References

- `docs/ISSUES_WORKFLOW.md`
- `docs/workflow/IMPLEMENT.md`
- `docs/workflow/VERIFY.md`
- `docs/template/KICKOFF.md`
