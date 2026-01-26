---
name: create-feature
description: Start a new feature with structured workflow. Brainstorm → plan → execute → test → commit → push.
disable-model-invocation: true
---

# Feature Workflow

Complete workflow for implementing a feature: brainstorm, plan, execute, test, finalize, commit, push.

**Mode:** `$ARGUMENTS` may include `--auto` for autonomous execution. Default is interactive.

## Phase 1: Brainstorm

Understand the feature before creating a ticket.

**Gather context:**
- Review relevant files, docs, recent commits
- Check active tickets: `tk ls` for open tasks, `tk ls -T epic` for epics

**Ask questions (one at a time, prefer multiple choice):**
- What problem does this solve?
- How will it be solved?
- What does success look like?
- What constraints exist?

**Detect scope:**
- If >2 hours of work, propose: "This is epic-sized. Break into child tickets?"
- If yes, use `powers:create-tickets` to generate epic + children, then stop
- If no, continue with single feature

**Output:** Clear understanding of problem, solution, success criteria, constraints.

## Phase 2: Create Ticket

```bash
tk create "<feature title>" \
  --type feature \
  -d "<problem and solution summary>" \
  --design "<approach and key decisions>" \
  --acceptance "<success criteria>"
```

Record the ticket ID for later phases.

## Phase 3: Plan

Define implementation steps with key decisions.

**Produce:**
- Ordered list of implementation steps
- Files to create/modify
- Key decisions with rationale

**Document in ticket:**
```bash
tk add-note <ticket-id> "## Plan

**Decision:** <choice> (auto) — <rationale>

1. <step one>
2. <step two>
3. <step three>

<!-- checkpoint: planning -->"
```

**Interactive mode:** Ask "Does this plan look right?" before proceeding.
**Auto mode:** Document plan and continue.

## Phase 4: Execute

Implement the feature following the plan.

**As you work:**
- Track deviations from plan
- Note surprises and learnings
- Document decisions with `**Decision:** <choice> (auto|human) — <rationale>`

**After implementation, update ticket:**
```bash
tk add-note <ticket-id> "## Execute

**What changed:**
- <file created/modified>
- <component added>

**Decisions made:**
- <decision> (auto) — <rationale>

<!-- checkpoint: executing -->"
```

**If blocked:**
- Self-inflicted errors (syntax, typos): Retry until solved
- Environmental blockers (server down): Stop and surface
- Approach issues: Document and ask

## Phase 5: Test

Verify the feature works.

**Run existing test suite:**
```bash
# Project-specific command, check package.json or PROJECT.md
npm test  # or bun test, pytest, etc.
```

**Manual verification:**
- Use Puppeteer for UX testing (headless=false interactive, headless=true auto)
- Use CLI execution for non-UI features
- Use running dev servers — don't spin up test instances

**Update ticket with results:**
```bash
tk add-note <ticket-id> "## Test Results

**<timestamp>:** <count> tests, <passed> passed

Verified manually:
- <what was tested>
- <what was tested>

<!-- checkpoint: testing -->"
```

**If tests fail:** Fix issues, re-run, document the fix.

## Phase 6: Finalize

Wrap up the feature.

**Check for:**
- TODOs that should become tickets
- Known limitations to document
- Cleanup needed

**Update ticket:**
```bash
tk add-note <ticket-id> "## Finalize

**Known limitations:**
- <limitation if any>

**TODOs filed:**
- <ticket-id>: <description>

## Learnings

- <insight worth remembering>

<!-- checkpoint: finalized -->"
```

**File new tickets for TODOs:**
```bash
tk create "<TODO title>" --type task -d "<description>"
```

## Phase 7: Commit

Stage and commit with ticket-first format.

```bash
git add <files>
git commit -m "[<ticket-id>] <imperative description>"
```

**Example:** `[p-1234] Add user form validation`

**Include:**
- All files changed for this feature
- Updated ticket file from `.tickets/`

## Phase 8: Push

```bash
tk edit <ticket-id> --status needs_testing
git add .tickets/<ticket-id>.md
git commit --amend --no-edit
git push
```

---

## Auto Mode

When `--auto` is passed:
- Proceed through phases without confirmation prompts
- Document all decisions with `(auto)` tag
- Add "Questions Considered" section:

```markdown
## Questions Considered (auto mode)

- Q: <question that would have been asked> → <decision made>
- Q: <question> → <decision>
```

- Still stop on environmental blockers or ambiguous requirements

## Error Handling

| Error Class | Behavior |
|-------------|----------|
| Self-inflicted (syntax, typo, wrong API) | Retry until solved |
| Environmental (server down, port unavailable) | Stop and surface |
| Approach/design (plan doesn't work) | Document and ask |

**Never:**
- Write hacky workarounds
- Skip testing
- Silently degrade quality
