# ADR Module

Gen ADRs (MADR default, repo convention fallback).

## 1. Discovery

Search for existing ADR location:
- `docs/decisions/`, `docs/adr/`, `doc/architecture/decisions/`, `adr/`, or `*ADR*`/`*adr-*`/`*decision*` with numeric prefix.

If found: infer filename pattern, ID/numbering, heading, status, next number. Follow convention.
If not: ask user (default `docs/decisions`, `ADR-0001-title.md`).

**User instruction overrides all.**

## 2. Cross-linking

Check for existing invariants/components docs. Propose links; don't auto-insert. Check for existing ADRs on same topic (for obsoletion).

## 3. MADR Template (default)

```markdown
---
status: proposed
date: YYYY-MM-DD
deciders: [names or roles]
---

# ADR-XXXX: {Short title}

## Status
{Proposed | Accepted | Rejected | Deprecated | Superseded by ADR-YYYY}

## Context and Problem Statement
{2–4 sentences}

## Decision Drivers
- {driver 1}
- {driver 2}

## Considered Options
- {option 1}
- {option 2}

## Decision Outcome
Chosen option: "{option}", because {justification}.

### Consequences
- Good, because {pos}
- Bad, because {neg}

## Pros and Cons
### {option 1}
- Good, because {arg}
- Bad, because {arg}

### {option 2}
- Good, because {arg}
- Bad, because {arg}

## Links
- Supersedes ADR-XXXX
- Superseded by ADR-XXXX
- Related invariant: {link}
- Related component: {link}
```

Note: Invariants require `established_by` ADR. Debt items (`origin: decided`) require backing ADR.

## 4. Lifecycle

Status: `proposed`, `accepted`, `rejected`, `deprecated`, `superseded by ADR-YYYY`.

- **IDs/files permanent.** No deleting/renumbering.
- **Superseding:** New ADR: `status: accepted` + `Supersedes ADR-XXXX`. Old ADR: `status: superseded by ADR-YYYY` + `Superseded by ADR-YYYY`.
- **Deprecating:** `status: deprecated` + reason/date.
- **Conflicts:** If existing ADR overlaps, ask user before writing/editing.
- **No silent edits.**

## 5. Checklist

- [ ] Convention resolved
- [ ] Next ID correct
- [ ] Related docs searched/proposed
- [ ] Supersession confirmed (if overlap)
- [ ] Edits confirmed