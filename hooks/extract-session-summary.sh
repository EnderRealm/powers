#!/usr/bin/env bash
set -euo pipefail

# Extracts session summary from transcript JSONL and pushes to learnings repo.
# Receives JSON on stdin: session_id, transcript_path, cwd, reason.
# Registered as a SessionEnd command hook.

LEARNINGS_REPO="${LEARNINGS_REPO:-$HOME/code/learnings}"
MAX_RETRIES=3

# Read hook input from stdin
input="$(cat)"
session_id="$(echo "$input" | jq -r '.session_id')"
transcript_path="$(echo "$input" | jq -r '.transcript_path')"
cwd="$(echo "$input" | jq -r '.cwd')"

if [[ -z "$transcript_path" || ! -f "$transcript_path" ]]; then
  exit 0
fi

if [[ ! -d "$LEARNINGS_REPO/.git" ]]; then
  exit 0
fi

# Search assistant messages for sentinel markers.
# Extract all text blocks from assistant messages and concatenate.
summary_body="$(jq -r '
  select(.type == "assistant")
  | .message.content[]
  | select(.type == "text")
  | .text
' "$transcript_path" | awk '
  /<!-- BEGIN_SESSION_SUMMARY -->/ { capture=1; next }
  /<!-- END_SESSION_SUMMARY -->/ { capture=0 }
  capture { print }
')"

# If no summary found, exit silently (catch-up script handles it)
if [[ -z "$summary_body" ]]; then
  exit 0
fi

# Infer project from git repo root basename
project="$(cd "$cwd" 2>/dev/null && basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || basename "$cwd")"

# Extract date
today="$(date -u +%Y-%m-%d)"

# Extract branch
branch="$(cd "$cwd" 2>/dev/null && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")"

# Parse ticket IDs from body (p-XXXX pattern)
tickets="$(echo "$summary_body" | grep -oE 'p-[0-9a-f]{4}' | sort -u | jq -R . | jq -sc .)"

# Build output path
session_dir="$LEARNINGS_REPO/sessions/$project"
mkdir -p "$session_dir"
output_file="$session_dir/${today}-${session_id}.md"

# Write frontmatter + body
cat > "$output_file" <<ENDFILE
---
project: $project
session_id: $session_id
date: $today
branch: $branch
tickets: $tickets
processed: false
---

<!-- BEGIN_SESSION_SUMMARY -->
$summary_body
<!-- END_SESSION_SUMMARY -->
ENDFILE

# Commit and push to learnings repo
cd "$LEARNINGS_REPO"
git add "$output_file"
git commit -m "Add session summary: $project $today $session_id" --quiet 2>/dev/null || exit 0

for i in $(seq 1 $MAX_RETRIES); do
  if git push --quiet 2>/dev/null; then
    exit 0
  fi
  git pull --rebase --quiet 2>/dev/null || true
done
