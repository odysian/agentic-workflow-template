# AGENTS.md — {{PROJECT_NAME}}

## Start Here (Canonical Entrypoint)

`AGENTS.md` is the canonical entrypoint for agents and contributors in this repository.

Read in this order:
1. `AGENTS.md` (this file)
2. `WORKFLOW.md`
3. `ISSUES_WORKFLOW.md`
4. `ARCHITECTURE.md` (if present)
5. `PATTERNS.md` (if present)
6. `REVIEW_CHECKLIST.md` (if present)
7. `skills/write-spec.md` (if present)
8. `skills/spec-to-issues.md` (if present)
9. `skills/issue-to-pr.md` (if present)
10. `skills/spec-workflow-gh.md` (if present)

## Unit of Work Rule

- **Unit of work is a GitHub Issue.**
- Choose an execution mode from `ISSUES_WORKFLOW.md` before coding:
  - `single` (default): one feature -> one Task issue -> one PR
  - `gated`: Spec issue + child Task issue(s) for feature sets or higher-risk work
  - `fast`: quick-fix path for tiny low-risk changes (if project policy allows)
- Convert freeform requests into the selected issue mode before implementation.
- Work one Task issue at a time.
- PRs close Task issues (`Closes #123`), not Specs.
- Specs close only when all child Tasks are done or explicitly deferred.
- Detailed control-plane rules are canonical in `ISSUES_WORKFLOW.md`.
- For one-shot issue body + `gh` command generation, use `skills/spec-workflow-gh.md`.
- Canonical single-line kickoff prompt:
  - `Run kickoff for feature <feature-id> from <filename> mode=<single|gated|fast>.`
  - If `mode` is omitted, default to `single`.
  - Expected output: issue body file(s), `gh issue create` command(s), created issue link(s), and a 3-5 step implementation plan.

## Agent Operating Loop

1. Whiteboard scope in `plans/*.md` or spec docs (scratch only).
2. Choose execution mode (`single` default, `gated`, or `fast`) and create required issue(s).
3. Restate goal and acceptance criteria.
4. Plan minimal files and scope.
5. Implement with tight, surgical changes.
6. Run verification commands once (or once per code change set).
7. Open PR that closes the Task issue; close Spec after child Tasks are done/deferred.
8. Provide a lean reviewer follow-up prompt for a separate review pass.
9. Patch only actionable findings, rerun relevant verification, and finalize.

## Project Context

- **Project:** `{{PROJECT_NAME}}`
- **Stack:** `{{STACK_SUMMARY}}`
- **Repo layout:** `{{REPO_STRUCTURE_OVERVIEW}}`

## Operating Rules

- Keep solutions simple and explicit.
- Make surgical changes only.
- Match existing style and conventions.
- Do not install dependencies without approval.
- Do not change unrelated files.
- Do not modify applied migrations; create a new migration.
- Keep code review lean: focus on major bugs/regressions and missing tests.
- In review mode, avoid environment triage loops, worktree setup, and repeated full-suite verification unless a blocker requires it.

## Frontend Modularity Default

- Default for new projects: use a feature-first frontend structure: `src/features/<feature>/{components,hooks,services,types,tests}` and `src/shared/{components,hooks,lib,types}`.
- Keep feature boundaries explicit: feature internals stay private; cross-feature usage should go through public exports.
- If a repo already uses a different structure, preserve it unless a dedicated migration task explicitly scopes restructuring.
- Practical file-size budgets: target `<=250` LOC for leaf components and `<=180` LOC for single-purpose hooks/services; `300-400` LOC can be acceptable when cohesive; require split or linked follow-up when a component exceeds `450` LOC or a hook/service exceeds `300` LOC.

## Decision Brief (Required)

For non-trivial fixes/features, include a short decision brief before completion:

- **Chosen approach:** what was implemented.
- **Alternative considered:** one realistic alternative.
- **Tradeoff:** why this choice won (complexity/risk/perf/security).
- **Revisit trigger:** when the alternative should be reconsidered.

For tiny quick fixes, a one-line brief is enough: chosen approach + primary risk.

## Workflow Order

1. Read `WORKFLOW.md`
2. Read `ISSUES_WORKFLOW.md`
3. Read project docs in `{{DOCS_PATHS}}`
4. Execute one ready Task issue

## Reviewer Handoff Contract

After implementation PR is open, the implementation agent provides a reviewer prompt containing:

- Task/PR identifier and branch/base
- verification already run
- explicit request for `APPROVED` or `ACTIONABLE`
- findings format: severity, file/path:line, issue, required fix

Reviewer pass default constraints:

- use local diff context first
- no broad environment triage by default
- no worktree creation by default
- no rerun of broad verification already reported green
- no command transcript in output unless a command failed

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

## Documentation Discipline

Treat doc updates like failing tests. Keep architecture, patterns, checklists, and ADRs current.

## Skills Note

`skills/*.md` are portable procedural playbooks unless your runtime explicitly loads them.

## Skill Governance

Keep external skills high-signal and conflict-free:

- Precedence order: `AGENTS.md` -> `WORKFLOW.md` -> `ISSUES_WORKFLOW.md` -> local `skills/*` -> external installed skills.
- Install external skills globally in Codex home, not inside project repos.
- Keep a small baseline (about 4-6 active external skills).
- Use skills intentionally (named skill or clear task match), not by default for every request.
- Avoid overlap: keep one primary skill per domain (API design, DB design, security, TypeScript).
- If an external skill conflicts with repo docs, follow repo docs and treat the skill as advisory.
- Review and prune unused or low-value skills regularly.

## Optional Later

MCP is out of scope for v1. It can be added later to automate issue creation/labeling/CI summaries.
