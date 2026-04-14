#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

required_paths=(
  "AGENTS.md"
  "CLAUDE.md"
  "docs/WORKFLOW.md"
  "docs/ISSUES_WORKFLOW.md"
  "docs/GREENFIELD_BLUEPRINT.md"
  "docs/workflow/IMPLEMENT.md"
  "docs/workflow/REVIEW.md"
  "docs/workflow/VERIFY.md"
  "docs/PATTERNS.md"
  "docs/REVIEW_CHECKLIST.md"
  "docs/template/KICKOFF.md"
  "docs/template/KICKOFF_SHORT.md"
  "docs/template/EXECUTION_BRIEF.md"
  "docs/template/MIGRATION_GUIDE.md"
  "docs/template/PROJECT_SETUP.md"
  "docs/template/VERTICAL_SLICE_SPEC.md"
  "docs/template/SCAFFOLD_KICKOFF.md"
  ".github/prompts/review-task.prompt.md"
  ".github/ISSUE_TEMPLATE/spec.md"
  ".github/ISSUE_TEMPLATE/task.md"
  ".github/PULL_REQUEST_TEMPLATE.md"
  "scripts/check-unresolved-template-tokens.sh"
  "scripts/gh_preflight.sh"
  "scripts/create_pr.sh"
)

required_exec=(
  "scripts/check-unresolved-template-tokens.sh"
  "scripts/gh_preflight.sh"
  "scripts/create_pr.sh"
)

has_backend_surface() {
  [[ -d "backend/app" ]] || [[ -d "backend/src" ]] || [[ -d "backend/tests" ]] || [[ -f "backend/pyproject.toml" ]] || [[ -f "backend/requirements.txt" ]] || [[ -f "backend/Pipfile" ]]
}

has_frontend_surface() {
  [[ -d "frontend/src" ]] || [[ -d "frontend/app" ]] || [[ -d "frontend/tests" ]] || [[ -f "frontend/package.json" ]] || [[ -f "frontend/pnpm-lock.yaml" ]] || [[ -f "frontend/yarn.lock" ]]
}

missing=()
for path in "${required_paths[@]}"; do
  [[ -f "$path" ]] || missing+=("$path")
done

if has_backend_surface && [[ ! -f "backend/AGENTS.md" ]]; then
  missing+=("backend/AGENTS.md (required when backend surface exists)")
fi

if has_frontend_surface && [[ ! -f "frontend/AGENTS.md" ]]; then
  missing+=("frontend/AGENTS.md (required when frontend surface exists)")
fi

if ((${#missing[@]} > 0)); then
  echo "Template preflight FAILED: missing required files:"
  printf '  - %s\n' "${missing[@]}"
  exit 1
fi

not_exec=()
for path in "${required_exec[@]}"; do
  [[ -x "$path" ]] || not_exec+=("$path")
done

if ((${#not_exec[@]} > 0)); then
  echo "Template preflight FAILED: required scripts are not executable:"
  printf '  - %s\n' "${not_exec[@]}"
  exit 1
fi

echo "Template preflight PASS"
