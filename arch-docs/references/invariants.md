# Invariants Module

Docs system-wide invariants: properties that must hold true at all times. Not component contracts or pre/post-conditions.

Every invariant **must trace to an ADR**. No ADR = no invariant.

## 1. Discovery

Search for existing invariants docs:
- `docs/invariants/`, `docs/architecture/invariants/`, or `*invariant*` with numeric prefix.

If found: infer filename pattern, ID/numbering, heading, structure. Follow convention.
If not: ask user (default `docs/invariants`, `INV-0001-title.md`).

**User instruction overrides all.**

## 2. The ADR-traceability gate (hard requirement)

Before drafting, determine backing ADR:
1. Ask user for the ADR.
2. Verify ADR actually supports the invariant.
3. If no ADR exists: **Do not create the invariant.** Offer to draft the ADR first.
4. Never invent/guess ADR IDs.

If the user insists on skipping, explain why it makes the doc unusable, but let them decide. Do not silently comply by fabricating links.

## 3. Template

```markdown
---
status: active
date: YYYY-MM-DD
established_by: ADR-XXXX
---

# INV-XXXX: {Short, falsifiable statement}

## Statement
{Precise, testable statement of what must always hold.}

## Scope
{What part of the system this applies to. Be explicit about what's NOT covered.}

## Rationale
{Short pointer to the reasoning in the ADR (1-3 sentences).}

## Established By
- ADR-XXXX: {short ADR title}

## Enforcement
{How it's enforced/verified (e.g. DB constraint, test, convention, or "not currently enforced").}

## Related
- Related component: {link}
- Related invariant: {link}
```

## 4. Lifecycle

Status: `active`, `retired`.

- **Active**: default.
- **Retired**: property no longer applies. Change `status` to `retired`, append reason + date. Do not delete file.
  - If retirement is due to new ADR, add `Retired by ADR-YYYY` link.
- **Never silently retire** existing invariants. Requires user confirmation.
- **Invariant violated in practice:** This is not a status change. Flag to user; suggest fixing the bug or retiring/revising the invariant via a new ADR.

## 5. Cross-linking

Scan for related ADRs, components, and other invariants. Propose links; don't insert unasked (except the required `Established By` link).

## 6. Checklist

- [ ] Convention resolved
- [ ] Backing ADR identified and verified
- [ ] Statement is precise/falsifiable
- [ ] Enforcement section reflects reality
- [ ] Related docs searched/proposed
- [ ] Edits to existing invariants confirmed