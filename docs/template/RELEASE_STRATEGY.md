# Release Strategy

## Current Release

- Current baseline tag: `v0.5.0`
- Scope: workflow token optimization (Execution Brief, `docs/analogs/*`, brief-first execution, delta-only patch handoff, `docs/template/KICKOFF_SHORT.md`, reference-not-reprint alignment across control-plane docs).

## Release History (Short)

- `v0.1.0`: base workflow docs, issue templates, PR template, skills playbooks, migration guide.
- `v0.2.0`: lean implementation -> PR -> reviewer prompt flow, focused review constraints, and streamlined review reporting requirements.
- `v0.3.0`: scaffold hardening templates + template preflight + required GH helper scripts + standardized dated plans convention examples.
- `v0.4.0`: reviewer-owned in-chat learning handoff; planning `Why this approach`; conditional Behavior Matrix; selective test-first and DoR/DoD tightening; `tight boundaries, loose middle`; expanded reviewer parity/CI guidance; `.github/copilot-instructions.md`.
- `v0.5.0`: Execution Brief template; generic analog docs; brief-first execution + delta-only patching in `docs/template/KICKOFF.md`; operator shortcuts; optional plans workstream subfolder hint; skills path alignment to dated `plans/`.

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
