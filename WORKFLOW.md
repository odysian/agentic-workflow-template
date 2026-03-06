# WORKFLOW.md — {{PROJECT_NAME}}

## Project Context

- **Project:** `{{PROJECT_NAME}}`
- **Stack:** `{{STACK_SUMMARY}}`
- **Repo layout:** `{{REPO_STRUCTURE_OVERVIEW}}`

## Development Loop

Every feature follows:

1. Whiteboard
2. Document
3. Implement
4. Verify
5. Review handoff
6. Patch (if needed)
7. Finalize

## Issues Workflow (Control Plane)

Read `ISSUES_WORKFLOW.md` before implementation.

Core rule:

- GitHub issues are the execution source of truth.
- Choose execution mode: `single` by default; use `gated` or `fast` only when explicitly requested.
- Default sizing is 1 feature -> 1 Task -> 1 PR unless split criteria apply.
- PRs close Tasks.
- Specs close only when all child Tasks are done or deferred.
- For `single` and `gated` modes, create a dedicated Task branch before implementation.
- Backend-coupled work must have Decision Locks checked before implementation.
- After major refactors, open one docs-only Task for readability hardening (comments + `docs/PATTERNS.md` updates), with no behavior changes.

Definition of Ready and Definition of Done are defined in `ISSUES_WORKFLOW.md` and are mandatory gates.

## Lean Review Mode (Default)

After implementation and PR creation, run one focused reviewer follow-up pass:

- Reviewer scope: major correctness bugs, regressions, and missing tests/docs.
- Reviewer output: `APPROVED` or `ACTIONABLE`.
- If `ACTIONABLE`, patch findings and rerun only relevant verification.
- Default to one review pass; run a second pass only when explicitly requested.

Default reviewer constraints:

- use local branch diff/repo context first
- skip broad environment triage unless blocked
- do not create worktrees by default
- do not rerun full verification already reported green
- report findings first; no command-by-command transcript unless a command failed

## Canonical Reviewer Follow-Up Prompt

Use this after opening a Task PR:

```text
Review Task #<id> / PR #<id> on branch <task-branch> vs <base-branch>.

Goal:
- Find major bugs/regressions and missing tests/docs.

Constraints:
- Use local diff and repository context first.
- No environment triage loops, no worktree setup, no broad verification reruns.
- Run targeted checks only if needed to validate a specific finding.
- Keep output concise and findings-first.

Required output:
1. Verdict: APPROVED or ACTIONABLE
2. Findings (if ACTIONABLE): severity, file/path:line, issue, required fix
3. Residual risk/testing gaps (max 3 bullets)
```

## Planning and Scope

- One issue at a time.
- Default to one end-to-end Task per feature.
- For new frontend projects, default to feature-first structure: `src/features/<feature>/*` plus `src/shared/*`.
- For existing repos, keep current structure unless a dedicated migration task explicitly scopes restructuring.
- Practical file-size budgets: target `<=250` LOC for leaf components and `<=180` LOC for single-purpose hooks/services; `300-400` LOC is acceptable when cohesive; split or create a linked follow-up when a component exceeds `450` LOC or a hook/service exceeds `300` LOC.
- Split Tasks only when `ISSUES_WORKFLOW.md` split criteria apply.
- Keep changes surgical.

## Decision Brief Requirement

For non-trivial changes that modify behavior/contracts/architecture, include a short decision brief:

- chosen approach
- one alternative considered
- tradeoff behind the choice (complexity/risk/perf/security)
- revisit trigger for when the alternative becomes preferable

For small tasks with no contract/behavior change, decision brief is optional.

## Verification

Run the relevant checks before claiming completion.

### Full Verification

```bash
{{VERIFY_COMMANDS}}
```

### Frontend Verification

```bash
{{FRONTEND_VERIFY_COMMANDS}}
```

### Backend Verification

```bash
{{BACKEND_VERIFY_COMMANDS}}
```

### Database Verification

```bash
{{DB_VERIFY_COMMANDS}}
```

## Documentation

Update docs only when behavior/contracts/patterns changed.

Docs paths:

- `{{DOCS_PATHS}}`

## CI

- `{{CI_LINKS_OR_NOTES}}`

## Optional Later

MCP is optional and not part of v1. Introduce it only when you need automation for issue operations or CI summaries.
