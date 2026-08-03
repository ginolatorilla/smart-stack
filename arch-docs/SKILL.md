---
name: arch-docs
description: Generate and maintain architecture documentation — Architecture Decision Records (ADRs), invariants, and component docs — with consistent conventions across a codebase or documentation corpus. Use this skill whenever the user asks to create, write, update, or manage an ADR, architecture decision record, design decision doc, invariant doc, or component/module documentation. Also use it when the user asks to supersede, deprecate, or obsolete an existing decision record, or to find/list/link existing ADRs, invariants, or components. Trigger even if the user doesn't say "ADR" explicitly — phrases like "document this decision", "why did we choose X over Y", "record this architecture choice", or "write up the reasoning for this design" should trigger the ADR module. Make sure to consult this skill before freehanding any architecture documentation, since it encodes numbering, filing, cross-linking, and obsoletion conventions that must stay consistent across the user's documentation corpus.
---

# Architecture Docs

Generates three related kinds of architecture documentation, each as its own module:

| Module | Status | Reference |
|---|---|---|
| ADRs (Architecture Decision Records) | **Active** | `references/adr.md` |
| Invariants | **Active** | `references/invariants.md` |
| Components | **Active** | `references/components.md` |
| Debt Register | **Active** | `references/debt.md` |
| Glossary | **Active** | `references/glossary.md` |

If the user asks for invariants or components docs and those modules aren't built yet, say so plainly and offer to draft that module now rather than improvising an undocumented format.

## Core principle: user instruction overrides detection

Across all modules: if the user explicitly states a convention (directory, filename format, numbering scheme, template fields), **use exactly what they said**, even if it conflicts with what's detected in the repo. Detection is a fallback for when the user hasn't specified — never a correction to what they did specify. If user instruction conflicts with detected repo convention, briefly note the mismatch once, then follow the user.

## Workflow for any architecture-doc request

1. **Identify which module** applies (ADR / invariant / component). If ambiguous, ask.
2. **Load that module's reference file** from `references/` before doing anything else — it has the full template, discovery steps, and lifecycle rules. Don't rely on memory of a prior conversation for template details; re-read the reference.
3. **Discover existing conventions** in the target repo/corpus per that module's discovery steps, unless the user already told you the convention (see above).
4. **Discover related docs** across *all* modules (not just the current one) so cross-references are complete — an ADR may relate to a component or invariant even if you're only asked to write the ADR.
5. **Draft the document**, present it to the user, and only then write the file.
6. **Never silently mutate existing documents.** Any edit to a pre-existing ADR/invariant/component file (status changes, added links, etc.) requires explicit user confirmation first — see each module's lifecycle section. The **only** exception in this entire skill is the bidirectional "Depended On By" bookkeeping in the components module (`references/components.md` §4), which is mechanical graph consistency, not a judgment call — it's still reported to the user in output, just not gated on confirmation.

## General cross-linking rule

When creating any architecture doc, scan sibling directories for the other doc types and check titles/frontmatter for topical overlap. If you find plausible relations, propose links to the user rather than inserting them unasked — false or irrelevant links are worse than missing ones.

If the corpus has a glossary (`references/glossary.md`), check whether domain terms used in the new doc are already defined there, and whether your usage matches the existing definition. Flag drift if you find a term used inconsistently — don't silently pick one meaning. Don't require a glossary to exist; it's the one module nothing else is gated on.

---

Start with `references/adr.md` for ADR work.
