# Blockers and output

Steps 11-12 of `work-summary`: deciding what counts as a blocker, writing in the person's
voice, and posting. Every `{{key}}` comes from the profile resolved in step 0.

## Step 11 — blockers

Blockers are not a source of their own — no API returns them. Derive them from what the
previous steps already surfaced, and only from that. These qualify:

- **Owed to him by a named person.** From that day's Granola notes: access, credentials,
  documents, decisions someone else committed to provide. These are the most reliable kind —
  a meeting is where they get promised.
- **His PRs sitting unreviewed.** From step 2. Include the number and roughly how long it has
  been open. Two or more days of silence is worth a line; same-day is not. Measure the silence
  from `END`, not from today — a summary of last week judges staleness as of last Friday.
- **Blocked work he wrote down himself** in an Outline doc, artifact, or Google Doc he touched
  that day. If he recorded "waiting on X" somewhere, it counts.
- **Access or credential gaps** hit during the day's work. Email (step 7) is usually where these
  resolve — a provisioning mail that arrived is a blocker *cleared*, and worth one line saying so
  if it was blocking yesterday.
- **A question he asked that nobody answered** — in Slack (step 8) or email (step 7). An ask
  from the last few hours of the period is not a blocker; one from two days before `END` is.
- **A Claude Code session that ended mid-problem** — from step 10: a credential he didn't
  have, a decision he parked, a failure he stopped on. A session that ends because the work
  finished is not a blocker, and neither is one that ends because he logged off.

Separate **waiting on a person** from **waiting on an external process** — a teammate needs a
nudge, a vendor review needs lead time, and conflating them makes the first look unactionable.
Name the person and the specific thing needed; "waiting on a teammate" is useless next week, "a teammate
owes Linear access" is not.

Same evidence bar as everything else: each blocker traces to a source from steps 2–10. **Do not
infer a blocker from work that merely looks unfinished** — an open PR is not blocked, and a task
with days left on the clock is not late. If nothing qualifies, omit the section; a day with no
blockers is the normal case, and an empty *Blockers* heading reads like a problem.

If he is present and something looks like a blocker but can't be sourced, ask rather than guess.

## Step 12 — write it in his voice, then post

**Voice.** Write as the person, first person, in their own voice: conversational,
contractions, plain words, no corporate register. He explains *why* briefly when it matters
and otherwise stays short. Not a bullet dump and not a status-report template — a short
writeup a colleague would actually read. Skip the exclamation marks; those belong in his
replies to people, not in notes to himself.

**Matter-of-fact, not narrated.** State what happened and what it means. No scene-setting, no
"spent most of the day" hedging where a verb will do, no editorialising about how it went. Short
declarative sentences beat flowing ones here.

**Lead with what the period was actually about** — one sentence for a day, two at most for
anything longer. The thread connecting it, not a restatement of the bullets. Then stop and get
to the lists. The longer the period, the more this opening is the part he actually reads.

**Every item earns its line, in one clause.** A title alone is useless, but so is a sentence
where a clause will do. Each PR, doc and artifact bullet says what it *is* or what changed —
substance, not filename. "#136 — the two local-setup requirements missing from CLAUDE.md" beats
both "#136 — docs(claude): local setup" and a full sentence explaining it. For a doc he edited,
say what he added, not that he edited it.

**Succinct is the point.** The shortest thing that still lets him reconstruct the period in a
month — PR numbers, doc names, one clause of substance each, and nothing else. Not every commit,
not the reasoning behind it, not the process, not how it went. Where a line and a merge both
work, merge. He is the only reader and he was there.

**Shape follows the period length.** Same sources, same voice, three shapes:

| Period | Header | Shape |
|---|---|---|
| 1 day | `**Thu 20 Aug**` | as the sample below — one bullet per item, merged where two would say one thing |
| 2–7 days | `**Mon 17 – Fri 21 Aug**` | same sections; prefix each bullet with the day (`Thu — …`) where it matters, and merge repeat work on one thing into a single bullet |
| 8+ days | `**3–21 Aug**` | themes, not entries: group by workstream, give counts with only the notable items named, and lead with what moved versus what stalled |

