---
name: scope-discipline
description: Use on every task. Do exactly what was asked — no extra features, no unsolicited refactors, no "improvements" beyond the request.
---

# Scope Discipline

## Overview

The most common agent failure: doing more than asked. Adding error handling "just in case." Refactoring adjacent code. Adding type annotations to files you didn't change. Extracting helpers for one-time operations. Every unsolicited change is a potential bug, a review burden, and a deviation from what the user actually needed.

This skill is grounded in Google's "one logical change per CL" principle — every change should do one thing and only one thing.

## When to Use

**Always.** This skill applies to every task, every time.

## Core Process

### 1. Understand the Request

Before writing any code, restate what was asked:
- What is the specific change?
- What files are affected?
- What is NOT being asked?

### 2. Do Exactly That

Write the code that fulfills the request. Stop.

### 3. Review Your Diff

Before presenting the result, check every changed line against the request:

| Change | Keep? |
|--------|-------|
| Directly implements the request | Yes |
| Fixes a bug you discovered in the requested area | Yes — but mention it |
| Renames a variable in a file you're editing | No — separate change |
| Adds type annotations to code you didn't write | No |
| Refactors adjacent code "while you're here" | No |
| Adds a feature the user didn't ask for | No |
| Adds error handling for impossible scenarios | No |
| Creates a helper for a one-time operation | No |
| Adds comments explaining obvious code | No |
| Extracts a constant that's used once | No |

### 4. If You Notice Something

If you notice a real issue outside the scope:
- **Mention it** to the user: "I noticed X. Want me to fix that separately?"
- **Don't fix it** in the same change
- Let the user decide whether it's worth doing

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "While I'm here, I should also..." | You should not. Every additional change is risk with no user-requested benefit |
| "This code needs better error handling" | If the user didn't ask for error handling, it's out of scope. Mention it, don't do it |
| "I'll add types to make it safer" | Adding types to code you didn't change creates a larger diff with no connection to the task |
| "This helper will be useful later" | You don't know that. Premature abstraction is the root of all evil |
| "The existing code is messy, I should clean it up" | Clean it up in a separate PR. Mixing cleanup with features makes both harder to review |
| "I'm improving the code" | Unsolicited improvements are unsolicited changes. They may break assumptions you don't know about |

## Red Flags

- Diff includes files not related to the request
- New abstractions (helpers, utilities, base classes) created for one-time use
- Type annotations added to code that wasn't part of the task
- Comments added to code the agent didn't write
- Error handling added for scenarios that can't happen
- "While I was here, I also..." in the agent's explanation
- Commit message describes two unrelated changes

## Verification

- [ ] Every changed line directly relates to the request
- [ ] No files were modified that aren't necessary for the task
- [ ] No new abstractions created for single use
- [ ] No unsolicited refactoring, renaming, or reformatting
- [ ] If issues were noticed outside scope, they were mentioned but not fixed
