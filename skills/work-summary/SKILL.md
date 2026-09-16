---
name: work-summary
description: Use when asked "what did I do today", for an end-of-day/EOD summary, standup notes, or a scheduled work report. Summarizes one workspace's activity for a day or any period across GitHub, Linear, meetings, docs, mail, chat, calendar and Claude Code sessions, then drafts it to a configured chat destination for review.
---

# Work Summary

## Overview

Gather what one person did over a given period from up to ten sources, write a short factual
summary, and post it to a configured chat destination. Every workspace-specific value lives in
a profile file, so the same skill serves any company or org.

## When to Use

- "What did I do today", end-of-day / EOD summaries, standup notes
- A scheduled recurring work report
- Reconstructing a period: "this week", "last week", "since Tuesday", "last N days"

**Do not use** to summarize someone else's work, or to mix two workspaces into one summary —
one profile per run.

## Core Process

Gather what one person did over a given period from up to ten sources, write a short
factual summary, and post it to a configured chat destination.

**A day is the default, not the only option.** Every step below takes the `START`/`END`
resolved in step 1. Three things change as the period grows, and they are called out where
they bite: which GitHub query is trustworthy (step 2), which sources need paginating
(steps 4-10), and how the output is shaped (step 13).

**One workspace per run.** A summary mixes companies only if you let it. Step 0 binds the
run to exactly one profile, and every query below filters by that profile's values.

## Step 0 - load the profile

All workspace-specific values live in a profile file, never in this skill. Resolve one
before doing anything else:

1. If the caller named a workspace, read `~/<workspace>/.claude/work-summary.config.md`.
2. Otherwise glob `~/*/.claude/work-summary.config.md`. Exactly one match - use it.
   Several - list them and ask which. None - stop and say a profile must be created, and
   point at `work-queue/references/profile-example.md`, which is the template for both skills.

The profile defines these keys. Every `{{key}}` below is substituted from it:

| Key | Meaning |
|---|---|
| `workspace_root` | Directory holding this workspace's repos |
| `github_login` | GitHub username to attribute activity to |
| `github_org` | Org to filter activity to |
| `exclude_orgs` | Other orgs the person works in, excluded from this summary |
| `outline_base` | Outline (or other wiki) base URL, blank if unused |
| `outline_user_id` | That wiki's user id, blank if unused |
| `linear_teams` | Linear team keys or names belonging to this workspace, blank if unused |
| `linear_user` | Their Linear user id or email, for attribution, blank if unused |
| `chat_destination` | Channel or DM id to post the summary to |
| `work_channels` | Chat channel ids this workspace's work happens in, blank to skip step 8's pass C |
| `transcript_glob` | Claude Code project-dir glob for this workspace |
| `work_log_dir` | Where each run is recorded; defaults to `{{workspace_root}}/.claude/work-log` |

**Never hardcode a profile value into this file.** If a step needs a new workspace-specific
value, add a key to the table and to every profile.

## Step 1 — resolve the period

Resolve the argument to **`START` and `END`, inclusive local dates**. A bare day sets both
to itself. Get every date from `date` — never assume today, and never do the arithmetic in
your head.

| Argument | Resolves to |
|---|---|
| *(none)*, `today` | `date +%F` … same |
| `yesterday` | `date -j -v-1d +%F` … same |
| `YYYY-MM-DD` | that day … same |
| `START..END` | as given (reject END < START) |
| `this week` | `date -j -v-mon +%F` … today |
| `last week` | `date -j -v-sun -v-6d +%F` … `date -j -v-sun +%F` (Mon–Sun) |
| `last N days` | `date -j -v-$((N-1))d +%F` … today |
| `this month` | `date -j -v1d +%F` … today |
| `YYYY-MM` | the 1st … the last day, clipped to today if it's the current month |

Two helpers the later steps ask for by name — several APIs want an exclusive bound:

```bash
date -j -v-1d -f %F "$START" +%F     # day before START  (Gmail/Slack `after:`)
date -j -v+1d -f %F "$END"   +%F     # day after END     (Gmail/Slack `before:`, Granola end)
```

`-v-mon` on a Monday returns that same Monday, which is what "this week" should mean. Say the
resolved period back in one line before gathering — a wrong range is the one error that
silently poisons every step downstream.

