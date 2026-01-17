# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Powers is a Claude Code plugin providing skills for ticket-based workflows using [tk](https://github.com/wedow/ticket/).

## Architecture

```
.claude-plugin/
  plugin.json           # Plugin metadata
  marketplace.json      # Local dev marketplace config
commands/
  brainstorm.md         # Delegates to brainstorming skill
  tk-ready.md           # Wraps tk ready
  tk-list.md            # Wraps tk ls
  tk-ticket.md          # Wraps tk create (single ticket)
  tk-tickets.md         # Delegates to create-tickets skill
skills/
  brainstorming/        # Socratic design refinement
  create-tickets/       # Convert designs to tk epics/tasks
  using-powers/         # Meta-skill injected at session start
hooks/
  hooks.json            # Hook registration
  session-start.sh      # Injects using-powers into session context
  run-hook.cmd          # Cross-platform hook runner
```

**Skill loading:** SessionStart hook reads `using-powers/SKILL.md` and injects as context.

**Skill structure:** Each skill has `SKILL.md` with YAML frontmatter (`name`, `description`) and markdown content.

## Local Development

```bash
# Register local marketplace
/plugin marketplace add powers-dev file://./.claude-plugin/marketplace.json

# Install from local marketplace
/plugin install powers-dev@powers
```

## Dependency

Requires [tk](https://github.com/wedow/ticket/) CLI. Skills verify `tk` is available before proceeding.
