---
name: "Task"
about: "Small implementable unit that becomes a PR"
title: "Task: "
labels: ["type:task"]
---

## Goal
What should exist when this is done?
Default: this Task should represent the entire feature end-to-end unless split criteria apply.

## Scope
**In:**
-

**Out:**
-

## Implementation notes
-

## Decision locks (backend-coupled only)
- [ ] Locked: <decision 1>
- [ ] Locked: <decision 2>

## Acceptance criteria
- [ ] ...

## Verification Tier

Select one tier from `docs/workflow/VERIFY.md`:

- [ ] Tier 1 (targeted checks only)
- [ ] Tier 2 (single-surface checks)
- [ ] Tier 3 (cross-layer changed surfaces)
- [ ] Tier 4 (full verification)

## Verification Plan

### Tier 1 (targeted examples)

```bash
# backend-only example
{{BACKEND_VERIFY_COMMANDS}}

# frontend-only example
{{FRONTEND_VERIFY_COMMANDS}}
```

### Tier 2 (single-surface examples)

```bash
# backend-focused surface
{{BACKEND_VERIFY_COMMANDS}}

# frontend-focused surface
{{FRONTEND_VERIFY_COMMANDS}}
```

### Tier 3 (default cross-layer)

```bash
{{BACKEND_VERIFY_COMMANDS}}
{{FRONTEND_VERIFY_COMMANDS}}
```

### Tier 4 (full suite)

```bash
{{VERIFY_COMMANDS}}
```

## PR checklist
- [ ] PR references this issue (`Closes #...`)
- [ ] Docs updated if needed (architecture/patterns/review checklist/ADR)
- [ ] Tests added/updated where needed
