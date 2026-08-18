---
name: code-review
description: Review git repo diff (current vs base branch) or full codebase. Checks architecture conformance, tests, code quality, security, performance, concurrency, data integrity. Priorities: (1) architecture, (2) tests, (3) quality. Never edits files — writes timestamped report to .agent-artifacts/. Use for "review my code/PR/branch/changes," "code review," "check this diff," or pre-merge audit.
---

# Code Review

Thorough code review skill. Reviews branch diff or full codebase, checks against project
architecture (if exists), writes report. Never edits source files. Surfaces all ambiguous
choices — never decides silently.

Works in any harness with shell commands + file I/O: interactive chat, CLI agent, or
non-interactive CI. Maps generic actions (`ASK`, `WRITE FILE`, `SURFACE`) to whatever
mechanism is available.

## Adapting to your environment

Three generic actions — map to your harness:

- **ASK** (present choice, wait for decision) — use interactive input tool, or ask in plain
  text and wait for next message. In **non-interactive** environments (CI pipeline, one-shot
  script, `--yes`/`--non-interactive` mode, no input mechanism): do NOT block. Apply the
  **stated fallback default** for each ASK point (documented below), record every default
  used in "Decisions made automatically (non-interactive mode)" section at report top, with
  reason. Never invent decisions silently — report must state what was decided + why.
