---
id: p-fcd1
status: open
deps: []
links: []
created: 2026-02-14T22:18:09Z
type: task
priority: 2
assignee: Steve Macbeth
tags: [cross-repo]
---
# Add token tracking to session summaries

Update PreCompact/SessionEnd hooks to capture and include token_count in session summary frontmatter. Token data comes from the session JSONL files.

## Design

Files: hooks/session-end.sh (or equivalent hook script), hooks/pre-compact-prompt.md (update prompt to request token_count in frontmatter).
Approach: In the SessionEnd hook, read the session JSONL to sum token usage (input+output). Include token_count in the YAML frontmatter when writing the summary to the learnings repo. Update the PreCompact prompt to instruct Claude to include token usage metrics if available.

## Acceptance Criteria

Session summaries written by Powers hooks include token_count in YAML frontmatter. Works for both PreCompact and SessionEnd paths.

