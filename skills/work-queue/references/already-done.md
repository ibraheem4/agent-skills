# Already done, still open

A queue's worst failure is not missing an item. It is showing work that finished weeks ago, so
the reader loses trust in the whole list and stops reading it. This is the pass that finds
those, and the one place the pair is allowed to write to the tracker.

Everything here is **detection**. The close is a separate, human-confirmed act, described at
the bottom, and it never happens on a bare invocation.

## Why this lives in work-queue, not work-summary

The pair's boundary is "done belongs to `work-summary`, owed belongs here." A ticket that is
finished but still open looks like an obligation and is not one — it is a **defect in the owed
list**, which is this skill's own output. `work-summary` would have to re-derive the queue to
find them. So detection lives here; it is still true that reporting *what closed* belongs to
the other half.

## Evidence, strongest first

Rank every candidate by the best evidence it has, and **name the strength in the output**. The
reader is deciding whether to spend a click, and a weak signal presented like a strong one
costs more trust than staying silent.

| # | Signal | Strength | Why |
|---|---|---|---|
| 1 | A **merged** PR is attached to the open issue by the tracker integration | Strong | The integration made the link; nobody typed it. Attachment titles mirror the PR title verbatim with an empty subtitle — a hand-made one is prose |
| 2 | A merged PR's **branch name encodes the id** (`alex/abc-33-db-secret-runtime-retrieval`) | Strong | Branch names are generated from the ticket. Someone started that branch *for* that ticket |
| 3 | A merged PR body carries a **magic word** (`Closes ABC-33`) and the issue is still open | Strong | The author declared it closing. If the issue is open anyway, the automation failed rather than the work |

⚠️ **Match the magic word in both forms.** The tracker accepts `Closes ABC-123` *and*
`Closes <full issue URL>`, and people use the URL form when they paste from the browser. A
pattern that only reads the bare id silently demotes the strongest signal there is to a
passing mention — measured on the first real run, where the best candidate in the queue scored
"reference only" for exactly this reason. Match `clos(e|es|ed)|fix(es|ed)|resolv(e|es|ed)`
followed by either the id or a URL ending in it, and treat the two identically.
| 4 | A merged PR **title** contains the id | Moderate | Usually right, occasionally a "related to" |
| 5 | The id appears **anywhere** in a merged PR body | **Weak — usually wrong** | See the trap below |
| 6 | A colleague's comment says the work already exists | Moderate | Quote it verbatim; they may be describing a sibling |

## The trap that outranks all of them: a merged PR that says it is not finished

**Before believing any signal, read the merged PR for its own rollout caveats.** The very first
candidate this pass produced scored on signals 1, 2 **and** 3 — attached by the integration,
branch named for the ticket, id in the body — and was not merely unfinished but the most
urgent item in the whole queue. Its PR said so in plain text: *"Rollout is ordered, and merging
is not the whole of it."* The deploy workflow did not run `terraform apply`, so merging shipped
the new code path **dormant**, and the ticket's own acceptance list had one of three boxes met.
Closing it would have re-armed a 2h45m outage with a known recurrence date three days out.

Look for these words in a merged PR before trusting it, and drop the candidate to weak on any
of them: *rollout*, *ordered*, *step 1 / step 2*, *dormant*, *behind a flag*, *not verified*,
*follow-up required*, *merging is not*, *needs terraform apply*, *manual step*.

**Then check the ticket's own acceptance criteria against the PR's "what's here".** A ticket
with checkboxes has told you exactly what done means; a merged PR covering two of three is not
done, and that arithmetic is cheaper than any inference about it. Where the ticket names a
**date the problem returns**, that date makes it a band-2 queue item — the opposite of a
close candidate.