- **WRITE FILE** (create report) — use whatever file-write tool is available (editor,
  `cat > file <<'EOF'`, scripting language's file write). Constraint: only report file is
  created; no existing repository file is modified or deleted.
- **SURFACE** (hand report back) — use harness's file-preview/attachment mechanism if
  available. Otherwise, print report path + short summary to stdout/chat. Always print path
  plainly for recoverability even if rich-display fails.

## Core principles (read before starting)

1. **Read-only on codebase.** Never modify, move, or delete any file except the report.
   This skill produces a report, not a fix.
2. **Never decide silently.** More than one reasonable path (which base branch, whether to
   use architecture corpus, how to treat ambiguous finding) = ASK point (see above). In
   interactive mode: wait for real answer. Do not guess and proceed.
3. **Priority order governs everything**: (1) Architecture conformance, (2) Tests, (3) Code
   quality/implementation. Determines finding order + conflict resolution (e.g., clever code
   violating architecture > inelegant but architecturally sound code).
4. **Judge, don't pattern-match.** Finding only real if you can point to specific evidence
   (file, line, rule) — don't flag superficial anti-pattern matches. Surface genuinely
   uncertain items as questions in the report; don't silently decide they're fine.

## Step 1 — Establish scope: diff vs. full codebase

Run read-only shell checks:

```bash
git rev-parse --is-inside-work-tree 2>/dev/null   # confirms it's a git repo
git branch --show-current                          # current branch
git branch -a                                      # all branches, to find a plausible base
```

**Determine the base branch:**
- Look for common base branch in `git branch -a` output: `main`, `master`, `develop`,
  `trunk` (preference order), or upstream tracking via
  `git rev-parse --abbrev-ref --symbolic-full-name @{u}` if set.
- If exactly one candidate found and current branch differs, **ASK**:
  "Review your branch `<current>` against `<candidate>`?" Options: use `<candidate>`, use a
  different base branch, review entire codebase.
  *Non-interactive default:* use `<candidate>`.
- If **multiple** candidates, **none** found, or not a git repo, **ASK** what to do —
  options: name a base branch, or review whole codebase.
  *Non-interactive default:* not a git repo → review whole codebase. Git repo but ambiguous
  base → prefer `main`, else `master`, else `develop`, else `trunk`, else fall back to
  whole codebase review.
- If base branch selected, confirm it exists + has merge-base with current branch
  (`git merge-base <base> <current>`); if not, treat as "none found" and re-resolve (ask
  again if interactive, apply fallback if not).

**Once scope is settled:**
- Diff mode: `git diff <merge-base>...<current> --stat` then full diff
  (`git diff <merge-base>...<current>`) for changed files, plus `git diff --name-status` to
  classify added/modified/deleted files. Read full contents of changed files (not just diff
  hunks) when surrounding context is needed to judge correctness.
- Full-codebase mode: enumerate source files with `git ls-files` (respects .gitignore) if
  git repo, or plain directory walk otherwise (e.g. `find . -type f`). Skip binary files,
  lockfiles, vendored/generated directories (`node_modules`, `dist`, `build`, `vendor`,
  `.venv`, etc.).

Never run git commands that mutate state (no `checkout`, `merge`, `reset`, `stash`,
`add`, `commit`, `push`, `pull`). Read-only inspection only.

## Step 2 — Locate the architecture corpus

Check for `docs/architecture` (directory) at repo root.

- **Found:** read contents recursively (list directory, then read relevant files — markdown,
  ADRs, diagrams-as-text, etc.). Treat as source of truth for architectural rules,
  boundaries, layering, naming/module conventions, intended data flow.
- **Not found:** do not assume no architecture docs elsewhere, do not silently skip.
  **ASK**: "I couldn't find `docs/architecture`. How should I handle architecture conformance
  in this review?" Options: give another directory, skip architecture review, or look for
  architecture docs elsewhere (root-level `ARCHITECTURE.md`, `README` design sections,
  `docs/adr`, `docs/design`, etc.).
  *Non-interactive default:* look for common alternate locations; if found, use it + note
  substitution in report; if none found, skip architecture review, mark section "Skipped —
  no architecture corpus found, ran non-interactively."
  - If directory is given/found, read it in place of `docs/architecture`.
  - If skipped (by choice or default), mark Architecture section in report accordingly; do
    not fabricate architectural findings.

## Step 3 — Review, in priority order

Evaluate only what's in scope (the diff, or full codebase). In diff mode: read enough
surrounding/imported code to judge correctness — changed function correctness often depends
on callers or shared state not visible in the diff alone.

### 3.1 Architecture conformance (priority 1)

Only if a corpus was found or provided. For each changed/reviewed area, check:
- Does it respect documented module/layer boundaries (e.g., UI code reaching directly into
  a data layer the architecture says should be mediated by a service)?
- Does it follow documented naming, directory structure, or dependency-direction rules?
- Does it introduce a new pattern where the architecture prescribes an existing one (new
  HTTP client instead of the shared one, new error-handling convention, etc.)?
- Does it contradict any explicit constraint or decision recorded in an ADR?

For every finding, cite the specific architecture doc/section + specific code location. If
the architecture corpus is silent on something, don't invent a rule — note the gap instead
of flagging a violation.

### 3.2 Tests (priority 2)

- Tests covering the changed/reviewed behavior? Identify what's untested.
- Existing tests assert meaningful behavior, or shallow (e.g. no-throw only, snapshot tests
  with no real assertions, disabled/skipped tests)?
- Tests cover edge cases relevant to the change: empty/null inputs, concurrency,
  failure/error paths, boundary values?
- Bug fixes: regression test?
- Flag tests deleted or weakened as part of the change — high priority, not a footnote.

### 3.3 Code quality / implementation (priority 3)

Cover all of the following — don't drop any silently:

- **Correctness**: logic errors, off-by-one, incorrect assumptions, unhandled branches.
- **Security**: injection (SQL/command/template), unsafe deserialization, auth/authz gaps,
  secrets in code, unsafe user input use, insecure defaults, dependency risk if visible.
- **Performance**: obvious algorithmic issues (N+1 queries, unbounded loops over large data,
  quadratic behavior where linear is feasible), unnecessary blocking I/O, missing
  pagination/streaming for large datasets.
- **Load / concurrency behavior**: race conditions, missing locking/transactions where
  needed, shared mutable state, non-idempotent operations that should be idempotent (e.g.
  retried webhook handlers), resource exhaustion under load (unbounded queues/connections).
- **Data integrity**: transaction boundaries, partial-write/rollback handling, validation at
  trust boundaries, migrations that could lose or corrupt data.
- **General implementation quality**: error handling, readability, dead code, duplication,
  consistency with surrounding code style — keep lower-weight than the above; style nit ≠
  security or data-integrity finding. Report should reflect severity difference, not list
  everything flatly.

### 3.4 Judgment calls — always surface, never resolve silently

Genuinely ambiguous cases (e.g., "is this N+1 query actually a problem at this data
volume?", "is this missing test acceptable because the behavior is trivial?", "does this
violate the architecture doc, or is the doc just outdated?"). For each:
- Do **not** decide and present only your conclusion.
- Put in distinct **"Needs your judgment"** section with the specific question, evidence on
  both sides, and (if genuinely useful) a leaning — framed as a leaning, not a verdict.
- If ambiguity is severe enough to change the review's shape (e.g., "half these findings
  assume this table is high-write; is that true?") and environment is interactive, **ASK**
  before finalizing the report rather than only noting it. In non-interactive mode, note
  it prominently in the report + proceed.

## Step 4 — Severity

Four levels, applied consistently: **Critical** (data loss, security hole, architecture
violation that breaks a hard boundary), **High** (likely bug, missing test for critical
path, meaningful performance/load risk), **Medium** (real but contained issue), **Low**
(style/consistency/nice-to-have). Every finding gets exactly one severity + one-line
justification for why it's at that level — severity should never be a default label.

## Step 5 — Write the report (never touch existing files)

Determine the timestamp with the shell:

```bash
mkdir -p .agent-artifacts
date +"%Y-%m-%d-T-%H-%M-%S"
```

**WRITE FILE** to `.agent-artifacts/review-<YYYY-MM-DD-T-hh-mm-ss>.md`. Must not already
exist; if collision occurs (e.g. two runs in the same second), regenerate the timestamp.
Do not create, modify, or delete any other file in the repository.

Use `references/report-template.md` as the structure for the report — read it before
writing so section order + headings match (a "Decisions made automatically" section if
running non-interactively; architecture, then tests, then code, matching the priority order;
a "Needs your judgment" section; a scope/methodology section documenting exactly what was
diffed or walked and what architecture source was used).

## Step 6 — Present

After writing the report:
- **SURFACE** the report file per the environment's capability; always print its path
  plainly regardless.
- Short prose summary (not a re-dump of the whole report): counts by severity, the single
  most important finding, explicitly call out anything in "Needs your judgment" — and, if
  running non-interactively, anything in "Decisions made automatically" — that a human
  should weigh in on.
- Do not ask "want me to fix these?" as a throwaway — if fixes are requested afterward,
  that's a separate, explicit new task; this skill's job ends at the report.
- Exit/return successfully once the report is written, even if findings include Critical
  items — this skill reports, it does not gate or fail a build. If invoked from a CI
  context that wants a failing exit code on Critical/High findings, that policy belongs
  in the calling script, not in this skill.

## Notes

- If repo has no `.gitignore`-respecting way to enumerate files and full-codebase mode is
  huge (thousands of files): if interactive, **ASK** whether to scope down (e.g. to a
  subdirectory) before proceeding; if non-interactive, proceed but note the scale + note
  that a targeted re-run against a subdirectory is recommended, in the report.
- If `.agent-artifacts` is itself gitignored or new: fine — it's an output directory, not a
  source file, so creating it doesn't violate the read-only constraint.
- Nothing in this skill depends on any specific vendor's tool names or APIs. If a capability
  described here (shell access, file read/write, interactive input) isn't available at all
  in your environment, say so explicitly rather than attempting a partial, silently-degraded
  review.
