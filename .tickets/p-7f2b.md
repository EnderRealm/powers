---
id: p-7f2b
status: open
deps: [p-dd95]
links: []
created: 2026-01-26T00:06:23Z
type: task
priority: 2
assignee: Steve Macbeth
parent: p-19a2
---
# Create create-feature skill

Skill implementing the full feature workflow

## Design

Files: skills/create-feature/SKILL.md, commands/create-feature.md
Flow phases:
1. Brainstorm (problem, solution, success criteria, constraints)
2. Create ticket via tk create --type feature
3. Plan (implementation steps + key decisions)
4. Execute (update ticket with changes, learnings)
5. Test (run suite, Puppeteer/CLI verification)
6. Finalize (brief notes, TODOs → new tickets)
7. Commit [ticket-id] description
8. Push
Detect epic scope during brainstorm (>2hr → propose breakdown)
Support --auto flag for autonomous mode

## Acceptance Criteria

Skill executes full feature flow, creates properly structured ticket, commits with correct format

