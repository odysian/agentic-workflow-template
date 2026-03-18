# Temporary Plan: Notion Feature Log v1 Trial (`~/vector-doc-qa`)

## Goal
Validate a simple Spec-driven Notion Feature Log workflow in a real project (`~/vector-doc-qa`) before adopting it as a template standard in this repo.

## Trial Scope
- In scope:
- Implement and run a v1 sync in `~/vector-doc-qa` using historical Spec issues/PRs.
- Confirm idempotent upserts and status transitions (`In progress` <-> `Shipped`).
- Confirm auto-managed fields update correctly and `My Notes` is preserved.
- Out of scope:
- Template repo standardization/commit in this pass.
- Weekly review automation, task rollups, multi-database setup, advanced backfill framework.

## Proposed v1 Design (for trial)
- Source of truth: GitHub issues labeled `type:spec`.
- Trigger events: `opened`, `reopened`, `edited`, `closed`.
- Notion database: single `Feature Log` DB.
- Auto-managed fields:
- `Title`, `Date`, `Status`, `Type`, `Area`, `Summary`, `Details`, `Spec`, `PRs`.
- Protected manual field:
- `My Notes` (never overwritten).
- Idempotency key:
- hidden Notion property `Sync Key` = `<owner>/<repo>:<spec_issue_id>`.

## Trial Execution Steps
1. Prepare Notion database
- Create `Feature Log` database with required properties.
- Add hidden `Sync Key` rich-text property for idempotent upsert.
- Configure select options:
- `Status`: `In progress`, `Shipped`
- `Type`: `Feature`, `Refactor`, `Infra`, `Fix`
- `Area`: at minimum `Backend`, `Frontend`, `Full stack`, `Eval`, `Observability`, `Other`

2. Implement minimal sync in `~/vector-doc-qa`
- Add workflow file: `.github/workflows/notion-feature-log.yml`
- Add sync script: `scripts/notion_feature_log_sync.py`
- Add core transform/parser module: `scripts/notion_feature_log_core.py`
- Add/update Spec issue template for parseable sections:
- `## Summary`
- `## Details`
- `## Type`
- `## Area`

3. Add tests in `~/vector-doc-qa`
- Add fixture-based tests for:
- opened spec event
- reopened spec event
- edited spec event
- closed spec event
- missing optional fields
- repeated same event idempotency
- `My Notes` preservation

4. Configure secrets in `~/vector-doc-qa`
- `NOTION_TOKEN`
- `NOTION_DATABASE_ID_FEATURE_LOG`

5. Run historical test pass (previous PRs/specs)
- Identify a small historical sample (5-10 closed Specs tied to known PRs).
- Replay/simulate payloads (or run targeted manual dispatches) to seed/update Notion.
- Verify rows are one-per-Spec and no duplicates are created on re-run.
- Spot-check that PR aggregation populates `PRs` with reliable links.

6. Validate live event behavior
- Open or edit a Spec -> row creates/updates as `In progress`.
- Close the same Spec -> same row updates to `Shipped` and sets `Date`.
- Reopen the Spec -> same row returns to `In progress` and keeps manual notes.

## Acceptance Criteria for Trial
- A `type:spec` issue creates exactly one Notion row.
- Reopen/edit/close updates the same row (no duplication).
- `Status` transitions are correct.
- `Date` is set from `closed_at` when shipped.
- `Summary` and `Details` come from Spec body sections.
- `My Notes` is never overwritten by automation.
- Implementation is simple enough to be maintained without extra framework code.

## Evidence to Capture
- Workflow run links/screenshots for each event type.
- Example Notion rows before/after close/reopen.
- Test output summary from `~/vector-doc-qa`.
- One short list of limitations observed (especially PR link discovery edge cases).

## Decision Gate (Adopt as Template Standard?)
- Adopt if all acceptance criteria pass and no major maintainability concerns appear.
- If issues are found, patch only the minimal blocking gaps, then re-run targeted checks.
- After successful trial, port the same minimal implementation into this template repo.

## Notes
- This is intentionally a temporary planning artifact for trial execution.
- Keep architecture boring and explicit; avoid abstraction until a real need appears.
