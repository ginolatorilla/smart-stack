---
name: merge-arch-proposals
description: Locates and loads software/system architecture proposal documents from a proposals folder (asks the user where, defaulting to docs/proposals) to use as context when drafting Architecture Decision Records (ADRs) via the arch-docs skill. On every activation, first confirms the proposals folder location, then offers a portable prompt (for use in any LLM) to generate a new proposal if one doesn't exist yet, and waits for the user to save it before continuing. Use whenever the user references "the proposal," "the design doc," "the RFC," asks to draft ADRs "based on" or "from" a proposal, wants to find/list/summarize existing proposals, or wants to add a new one. This skill does NOT generate proposal content itself — it hands the user a portable prompt to run elsewhere and only reads the result. Trigger even without the word "proposal" — e.g. "using our design doc for X, draft the ADRs," "what proposals do we have on file," or "I need to write a new architecture proposal."
---

# Architecture Proposals

Discovers and loads architecture proposal documents from a proposals folder, then hands that context to the **arch-docs** skill to draft the resulting ADRs. This skill never generates proposal content itself: if the user needs a new proposal, it hands them a portable prompt (`references/proposal-generation-prompt.md`) to run in any LLM, and waits for them to save the result into the proposals folder before continuing.

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
- "I need to write a new architecture proposal for [system]"

Don't use for: quick one-off code snippets, non-architectural technical questions, or building/physical architecture. Note that "write a new proposal" requests ARE in scope for this skill (via step 0b's portable-prompt handoff) — this skill just never generates the proposal content directly in-conversation.

## Workflow

Every activation of this skill starts with steps 0a and 0b below, before anything else — even if the user's request sounds like it only needs step 2 (e.g. "what proposals do we have?"). This keeps the folder location and the add-new-proposal offer consistent regardless of entry point.

### 0a. Ask where proposals live (or use the default)

- If the user has already stated a folder (this turn or earlier in the conversation), use exactly that — never override a stated path, and don't re-ask.
- Otherwise, ask the user where their proposals live, offering `docs/proposals` as the default if they don't have a preference. Don't silently assume without asking at least once per conversation.
- If they don't answer or say "just use the default," proceed with `docs/proposals`.
- (Detected-convention fallback: if the folder truly can't be resolved via the question above — e.g. a non-interactive context — check `docs/proposals/`, `docs/architecture/proposals/`, `proposals/`, or any directory with files matching `*proposal*`, `*RFC*`, `*design-doc*`, before defaulting to `docs/proposals`.)

### 0b. Offer to add a new proposal first

Before proceeding to locate/load anything, ask the user whether they want to add a new proposal to the folder first (in case the one they need doesn't exist yet, or they want to add a fresh one alongside existing ones).

- If **no** / not needed: continue straight to step 2.
- If **yes**:
  1. Give the user the portable generation prompt from `references/proposal-generation-prompt.md` (the block between the `-----` markers), for them to run in any LLM of their choice.
  2. Instruct them to save the resulting Markdown document into the proposals folder resolved in step 0a, using a descriptive filename.
  3. **Wait for their explicit acknowledgement that they've done this** before proceeding — do not move on to step 2 speculatively or assume the file now exists. If they come back with a filename or say "done," treat that as acknowledgement and continue.
  4. Once acknowledged, continue with the rest of the workflow (step 2 onward), which will pick up the newly added file during discovery.

This skill still does not author proposal content itself — the portable prompt is designed to be run elsewhere (or pasted into a fresh conversation) precisely so that proposal-writing stays out of this skill's own generation path.

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
- Don't re-ask the user for information the proposal already states, and don't re-ask for the folder location more than once per conversation.
- Keep the boundary strict: this skill reads proposals and triggers ADR drafting; it never authors proposal content itself, even when the user explicitly wants a new proposal — that always routes through the portable prompt in step 0b.
- Never skip the wait-for-acknowledgement in step 0b. Proceeding to discovery before the user confirms the file is saved risks silently operating on stale or missing data.
