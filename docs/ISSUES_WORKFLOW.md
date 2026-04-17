# Issues Workflow

This repository uses GitHub issues as the execution control plane.

Downstream repos should record template baseline version and adoption date in repo docs (for example `AGENTS.md` or `docs/template/MIGRATION_GUIDE.md`).

## Workflow Loop

1. Whiteboard feature ideas in `plans/YYYY-MM-DD/*.md` or spec docs (scratch planning). Optional: co-locate multiple related drafts under `plans/YYYY-MM-DD/<workstream-slug>/` when one planning pass produces several files (see `AGENTS.md` Agent Operating Loop).
2. Document work as issues using one of the execution modes below.
3. Implement and close Task issues via PRs (`Closes #...`).
4. Finalize by updating docs only when behavior/contracts changed and close related Spec/tracker issues.

## Objects

- **Task** (`type:task`): PR-sized implementation unit and default feature issue.
- **Spec** (`type:spec`): feature-set/spec umbrella with decision locks and child Task links.
- **Decision** (`type:decision`): short-term decision lock with rationale.

## Control Plane Rules

1. For issue-backed work (`single`/`gated`), GitHub Issues are the source of truth for execution. `TASKS.md` (if present) is scratchpad only.
2. The default execution path is **1 feature -> 1 Task -> 1 PR**.
3. PRs close Task issues (`Closes #...`), not Specs.
4. Specs close only when all child Tasks are done or explicitly deferred.
5. Tasks are PR-sized; in this workflow PR-sized usually means end-to-end feature delivery.
6. Backend-coupled work requires Decision Locks checked before implementation begins.
7. After major refactors, open one docs-only Task for readability hardening (comments + `docs/PATTERNS.md` updates), with no behavior changes.
8. For `single` and `gated` modes, create a dedicated branch for the Task issue before implementation (for example: `task-123-short-name`).
9. After Task PR creation, run a lean reviewer follow-up pass and return `APPROVED` or `ACTIONABLE`.
10. If scope is a no-contract refactor, include a parity lock checklist in the Task acceptance criteria.
11. For greenfield repos, align issue scope with `docs/GREENFIELD_BLUEPRINT.md` boundaries and structure defaults.

**Guiding principle — tight boundaries, loose middle:** be strict about scope, contracts, acceptance criteria, verification, and layer boundaries. Be flexible about internal decomposition and helper structure as long as the implementation stays readable, testable, and consistent with repo patterns.

## Execution Modes (Choose Before Opening Issues)

Use `single` by default. Use `gated` or `fast` only when explicitly requested.

### `single` (Default)

Use one Task issue per feature, then one PR that closes it.

- Best for most feature work.
- Task includes mini-spec content: summary/scope/acceptance criteria/verification.
- Decision Locks live in the Task for backend-coupled work.

### `gated` (Spec + Tasks)

Use one Spec issue plus child Task issue(s).

- Use when working a feature set or higher-risk work.
- Decision Locks live in the Spec.
- Child Tasks should stay PR-sized (default one Task per feature).

### `fast` (Quick Fix)

For low-risk maintenance, a direct quick-fix path can be allowed (if project policy allows) without mandatory issue creation when all are true:

- the change is a single logical fix
- no schema/API/realtime contract change
- no auth/security model change
- no migration/dependency changes
- no ADR-worthy architecture decision

When using Fast Lane:

- run relevant verification
- use a clear quick-fix commit message
- follow the repo's branch/merge policy
- if scope grows, switch to `single` or `gated`

## When To Split Into Multiple Tasks

Split only when it clearly improves delivery or risk control:

- change is too large for one PR (guideline: ~600+ LOC or hard to review)
- backend contract should land before frontend integration
- migrations or realtime contract changes increase risk
- parallel work or staged rollout is needed
- a module exceeds file-size thresholds and needs intentional extraction

## When Domain Pass Is Required

Run a **Domain Pass** before drafting issues when any of the following are true:

