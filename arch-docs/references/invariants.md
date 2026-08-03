# Invariants Module

Documents **system-wide invariants**: properties that must hold true at all times across the system (e.g. "account balance is never negative", "every order has exactly one owning tenant"). Not component contracts or pre/post-conditions of a single function — those belong to the (future) components module.

Every invariant **must trace to an ADR**. An invariant without a decision behind it isn't documentable yet — see §2.

## 1. Discovery (run before drafting, unless user already specified everything)

Same pattern as ADR discovery (see `references/adr.md` §1), applied to invariants:

Search, in this order:
- `docs/invariants/`
- `docs/architecture/invariants/`
- Any directory with files matching `*invariant*` with a numeric or ID prefix

If found: infer filename pattern, ID scheme, heading structure, and next available number from 1–2 existing files. Follow that convention.

If not found: ask the user for directory (default `docs/invariants`) and filename format (default `INV-0001-title.md`, zero-padded to 4 digits, kebab-case title).

**User instruction always overrides detection** — same core principle as the rest of this skill.

## 2. The ADR-traceability gate (hard requirement)

Before drafting any invariant, determine which ADR establishes it:

1. Ask the user which ADR backs this invariant, if they haven't already said.
2. If they point to an existing ADR, open it and sanity-check it actually supports the claimed invariant — don't take the ID on faith if the content clearly doesn't establish it. If it doesn't fit, say so and ask for the right one rather than filing a mismatched link.
3. If **no ADR exists yet** for this invariant:
   - **Do not create the invariant doc.** This is a hard block, not a soft warning.
   - Tell the user plainly that invariants must trace to a decision record, and offer to draft the backing ADR first (hand off to `references/adr.md`).
   - Only proceed to the invariant once that ADR exists (freshly created or pre-existing) and its ID is known.
4. Never invent or guess an ADR ID to satisfy the link. A missing or fabricated citation is worse than stopping to ask.

This gate applies even under time pressure or if the user pushes back — if they insist on skipping it, explain once why the doc would be unusable (an untraceable invariant can't be understood or revisited later) and let them decide, but don't silently comply by fabricating a link.

## 3. Template

```markdown
---
status: active
date: YYYY-MM-DD
established_by: ADR-XXXX
---

# INV-XXXX: {Short, falsifiable statement of the invariant}

## Statement

{Precise, testable statement of what must always hold. Prefer a form that could be
turned into an assertion or test, e.g. "The sum of all ledger entries for a given
account always equals the account's displayed balance."}

## Scope

{What part of the system this applies to — services, data stores, boundaries.
Be explicit about what's NOT covered if that's likely to be assumed incorrectly.}

## Rationale

{Why this must hold — usually a short pointer, since the reasoning lives in the ADR.
1-3 sentences, not a restatement of the whole decision.}

## Established By

- ADR-XXXX: {short ADR title}

## Enforcement

{How this is (or should be) enforced or verified today — e.g. a DB constraint,
a runtime assertion, a test suite, code review convention, or "not currently
enforced, relies on convention." Be honest if enforcement is weak; that's useful
information, not a flaw to paper over.}

## Related

- Related component: {link} <!-- only if applicable -->
- Related invariant: {link} <!-- only if applicable -->
```

## 4. Lifecycle

Status values: `active`, `retired`.

- **Active**: the default state; the invariant is believed to hold and matters now.
- **Retired**: the invariant no longer applies — e.g. the system changed such that the property is no longer relevant or was replaced by a different invariant. Retiring is *not* the same as the invariant being violated (see below).
  - To retire: change only the `status` field to `retired`, append one line with reason + date. Do not delete the file or rewrite the body — same permanence rule as ADRs.
  - If retirement is because a new ADR changed the underlying decision, add `Retired by ADR-YYYY` as a link and note it in Established By's sibling context if useful.
  - **Never silently retire an existing invariant file** — requires explicit user confirmation first, same as ADR edits.
- **Invariant violated in practice** (the property doesn't actually hold, e.g. a bug broke it): this is not a status change. Flag it to the user in conversation and suggest they decide whether that's (a) a bug to fix so the invariant holds again, or (b) grounds to actually retire/revise the invariant via a new ADR. Don't silently mark it retired or violated in the doc yourself — that's a judgment call for the user, since it usually implies either an incident or a scope change.

## 5. Cross-linking

Same rule as the rest of the skill: scan for related ADRs, components, and other invariants; propose links, don't insert unasked (except the Established By link, which is required, not optional — see §2).

## 6. Output checklist before writing files

- [ ] Directory/filename convention resolved (user > detected > asked-and-defaulted)
- [ ] Backing ADR identified and verified to actually support the claimed invariant
- [ ] If no ADR exists, stopped and offered to draft one — did not proceed without it
- [ ] Statement is precise/falsifiable, not vague ("system is secure" is not an invariant)
- [ ] Enforcement section reflects reality, not aspiration
- [ ] Related docs searched; candidate links proposed to user
- [ ] Any edit to a pre-existing invariant file was explicitly confirmed by user before writing
