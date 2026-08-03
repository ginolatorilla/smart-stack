# Debt Register Module

Documents **known technical debt**: things the team knows are fragile, wrong, or suboptimal, why they exist, and what would trigger fixing them. This is the mirror image of an ADR — an ADR records a decision going forward; a debt item often records the *acknowledged cost* of that decision, or a problem discovered independently of any decision.

## 1. Discovery (run before drafting, unless user already specified everything)

Same pattern as the other modules:

Search, in this order:
- `docs/debt/`
- `docs/tech-debt/`
- `docs/architecture/debt/`
- Any directory with files matching `*debt*` with a numeric or ID prefix

If found: infer filename pattern, ID scheme, heading structure, next available number. Follow that convention.

If not found: ask the user for directory (default `docs/debt`) and filename format (default `DEBT-0001-title.md`, zero-padded to 4 digits, kebab-case title).

**User instruction always overrides detection.**

## 2. Origin: decided vs. discovered (this determines the ADR gate)

Every debt item has an `origin` field: `decided` or `discovered`.

- **`decided`** — this debt is a known consequence of a specific decision (e.g. an ADR's "Bad, because..." consequence, or a deliberate shortcut taken to hit a deadline that someone consciously signed off on). **Requires a backing ADR** — same hard-block gate as the invariants module (see `references/invariants.md` §2):
  1. Ask which ADR establishes this debt, if not already stated.
  2. Verify the ADR actually supports the claimed debt (open it, sanity-check) rather than trusting the ID on faith.
  3. If no such ADR exists, **do not create the debt item as `origin: decided`.** Either offer to draft the ADR first, or ask whether this is actually `origin: discovered` instead (it may be that no one ever formally decided this — that's fine, it just changes the origin field).
- **`discovered`** — nobody made an explicit decision that produced this; it was found (e.g. during a refactor, incident review, or code read) with no traceable originating choice. **No ADR required.** Still worth noting *how* it was discovered and by whom/when, since that's useful provenance even without a decision trail.

Do not guess which origin applies — ask if it's not obvious from context. Do not fabricate or force-fit an ADR link to make `discovered` debt look like `decided` debt.

## 3. Template

```markdown
---
status: open
origin: decided   <!-- or: discovered -->
date: YYYY-MM-DD
established_by: ADR-XXXX   <!-- required if origin: decided; omit entirely if origin: discovered -->
---

# DEBT-XXXX: {Short, specific description of the debt}

## Description

{What's actually wrong or suboptimal. Be concrete — "the auth module has no tests"
is more useful than "auth needs work."}

## Origin

{If origin: decided — one line pointing to the ADR and the tradeoff it accepted.}
{If origin: discovered — how/when/by whom this was found, and best guess at how
long it's been there if relevant.}

## Impact

{What this actually costs today — slower development, incident risk, onboarding
friction, performance, etc. Be honest about severity; don't inflate or downplay.}

## Trigger to Address

{What condition would make this worth fixing — e.g. "if we add a second auth
provider," "if incident rate in this area exceeds X," "next time this file is
touched for unrelated work." A debt item without a trigger is just a complaint;
the trigger is what makes it actionable later.}

## Related

- Established by: ADR-XXXX <!-- only if origin: decided -->
- Related component: {link} <!-- only if applicable -->
- Related invariant: {link} <!-- only if applicable, e.g. debt that risks violating one -->
```

## 4. Lifecycle

Status values: `open`, `resolved`, `wont-fix`.

- **Open**: default; debt is known and unaddressed.
- **Resolved**: the debt has been paid down / fixed. Append a line noting how and when (and a PR/commit link if useful and available). Keep the file — same permanence rule as every other module — don't delete it; a resolved debt item is a useful record that the cost was real and got addressed.
- **Wont-fix**: a decision was made to accept this debt permanently rather than address it. This itself is a small decision — if it's significant, consider whether it warrants its own ADR, but don't require one; use judgment and ask the user if unsure. Append the reason and date.
- Changing status on an **existing** debt item requires explicit user confirmation before writing, same as every other module in this skill.

## 5. Cross-linking

Standard rule: scan for related ADRs, components, and invariants; propose links, don't insert unasked (except the required `established_by` link when `origin: decided`, which follows the same non-negotiable rule as the invariants module).

## 6. Output checklist before writing files

- [ ] Directory/filename convention resolved (user > detected > asked-and-defaulted)
- [ ] Origin field set (`decided` or `discovered`) — not guessed
- [ ] If `decided`: backing ADR identified and verified to actually support the claimed debt
- [ ] If `decided` and no ADR exists: stopped, offered to draft one or reconsider origin — did not proceed without resolving this
- [ ] Trigger to Address is concrete, not vague
- [ ] Related docs searched; candidate links proposed to user
- [ ] Any edit to a pre-existing debt item was explicitly confirmed by user before writing
