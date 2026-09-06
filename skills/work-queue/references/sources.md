# Sources

One section per source. Each carries the query, the noise filter it needs, and what the source
is actually good for. Connector tool names differ between hosts — some expose a readable name,
some an opaque id — so each section names the *capability* and the call shape rather than a
literal tool name.

Every measurement below was taken against one real working queue on 2026-09-06. Treat the
ratios as an order of magnitude, not a constant; treat the *filters* as required.

## Step 2 — tracker issues (tier 1)

The only tier with no inference in it. Everything here is owed because a system says so.

**Confirm the workspace first.** A tracker connector is OAuth'd to one workspace at a time and
the person may belong to several. Call the workspace/whoami read and compare against the
profile's workspace id. Mismatch — skip the source and say so; never report another company's
tickets into this queue.

**Query once per team in `{{linear_teams}}`:**

```
list_issues  assignee: "me", team: <team>, limit: 100,
             fields: [title, status, statusType, priority, dueDate, updatedAt, url, team]
```

**No window on this source.** Age is a ranking input, never a filter — an issue assigned
eight months ago is still owed, and dropping it is how a queue quietly loses its worst items.

Keep `statusType` in `unstarted`, `started`, `backlog`. Drop `completed` and `canceled` —
assigned-and-closed is not owed, and it is the most common way a queue inflates.

Separate `backlog` from `unstarted` before ranking. Backlog is a someday list; it belongs in
the tail count, never in the printed queue.

**Traps:**

- **Teams get added, and the profile lags.** This is the failure that motivated the skill:
  a profile naming one team while a second team, created days earlier, held 15+ assigned
  issues — so every sweep missed half the queue. When the queue looks thinner than expected,
  call the list-teams read and compare it against `{{linear_teams}}`.
- Paginate. A cursor means there is more; a first page of 15 is not the queue.
- `priority` is rarely a usable sort. Half a real queue sitting at Urgent is normal.
- `dueDate` is very often null on every single issue. Do not infer urgency from its absence.

## Step 3 — tracker inbox (tier 2)

What other people have said to you inside the tracker. Higher signal than chat, lower than
an explicit assignment.

```
get_notifications  unreadOnly: true, limit: 50
```

Bounded by `SINCE` — drop notifications older than the window.

**Whitelist the types that mean someone wants something.** Keep `issueCommentMention`,
`issueNewComment` where the issue is assigned to you, `issueAssignedToYou`, and
`projectAddedAsLead`. Everything else is churn.

Drop `projectDescriptionContentChange`, `projectUpdateCreated`, `issueStatusChanged` and
priority-change notifications. Measured: 5 of 15 notifications were project description edits
and 3 more were status changes — under half carried an ask of any kind.

The valuable ones read like a handoff: a colleague leaving a question they could not answer,
or saying outright that they are leaving an issue with you. Quote that sentence into the
output; it is usually more actionable than the issue title.

## Step 4 — GitHub (tiers 1 and 4)

```
gh search prs    --owner={{github_org}} --review-requested={{github_login}} --state=open
gh search prs    --owner={{github_org}} --author={{github_login}}           --state=open
gh search issues --owner={{github_org}} --assignee={{github_login}}         --state=open
```

**No window here either**, for the same reason as the tracker: a PR nobody reviewed in four
months is the most important thing this tier can tell you.

**Always pass `--owner={{github_org}}`.** Without it the search spans every org the account
touches, including everything in `{{exclude_orgs}}`. Measured without it: 5 of 5 results were
from excluded orgs, and every one was a dependency bot.

**Drop bot authors.** Dependency bumps are not review requests. Add `--json` and filter on the
author login, discarding `app/dependabot`, `app/renovate` and anything else flagged as a bot.
Bot PRs are the single largest source of false items in this tier.

**Two different bands.** Review requests of you are band 1 — someone is blocked. Your *own*
open PRs are band 3, stalled: not work, a nudge. Report their age; a PR untouched for ten days
is the item, not the code in it.

