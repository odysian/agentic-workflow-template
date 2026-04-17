# Migration Guide

This guide covers both new-project bootstrap and adoption in existing repositories.

## What This Template Provides

- Agent operating rules (`AGENTS.md`)
- Workflow/control-plane docs under `docs/`
- Canonical kickoff/review prompts (`docs/template/KICKOFF.md`)
- Robust reviewer prompt body (`.github/prompts/review-task.prompt.md`)
- Planning templates in `docs/template/`
- Documentation skeletons (`docs/ARCHITECTURE.md`, `docs/PATTERNS.md`, `docs/REVIEW_CHECKLIST.md`)
- GitHub issue/PR templates (`.github/`)
- Workflow helper scripts (`scripts/`)
- Template integrity checks (`scripts/template_preflight.sh`, `scripts/check-unresolved-template-tokens.sh`)
- Portable playbooks in `skills/`

## Upgrading From <= 0.7.x

Version `0.8.0` adds optional repo-local planning and review playbooks.

### New files: `skills/domain-pass.md`, `skills/grill-plan.md`, `skills/design-interface.md`, `skills/architecture-audit.md`, `skills/tdd-boundaries.md`

- These are advisory manual-load helpers, not automatic runtime requirements.
- Downstream repos can keep, trim, or adapt them to local conventions.
- The `CONTEXT.md`-aware playbooks (`domain-pass.md`, `grill-plan.md`) assume the 0.7.0 workflow/domain-model upgrade has already been adopted.
- No new mandatory workflow steps are introduced.

### Required downstream actions

Re-run template checks:

```bash
./scripts/template_preflight.sh
```

## Upgrading From <= 0.6.x

Version `0.7.0` adds domain language governance and updates the approval learning handoff.

### New file: `CONTEXT.md`

- A root `CONTEXT.md` scaffold is now part of the template.
- Copy it into downstream repos or create it from scratch using the template shape.
- Seed it only with real project terms; do not fill it with generic implementation nouns (`repository`, `controller`, `hook`, `migration`).
- Update it inline during planning whenever a Domain Pass resolves a term.

### Domain Pass planning checkpoint

- Domain Pass is a conditional step before issue creation, not a mandatory gate for every task.
- Required when a feature introduces new product language, changes lifecycle/state meaning, or crosses domain boundaries.
- Skipped for bug fixes with stable terminology, style changes, dependency updates, and low-risk `fast` work.
- Decision Locks should use canonical terms from `CONTEXT.md`. ADRs remain optional and rare.

### Updated `APPROVED` reviewer learning handoff

Future `APPROVED` review responses use the new five-bullet concept-primer handoff from `docs/template/KICKOFF.md` section 4. The old `Code pointers:` block is no longer required. This is a format change only; the `APPROVED` / `ACTIONABLE` verdict contract is unchanged.

### Required downstream actions

1. Add `CONTEXT.md` to root (copy template scaffold or create from scratch).
2. Re-run template checks:

```bash
./scripts/template_preflight.sh
./scripts/check-unresolved-template-tokens.sh
```

3. Update planning habits so terminology-heavy work runs a Domain Pass before issue creation.
4. Expect future `APPROVED` review responses to start with `Concept primer` instead of `Code pointers`.

## Upgrading From <= 0.5.x

Version `0.6.0` introduces a breaking docs-topology and bootstrap update.

### Path moves

| Old path (<= 0.5.x) | New path (0.6.0+) |
| --- | --- |
| `ISSUES_WORKFLOW.md` | `docs/ISSUES_WORKFLOW.md` |
| `WORKFLOW.md` | `docs/WORKFLOW.md` |
| `GREENFIELD_BLUEPRINT.md` | `docs/GREENFIELD_BLUEPRINT.md` |

### Required downstream actions

1. Update links/bookmarks/notes/CI references to the new `docs/` paths.
2. Update any local automation or scripts that hardcode old root paths.
3. Re-run scaffold alignment if you maintain a generator or template copier.
4. Re-run template checks:

```bash
./scripts/template_preflight.sh
./scripts/check-unresolved-template-tokens.sh
```

### Startup contract change

- `AGENTS.md` is now mode-routed instead of fixed universal read order.
- `CLAUDE.md` should include `@AGENTS.md` only; other docs should be plain conditional paths.

## Part 1: New Project Setup (Recommended)

1. Create a new repo from this template repository.
2. Run `./scripts/template_preflight.sh` and resolve missing assets.
3. Replace all token placeholders before implementation.
4. Create project planning docs from templates in `docs/template/`.
5. Confirm verification commands run locally.
6. Configure GitHub labels and board.
7. Record template baseline version and adoption date in repo docs.
8. Use planning artifact paths as `plans/YYYY-MM-DD/<type>-<slug>.md`.

## Part 2: Existing Project Adoption

1. Copy template files into the existing repo.
2. Merge with existing docs carefully; keep project-specific rules.
3. Reconcile contradictions first (verification commands, auth patterns, test plans).
4. Keep issue-backed execution control plane authoritative.
5. Roll out in two phases:
   - Phase A: docs/templates alignment only
   - Phase B: enforce Task -> PR execution flow in active work
6. Keep mode defaults strict: `single` by default; `gated`/`fast` only when explicitly requested.

## Definition Of Ready And Done

Use `docs/ISSUES_WORKFLOW.md` as the authoritative gate for DoR and DoD.

No backend-coupled implementation should begin until Decision Locks are checked.

## ADR Rule

Use Decision issues/checkboxes for short-term locking.
If a decision has lasting architecture/security/performance impact, create an ADR (`NNN-*.md`) and link it from the Task/Spec and PR.

## Suggested Release Discipline For This Template Repo

1. Tag versions (`v0.1.0`, `v0.2.0`, ...).
2. Keep release notes concise and dated.
3. In downstream repos, record the template version used at initialization.
