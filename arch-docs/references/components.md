# Components Module

Docs service/module boundaries: responsibility, interfaces, dependencies. Not pre/post-condition contracts or system-wide invariants.

Unlike invariants, components don't require a backing ADR.

## 1. Discovery

Search for existing component docs:
- `docs/components/`, `docs/architecture/components/`, or `*component*` files.

If found: infer filename pattern, ID/naming, heading, structure. Follow convention.
If not: ask user (default `docs/components`, `<kebab-case-name>.md`).

**User instruction overrides all.**

## 2. Template

```markdown
---
status: active
date: YYYY-MM-DD
---

# {Component Name}

## Responsibility
{1-3 sentences: ownership and scope.}

## Interfaces
{APIs, events, CLI, etc. List surface, not full spec.}

## Depends On
- {Component X} — {why}
- {External system Y} — {why}

## Depended On By
<!-- Maintained automatically for graph consistency. -->
- {Component A}
- {Component B}

## Invariants Upheld
{Required section. List invariants or state "none apply".}
- INV-XXXX: {description}

## Related
- Related ADR: {link}
- Related component: {link}
```

## 3. Invariants Check

Before finishing:
1. Search existing invariants for plausible matches.
2. Propose match to user (e.g., "Include INV-0003?").
3. Always render "Invariants Upheld" section (even if empty).

## 4. Dependency Consistency (Bidirectional)

Keep graph consistent:
- If A depends on B, and B exists, add A to B's "Depended On By" list automatically (no confirmation needed for this mechanical edit).
- If A's dependency on B is removed, remove back-reference from B (auto, reported).
- All other edits (status, responsibility, etc.) require user confirmation.

## 5. Lifecycle

Status: `active`, `deprecated`, `retired`.

- **Active**: default.
- **Deprecated**: still running, but phasing out. Note replacement.
- **Retired**: no longer exists. Keep doc as historical record.
- Changing status on existing doc requires user confirmation.

## 6. Cross-linking

Scan for related ADRs, invariants, and components. Propose links.

## 7. Checklist

- [ ] Convention resolved
- [ ] Responsibility specific
- [ ] Invariants considered/rendered
- [ ] Dependency graph checked bidirectionally
- [ ] Edits beyond "Depended On By" confirmed
- [ ] Orphaned dependents flagged if retiring/deprecating