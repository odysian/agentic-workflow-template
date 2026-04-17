# AGENTS.md — {{PROJECT_NAME}}

## Canonical Entrypoint

`AGENTS.md` is the canonical entrypoint for agents and contributors in this repository.

## Universal Quality Floor

- Keep changes surgical and in-scope.
- Do not modify unrelated files.
- Preserve existing contracts unless the Task explicitly changes them.
- Do not modify applied migrations; create a new migration instead.
- Do not install dependencies without explicit approval.
- Use tiered verification while implementing; broad verification is a PR/final gate.
- Discover and apply subtree rules from `backend/AGENTS.md` and `frontend/AGENTS.md` when the touched scope enters those surfaces.
- Follow `docs/CODE_COMMENTING_CONTRACT.md` for in-code documentation standards.

## Mode-Routed Startup Paths

Choose the startup path that matches your immediate objective.

### A) Implement Existing Task (default execution path)

1. Read the Task issue (and PR context, if already open) first.
2. Read `docs/template/EXECUTION_BRIEF.md` only when a brief exists for the Task.
3. Read subtree rules (`backend/AGENTS.md`, `frontend/AGENTS.md`) only for touched scope.
4. Run the execution contract from `docs/template/KICKOFF.md` section 1.
5. Load `docs/workflow/IMPLEMENT.md` and `docs/workflow/VERIFY.md` only as needed.

### B) Review PR / Return Verdict

1. Start from PR diff + Task issue.
2. Apply review contracts from `docs/template/KICKOFF.md` sections `3a` and `3b`.
3. Use `.github/prompts/review-task.prompt.md` when you need the full robust reviewer prompt body.
4. Apply output budget and review defaults from `docs/workflow/REVIEW.md`.
5. Load subtree rules only if the diff touches those surfaces.

### C) Plan Work / Create Issues / Choose Mode

1. Read `docs/ISSUES_WORKFLOW.md` first.
2. Read `CONTEXT.md` when present to ground issue language in canonical product terms.
3. Run a Domain Pass before drafting issues when the feature introduces or changes product language, lifecycle semantics, or cross-layer domain concepts. Update `CONTEXT.md` inline as terms are resolved.
4. Use planning kickoff from `docs/template/KICKOFF.md` section 2.
5. Pull verification tier guidance from `docs/workflow/VERIFY.md`.
6. Use `skills/spec-workflow-gh.md` only for one-shot issue-body + `gh` generation.
7. Reflect resolved canonical terms consistently in issue titles, summaries, acceptance criteria, PR descriptions, UI copy, and docs.

### D) Docs / Architecture / Pattern Maintenance

Read only the docs you are updating (for example `docs/ARCHITECTURE.md`, `docs/PATTERNS.md`, `docs/REVIEW_CHECKLIST.md`, `docs/template/*`).

## Escape Hatch

If mode, labels, lifecycle, branching, or Spec/Task structure is unclear, read `docs/ISSUES_WORKFLOW.md` before changing process or opening issues.

## Path Switching Rule

The initial startup path is not a lock. If session intent shifts (for example planning -> implementation -> review), switch to the matching path above before proceeding.

## Unit Of Work Rule

- Default unit of work is a GitHub Task issue.
- Default mode is `single`: one feature -> one Task -> one PR.
- Use `gated` or `fast` only when explicitly requested.
- PRs close Tasks (`Closes #123`), not Specs.
- Specs close only after child Tasks are done or explicitly deferred.
- For issue-backed work, execute one Task issue at a time.

## Agent Operating Loop

1. Whiteboard in `plans/YYYY-MM-DD/*.md` (scratch only).
2. Confirm mode and issue readiness.
3. Restate goal/non-goals/acceptance criteria/verification.
4. Implement minimal in-scope changes.
5. Run relevant verification once per change set.
6. Open PR closing the Task.
7. Run one reviewer follow-up pass (`APPROVED` or `ACTIONABLE`).
8. Patch only actionable findings and rerun targeted verification.
9. Finalize only after explicit `APPROVED`.

Detailed implementation/review/verification defaults are split under `docs/workflow/*.md`.

## Project Context

- **Project:** `{{PROJECT_NAME}}`
- **Stack:** `{{STACK_SUMMARY}}`
- **Repo layout:** `{{REPO_STRUCTURE_OVERVIEW}}`

## Workflow Metadata

- Template baseline at scaffold time: `agentic-workflow-template v0.6.0`.
- Downstream repos should record an adoption date (`YYYY-MM-DD`) in repo docs.

## Verification Commands

```bash
{{VERIFY_COMMANDS}}
```

```bash
{{FRONTEND_VERIFY_COMMANDS}}
```

```bash
{{BACKEND_VERIFY_COMMANDS}}
```

```bash
{{DB_VERIFY_COMMANDS}}
```

When a Makefile verification contract exists, prefer canonical targets (`make verify`, `make backend-verify`, `make frontend-verify`, `make db-verify`).

## Rule Ownership

- Execution control plane (modes, lifecycle, DoR/DoD): `docs/ISSUES_WORKFLOW.md`
- Kickoff and reviewer prompt contracts: `docs/template/KICKOFF.md` and `.github/prompts/review-task.prompt.md`
- Engineering implementation defaults: `docs/workflow/IMPLEMENT.md`
- Review defaults and output budget: `docs/workflow/REVIEW.md`
- Verification tiers and contracts: `docs/workflow/VERIFY.md`
- Onboarding and mode routing: `AGENTS.md`
- Product/domain language and glossary: `CONTEXT.md`

## Skills Governance

- Precedence: repo docs -> local `skills/*` -> external installed skills.
- Install external skills in Codex home, not in project repos.
- Keep active external skills minimal and non-overlapping.
- If an external skill conflicts with repo docs, follow repo docs.

## Optional Later

MCP is out of scope for v1 and can be added later for automation.
