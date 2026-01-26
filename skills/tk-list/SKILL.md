---
name: tk-list
description: List tickets with optional filters
---

Run `tk ls` with any filters provided by the user.

## Common Filters

- `--status=open` or `--status=closed` or `--status=in_progress`
- `--priority=0` through `--priority=4`
- `--parent=<epic-id>` to list child tickets
- `-T, --type=<type>` to filter by type (bug, feature, task, epic, chore)

## Priority Levels

- 0 — Critical/highest priority
- 1 — High
- 2 — Medium (default)
- 3 — Low
- 4 — Backlog/lowest priority

## Examples

```bash
tk ls                          # All open tickets
tk ls --status=closed          # Closed tickets
tk ls --parent=p-1234          # Children of epic
tk ls -T bug                   # All bugs
```
