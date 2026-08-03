---
name: my-writing-style
description: Reproduce user's personal writing voice from samples. Trigger only on explicit request ("in my style", etc.). Maintains/updates profile via feedback.
---

# My Writing Style

Reproduces user's voice via profile built from samples and feedback.

## When to use

Only when explicitly invoked (e.g., "in my style"). Otherwise, write normally.

## Workflow

1. **Read profile** at `references/style-profile.md` (source of truth for structure, tone, formatting, vocab, and exclusions).

2. **If not seeded** (status "not yet seeded" or empty "Source samples"):
   - Do not attempt writing.
   - Ask user for 3-5 diverse samples (email, chat, doc, etc.).
   - Once received, add verbatim to "Source samples", derive "Observed patterns", and update status to "seeded".

3. **Apply profile**:
   - Match sentence structure/length.
   - Match formatting (prose vs lists, section labels, code, links).
   - Match tone (directness, hedging, warmth, contractions).
   - Match vocabulary (jargon, informal phrasing).
   - Avoid flagged patterns.

4. **Domain mismatch**: If domain (e.g. personal email) differs from profile (e.g. technical), apply closest patterns and flag domain gap.

5. **Feedback loop**: On feedback ("too formal", etc.), update `references/style-profile.md` under relevant pattern or "Open questions". Reproduce output.

6. **New samples**: Add verbatim to "Source samples" and update "Observed patterns".

## Notes

- Edits must be additive/specific.
- Organize by category (structure, formatting, tone, vocab, exclusions).
