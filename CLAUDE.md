# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Powers is a Claude Code plugin providing skills for ticket-based workflows using [tk](https://github.com/wedow/ticket/).

## Architecture

```
.claude-plugin/
  plugin.json           # Plugin metadata
  marketplace.json      # Local dev marketplace config
skills/
  brainstorming/        # /brainstorm - Socratic design refinement
  create-feature/       # /create-feature - Feature workflow
  create-bug/           # /create-bug - Bug workflow
  work-ticket/          # /work-ticket - Resume based on ticket type
  create-tickets/       # Convert designs to tk epics/tasks
  using-powers/         # Meta-skill injected at session start
  tk-list/              # /tk-list - List tickets with filters
  tk-ready/             # /tk-ready - Show ready tickets
  tk-ticket/            # /tk-ticket - Create single ticket
docs/
  TICKET-CONVENTIONS.md # Ticket structure patterns
templates/
  PROJECT.md            # Project configuration template
hooks/
  hooks.json            # Hook registration
  session-start.sh      # Injects using-powers into session context
  run-hook.cmd          # Cross-platform hook runner
```

**Skills are slash commands.** Each `skills/<name>/SKILL.md` creates a `/name` command. The `name` field in frontmatter becomes the command name.

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
