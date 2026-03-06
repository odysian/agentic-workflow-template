# Review Checklist — {{PROJECT_NAME}}

## Correctness

- [ ] Behavior matches acceptance criteria
- [ ] Edge cases are handled
- [ ] No regression in related flows

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

## Reviewer Follow-Up

- [ ] Reviewer verdict recorded (`APPROVED` or `ACTIONABLE`)
- [ ] Actionable findings include severity + file/path:line + required fix
- [ ] Review focused on major bugs/regressions and missing tests/docs
- [ ] No unnecessary environment triage/worktree/full-suite reruns were performed

## Docs

- [ ] Architecture/pattern docs updated if needed
- [ ] ADR created/updated if decision has lasting impact
- [ ] Issue and PR links are complete

## CI

- [ ] CI status checked (`{{CI_LINKS_OR_NOTES}}`)