**They ask in plain English; translate it and get on with it.** "the last few days", "since
Tuesday", "yesterday and today", "past couple weeks", "what have I been up to this week" all
map onto the table above. Pick the sensible reading, state it, and start gathering — do not
interrogate them about boundaries. Only ask when the phrase has no defensible reading ("this
sprint" with no sprint defined anywhere). If they say a weekday with no date, it means the most
recent one already past, not next week's.

**"Since the last run" — the run log first, then Slack.** Every run writes a record to
`{{work_log_dir}}/summary/` (step 14, and `work-queue/references/run-log.md` for the format),
which is authoritative because it exists whether or not the summary was ever sent. Read the
newest record there for the period it covered.

Fall back to the DM when there is no run log — for runs that predate it, the posted summary is
still the record of what was covered:

```
mcp__claude_ai_Slack__slack_read_channel  channel_id: {{chat_destination}}, limit: 5,
                                          response_format: "concise"
```

The newest message whose first line is a bold date header is the last run. That header states
the period it covered — `*Wed 19 Aug*` or `*Mon 17 – Fri 21 Aug*` — so `START` is **the day
after the end of that period** and `END` is today. Headers carry no year: resolve to the most
recent occurrence that isn't in the future.

Four things about this that matter:
- **Drafts are still not runs — but they are no longer invisible.** Drafting is the default
  (step 13), and a draft leaves nothing in the channel, so its days still count as uncovered:
  they never read it. What changed is that the run log records the draft with `sent: no`, so
  you can say *"you drafted the 19th and never sent it"* instead of silently re-covering those
  days. Coverage still advances only on a sent summary.
- **Resume from coverage, not from the timestamp.** A summary for the 19th posted at 17:22 on
  the 19th means the 19th is done; start at the 20th, not at 17:22.
- If the DM has no summary at all, there is no last run — treat the request as "today" and say
  that's what you did.
- This is the one place the self-DM is read on purpose. Step 8 still excludes it from activity
  searches, and that exclusion stays: reading it for a *boundary* is not the same as counting
  it as work.

## Steps 2-11 - gather the sources

Work through every source in **`references/sources.md`**. Each carries its own query syntax,
pagination rule and known traps. Sources are independent: if one fails, record the failure and
continue rather than aborting the run.

| Step | Source | Needs |
|---|---|---|
| 2 | GitHub activity | `{{github_login}}`, `{{github_org}}` |
| 3 | Granola meetings | connector |
| 4 | Outline docs | `{{outline_base}}`, `{{outline_user_id}}` |
| 5 | Google Docs | connector |
| 6 | Claude artifacts & design | `Artifact`, `DesignSync` |
| 7 | Email | connector |
| 8 | Chat | `{{chat_destination}}`, `{{work_channels}}` |
| 9 | Calendar | connector |
| 10 | Linear | `{{linear_teams}}`, `{{linear_user}}` |
| 11 | Claude Code sessions | `{{transcript_glob}}`, `scripts/claude-code-sessions.sh` |

## Steps 12-13 - blockers, voice, post

Follow **`references/output.md`**. It covers what qualifies as a blocker, how to write in the
person's voice rather than a report register, how output shape changes with period length, and
how to post to `{{chat_destination}}`.

## Step 14 - record the run

Write one record to `{{work_log_dir}}/summary/YYYY-MM-DD-HHMM.md`: the period covered, the
sources that failed, and `sent: yes|no`. Format in `work-queue/references/run-log.md`; the two
skills share that directory so one place answers both "what did I finish" and "what do I owe".

This is the only thing this skill writes outside `{{chat_destination}}`, and it is what makes
step 1's "since the last run" reliable rather than dependent on whether a draft got sent.

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "I'll just hardcode the org, there's only one workspace" | The profile is the only reason this skill is reusable. A hardcoded value silently breaks the next workspace |
| "Today's date is obvious" | Always get dates from `date`. Assumed dates are the most common defect in period resolution |
| "One source failed, so the run failed" | Sources are independent. Record the gap and summarize the rest |
| "The GitHub events API is enough" | It is unreliable past a short window and misattributes merges — step 2 says which query to trust for which period |
| "More detail is a better summary" | The output is read in a chat client. Length is a cost, not a signal of effort |
| "I'll include everything I found" | Cross-org work and tooling maintenance are excluded by design. Filter to `{{github_org}}` |
| "The Linear ticket and its PR are two things I did" | They are one piece of work. Linear flips the ticket when the PR merges — two bullets for one merge is padding (step 10) |
| "The Linear connector is authenticated, so its tickets are this workspace's" | OAuth binds one Linear workspace, and it may be an org in `{{exclude_orgs}}`. Check `get_workspace` before reading issues |

## Red Flags

- Any workspace-specific literal appearing in `SKILL.md` or `references/` instead of a profile key
- A summary containing work from an org listed in `{{exclude_orgs}}`
- Linear issues from a team outside `{{linear_teams}}`, or from a workspace `get_workspace` says isn't this one
- Dates computed mentally rather than with `date`
- Posting without reporting which sources were unavailable

## Verification

- [ ] Exactly one profile resolved, and every query filtered by its values
- [ ] `START` and `END` derived from `date`, never assumed
- [ ] Every source attempted; unavailable ones named in the output
- [ ] No content from an org in `{{exclude_orgs}}`
- [ ] Linear confirmed as this workspace's and scoped to `{{linear_teams}}`, or skipped with the reason stated
- [ ] No ticket reported as its own item when the PR in step 2 already covers it
- [ ] Summary drafted to `{{chat_destination}}` and the draft link returned — sent outright only if they asked
- [ ] Run recorded to `{{work_log_dir}}/summary/` with the period covered and `sent: yes|no`
- [ ] No workspace-specific literal committed to this skill
