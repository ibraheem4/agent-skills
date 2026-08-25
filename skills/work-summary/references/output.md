# Blockers and output

Steps 12-13 of `work-summary`: deciding what counts as a blocker, writing in the person's
voice, and posting. Every `{{key}}` comes from the profile resolved in step 0.

## Step 12 — blockers

Blockers are not a source of their own — no API returns them. Derive them from what the
previous steps already surfaced, and only from that. These qualify:

- **Owed to them by a named person.** From that day's Granola notes: access, credentials,
  documents, decisions someone else committed to provide. These are the most reliable kind —
  a meeting is where they get promised.
- **Their PRs sitting unreviewed.** From step 2. Include the number and roughly how long it has
  been open. Two or more days of silence is worth a line; same-day is not. Measure the silence
  from `END`, not from today — a summary of last week judges staleness as of last Friday.
- **A Linear issue that says it's stuck.** From step 10: an issue in a blocked state, one whose
  latest comment is a question aimed at them, or one assigned to them that slipped its cycle. The
  tracker is the one source where "blocked" is recorded as a fact rather than inferred — but an
  open issue is not a blocked one, and neither is one with days left on it.
- **Blocked work they wrote down themselves** in an Outline doc, artifact, or Google Doc they touched
  that day. If they recorded "waiting on X" somewhere, it counts.
- **Access or credential gaps** hit during the day's work. Email (step 7) is usually where these
  resolve — a provisioning mail that arrived is a blocker *cleared*, and worth one line saying so
  if it was blocking yesterday.
- **A question they asked that nobody answered** — in Slack (step 8) or email (step 7). An ask
  from the last few hours of the period is not a blocker; one from two days before `END` is.
- **A Claude Code session that ended mid-problem** — from step 11: a credential they didn't
  have, a decision they parked, a failure they stopped on. A session that ends because the work
  finished is not a blocker, and neither is one that ends because they logged off.

Separate **waiting on a person** from **waiting on an external process** — a teammate needs a
nudge, a vendor review needs lead time, and conflating them makes the first look unactionable.
Name the person and the specific thing needed; "waiting on Dana" is useless next week, "Dana
owes Linear access" is not.

Same evidence bar as everything else: each blocker traces to a source from steps 2–11. **Do not
infer a blocker from work that merely looks unfinished** — an open PR is not blocked, and a task
with days left on the clock is not late. If nothing qualifies, omit the section; a day with no
blockers is the normal case, and an empty *Blockers* heading reads like a problem.

If they are present and something looks like a blocker but can't be sourced, ask rather than guess.

## Step 13 — write it in their voice, then post

**Voice.** Write as the person, first person, in their own voice: conversational,
contractions, plain words, no corporate register. They explain *why* briefly when it matters
and otherwise stays short. Not a bullet dump and not a status-report template — a short
writeup a colleague would actually read. Skip the exclamation marks; those belong in their
replies to people, not in notes to themselves.

**Matter-of-fact, not narrated.** State what happened and what it means. No scene-setting, no
"spent most of the day" hedging where a verb will do, no editorialising about how it went. Short
declarative sentences beat flowing ones here.

**Lead with what the period was actually about** — one sentence for a day, two at most for
anything longer. The thread connecting it, not a restatement of the bullets. Then stop and get
to the lists. The longer the period, the more this opening is the part they actually read.

**Every item earns its line, in one clause.** A title alone is useless, but so is a sentence
where a clause will do. Each PR, doc and artifact bullet says what it *is* or what changed —
substance, not filename. "#136 — the two local-setup requirements missing from CLAUDE.md" beats
both "#136 — docs(claude): local setup" and a full sentence explaining it. For a doc they edited,
say what they added, not that they edited it.

**Succinct is the point.** The shortest thing that still lets them reconstruct the period in a
month — PR numbers, doc names, one clause of substance each, and nothing else. Not every commit,
not the reasoning behind it, not the process, not how it went. Where a line and a merge both
work, merge. They are the only reader and they were there.

**Shape follows the period length.** Same sources, same voice, three shapes:

| Period | Header | Shape |
|---|---|---|
| 1 day | `**Thu 20 Aug**` | as the sample below — one bullet per item, merged where two would say one thing |
| 2–7 days | `**Mon 17 – Fri 21 Aug**` | same sections; prefix each bullet with the day (`Thu — …`) where it matters, and merge repeat work on one thing into a single bullet |
| 8+ days | `**3–21 Aug**` | themes, not entries: group by workstream, give counts with only the notable items named, and lead with what moved versus what stalled |

**Cut by default.** If a bullet is only there because an API returned it, cut it. Merged PRs that
were one task go on one line; a doc touched four times is one bullet. The test at any length is
whether they could have written it from memory — anything past that is padding, and going long is
where the padding creeps in.

***On me* is for what they owe, *Blockers* for what they're owed.** Step 8's pass B surfaces asks
and assignments; the ones still open at end of day go in *On me*, immediately before *Blockers*.
One line each, naming the thing and where it came from. Something they answered or finished the
same day does not belong there — check for their reply first.

**Meetings are omitted unless they explain something.** There is no standing *Meetings*
section. Name a meeting only when it carries weight: it produced a decision or an action that
shows up elsewhere in the summary, it is why a piece of work moved or stalled, or they asked for
their calendar. A day that was simply busy with calls is not information — they were there. When one
does belong, it goes in the opening line or attached to the bullet it explains, never in a list
of its own.

