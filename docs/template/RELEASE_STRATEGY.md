# Release Strategy

## Current Release

- Current baseline tag: `v0.3.0`
- Scope: scaffold hardening templates (`PROJECT_SETUP`, `VERTICAL_SLICE_SPEC`, `SCAFFOLD_KICKOFF`), required GH helper scripts, and template preflight validation.

## Release History (Short)

- `v0.1.0`: base workflow docs, issue templates, PR template, skills playbooks, migration guide.
- `v0.2.0`: lean implementation -> PR -> reviewer prompt flow, focused review constraints, and streamlined review reporting requirements.
- `v0.3.0`: scaffold hardening templates + template preflight + required GH helper scripts + standardized dated plans convention examples.

## Ongoing Release Process

1. Open a Spec issue for meaningful template changes.
2. Split into Task issues and merge PRs that close Tasks.
3. Run template preflight: `./scripts/template_preflight.sh`.
4. Run token guard: `./scripts/check-unresolved-template-tokens.sh`.
5. Update `docs/template/VERSION.md` based on semantic versioning.
6. Add short release notes in the Git tag annotation.
7. Create annotated tag:

```bash
git tag -a vX.Y.Z -m "template release vX.Y.Z"
```

8. Push commits and tags:

```bash
git push origin main
git push origin vX.Y.Z
```

## Downstream Consumption

In each project that uses this template, record the template version used at initialization (for example in `AGENTS.md` / `WORKFLOW.md` / `MIGRATION_GUIDE.md`).
