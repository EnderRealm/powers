# Learning Extraction System Design

## Purpose

Agentic coding sessions generate significant value beyond the code itself: decisions are made, problems are encountered, solutions are discovered, and understanding deepens. Currently, this knowledge evaporates when a session ends. The ticket system (tk) captures *what* was built, but not the *thinking* and *learning* that went into building it.

This system exists to:

1. **Preserve session knowledge** before it's lost to context compaction or session end.
2. **Extract actionable items** that would otherwise be forgotten (unresolved bugs, incomplete work).
3. **Surface patterns** that span sessions and projects, enabling systematic improvement.
4. **Feed learnings back** into the workflow itself, creating a continuous improvement loop.

The end state: every coding session contributes to a growing body of knowledge that makes future sessions more effective.

---

## Goals

**Immediate value:**
- Unresolved problems become bug tickets automatically.
- Incomplete work is captured and can be resumed.
- Decisions are attached to the tickets they relate to, preserving context.

**Accumulated value:**
- Project-level discoveries become CLAUDE.md improvements (via tickets).
- Cross-project patterns identify transferable solutions.
- Historical summaries enable reflection (daily, weekly, monthly, annual).

**Workflow evolution:**
- Patterns that affect how work is done become Powers/Manager/Ticket improvements.
- The workflow adapts based on what's actually happening in sessions.

**Non-goals:**
- Not trying to replace human judgment on what's important.
- Not auto-updating CLAUDE.md or workflow (everything becomes tickets for human review).
- Not capturing every detail (high bar for extraction, prefer false negatives to noise).

---

## Architecture Overview

### Data Flow

```
+------------------------------------------------------------------+
|                     SESSION (any machine)                         |
|  PreCompact hook (prompt) -> Creates summary inline               |
|  SessionEnd hook (command) -> Extracts summary -> pushes to repo  |
+------------------------------------------------------------------+
                                |
                                v
                         learnings repo (git)
                                |
                                v
+------------------------------------------------------------------+
|              CATCH-UP SCRIPT (each machine, daily)               |
|  Finds sessions without summaries -> summarizes -> pushes         |
|  Also used for initial backfill of all historical sessions        |
+------------------------------------------------------------------+
                                |
                                v
+------------------------------------------------------------------+
|                  NIGHTLY CRON (Mac Studio)                        |
|  1. Extract learnings -> Create tickets (via create-ticket)       |
|  2. Attach decisions to existing tickets                          |
|  3. Detect cross-project patterns                                 |
|  4. Build rollups (daily/weekly/monthly/annual)                   |
+------------------------------------------------------------------+
```

### Repository Split

| Repository | Responsibility |
|------------|----------------|
| **learnings** (new) | Data only. Session summaries, rollups, pattern files. |
| **Powers** | In-session workflow. PreCompact and SessionEnd hooks, summary prompt template. |
| **Manager** | Cross-session orchestration. Nightly cron, catch-up script, extraction logic, pattern detection, rollup generation. |

**Principle:** Powers handles "in-session" workflow. Manager handles "across-session/project" orchestration. Learnings repo is pure data.

### Learnings Repository Layout

```
learnings/
  sessions/
    powers/
      2025-02-08-abc123.md
      2025-02-08-def456.md
    manager/
      2025-02-08-ghi789.md
  rollups/
    daily/
    weekly/
    monthly/
    annual/
  patterns/
    ptr-001.md
    ptr-002.md
```

---

## Session Summaries

### Creation

Summaries are created in two phases:

1. **PreCompact hook (prompt type):** Fires before context compaction. Prompts the in-session Claude to produce a structured summary while it still has full context. This uses the MAX subscription (no API cost) and produces higher quality output than external summarization.

2. **SessionEnd hook (command type):** Fires when the session ends. A shell script extracts the summary from the session transcript JSONL, writes it to the learnings repo, and pushes via git.

### Hook Data

Both hooks receive JSON on stdin:

```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/transcript.jsonl",
  "cwd": "/path/to/project",
  "hook_event_name": "PreCompact"
}
```

SessionEnd additionally receives:

```json
{
  "reason": "prompt_input_exit"
}
```

### Summary Format

```markdown
---
project: powers
session_id: abc123
date: 2025-02-08
branch: main
duration_minutes: 45
message_count: 23
first_prompt: "Add session summarization hooks"
tickets: [p-1234]
processed: false
---

<!-- BEGIN_SESSION_SUMMARY -->

### Ticket(s)
p-1234

### Overview
2-3 sentences of what was accomplished.

### Decisions
- Chose X over Y because Z (human)
- Used approach A instead of B (auto)

### Problems
- Bug in auth module (resolved)
- Multi-machine sync issue (unresolved)

### Discoveries
- Claude Code stores sessions as JSONL in ~/.claude/projects/

### Incomplete Work
- Started refactoring the hook system, need to finish registration

<!-- END_SESSION_SUMMARY -->
```

