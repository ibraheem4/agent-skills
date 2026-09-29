---
name: session-handoff
description: Use when asked for a continuation prompt, a prompt to run after clearing context, a handoff before logging off, or when picking one up — "how do I resume this later", "give me a prompt to start a new session", "resume from the previous session". Also use when a session's work has shipped or is winding down, or when asked "anything else for this session?" — close it out without waiting to be asked: tickets updated and follow-ups filed, the system of record and internal and external docs corrected, the record linted, a handoff written. Writes a handoff a cold session can act on without re-deriving anything.
---

# Session Handoff

## Overview

A handoff is a prompt for a session with no memory of this one. The failure mode is a
document that reads well and still leaves the next session rediscovering state — because it
referred to "the worktree" and "that branch" instead of naming them, or because it claimed
work was done that was never run.

Write it as a block to paste, not as prose about what to paste. Keep it under a page.

**Where a tracker already holds the state, the tracker is the handoff.** A pasted block then
duplicates the ticket comments, the log and memory, and goes stale as soon as the lead branch
moves. The full block is for state that lives nowhere else: uncommitted work, a half-finished
branch, a running process, a decision made mid-task. The profile's `handoff` key says which
applies (§3).

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

- **Profile says `handoff: tracker`:** the tracker, the system of record's log and agent memory
  carry it. The reply is a summary of three lines at most plus ticket ids, and the next session
  starts by reading the tracker (a work-queue sweep), not a pasted block. Write the full block
  anyway when state lives nowhere else — uncommitted changes, a branch mid-edit, a process that
  must keep running — and put it in the ticket it belongs to, not only in chat.
- **Default, or `handoff: block`:** a chat message or a paste block. Ephemeral by design, which is correct — the
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
question, and do not repeat it. A profile key that is missing means that layer is skipped and
named in the handoff, not guessed.

| Key | What it names |
|---|---|
| `wiki_base` | The system of record: its log, pages and registries |
| `wiki_lint` | The command that health-checks the system of record |
| `docs_internal` | Repo docs agents and staff read: instruction files, READMEs, runbooks, specs |
| `docs_external` | Docs customers read, and how each is generated and published |
| `tracker` | Where tickets live, and the hygiene skill that guards writes |
| `handoff` | `tracker` (the tracker carries continuation; reply with a short summary) or `block` (the paste block; the default) |

1. **Reconcile before recording.** For everything the session removed, renamed or retired,
   search the system of record for it by name. A record that says "kept deliberately" turns a
   follow-up into a decision for the owner. Surface it; don't file it as a cleanup task.
2. **Update the tracker** (`{{tracker}}`, through its hygiene skill).
   - Tickets the session worked on: add the commits, PR, deploy or run ids, and what is still
     unverified. Move the state only when `closeout` allows it; otherwise put the exact change
     ("ENG-12 → Done, verified by …") in the handoff for the user to approve.
   - Follow-ups: one ticket per independent piece, in the matching project, related to any
     existing ticket rather than duplicating it. Each names paths, shas and a done-when line.
   - Never file work blocked by a permission denial as if an agent could do it. Say that it
     needs the user.
3. **Update every doc the session made false or incomplete**, in three layers:
   - **System of record** (`{{wiki_base}}`): append the session to its log; correct any page
     or registry entry it contradicted. A rule the owner stated in the session goes into the
     page or skill that governs that work, quoting the owner. Never promote a proposal or your
     own inference into a decision.
   - **Internal docs** (`{{docs_internal}}`): any command, path, env name, deploy step, API
     contract or behaviour the session changed.
   - **External docs** (`{{docs_external}}`): public docs, API reference, changelog. Where a
     page is generated, edit its source and run the generator, never the output. Publishing
     is an outward action and needs approval unless `closeout` covers it.
   To find what went stale, search each layer for every name the session changed (field,
   route, label, command, env var). Prove the search works on one term you know is present
   first.
4. **Lint what you wrote.** Run `{{wiki_lint}}`, and the repo's doc checks where they exist
   (a docs-sync `--check`, link or markdown lint). Fix mechanical findings in the same pass;
   report judgment findings to the owner. A lint you skipped is named in the handoff.
5. **Commit only those paths**, staged and committed in one command. Push when `closeout`
   allows it.
6. **Update agent memory** with what was non-obvious, not a restatement of the commits.
7. **Reply.** With `handoff: tracker` and nothing left outside the tracker: three lines at
   most — what shipped, what waits on whom, the one next step — with ticket ids. Otherwise the
   handoff block (§1), with ticket ids in place of prose, the docs updated by path, lint results,
   and exactly one next step.

## Common Rationalizations

| Excuse | Why It's Wrong |
|---|---|
| "I'll describe the branch, they'll find it" | They will guess wrong, or work on the default branch |
| "It's obviously still on that branch" | Between sessions, someone rebased, merged, or renamed it |
| "I'll list a few options for what's next" | The next session picks the wrong one and you have lost the context that would have prevented it |
| "The tests passed earlier so I'll write that they pass" | Earlier is not now, and you did not read that output |
| "I'll list the follow-ups and let them say whether to file them" | That makes the user ask every session. Filing them is the close-out |
| "It's unused, so the teardown is a plain follow-up" | Unused is not the same as unwanted. Check the record for a keep decision first |
| "The commit message documents it" | Nobody reads history to learn how a service deploys. The runbook they do read is now wrong |
| "The public docs are generated, so they'll catch up" | They regenerate from a source nobody edited. Edit the source, run the generator |
| "I'll lint the wiki next session" | The next session inherits broken links it didn't write and can't attribute |
| "The ticket is obviously done, I'll close it" | Closing is a state change the profile may reserve for the owner. Propose it |
| "I'll paste the full block as well, to be safe" | With `handoff: tracker` it restates the tickets and is stale by the next session. The summary points at them |
| "The tickets say it all" | Not an uncommitted change or a process left running. That still needs the block, in its ticket |

## Verification

- [ ] Every path is absolute; every branch and sha is real and copied, not recalled
- [ ] Every "done" line names the command that proved it
- [ ] Skipped checks are listed explicitly
- [ ] Exactly one next step
- [ ] With `handoff: tracker`: a short summary with ticket ids, and a full block only for state
      the tracker cannot hold
- [ ] No secrets, tokens, or env values anywhere in the block
- [ ] When picking one up: claims re-verified before acting on them
- [ ] When closing: worked tickets carry their commits and state (or a proposed state change);
      follow-ups are tickets
- [ ] When closing: system of record, internal and external docs searched for every changed
      name, and corrected at the source
- [ ] When closing: `wiki_lint` and repo doc checks ran, or are named as skipped; the record is
      committed and memory is updated
