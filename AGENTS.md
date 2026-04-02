# AGENTS.md — {{PROJECT_NAME}}

## Start Here (Canonical Entrypoint)

`AGENTS.md` is the canonical entrypoint for agents and contributors in this repository.

Must-read in this order:
1. `AGENTS.md` (this file)
2. `ISSUES_WORKFLOW.md`
3. `docs/template/KICKOFF.md` (if present)
4. `WORKFLOW.md`

Read conditionally (only when relevant):
- `GREENFIELD_BLUEPRINT.md` for greenfield repos or explicit restructuring tasks
- `docs/README.md`, `docs/ARCHITECTURE.md`, `docs/PATTERNS.md`, `docs/REVIEW_CHECKLIST.md` for domain/contract/pattern changes
- `docs/template/EXECUTION_BRIEF.md` and `docs/analogs/*` when a Task uses a compressed handoff or analog pointers
- `skills/*` playbooks only when explicitly requested or clearly required by the task

## Unit of Work Rule

- **Default unit of work is a GitHub Issue.**
- Use `single` mode by default: one feature -> one Task issue -> one PR.
- Use `gated` or `fast` only when the user explicitly requests it.
- In `fast` mode, no issue creation is required (per `ISSUES_WORKFLOW.md` criteria).
- Convert freeform requests into the selected issue mode before implementation.
- For issue-backed work, work one Task issue at a time.
- PRs close Task issues (`Closes #123`), not Specs.
- Specs close only when all child Tasks are done or explicitly deferred.
- Detailed control-plane rules are canonical in `ISSUES_WORKFLOW.md`.
- For one-shot issue body + `gh` command generation, use `skills/spec-workflow-gh.md`.
- Canonical kickoff types:
  - Planning kickoff (issue planning only): `Run kickoff for feature <feature-id> from <filename> mode=<single|gated|fast>, planning-only (no code changes, no PR).`
  - Execution kickoff (implementation): `Run kickoff for existing Task #<task-id> mode=single.`
  - If an Execution Brief exists, reference it after the Task prompt and use it as the working handoff for task-local deltas; the GitHub Task issue remains authoritative.
  - If `mode` is omitted, default to `single`.
  - Do not switch to `gated` or `fast` unless explicitly requested.
  - Planning kickoff output: issue body file(s), `gh issue create` command(s) when applicable, created issue link(s), a 3-5 step implementation plan, and the short `Why this approach` checkpoint from `docs/template/KICKOFF.md` (immediately before issue-ready markdown).
  - Execution kickoff output: implementation + verification + PR + standardized reviewer follow-up prompt + final completion after explicit `APPROVED`, with the lightweight tutoring handoff generated once by the approving reviewer in that same response.
  - Use `docs/template/KICKOFF.md` for exact brief-first execution, delta-only patch handoff, and reviewer prompt wording instead of restating stable repo rules in task-local prompts.

## Agent Operating Loop

1. Whiteboard scope in `plans/YYYY-MM-DD/*.md` or spec docs (scratch only). New planning files should follow `plans/YYYY-MM-DD/<type>-<slug>.md`. Optional: when one workstream produces several artifacts (for example Spec + Task bodies and an optional Execution Brief), co-locate them under `plans/YYYY-MM-DD/<workstream-slug>/` with a stable hyphenated slug.
2. Choose execution mode and create required issue(s) (`single` unless explicitly asked for `gated`/`fast`; `fast` can skip issue creation).
3. Restate goal and acceptance criteria.
4. Plan minimal files and scope.
5. Implement with tight, surgical changes.
6. Run verification commands once (or once per code change set).
7. For issue-backed work, open PR that closes the Task issue; close Spec after child Tasks are done/deferred.
8. Provide a lean reviewer follow-up prompt for a separate review pass.
9. Patch only actionable findings, rerun relevant verification, and repeat review only if explicitly requested.
10. After explicit reviewer verdict `APPROVED`, finalize the Task or Spec; do not generate a second lightweight tutoring handoff after approval is relayed back.
11. Finalize: return the completion output and then close/complete the Task or Spec as applicable.

## Project Context

- **Project:** `{{PROJECT_NAME}}`
- **Stack:** `{{STACK_SUMMARY}}`
- **Repo layout:** `{{REPO_STRUCTURE_OVERVIEW}}`

## Workflow Metadata

- Template baseline at scaffold time: `agentic-workflow-template v0.5.0`.
- Downstream repos should record an adoption date (`YYYY-MM-DD`) in repo docs.

## Operating Rules

- **Tight boundaries, loose middle:** be strict about scope, contracts, acceptance criteria, verification, and layer boundaries. Be flexible about internal decomposition and helper structure as long as the implementation stays readable, testable, and consistent with repo patterns.
- Keep solutions simple and explicit.
- Make surgical changes only.
- Match existing style and conventions.
- Follow `docs/CODE_COMMENTING_CONTRACT.md` for in-code comment/docstring standards.
- Do not install dependencies without approval.
- Do not change unrelated files.
- Do not modify applied migrations; create a new migration.
- Keep code review lean: focus on major bugs/regressions and missing tests.
- In review mode, avoid environment triage loops, worktree setup, and repeated full-suite verification unless a blocker requires it.
- For no-contract refactors, use the parity lock checklist (status/shape/error/side-effects) before merge.
- Keep runtime/toolchain contracts explicit and consistent across README, local verify commands, and CI.
- For bug fixes, backend business logic, contract-sensitive behavior, and stateful/cross-layer changes, identify the first test/assertion to add before implementation when practical. This is guidance for higher-risk work, not strict TDD.

