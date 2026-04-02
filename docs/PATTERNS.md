# Patterns — {{PROJECT_NAME}}

Record conventions that already exist in code.

## Greenfield Structure Defaults

Use `GREENFIELD_BLUEPRINT.md` for new repos.

- Backend default: `backend/app/features/<feature>/...`
- Frontend default: `frontend/src/features/<feature>/...` plus `src/shared/...`
- For existing repos, preserve current layout unless migration is explicitly scoped.

## Backend Layering

### Dependency Direction

- Allowed: `api -> services -> repositories -> integrations/libs`
- Disallowed: reverse imports and cross-layer shortcuts.

### Route/Controller Pattern

- Keep route files thin: request parsing, DI, response mapping, decorators.
- One service entrypoint per route handler where possible.
- No direct persistence primitives in route modules.

### Service Pattern

- Services own orchestration, policy checks, and transaction boundaries.
- Public services must add value (no pass-through wrappers).
- Services can call repositories and integrations.

### Repository Pattern

- Repositories own query/persistence primitives only.
- No transport-layer exceptions.
- No calls to external integrations.

## Refactor Parity Lock Pattern

For no-contract refactors, keep behavior stable and verify:

1. status code parity
2. response schema parity
3. error semantics parity
4. side-effect parity

## Frontend Layering

### Feature-First Boundaries

- Feature internals stay private.
- Cross-feature usage should happen through feature public exports.
- Route shells compose feature modules; heavy logic should live in feature hooks/services.

### Transport And Service Pattern

- UI components/hooks call domain services, not raw `fetch` directly.
- Shared request concerns (auth/CSRF/retry) live in one transport helper module.
- Keep compatibility facades explicit and temporary when migrating old callers.

### Streaming Pattern

- Event-stream parsers should be chunk-safe.
- Normalize line endings after complete frame buffering, not per raw chunk.
- Treat `done` and `error` as terminal stream states and prevent duplicate terminal handling.

## File-Size Budgets

- Frontend leaf components: target `<=250` LOC.
- Frontend hooks/services: target `<=180` LOC.
- Backend route/service/repository modules: target `<=220` LOC.
- If modules exceed defined split thresholds, split or create a linked follow-up Task.

## Code Documentation And Commenting Contract

Follow `docs/CODE_COMMENTING_CONTRACT.md` for comment/docstring requirements.

Default baseline:

- Complex touched files (`>300` LOC or non-obvious orchestration) include a short module context header.
- Touched public/exported side-effecting behavior includes concise docstrings/JSDoc.
- Inline comments are used for non-obvious invariants/contracts only.
- Obvious narration comments are prohibited.

## Toolchain And Verify Reproducibility

- Pin runtime versions and keep them aligned across:
  - local setup docs
  - verify commands
  - CI configuration
- Verification should fail fast when runtime requirements are not met.

## Error Handling

Document standard error shapes and handling conventions.

## Naming

Document naming conventions used in this repository.

## Testing Patterns

Document test structure and fixture conventions.

- Keep unit tests close to feature/service boundaries.
- Include boundary guardrail tests for dependency-direction rules when possible.
- For refactors, include parity lock checks in test plans or acceptance checklists.

## Implementation Analogs (Reference)

- `docs/analogs/*` holds **narrow, reusable implementation shapes** (when to use, invariants, allowed deltas, checklists). They point at **example slots** or downstream-filled paths; they do not replace repo-wide conventions.
- Starting points: `docs/analogs/transactional-email-flow.md`, `docs/analogs/stateful-action-matrix.md`.
- Keep **this file conventions-first**. Add new analogs only when a shape is repeated in code and worth reusing across Tasks.

## Verification Reference

```bash
{{VERIFY_COMMANDS}}
```
