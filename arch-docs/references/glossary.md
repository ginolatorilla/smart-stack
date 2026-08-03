# Glossary Module

Documents **domain terms** and their precise meanings within this system — a shared vocabulary so "Order," "Tenant," or "Session" mean one thing consistently across ADRs, invariants, components, and debt items. This module is intentionally lighter than the others: single file, no ID scheme, no required ADR trace, no lifecycle beyond "current" vs "deprecated term."

## 1. Discovery (run before drafting, unless user already specified everything)

Search, in this order:
- `docs/glossary.md`
- `docs/GLOSSARY.md`
- `docs/architecture/glossary.md`
- `GLOSSARY.md` at repo root

If found: use that file. Follow its existing heading/entry style rather than imposing the template below wholesale — adapt to match.

If not found: ask the user for location (default `docs/glossary.md`).

**User instruction always overrides detection.**

Unlike the other modules, there's no per-term filename or numbering to resolve — it's one file, so discovery is really just "find the file or agree where to create it."

## 2. Structure

Single file, terms as level-2 headings, alphabetically ordered:

```markdown
# Glossary

Domain terminology for {system/project name}. If a term is used differently in
code than defined here, this doc is the source of truth — update code or update
this doc, don't let them drift.

## {Term}

{Precise definition — 1-3 sentences. Prefer definitions specific enough to rule
out plausible-but-wrong readings, not textbook-generic ones.}

- **Owning component**: {link, if one component is the authority on this term} <!-- optional -->
- **Aliases**: {other names this concept goes by in the codebase, if any} <!-- optional, flag if this indicates drift worth fixing -->
- **Not to be confused with**: {a similar term that means something different} <!-- optional, but valuable when confusion is likely -->

## {Next Term}

...
```

Keep entries short. The glossary is a lookup reference, not a design doc — if a term needs paragraphs of explanation, that's a sign it deserves its own ADR or component doc, and the glossary entry should just define the term and link out.

## 3. No required linkage, but check for drift

No ADR or other doc is required to add a glossary term — definitions can simply reflect current usage. However, when adding or editing a term:

- Check whether the term appears in existing ADRs, invariants, components, or debt items with an inconsistent meaning. If you find drift (the term is used two different ways across docs), flag it to the user explicitly rather than silently picking one definition — this is exactly the kind of inconsistency the glossary exists to catch, so surface it rather than papering over it.
- If a term is clearly owned by one component (i.e. that component's doc is the natural authority on what it means), propose linking `Owning component` — don't insert it unasked, standard rule.

## 4. Lifecycle

Simpler than other modules — no separate ID/status frontmatter needed per term, since it's all one file. Within an entry:

- **Current usage**: the default — just a definition, no marker needed.
- **Deprecated term**: if a term is no longer used but might still appear in old docs/code, keep the entry (don't delete — same permanence spirit as other modules) but mark it clearly, e.g. prepend `**(deprecated)**` to the heading or definition, note what replaced it if applicable.
- Editing an **existing** entry's definition (changing what a term means, not just adding a new one) requires explicit user confirmation — this is a substantive change to a shared reference, not mechanical bookkeeping.
- Adding a brand-new term, or adding optional metadata (aliases, owning component) to an entry that didn't have it, doesn't need the same level of confirmation as changing an existing definition — but still show the user the diff/addition before writing, as with all modules.

## 5. Cross-linking

Lighter than other modules: the glossary is mostly a target for links (other docs link *to* glossary terms), not a heavy source of outbound links itself. The main proactive check is the drift check in §3.

## 6. Output checklist before writing files

- [ ] File location resolved (user > detected > asked-and-defaulted)
- [ ] Definition specific enough to rule out plausible misreadings, not generic
- [ ] Checked other docs (ADRs, invariants, components, debt) for inconsistent usage of this term; flagged drift if found
- [ ] Owning component proposed only if genuinely clear, not assumed
- [ ] Any edit to an existing entry's definition was explicitly confirmed by user before writing
