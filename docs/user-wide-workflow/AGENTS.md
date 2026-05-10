# AGENTS.md Kernel - User-Wide Portable Workflow

This is a portable operating kernel for coding agents. It is intentionally
project-agnostic. Local repo shims define stack facts, commands, and local constraints.

## Precedence

When instructions conflict, follow this order:

1. Human instruction in the current session.
2. Repo or company policy, security rules, and code owner guidance.
3. Nearest repo/subtree `AGENTS.md` or equivalent local shim.
4. This portable kernel.
5. Personal preferences and optional playbooks.

Do not use this workflow to bypass team review, CI, security controls, licensing rules,
or data-handling policies.

## Universal Quality Floor

- Keep changes surgical and scoped to the work item.
- Preserve public contracts unless the work item explicitly changes them.
- Do not modify unrelated files.
- Do not install dependencies, change toolchains, or edit generated artifacts without clear need and approval.
- Do not commit secrets, local credentials, device identifiers, or personal paths.
- Prefer existing repo patterns over new abstractions.
- Add tests or verification proportional to risk.
- Update docs only when behavior, contracts, setup, or user-visible workflow changes.
- If a command fails because of environment or permissions, report the blocker clearly instead of masking it.

## Startup Routing

Choose one path. If the session changes, switch paths.

### A) Implement Existing Work Item

Use this when a ticket, issue, bug, or explicit task already exists.

1. Read the work item and any linked PR/context first.
2. Read the nearest repo/subtree shim for touched files.
3. Restate goal, non-goals, acceptance criteria, and verification.
4. Identify files in scope and explicitly risky/out-of-scope areas.
5. Check current git status before branching or editing; never discard unowned changes.
6. Create or switch to the team-standard branch when edits are expected.
7. Implement minimally.
8. Run tiered verification.
9. Open/update PR or push only when authorized by the user/team flow.
10. Request one focused review pass.

### B) Plan Work

Use this for feature shaping, issue drafting, task splitting, or unclear scope.

1. Read relevant product/docs/code context.
2. Run a Domain Pass when terminology, lifecycle state, or cross-boundary behavior changes.
3. Choose mode: `task` by default, `gated` for high-risk multi-step work, `fast` for low-risk quick fixes.
4. Produce issue-ready scope with acceptance criteria and exact verification commands.
5. Do not make code changes during planning unless explicitly asked.

### C) Review PR Or Diff

Use this when asked for review.

1. Review changed behavior first, not style first.
2. Focus on correctness, regressions, contract drift, security, data loss, and missing verification.
3. Lead with findings ordered by severity and file/line.
4. Return `APPROVED` only when no blocking findings remain.
5. Return `ACTIONABLE` when concrete fixes are required.

### D) Docs, Architecture, Or Pattern Maintenance

Read only docs relevant to the requested scope. Keep docs aligned with actual commands,
runtime versions, and contracts.

## Work Item Model

Use neutral objects so the workflow works with GitHub Issues, Jira, Linear, or a written
prompt.

- **Task**: default PR-sized implementation unit.
- **Spec**: umbrella for multiple related tasks or high-risk work.
- **Decision**: short decision lock with rationale.
- **Fast fix**: low-risk direct change when team policy allows it.

Default: one Task -> one branch -> one PR.

Split work only when it improves delivery or risk control:

- too large to review safely
- contract or schema change should land separately
- hardware/manual validation gates later software work
- migration or state-machine work needs staging
- independent parts can be reviewed and merged without coordination risk

Parallel worktree execution is optional and deferred. Do not make it part of the core
workflow until it is used often enough to justify the extra surface area.

## Definition Of Ready

A Task is ready when:

- goal and non-goals are clear
- acceptance criteria are testable
- exact verification commands are listed
- affected surfaces and owners are known
- dependencies and manual/hardware requirements are called out
- contract changes are explicit
- domain terms are resolved or open questions are named

## Definition Of Done

A Task is done when:

- implementation satisfies acceptance criteria
- verification passed or blockers are documented with exact failed commands
- tests/docs changed where risk requires it
- PR/review requirements are satisfied
- follow-up work is explicitly captured, not hidden in prose

## Domain Pass

Run before issue drafting when work:

- introduces or overloads a core noun
- changes lifecycle or state meaning
- crosses app/service/provider/device boundaries
- affects user-facing terminology
- creates a new module or service boundary
- is high-risk or multi-step

Output:

- canonical terms
- avoided synonyms, when important
- unresolved decisions
- ADR/decision-record need, only if the decision is hard to reverse, surprising, and has a real trade-off

Skip Domain Pass for isolated bug fixes, visual polish, small refactors, and dependency
maintenance with stable terminology.

## Implementation Defaults

- Read code before editing.
- Prefer structured APIs/parsers over ad hoc text manipulation.
- Keep route/page/entry files thin; move orchestration to existing service/hook/module layers.
- Repositories or persistence layers own persistence details only.
- Services own policy, validation, orchestration, transactions, and side effects.
- UI state should make loading, error, empty, disabled, and retry states explicit.
- For no-contract refactors, verify parity for status/shape/error/side effects.

## Verification Tiers

- **Tier 1 - Loop**: smallest checks proving changed behavior.
- **Tier 2 - Patch**: targeted reruns for review findings.
- **Tier 3 - Gate**: broad repo or surface verification before final/PR.
- **Tier 4 - Operator**: manual, hardware, live-provider, destructive, or expensive checks.

Rules:

- Prefer repo-provided verify commands.
- Do not run live/provider/hardware checks from an agent unless the environment is explicitly prepared.
- If sandboxing blocks services, hardware, localhost, or network, stop after one diagnostic run and escalate or ask the operator for output.
- Final summaries must name commands run and results.

## Review Loop

Default review pass:

- verdict: `APPROVED` or `ACTIONABLE`
- if `ACTIONABLE`, list only concrete findings with required fixes
- patch only listed findings unless scope expands
- rerun targeted verification
- run a second review only when requested or risk remains high

Reviewer priorities:

1. correctness/regression
2. contract/API/schema drift
3. state and failure-path behavior
4. security/privacy/data loss
5. missing tests or docs
6. maintainability issues that affect future changes

## Output Budget

- Be concise.
- Do not restate stable repo rules unless they matter.
- Show failed command context only when useful.
- Final summaries should include changed files, intent, verification, and known follow-ups.

## Local Repo Facts Contract

Each local repo shim should define only facts the kernel cannot know:

- stack and package manager
- repo layout
- branch/PR/ticket conventions
- verification commands by tier
- manual/hardware gates
- forbidden or sensitive files
- common pitfalls
- subtree-specific rules

Shims should stay small and local-only unless the team wants them committed. Put durable
domain vocabulary in `CONTEXT.md`, not in every agent instruction file.
