# Embedding Jira Agent Instructions in project-plan.md

Human-readable markdown + machine-actionable XML comments. Downstream Jira-automation agent/MCP tool/script parses XML to create epics/issues.

## Placement

- `<!-- jira:epic ... -->` after WBS epic heading.
- `<!-- jira:issue ... -->` after task row context, OR batched `<!-- jira:issues-bulk -->` end of epic section. Bulk preferred.
- `<!-- jira:project ... -->` once near top with project metadata.

Comments invisible in rendered markdown.

## Schema

### Project block (once, near top)

```xml
<!-- jira:project
key: "<PROJECT_KEY or TBD>"
name: "<project name>"
default_issue_type: "Story"
epic_link_field: "customfield_10014"
labels: ["planned-by-claude"]
-->
```

### Epic block (after `### E<n>. <name>` heading)

```xml
<!-- jira:epic
id: "E1"
summary: "<epic name>"
description: |
  <outcome statement from WBS>
  Source: <corpus citation or "derived from request">
labels: ["<domain>"]
-->
```

### Bulk issues block (end of epic section)

```xml
<!-- jira:issues-bulk
epic: "E1"
issues:
  - id: "E1.1"
    summary: "<task>"
    issue_type: "Task"
    assignee_role: "<role>"
    estimate: "3d"
    depends_on: []
    labels: []
-->
```

### Dependency edges (once, after dependency graph)

```xml
<!-- jira:dependencies
edges:
  - from: "E1"
    to: "E2"
    type: "blocks"
-->
```

### Milestones → Jira

```xml
<!-- jira:milestones
milestones:
  - name: "M1: Foundations ready"
    target: "<date/Wk N>"
    exit_criteria: "Schema frozen, CI green"
    epics: ["E1"]
-->
```

## Rules

- IDs (`E1`, `E1.1`) must match WBS table and XML blocks (join key).
- Use YAML in XML comments.
- Use `TBD` or `"unknown - agent should discover via API"` for Jira keys/IDs.
- `summary` < 80 chars.
- Regenerate XML block if markdown edits change task details.