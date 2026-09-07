---
name: work-queue
description: Use when asked "what should I work on", "what's on my plate", "what's assigned to me", or for a to-do list gathered from every channel. Sweeps Linear, GitHub, mail, chat, meetings and local work-in-progress for one workspace, then ranks what is owed into six bands. Read-only by default; can also find tickets that finished but were never closed and close them one at a time on explicit confirmation. The inverse of work-summary, which reports what is already done.
---

# Work Queue

## Overview

Gather everything one person owes across up to nine sources, rank it, and print it. Every
workspace-specific value lives in a profile file, so the same skill serves any company.

`work-summary` is the other half of the pair. It reports what closed; this reports what is
open. The boundary is one rule in both directions: **done belongs to work-summary, owed
belongs here.** A completed item is never a queue item, however recently it closed.

Both halves share one interface, so either can be called the same way:

- **A bare call always works.** No argument is required by either skill, ever.
- **The period is optional** and uses the same words in both: `last week`, `since Tuesday`,
  `30 days`, `2026-09-01`.
- **The header states what was covered** — scope, window, and any source that failed.
- **Every run is logged** to `{{work_log_dir}}`, so both can answer questions about the past.
  See `references/run-log.md`, which both skills write.

## When to Use

- "What should I work on", "what's on my plate", "what am I on the hook for"
- A to-do list assembled from Linear, GitHub, mail, chat and meetings
- Picking work back up after time away

**Do not use** to summarize finished work, to build someone else's queue, or to mix two
workspaces into one list — one profile per run.

## Read-only, and the one exception

**A bare call never writes.** It does not file tickets, reply to anyone, move a Linear issue,
or comment on a PR. Two reasons, both load-bearing: a queue that infers must not also act on
its inferences, and read-only is what makes it safe to run several times a day. Acting on an
item is a separate request the person makes after reading the list.

The single exception is **closing a ticket that already finished** — `--close`, step 13. It
exists because a stale-open ticket is a defect in this skill's own output rather than a piece
of work, and because nobody else is going to notice. It is fenced so it cannot become an
inference that acts:

- It never runs on a bare call. `--close` is required, every time.
- It closes **one ticket per explicit confirmation**, never a batch, and never a second one
  inferred from the first yes.
- It only ever sets a status and adds a comment saying why. No reassigning, relabelling, or
  moving projects.
- Detection itself stays read-only, so the finding is available on every run whether or not
  anyone acts on it.

`references/already-done.md` carries the evidence ranking, the scope rule, and the confirmation
protocol. Read it before using `--close`.

## Step 0 — load the profile

All workspace-specific values live in a profile, never in this file.

1. If the caller named a workspace, read `~/<workspace>/.claude/*.config.md`.
2. Otherwise glob `~/*/.claude/*.config.md`. Exactly one workspace matches — use it. Several —
   list them and ask. None — stop and say a profile must be created.

A workspace may carry several profile files with separate contracts; a key defined by any of
them resolves. **If two profiles define the same key with different values, stop and report
the drift** instead of picking one. That divergence silently changes what the sweep covers,
and it is the defect this skill is most likely to inherit.

Keys read: `{{workspace_root}}`, `{{github_login}}`, `{{github_org}}`, `{{exclude_orgs}}`,
`{{linear_teams}}`, `{{linear_user}}`, `{{work_channels}}`, `{{transcript_glob}}`,
`{{work_log_dir}}`.

## Step 1 — set the scope

**No date argument is ever required.** Running the skill bare is the normal case. If the
caller gave no period, do not ask for one — pick the defaults below and say which you used.

**Scope.** The default sweep is **tiers 1-2** — tracker, GitHub, mail and chat. Those carry
real assignments and finish fast enough to run before standup. `--full` adds **tiers 3-4** —
meetings, calendar, wiki and local work-in-progress. Transcript search and a session scan are
slow; they earn their cost weekly, not hourly.

**Window.** There are two kinds of source here, and only one of them has a window at all:

| Source kind | Window |
|---|---|
| **Assignments** — tracker issues, GitHub PRs and issues (tier 1) | **None, ever.** An issue assigned eight months ago is still owed. A window here silently drops the oldest and most neglected items, which are exactly the ones a queue exists to surface |
| **Asks** — chat, mail, tracker inbox, meetings (tiers 2-3) | `SINCE`, default **14 days**. An unanswered question older than that has usually died or been handled somewhere else |

An optional argument overrides `SINCE` and nothing else: a date, `last week`, `since Tuesday`,
`30 days`. Resolve it with `date` — never compute a date in your head — and state the window
in the output header so the reader knows what was covered.

