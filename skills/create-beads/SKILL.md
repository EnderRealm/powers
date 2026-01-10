---
name: create-beads
description: Use when you have a design or requirements and need to create beads (epics/tasks) for implementation
---

# Creating Beads

Convert designs into beads. Verify `bd` is installed first or **STOP**.

## Structure

**Multi-task features:** Epic + child tasks
```bash
bd create "Feature Name" --type epic -d "Goal and design summary"
bd create "Task 1" --parent <epic-id> -d "What to do, files to touch"
```

**Small features:** Standalone tasks
```bash
bd create "Task title" -d "Description"
```

## Task Guidelines

- Bite-sized: 2-5 minutes each
- Exact file paths
- Specific code/commands (not "add validation")
- TDD: test first, implement, commit

## Task Description Format

```
Goal: What this accomplishes
Files: exact/paths/here
Steps: 1. Write test 2. Implement 3. Verify
Acceptance: Tests pass, no regressions
```

## After Creating

```bash
bd list --parent <epic-id>  # Show tasks
bd ready                    # Find unblocked work
```
