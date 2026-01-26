---
name: create-bug
description: Start a bug fix with lean workflow. Investigate → fix → test → commit → push.
disable-model-invocation: true
---

# Bug Workflow

Lean workflow for fixing bugs: create ticket, investigate, fix, test, document root cause, commit, push.

**Mode:** `$ARGUMENTS` may include `--auto` for autonomous execution. Default is interactive.

## Phase 1: Create Ticket

Capture initial symptoms immediately.

```bash
tk create "<bug title>" \
  --type bug \
  -d "<symptoms: what's broken, how to trigger, expected vs actual>"
```

Record the ticket ID for later phases.

## Phase 2: Investigate

Find the root cause.

**Reproduce the bug:**
- Use Puppeteer for UX bugs (headless=false to observe)
- Use CLI execution for command-line bugs
- Use code/tests for logic bugs

**Document reproduction steps in ticket:**
```bash
tk add-note <ticket-id> "## Reproduction

1. <step to trigger>
2. <step>
3. <observe: expected X, got Y>

<!-- checkpoint: investigating -->"
```

**Find root cause:**
- Trace the code path
- Identify the faulty logic
- Understand why it happens

## Phase 3: Fix

Implement the fix.

**Keep it minimal:**
- Fix the bug, nothing more
- Don't refactor surrounding code
- Don't add "while I'm here" improvements

**Document decisions if any:**
```markdown
**Decision:** <approach chosen> (auto) — <why this fix over alternatives>
```

## Phase 4: Test

Verify the bug is gone.

**Use same reproduction steps:**
1. Follow exact steps from Phase 2
2. Confirm expected behavior now occurs
3. Run test suite to check for regressions

```bash
# Project-specific test command
npm test  # or bun test, pytest, etc.
```

**Update ticket:**
```bash
tk add-note <ticket-id> "## Verified

Reproduction steps now produce expected behavior.

**<timestamp>:** <count> tests, <passed> passed

<!-- checkpoint: testing -->"
```

**If tests fail:** Fix regressions, re-run, document.

## Phase 5: Document Root Cause

Update ticket with what was learned.

```bash
tk add-note <ticket-id> "## Root Cause

<clear explanation of what was wrong and why>

## Fix

<what was changed to fix it>

## Learnings

- <insight worth remembering for future bugs>

<!-- checkpoint: finalized -->"
```

**Root cause format:**
- Be specific: file, line, function
- Explain the flaw in logic
- Note any patterns to watch for

## Phase 6: Commit

Stage and commit with ticket-first format.

```bash
git add <files>
git commit -m "[<ticket-id>] Fix <concise description>"
```

**Example:** `[p-5678] Fix session expiry check using wrong comparison`

**Include:**
- All files changed for this fix
- Updated ticket file from `.tickets/`

## Phase 7: Push & Close

```bash
tk edit <ticket-id> --status closed
git add .tickets/<ticket-id>.md
git commit --amend --no-edit
git push
```

---

## Auto Mode

When `--auto` is passed:
- Proceed through phases without confirmation prompts
- Document all decisions with `(auto)` tag
- Add "Questions Considered" section if any arose
- Still stop on environmental blockers

## Error Handling

| Error Class | Behavior |
|-------------|----------|
| Self-inflicted (syntax, typo, wrong API) | Retry until solved |
| Environmental (server down, can't reproduce) | Stop and surface |
| Unclear root cause | Document findings and ask |

**Never:**
- Write hacky workarounds
- Skip verification
- Close without documenting root cause

## When to Escalate to Feature Workflow

If investigation reveals the "bug" is actually:
- Missing functionality → `/create-feature`
- Design flaw requiring rework → `/create-feature`
- Multiple related issues → Create epic

Stop and discuss before switching workflows.
