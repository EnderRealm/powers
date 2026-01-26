# Powers

Structured development workflows for Claude Code using [tk](https://github.com/EnderRealm/ticket/) tickets.

**One ticket = one commit = one push.** Each workflow guides you from idea to shipped code.

## Quick Start

```bash
# Start a new feature
/create-feature

# Fix a bug
/create-bug

# Resume work on an existing ticket
/work-ticket p-1234
```

## Full System Installation

Set up the complete powers workflow on a new machine:

### 1. Prerequisites

Install [tk](https://github.com/EnderRealm/ticket/):
```bash
# Follow tk installation instructions
```

### 2. Clone the Repo

```bash
git clone https://github.com/EnderRealm/powers.git ~/code/powers
cd ~/code/powers
```

### 3. Set Up Global Config (Optional)

Link the global Claude config files to use this repo's versions:

```bash
# Backup existing configs
mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.backup 2>/dev/null
mv ~/.claude/settings.json ~/.claude/settings.json.backup 2>/dev/null

# Create symlinks
ln -s ~/code/powers/CLAUDE.global.md ~/.claude/CLAUDE.md
ln -s ~/code/powers/settings.global.json ~/.claude/settings.json
```

This gives you:
- Development workflow instructions in every session
- Pre-approved permissions for common operations
- Consistent behavior across machines

### 4. Install the Plugin

In Claude Code:
```
/plugin marketplace add EnderRealm/powers
/plugin install powers@powers
```

Restart Claude Code. You should see the workflow commands in `/skills`.

## Workflow Commands

### Development Workflow

| Command | Description |
|---------|-------------|
| `/create-feature` | Full feature workflow: brainstorm → plan → execute → test → commit → push |
| `/create-bug` | Lean bug workflow: investigate → fix → test → commit → push |
| `/work-ticket <id>` | Resume work on existing ticket based on type and state |

### Ticket Management

| Command | Description |
|---------|-------------|
| `/tk-list` | List tickets with optional filters |
| `/tk-ready` | Show tickets ready to work on (no blockers) |
| `/tk-ticket` | Create a single ticket manually |

### Design & Planning

| Command | Description |
|---------|-------------|
| `/brainstorm` | Socratic design refinement before implementation |

## Workflow Principles

- **Phases always run**, scaled to task size
- **Ask on decisions, not confirmations** — proceed unless blocked
- **Document decisions** with `**Decision:**` and `(auto)` or `(human)` tags
- **Capture learnings** in `## Learnings` section for later mining
- **Never hack around blockers** — stop and surface issues

## Testing Handoff

Workflows end by setting tickets to `needs_testing` status, not `closed`. This signals that:

1. The agent has completed implementation
2. Code is committed and pushed
3. Human (or agent) testing is required before closure

To close a ticket after verification:
```bash
tk edit <ticket-id> --status closed
```

Use `tk ls --status=needs_testing` to see tickets awaiting verification.

## Project Structure

```
skills/
  create-feature/     # /create-feature workflow
  create-bug/         # /create-bug workflow
  work-ticket/        # /work-ticket resume logic
  brainstorming/      # /brainstorm design sessions
  create-tickets/     # Epic/task generation
  using-powers/       # Session start context
  tk-list/            # Ticket listing
  tk-ready/           # Ready tickets
  tk-ticket/          # Single ticket creation
docs/
  TICKET-CONVENTIONS.md   # Ticket structure patterns
templates/
  PROJECT.md          # Project config template
CLAUDE.global.md      # Global agent instructions
settings.global.json  # Global permissions
```

## Local Development

```bash
/plugin marketplace add powers-dev file://./.claude-plugin/marketplace.json
/plugin install powers-dev@powers
```

## Updating

```
/plugin update powers
```

## License

MIT
