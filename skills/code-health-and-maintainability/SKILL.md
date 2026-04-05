---
name: code-health-and-maintainability
description: Use when improving codebase health — reducing complexity, removing dead code, improving readability. The "leave it better than you found it" skill.
---

# Code Health and Maintainability

## Overview

Code health is a continuous practice, not a project. Every change is an opportunity to improve the surrounding code. Reduce complexity, remove dead code, improve names, and shrink the surface area that future engineers must understand.

## When to Use

- Touching code that's hard to understand
- Noticing dead code, stale comments, or unclear naming
- Refactoring as part of a feature (the "boy scout rule")
- Dedicated code health sprints

**Do not use** as justification for large refactors mixed into feature PRs. Separate health changes from feature changes.

## Core Process

### 1. Measure Before Changing

Identify what's unhealthy:

| Signal | Healthy | Unhealthy |
|--------|---------|-----------|
| File size | < 300 lines | > 500 lines |
| Function length | < 30 lines | > 50 lines |
| Cyclomatic complexity | < 10 | > 15 |
| Parameters | < 4 | > 5 |
| Nesting depth | < 3 levels | > 4 levels |
| Dependencies (imports) | < 10 | > 15 |

These are guidelines, not rules. A 400-line file that's clear is better than five 80-line files that are tangled.

### 2. Remove Dead Code

Delete it. Don't comment it out. Git has history.

Targets:
- Unreachable branches
- Unused imports, variables, functions
- Commented-out code blocks
- Feature flags for features that shipped months ago
- Backward-compatibility shims for migrations that completed

### 3. Improve Names

Names are the primary documentation:

```typescript
// Bad
const d = getTime() - s;
const res = await proc(items.filter(i => i.a));

// Good  
const elapsed_ms = Date.now() - startTime;
const result = await processActiveItems(items.filter(item => item.isActive));
```

Rules:
- Functions: verb + noun (`createUser`, `parseConfig`, `validateInput`)
- Booleans: `is`/`has`/`should` prefix (`isActive`, `hasPermission`)
- Collections: plural (`users`, `activeOrders`)
- Avoid abbreviations unless universally understood (`id`, `url`, `http`)

### 4. Reduce Complexity

Apply these transformations in order:

1. **Early return** — Replace nested conditionals with guard clauses
2. **Extract function** — Name a block of code by what it does
3. **Replace conditional with polymorphism** — When you have type-based switches
4. **Inline** — Remove one-line wrappers that add no clarity

```typescript
// Before: nested, hard to follow
function processOrder(order) {
  if (order) {
    if (order.items.length > 0) {
      if (order.payment) {
        // actual logic
      }
    }
  }
}

// After: guard clauses, flat
function processOrder(order) {
  if (!order) return;
  if (order.items.length === 0) return;
  if (!order.payment) return;
  // actual logic
}
```

### 5. Keep Changes Small and Separate

Code health changes in their own commits (or PRs):
- Renames in one commit
- Dead code removal in another
- Logic simplification in another

Never mix refactoring with behavior changes — reviewers can't tell what's a rename vs. what's a fix.

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "If it works, don't touch it" | Working code that nobody can understand is a liability, not an asset |
| "We don't have time for cleanup" | You don't have time NOT to. Every hour of reading bad code costs more than the cleanup |
| "The next person can figure it out" | You are the next person. And it's harder than you think |
| "A big refactor will fix everything" | Big refactors fail. Small, continuous improvements compound |
| "Commenting it out is safer than deleting" | Git exists. Commented-out code is noise that confuses future readers |

## Red Flags

- Functions longer than a screen
- Variables named `temp`, `data`, `result`, `x` without context
- Commented-out code blocks older than 30 days
- Import lists longer than the function they serve
- Copy-pasted code blocks with minor variations
- Deeply nested conditionals (> 3 levels)

## Verification

- [ ] No dead code introduced (unused imports, unreachable branches)
- [ ] Function and variable names describe their purpose
- [ ] No function exceeds 50 lines (excluding tests)
- [ ] Refactoring changes are in separate commits from behavior changes
- [ ] Nesting depth is 3 levels or fewer