## Codebase Modularity Defaults

- Default for greenfield repos: follow `GREENFIELD_BLUEPRINT.md`.
- Backend layering default: `api -> services -> repositories -> integrations/libs`.
- Frontend layering default: `src/app` route shells + `src/features/<feature>` + `src/shared`.
- Keep feature boundaries explicit: feature internals stay private; cross-feature usage should go through public exports.
- If a repo already uses a different structure, preserve it unless a dedicated migration task explicitly scopes restructuring.
- Practical file-size budgets:
  - frontend components target `<=250` LOC
  - frontend hooks/services target `<=180` LOC
  - backend route/service/repository modules target `<=220` LOC
  - split or create linked follow-up when any frontend module exceeds `450/300` LOC (component vs hook/service) or backend route/service/repository exceeds `350` LOC

## Decision Brief (Conditional)

For non-trivial fixes/features, include a short decision brief only when behavior/contracts/architecture decisions changed:

- **Chosen approach:** what was implemented.
- **Alternative considered:** one realistic alternative.
- **Tradeoff:** why this choice won (complexity/risk/perf/security).
- **Revisit trigger:** when the alternative should be reconsidered.

For tiny quick fixes with no contract change, decision brief is optional.

## Workflow Order

1. Read `ISSUES_WORKFLOW.md`
2. Read `docs/template/KICKOFF.md`
3. Read `WORKFLOW.md`
4. Read `GREENFIELD_BLUEPRINT.md` only for greenfield/restructure tasks
5. Read project docs in `{{DOCS_PATHS}}` only when needed for touched scope
6. Execute one ready Task issue

## Reviewer Handoff Contract

After implementation PR is open, the implementation agent provides a reviewer prompt containing:

- Task/PR identifier and branch/base
- verification already run
- explicit request for `APPROVED` or `ACTIONABLE`

Reviewer pass default constraints:

- use local diff context first
- no broad environment triage by default
- no worktree creation by default
- no rerun of broad verification already reported green
- no command transcript in output unless a command failed
- default to one review pass; run a second pass only if the user explicitly requests it
- if verdict is `APPROVED`, the approving reviewer ends that same response with the lightweight tutoring handoff, generated once

Use the exact reviewer prompt/output contract from `docs/template/KICKOFF.md`.

## Learning Handoff Contract

Required completion gate:

- Post a lightweight tutoring handoff whenever a Task is finished and whenever a Spec is closed.
- The handoff is generated once, by the approving reviewer, in the same `APPROVED` response.
- Do not generate a second learning handoff after approval is relayed back; the implementation agent finalizes after approval.
- Post it directly in the same chat/thread; do not create a separate markdown handoff unless explicitly requested.
- Keep it brief, tutor-style, and practical rather than archival.
- Required shape:
  - 4 short bullets covering:
    - what changed
    - why it was done this way
    - one tradeoff or pattern worth learning
    - what to review first
  - 3-6 code pointers using `path:line-line — why it matters` format

## Verification

### Full

```bash
{{VERIFY_COMMANDS}}
```

### Frontend

```bash
{{FRONTEND_VERIFY_COMMANDS}}
```

### Backend

```bash
{{BACKEND_VERIFY_COMMANDS}}
```

### DB

```bash
{{DB_VERIFY_COMMANDS}}
```

If the repo defines a Makefile verification contract, prefer canonical `make` targets (for example: `make verify`, `make backend-verify`, `make frontend-verify`) over ad-hoc command variants.

## Documentation Discipline

Treat doc updates like failing tests. Keep architecture, patterns, checklists, and ADRs current.

## Skills Note

`skills/*.md` are portable procedural playbooks unless your runtime explicitly loads them.

## Skill Governance

Keep external skills high-signal and conflict-free:

- Rule ownership:
  - execution control plane (modes/DoR/DoD/branching): `ISSUES_WORKFLOW.md` (authoritative)
  - kickoff and reviewer output contract: `docs/template/KICKOFF.md` (authoritative)
  - implementation loop and quality defaults: `WORKFLOW.md`
  - onboarding and operating constraints: `AGENTS.md`
- For skills, precedence order is: repo docs above -> local `skills/*` -> external installed skills.
- Install external skills globally in Codex home, not inside project repos.
- Keep a small baseline (about 4-6 active external skills).
- Use skills intentionally (named skill or clear task match), not by default for every request.
- Avoid overlap: keep one primary skill per domain (API design, DB design, security, TypeScript).
- If an external skill conflicts with repo docs, follow repo docs and treat the skill as advisory.
- Review and prune unused or low-value skills regularly.

## Optional Later

MCP is out of scope for v1. It can be added later to automate issue creation/labeling/CI summaries.
