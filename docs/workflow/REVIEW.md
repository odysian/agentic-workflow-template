# Review Workflow — {{PROJECT_NAME}}

Use this document for reviewer behavior, output budget, and post-review patching defaults.

## Agent Output Budget

- Findings-first output, ordered by severity.
- Keep overviews brief and only after findings.
- Do not repeat full verification blocks already reported green.
- Do not include command transcripts unless a failed command is necessary to explain a finding.
- Keep residual risk/testing-gap notes concise (up to 5 bullets).

## Lean Reviewer Mode (Default)

1. Start from Task/PR diff and surrounding context.
2. Focus on correctness/regressions, contract drift, boundary violations, security/perf risks, and missing tests/docs.
3. Return one verdict: `APPROVED` or `ACTIONABLE`.

Default constraints:

- no environment triage loops
- no worktree setup
- no broad verification reruns already reported green
- targeted checks only when needed to validate a specific finding

## Review Kickoff Assets

- `docs/template/KICKOFF.md` section 3a: reviewer kickoff contract
- `docs/template/KICKOFF.md` section 3b: required output contract summary
- `.github/prompts/review-task.prompt.md`: full robust reviewer prompt body

## Verdict And Patch Flow

- `ACTIONABLE`: patch listed findings only, then rerun targeted verification unless scope expands.
- `APPROVED`: approving reviewer includes lightweight tutoring handoff in the same response.

Use the delta-only patch handoff in `docs/template/KICKOFF.md` for post-review updates.

## Learning Handoff Rule

The lightweight tutoring handoff is generated once, by the approving reviewer, in the same `APPROVED` response.

- Do not generate a second handoff after approval is relayed back.
- Keep handoff to 4 short bullets + 3-6 code pointers.

## Related References

- `docs/template/KICKOFF.md`
- `.github/prompts/review-task.prompt.md`
- `docs/REVIEW_CHECKLIST.md`
