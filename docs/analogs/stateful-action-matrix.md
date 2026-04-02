# Stateful Action Matrix (Analog)

Use this analog when a screen or API surface exposes different actions, labels, disabled/hidden states, or side effects based on lifecycle status, permissions, or cross-layer rules.

## When To Use

- Adding or changing status-driven action visibility
- Changing which actions are enabled, disabled, or hidden during async mutations
- Introducing new outcomes or transitions while preserving parity across layers
- Refactoring a stateful surface without drifting contract semantics

## Canonical Examples / Example Slots

**Template:** replace angle-bracket placeholders with real paths after scaffold or adoption.

- Status or lifecycle helper (single source for “what state means” in UI): `<frontend-status-helper-path>`
- Action bar or primary/overflow actions: `<frontend-actions-component-path>`
- Backend transitions and invariants: `<backend-service-path>`
- Architecture or contract doc: `docs/ARCHITECTURE.md` (if present)
- Tests focused on action matrix parity: `<frontend-test-path>`, `<backend-test-path>`

## Invariants (Typical Shape)

- Derive action availability from a **small explicit model** (status + a few derived flags), not scattered ad-hoc checks.
- Backend rules for valid transitions remain authoritative; UI may smooth UX but must not invent impossible transitions.
- While a mutation is in flight, disable or queue conflicting actions to prevent double-submit races.
- Destructive or irreversible actions require explicit confirmation when your product standard demands it.
- After partial responses, merge or refetch so the UI does not drop fields still needed for the current view.

## Allowed Deltas

- Layout and labels may change if the action matrix and side effects remain intentional and tested.
- Local derived state is acceptable when it mirrors a server-backed transition already in flight or a strictly client-local concern (for example ephemeral preview state), and that boundary is clear.

## What Not To Assume

- Do not assume **hidden** and **disabled** are interchangeable; choose intentionally for discoverability vs safety.
- Do not assume all entity types share the same editability or resend rules.
- Do not assume a status change implies identical side effects on every surface.

## Minimal Checklist

- List authoritative statuses and derived flags before editing code.
- Write visible actions per state (matrix) and compare backend-allowed transitions.
- Verify busy states, confirmations, and error paths for each materially different state.
- Update docs when externally visible action or error semantics change.

## Verification Guidance

- Run the Task’s **exact** verification commands from the issue.
- Prefer tests that assert the matrix across **multiple** states, not only the default or happy path.
- For backend-coupled rules, run backend verification when status or side-effect logic changes.
