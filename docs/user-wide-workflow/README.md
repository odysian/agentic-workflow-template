# User-Wide Workflow Overlay

This folder contains the smaller, portable workflow shape intended for day-to-day work
across many repositories without committing repo-specific agent files.

Use this when you want:

- one user-wide agent workflow
- tiny local repo shims
- no personal absolute paths committed to company repositories
- no symlinks into work repos

## Files

- `AGENTS.md` - user-wide portable kernel.
- `CLAUDE.md` - user-wide Claude bridge.
- `KICKOFFS.md` - copy/paste planning, execution, review, and patch prompts.
- `PLANS.md` - personal cross-project planning document conventions.
- `CONTEXT.template.md` - optional domain-language scaffold.
- `WINDOWS_SETUP.md` - Windows/Git Bash setup notes.
- `local-shims/` - ignored local repo shim templates.

## Install Shape

User-wide source of truth:

```text
~/.agents/workflow/
  AGENTS.md
  CLAUDE.md
  KICKOFFS.md
  PLANS.md
  CONTEXT.template.md
```

Windows equivalent:

```text
%USERPROFILE%\.agents\workflow\
  AGENTS.md
  CLAUDE.md
  KICKOFFS.md
  PLANS.md
  CONTEXT.template.md
```

Per repo, local-only and ignored:

```text
AGENTS.md      # imports user-wide kernel and records local repo facts
CLAUDE.md      # imports AGENTS.md
CONTEXT.md     # optional local domain notes
```

Add local shims to `.git/info/exclude`, not the committed `.gitignore`, unless the team
explicitly wants these files tracked:

```bash
printf "\nAGENTS.md\nCLAUDE.md\nCONTEXT.md\n" >> .git/info/exclude
```

## Local Repo Facts

The local shim should contain only facts the user-wide kernel cannot know:

```md
## Local Repo Facts

- Shell:
- Work item source:
- Branch convention:
- Package manager:
- Install:
- Tier 1 verify:
- Tier 3 verify:
- Manual gates:
- Sensitive files:
- Notes:
```

## Agent Load Smoke Test

After creating a local shim, start a new agent session in the repo and ask:

```text
Read the repo agent instructions and summarize: workflow source, stack, verification
commands, shell expectations, and files you should avoid editing casually. Do not make
code changes.
```

If the agent misses the user-wide kernel, fix the shim include path before doing
implementation work.

## Relationship To Full Template

The full repo-local template remains useful for greenfield projects and teams that want
workflow files committed. This user-wide overlay is lighter: it keeps personal workflow
rules outside project repos and uses local ignored shims for per-repo facts.
