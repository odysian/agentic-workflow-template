#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/gh_preflight.sh [--quiet]

Checks:
  1. DNS resolution for api.github.com
  2. GitHub CLI auth validity
  3. GitHub API reachability via gh api rate_limit
EOF
}

QUIET=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --quiet)
      QUIET=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if ! command -v gh >/dev/null 2>&1; then
  [[ "$QUIET" -eq 1 ]] || echo "FAIL: gh command not found" >&2
  exit 1
fi

dns_ok=0
if command -v getent >/dev/null 2>&1; then
  if getent hosts api.github.com >/dev/null 2>&1; then
    dns_ok=1
  fi
elif command -v host >/dev/null 2>&1; then
  if host api.github.com >/dev/null 2>&1; then
    dns_ok=1
  fi
fi

if [[ "$dns_ok" -ne 1 ]]; then
  [[ "$QUIET" -eq 1 ]] || echo "FAIL: DNS resolution failed for api.github.com" >&2
  exit 1
fi

if ! gh auth status -h github.com >/dev/null 2>&1; then
  [[ "$QUIET" -eq 1 ]] || echo "FAIL: gh auth status failed (invalid/expired token or auth missing)" >&2
  exit 1
fi

if ! gh api rate_limit >/dev/null 2>&1; then
  [[ "$QUIET" -eq 1 ]] || echo "FAIL: gh api rate_limit failed (GitHub API unreachable)" >&2
  exit 1
fi

[[ "$QUIET" -eq 1 ]] || echo "PASS: gh preflight checks succeeded"
