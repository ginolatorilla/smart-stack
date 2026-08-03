# ADR Module

Generates Architecture Decision Records using the **MADR** (Markdown Any Decision Records) format as the default, adapted to match an existing repo's convention when one is detected.

## 1. Discovery (run before drafting, unless user already specified everything)

Search the target repo/corpus, in this order, for an existing ADR location:

- `docs/decisions/`
- `docs/adr/`
- `doc/architecture/decisions/`
- `adr/`
- Any directory containing files matching `*ADR*`, `*adr-*`, `*decision*` with a numeric prefix

If found:
- Open 1–2 existing files to infer: filename pattern, ID/numbering scheme (zero-padded? sequential? date-based?), heading structure, status vocabulary, and next available number.
- Follow that convention for the new file, even if it isn't MADR — don't force MADR fields onto a repo using a different format. Note the deviation to the user in one line so they know why the output doesn't look like the MADR template below.

If not found:
- Ask the user for: directory (default `docs/decisions`) and filename format (default `ADR-0001-title.md`, zero-padded to 4 digits, kebab-case title).
- Use the MADR template below.

**User instruction always overrides both of the above** — see SKILL.md's core principle.

## 2. Discover related docs (for cross-linking)

Regardless of whether invariants/components modules exist yet as skill modules, check whether the corpus *has* invariant or component documentation (common locations: `docs/invariants/`, `docs/components/`, `docs/architecture/`, `README.md` files per module). If titles or content overlap with the new ADR's topic, list them as candidate links under "Related" — propose, don't auto-insert.

Also check for **existing ADRs on the same topic** — this matters for obsoletion (see §4).

## 3. MADR Template (default when no repo convention detected)

```markdown
---
status: proposed
date: YYYY-MM-DD
deciders: [names or roles]
---

# ADR-XXXX: {Short title, decision-oriented, e.g. "Use PostgreSQL for primary datastore"}

## Status

{Proposed | Accepted | Rejected | Deprecated | Superseded by ADR-YYYY}

## Context and Problem Statement

{2–4 sentences: what's the issue, framed as a question if useful.}

## Decision Drivers

- {driver 1, e.g. a force, requirement, or constraint}
- {driver 2}

## Considered Options

- {option 1}
- {option 2}
- {option 3}

## Decision Outcome

Chosen option: "{option}", because {justification — shortest sufficient reason}.

### Consequences

- Good, because {positive consequence}
- Bad, because {negative consequence}

## Pros and Cons of the Options

### {option 1}

- Good, because {argument}
- Bad, because {argument}

### {option 2}

- Good, because {argument}
- Bad, because {argument}

## Links

- Supersedes ADR-XXXX <!-- only if applicable -->
- Superseded by ADR-XXXX <!-- filled in later, at obsoletion time -->
- Related invariant: {link} <!-- only if applicable -->
- Related component: {link} <!-- only if applicable -->
```

Note: the invariants module requires every invariant to trace back to an ADR (`established_by`). If this ADR establishes a system-wide property that should hold going forward, mention to the user that it could be worth documenting as an invariant — but don't create one unasked.

Note: if this ADR's "Bad, because..." consequences describe a known cost being knowingly accepted, mention to the user that it could be worth logging as a debt item (`references/debt.md`, `origin: decided`) — but don't create one unasked.

Fields to trim for lightweight decisions: "Pros and Cons of the Options" detail section is optional if the Decision Outcome justification is already clear — don't pad it out artificially. Keep "Decision Drivers" and "Considered Options" even for simple ADRs; they're what make the record useful later.

## 4. Lifecycle and obsoletion

Status values: `proposed`, `accepted`, `rejected`, `deprecated`, `superseded by ADR-YYYY`.

Rules:

- **IDs and files are permanent.** Never delete, renumber, or move an old ADR when it's obsoleted. History (and any external references/links to it) must stay valid.
- **Superseding an ADR** (new decision replaces an old one):
  1. Draft and confirm the new ADR first.
  2. New ADR: `status: accepted`, with a `Supersedes ADR-XXXX` link.
  3. Old ADR: change only its `status` field to `superseded by ADR-YYYY` and add a `Superseded by ADR-YYYY` link. Do not rewrite or "clean up" any other part of the old document — it's a historical record.
- **Deprecating without a replacement** (decision no longer applies, nothing replaces it): status → `deprecated`, plus one appended line noting the reason and date. No link required.
- **Detecting conflicts proactively:** when drafting a new ADR, if discovery (§2) surfaces an existing ADR that appears to address the same decision area with a contradictory outcome, **stop and ask the user to confirm** whether this new ADR supersedes it before writing or editing anything. Do not auto-mark supersession, even when the overlap looks obvious — this is a hard rule, not a heuristic to relax under confidence.
- **Never silently edit an existing ADR file.** Any status change to a pre-existing file happens only after the user has explicitly confirmed it in this conversation.

## 5. Output checklist before writing files

- [ ] Directory/filename convention resolved (user > detected > asked-and-defaulted)
- [ ] Next ID number correctly determined (no collision with existing files)
- [ ] Related docs searched; candidate links proposed to user, not assumed
- [ ] If topical overlap with an existing ADR was found, supersession explicitly confirmed by user
- [ ] Any edit to a pre-existing file was explicitly confirmed by user before writing
