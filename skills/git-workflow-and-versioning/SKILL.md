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

### 4. Semantic Versioning

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
| "Squash everything into one commit" | One commit per PR is fine. One commit per feature branch with 20 changes is not |

## Verification

- [ ] Every commit follows conventional format
- [ ] Branch name includes ticket reference
- [ ] No secrets, debug output, or uncommitted files in the diff
- [ ] Version bump follows semver rules
