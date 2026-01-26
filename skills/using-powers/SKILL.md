---
name: using-powers
description: Establishes skill usage patterns at session start
user-invocable: false
---

# Powers Plugin

Structured development workflows using tk tickets.

## Development Workflow

**Start new work:**
- `/create-feature` — Full feature workflow (brainstorm → plan → execute → test → commit → push)
- `/create-bug` — Lean bug workflow (investigate → fix → test → commit → push)

**Resume existing work:**
- `/work-ticket <id>` — Resume work on a ticket based on its type and state

**One ticket = one commit = one push.** Each workflow ends with a committed, pushed change.

## Ticket Management

- `/tk-list` — List tickets with optional filters
- `/tk-ready` — Show tickets ready to work on (no blockers)
- `/tk-ticket` — Create a single ticket manually

## Design & Planning

- `/brainstorm` — Socratic design refinement before implementation
- `powers:create-tickets` — Convert designs into tk epics and tasks

## When to Use What

| Situation | Action |
|-----------|--------|
| New feature to build | `/create-feature` |
| Bug to fix | `/create-bug` |
| Resuming from yesterday | `/work-ticket <id>` |
| Need to think through approach | `/brainstorm` |
| Have design, need task breakdown | `powers:create-tickets` |
| Quick ticket lookup | `/tk-list` or `/tk-ready` |

## Workflow Principles

- **Phases always run**, scaled to task size
- **Ask on decisions, not confirmations** — proceed unless blocked
- **Document decisions** with `**Decision:**` and `(auto)` or `(human)` tags
- **Capture learnings** in `## Learnings` section
- **Never hack around blockers** — stop and surface issues
