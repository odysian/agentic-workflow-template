# Windows Laptop Setup

Use this when installing the portable workflow on a Windows work laptop. Assumption:
day-to-day agent work happens in Git Bash.

## Goal

Keep the workflow user-wide. Put only tiny ignored shims in workplace repos. No
repo-specific workflow files need to be committed.

## Recommended Location

```text
%USERPROFILE%\.agents\workflow\
```

Git Bash copy from this folder:

```bash
dst="$HOME/.agents/workflow"
mkdir -p "$dst"
cp AGENTS.md CLAUDE.md KICKOFFS.md PLANS.md CONTEXT.template.md "$dst/"
```

PowerShell equivalent:

```powershell
$dst = "$env:USERPROFILE\.agents\workflow"
New-Item -ItemType Directory -Force $dst
Copy-Item .\AGENTS.md $dst
Copy-Item .\CLAUDE.md $dst
Copy-Item .\KICKOFFS.md $dst
Copy-Item .\PLANS.md $dst
Copy-Item .\CONTEXT.template.md $dst
```

Prefer forward slashes inside agent include references if a tool accepts absolute paths:

```text
@C:/Users/<you>/.agents/workflow/AGENTS.md
```

Do not commit that personal absolute path into company repos.

## Repo Adoption

Use local ignored shims. They are tiny repo facts, not repo-specific workflow files.

From a repo root in Git Bash:

```bash
kernel_path="$(cygpath -m "$HOME")/.agents/workflow/AGENTS.md"

printf "\nAGENTS.md\nCLAUDE.md\nCONTEXT.md\n" >> .git/info/exclude

printf "@%s\n\n" "$kernel_path" > AGENTS.md
cat >> AGENTS.md <<'EOF'
This file is local-only. Keep it out of git with `.git/info/exclude`.

## Local Repo Facts

- Shell: Git Bash
- Work item source:
- Branch convention:
- Package manager:
- Install:
- Tier 1 verify:
- Tier 3 verify:
- Manual gates:
- Sensitive files:
- Notes:
EOF

cat > CLAUDE.md <<'EOF'
@AGENTS.md
EOF
```

Use `CONTEXT.md` only when local domain terms matter.

## Shell Expectations

Use Git Bash as the default agent shell unless a repo explicitly needs PowerShell.

When documenting verification, include the shell:

```text
Git Bash: bun run typecheck
Git Bash: ./ci/smoke.sh
```

## First-Day Checklist

1. Confirm which shell the repo expects.
2. Confirm package manager and lockfile policy.
3. Confirm issue tracker and branch naming.
4. Add `AGENTS.md`, `CLAUDE.md`, and optional `CONTEXT.md` to `.git/info/exclude`.
5. Run the agent-load smoke prompt from `README.md`.
6. Run one small code task only after the shim has the right commands.

## Tool Checks

Run in Git Bash as relevant to the repo:

```bash
git --version
bash --version
node --version
bun --version
make --version
py -3 --version
```

Not every repo needs every tool.

## Windows Pitfalls

- Absolute local paths differ by user and should stay out of committed files.
- Shell scripts may fail in PowerShell even when correct in Git Bash/WSL.
- Case sensitivity differs from Linux; avoid renames that only change case.
- Line endings can churn files; respect the repo's `.gitattributes` and formatter.
- Symlink creation may require developer mode/admin rights; this workflow does not depend on symlinks.
- Hardware tools may need USB drivers, PATH setup, and serial-port permissions outside the agent's sandbox.
