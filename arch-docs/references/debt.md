# Debt Register Module

Docs known tech debt: fragile/wrong/suboptimal things, why they exist, trigger to fix. Mirror of ADR: ADR records decision; debt records acknowledged cost or discovered problem.

## 1. Discovery

Search for existing debt docs:
- `docs/debt/`, `docs/tech-debt/`, `docs/architecture/debt/`, or `*debt*` with numeric prefix.

If found: infer filename pattern, ID/numbering, heading, structure. Follow convention.
If not: ask user (default `docs/debt`, `DEBT-0001-title.md`).

**User instruction overrides all.**

## 2. Origin: decided vs. discovered

Every debt item has `origin` field: `decided` or `discovered`.

- **`decided`** — known consequence of decision (e.g. ADR "Bad, because..." or deliberate shortcut). **Requires backing ADR** (see `references/invariants.md` §2):
  1. Ask which ADR establishes it.
  2. Verify ADR supports claimed debt.
  3. If no ADR exists, don't create as `origin: decided`. Offer to draft ADR or reconsider origin.
- **`discovered`** — found (e.g. refactor, incident) with no traceable decision. **No ADR required.**

Do not guess origin. Do not fabricate ADR links for `discovered` debt.

## 3. Template

```markdown
---
status: open
origin: decided   <!-- or: discovered -->
date: YYYY-MM-DD
established_by: ADR-XXXX   <!-- required if origin: decided; omit if origin: discovered -->
---

# DEBT-XXXX: {Short, specific description}

## Description
{What's wrong/suboptimal. Be concrete.}

## Origin
{If decided: link to ADR + tradeoff. If discovered: how/when/by whom.}

## Impact
{Cost today: slower dev, risk, friction, etc. Be honest.}

## Trigger to Address
{Condition to fix: e.g. "if we add X", "if incident rate > Y". Makes it actionable.}

## Related
- Established by: ADR-XXXX <!-- if origin: decided -->
- Related component: {link}
- Related invariant: {link}
```

## 4. Lifecycle

Status: `open`, `resolved`, `wont-fix`.

- **Open**: default.
- **Resolved**: debt paid/fixed. Append how/when (and PR/commit link). Keep file (historical record).
- **Wont-fix**: decision to accept debt permanently. Append reason/date.
- Changing status on existing item requires user confirmation.

## 5. Cross-linking

Scan for related ADRs, components, and invariants. Propose links; don't auto-insert (except required `established_by` for `decided` origin).

## 6. Checklist

- [ ] Convention resolved
- [ ] Origin set (`decided` or `discovered`) — not guessed
- [ ] If `decided`: backing ADR identified and verified
- [ ] Trigger to Address is concrete
- [ ] Related docs searched/proposed
- [ ] Edits to existing items confirmed