**Ticket linkage:** The PreCompact prompt generates the body including `### Ticket(s)`. The extraction script parses ticket IDs from the body and populates the frontmatter `tickets` field. Frontmatter is the machine-readable source of truth; body is the human-generated source.

**Decision tag format:** Decisions use `(auto)` / `(human)` tags, matching the convention in [TICKET-CONVENTIONS.md](./TICKET-CONVENTIONS.md). This allows extraction logic to reuse the same parsing for decisions in tickets and session summaries.

**Project inference:** `project` is derived from the basename of the git repo root (e.g., `/Users/smacbeth/code/powers` becomes `powers`). If frontmatter contains an explicit `project` value, it wins over the inferred name.

### Summary Extraction Rules

The extraction script (SessionEnd hook) finds the summary in the session transcript JSONL using sentinel markers.

**Extraction steps:**
1. Read the transcript JSONL file.
2. Search for the `<!-- BEGIN_SESSION_SUMMARY -->` marker in assistant messages.
3. Extract all content between `BEGIN_SESSION_SUMMARY` and `END_SESSION_SUMMARY`.
4. Parse ticket IDs, decisions, problems, discoveries, and incomplete work from the body.
5. Build frontmatter from parsed data plus hook input (`session_id`, `cwd`, timestamp).
6. Write the combined frontmatter + body to the learnings repo.

**Required frontmatter fields:** `project`, `session_id`, `date`, `processed`. All others are optional.

**Fallback behavior:**
- If sentinel markers are not found in the transcript, the session is skipped (catch-up script will handle it later).
- If a required frontmatter field cannot be inferred, the summary is written with the field set to `unknown` and flagged for manual review.

### Catch-Up Script

Handles sessions that were missed (hook failure, crash, sessions predating the system):

1. Scan `~/.claude/projects/` for session JSONL files.
2. Compare against summaries already in the learnings repo by `session_id`.
3. For each unsummarized session, use Claude (MAX subscription) to produce a summary.
4. Push to learnings repo.

This script runs daily on each machine and doubles as the initial backfill mechanism.

**Valid summary criteria:** A session is considered "summarized" if a file exists in `sessions/<project>/` with a matching `session_id` in frontmatter. A summary is considered "valid" if it has all required frontmatter fields and contains the sentinel markers. Malformed or partial summaries are regenerated by the catch-up script (the existing file is overwritten).

---

## Hook Configuration (Powers)

```json
{
  "hooks": {
    "PreCompact": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Before this context is compacted, create a session summary.\n\nIMPORTANT: Do not include secrets, API keys, tokens, passwords, or personal data. Redact with [REDACTED] if referencing sensitive values.\n\nWrap the entire summary in sentinel markers exactly as shown.\n\n## Format\n\n<!-- BEGIN_SESSION_SUMMARY -->\n\n### Ticket(s)\nList ticket ID(s) worked on this session (e.g., p-1234, p-5678).\nIf no tickets, write \"None.\"\n\n### Overview\n2-3 sentences: What was accomplished this session.\n\n### Decisions\nBullet list of choices made and why. Include:\n- What was decided\n- Alternatives considered\n- Rationale for the choice\nTag each: (auto) if you decided, (human) if the user decided.\nIf none, write \"None.\"\n\n### Problems\nBullet list of bugs, blockers, or things that didn't work.\nInclude resolution status: (resolved) or (unresolved).\nIf none, write \"None.\"\n\n### Discoveries\nBullet list of new understanding gained about the codebase, tools, or domain.\nIf none, write \"None.\"\n\n### Incomplete Work\nBullet list of work started but not finished.\nInclude enough context to resume or create a follow-up ticket.\nIf none, write \"None.\"\n\n<!-- END_SESSION_SUMMARY -->\n\nOutput the summary now.",
            "timeout": 120
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "extract-session-summary.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

---

## Nightly Extraction

The nightly cron job on the Mac Studio processes summaries and generates learnings.

### Extraction Categories

| Summary Section | Extracted Into | Threshold | Mechanism |
|-----------------|---------------|-----------|-----------|
| Decisions | Note on existing ticket | Low | `tk add-note <ticket-id>` |
| Problems (unresolved) | Bug ticket in project | High | `/create-bug` or `tk` |
| Discoveries (codebase) | Task ticket (CLAUDE.md suggestion) in project | Highest | `tk` |
| Incomplete work | Reopen existing or create new task | Medium | `tk` |
| Workflow suggestions | Task ticket in Powers (marked global) | Highest | `tk` |

### Extraction Thresholds

The system prefers false negatives to noise:

- **Decisions:** Low threshold. Attaching context to existing tickets is cheap. Only skip if the decision is trivial or obvious.
- **Problems (unresolved):** High threshold. Only create a bug ticket if the problem is clearly reproducible and worth fixing. Don't ticket transient issues.
- **Discoveries:** Highest threshold. Only create CLAUDE.md suggestion tickets for genuinely useful, non-obvious findings. Most "discoveries" are just learning what already exists.
- **Incomplete work:** Medium threshold. Create tickets when there's enough context to resume. Skip if the work was exploratory and didn't lead anywhere.
- **Workflow suggestions:** Highest threshold. Changes to the workflow affect every future session. Must be clearly beneficial and well-understood.

### Processing Flow

```
1. Pull learnings repo (rebase to incorporate summaries from other machines)
2. Find summaries where processed: false
3. For each unprocessed summary:
   a. Extract items per category
   b. Create tickets / add notes as needed
   c. Set processed: true in frontmatter
   d. Commit the processed summary immediately