**Linear folds into the work it tracks; it gets no standing section.** A ticket behind a PR
already in *Code* rides along inside that bullet — `#136 — … (ACME-42)` — never as a line of its
own; that is the duplication step 10 exists to prevent. A ticket that moved with nothing in
GitHub behind it is what earns its own line, and several of those in one period earn a *Tickets*
heading. Issues assigned to them and still open at `END` go in *On me*, not into a ticket list.

**Claude Code sessions fold in; they do not get a section by default.** Most of what step 11
surfaces belongs in the opening line, or as the substance behind a *Code* bullet — the session
is why the PR looks like it does. Give it its own *Sessions* heading only for work that left no
commit, doc, or artifact behind, since that is the part nothing else in the summary records.

Format — this block is a **shape-and-voice sample, not data**, and it shows the one-day shape.
Every name, number, date and title in a real run comes from the sources above; never carry a
line out of this example into a posted summary.

```
*Wed 19 Aug*

Got billing-api running locally, then documented the two setup requirements that aren't
written down anywhere.

*Code* — billing-api
• #135 — gitignore Claude Code local overrides
• #136 — the submodule checkout and the auth-bypass env var, into CLAUDE.md (ACME-42)
Neither reviewed yet.

*Docs*
• Billing Login — Problems, Options & Decisions — my first-run notes: the missing-org error on
  my own sign-in, the duplicate login page
• billing-api — First-Run Setup Issues — new. Three startup blockers, two of them doc gaps

*On me*
• Infra migration plan doc — Dana's standup to-do, not started
• ACME-51 — billing auth onto the new IdP, mine since Tuesday, not started

*Blockers*
• Linear access from Dana — asked Monday, still nothing
```

Formatting rules:
- **Bold is `**double asterisks**`.** The Slack tool takes STANDARD markdown and converts it,
  so `*single*` renders italic, not bold — verified by reading a posted message back.
  Date header short and bold: `**Wed 19 Aug**` for a day, `**Mon 17 – Fri 21 Aug**` for a
  range, and drop the weekday once the period passes a week: `**3–21 Aug**`.
- `•` for bullets. Link with standard markdown `[text](url)`; it converts to Slack's
  `<url|text>` form correctly. Link PR numbers, Outline doc titles, Google Doc titles, and
  ticket ids — never paste bare URLs into prose. A design canvas is named by its artboard and
  project (step 6), never by its `claude.ai/design/p/<uuid>` link, which says nothing to a
  reader.
- A blank line immediately after a bullet list gets collapsed, so the next heading can end up
  flush against the list. Keep one short non-list line between a list and the next heading.
- Leave `unfurl_app_links` off by default. It gives GitHub links rich previews, which makes
  the message much taller; turn it on only if they ask for previews.
- Section headings only when that section has content. Never a heading over nothing.
- *On me* then *Blockers* go **last**, in that order — they're what they act on tomorrow, so they
  should be the thing they're left looking at. The exception is a blocker that stopped the day's actual work: that belongs in the
  opening narrative, because it explains the day rather than just following it.
- Put status inline as a closing line under a section ("Both still open, waiting on review")
  rather than a separate *Open* section — it reads less like a form.
- Strip the `chore(...)`/`docs(...)` conventional-commit prefixes from PR titles in prose;
  they're noise to a human reader. Keep the PR numbers.
- **Budget: a day is one narrative sentence plus at most ~8 bullets. A week or longer, two
  sentences plus ~14.** Headings and blank lines don't count. If the period genuinely produced
  more, merge related bullets and cut clauses — never drop a fact just to hit the number.
- Shortest thing that works wins. No preamble, no sign-off, no "here's what I did today", no
  closing summary of the summary.

Hard rules:
- **Never invent activity.** Every fact traces to a source above. A quiet period gets a quiet
  message — one line saying so beats a padded one. For a range, name the days that were empty
  rather than averaging them away; "nothing Tue or Wed" is information.
- If a source failed or returned nothing usable, say so in one short line rather than
  silently omitting it. A summary that looks complete but isn't is worse than an honest gap.
- **Say when the period outran a source.** The events feed aging out mid-period, the artifact
  list hitting its 50 cap, an unpaginated tail — each means partial coverage, and a long-period
  summary that hides it reads as authoritative when it isn't. One line at the end: what was
  capped and from when.
- No secrets, tokens, or `.env` values, even if they appear in a commit message or doc title.
- **Never mention work on this skill.** Sessions that edit this skill's own directory — the
  installed plugin copy or any checkout of the repo that ships it — are tooling maintenance, not workspace work — drop them silently. No *Sessions* line, no
  mention in the narrative, and they don't count toward deciding whether the day was quiet.
  A summary that talks about its own plumbing is noise to the person reading it.

**Draft, don't send.** Use `mcp__claude_ai_Slack__slack_send_message_draft`,
`channel_id: "{{chat_destination}}"`, and return the draft link so they can edit before it goes.
This is the default even when they say "post it" or "send it" — they are the only reader, and a
draft costs them one click.

Send outright with `mcp__claude_ai_Slack__slack_send_message` only when they ask for that
specifically, or when the run is unattended and nobody is there to press send.

A drafted summary they never send leaves no record, so the next run re-covers those days —
correct, but say so rather than letting a resend surprise them (step 1).
