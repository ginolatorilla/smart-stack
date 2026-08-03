# Proposal-Generation Prompt (portable, for any LLM)

This is a self-contained prompt the user can copy into ChatGPT, another Claude session, or any other LLM to generate a new architecture proposal document in the format this skill expects. It is intentionally standalone — it does not assume the target LLM has access to this skill, arch-docs, or any tools.

Give the user this whole block (between the `-----` markers) to copy/paste, filled in with their specifics where noted, or as-is if they'd rather fill in the placeholders themselves in the other tool.

-----

You are helping me write a software/system architecture proposal document in Markdown. Follow this structure exactly, in this order. Do not skip sections — if a section doesn't apply, keep the heading and explicitly write "N/A" with a one-line reason, rather than omitting it.

**Ask me for any of the following if I haven't already provided them, before drafting:** the problem/goal driving this proposal, constraints (team size, existing stack, scale/latency requirements, budget, deadline, compliance), whether this is greenfield or a change to an existing system, and any decisions I already know need to be made.

Once you have enough context, produce a single Markdown document with these sections:

1. **Title** — `# [System/Feature Name] Architecture Proposal`, plus Author/Status/Date lines.
2. **Summary** — 2-4 sentences. Someone should understand the gist from this alone.
3. **Goals** — bullet list, concrete and measurable where possible (e.g. "support 10k concurrent connections," not "be scalable").
4. **Non-Goals** — explicitly out of scope, to prevent scope creep.
5. **Context** — what's driving this now; relevant existing-system details if not greenfield.
6. **Proposed Architecture** — prose description, followed by a diagram in a ```mermaid fenced code block (use `graph TD` or `graph LR` for components, `sequenceDiagram` for flows; keep it under ~12-15 nodes, split into multiple diagrams if needed). Walk through the diagram in prose after it.
7. **Key Decisions** — identify the 2-5 decisions that most shape this architecture (not every minor choice — only ones with real tradeoffs and long-term consequences). Present as a table: `| Decision | Choice | ADR |`. Leave the ADR column as `(not yet drafted)` for each row — actual ADRs are written separately by another process, not by you in this document.
8. **Alternatives Considered** — for the architecture as a whole, not individual decisions above. What else was considered, why not chosen.
9. **Risks and Tradeoffs** — what could go wrong, what are we knowingly giving up. Include operational, cost, and team/skillset risks, not just technical ones. A decision with no downside listed is a red flag — find the real cost.
10. **Rollout Plan** — phases, migration steps, rollback plan. Skip only if genuinely not applicable (e.g. pure greenfield with no migration), and say so explicitly rather than omitting the heading.
11. **Open Questions** — anything unresolved. It's fine to ship with open questions rather than blocking on resolving everything.

**Quality bar:**
- Every major claim should trace back to a stated goal or constraint — don't invent requirements I didn't give you.
- Be concrete and falsifiable ("p99 latency under 200ms," not "should be fast").
- Don't pad. A crisp, proportionate proposal beats a padded one — if I described a simple system, keep the doc simple; don't manufacture complexity or risk sections that don't apply.

When done, output the complete Markdown document in a single code block so I can copy it directly into a file.

-----

## How this fits into the skill

This prompt produces a proposal document with the same structure and Key-Decisions-table convention that `architecture-proposals` and `arch-docs` expect downstream (unresolved ADR links, one row per major decision). After the user generates a proposal with it, they save the file into their proposals directory (see SKILL.md step "Offer to help add a new proposal") and the rest of this skill's workflow — discovery, loading, handing off to arch-docs for ADR drafting — picks up from there unchanged.
