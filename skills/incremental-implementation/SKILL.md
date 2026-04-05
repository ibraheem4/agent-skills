---
name: incremental-implementation
description: Use when building a feature that requires multiple steps. Implement in small, tested, committed increments.
---

# Incremental Implementation

## Overview

Build features in small steps where each step compiles, passes tests, and could be merged independently. Never write more than 50 lines without running tests.

## When to Use

- Implementing a feature from a task breakdown
- Building anything that touches more than one file
- Working on a feature that will take more than 15 minutes

**Do not use** for trivial one-line fixes.

## Core Process

### 1. Start with the Smallest Working Thing

Build the thinnest vertical slice that proves the approach. Hardcode values if needed. Get it working end-to-end.

### 2. Commit and Test

After each meaningful change:
1. Run the tests
2. Verify the code compiles
3. Commit with a descriptive message

### 3. Expand Incrementally

Add one behavior at a time. Each increment follows:
1. Write a test for the next behavior
2. Implement the minimal code
3. Refactor if needed
4. Commit

### 4. Resist Premature Abstraction

Don't create helpers, utilities, or abstractions until you have three concrete uses. Three similar lines are better than one wrong abstraction.

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "I'll commit when it's done" | Large uncommitted changes are unrecoverable if something breaks |
| "I need to build the foundation first" | Foundations without features are untested assumptions |
| "This abstraction will save time" | Abstractions built on one example are usually wrong |
| "I know what the whole thing needs to look like" | You don't. Build the first slice and let the design emerge |

## Red Flags

- More than 100 lines changed without a test run
- Multiple features implemented before any tests pass
- Abstract base classes created before concrete implementations
- Uncommitted work spanning multiple hours

## Verification

- [ ] Each commit compiles and passes tests independently
- [ ] No commit contains more than ~200 lines of change
- [ ] The first commit is the smallest possible working slice
- [ ] No abstractions exist without at least two concrete uses
