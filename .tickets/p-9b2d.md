---
id: p-9b2d
status: closed
deps: [p-c156, p-5f5f, p-3c6d, p-2020]
links: []
created: 2026-02-08T20:06:48Z
type: chore
priority: 2
assignee: Steve Macbeth
parent: p-2f2f
---
# Set up Mac Studio cron jobs

Configure cron jobs on Mac Studio for nightly extraction, pattern detection, rollups, and catch-up

## Design

Repo: Manager (cron config or launchd plist)
Nightly job (runs once per day, e.g., 2am):
  1. Pull learnings repo
  2. Run catch-up script (summarize missed sessions on this machine)
  3. Run nightly extraction (process unprocessed summaries -> tickets)
  4. Run pattern detection (7-day window)
  5. Regenerate rollups (daily + weekly; monthly on Sundays; annual on 1st)
  6. Commit and push learnings repo (rebase + retry x3)
All steps in sequence. Partial failure is ok (next run picks up).
Log output for debugging.
Consider launchd over cron for macOS reliability.

## Acceptance Criteria

Cron/launchd job runs nightly on Mac Studio, executes full pipeline, logs output

