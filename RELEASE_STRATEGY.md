# Release Strategy

## First Release

- Initial baseline tag: `v0.1.0`
- Scope: base workflow docs, issue templates, PR template, skills playbooks, migration guide.

## Ongoing Release Process

1. Open a PRD issue for meaningful template changes.
2. Split into Task issues and merge PRs that close Tasks.
3. Update `VERSION.md` based on semantic versioning.
4. Add short release notes in the Git tag annotation.
5. Create annotated tag:

```bash
git tag -a vX.Y.Z -m "template release vX.Y.Z"
```

6. Push commits and tags:

```bash
git push origin main
git push origin vX.Y.Z
```

## Downstream Consumption

In each project that uses this template, record the template version used at initialization (for example in `WORKFLOW_BASE_VERSION` or project docs).
