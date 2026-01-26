---
name: tk-ticket
description: Create a single ticket
---

Run `tk create` with the title and options provided.

## Options

- `-d, --description` — Description text
- `--design` — Design notes
- `--acceptance` — Acceptance criteria
- `-t, --type` — Type: bug | feature | task | epic | chore
- `-p, --priority` — Priority 0-4 (0=highest)
- `--parent` — Parent ticket ID
- `--tags` — Comma-separated tags

## Examples

```bash
tk create "Fix login bug" --type bug -d "Users can't log in with email"

tk create "Add search feature" --type feature \
  -d "Full-text search for tickets" \
  --design "Use SQLite FTS5" \
  --acceptance "Search returns results in <100ms"

tk create "Implement search API" --parent p-1234 \
  -d "REST endpoint for search"
```