- the feature introduces a new core noun or user-facing concept
- a term is overloaded or conflicts with existing project language
- the feature changes lifecycle or state meaning
- the feature crosses backend/frontend/provider boundaries and needs shared language
- the feature creates or renames a major workflow, role, entity, or status
- the feature is `gated`, high-risk, or likely to generate several Task issues

Skip it for:

- isolated bug fixes with stable terminology
- purely visual polish or style changes
- dependency/tooling updates with no user-facing language change
- low-risk `fast` fixes unless they expose terminology ambiguity

When terms are resolved during a Domain Pass, update `CONTEXT.md` inline before finalizing issue artifacts.

Decision Locks should use canonical terms from `CONTEXT.md` when present. ADRs remain optional and rare; terminology alone is not ADR-worthy unless tied to a durable architecture trade-off.

## Definition Of Ready

A Task is ready when:

- acceptance criteria are explicit and testable
- verification commands are listed and exact
- dependencies/links are included
- runtime/toolchain versions are explicit if verify depends on specific versions
- for backend-coupled work: Decision Locks are checked in the controlling issue (Task in `single`, Spec in `gated`)
- for no-contract refactors: parity lock checklist is explicitly listed in acceptance criteria
- for bug fixes, backend business logic, contract-sensitive behavior, and stateful/cross-layer changes: the first test/assertion to add is identified when practical
- for domain-affecting work: canonical terms are either resolved in `CONTEXT.md` or explicitly listed as open ambiguities in the Task/Spec

## Definition Of Done

A Task is done when:

- PR is merged
- verification commands pass
- tests for the feature are included in the same Task by default
- targeted tests/assertions for the touched behavior are added when practical; lower-risk UI polish or exploratory work can stay lighter
- docs are updated when behavior/contracts changed
- changed code complies with `docs/CODE_COMMENTING_CONTRACT.md`
- follow-up issues are created for deferred work
- reviewer follow-up is complete with verdict and actionable findings addressed or deferred explicitly
- boundary/layer guardrail checks pass when applicable
- no-contract refactors include reported parity lock results (status/shape/error/side-effects), not just a prose claim
- after explicit reviewer verdict `APPROVED`, the lightweight tutoring handoff is generated once by the approving reviewer in that same chat response; do not create a separate markdown artifact unless explicitly requested

## Decision Records And ADRs

- Default: Decision Locks live in the controlling issue (Task in `single`, Spec in `gated`).
- Use a separate Decision issue only for non-trivial or cross-Spec discussion.
- If a decision has lasting architecture/security/performance impact:
  - create an ADR (`NNN-*.md`)
  - link it from the Spec or Task
  - link it from the implementing PR

## Verification Template

Use project commands:

```bash
{{VERIFY_COMMANDS}}
```

Prefer repo-level verify entrypoints when available (for example: `make backend-verify`, `make frontend-verify`).

When a Makefile verify contract exists (see `docs/workflow/VERIFY.md`), use those canonical targets in Task verification sections.

## Codex + GitHub CLI Playbook

If using Codex in VS Code with GitHub CLI, follow `skills/spec-workflow-gh.md`.

- `mode=single` (default): generate one Task issue body + `gh issue create` command
- `mode=gated`: generate Spec + Task issue body + commands (only when explicitly requested)
- `mode=fast`: generate quick-fix checklist (only when explicitly requested)

### Planning Kickoff Prompt (Feature -> Issue Artifacts)

Use this canonical planning kickoff prompt:

`Run kickoff for feature <feature-id> from <filename> mode=<single|gated|fast>.`

Rules:

- If `mode` is omitted, default to `single`.
- Do not switch to `gated` or `fast` unless explicitly requested.
- This kickoff is planning-only by default: no code changes, no PR creation.
- Immediately before issue-ready markdown / issue creation output, include a short `Why this approach` checkpoint with:
  - chosen approach
  - one rejected alternative
  - main tradeoff
  - assumptions/contracts that must hold
