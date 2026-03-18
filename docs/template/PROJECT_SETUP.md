# {{PROJECT_NAME}} — Project Setup Reference

## Purpose

Lock stack decisions, pinned versions, folder structure, environment variables, and dependency guardrails before implementation starts.

## 1. Framework Decision

- Decision:
- Why this option:
- Why alternatives were rejected:
- Non-negotiable constraints:

## 2. Runtime Versions (Pinned)

```text
Python:
Node:
```

Required repo files:
- `.python-version`
- `.nvmrc`
- frontend `package.json` `engines`

## 3. Backend Dependencies (Exact)

Provide exact pinned dependencies for:
- runtime
- test
- lint/type/security

Dependency guardrails:
- Explicitly list banned packages and why they are excluded.
- Include a verification grep command in scaffold kickoff.

## 4. Frontend Dependencies (Exact)

Provide exact pinned dependencies for:
- runtime
- dev/test/lint/build

## 5. Folder Structure

Define the full day-one tree (root, backend, frontend, docs, plans, scripts, `.github`).

Planning artifact convention:
- Use `plans/YYYY-MM-DD/<type>-<slug>.md`

## 6. Auth & Security Pattern

Document:
- token storage
- cookie settings
- CSRF model
- local vs production differences
- hashing algorithm requirements

## 7. Integrations Pattern

For each external dependency (AI/provider/storage/queue), document:
- module ownership/path
- validation requirements
- failure behavior expectations

## 8. Environment Variables

Define all required env vars with local defaults/placeholders.

## 9. CI Baseline

Define required CI workflows and exact commands per workflow.

## 10. Agent Must-Read Order

Define mandatory read order for this project.

## 11. Scaffold Verification Checklist

Must include:
1. unresolved template token check
2. banned dependency grep checks
3. pinned runtime file checks
4. required scaffold file existence checks
