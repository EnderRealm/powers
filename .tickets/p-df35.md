---
id: p-df35
status: open
deps: [p-2020]
links: []
created: 2026-02-08T20:06:13Z
type: chore
priority: 2
assignee: Steve Macbeth
parent: p-2f2f
---
# Run initial backfill of historical sessions

Execute catch-up script against all historical sessions to populate learnings repo with initial data

## Design

Run the catch-up script from p-2020 against all existing sessions in ~/.claude/projects/.
This populates the learnings repo with summaries for all prior sessions.
May take significant time depending on session count and Claude API throughput.
Run on each machine (Mac Studio, laptop) to cover all sessions.

## Acceptance Criteria

All historical sessions with meaningful content have summaries in the learnings repo

