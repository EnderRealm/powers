---
description: Return a subset of tickets
---

Run `tk query` with jq syntax to filter based on frontmatter properties:

Usage examples:

# All tickets as JSON (one per line)
tk query

# Filter by type
tk query '.type == "epic"''

Valid types:

"epic" -- ticket is an epic
"bug" -- ticket is a bug or defect
"chore" -- ticket is work that needs to be done to improve codebase/tech debt
"feature" -- ticket is a new feature
"task" -- ticket is a non-coding task like investigation or sign-up for a service

# Filter by priority
tk query '.priority == 0'

Valid priorities:

0 - critical/highest priority
1 - high
2 - medium
3 - low
4 - backlog/lowest priority

# Filter by assignee
tk query '.assignee = "full name"'
