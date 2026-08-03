# Components Module

Documents **service/module boundaries**: what a component is responsible for, how other things talk to it, and what it depends on. Not pre/post-condition contracts (that level of detail belongs in the component's own interface docs/code, not here) and not system-wide properties (those are invariants).

Unlike invariants, components do **not** require a backing ADR — a component doc can simply describe what currently exists. If an ADR *does* explain why the component is shaped the way it is, link it; don't require it.

## 1. Discovery (run before drafting, unless user already specified everything)

Same pattern as the other modules:

Search, in this order:
- `docs/components/`
- `docs/architecture/components/`
- Any directory with files matching `*component*` with a numeric or ID prefix, or a per-component subdirectory layout (e.g. `docs/architecture/<component-name>.md`)

If found: infer filename pattern, ID scheme (if any — components are often named rather than numbered, unlike ADRs/invariants), heading structure. Follow that convention.

If not found: ask the user for directory (default `docs/components`) and filename format. Components are commonly named rather than sequentially numbered — default to `<kebab-case-name>.md` (e.g. `docs/components/payment-service.md`) unless the user wants ID prefixes like the other modules.

**User instruction always overrides detection** — same core principle as the rest of this skill.

## 2. Template

```markdown
---
status: active
date: YYYY-MM-DD
---

# {Component Name}

## Responsibility

{1-3 sentences: what this component owns and why it exists. Should be specific
enough that you could say what does NOT belong here.}

## Interfaces

{How other things interact with this component — APIs, events published/consumed,
CLI, library entry points. List the surface, not full API docs (link out if a
full spec exists elsewhere).}

## Depends On

- {Component X} — {why / what for}
- {External system Y} — {why / what for}

## Depended On By

<!-- Maintained automatically as other component docs are created — see §4.
     Do not hand-edit unless correcting an inaccuracy. -->

- {Component A}
- {Component B}

## Invariants Upheld

{Required section — always include, even if empty. List invariants this component
is responsible for maintaining. If none apply, state that explicitly rather than
omitting the section — an empty-but-present section signals it was considered,
not overlooked.}

- INV-XXXX: {short description} <!-- omit this bullet entirely if none apply -->

## Related

- Related ADR: {link} <!-- only if an ADR explains this component's shape -->
- Related component: {link} <!-- for relationships that aren't strict dependencies -->
```

## 3. The invariants check (required consideration, not required linkage)

Before finishing a component doc:

1. Search existing invariant docs (`references/invariants.md`'s discovery locations) for any whose scope plausibly includes this component.
2. For each plausible match, propose it to the user rather than assuming — "This looks like it should uphold INV-0003 (X). Include it?"
3. Always render the "Invariants Upheld" section, even if the answer is "none apply" — write that explicitly (e.g. "No system-wide invariants currently apply to this component.") so a reader knows the question was asked, not skipped.
4. This is lighter than the invariants module's ADR gate: there's nothing to block on. The obligation is to *check and record the answer*, not to require a match.

## 4. Dependency consistency (bidirectional)

Components form a graph; keep both directions consistent:

- When creating or editing Component A's doc and it lists Component B under **Depends On**:
  1. Check whether B's doc exists and already lists A under **Depended On By**.
  2. If B's doc exists but is missing the back-reference, **add it automatically** — this specific edit (appending A to B's "Depended On By" list) doesn't need confirmation, since it's mechanical bookkeeping, not a judgment call. Mention in your output that you updated B's doc and why.
  3. If B's doc doesn't exist yet, note that in your output (don't fabricate a stub file unasked) and offer to create it.
- **Scope of the silent-edit exception:** it applies *only* to appending/removing entries in "Depended On By" to keep the graph consistent. It does not extend to any other field — status changes, responsibility rewrites, or anything else on another component's doc still require explicit user confirmation, same as ADRs and invariants.
- If editing A's doc removes a dependency on B, remove the corresponding back-reference from B's doc the same way (auto, mentioned in output) — don't leave stale edges.

## 5. Lifecycle

Status values: `active`, `deprecated`, `retired`.

- **Active**: default; the component exists and is in use as described.
- **Deprecated**: still exists/running but shouldn't be built on further (e.g. being phased out). Note the replacement if there is one.
- **Retired**: no longer exists in the system. Keep the doc (historical record, same permanence rule as ADRs/invariants) but mark retired with date + reason.
- Changing status on an **existing** component doc requires explicit user confirmation, same as everywhere else in this skill. The bidirectional dependency bookkeeping in §4 is the *only* silent-edit exception in this entire skill — don't generalize it to status or content changes.
- Retiring or deprecating a component may orphan other components' "Depends On" entries pointing at it — flag those to the user rather than editing them; whether the dependent components need rework is a judgment call, not bookkeeping.

## 6. Cross-linking

Standard rule: scan for related ADRs, invariants, and other components; propose links (except the bidirectional dependency back-reference in §4, and the "Invariants Upheld" section which must always be rendered per §3).

## 7. Output checklist before writing files

- [ ] Directory/filename convention resolved (user > detected > asked-and-defaulted)
- [ ] Responsibility statement specific enough to imply what's out of scope
- [ ] Invariants considered and section rendered either way (populated or explicit "none apply")
- [ ] Dependency graph checked bidirectionally; back-references added/removed as needed and reported to user
- [ ] Any edit beyond the "Depended On By" bookkeeping was explicitly confirmed by user before writing
- [ ] If retiring/deprecating, checked for and flagged any orphaned dependents
