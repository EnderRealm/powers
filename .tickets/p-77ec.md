---
id: p-77ec
status: open
deps: [p-dd95]
links: []
created: 2026-01-26T00:06:31Z
type: task
priority: 2
assignee: Steve Macbeth
parent: p-19a2
---
# Create create-bug skill

Skill implementing the lean bug workflow

## Design

Files: skills/create-bug/SKILL.md, commands/create-bug.md
Flow phases:
1. Create ticket via tk create --type bug (initial symptoms)
2. Investigate (reproduce if possible via Puppeteer/CLI/code)
3. Fix
4. Test (verify bug gone using same reproduction steps)
5. Update ticket (root cause + what changed)
6. Commit [ticket-id] description
7. Push
No brainstorm/plan phases unless needed
Document root cause in ticket for learning corpus

## Acceptance Criteria

Skill executes bug flow, documents root cause, commits with correct format