**Signal 5 is a trap, and it is the most common hit.** PR bodies cite tickets to say the
opposite of done: *deferred*, *pre-existing*, *its own ticket*, *out of scope here*. Measured
on this queue 2026-09-07 — of 7 still-open tickets referenced by a merged PR, **zero** carried
a magic word and at least two were referenced precisely as future work: `ABC-28` ("tear down
the tooling *once* sam/migration lands") was named by the very PR that built the tooling, and
`ABC-39` was named by two PRs that describe it as the next step. Read the sentence around the
id before believing it.

## Never candidates

- **Standing duties.** A ticket like "every invited broker gets in, and every failure gets
  root-caused" is a watch, not a deliverable. No merge finishes it, and closing it deletes an
  ongoing responsibility.
- **Parent or tracking issues** whose children are still open.
- **Tickets outside the scope rule below.**

**Backlog status is not a disqualifier, and assuming it was is a real bug this pass shipped
with.** The first version of this file excluded backlog outright, on the reasoning that nobody
had started it so any PR reference must be signal 5. Wrong: the strongest candidate on the
first real run was a **backlog** ticket whose fix had merged a week earlier under a branch
named for it — the author fixed it and never moved the status, which is precisely the failure
this pass exists to catch. Status tells you what someone remembered to update; it is not
evidence.

The rule that actually holds: **strong evidence (signals 1-3) overrides any status. Weak
evidence (4-5) plus a backlog status is not a candidate** — that combination is where the
false positives live.

## Scope: whose tickets this pass may touch

Read `{{linear_user}}`. A ticket qualifies if they **created it or it is assigned to them**.
Everything else is invisible to this pass — not merely un-closeable, but not reported either,
because a list of other people's stale tickets is someone else's queue.

⚠️ This is deliberately **wider than the tracker-hygiene rule** of "only update tickets you
created", and the widening is authorized: the assignee is accountable for the ticket's state
even when a colleague filed it. That rule's own skill carries the matching exception. If the
two ever disagree again, this pass is the narrower authority — stop and ask.

## Presenting candidates — one at a time

**Never batch.** One ticket per message, and wait for an answer before the next. A list of
twelve invites a single "yes to all", which is exactly the judgment this pass exists to keep
with the person.

Each candidate carries four things and nothing else:

```
ABC-33 · Backlog · created by you · https://linear.app/<org>/issue/ABC-33/…
  "broker-dev loses its DB credential on every RDS password rotation"
  What it actually is: one plain sentence, in case the id means nothing to them today
  Strong (2, 3): branch alex/abc-33-db-secret-runtime-retrieval, PR #99
                 "read the DB password from Secrets Manager per connection", merged 2026-09-04
                 https://github.com/<org>/<repo>/pull/99
  If closed, still open: nothing — this was the whole ticket
  Close it?
```

**Always print the ticket URL and the evidence PR's URL.** An id is not a recognisable name for
a piece of work — the first person to use this pass could not tell what one of their own
tickets was from `ABC-21`, and they had written it two weeks earlier. Someone being asked to
authorise a close needs to be able to open the thing in one click; an unclickable id makes the
confirmation a guess. The tracker read already returns a `url` field, so there is no excuse for
omitting it.

For the same reason, carry **one plain sentence saying what the work was** — not the title
reworded, but what it did and why anyone wanted it. A title written for the person who filed it
is rarely legible to the same person a fortnight later.

The "if closed, still open" line is the one that earns its place. State what the ticket asked
for that the evidence does **not** cover, so a partial fix does not get closed as a whole one.
When the evidence covers everything, say so plainly.

Rank candidates strongest-first and stop when the evidence goes weak. Say how many weaker ones
remain rather than walking through them: a pass that asks twelve questions gets answered once.

## The write

On an explicit yes, and only then:

1. Set the status to the team's completed state. Nothing else — never reassign, relabel or
   move a project.
2. Add one comment citing the evidence: the PR, its merge date, and the signal. A close with no
   explanation is unreadable in three weeks.
3. If `{{linear_user}}` did not create the ticket, the comment must say the close was made at
   their direction, so the author knows who to ask and can reopen it.

On anything other than a clear yes — a maybe, a "leave it", silence — **change nothing** and
move on. Record the declined candidate in the run log so the next run does not re-ask.

Never infer a second close from one yes. Never close as a batch. Never close to tidy up a
count.