- Output should include: issue body file(s), `gh issue create` command(s) when applicable, created issue link(s), and a 3-5 step implementation plan.
- Include the Execution Brief decision and criteria from `docs/template/KICKOFF.md` §2 (create a brief when it materially shrinks handoff; otherwise state why not).
- For `mode=fast`, output a quick-fix checklist and verification plan; no issue creation by default.
- Keep chatter minimal; ask follow-up questions only for hard blockers (auth/permissions/missing required labels).

### Execution Kickoff Prompt (Existing Task)

When a Task issue already exists, use the canonical execution kickoff prompt in `docs/template/KICKOFF.md`:

`Run kickoff for existing Task #<task-id> mode=single.`

Expected behavior:

- restate goal/non-goals/acceptance criteria/verification from the issue
- if an Execution Brief exists, reference it alongside the Task and treat it as the working handoff for task-local deltas only; the Task issue remains authoritative
- execute in `single` mode unless explicitly told otherwise
- create/switch to dedicated branch `task-<id>-<slug>` before implementation
- for bug fixes, backend business logic, contract-sensitive behavior, and stateful/cross-layer changes, identify the first test/assertion to add before implementation when practical
- open PR with `Closes #<task-id>`
- follow brief-first execution and the delta-only patch handoff in `docs/template/KICKOFF.md` instead of reprinting stable repo rules in task-local prompts
- return the standardized robust reviewer follow-up prompt

### Resiliency Checkpoints (Lightweight)

Before implementation in `single`/`gated` modes, restate:

- Goal and non-goals
- Files in scope and files explicitly out of scope
- Acceptance criteria and verification commands
- When the Task is stateful or cross-layer: a short Behavior Matrix (states/actions, success/error semantics, side effects per path, failure-path outcomes)

Before completion, restate:

- What changed
- What did not change (contracts/behavior)
- Verification results and follow-ups (if any)

## Lean Reviewer Follow-Up (Default)

This review step is intentionally narrow and fast.

Flow:

1. Implementation agent opens PR and provides reviewer prompt.
2. Reviewer inspects major correctness/regression risks and missing tests/docs.
3. Reviewer returns:
   - `APPROVED`, or
   - `ACTIONABLE` with concrete fixes.
4. If `ACTIONABLE`, implementation agent uses the delta-only patch handoff from `docs/template/KICKOFF.md` and reruns relevant verification only unless scope expands.
5. Run second review pass only if explicitly requested.

Reviewer constraints:

- use local diff/repo context first; use the diff as the review entrypoint and expand when the change touches state transitions, contracts, shared utilities, templates, or cross-layer behavior
- no environment triage loops by default
- no worktree setup by default
- no broad verification reruns already reported green
- no command transcript unless a command failed
- for stateful/cross-layer Tasks, verify parity across affected states (status/action, error/detail, side-effect, failure/retry), not only the happy path
- classify findings as merge-blocking bug/contract issue, quick hardening fix, or follow-up product/UX decision; do not treat unresolved copy/UX questions as correctness bugs unless they violate a documented contract
- be strict about contract drift, acceptance criteria, verification evidence, and layer-boundary violations; be flexible about internal helper structure when the code remains readable, testable, and consistent with repo patterns
- do not return `APPROVED` while required PR checks are failing, stale, or missing unless CI/check status was explicitly inspected and determined non-blocking; mention in verification notes whether CI was inspected when relevant

Use the exact output contract in `docs/template/KICKOFF.md` (single source of truth).

## Common GitHub CLI Commands

This section is the canonical command snippet source for issue operations.

```bash
gh issue create --title "Task: <feature> end-to-end" --label "type:task,area:frontend" --body-file plans/YYYY-MM-DD/task-<feature>-01.md
gh issue create --title "Spec: <feature set>" --label "type:spec" --body-file plans/YYYY-MM-DD/spec-<feature-set>.md
gh issue list --label type:task
gh issue view <id>
```

## Optional Later

MCP is not required for v1. Add it later only for automation (issue creation/labeling/CI summaries).
