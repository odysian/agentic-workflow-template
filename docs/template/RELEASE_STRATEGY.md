# Release Strategy

## Current Release

- Current baseline tag: `v0.2.0`
- Scope: lean workflow defaults with explicit reviewer follow-up prompt contract and reduced review-process overhead.

## Release History (Short)

- `v0.1.0`: base workflow docs, issue templates, PR template, skills playbooks, migration guide.
- `v0.2.0`: lean implementation -> PR -> reviewer prompt flow, focused review constraints, and streamlined review reporting requirements.

## Ongoing Release Process

1. Open a Spec issue for meaningful template changes.
2. Split into Task issues and merge PRs that close Tasks.
3. Run template token guard: `./scripts/check-unresolved-template-tokens.sh`.
4. Update `docs/template/VERSION.md` based on semantic versioning.
5. Add short release notes in the Git tag annotation.
6. Create annotated tag:

```bash
git tag -a vX.Y.Z -m "template release vX.Y.Z"
```

7. Push commits and tags:

```bash
git push origin main
git push origin vX.Y.Z
```

## Downstream Consumption

In each project that uses this template, record the template version used at initialization (for example in `WORKFLOW_BASE_VERSION` or project docs).
