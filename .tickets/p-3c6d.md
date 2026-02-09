---
id: p-3c6d
status: closed
deps: [p-c156]
links: []
created: 2026-02-08T20:06:40Z
type: task
priority: 2
assignee: Steve Macbeth
parent: p-2f2f
---
# Write rollup generation logic

Generate daily, weekly, monthly, and annual rollup summaries from session data

## Design

Repo: Manager (new script or module within nightly job)
Rollup levels and inputs:
  - Daily: session summaries from that day -> rollups/daily/YYYY-MM-DD.md
  - Weekly: daily rollups from that week -> rollups/weekly/YYYY-WNN.md
  - Monthly: weekly rollups from that month -> rollups/monthly/YYYY-MM.md
  - Annual: monthly rollups from that year -> rollups/annual/YYYY.md
Regeneration: each level regenerated fresh from inputs until period ends, then immutable.
Nightly job regenerates: current day daily, current week weekly.
Weekly job regenerates: current month monthly.
Monthly job regenerates: current year annual.
Rollup format: YAML frontmatter (level, date, projects, sessions, patterns_active) + body (Summary, Key Outcomes, Decisions Made, Open Items, Patterns).
See docs/LEARNING-EXTRACTION-DESIGN.md Rollups section for format example.

## Acceptance Criteria

Rollups generated at all four levels from correct inputs, immutable after period ends, format matches design spec

