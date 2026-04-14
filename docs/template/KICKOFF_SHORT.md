# Kickoff Shortcuts (Operator)

Minimal invocations only. Canonical contracts live in `docs/template/KICKOFF.md`.

## Whiteboard / Discovery

```text
Whiteboard feature <feature-id> using <plan-or-spec-filepath>. Stay planning-only: no implementation, no PR.
```

(Use `docs/template/KICKOFF.md` section 2 when formalizing into issue artifacts.)

## Plan Review

```text
Review the plan in <plan-filepath> for scope creep, missing error paths, untestable acceptance criteria, verification gaps, and blocking decisions. Output READY or NEEDS_WORK with concise findings.
```

## Planning / Issue Creation

```text
Run kickoff for feature <feature-id> from <filename> mode=<single|gated|fast>, planning-only (no code changes, no PR).
```

(See `docs/template/KICKOFF.md` section 2.)

## Optional Execution Brief

```text
Create an Execution Brief for Task #<task-id> using docs/template/EXECUTION_BRIEF.md.
```

## Implementation (Existing Task)

```text
Run kickoff for existing Task #<task-id> mode=single.

Reference <execution-brief-filepath>  # when present
Reference <analog-filepath>  # when relevant
```

(See `docs/template/KICKOFF.md` section 1.)

## PR Review

```text
Review Task #<task-id> / PR #<pr-id> on branch <task-branch> vs <base-branch>.
```

- Kickoff contract: `docs/template/KICKOFF.md` section 3a
- Full robust review prompt body: `.github/prompts/review-task.prompt.md`
- Required output contract: `docs/template/KICKOFF.md` section 3b

## Delta-Only Patch (after ACTIONABLE)

```text
Patch Task #<task-id> / PR #<pr-id> on branch <task-branch> after review.

Inputs:
- Review verdict: ACTIONABLE
- Findings to address: <paste only the findings being patched>
```

(See delta-only block in `docs/template/KICKOFF.md` section 1.)

## Re-Review

```text
Re-review Task #<task-id> / PR #<pr-id> on branch <task-branch> vs <base-branch>.

Reference: prior findings, patch summary, targeted verification run.
Return APPROVED or ACTIONABLE.
```
