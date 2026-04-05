---
name: context-engineering
description: Use when starting any task. Manage what you load into context — read before writing, load relevant files not everything, and avoid hallucinating from stale or missing context.
---

# Context Engineering

## Overview

The quality of agent output is bounded by the quality of agent input. Agents hallucinate when they lack context, over-generalize when they load too much, and break existing patterns when they don't read current code first. This skill governs what to load, when, and how to manage the context window as work progresses.

This is the most agent-specific skill in the set — humans manage context unconsciously; agents must do it explicitly.

## When to Use

**Every task.** Context management is not a separate step — it's embedded in how agents approach all work.

## Core Process

### 1. Context Hierarchy

Load context in this order, stopping when you have enough:

```
Priority 1: Project rules (CLAUDE.md, AGENTS.md, GEMINI.md)
    ↓       Always loaded. These are persistent constraints.
Priority 2: Relevant source files
    ↓       Read files you'll modify BEFORE modifying them.
Priority 3: Related tests
    ↓       Understand expected behavior before changing it.
Priority 4: Recent git history
    ↓       What changed recently? Why? By whom?
Priority 5: Documentation / specs
    ↓       Only when the task requires understanding intent.
Priority 6: Dependencies / types
            Only when you need to understand an interface.
```

### 2. Read Before Writing

**Never modify a file you haven't read.** This is the single most important context rule.

```
Bad:  "I'll add a login function to auth.ts"
      → Writes a new function without reading auth.ts
      → Duplicates existing loginUser() that handles edge cases

Good: "Let me read auth.ts first to understand the existing patterns"
      → Discovers loginUser() already exists
      → Extends it instead of duplicating
```

Before editing any file:
- Read the full file (or relevant section for large files)
- Identify existing patterns: naming conventions, error handling style, import patterns
- Check if similar functionality already exists

### 3. Load Deliberately, Not Exhaustively

Don't load every file in the project. Load what's relevant to the task:

| Task | Load | Don't Load |
|------|------|-----------|
| Fix a bug in `UserService` | `UserService.ts`, its tests, its callers | Unrelated services |
| Add an API endpoint | Existing endpoints for pattern reference, router config, types | Frontend components |
| Update a UI component | The component, its parent, the design system | Backend services |

### 4. Refresh Stale Context

Context goes stale during long tasks:
- If you made changes 10+ steps ago, re-read the file before modifying it again
- If a test failed, re-read the test output — don't rely on your memory of what it said
- If you're referencing a function signature, verify it — don't assume you remember correctly

### 5. Manage Window Pressure

When context is getting large:
- Summarize what you've learned before it scrolls away
- Focus on the current task — don't hold context for "later"
- If you need information from earlier in the conversation, re-read the source rather than guessing

### 6. Verify, Don't Assume

When you're uncertain about something:

| Instead of | Do |
|-----------|-----|
| Guessing a function name | `grep` for it |
| Assuming an import path | Check the actual file structure |
| Remembering a type signature | Read the type definition |
| Assuming a file exists | Check with `ls` or `glob` |
| Assuming a pattern from another file | Read the actual file you're editing |

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "I know what that file looks like" | You think you do. Read it. It may have changed since you last saw it |
| "I'll just write the code, it's straightforward" | Straightforward code in the wrong pattern creates maintenance debt |
| "Loading more context will slow me down" | Hallucinating from missing context slows you down 10x more when you debug the result |
| "I'll check the patterns later" | Later means after you've written code that doesn't match. Read first |
| "The function probably takes these arguments" | Probably isn't good enough. Verify the signature |

## Red Flags

- Modifying a file without reading it first
- Guessing function names, import paths, or type signatures
- Creating a new utility when one already exists in the codebase
- Writing code that uses different conventions than the surrounding code
- Asking the user for information that's available in the codebase
- Loading every file in a directory when only one is relevant

## Verification

- [ ] Every modified file was read before editing
- [ ] Existing patterns were identified and followed
- [ ] No duplicate functionality was created
- [ ] Import paths and function signatures were verified, not guessed
- [ ] Context was refreshed after long gaps between edits to the same file
