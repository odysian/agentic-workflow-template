# Portable Kickoffs

Copy these prompts into an agent session when you want a consistent workflow.

## Planning Kickoff

```text
Run planning kickoff for <feature/workstream> from <source>.

Mode: <task|gated|fast>  # default task
No code changes.

Deliver:
1. problem framing
2. goal and non-goals
3. risks and edge cases
4. 3-5 step implementation plan
5. testable acceptance criteria
6. exact verification plan
7. issue/ticket-ready markdown
8. decision brief: chosen approach, one rejected alternative, tradeoff, assumptions
```

## Domain Pass

```text
Run a domain pass on <feature/plan>.

Challenge terminology against current repo language and code. Resolve canonical terms,
flag overloaded words, update/prepare CONTEXT.md entries when terms are settled, and
suggest an ADR only if the decision is hard to reverse, surprising without context, and
based on a real trade-off.
```

## Execution Kickoff

```text
Run execution kickoff for existing work item <id/link>.

Then execute end-to-end:
1. read the work item and local repo shim
2. restate goal, non-goals, acceptance criteria, and verification commands
3. identify files in scope and out of scope
4. create/switch to the team-standard branch if edits are expected
5. implement minimally
6. run verification by tier
7. summarize changes and verification
8. open/update PR only when authorized
9. provide review kickoff
```

## Review Kickoff

```text
Review work item <id/link> / PR <id/link> / branch <branch> against <base>.

Implementation verification already run:
- <command>: <result>

Return:
1. Verdict: APPROVED or ACTIONABLE
2. Findings if ACTIONABLE: [severity] path:line | category | issue | impact | required fix
3. Verification notes
4. Residual risk or testing gaps

Focus on correctness, regressions, contract drift, state/failure behavior, security,
data loss, and missing tests/docs. Do not rerun broad verification already reported
green unless the diff makes that evidence suspect.
```

## Delta Patch After Review

```text
Patch work item <id/link> / PR <id/link> after ACTIONABLE review.

Findings to patch:
- <paste findings only>

Deliver:
1. patch listed findings only
2. preserve existing scope and contracts
3. rerun targeted verification
4. return concise patch summary, verification result, and remaining risk
```

## Fast Fix

```text
Run fast-fix kickoff for <bug/maintenance item>.

Allowed only if no schema/API/security/dependency/toolchain/state-machine change is
needed. If scope grows, switch to normal task mode.

Deliver:
1. tiny scope statement
2. changed files
3. targeted verification
4. PR/commit summary
```

## Post-Plan Grill

```text
Grill this plan for execution risk, hidden edge cases, sequencing problems, and
verification gaps. Ask one question at a time and recommend an answer for each. Stop
when the remaining risk is named and manageable.
```
