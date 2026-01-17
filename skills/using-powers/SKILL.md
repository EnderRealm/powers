---
name: using-powers
description: Establishes skill usage patterns at session start
---

# Powers Skills

This plugin provides skills for structured design and task management workflows.

## Available Skills

- `powers:brainstorming` - Socratic design refinement before implementation
- `powers:create-tickets` - Convert designs into tk epics and tasks

## Available Commands

- `/brainstorm` - Start a brainstorming session
- `/tk-ready` - Show tickets ready to work on
- `/tk-list` - List tickets with optional filters
- `/tk-ticket` - Create a single ticket
- `/tk-tickets` - Create structured tickets from a design

## When to Invoke

Check skills before starting implementation work:

- Building a feature → `powers:brainstorming` first, then `powers:create-tickets`
- Adding functionality → `powers:brainstorming` to clarify requirements
- Have a design, need tasks → `powers:create-tickets`

## Access

Use the `Skill` tool with `powers:` prefix. Follow skill instructions directly.
