# Template Version

Current version: `0.6.0`

## Notes

- Use semantic versioning for template evolution.
- Tag releases as `vMAJOR.MINOR.PATCH`.

### `0.6.0` (2026-04-13)

- BREAKING: moved `ISSUES_WORKFLOW.md`, `WORKFLOW.md`, and `GREENFIELD_BLUEPRINT.md` under `docs/`.
- Added mode-routed root `AGENTS.md` bootstrap and subtree `backend/AGENTS.md` + `frontend/AGENTS.md` guidance.
- Split workflow guidance into `docs/workflow/IMPLEMENT.md`, `docs/workflow/REVIEW.md`, and `docs/workflow/VERIFY.md` with thin `docs/WORKFLOW.md` index.
- Added extracted robust reviewer prompt at `.github/prompts/review-task.prompt.md` and aligned kickoff/review assets.
- Added tiered verification defaults in Task template + Execution Brief and updated template scripts for new topology.

### `0.5.0`

- Workflow token optimization: Execution Brief template, `docs/analogs/*`, brief-first execution and delta-only patch handoff in `docs/template/KICKOFF.md`, operator shortcuts in `docs/template/KICKOFF_SHORT.md`, aligned control-plane docs.

## Change Types

- `MAJOR`: breaking template structure or workflow contract changes.
- `MINOR`: backward-compatible additions (new docs/templates/checklists).
- `PATCH`: backward-compatible clarifications/fixes.
