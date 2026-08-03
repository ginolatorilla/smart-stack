---
name: merge-arch-proposals
description: Locates and loads existing software/system architecture proposal documents from a proposals folder (default docs/proposals) to use as context when drafting Architecture Decision Records (ADRs) via the arch-docs skill. Use this skill whenever the user references "the proposal," "the design doc," "the RFC," or asks to draft ADRs "based on" or "from" an architecture proposal, or wants to find/list/summarize existing proposal docs. This skill does NOT write or generate new proposal documents — it only discovers and reads existing ones. If the user wants a brand-new proposal authored from scratch with no existing doc to read, this skill doesn't apply; only arch-docs (for the resulting ADRs) is relevant. Trigger even if the user doesn't say "proposal" explicitly — phrases like "using our design doc for X, draft the ADRs" or "what proposals do we have on file" should trigger this skill.
---

# Merge Architecture Proposals

Discovers and loads existing architecture proposal documents from a proposals folder, then hands that context to the **arch-docs** skill to draft the resulting ADRs. This skill does not author proposal documents — only arch-docs authors ADRs, and only the user (or another process) authors proposals.

## Relationship to arch-docs

- This skill: **finds and reads** proposal docs.
- `arch-docs`: **writes** ADRs (and invariants/components), owning all template, numbering, filing, cross-linking, and lifecycle rules.

Once a relevant proposal is loaded, treat its content as background context (goals, constraints, options already explored) when invoking arch-docs's ADR module (`references/adr.md`) — don't re-derive decision drivers from scratch if the proposal already states them.

## When to use this

Trigger for requests like:
- "Draft ADRs based on the proposal for [system]"
- "What proposals do we have for [topic]?"
- "Load the design doc for X and turn the key decisions into ADRs"
- "Summarize our existing proposals"

Don't use for: authoring a brand-new proposal document from scratch (not supported by this skill — if no proposal exists yet, that's out of scope here; only the ADR drafting via arch-docs applies once decisions are otherwise identified), quick one-off code snippets, non-architectural technical questions, or building/physical architecture.

## Workflow

### 1. Resolve the proposals folder

- If the user states a folder explicitly, use exactly that — never override a stated path.
- Otherwise, check for a proposals folder in this order:
  - `docs/proposals/`
  - `docs/architecture/proposals/`
  - `proposals/`
  - Any directory with files matching `*proposal*`, `*RFC*`, `*design-doc*`
- If none of the above exist, default to `docs/proposals` and say so explicitly before proceeding (don't silently assume — one line noting the default is enough).

### 2. Locate the relevant proposal(s)

- List the folder's contents and identify candidate file(s) matching the user's topic (by filename and, if ambiguous, by opening and checking titles/headers).
- If the user's request doesn't map cleanly to one file (multiple plausible matches, or none), ask rather than guessing — don't silently pick one.
- If the folder is empty or doesn't exist even after defaulting, say so plainly. Don't fabricate a proposal to fill the gap — that's out of scope for this skill.

### 3. Load and extract context

Read the matched proposal(s) in full. Pull out what's relevant for ADR drafting:
- Stated goals, non-goals, and constraints
- The "Key Decisions" section, if present, which typically enumerates the decisions needing ADRs
- Any "Alternatives Considered" or "Risks and Tradeoffs" content relevant to a given decision
- Existing links to ADRs already drafted (avoid duplicating those; note if a linked ADR already covers what the user is asking for)

### 4. Hand off to arch-docs for ADR drafting

For each decision the user wants documented:

- Load `arch-docs`'s `SKILL.md` and `references/adr.md` and follow its workflow exactly — discovery of ADR directory/numbering conventions, MADR template, cross-linking, and lifecycle/supersession rules. Do not improvise ADR structure here.
- Feed the context extracted in step 3 into arch-docs's "Decision Drivers" and "Considered Options" fields rather than re-inventing them, but still verify against the proposal's actual wording rather than assuming.
- If the proposal's "Key Decisions" table already links to an ADR path for this decision, that's very likely the correct target file/number — use arch-docs's discovery to confirm rather than picking a new number blind.
- If arch-docs's discovery surfaces an existing ADR on the same topic with a contradictory outcome, stop and confirm supersession with the user before writing anything (per arch-docs's hard rule) — do not resolve this yourself.

### 5. Output

Present the drafted ADR(s) via arch-docs's normal output, plus a short note on which proposal(s) they were sourced from. If the proposal's "Key Decisions" table doesn't yet link to the new ADR(s), point this out to the user and ask before editing the proposal file yourself — this skill does not silently modify proposal documents.

## Quality bar

- Never fabricate proposal content that isn't actually in the loaded file — if the proposal is thin on a decision's rationale, say so and ask the user to fill the gap rather than inventing drivers/options.
- Don't re-ask the user for information the proposal already states.
- Keep the boundary strict: this skill reads proposals and triggers ADR drafting; it does not write, edit, or restructure proposal documents.
