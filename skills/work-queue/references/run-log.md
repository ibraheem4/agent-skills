# The run log

Both halves of the pair write here, so a person can ask what they owed last Tuesday and what
they finished that week from the same directory. `work-queue` writes a full snapshot and diffs
against the previous one; `work-summary` writes a one-line record of what it covered.

```
{{work_log_dir}}/queue/YYYY-MM-DD-HHMM.md
{{work_log_dir}}/summary/YYYY-MM-DD-HHMM.md
```

If the profile does not define `{{work_log_dir}}`, default to
`{{workspace_root}}/.claude/work-log`. Create it on first use. **Add it to the workspace's
`.gitignore`** — a run log is personal working state and does not belong in a shared history.

This is the only thing either skill writes, and it writes nothing outside this directory. The
read-only promise is about other people's systems — the tracker, GitHub, chat, mail — and that
promise is unchanged.

## Snapshot format

```markdown
# work-queue · 2026-09-06T12:34 · default scope · asks since 2026-08-23

| id | band | first_seen | title |
|---|---|---|---|
| linear:ABC-12 | 1 | 2026-09-06 | Vendor probe — a teammate is blocked on credentials |
| gh:<org>/<repo>#173 | 3 | 2026-08-28 | Derive the auth middleware matcher check |
| slack:C0XXXXXXXXX:1757021175.001 | 1 | 2026-09-06 | A teammate — why three repos |

## cleared since 2026-09-04
| linear:ABC-40 | done |
| slack:C0XXXXXXXXX:1756900000.002 | aged out |

## already-done
| linear:ABC-33 | closed 2026-09-07 | strong — branch + PR #99 merged 2026-09-04 |
| linear:ABC-21 | declined 2026-09-07 | keep asking? no |

## judgments
| slack:C0XXXXXXXXX:1757021175.001 | discharged 2026-09-06 — standup | "took it verbally instead" |
| linear:ABC-12 | ranked 5 by owner 2026-09-06 | "nothing is needed from them" |
```

## Already-done candidates, and why declines must persist

Step 13's section records three outcomes, and the third is the one that matters across runs.

- **`closed <date>`** with the evidence that justified it. The ticket leaves the queue on the
  next run as a normal `cleared … done`; this line is the audit trail for why.
- **`offered <date>`** — presented, no answer given. Offer it again next run.
- **`deferred <date>`** — **the default answer to anything that is not a yes.** The ticket
  stays open and stays in the queue; it simply stops being offered as a close candidate, and
  ranks below anything with live evidence. Deferring is cheap and reversible, which is the
  point.
- **`declined <date>`** — never offer this again, ever. **Only ever record this when the person
  says so in those terms.** Never infer it from a "no", a "not now", a "leave it", or silence.

⚠️ **Do not promote a soft answer into a hard state.** "Not now", "defer it", "deprioritize it"
and "leave it open" all mean `deferred`. Reading any of them as `declined` permanently deletes
a candidate on the strength of a passing remark, and the person who said "not now" has no way
to know it will never be raised again. The same mistake in the other direction — treating a
scheduling remark as a status change on the ticket itself — is why step 13 writes nothing
without a per-ticket confirmation.

A `declined` is a statement about the ticket rather than about that day's evidence, so it
survives new evidence arriving. A `deferred` does not: if a genuinely stronger signal appears
later, offering it again is correct.

## Judgments that outlive the evidence

Two things a person says about an item are **not** facts about the item, and both must survive
into the next run or the sweep will undo them. Neither is an already-done state; they apply to
any item, including ones nobody would ever close.

- **`discharged <date> — <where>`** — the ask was answered, but **somewhere the sweep cannot
  see**: out loud in a standup, on a call, in person. The source still shows it unanswered and
  always will. A discharged ask does not print again.
- **`ranked <band> by owner <date>`** — the person moved an item out of the band the evidence
  put it in. Keep it at their band until *new* evidence arrives; re-deriving the old band from
  the same evidence is the sweep overruling them once a day, every day.

Record the person's own words next to each, because both states are claims the sources
contradict, and in three weeks the log is the only thing that remembers why.

⚠️ **The out-of-band answer is the failure mode that never self-corrects.** Measured
2026-09-15: two asks — a thread and a DM — were answered verbally at a standup five minutes
after the queue printed. Nothing was typed, so both still read as unanswered in chat. Without
this state, every future run re-surfaces them as band-1 "blocking someone else", the person
re-explains that they handled it, and the queue's most urgent band is permanently wrong. The
same run also demoted two band-1 items on the person's say-so; the log had to carry a prose
"do not re-rank these next run", which is exactly the instruction a structured state replaces.

**Discharged is not done.** The ask is settled; the work it asked for usually is not. The
09-15 standup answered *whether* the verification pass would happen — nobody had performed it.
Close the ask, keep the work, and say which is which.

**Ask before recording either.** Both come from the person telling you. Never infer a discharge
from a meeting that merely happened near the ask, and never infer a band override from the
person not mentioning an item — silence is not a ranking.

## Ids must be stable

An id identifies the *thing owed*, not how it looked on one day. Title and band both change
between runs — an issue moves from band 5 to band 1 the moment someone asks about it — so
neither may appear in the id.

| Source | Id |
|---|---|
| Tracker issue | `linear:<identifier>` — `linear:ABC-12` |
| GitHub | `gh:<owner>/<repo>#<number>` |
| Chat | `slack:<channel_id>:<message_ts>` |
| Mail | `mail:<thread_id>` |
| Meeting commitment | `meeting:<meeting_id>:<first six words of the quote, hyphenated>` |
| Local work-in-progress | `local:<repo>:<branch>` |

Meeting commitments are the weak one: they have no natural key, and a re-worded quote produces
a new id and a false `NEW`. Prefer the tracker item when a commitment has one — a promise that
became ABC-3 is `linear:ABC-3`, not a meeting id.

## The diff

Read the most recent snapshot before printing. For each item in the current sweep:

- **`NEW`** — the id is absent from the previous snapshot. `first_seen` is today.
- **`carried Nd`** — the id was present. Copy `first_seen` forward unchanged and let
  `N = today − first_seen`. Never reset `first_seen`; an item that vanished and came back is
  genuinely as old as it looks.

`first_seen` is the only counter, deliberately. A run count would say "×5" after five runs in
one afternoon, which tells the reader nothing; days tell them what they actually want to know.

## Items that disappear — two very different reasons

Anything in the previous snapshot and absent now goes under `## cleared`, **classified**:

- **`done`** — it would still be in scope, so its absence means it closed: the issue completed,
  the PR merged, the question answered.
- **`aged out`** — an ask whose timestamp is now older than `SINCE`. It was never done. It fell
  out of the window.

**Do not conflate these.** Reporting an aged-out question as `done` tells the person they
handled something they ignored, which is the single most damaging thing this log could get
wrong. Check the item's own timestamp against `SINCE` before classifying; when the two cannot
be told apart, say `unknown` rather than guessing.

Never re-query a source to find out why something vanished. The classification is a comparison
against the window, not an investigation.

## Reading the past

`--as-of <date>` prints the nearest snapshot at or before that date **instead of sweeping**.
No queries, no diff — it is a read of what was true then. Say which snapshot was used and its
timestamp, since "nearest at or before" may not be the date asked for.

If no snapshot exists at or before that date, say so plainly. Do not sweep and present today's
queue as though it were that day's; a reconstructed past is a fabricated one.

## Retention

Snapshots are a few kilobytes. Keep them. If the directory is ever pruned, keep the oldest
snapshot for every item still open — `first_seen` is read from it, and losing it silently
resets every age in the queue to today.
