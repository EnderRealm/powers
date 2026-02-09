---
id: p-5f5f
status: closed
deps: [p-c156]
links: []
created: 2026-02-08T20:06:32Z
type: task
priority: 2
assignee: Steve Macbeth
parent: p-2f2f
---
# Write pattern detection logic

Detect cross-session and cross-project patterns from session summaries using Claude

## Design

Repo: Manager (new script or module within nightly job)
Claude-powered pattern detection over 7-day rolling window of summaries.
Looks for:
  - Repeated unresolved problems across sessions
  - Similar discoveries in different projects
  - Recurring workflow friction
  - Common decision patterns (same trade-off recurring)
Pattern lifecycle: observation -> pattern -> actioned -> resolved
  - observation: first occurrence, watching for evidence
  - pattern: 3+ sessions or 2+ projects (guideline for Claude, not algorithmic)
  - actioned: tickets created
  - resolved: human decision
Pattern files: learnings/patterns/ptr-XXX.md with YAML frontmatter (id, status, first_seen, last_seen, occurrences, projects, tickets_created) and body (Description, Evidence, Suggested Action).
New patterns create observation files. Existing observations get updated evidence. Patterns meeting threshold get promoted.
See docs/LEARNING-EXTRACTION-DESIGN.md Pattern Detection section.

## Acceptance Criteria

Pattern detection runs against recent summaries, creates/updates pattern files with correct lifecycle, existing patterns accumulate evidence

