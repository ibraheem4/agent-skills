---
name: session-handoff
description: Use when asked for a continuation prompt, a prompt to run after clearing context, a handoff before logging off, or when picking one up — "how do I resume this later", "give me a prompt to start a new session", "resume from the previous session". Also use when a session's work has shipped or is winding down, or when asked "anything else for this session?" — close it out without waiting to be asked: follow-ups filed, the system of record reconciled, a handoff written. Writes a handoff a cold session can act on without re-deriving anything.
---

# Session Handoff

## Overview

A handoff is a prompt for a session with no memory of this one. The failure mode is a
document that reads well and still leaves the next session rediscovering state — because it
referred to "the worktree" and "that branch" instead of naming them, or because it claimed
work was done that was never run.

Write it as a block to paste, not as prose about what to paste. Keep it under a page.

## When to Use

- Asked for a continuation prompt, or a prompt to run after clearing context
- Wrapping up before a break, with work still in flight
- The session's main work has shipped, or the user asks whether anything is left — run
  **Closing a session** below instead of listing follow-ups and waiting to be told to file them
- Starting from a handoff someone else — or an earlier session — wrote

## Core Process

### 1. The template

```
## Where this is
<repo> on branch <branch>, worktree at <absolute path>.
Last commit: <sha> <subject>. Pushed: yes/no. PR: <url or none>.

## What is done
- <one clause each, only what is verified>

## Immediate next step
<one concrete action, named precisely enough to start on>

## What is blocked, and on whom
- <blocker> — waiting on <person/thing>

## Verified vs assumed
Verified: <commands run and what they printed>
Assumed: <anything not checked>

## Traps hit this session
- <thing that cost time, and the fix>
```

### 2. Rules for writing one

| Rule | Why |
|---|---|
| **Absolute paths, real branch names, real shas** | A cold session cannot resolve "the worktree" or "that branch" |
| Only claim done what you ran and read the output of | Include the command, so the next session can re-run it |
| Name what you skipped | Silence reads as green |
| One concrete next step, not a menu | A menu makes the next session redo your decision |
| Say which repos, and where they sit relative to each other | Multi-repo work stalls on layout assumptions |
| Never include a secret, token, or env value | Handoffs get pasted into chat, tickets, and docs |

If part of the work is blocked, say what is finished, what is left, and why. Scaling the
work down is the requester's call, not yours.

### 3. Where it goes

- **Default:** a chat message or a paste block. Ephemeral by design, which is correct — the
  handoff describes a moment.
- **If it must persist:** the team's system of record, wherever documentation actually
  lives.
- **A `HANDOFF.md` in a repo root** works for a short-lived, single-machine handoff. It will
  fork if it lives longer than a day, so do not treat it as documentation.

### 4. Picking one up

1. Read it fully before running anything.
2. **Re-verify its claims rather than trusting them.** State is the thing most likely to have
   moved: branch heads, ports, running containers, whether a PR merged.
3. Check the branch still exists, and whether the base or lead branch has moved under it.
4. Then start at the named next step.

A handoff is a claim about the past. Treat every line as needing confirmation, especially the
ones that say something is already done.

### 5. Closing a session

A list of follow-ups in chat is not a close-out. The user should not have to ask for any of
this. Resolve the workspace profile first (`~/<workspace>/.claude/workspace.config.md`); its
`closeout` key says what is pre-approved. Without that key, offer these steps once, as one
question, and do not repeat it.

1. **Reconcile before recording.** For everything the session removed, renamed or retired,
   search the system of record (`{{wiki_base}}` and its registries) for it by name. A record
   that says "kept deliberately" turns a follow-up into a decision for the owner. Surface it;
   don't file it as a cleanup task.
2. **File each follow-up in the tracker** (`{{tracker}}`, through the tracker-hygiene skill):
   one ticket per independent piece, in the matching project, related to any existing ticket
   rather than duplicating it. Each ticket names paths, shas and a done-when line.
3. **Update the system of record:** append the session to its log, and correct any page or
   registry entry the session made false. Commit only those paths. Push when the profile's
   `closeout` allows it.
4. **Update agent memory** with what was non-obvious, not a restatement of the commits.
5. **Reply with the handoff block** (§1), with ticket ids in place of prose, and exactly one
   next step.

Never file a ticket for work that was blocked by a permission denial as if an agent could do
it. Say that it needs the user.

## Common Rationalizations

| Excuse | Why It's Wrong |
|---|---|
| "I'll describe the branch, they'll find it" | They will guess wrong, or work on the default branch |
| "It's obviously still on that branch" | Between sessions, someone rebased, merged, or renamed it |
| "I'll list a few options for what's next" | The next session picks the wrong one and you have lost the context that would have prevented it |
| "The tests passed earlier so I'll write that they pass" | Earlier is not now, and you did not read that output |
| "I'll list the follow-ups and let them say whether to file them" | That makes the user ask every session. Filing them is the close-out |
| "It's unused, so the teardown is a plain follow-up" | Unused is not the same as unwanted. Check the record for a keep decision first |

## Verification

- [ ] Every path is absolute; every branch and sha is real and copied, not recalled
- [ ] Every "done" line names the command that proved it
- [ ] Skipped checks are listed explicitly
- [ ] Exactly one next step
- [ ] No secrets, tokens, or env values anywhere in the block
- [ ] When picking one up: claims re-verified before acting on them
- [ ] When closing: follow-ups are tickets, the record is reconciled and committed, memory is updated
