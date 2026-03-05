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

## Fresh-Context Review

- [ ] Fresh-context review pass completed on PR branch
- [ ] Review/patch loop stayed within configured caps
- [ ] Findings are documented with severity and disposition
- [ ] Patch commits or follow-up issues are linked
- [ ] Local audit artifacts exist under `.codex/audit/task-<id>-<utc-timestamp>/`
- [ ] Queued GH actions (if any) are replayed or explicitly deferred (`scripts/gh_outbox_replay.sh`)

## Docs

- [ ] Architecture/pattern docs updated if needed
- [ ] ADR created/updated if decision has lasting impact
- [ ] Issue and PR links are complete

## CI

- [ ] CI status checked (`{{CI_LINKS_OR_NOTES}}`)
