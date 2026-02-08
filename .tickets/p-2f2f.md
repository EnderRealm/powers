---
id: p-2f2f
status: open
deps: []
links: []
created: 2026-02-08T20:05:34Z
type: epic
priority: 2
assignee: Steve Macbeth
---
# Learning extraction system

Capture session knowledge, extract learnings into tickets, detect cross-project patterns, build rollups

## Design

Three-repo architecture: Powers (in-session hooks), Manager (nightly orchestration), learnings repo (data).
PreCompact prompt hook creates structured summary with sentinel markers during session.
SessionEnd command hook extracts summary from JSONL and pushes to learnings repo.
Catch-up script handles missed sessions and initial backfill.
Nightly cron processes summaries into tickets, detects patterns, generates rollups.
Full design: docs/LEARNING-EXTRACTION-DESIGN.md

## Acceptance Criteria

Sessions produce summaries in learnings repo, nightly job extracts learnings into tickets, patterns detected across projects, rollups generated at daily/weekly/monthly/annual levels

