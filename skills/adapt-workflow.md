# Playbook: Adapt Workflow To Existing Repo

Use this when onboarding this template into an existing project.

## Canonical Adapter Prompt

`Run workflow adaptation for <repo-name>: map existing branch strategy, CI triggers, verify commands, issue labels, and GH reliability constraints to this template; output exact file edits, commands, and rollback notes.`

## Required Inputs

- repo name
- default branch and branch protections
- current CI triggers (push/PR/main deploy behavior)
- verification commands in current repo
- current issue/PR labels and templates
- GH reliability constraints (auth, DNS/network, proxy/VPN)

## Expected Output

1. adaptation summary (what maps cleanly, what conflicts)
2. file-by-file edit plan
3. exact commands to run
4. fallback behavior for GH failures
5. rollback notes

## Adaptation Checks

1. `AGENTS.md`, `WORKFLOW.md`, `ISSUES_WORKFLOW.md` are aligned and contradiction-free.
2. Verification commands are real and runnable in the target repo.
3. CI strictness is explicit:
- local fail-open queue behavior is allowed
- CI fail-fast behavior is preserved where required
4. GitHub issue/PR templates match the selected execution modes.
5. Replay path for queued GH actions is documented and tested.
