---
name: arch-docs
description: Gen/maint arch docs (ADR, invar, comp) w/ consistent convs. Trigger on: create/write/update/manage ADR/invar/comp docs, supersede/deprecate/obsolete records, find/list/link. Trigger on: "document decision", "why X over Y", "record choice", "write reasoning". Consult skill first to ensure consistent numbering, filing, cross-linking, obsoletion.
---

# Arch Docs

3 modules:

| Mod | Status | Ref |
|---|---|---|
| ADRs | **Active** | `references/adr.md` |
| Invariants | **Active** | `references/invariants.md` |
| Components | **Active** | `references/components.md` |
| Debt | **Active** | `references/debt.md` |
| Glossary | **Active** | `references/glossary.md` |

If invar/comp modules missing: state plainly, offer draft. No improvisation.

## Principle: User > Detection

User convention (dir, file, num, template) overrides repo detection. Detection = fallback. If conflict: note mismatch once, then follow user.

## Workflow

1. **Identify module** (ADR/invar/comp). Ambiguous? Ask.
2. **Load ref** from `references/` first. Use ref template/rules, not memory.
3. **Discover conventions** in target repo/corpus.
4. **Discover related docs** across ALL modules for cross-refs.
5. **Draft**, present, then write.
6. **No silent mutation.** Edits (status, links, etc.) need user confirmation. Exception: mechanical "Depended On By" in components (reported, not gated).

## Cross-linking

Scan sibling dirs for other doc types. Propose links; don't insert unasked. Check `references/glossary.md` for term consistency. Flag drift. No glossary? No problem.

---

Start: `references/adr.md` for ADR.
