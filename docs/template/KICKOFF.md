# Kickoff Prompts

Use these prompts to start planning, implementation, and review passes with predictable output.

Short invocations live in `docs/template/KICKOFF_SHORT.md`.

## Types

- Planning kickoff: feature -> issue artifacts only (no code changes, no PR).
- Execution kickoff: existing Task -> implement/verify/PR flow.
- Review kickoff: existing Task/PR -> `APPROVED` or `ACTIONABLE` verdict.
- Delta-only patch: post-review patching for `ACTIONABLE` findings.

## Defaults

- Default mode is `single`.
- Do not switch to `gated` or `fast` unless explicitly requested.
- For issue-backed work, Task issue is authoritative.
- Execution Brief is optional and task-local only.

## When To Load Which Asset

| Situation | Load first | Load only if needed |
| --- | --- | --- |
| Planning issue artifacts | `docs/ISSUES_WORKFLOW.md`, this file section 2 | `CONTEXT.md` (when feature changes product language, lifecycle/state semantics, or cross-layer domain concepts), `docs/template/EXECUTION_BRIEF.md`, `docs/analogs/*`, `docs/workflow/VERIFY.md` |
| Implement existing Task | Task issue + this file section 1 | `docs/template/EXECUTION_BRIEF.md`, subtree `backend/AGENTS.md` / `frontend/AGENTS.md`, `docs/workflow/IMPLEMENT.md`, `docs/workflow/VERIFY.md` |
| Review Task PR | Task/PR diff + this file section 3a | section 3b + `.github/prompts/review-task.prompt.md`, subtree `AGENTS` files |
| Patch after `ACTIONABLE` | this file delta-only block | Execution Brief + analogs (if still relevant) |

## 1) Execute Existing Task Issue

```text
Run kickoff for existing Task #<task-id> mode=single.

Reference <execution-brief-filepath>  # when present
Reference <analog-filepath>  # when relevant

Then execute the full Task flow end-to-end:
1. Restate goal, non-goals, acceptance criteria, and exact verification commands from the Task issue.
2. If an Execution Brief exists (`docs/template/EXECUTION_BRIEF.md`), use it as task-local handoff only; the Task issue remains source of truth.
3. Create/switch to branch `task-<id>-<slug>`.
4. Implement minimally and surgically, preserving contracts unless scope says otherwise.
5. Run relevant verification once after implementation.
6. Open PR with `Closes #<task-id>`.
7. Return the standardized reviewer follow-up prompt from section 3 below.
8. After review verdict:
   - if `ACTIONABLE`: use the delta-only patch handoff below and rerun targeted verification unless scope expands.
   - if `APPROVED`: finalize Task completion; do not generate a second tutoring handoff after approval is relayed back.
9. If Task touches state transitions, action availability, side effects, or contract/error semantics, include a short Behavior Matrix before implementation.

Behavior Matrix:
- states and allowed actions
- success/error semantics
- side effects per path
- failure-path outcomes

Open Product Decisions:
- if unresolved, mark as follow-up candidates instead of encoding as settled behavior

Constraints:
- Keep mode `single` unless explicitly requested otherwise.
- For bug fixes, backend business logic, contract-sensitive behavior, and stateful/cross-layer changes, identify the first test/assertion to add before implementation when practical.
- No environment triage loops, no worktree setup, no broad verification reruns.
```

### Delta-Only Patch Handoff (Post-Review)

```text
Patch Task #<task-id> / PR #<pr-id> on branch <task-branch> after review.

Reference <execution-brief-filepath>  # when present
Reference <analog-filepath>  # when relevant

Inputs:
- Review verdict: ACTIONABLE
- Findings to address: <paste only the findings being patched>

Deliver:
1. Patch listed findings only. If scope must expand, stop and flag it.
2. Keep Task issue authoritative; use Execution Brief only for still-applicable task-local deltas.
3. Rerun targeted verification for patched behavior unless scope expansion invalidates prior green runs.
4. Return concise patch summary, targeted verification run, and follow-ups.

