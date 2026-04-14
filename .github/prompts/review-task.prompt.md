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
- If the verdict is `APPROVED`, end the same response with the lightweight tutoring handoff from `docs/template/KICKOFF.md` section 4.
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
5. If verdict is `APPROVED`, end with the lightweight tutoring handoff from `docs/template/KICKOFF.md` section 4 in the same chat response