4. Run pattern detection across recent summaries (7-day window)
5. Update pattern files
6. Regenerate rollups for current period
7. Commit rollup/pattern changes
8. Push learnings repo (rebase + retry on conflict, max 3 attempts)
```

### Idempotency and Failure Recovery

**Natural key:** `session_id`. Each session produces at most one summary file.

**Idempotency rule:** Processing is idempotent per summary. If the nightly job fails partway through:
- Summaries already marked `processed: true` are skipped on rerun.
- Summaries still `processed: false` are reprocessed. This may create duplicate tickets if the first run created tickets but crashed before marking processed. This is an acceptable trade-off: duplicate tickets are cheap to close, lost extraction is not.

**Reprocessing:** Summaries are not reprocessed after being marked `processed: true`. If a summary is later found to be malformed, the catch-up script regenerates it (resetting `processed: false`), and the nightly job picks it up on the next run.

**Git conflict resolution:** The learnings repo has low write frequency (a few summaries per day per machine). Conflicts are resolved by pull with rebase before push. If push fails after rebase, retry up to 3 times. If still failing, log the error and skip (next run will pick it up).

---

## Pattern Detection

### Lifecycle

```
Observation -> Pattern -> Actioned -> Resolved
```

| Status | Meaning | Transition Trigger |
|--------|---------|--------------------|
| `observation` | Noticed, watching for more evidence | First occurrence |
| `pattern` | Enough evidence, ready to act | 3+ sessions or 2+ projects |
| `actioned` | Tickets created to address it | Nightly job creates tickets |
| `resolved` | Addressed or intentionally accepted | Human decision |

### Pattern File Format

```markdown
---
id: ptr-001
status: pattern
first_seen: 2025-02-01
last_seen: 2025-02-08
occurrences: 5
projects: [powers, manager]
tickets_created: []
---

### Description
Brief description of the pattern.

### Evidence
- 2025-02-01 powers session abc123: <what was observed>
- 2025-02-03 manager session def456: <what was observed>
- ...

### Suggested Action
What should be done about this pattern.
```

### Detection Method

Pattern detection is **Claude-powered, not algorithmic**. The nightly job feeds recent summaries to Claude and asks it to identify patterns. The "3+ sessions or 2+ projects" threshold is a guideline in the detection prompt, not a computed score. Claude evaluates semantic similarity between problems, discoveries, and decisions — something that resists reduction to keyword matching or tag clustering.

This is a deliberate choice: the patterns we care about are conceptual (e.g., "auth-related issues keep appearing across projects") rather than syntactic (e.g., "the word 'auth' appears 3 times"). False precision from an algorithmic scorer would give a misleading sense of rigor.

### Detection Scope

Pattern detection runs nightly across a 7-day rolling window of summaries. It looks for:

- Repeated unresolved problems across sessions
- Similar discoveries in different projects
- Recurring workflow friction points
- Common decision patterns (same trade-off appearing repeatedly)

---

## Rollups

### Structure

| Level | Input | Regenerated | Immutable After |
|-------|-------|-------------|-----------------|
| Daily | Session summaries from that day | Nightly | Day ends |
| Weekly | Daily rollups from that week | Nightly | Sunday |
| Monthly | Weekly rollups from that month | Weekly | Month ends |
| Annual | Monthly rollups from that year | Monthly | Dec 31 |

### Regeneration Strategy

Each level is regenerated fresh from its inputs until its period ends, at which point it becomes immutable. This ensures accuracy without drift. The inputs at each level are small (7 dailies into a weekly, 4-5 weeklies into a monthly), so regeneration cost is negligible.

### Rollup Format

```markdown
---
level: daily
date: 2025-02-08
projects: [powers, manager]
sessions: 3
patterns_active: [ptr-001, ptr-003]
---

