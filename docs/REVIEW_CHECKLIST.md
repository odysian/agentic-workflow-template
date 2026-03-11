# Review Checklist — {{PROJECT_NAME}}

## Correctness

- [ ] Behavior matches acceptance criteria
- [ ] Edge cases are handled
- [ ] No regression in related flows
- [ ] No-contract refactors include parity lock validation (status/shape/error/side-effects)

## Architecture And Boundaries

- [ ] Backend layering is preserved (`api -> services -> repositories -> integrations/libs`)
- [ ] No cross-layer shortcuts or reverse imports
- [ ] Public services are not pass-through wrappers
- [ ] Frontend feature boundaries are respected (`src/app` shells, feature logic in `src/features`, shared in `src/shared`)
- [ ] Module size guardrails were respected or explicitly deferred with a linked follow-up

## Security

- [ ] Authn/authz checks are correct
- [ ] Inputs are validated on trusted boundaries
- [ ] No secrets in code, logs, or config

## Performance

- [ ] Query/API patterns scale reasonably
- [ ] No obvious N+1 or avoidable heavy work
- [ ] Caching/pagination behavior is correct (if applicable)

## Tests

- [ ] Happy path covered
- [ ] Error path covered
- [ ] Edge case covered
- [ ] Verification commands pass
- [ ] Boundary/parity checks are included when relevant

## Toolchain And Reproducibility

- [ ] Runtime versions are pinned (for example Node/Python version files and `engines` where needed)
- [ ] README prerequisites, local verify commands, and CI runtime versions are consistent
- [ ] Verify pipeline fails fast on runtime mismatch

## Reviewer Follow-Up

- [ ] Reviewer verdict recorded (`APPROVED` or `ACTIONABLE`)
- [ ] Actionable findings include severity + file/path:line + required fix
- [ ] Review focused on major bugs/regressions and missing tests/docs
- [ ] No unnecessary environment triage/worktree/full-suite reruns were performed

## Docs

- [ ] Architecture/pattern docs updated if needed
- [ ] ADR created/updated if decision has lasting impact
- [ ] Issue and PR links are complete
- [ ] Changes remain aligned with `GREENFIELD_BLUEPRINT.md` defaults (or deviation is documented)

## CI

- [ ] CI status checked (`{{CI_LINKS_OR_NOTES}}`)
