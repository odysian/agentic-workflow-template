# [PROJECT_NAME] Context

This file captures product/domain language for [PROJECT_NAME]. Keep it focused on terms users, domain experts, and product docs rely on. Do not use it as a module map, backlog, or architecture decision log.

## Language

**[Domain Term]**:
Short definition in product language.
_Avoid_: ambiguous synonym, implementation-only synonym

## Relationships

- A **[Domain Term]** relates to another **[Domain Term]** by ...

## Example Dialogue

> **Domain expert:** "..."
> **Developer:** "..."

## Flagged Ambiguities

- `[Ambiguous Term]`: clarify whether this means ...

---

Rules for maintaining this file:

- Define user/product concepts, not code modules.
- Keep entries short and concrete.
- Prefer the words users and domain experts actually use.
- Capture avoided synonyms when they prevent confusion.
- Update inline during planning when terms are resolved.
- Move unresolved terms to `Flagged Ambiguities` rather than hiding them in issue prose.
- Do not record architecture trade-offs here; use Decision Locks or ADRs.
