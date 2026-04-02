# Transactional Email Flow (Analog)

Use this analog when a user-triggered flow validates context, prepares a durable artifact or shareable link, invokes an email provider, and must preserve resend, throttle, and error contracts across backend and frontend.

## When To Use

- Adding or changing a send/resend path for a document or resource
- Updating provider error semantics, duplicate-send throttling, or token/link reuse rules
- Wiring a UI action that confirms, sends, and reflects updated server state

## Canonical Examples / Example Slots

**Template:** replace angle-bracket placeholders with real paths after scaffold or adoption.

- Backend API route or handler: `<backend-api-path-for-send>`
- Orchestration service (validation, ordering, side effects): `<backend-service-path>`
- Frontend surface (confirm dialog, busy state, success/error mapping): `<frontend-component-or-screen-path>`
- Architecture or contract doc: `docs/ARCHITECTURE.md` (if present)
- Tests: `<backend-test-path>`, `<frontend-test-path>`

Do not treat this file as authoritative for your repo’s routes or filenames until you fill in real paths.

## Invariants (Typical Shape)

- Validate authorization and load send context before any provider call.
- Reject not-ready or invalid payloads before the provider call (with documented error semantics).
- Enforce duplicate-send or rate limits **before** the provider call when product policy requires it.
- If the flow creates or updates a shareable link or public token, define explicit ordering (for example share-then-send vs send-then-share) and keep it consistent across resend paths.
- Resend should not silently rotate an existing stable token unless the product contract explicitly allows it.
- Provider failure may leave prior durable state committed; avoid assuming an all-or-nothing rollback unless your layer uses real transactions and that is documented.
- Frontend: explicit confirmation before irreversible or provider-backed actions; disable conflicting actions while in flight.

## Allowed Deltas

- Copy, subjects, and template fields may vary by surface.
- Throttle windows and fallback timestamps may change when tests and architecture docs stay aligned.
- Frontend messaging may vary if externally visible API semantics stay intentional and documented.

## What Not To Assume

- Do not assume every document type shares the same public URL or CTA shape.
- Do not assume provider failure implies unchanged server state.
- Do not assume a successful provider response guarantees downstream analytics or audit persistence without checking your implementation.
- Do not assume UI strings can drift from API error codes without a deliberate contract change.

## Minimal Checklist

- Identify API entrypoint, orchestration owner, and UI caller.
- Confirm ordering for share/link creation vs provider send and for resend.
- Cover happy path, throttled/duplicate, validation failure, and provider failure in tests when practical.
- Update `docs/ARCHITECTURE.md` (or equivalent) when customer-visible behavior changes.

## Verification Guidance

- Run the Task’s **exact** verification commands from the issue (for example `make backend-verify`, `make frontend-verify`, or repo-specific targets).
- Add or extend targeted tests at the paths you listed in **Canonical Examples / Example Slots**.
