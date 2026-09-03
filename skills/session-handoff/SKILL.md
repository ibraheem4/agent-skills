---
name: session-handoff
description: Use when asked for a continuation prompt, a prompt to run after clearing context, a handoff before logging off, or when picking one up — "how do I resume this later", "give me a prompt to start a new session", "resume from the previous session". Writes a handoff a cold session can act on without re-deriving anything.
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

## Common Rationalizations

| Excuse | Why It's Wrong |
|---|---|
| "I'll describe the branch, they'll find it" | They will guess wrong, or work on the default branch |
| "It's obviously still on that branch" | Between sessions, someone rebased, merged, or renamed it |
| "I'll list a few options for what's next" | The next session picks the wrong one and you have lost the context that would have prevented it |
| "The tests passed earlier so I'll write that they pass" | Earlier is not now, and you did not read that output |

## Verification

- [ ] Every path is absolute; every branch and sha is real and copied, not recalled
- [ ] Every "done" line names the command that proved it
- [ ] Skipped checks are listed explicitly
- [ ] Exactly one next step
- [ ] No secrets, tokens, or env values anywhere in the block
- [ ] When picking one up: claims re-verified before acting on them
