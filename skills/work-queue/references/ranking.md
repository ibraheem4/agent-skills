# Ranking and output

## Why not priority order

Two facts about real queues drive the whole design:

1. **Tracker priority goes flat.** A queue with half its items at Urgent has no ordering left
   in that field. Sorting by it produces an arbitrary list wearing a confident label.
2. **Dates live somewhere else.** Due-date fields are frequently empty across an entire queue
   while real deadlines sit in meeting notes and chat. A ranking that reads only the tracker
   cannot see the thing that is actually due first.

So rank on evidence gathered across sources, and use tracker priority only as a tie-break
inside one band.

## The six bands

Print in this order. A band with nothing in it gets one line saying so — an empty top band is
information, not a gap to fill.

**1 — Blocking someone else.** A review requested of you on someone else's open PR. A direct
question addressed to you, unanswered for more than a working day. An issue a colleague
explicitly handed to you in a comment. First because these are usually minutes of work that
unblock somebody else's day, and because the cost of missing them lands on another person.

**2 — Dated.** Anything with a real date, from any source, ordered nearest first. A date from
a meeting transcript counts; label where it came from, since a date no system knows about is
the one most likely to be missed.

**3 — Stalled on someone else.** Your own open PRs with no reviewer, your issues waiting on an
external dependency or an access request. These are not work — they are one message each. They
rank this high because they rot silently and because clearing them is nearly free. Always show
age; a PR untouched for ten days *is* the item.

**4 — In flight.** Started and unfinished: tracker status started, draft PRs, sessions that
stopped mid-task. Finishing beats starting.

**5 — Assigned, not started.** Todo, not backlog. This is the only band where tracker priority
is the tie-break.

**6 — Inferred.** Asks and promises carrying no date — everything from the chat, mail and
meeting tiers that did not earn a place above. Always printed with its quote.

## Tie-breaks

Oldest first within every band, except band 2, which is nearest-date first. Age is the tie-
break because the queue's job is to surface what is quietly rotting, and recency bias is what
lets that happen.

## Output

A header line: the workspace, today's date, the scope that ran (default or `--full`), the
`SINCE` window used for asks, the snapshot it diffed against, and any source that failed. State
the window even when it is the default — the reader cannot otherwise tell a quiet week from a
narrow sweep. Say when there was no previous snapshot; a first run has no diff and should not
imply everything is new work. Failures are named, never silently dropped — a queue missing a source is
a different queue, and the reader has to know which one they are looking at.

Then at most **ten items**. A list nobody finishes is not a priority list. Everything past the
cut becomes one line: `and N more — ask for the tail`. Backlog items are never in the printed
list; they only add to that count.

One line per item:

```
[band] What it is · source · age or date · NEW | carried Nd · link
        "the quote it was inferred from"        <- tiers 2-4 only
```

Then one closing line for what left the queue since the last run, with the two reasons kept
apart:

```
cleared since 2026-09-04: 2 done · 1 aged out (never answered)
```

Never print a bare "3 cleared". The whole value of that line is the distinction between work
that finished and an ask that quietly expired, and merging them tells the reader they handled
something they ignored.

The quote is not decoration. It is what lets the reader reject a wrong inference in one glance
instead of clicking through to find out. An inferred item without its quote should not print.

## The closing line

End with a single sentence naming the one thing to do first, and why it beat the rest. A
ranked list still leaves the choice open; the reader asked what to work on.

Do not hedge it across three options. Name one.

## What never appears

- Anything completed, merged or closed
- Anything from an org or team the profile excludes
- Meetings the person merely attends
- Bot-authored PRs
- The person's own chat messages, returned by their own mention search
- Any item the skill acted on — it does not act
