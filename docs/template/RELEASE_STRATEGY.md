# Release Strategy

## Current Release

- Current baseline tag: `v0.7.0`
- Scope: root `CONTEXT.md` scaffold, conditional Domain Pass planning checkpoint, concept-primer approval learning handoff, plus the v0.6.0 mode-routed startup, docs topology, workflow split, extracted review prompt file, tiered verification artifacts, and script/path coherence updates.

## Release History (Short)

- `v0.1.0`: base workflow docs, issue templates, PR template, skills playbooks, migration guide.
- `v0.2.0`: lean implementation -> PR -> reviewer prompt flow, focused review constraints, streamlined review reporting.
- `v0.3.0`: scaffold hardening templates + template preflight + required GH helper scripts + standardized dated plans examples.
- `v0.4.0`: reviewer-owned in-chat learning handoff; planning "Why this approach"; conditional Behavior Matrix; selective test-first and DoR/DoD tightening.
- `v0.5.0`: Execution Brief template; generic analog docs; brief-first execution + delta-only patching in `docs/template/KICKOFF.md`; operator shortcuts.
- `v0.6.0`: BREAKING docs-path move + mode-routed startup + workflow split + extracted robust review prompt + tiered verification defaults.
- `v0.7.0`: root `CONTEXT.md` scaffold + conditional Domain Pass planning checkpoint + concept-primer approval learning handoff.

## Ongoing Release Process

1. Open a Spec issue for meaningful template changes.
2. Split into Task issues and merge PRs that close Tasks.
3. Run template preflight: `./scripts/template_preflight.sh`.
4. Run token guard: `./scripts/check-unresolved-template-tokens.sh`.
5. Update `docs/template/VERSION.md` based on semantic versioning.
6. Add concise dated release notes in tag annotation.
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

In each project that uses this template, record the baseline/adoption in repo docs (for example `AGENTS.md`, `docs/WORKFLOW.md`, or project migration notes).