### Summary
Brief narrative of the day's work across all projects.

### Key Outcomes
- Completed session hook implementation in Powers
- Fixed auth token refresh bug in Manager

### Decisions Made
- Chose sentinel markers for summary extraction (auto)
- Deferred pattern scoring algorithm (human)

### Open Items
- Multi-machine sync not yet tested
- Rollup format needs validation

### Patterns
- ptr-001: Still observing (3 occurrences)
- ptr-003: Promoted to pattern, tickets pending
```

Weekly/monthly/annual rollups follow the same structure but summarize from their inputs (dailies, weeklies, monthlies respectively) rather than raw sessions.

---

## Multi-Machine Handling

- Each machine pushes summaries to the learnings repo via git.
- The Mac Studio runs nightly processing (pulls all summaries first).
- The catch-up script runs daily on each machine, covering missed sessions.
- Git is the synchronization mechanism. No custom sync tooling.

**Conflict resolution:** Summaries are written to unique paths (`sessions/<project>/<date>-<session_id>.md`), so file-level conflicts between machines don't occur. The only conflict surface is the nightly job updating `processed` flags on summaries that another machine just pushed. This is handled by rebase before push, with up to 3 retries. If a push still fails (unlikely given the low write rate), the run is aborted and the next nightly run picks up where it left off.

---

## Safety and Redaction

Session summaries are pushed to a git repo that may be shared or backed up. The PreCompact prompt instructs Claude to exclude secrets, API keys, tokens, passwords, and personal data, replacing them with `[REDACTED]`.

This is a best-effort measure relying on the LLM's judgment. It is not a guarantee. The learnings repo should be treated as private and not published. If a secret is accidentally captured, the standard response is: rotate the secret, force-push to remove the commit, and treat the summary as compromised.

The catch-up script (which summarizes from raw transcripts) applies the same redaction instruction in its summarization prompt.

---

## Design Trade-offs

### 1. Centralized learnings repo vs distributed storage

**Chose centralized.** Cross-project pattern detection is a core goal and requires a single location. Project-specific learnings get pushed back as tickets, so they do end up in project repos as actionable items, not raw summaries.

### 2. Direct CLAUDE.md updates vs tickets

**Chose tickets.** CLAUDE.md affects all future sessions. Changes should be intentional. Tickets ensure nothing is applied without review, and the ticket system is already the lingua franca for tracking work.

### 3. Session summarization: in-session vs external

**Chose in-session (PreCompact prompt hook).** MAX subscription avoids API costs. More importantly, the in-session Claude has richer context about what mattered. External summarization would be working from cold transcripts.

### 4. Extraction thresholds: inclusive vs selective

**Chose selective (high bar, prefer false negatives).** Ticket noise is worse than missed items. A bug ticket that isn't a real bug wastes time. A suggestion that doesn't matter clutters the backlog. The system should surface what clearly matters; edge cases can be caught in manual review.

### 5. Pattern detection: immediate action vs observation period

**Chose observation period.** Seeing something once isn't a pattern. The observation stage lets signals accumulate before creating work. This prevents ticket churn from one-off occurrences.

### 6. Rollups: incremental vs regenerated

**Chose regenerated with immutable snapshots.** Rolling up from source data ensures accuracy. The inputs at each level are small, so regeneration cost is negligible. Immutable snapshots preserve historical perspective.

### 7. Implementation split: single repo vs Powers + Manager

**Chose Powers + Manager.** Powers already owns in-session workflow (hooks, skills). Manager already owns cross-project coordination. The learnings repo is purely data.

### 8. Multi-machine sync: raw sessions vs summaries

**Chose summaries.** Raw session JSONLs are large and contain internal Claude Code structure that could change. Summaries are the stable artifact. Git handles sync naturally. The catch-up script covers missed sessions.

---

## Risk Mitigations

| Risk | Mitigation |
|------|------------|
| Hook fails, session not summarized | Catch-up script runs daily on each machine |
| Summary extraction misses key info | PreCompact prompt is structured; manual review possible via raw transcripts |
| Too many tickets created (noise) | High extraction thresholds; prefer empty arrays to marginal items |
| Patterns identified but never actioned | Observation -> Pattern lifecycle; nightly job surfaces unactioned patterns |
| Rollups become stale or inaccurate | Regenerate from source; immutable snapshots for history |
| Cross-project analysis misses patterns | 7-day rolling window; patterns file tracks what's been seen |
