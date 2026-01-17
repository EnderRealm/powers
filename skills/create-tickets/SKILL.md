---
name: create-tickets
description: Convert designs into tk epics and tasks for implementation
---

# Creating Tickets

Convert designs into actionable tickets using tk's native fields.

## Prerequisites

Verify `tk` is installed. If unavailable, stop and tell the user to install it.

## Assess Scope

- Single task → standalone ticket
- Multiple steps → epic with child tasks

## Creating an Epic

```bash
tk create "Feature Name" \
  --type epic \
  -d "High-level goal" \
  --design "Architecture decisions, approach, constraints" \
  --acceptance "Definition of done"
```

## Creating Tasks

```bash
tk create "Task title" \
  --parent <epic-id> \
  -d "What to accomplish" \
  --design "Files: src/foo.ts, src/bar.ts
Approach: specific implementation details" \
  --acceptance "Tests pass, integrates with X"
```

## Task Guidelines

- Each task: 2-5 minutes of work
- Include exact file paths in design
- Specific implementation steps, not vague instructions
- Clear acceptance criteria

## After Creating

```bash
tk ls --parent <epic-id>  # show created tasks
tk ready                   # confirm unblocked work
```

## Standalone Task

For small features without an epic:

```bash
tk create "Task title" \
  -d "What to accomplish" \
  --design "Files and approach" \
  --acceptance "How to verify"
```
