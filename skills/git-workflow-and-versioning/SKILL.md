---
name: git-workflow-and-versioning
description: Use when committing, branching, or preparing releases. Conventional commits, clean history, and semantic versioning.
---

# Git Workflow and Versioning

## Overview

Maintain a clean, navigable git history with conventional commits, purposeful branches, and semantic versioning.

## When to Use

- Making any git commit
- Creating or naming branches
- Preparing a release or version bump

## Core Process

### 1. Conventional Commits

Every commit message follows:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

| Type | When |
|------|------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `refactor` | Code change that doesn't fix a bug or add a feature |
| `test` | Adding or fixing tests |
| `chore` | Build, CI, dependencies |

### 2. Branch Naming

```
<type>/<ticket>-<short-description>
```

Examples: `feat/LUC-123-user-registration`, `fix/LUC-456-null-pointer`

### 3. Commit Hygiene

- Each commit does one thing
- Each commit compiles and passes tests
- No "WIP" or "fix typo" commits in final history (squash before merge)
- No committed secrets, debug logs, or TODO without ticket reference

"No committed secrets" needs a procedure, not an intention. Before every commit:

```sh
git status --short                    # no .env*, *.local.md, settings.local.json
git check-ignore -v <env file>        # prove the env file is actually ignored
git diff --cached | grep -inE 'secret|token|api[_-]?key|password|PRIVATE KEY'
```

Local-config files leak repeatedly because they sit in the working tree looking normal. When
one is untracked-but-visible, add it to `.git/info/exclude` rather than the repo's
`.gitignore` — unless the whole team wants it ignored.

Leave other people's files alone. If a shared doc changed and it was not you, revert it.

⚠️ **Where a repo's history is all-prose, house style and the conventional-commit rule
conflict.** Say so and ask rather than deciding silently — a subject line cannot be fixed
after pushing, because force-push is off the table.

### 4. Worktree Lifecycle

Use worktrees for feature isolation. Never switch branches in-place on the main checkout.

```
Enter worktree → create branch → implement → commit → push → PR → remove worktree
```

| Rule | Rationale |
|------|-----------|
| **One worktree per feature** | Keeps each feature isolated, enables parallel work |
| **Worktrees inside the repo** | Store in a dotfile directory within the repo (e.g., `.worktrees/`) — never in home or sibling directories where they get orphaned |
| **Remove after merge** | Stale worktrees accumulate and confuse future sessions |
| **Keep only if in-progress** | Only preserve a worktree if you'll return to unfinished work |
| **Never switch branches in-place** | Contaminates the working tree, dirties submodule pointers |

Periodic cleanup: run `git worktree list` and `git worktree prune` to find and remove orphaned worktrees.

### 5. Pushing — the destination is not always the branch you named

⚠️ With `push.default = upstream`, a branch created from `origin/main` inherits `origin/main`
as its upstream, so a push that names the branch twice still targets **main**:

```
git push -u origin feat/my-branch
  ! [rejected]  feat/my-branch -> main   (fetch first)
```

Nothing in the command hints that the destination comes from the upstream ref. It fails only
when the base has moved; on a fast-forward it pushes your commits straight to the default
branch.

Push a new branch with an explicit refspec, and dry-run it first:

```sh
git push --dry-run -u origin <name>:refs/heads/<name>   # read the target ref
git push -u origin <name>:refs/heads/<name>
```

### 6. Renaming a branch is local only

Every part of this surprises:

| What you expect | What actually happens |
|---|---|
| The remote branch is renamed | It is not. `origin/<old>` still exists |
| An open PR follows the rename | It cannot — the host cannot retarget a PR's head ref |
| Tracking config follows | `branch.<new>.merge` still points at `refs/heads/<old>`, so the renamed branch keeps pushing to the **old** remote name |
| The worktree directory moves | It keeps its old path — `git worktree move` if that matters |

Read `git branch -vv` after every rename and set the upstream deliberately.
`git branch --unset-upstream <new>` is safest: a bare `git push` then errors instead of
guessing a target.

Renaming *back* does not clear a divergence. Once a rebase has rewritten a published commit,
the remote's copy reads "1 behind, N ahead" under any name, because git counts SHAs, not
content — `git show <sha> | git patch-id --stable` on both proves it is the same change
replayed on a newer base. Only a push fixes the count. A stale upstream is the usual reason a
branch *looks* wildly out of date while being level with its base.

### 7. Force-pushing, when explicitly authorized

Never on your own judgment. When the owner of the work asks for it outright:

```sh
git fetch origin
git push --dry-run --force-with-lease origin <name>:refs/heads/<name>
git push --force-with-lease origin <name>:refs/heads/<name>
```

`--force-with-lease`, never bare `--force`: it refuses if the remote moved since your fetch,
so you cannot clobber someone else's push. Dry-run for the same reason as any push — the
refspec is what keeps this off the default branch. Say plainly in the summary that it rewrote
published commits.

### 8. Semantic Versioning

```
MAJOR.MINOR.PATCH
  │     │     └── Bug fixes (backward compatible)
  │     └──────── New features (backward compatible)  
  └────────────── Breaking changes
```

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "The commit message doesn't matter" | `git log` and `git blame` are read 100x more than they're written |
| "I'll clean up the history later" | You won't. And force-pushing rewrites is risky |
| "`git push -u origin <branch>` obviously pushes to that branch" | Not under `push.default = upstream`. Read the dry-run's target ref |
| "I renamed it, so the remote is renamed too" | The rename never left your machine |
| "Squash everything into one commit" | One commit per PR is fine. One commit per feature branch with 20 changes is not |

## Verification

- [ ] Every commit follows conventional format
- [ ] Branch name includes ticket reference
- [ ] No secrets, debug output, or uncommitted files in the diff
- [ ] Version bump follows semver rules
- [ ] New branches pushed with an explicit refspec, dry-run read before the real push
- [ ] After any rename, `git branch -vv` checked and the upstream set deliberately
- [ ] Worktree removed after work is committed and pushed (not left stale)
