# Architecture Corpus Analysis

Corpus: docs, repo, API specs, schemas, IaC, or text.

If empty, ask user. Default `/docs`. Walk path (`ls`/`find`/`view`). Read all.
Read all before planning. Plan must trace to corpus.

## Extraction

| Signal | Source | Target |
|---|---|---|
| Components | Diagrams, lists, structure | WBS |
| Data flows | Diagrams, API, schemas | Dependency, risk |
| External deps | APIs, SDKs, ADRs | Risk, critical path |
| Decisions | ADRs | Assumptions, scope |
| Alternatives | ADRs | Risk |
| NFRs | Perf/scale/security | Acceptance, testing |
| Open items | Anywhere | Assumptions |
| Ownership | CODEOWNERS, authors | Resource, RACI |
| Timelines | Roadmaps, milestones | Roadmap anchor |

## Gaps

If thin/missing:
- State in Executive Summary.
- Ask min needed for WBS.
- Mark inferred boundaries `[inferred]`.

## Traceability

Cite source inline: `Task (source: file.md)`.