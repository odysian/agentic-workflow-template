# Frontend AGENTS

Downstream note: if your repo does not have a frontend surface, you can delete this file or keep it as scaffold guidance.

Apply this file only when touched scope includes `frontend/`.

## Boundaries

- Route/page modules should remain composition shells.
- Feature logic belongs in `src/features/<feature>`.
- Shared cross-feature primitives belong in `src/shared`.
- Avoid direct cross-feature internal imports.

## Frontend Safety Rules

- Preserve existing UX and API contracts unless explicitly scoped.
- Keep accessibility and error-state behavior intact.
- For stateful UI changes, document action availability across states.
- For no-contract refactors, report parity for visible state/shape/error/side-effects.

## Tests And Verification

- Add targeted tests for changed states and error paths when practical.
- Default to tiered verification from `docs/workflow/VERIFY.md`.

Examples:
- Tier 1: focused component/hook tests for touched files
- Tier 3: `{{FRONTEND_VERIFY_COMMANDS}}`
- Tier 4: `{{VERIFY_COMMANDS}}`

## References

- `docs/ISSUES_WORKFLOW.md`
- `docs/workflow/IMPLEMENT.md`
- `docs/workflow/VERIFY.md`
- `docs/template/KICKOFF.md`