```bash
date -j -v-14d +%F     # default SINCE
```

**Optional arguments.** All of them optional; the bare call is the one to optimise for.

| Argument | Effect |
|---|---|
| *(none)* | Default sweep, `SINCE` 14 days, snapshot written |
| a period | Overrides `SINCE` only — never the assignment sources, which have no window |
| `--full` | Adds tiers 3-4 |
| `--as-of <date>` | Prints the nearest snapshot at or before that date **instead of sweeping**. This is how the skill answers questions about past work |
| `--no-log` | Skips writing a snapshot. For a throwaway run that should not affect the next diff |
| `--close` | Runs step 13's confirmation loop, offering each already-done candidate one at a time. **The only argument that can write to the tracker.** Detection runs either way |

## Steps 2-10 — gather

Work through **`references/sources.md`**. Each source carries its query, its noise filter, and
what it is actually good for. Sources are independent: if one fails, record the failure, name
it in the output, and continue.

| # | Source | Tier | Yields |
|---|---|---|---|
| 2 | Tracker issues | 1 | The assigned queue — **every** team in `{{linear_teams}}` |
| 3 | Tracker inbox | 2 | Mentions, and comments on issues that are mine |
| 4 | GitHub | 1, 4 | Review requests of me; my own open PRs |
| 5 | Mail | 2 | Direct asks addressed to me |
| 6 | Chat | 2 | Unanswered @-mentions in `{{work_channels}}` |
| 7 | Meetings | 3 | Commitments I made out loud — **and usually the only source of dates** |
| 8 | Calendar | 3 | What is imminent, and what needs preparing |
| 9 | Wiki and docs | 3 | Documents left awaiting my edit |
| 10 | Local work-in-progress | 4 | Unmerged branches, draft PRs, sessions that stopped mid-task |

**Every tier past 1 is inference.** Carry a confidence with each item and quote its evidence
verbatim, so a wrong guess costs one glance to reject instead of a click to investigate.

**Step 4 pays for itself twice.** The merged-PR half of the GitHub sweep is what step 13 reads
to find finished-but-open tickets, so scan merged PRs for tracker ids while you are already
there rather than querying GitHub a second time.

## Step 11 — diff against the last run, then rank and print

Read the most recent snapshot from `{{work_log_dir}}` **before printing**, and mark each item
`NEW` or `carried Nd` against it. Anything that disappeared goes in a short cleared line,
classified `done` or `aged out` — never conflated. `references/run-log.md` has the id scheme
and the classification rule.

The diff is what makes the queue a record rather than a snapshot: `carried 12d` on a two-line
task is the most actionable thing on the page, and no single sweep can produce it.

Then follow **`references/ranking.md`** for the six bands, the tie-breaks and the output shape.
In order: blocking someone, dated, stalled on someone else, in flight, assigned, inferred.

Two properties of a real queue that the ranking exists to handle: tracker priority is usually
flat — a queue where half the items are Urgent carries no signal — and dates usually live
somewhere other than the tracker. Rank on what is true, not on the priority field.

## Step 12 — record the run

Write today's snapshot to `{{work_log_dir}}/queue/`, in the format in `references/run-log.md`.
Carry `first_seen` forward for every item that survived; set it to today for anything `NEW`.

Apart from step 13's confirmed closes, this is the only write either skill performs, and it
stays inside `{{work_log_dir}}`. Skip it only for `--as-of` (which swept nothing) and
`--no-log`.

## Step 13 — already done, still open

Follow **`references/already-done.md`**. Two halves, and only the second one writes.

**Detection runs on every sweep.** Cross-reference the open tracker queue against the merged
PRs already gathered in step 4, rank each candidate by evidence strength, and print the result
as its own short section below the ranked queue — never mixed into the bands, because these are
not work. A candidate list is information even when nobody acts on it: it tells the reader the
queue above may be shorter than it looks.

Print at most the strong candidates and a count of the weak ones. If there are none, one line
saying so — that is a healthy queue, not a gap to fill.

**Closing needs `--close` and one confirmation per ticket.** Offer the strongest candidate
with its evidence and what closing would leave unfinished, then wait. A yes closes exactly that
ticket and adds a comment citing the evidence; anything else changes nothing. Then offer the
next one. Never batch, never generalize a yes, and stop as soon as the evidence goes weak.

