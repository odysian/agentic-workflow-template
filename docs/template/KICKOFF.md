# Kickoff Prompts

Use these prompts to start an agent on already-scoped work with predictable output.

**Shortcut invocations (minimal copy-paste):** `docs/template/KICKOFF_SHORT.md`.

## 1) Execute Existing Task Issue

```text
Run kickoff for existing Task #<task-id> mode=single.

Reference <execution-brief-filepath>  # when present
Reference <analog-filepath>  # when relevant

Then execute the full Task flow end-to-end:
1. Restate goal, non-goals, acceptance criteria, and exact verification commands from the Task issue. If an Execution Brief exists (`docs/template/EXECUTION_BRIEF.md`), use it as the working handoff for task-local deltas only; the Task issue remains the source of truth.
2. Create/switch to branch `task-<id>-<slug>`.
3. Implement minimally and surgically, preserving existing contracts unless issue scope says otherwise.
4. Run relevant verification once after implementation.
5. Open PR with `Closes #<task-id>`.
6. Return the standardized reviewer follow-up prompt from section 3 below.
7. After review verdict:
   - if verdict is `ACTIONABLE`: use the delta-only patch handoff below; patch listed findings only and rerun targeted verification unless scope expands.
   - if verdict is `APPROVED`: finalize the Task and return the final completion summary; do not generate a second lightweight tutoring handoff after approval is relayed back.
8. If the Task touches state transitions, action availability, external side effects, or contract/error semantics, include a short Behavior Matrix before implementation.

Behavior Matrix (required when the Task is stateful or cross-layer):
- States/statuses involved and allowed actions per state
- Success/error codes and externally visible error semantics when relevant
- Side effects per path
- Failure-path outcomes

Open Product Decisions (required when applicable):
- If unresolved, explicitly mark them as follow-up candidates rather than encoding them as "correct" behavior

