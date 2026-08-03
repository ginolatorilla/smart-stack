# Glossary Module

Docs domain terms/meanings for consistency across ADRs, invariants, components, debt. Lighter module: single file, no ID, no ADR trace, lifecycle: current vs deprecated.

## 1. Discovery

Search:
- `docs/glossary.md`
- `docs/GLOSSARY.md`
- `docs/architecture/glossary.md`
- `GLOSSARY.md` @ root

If found: use it. Follow existing style.
If not: ask user (default `docs/glossary.md`).

**User instruction overrides all.**

No per-term filename/numbering.

## 2. Structure

Single file, terms as L2 headings, alphabetical:

```markdown
# Glossary

Domain terminology for {system}. If usage drifts from code, update code or this doc.

## {Term}

{Precise definition (1-3 sentences). Avoid generic textbook definitions.}

- **Owning component**: {link} <!-- optional -->
- **Aliases**: {aliases} <!-- optional, flag drift -->
- **Not to be confused with**: {term} <!-- optional -->

## {Next Term}

...
```

Short entries. Glossary is lookup ref, not design doc. Long explanations belong in ADR/component docs.

## 3. Drift Check

When adding/editing:
- Check for inconsistent usage in ADRs, invariants, components, debt.
- If drift found, flag to user; don't silently pick a side.
- Propose `Owning component` link; don't insert unasked.

## 4. Lifecycle

No separate ID/status frontmatter.

- **Current**: default.
- **Deprecated**: keep entry, mark `**(deprecated)**` in heading/definition. Note replacement.
- Editing existing definition requires user confirmation.
- Adding new terms/metadata doesn't need same level of confirmation, but show diff/addition.

## 5. Cross-linking

Mostly a target for links (other docs link *to* it). Main task: drift check in §3.

## 6. Checklist

- [ ] Location resolved
- [ ] Definition specific (no generic terms)
- [ ] Checked other docs for drift; flagged if found
- [ ] Owning component proposed only if clear
- [ ] Edits to existing definitions confirmed