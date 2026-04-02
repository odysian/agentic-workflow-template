# Kickoff Shortcuts (Operator)

Minimal copy-paste **invocations**. Canonical prompts, constraints, and reviewer output contract live in **`docs/template/KICKOFF.md`**.

Replace `<placeholders>` before sending.

---

## Whiteboard / discovery

```text
Whiteboard feature <feature-id> using <plan-or-spec-filepath>. Stay planning-only: no implementation, no PR. Follow docs/template/KICKOFF.md §2 for deliverable shape when ready to formalize.
```

## Plan review (before issue creation)

```text
Review the plan in <plan-filepath> for scope creep, missing error paths, untestable acceptance criteria, verification gaps, and blocking decisions. Output READY or NEEDS_WORK with concise findings. Canonical planning checklist: docs/template/KICKOFF.md §2.
```

## Planning / issue creation

```text
Run kickoff for feature <feature-id> from <filename> mode=<single|gated|fast>, planning-only (no code changes, no PR).
```

## Optional Execution Brief (after Task exists)

```text
Create an Execution Brief for Task #<task-id> using docs/template/EXECUTION_BRIEF.md.

Reference:
- <task-issue-URL>
- <plan-filepath>  # optional
- <analog-path-under-docs/analogs/>  # when relevant

Constraints: Task issue remains authoritative; brief is task-local and compressed; reference canonical docs instead of pasting stable rules.
```

## Implementation (existing Task)

```text
Run kickoff for existing Task #<task-id> mode=single.

Reference <execution-brief-filepath>  # when present
Reference <analog-filepath>  # when relevant
```

(Full step list and Behavior Matrix: **docs/template/KICKOFF.md §1**.)

## PR review

```text
Review Task #<task-id> / PR #<pr-id> on branch <task-branch> vs <base-branch>.
```

(Full reviewer prompt and required output: **docs/template/KICKOFF.md §3**.)

## Delta-only patch (after `ACTIONABLE`)

```text
Patch Task #<task-id> / PR #<pr-id> on branch <task-branch> after review.

Reference <execution-brief-filepath>  # when present
Reference <analog-filepath>  # when relevant

Inputs:
- Review verdict: ACTIONABLE
- Findings to address: <paste only the findings being patched>
```

(Full delta-only contract: **docs/template/KICKOFF.md** — Delta-Only Patch Handoff.)

## Re-review

```text
Re-review Task #<task-id> / PR #<pr-id> on branch <task-branch> vs <base-branch>.

Reference: prior findings, patch summary, targeted verification run.

Return APPROVED or ACTIONABLE per docs/template/KICKOFF.md §3.
```

## Copilot / Codex PR comment triage

```text
Triage all review bot / Copilot / Codex comments on PR #<pr-id> for Task #<task-id>.

For each thread: ACCEPT, REJECT, or DEFER with a one-line reason. Stay inside Task scope and execution mode. Apply the reviewer constraints in docs/template/KICKOFF.md §3. Summarize code changes made, verification run, and final verdict APPROVED | ACTIONABLE | NO_CHANGES_NEEDED.
```