Record both the closes and the declines in the run log, so the next run does not re-ask about a
ticket the person already said to leave alone.

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "It's assigned to me, so it belongs in the queue" | Assigned and closed is not owed. Filter by status type, not by assignee alone |
| "The profile names one team, so that's the team" | Teams get added. Read every team in `{{linear_teams}}`, and re-verify that list against the tracker when the queue looks thin |
| "Unread mail addressed to me is a to-do list" | It is mostly calendar invitations and automated notes. Without the exclusions in `references/sources.md` this tier returns almost no signal |
| "The notification inbox is the ask list" | A large share of notifications are project-metadata churn. Whitelist the types that mean someone wants something from you |
| "A mention is a request" | Most mentions are cc-and-FYI. A request carries a question mark or an imperative addressed to you |
| "More sources means a better queue" | Every source past tier 1 lowers precision. `--full` exists so the person chooses when to pay that |
| "I found 40 things, so I'll list 40" | A list nobody finishes is not a priority list. Rank, cut, and offer the tail |
| "The tracker says Urgent, so it ranks first" | Urgent is frequently applied to most of a queue. Something blocking a colleague outranks a flat priority flag |
| "I can close this one for them while I'm here" | A bare call is read-only. Closing needs `--close` **and** a confirmation for that specific ticket |
| "A merged PR mentions this ticket, so it's done" | The most common reason a PR names a ticket is to defer it — "out of scope here, its own ticket". Read the sentence around the id |
| "They said yes to the last three, so this one's fine" | One yes closes one ticket. The confirmation loop exists precisely because the fourth is the wrong one |
| "It's their own ticket and it looks finished — I'll just close it" | Looks-finished is the state this pass reports, never the state it acts on. The person supplies the certainty |
| "Closing it silently is cleaner than a comment" | A status change with no evidence is unreadable in three weeks, and on someone else's ticket it is unexplainable |
| "There are twelve candidates, I'll list them and ask once" | A list invites one blanket yes. One ticket per message |
| "No period was given, so I'll ask which one" | Bare invocation is the normal case. Assignments have no window and asks default to 14 days — state what you used and get on with it |
| "This issue is months old, it can't still be live" | Assignments never expire on age. That judgment belongs to the person reading the queue, not to the sweep |
| "It's gone from the queue, so it got done" | It may have aged out of `SINCE` without ever being answered. Classify against the window before claiming anything closed |
| "There's no snapshot for that date, I'll just sweep and present it as that day" | A reconstructed past is a fabricated one. Say no snapshot exists |
| "I'll reset first_seen, the item looks different now" | `first_seen` is the age of the obligation, not of its wording. Resetting it hides exactly what the log is for |

## Red Flags

- Any workspace-specific literal in `SKILL.md` or `references/` instead of a profile key
- An item from an org in `{{exclude_orgs}}`, or from a tracker team outside `{{linear_teams}}`
- A completed, merged or closed item presented as owed
- An inferred item shown without the quote it was inferred from
- Bot-authored PRs (dependency bumps) counted as review requests
- Any write outside `{{work_log_dir}}` other than a step-13 confirmed close: a reply, a filed
  ticket, a reassignment, a project move
- A tracker write on a bare call, or any close without a confirmation naming that ticket
- An already-done candidate outside the scope rule — not created by and not assigned to
  `{{linear_user}}`
- A standing-duty ticket, or a weak-evidence backlog ticket, offered as an already-done candidate
- A close whose only evidence is a bare id in a merged PR body
- A `cleared` item marked `done` when its timestamp merely fell outside `SINCE`
- A run log committed to git rather than ignored
- Printing a queue without naming the sources that failed

## Verification

- [ ] Exactly one workspace resolved, and no key divergent across its profiles
- [ ] Every team in `{{linear_teams}}` queried, not just the first
- [ ] Every source attempted; unavailable ones named in the output
- [ ] Nothing completed, and nothing from `{{exclude_orgs}}`, appears in the list
- [ ] Every tier 2-4 item carries a confidence and a verbatim quote
- [ ] Noise filters applied — bot PRs, calendar invitations, metadata notifications, own messages
- [ ] Items ranked into the six bands, not sorted by tracker priority
- [ ] Diffed against the previous snapshot; every item marked `NEW` or `carried Nd`
- [ ] Cleared items classified `done` or `aged out`, never merged into one list
- [ ] Snapshot written to `{{work_log_dir}}`, with `first_seen` carried forward
- [ ] Already-done candidates printed as their own section, each with its evidence strength
- [ ] Every candidate is created by or assigned to `{{linear_user}}`; no standing duties, and no
      backlog ticket resting on weak evidence alone
- [ ] No tracker write happened unless `--close` was passed
- [ ] Every close was confirmed for that specific ticket, carries an evidence comment, and
      changed nothing but the status
- [ ] Declined candidates recorded in the run log so the next run does not re-ask
- [ ] Nothing else written to any system outside `{{work_log_dir}}`
