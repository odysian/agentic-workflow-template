# Copilot / Automated Review Instructions

Route workflow guidance through canonical docs instead of restating process rules.

## Start With

- `AGENTS.md` for mode routing
- `docs/ISSUES_WORKFLOW.md` for execution control plane
- `docs/template/KICKOFF.md` for kickoff + reviewer contracts
- `.github/prompts/review-task.prompt.md` when full robust reviewer body is needed

## Review Priorities

- correctness, regressions, and contract drift
- boundary violations against documented layering
- security/performance risks introduced by the diff
- missing tests/docs for changed behavior

## Keep Reviews High Signal

- findings-first output with exact file/line references
- avoid workflow-ceremony nitpicks as code defects
- avoid opportunistic large refactors unless the Task explicitly scopes them
- stay inside the approved Task scope

## Supporting Context

Use `docs/REVIEW_CHECKLIST.md`, `docs/workflow/REVIEW.md`, and subtree `backend/AGENTS.md` or `frontend/AGENTS.md` when relevant to touched scope.