Constraints:
- Do not restate full Task scope or stable repo rules.
- No broad verification reruns or environment triage loops by default.
- Preserve existing contracts unless listed findings require a contract correction.
```

## 2) Planning-Only Kickoff (No Code Changes)

```text
Run kickoff for feature <feature-id> from <filename> mode=<single|gated|fast>, planning-only (no code changes, no PR).

Deliver:
1. Problem framing (goal, non-goals, constraints).
2. Proposed implementation plan (3-5 steps, smallest viable path first).
3. Risks and edge cases.
4. Acceptance criteria draft.
5. Verification plan (exact commands + intended verification tier).
6. Why this approach checkpoint:
   - chosen approach
   - one rejected alternative
   - main tradeoff
   - assumptions/contracts that must hold
7. Recommended issue artifact markdown ready for `gh issue create --body-file` when applicable.
8. Execution Brief decision:
   - create brief when task-local deltas/analogs/locked decisions/blockers materially shrink handoff
   - otherwise state why Task issue alone is enough

Constraints:
- Keep it lean and concrete.
- Default to one Task unless explicit split criteria apply.
- No speculative architecture.
- For bug fixes, backend business logic, contract-sensitive behavior, and stateful/cross-layer changes, identify the first test/assertion to add when practical.
```

Notes:
- `mode=gated`: output Spec + default child Task issue artifacts.
- `mode=fast`: output quick-fix checklist + verification plan; no issue creation by default.

### Domain Pass Prompt (Optional, Planning-Only)

Use when the feature introduces or changes product language, lifecycle semantics, or cross-layer domain concepts:

```text
Run a Domain Pass on <feature/plan>. Challenge terminology against this repo's current CONTEXT.md and docs, cross-check the code when claims can be verified locally, update CONTEXT.md inline when terms are resolved, and only suggest an ADR if the decision is hard to reverse, surprising without context, and the result of a real trade-off.
```

## 3) Review Assets

### 3a) Standard Reviewer Kickoff Prompt

```text
Review Task #<task-id> / PR #<pr-id> on branch <task-branch> vs <base-branch>.

Use reviewer constraints and required output contract from docs/template/KICKOFF.md section 3b.
Load .github/prompts/review-task.prompt.md for the full robust prompt body.
```

### 3b) Robust Prompt Body + Output Contract

- Full robust prompt text is owned in `.github/prompts/review-task.prompt.md`.
- Keep `docs/template/KICKOFF.md` as the index and contract pointer to avoid drift.
- Reviewer constraints summary (always apply):
  - use local diff/repo context first
  - no environment triage loops or worktree setup by default
  - run targeted checks only when needed; do not rerun broad verification already reported green unless suspect
  - keep output concise and findings-first; no command transcript unless a failed command matters to a finding
  - do not return `APPROVED` while required PR checks are failing/stale/missing unless explicitly inspected and non-blocking

Required reviewer output:

1. Verdict: `APPROVED` or `ACTIONABLE`
2. Findings (if `ACTIONABLE`), one per line:
   `[severity] file/path:line | category | issue | impact | required fix`
3. Verification notes:
   - targeted checks run (if any) and why
   - whether PR CI/check status was inspected, and blocking failures if any
4. Residual risk/testing gaps: up to 5 concise bullets
5. If verdict is `APPROVED`, end the same response with the lightweight tutoring handoff from section 4

## 4) Lightweight Tutoring Handoff In Chat (Reviewer-Owned)

Generated once by the approving reviewer in the same `APPROVED` response. Do not generate a second handoff after approval is relayed back.

Use this shape:

```text
Learning handoff:
- Concept primer: <plain-language explanation of the underlying idea before this PR's specifics>
- What changed: <2-3 sentences max>
- Why it was done this way: <brief rationale>
- Tradeoff or pattern worth learning: <one point>
- How to review this kind of change: <what a junior operator should inspect first next time>
```

File references may appear naturally when useful, but are not required.
