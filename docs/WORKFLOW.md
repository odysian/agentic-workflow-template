# Workflow Index — {{PROJECT_NAME}}

`docs/WORKFLOW.md` is the thin index for implementation, review, and verification defaults.

## Source Of Truth Map

- Execution control plane (modes, issue lifecycle, DoR/DoD): `docs/ISSUES_WORKFLOW.md`
- Kickoff prompts, delta-only patch flow, and reviewer output contract: `docs/template/KICKOFF.md`
- Full robust reviewer prompt body (off-repo copy/paste): `.github/prompts/review-task.prompt.md`
- Implementation loop, boundaries, parity, and scope defaults: `docs/workflow/IMPLEMENT.md`
- Review constraints, output budget, and verdict flow: `docs/workflow/REVIEW.md`
- Verification tiers, commands, and gate expectations: `docs/workflow/VERIFY.md`
- Greenfield structure baseline: `docs/GREENFIELD_BLUEPRINT.md`
- Onboarding and mode routing entrypoint: `AGENTS.md`
- Product/domain language and glossary: `CONTEXT.md`

## How To Use This Split

1. Start with `AGENTS.md` to pick the correct mode path.
2. Load only the workflow slice needed for the current step:
   - implementation -> `docs/workflow/IMPLEMENT.md`
   - review -> `docs/workflow/REVIEW.md`
   - verification planning/gating -> `docs/workflow/VERIFY.md`
3. Use `docs/ISSUES_WORKFLOW.md` as the escape hatch whenever mode/lifecycle rules are unclear.

## Legacy Section Map

Former monolithic sections were split into:

- implementation guidance -> `docs/workflow/IMPLEMENT.md`
- review guidance -> `docs/workflow/REVIEW.md`
- verification guidance -> `docs/workflow/VERIFY.md`

## Workflow Metadata

- Template baseline at scaffold time: `agentic-workflow-template v0.7.0`.
- Downstream repos should record an adoption date (`YYYY-MM-DD`) in repo docs.
