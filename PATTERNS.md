# Patterns — {{PROJECT_NAME}}

Record conventions that already exist in code.

## Error Handling

Document standard error shapes and handling conventions.

## API / Service Layer

Document calling patterns, retries, timeouts, and auth conventions.

## Data Access

Document query and transaction patterns.

## Frontend/UI Patterns

- Default for new frontend projects: feature-first structure: `src/features/<feature>/{components,hooks,services,types,tests}` plus `src/shared/{components,hooks,lib,types}`.
- Keep feature boundaries explicit: avoid importing another feature's internals directly; use public exports.
- For existing repos, preserve current structure unless a dedicated migration task scopes restructuring.
- Practical file-size budgets: target `<=250` LOC for leaf components and `<=180` LOC for single-purpose hooks/services; `300-400` LOC can be acceptable when cohesive; split or add linked follow-up when a component exceeds `450` LOC or a hook/service exceeds `300` LOC.
- Keep components focused: avoid mixing heavy rendering, data orchestration, and transport/service concerns in one file.

## Naming

Document naming conventions used in this repository.

## Testing Patterns

Document test structure and fixture conventions.

## Verification Reference

```bash
{{VERIFY_COMMANDS}}
```
