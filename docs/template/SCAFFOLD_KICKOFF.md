# Scaffold Kickoff Template

Use this prompt when scaffolding a brand-new repository.

```text
You are scaffolding a new greenfield repository for <project-name>.

This is a scaffolding-only session. Do not implement product logic, routes, components, or migrations.

Required reading before any file creation:
1. <project setup reference>.md
2. <vertical slice spec>.md

Scaffold source policy:
- Copy workflow/template files from the workflow template repo.
- Replace template placeholders with project context.
- Do not rewrite template workflow files from scratch.

Create project-specific scaffold files exactly per setup reference:
- runtime pins
- dependency manifests
- docker/system deps
- env examples
- docs stubs
- backend/frontend folder trees with stub files only

What NOT to do:
- no app logic
- no dependency installation
- no generated migrations
- no tests beyond stubs

Verification (must all pass before completion):
1. unresolved token check (for target repo policy)
2. banned dependency grep checks from setup doc
3. runtime pin checks (`.python-version`, `.nvmrc`)
4. required scaffold file existence checks

Report all verification results explicitly.
```
