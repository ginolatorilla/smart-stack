---
name: merge-arch-proposals
description: Locates/loads architecture proposals from a folder (asks where, defaults to docs/proposals) as context for arch-docs ADR drafting. On activation, confirms folder, offers portable prompt for new proposals (waits for user to save). If multiple proposals match, automatically merges them into an architecture overview (default docs/architecture-overview.md) via synthesis. Does NOT author new proposal content; only synthesizes existing ones. Trigger: "the proposal", "design doc", "RFC", "draft ADRs from proposal", "summarize proposals", "combined overview".
---

# Merge Architecture Proposals

Discovers/loads architecture proposals from a folder, then hands context to **arch-docs** for ADR drafting. This skill never authors *proposal* content: if a new proposal is needed, it provides a portable prompt (`references/proposal-generation-prompt.md`) for use in any LLM and waits for the user to save the result to the proposals folder.

**Exception:** If multiple proposals match, it automatically generates a merged **architecture overview** (synthesis of existing content, not new claims).

## Relationship to arch-docs

- This skill: **finds/reads** proposals.
- `arch-docs`: **writes** ADRs (templates, numbering, filing, lifecycle).

Use proposal content as background context (goals, constraints, options) for `arch-docs` ADR module (`references/adr.md`).

## When to use this

Trigger for:
- "Draft ADRs based on the proposal for [system]"
- "What proposals do we have for [topic]?"
- "Load the design doc for X and turn key decisions into ADRs"
- "Summarize our existing proposals"
- "I need to write a new architecture proposal for [system]"

## Workflow

Every activation starts with steps 0a and 0b.

### 0a. Ask where proposals live

- Use user-stated path if provided.
- Otherwise, ask user (default: `docs/proposals`).
- Fallback: check `docs/proposals/`, `docs/architecture/proposals/`, `proposals/`, or any dir with `*proposal*`, `*RFC*`, `*design-doc*`.

### 0b. Offer to add a new proposal

- If **no**: proceed to step 2.
- If **yes**:
  1. Provide portable prompt from `references/proposal-generation-prompt.md`.
  2. Instruct user to save result to the proposals folder.
  3. **Wait for explicit acknowledgement** before proceeding.

### 2. Locate relevant proposal(s)

- List folder contents; identify matches by filename/content.
- If ambiguous/multiple matches, ask user; don't guess.
- If folder is empty/missing, state plainly.

### 2b. Automatic merge (if multiple matches)

If >1 relevant proposal matches, automatically produce a merged **architecture overview** (default: `docs/architecture-overview.md`). Notify user of action.

**Structure:**
1. **Title** — `# Architecture Overview` + date + source links.
2. **Executive Summary** — 3-6 sentences for non-technical readers (scope, direction, major risks).
3. **Combined System Diagram** — Mermaid diagram merging components. Only add edges if explicitly stated in source text.
4. **Proposals Covered** — Short subsection per source (2-4 sentences each).
5. **Cross-Cutting Themes** — Shared decisions/risks/dependencies.
6. **Combined Key Decisions** — Table merging "Key Decisions" rows with a "Source" column.
7. **Open Questions** — Merged/deduplicated list.

**Hard rules:**
- No fabrication: all content must trace to source proposals.
- No silent overwrites: ask before replacing existing overview files.
- Merge is a living summary, not a proposal (no ADR links/Key-Decisions-table-with-unresolved-ADR-links).

### 3. Load and extract context

Read matched proposals for:
- Goals, non-goals, constraints.
- "Key Decisions" (for ADR drafting).
- "Alternatives Considered" / "Risks and Tradeoffs".
- Existing ADR links.

### 4. Hand off to arch-docs

For each decision:
- Follow `arch-docs` workflow exactly (`references/adr.md`).
- Use extracted context for "Decision Drivers" and "Considered Options".
- If an ADR already exists for a topic, verify via `arch-docs` discovery; if contradictory, ask user before proceeding.

### 5. Output

Present ADRs via `arch-docs` + note source proposals. Do not silently modify proposal files.

## Quality bar

- No fabrication: if rationale is thin, ask user instead of inventing.
- No redundant info: don't re-ask for folder or info already in proposals.
- Strict boundary: this skill reads proposals and triggers ADR drafting; it never authors new proposal content.
- Wait for acknowledgement in step 0b.
