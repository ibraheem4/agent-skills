---
name: disk-reclaim
description: Use when reclaiming disk space on a development machine. Prune regenerable caches before touching anything that holds work, and never assume a build-output directory is untracked.
---

# Disk Reclaim

## Overview

Caches hold more space than repos and carry no risk. Reclaim in risk order: regenerable data
first, working trees last. The one trap that turns this destructive is assuming every
`dist/` and `build/` directory is generated — some are committed.

## When to Use

- A machine is low on space, or a directory has grown unexpectedly
- Periodic workstation cleanup
- After abandoning a tool, framework, or experiment

**Do not use** to delete git repositories — see `safe-repo-removal`.

## Core Process

### 1. Inventory before deleting anything

Size every top-level entry including dotfiles, sort by size, and classify each as: regenerable
cache, toolchain, working tree, or unknown. Report the table. Delete nothing yet.

```sh
du -sh ~/.* ~/* 2>/dev/null | sort -h | tail -40
```

Large `du`/`find` sweeps exceed typical command timeouts — run them in the background.

### 2. Caches first — this is where the space is

Caches routinely exceed every repo on the machine combined. Use each tool's own prune command
so you do not break the tool:

```sh
npm cache clean --force        # then check ~/.npm/_npx separately — often the real bulk
uv cache clean
go clean -modcache
pnpm store prune
brew cleanup
```

Check the subdirectory breakdown before and after. A tool-level `clean` may leave the largest
subdirectory untouched.

### 3. Date-sort tool directories to find abandoned experiments

Tool state directories cluster by the day they were tried and never touched again:

```sh
for d in ~/.*; do
  [ -d "$d" ] && printf '%6s %s  %s\n' "$(du -sh "$d"|cut -f1)" "$d" \
    "$(find "$d" -type f -exec stat -f '%Sm' -t '%Y-%m-%d' {} \; 2>/dev/null | sort -r | head -1)"
done | sort -rh
```

Several directories whose newest contained file share one date is a single abandoned session.
Confirm with the owner before deleting — "unused for months" is a judgment call, not a fact.

### 4. Build artifacts — check tracked status BEFORE deleting

A blanket `find . -name dist -exec rm -rf {} +` will delete **committed** files. Some repos
ship generated tokens, type definitions, or bundles. Always check after:

```sh
git status --porcelain | grep '^ D'        # tracked files you just deleted
git checkout -- <paths>                     # restore them
```

Safer: only remove paths that are git-ignored.

```sh
git clean -nXd     # dry run — ignored files only
git clean -fXd     # execute
```

### 5. Never touch these

`~/Library`, `~/.ssh`, `~/.gnupg`, `~/.config`, agent state directories, and anything holding
credentials. Preserve the cache of any tool the owner said to keep — deleting its runtime forces
a re-download and may break it.

### 6. Fix what the deletion broke

Registries with `local_path` fields, READMEs, and layout docs may reference deleted paths.
Correct them, and validate any structured file still parses.

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "`dist/` is always build output" | Some repos commit it. Check `git status` for `^ D` after deleting |
| "Deleting repos frees the most space" | Caches are usually larger and carry no risk. Do those first |
| "`npm cache clean` cleared the cache" | It may leave `_npx` — check the subdirectory breakdown |
| "That directory looks unused" | Sort by newest contained file, then confirm before deleting |
| "`rm -rf` on the tool dir is the same as pruning" | Tool-native prune preserves the structure the tool expects |
| "I'll measure the space saved with `df`" | On APFS `df` is unreliable mid-operation. Compare `du` before and after |

## Red Flags

- Deleting before an inventory has been reported
- Any `find -delete` across repos without a `git status` check afterwards
- Reaching for working trees while multi-gigabyte caches remain
- `rm -rf` on a directory belonging to a tool the owner still uses
- Structured config edited during cleanup and never re-parsed

## Verification

- [ ] Inventory produced and classified before any deletion
- [ ] Caches pruned with tool-native commands, and subdirectory breakdown re-checked
- [ ] `git status --porcelain | grep '^ D'` run in every touched repo — zero tracked deletions
- [ ] No protected path touched
- [ ] Dangling references to deleted paths corrected; structured files re-validated
- [ ] Space reclaimed reported from `du` before/after, not `df`
