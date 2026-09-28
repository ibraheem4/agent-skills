---
name: agent-instruction-files
description: Use when setting up, auditing or fixing the instruction files coding agents read — CLAUDE.md, AGENTS.md, GEMINI.md, .goosehints — in a repo or at a user's global paths, when two of them have drifted apart, or when a session shows "no CLAUDE.md found; AGENTS.md loaded". Makes every runtime read one file, from the path its own docs name.
---

# Agent instruction files

## Overview

Every CLI reads a different filename from different directories. Keeping one hand-written file
per tool drifts: in one setup `~/AGENTS.md` lost two whole sections against `~/.claude/CLAUDE.md`,
and a repo's `AGENTS.md` shrank to 24 lines against a 351-line `CLAUDE.md`. A pointer file ("read
`CLAUDE.md`") is no fix either — the other agent sees the target only if it chooses to open it.
**One file, reached from each tool's documented path, by symlink or import.**

Content quality is a different job: `claude-md-management:claude-md-improver` grades what a
`CLAUDE.md` says. This skill is about which files load, where, and how many times.

## When to Use

- Adding agent instructions to a repo, or a second agent to a repo that has one
- `CLAUDE.md` and `AGENTS.md` both exist as regular files
- A session shows `no CLAUDE.md found; AGENTS.md loaded: …` for a file you did not expect
- Rules appear twice in context, or one agent ignores rules another follows

## Where each runtime reads

Read from each vendor's docs on 2026-09-28. Re-check the docs before relying on a row; they move.

| Runtime | Global | Project | Imports |
|---|---|---|---|
| Claude Code | `~/.claude/CLAUDE.md` | `CLAUDE.md`, `.claude/CLAUDE.md`, `CLAUDE.local.md` in cwd **and every ancestor**. `AGENTS.md` too, but only where none of those exist (default `claude-md-or-agents-md`) | `@path`, 4 hops |
| Codex | `~/.codex/AGENTS.override.md`, else `~/.codex/AGENTS.md` (`CODEX_HOME`) | `AGENTS.override.md` / `AGENTS.md` from the git root **down** to cwd; cwd only with no git root; 32 KiB cap | none documented |
| Gemini CLI | `~/.gemini/GEMINI.md` | `GEMINI.md` in workspace dirs and their parents; other names only via `context.fileName` | `@file.md` |
| Goose | `~/.config/goose/.goosehints`, a **regular file only** | `AGENTS.md` and `.goosehints` from cwd **up** to the repo root (`CONTEXT_FILE_NAMES`) | `@file`, inside the file's directory only |

Sources: code.claude.com/docs/en/memory · learn.chatgpt.com/docs/agent-configuration/agents-md ·
geminicli.com/docs/cli/gemini-md · block/goose `using-goosehints.md`.

Tested against Goose 1.50.0 on 2026-09-28, and not in its docs: a hints file that resolves outside its
own directory is silently dropped, whether by symlink or by `@` import. A repo's `AGENTS.md` ->
`CLAUDE.md` link loads; a global `.goosehints` linked into a dotfiles repo never did.

## Core Process

### 1. Inventory before changing anything

```bash
for f in CLAUDE.md .claude/CLAUDE.md CLAUDE.local.md AGENTS.md GEMINI.md .goosehints; do
  [ -e "$f" ] && ls -l "$f" && wc -l < "$f"; done
```

Note which are symlinks, which are pointers, and how far apart the regular files are. Diff two
regular files before merging them — the shorter one sometimes holds the only correct line.

### 2. Repo: one file, linked or imported

Pick one, in this order:

1. **`AGENTS.md` -> `CLAUDE.md` symlink** when the repo, its docs and its code comments already cite
   `CLAUDE.md` (`CLAUDE.md § …`, `CLAUDE.md invariant 5`). Every reference stays valid.
2. **`CLAUDE.md` containing `@AGENTS.md`**, plus any Claude-only notes under it, for a new repo or
   one where Windows clones matter — Git checks a committed symlink out as a one-line text file
   unless `core.symlinks` is on. This is the layout Anthropic's docs show.

Fold anything unique in the losing file into the survivor first. Point Gemini at `AGENTS.md` with
`"context": {"fileName": ["AGENTS.md", "GEMINI.md"]}` in `~/.gemini/settings.json` rather than
adding a third file.

### 3. Global: the documented path only

Link one source file to the Claude, Codex and Gemini global paths in the table. Goose's must be a
copied regular file, refreshed by whatever installs the links. **Never `~/AGENTS.md`**: no CLI
reads it as global, and Claude Code finds it as an ancestor of every folder under home that has no
`CLAUDE.md` and loads it as project instructions — alongside `~/.claude/CLAUDE.md`. If both are
links to the same file, the rules load twice per session.

### 4. Guard it

Add a check that fails when the files split again: `AGENTS.md` is a symlink resolving to
`CLAUDE.md`, or the first non-blank line of `CLAUDE.md` is `@AGENTS.md`. Report a repo that is
missing rather than skipping it — a check whose list names paths that moved passes silently.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "AGENTS.md just says to read CLAUDE.md, that's one source" | The other agent sees the target only if it chooses to open it |
| "Each tool gets its own tailored file" | Tailored files drift; put tool-specific lines under the import |
| "`~/AGENTS.md` covers every agent at once" | None reads it as global; Claude reads it as a project file |
| "Setting Claude to `claude-md` fixes the duplicate" | It also stops Claude reading `AGENTS.md`-only repos — remove the stray file instead |
| "I asked the agent and it quoted the line" | Your question may contain the line. Ask it to complete a sentence, and run the same probe in an empty directory as the control |

## Verification

Ask each runtime, with tools forbidden, to complete a sentence found only in the file. Run the same
probe in an empty directory: the project line must be missing there. Do not trust a small local model's
answer. Goose on a 4k-context Ollama model answered a codeword it had never been given; its request
log (`~/.local/state/goose/logs/llm_request.*.jsonl`) showed the file had been sent and truncated.

- [ ] Claude: `claude -p /context` lists each instruction file once under **Memory Files**
- [ ] Codex (`codex exec`), Gemini (`gemini -p`) and Goose pass the probe and the empty-directory control;
      for Goose, grep the request log for a line that appears only in the file
- [ ] `ls -l` on every linked global path resolves to the same source file
- [ ] The guard check fails on a deliberately split pair, then passes on the fix
