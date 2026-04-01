# Copilot / automated code review (template-neutral)

Focus review comments on real engineering signal, not workflow ceremony.

## Prioritize

- Correctness, regressions, and contract drift
- Boundary violations and architectural inconsistency with the repo's stated layering
- Missing tests or docs for **changed** behavior
- Security and performance risks introduced by the diff

## Do not

- Treat normal workflow steps (planning checkpoints, lightweight tutoring handoffs in chat, issue/PR hygiene) as code defects
- Generate or demand learning handoffs as part of review triage; that belongs to the human reviewer's `APPROVED` response per `docs/template/KICKOFF.md`
- Suggest opportunistic large refactors or broad pattern rewrites during review unless the Task explicitly scoped them
- Expand scope beyond the approved Task

## Style

- Respect **tight boundaries, loose middle**: be strict on scope, contracts, acceptance criteria, verification, and layer boundaries; be flexible on internal decomposition when code stays readable, testable, and consistent with repo patterns
- Reference exact file paths and line numbers; keep comments concise

When repo docs define a review checklist (for example `docs/REVIEW_CHECKLIST.md`), treat it as advisory context alongside `AGENTS.md` and `WORKFLOW.md`.