Constraints:
- Apply stable repo defaults from `AGENTS.md`, `ISSUES_WORKFLOW.md`, and `WORKFLOW.md` by reference unless this Task introduces a task-specific exception.
- Keep mode `single` unless explicitly requested otherwise.
- For bug fixes, backend business logic, contract-sensitive behavior, and stateful/cross-layer changes, identify the first test/assertion to add before implementation when practical.
- No environment triage loops, no worktree setup, no broad verification reruns.
- Keep output concise and findings-first.
```

### Recommended Operator Flow

- **Task issue:** authoritative scope, acceptance criteria, and verification.
- **Execution Brief:** optional compressed working handoff for task-local deltas, file scope, blockers, and locked decisions; it never replaces the Task issue.
- **Analog docs:** optional `docs/analogs/*` references when a repeated shape applies; link instead of reprinting long guidance.
- **Kickoff:** reference the Task plus the brief and analogs that matter for this execution pass.
- **Post-review patching:** if review returns `ACTIONABLE` and scope is unchanged, use the delta-only handoff below instead of rehydrating the full Task.

### Delta-Only Patch Handoff (Post-Review)

```text
Patch Task #<task-id> / PR #<pr-id> on branch <task-branch> after review.

Reference <execution-brief-filepath>  # when present
Reference <analog-filepath>  # when relevant

Inputs:
- Review verdict: ACTIONABLE
- Findings to address: <paste only the findings being patched>

Deliver:
1. Patch the listed findings only. If a finding requires scope expansion or exposes a product/contract ambiguity, stop and flag that before editing.
2. Keep the Task issue authoritative; use the Execution Brief only for task-local deltas that still apply.
3. Rerun targeted verification for the patched behavior only unless scope expansion invalidates the previous green results.
4. Return a concise patch summary, the targeted verification run, and any follow-up needed.

Constraints:
- Do not restate the full Task scope, stable repo rules, or reviewer contract unless the findings change them.
- No broad verification reruns or environment triage loops by default.
- Preserve existing contracts unless a listed finding explicitly requires a contract correction.
```

## 2) Planning-Only Kickoff (No Code Changes)

```text
Run kickoff for feature <feature-id> from <filename> mode=<single|gated|fast>, planning-only (no code changes, no PR).

Deliver:
1. Problem framing (goal, non-goals, constraints).
2. Proposed implementation plan (3-5 steps, smallest viable path first).
3. Risks and edge cases.
4. Acceptance criteria draft.
5. Verification plan (exact commands).
6. `Why this approach` checkpoint:
   - chosen approach
   - one rejected alternative
   - main tradeoff
   - assumptions/contracts that must hold
7. Recommended issue artifact markdown (Task/Spec as applicable) ready for `gh issue create --body-file` when applicable.
8. Execution Brief decision:
   - Decide whether the resulting Task warrants an Execution Brief (`docs/template/EXECUTION_BRIEF.md`).
   - Create one when task-local deltas, analog references, locked decisions, blockers, or complexity would make implementation handoff meaningfully smaller and clearer.
   - If yes, output a filled brief (or a draft path under `plans/` for the operator to commit).
   - If no, state briefly why the Task issue alone is sufficient.

After a Task issue exists, add or refresh an Execution Brief only when it still reduces handoff size (for example mid-stream operator changes or newly locked decisions).

Constraints:
- Keep it lean and concrete.
- Default to one Task unless explicitly asked for split/gated mode.
- No speculative architecture.
- Reference stable repo rules from canonical docs instead of reprinting them in the issue artifact unless the task introduces an exception.
- For bug fixes, backend business logic, contract-sensitive behavior, and stateful/cross-layer changes, identify the first test/assertion to add when practical.
- UI polish, exploratory work, copy tweaks, and other low-risk changes can stay lighter.
```

Notes:
- If `mode=gated`, output Spec + default child Task issue bodies and commands.
- If `mode=fast`, output a quick-fix checklist and verification plan; no issue creation by default.

## 3) Standard Reviewer Follow-Up Prompt (Robust)

Use this exact prompt after opening a Task PR.

```text
Review Task #<task-id> / PR #<pr-id> on branch <task-branch> vs <base-branch>.

Goal:
- Identify correctness bugs, regressions, contract drift, boundary/pattern violations, and missing tests/docs.

Review Scope (in priority order):
1. Correctness and regressions (runtime behavior, edge cases, state transitions)
2. Contract parity (status codes, response shapes, error semantics, side effects) if scope claims no contract change
3. Architecture consistency (layer boundaries, dependency direction, service/repository responsibilities)
4. Security and performance risks introduced by this diff
5. Missing or weak tests/docs/comment-contract coverage for changed behavior

Constraints:
- Use local diff and repository context first.
- Use the local diff as the review entrypoint. Expand to surrounding code/tests/docs only when the change touches state transitions, contracts, shared utilities, templates, or cross-layer behavior.
- No environment triage loops or worktree setup.
- Run targeted checks only when needed to validate a specific finding.
- Do not rerun broad verification already reported green unless prior results are suspect.
- Keep output concise and findings-first.
- No command transcript unless a command failed and that failure matters to a finding.
- For stateful/cross-layer Tasks, verify status/action/error/side-effect parity across all affected states, not just the happy path.
- If the verdict is `APPROVED`, end the same response with the lightweight tutoring handoff from section 4.
- Classify findings as one of:
  - merge-blocking bug/contract issue
  - quick hardening fix
  - follow-up product/UX decision
- Avoid escalating unresolved wording/copy/product decisions as correctness bugs unless they violate a documented contract.
- Be strict about contract drift, verification gaps, acceptance-criteria misses, and layer-boundary violations. Be flexible about internal helper decomposition when readability, testability, and repo-pattern consistency are intact.
- Do not return `APPROVED` while required PR checks are failing, stale, or missing unless you explicitly inspected that CI state and determined it is non-blocking.

Required Output:
1. Verdict: APPROVED or ACTIONABLE
2. Findings (if ACTIONABLE), one per line with:
   [severity] file/path:line | category | issue | impact | required fix
   - severity: critical/high/medium/low
   - category: correctness|regression|contract|architecture|security|performance|tests|docs
3. Verification notes:
   - targeted checks run (if any) and why
   - whether PR CI/check status was inspected, and any blocking failures
4. Residual risk/testing gaps:
   - up to 5 concise bullets
5. If verdict is `APPROVED`, end with the lightweight tutoring handoff from section 4 in the same chat response
```

## 4) Lightweight Tutoring Handoff In Chat (Reviewer-Owned)

The lightweight tutoring handoff is generated once, by the approving reviewer, in the same `APPROVED` response.
Do not generate a second learning handoff after approval is relayed back.

Post it directly in the same chat/thread.
Do not create a separate markdown handoff unless explicitly requested.
Keep it lightweight enough to generate and consume in about five minutes.
Use plain English, tutoring tone, and cap it at 4 short bullets plus 3-6 code pointers.

```text
- What changed: <2-3 sentences max>
- Why it was done this way: <brief rationale>
- Tradeoff or pattern worth learning: <one thing to teach>
- What to review first: <how a junior operator should read the diff>

Code pointers:
- `path:line-line — why it matters`
```