**Cut by default.** If a bullet is only there because an API returned it, cut it. Merged PRs that
were one task go on one line; a doc touched four times is one bullet. The test at any length is
whether he could have written it from memory — anything past that is padding, and going long is
where the padding creeps in.

***On me* is for what he owes, *Blockers* for what he's owed.** Step 8's pass B surfaces asks
and assignments; the ones still open at end of day go in *On me*, immediately before *Blockers*.
One line each, naming the thing and where it came from. Something he answered or finished the
same day does not belong there — check for his reply first.

**Meetings are omitted unless they explain something.** There is no standing *Meetings*
section. Name a meeting only when it carries weight: it produced a decision or an action that
shows up elsewhere in the summary, it is why a piece of work moved or stalled, or he asked for
his calendar. A day that was simply busy with calls is not information — he was there. When one
does belong, it goes in the opening line or attached to the bullet it explains, never in a list
of its own.

**Claude Code sessions fold in; they do not get a section by default.** Most of what step 10
surfaces belongs in the opening line, or as the substance behind a *Code* bullet — the session
is why the PR looks like it does. Give it its own *Sessions* heading only for work that left no
commit, doc, or artifact behind, since that is the part nothing else in the summary records.

Format — this block is a **shape-and-voice sample, not data**, and it shows the one-day shape.
Every name, number, date and title in a real run comes from the sources above; never carry a
line out of this example into a posted summary.

```
*Wed 19 Aug*

Got broker-platform running locally, then documented the two setup requirements that aren't
written down anywhere.

*Code* — broker-platform
• #135 — gitignore Claude Code local overrides
• #136 — the spine checkout and AGENT_DEV_AUTH_BYPASS, into CLAUDE.md
Neither reviewed yet.

*Docs*
• Broker Login — Problems, Options & Decisions — my first-run notes: no_org on my own sign-in,
  the duplicate login page
• broker-platform — First-Run Setup Issues — new. Three startup blockers, two of them doc gaps

*On me*
• AWS migration plan doc — a teammate's standup to-do, not started

*Blockers*
• Linear access from a teammate — asked Monday, still nothing
```

Formatting rules:
- **Bold is `**double asterisks**`.** The Slack tool takes STANDARD markdown and converts it,
  so `*single*` renders italic, not bold — verified by reading a posted message back.
  Date header short and bold: `**Wed 19 Aug**` for a day, `**Mon 17 – Fri 21 Aug**` for a
  range, and drop the weekday once the period passes a week: `**3–21 Aug**`.
- `•` for bullets. Link with standard markdown `[text](url)`; it converts to Slack's
  `<url|text>` form correctly. Link PR numbers, Outline doc titles, and Google Doc titles —
  never paste bare URLs into prose.
- A blank line immediately after a bullet list gets collapsed, so the next heading can end up
  flush against the list. Keep one short non-list line between a list and the next heading.
- Leave `unfurl_app_links` off by default. It gives GitHub links rich previews, which makes
  the message much taller; turn it on only if he asks for previews.
- Section headings only when that section has content. Never a heading over nothing.
- *On me* then *Blockers* go **last**, in that order — they're what he acts on tomorrow, so they
  should be the thing he's left looking at. The exception is a blocker that stopped the day's actual work: that belongs in the
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
- **Never mention work on this skill.** Sessions that edit `~/.claude/skills/work-summary/`
  are tooling maintenance, not workspace work — drop them silently. No *Sessions* line, no
  mention in the narrative, and they don't count toward deciding whether the day was quiet.
  A summary that talks about its own plumbing is noise to the person reading it.

Post with `mcp__claude_ai_Slack__slack_send_message`, `channel_id: "{{chat_destination}}"`. Return the
message link.

When he's present and may want to tweak wording first, `slack_send_message_draft` is the
better call.
