# Code Review Report

**Generated:** <YYYY-MM-DD hh:mm:ss>
**Repository:** <repo name / path>
**Mode:** <Diff review: `<current-branch>` vs `<base-branch>`> | <Full codebase review>

## Scope & Methodology

- Run mode: <Interactive | Non-interactive>
- Base branch: <name, or "N/A — full codebase review">
- Merge base commit: <sha, or "N/A">
- Files reviewed: <count>, <how enumerated — git diff / git ls-files / directory walk, any exclusions>
- Architecture corpus: <`docs/architecture` | user-provided: `<path>` | "Skipped — no architecture corpus" | "Skipped at user's request" | "Skipped — none found, ran non-interactively">
- Priority: Architecture → Tests → Code (skill default)

<Include only if non-interactive with fallback defaults — omit otherwise.>

### Auto decisions (non-interactive mode)

| Decision point | Default | Reason |
|---|---|---|
| <e.g. "Base branch selection"> | <e.g. "Used `main`"> | <e.g. "Multiple candidates; `main` is standard fallback"> |

<repeat per decision>

**Double-check anything in this table before relying on the review.**

## Summary

| Severity | Count |
|---|---|
| Critical | <n> |
| High | <n> |
| Medium | <n> |
| Low | <n> |

<2-4 sentence overview: reviewed what, headline risk, general state.>

---

## 1. Architecture Conformance

<If skipped, state plainly and stop section.>

### Finding: <short title>
- **Severity:** <Critical/High/Medium/Low> — <one-line justification>
- **Location:** `<file>:<line(s)>`
- **Architecture ref:** `<doc path / section / ADR>`
- **Issue:** <code does vs. architecture specifies>
- **Evidence:** <quoted/paraphrased rule + code ref>

<repeat per finding; if none, say "No architecture conformance issues found" explicitly>

---

## 2. Tests

### Finding: <short title>
- **Severity:** <...> — <justification>
- **Location:** `<file/test file>`
- **Issue:** <missing coverage / weak assertion / deleted/skipped test / etc.>
- **Untested / what to add:** <specifics>

<repeat per finding; if none, say so explicitly, note overall coverage>

---

## 3. Code Quality & Implementation

Group findings by sub-dimension. Omit only if genuinely nothing found —
state explicitly rather than silently omitting.

### 3.1 Correctness
<findings>

### 3.2 Security
<findings>

### 3.3 Performance
<findings>

### 3.4 Load / Concurrency
<findings>

### 3.5 Data Integrity
<findings>

### 3.6 General Implementation Quality (style, duplication, readability)
<findings — lower severity by default>

Each finding:
- **Severity:** <...> — <justification>
- **Location:** `<file>:<line(s)>`
- **Issue:** <description>
- **Why it matters:** <concrete consequence — not generic>

---

## 4. Needs Your Judgment

Ambiguous items **not** resolved unilaterally. For each:

### Question: <specific question>
- **Context:** <files/finding this relates to>
- **Evidence for one reading:** <...>
- **Evidence for the other reading:** <...>
- **Leaning (optional, not verdict):** <if genuinely useful>

<If nothing ambiguous, state explicitly — don't omit section.>

---

## Appendix: Files Reviewed

<list files in scope, or pointer to diff/command used to generate list if large>
