# Proposal-Gen Prompt (LLM)

Copy block between `-----` to generate Markdown architecture proposal.

-----

You are helping me write a software/system architecture proposal document in Markdown. Follow this structure exactly, in this order. Do not skip sections — if a section doesn't apply, keep the heading and explicitly write "N/A" with a one-line reason, rather than omitting it.

**Ask me for any of the following if I haven't already provided them, before drafting:** the problem/goal driving this proposal, constraints (team size, existing stack, scale/latency requirements, budget, deadline, compliance), whether this is greenfield or a change to an existing system, and any decisions I already know need to be made.

Once you have enough context, produce a single Markdown document with these sections:

1. **Title** — `# [System/Feature Name] Architecture Proposal`, plus Author/Status/Date lines.
2. **Summary** — 2-4 sentences.
3. **Goals** — bullet list, concrete and measurable.
4. **Non-Goals** — explicitly out of scope.
5. **Context** — what's driving this now; relevant existing-system details if not greenfield.
6. **Proposed Architecture** — prose description, followed by a ```mermaid fenced code block (use `graph TD` or `graph LR` for components, `sequenceDiagram` for flows; keep it under ~12-15 nodes, split into multiple diagrams if needed). Walk through the diagram in prose after it.
7. **Key Decisions** — identify 2-5 decisions with real tradeoffs. Table: `| Decision | Choice | ADR |`. Leave ADR column as `(not yet drafted)`.
8. **Alternatives Considered** — what else was considered, why not chosen.
9. **Risks and Tradeoffs** — operational, cost, and team/skillset risks. Find real cost.
10. **Rollout Plan** — phases, migration steps, rollback plan. Skip only if genuinely not applicable, say so explicitly.
11. **Open Questions** — anything unresolved.

**Quality bar:**
- Trace claims to stated goals/constraints.
- Be concrete and falsifiable ("p99 latency < 200ms", not "should be fast").
- Don't pad. Crisp, proportionate proposal.

Once done, output complete Markdown document in single code block.

-----

## How this fits into the skill

Produces proposal with structure/Key-Decisions-table convention expected by `architecture-proposals` and `arch-docs` (unresolved ADR links, one row per major decision). User saves file to proposals directory (see SKILL.md step "Offer to help add a new proposal"). Downstream workflow (discovery, loading, handing off to `arch-docs` for ADR drafting) remains unchanged.