**Sandbox trap.** In a restricted sandbox, `gh` fails with a TLS `x509` certificate error and
`gh auth status` reports the keyring token as invalid — which reads exactly like a broken
login. The same commands succeed with the sandbox disabled. Verified 2026-09-06. Run GitHub
calls unsandboxed, and never report GitHub as unavailable on the strength of that error alone.

## Step 5 — mail (tier 2)

**The obvious query is the wrong one.** `to:me is:unread in:inbox` returned 10 of 10 items
that were calendar invitations and auto-generated meeting notes — six of them the same
recurring standup being rescheduled. Not one was an ask. Unread mail addressed to you is not
a to-do list.

Start from:

```
to:me is:unread in:inbox newer_than:<SINCE>
  -category:promotions -category:social -category:updates
  -subject:invitation -subject:"updated invitation"
  -from:me -in:sent
```

Then exclude automated senders — calendar notifications and meeting-notes bots are the bulk of
what survives. Add each one you see to the profile rather than to this file.

**Two predicates worth more than the query:**

- **To, not Cc.** A cc is an FYI. Require the person's address in the To line.
- **Last message is theirs.** A thread where you replied last is not owed. The search cannot
  express this; check the thread's final sender before counting it.

Only then read for an actual ask — a question mark, or an imperative directed at you.

## Step 6 — chat (tier 2)

Search mentions of the person's own id, restricted to `{{work_channels}}`, bounded by `SINCE`.

```
search  "<@USER_ID> after:<SINCE>"  sort: timestamp
```

Measured: 2 of 10 mention hits were genuine unanswered questions. The rest were cc-and-FYI
mentions, tracker-integration bot posts, and — worth knowing — the person's own messages
returned back to them by the search.

Drop: your own messages, bot and app posts, and mentions inside an announcement.

**Read the thread before counting it unanswered.** A hit is a message, not a conversation; you
may already have replied underneath it.

An ask looks like a question addressed to you, or a request for confirmation — *"let me know
if it worked"*, *"why do we need X"*. A decision announcement that cc's you is not an ask,
however important it is.

## Step 7 — meetings (tier 3)

**Usually the only source that produces dates.** On a queue where not one tracker issue had a
due date, the meeting notes produced two hard ones — including the deadline that ranked first
in the entire queue. This is why `--full` is worth running weekly even though it is slow.

Use `SINCE`, but **never less than 30 days** for this source. Commitments outlive a two-week
window — the promise everyone forgot is the one worth surfacing, and a short window hides
exactly that.

Query the notes in natural language: what did this person commit to, who asked, and was a date
mentioned. Then:

- **Quote the commitment.** A paraphrased promise is not verifiable and will be argued with.
- A date that exists only in a transcript is still a date. Surface it *loudly* — precisely
  because no other system knows about it.
- Notes often mark items "likely completed". They cannot know that. Keep those separate and
  labelled, and check them against the tracker before dropping them.
- Commitments decay. A promise from three weeks ago that nothing has moved on is either stale
  or the most overdue thing in the queue; show its age and let the person decide.

## Step 8 — calendar (tier 3)

The next three working days. Two things qualify as queue items: a meeting that needs
preparation, and a meeting that is really a deadline (a review, a demo, a hand-off).

A meeting you merely attend is not a queue item. Do not pad the list with your own schedule.

## Step 9 — wiki and docs (tier 3)

Documents where the person is mentioned, or which carry unresolved questions addressed to
them. Lowest-yield source here — it is in `--full` for that reason. Filter to the workspace's
own wiki base; a personal or cross-company doc space does not belong in this queue.

## Step 10 — local work-in-progress (tier 4)

Assigned by past you. All local, so it is the cheapest tier to verify and the easiest to
over-report.

- Branches under `{{workspace_root}}` with commits ahead of their default branch
- Draft PRs authored by `{{github_login}}`
- Sessions matching `{{transcript_glob}}` that ended mid-task

**A branch whose commits are already merged upstream is not in flight.** Compare against the
remote default branch, not the local one, before listing it.

**Skip worktree directories.** A workspace that keeps worktrees inside a dot-directory will
otherwise report the same branch several times over.
