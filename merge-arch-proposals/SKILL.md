---
name: merge-arch-proposals
description: Locates/loads architecture proposals to use as context for arch-docs ADR drafting.
---

# Architecture Proposals

Discovers/loads proposal docs; hands context to **arch-docs**. Skill does NOT generate content; hands portable prompt (`references/proposal-generation-prompt.md`) if new proposal needed.

## Relationship to arch-docs

- This skill: **finds/reads** proposals.
- `arch-docs`: **writes** ADRs/invariants/components.

Use proposal content as background context for `arch-docs` ADR module (`references/adr.md`).

## When to use

- "Draft ADRs based on proposal for [X]"
- "What proposals exist for [X]?"
- "Load design doc for X and turn decisions into ADRs"
- "Summarize existing proposals"
- "I need to write a new architecture proposal"

## Workflow

### 0a. Ask folder location

- Use user-stated path.
- Else, ask user (default: `docs/proposals`).
- Fallback: check `docs/proposals/`, `docs/architecture/proposals/`, `proposals/`, or files matching `*proposal*`/`*RFC*`/`*design-doc*`.

### 0b. Offer new proposal

- If **no**: proceed to step 2.
- If **yes**:
  1. Provide prompt from `references/proposal-generation-prompt.md`.
  2. Instruct user to save Markdown to proposals folder.
  3. **Wait for explicit acknowledgement** before proceeding.

### 2. Locate proposal(s)

- List folder; identify matches by filename/content.
- Ask if ambiguous.
- Say if folder empty/missing.

### 3. Load/extract context

Read full proposal for:
- Goals, non-goals, constraints.
- "Key Decisions" section.
- "Alternatives Considered"/"Risks and Tradeoffs".
- Existing ADR links.

### 4. Hand off to arch-docs

- Follow `arch-docs` workflow exactly (discovery, MADR template, cross-linking).
- Use extracted context for "Decision Drivers" and "Considered Options".
- If proposal links to existing ADR, use it.
- If conflict found, ask user before writing (per `arch-docs` rules).

### 5. Output

- Present ADR via `arch-docs`.
- Note source proposal.
- Ask before editing proposal file to add ADR links.

## Quality bar

- No fabrication.
- No redundant info requests.
- Strict boundary: this skill reads/triggers; never authors content.
- Never skip step 0b wait.