# AGENTS.md — {{PROJECT_NAME}}

## Canonical Entry

Read in this order:

1. `AGENTS.md`
2. `WORKFLOW.md`
3. `ISSUES_WORKFLOW.md`
4. `ARCHITECTURE.md` (if present)
5. `PATTERNS.md` (if present)
6. `REVIEW_CHECKLIST.md` (if present)
7. `skills/adapt-workflow.md` (when adopting this template into an existing repo)

Use `skills/*` playbooks only when the task explicitly needs them.

## Non-Negotiables

- Unit of work is a GitHub Task issue.
- Default sizing: `1 feature -> 1 Task -> 1 PR`.
- Work one Task at a time.
- PRs close Tasks (`Closes #123`), not Specs.
- Keep changes surgical; do not touch unrelated files.
- Do not install dependencies without approval.
- Do not modify applied migrations; create new migrations.

## Execution Modes

Choose mode before coding (rules in `ISSUES_WORKFLOW.md`):

- `single` (default): one feature -> one Task -> one PR
- `gated`: Spec + child Task(s) for higher-risk feature sets
- `fast`: tiny low-risk fixes only

Canonical kickoff prompt:

`Run kickoff for feature <feature-id> from <filename> mode=<single|gated|fast>.`

## Agent Loop

1. Restate goal + acceptance criteria.
2. Confirm files in scope.
3. Implement minimal change.
4. Run verification.
5. Open PR.
6. Run bounded fresh-context review loop.
7. Update docs/tests if required.

## Local Automation Defaults

- PR creation: use `scripts/create_pr.sh` (never inline multiline `gh --body`)
- Fresh review loop: use `scripts/fresh_review_loop.sh`
- GH connectivity fallback queue: `scripts/gh_outbox_replay.sh`

## Decision Brief (Required)

For non-trivial work, include:

- chosen approach
- one alternative considered
- tradeoff
- revisit trigger

For tiny fixes: one-line brief (approach + primary risk).

## Verification

Run project verification commands from `WORKFLOW.md`.

## Documentation Discipline

Treat doc updates like failing tests when behavior/contracts/patterns change.

## Skill Governance

Precedence:

`AGENTS.md` -> `WORKFLOW.md` -> `ISSUES_WORKFLOW.md` -> local `skills/*` -> external skills

If external skill guidance conflicts with repo docs, repo docs win.
