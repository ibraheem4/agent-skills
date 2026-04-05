---
name: shipping-and-launch
description: Use when preparing code for merge or release. Pre-launch checklist and go/no-go gates.
---

# Shipping and Launch

## Overview

A systematic checklist before merging or releasing code. Catches the issues that slip past code review.

## When to Use

- Opening a pull request
- Preparing a release
- Merging to a protected branch

## Core Process

### 1. Pre-Flight Checks

- [ ] All tests pass locally
- [ ] No uncommitted changes
- [ ] Branch is up to date with target
- [ ] No merge conflicts
- [ ] Linting passes with no new warnings

### 2. Security Scan

- [ ] No secrets committed (grep for `sk-`, `token`, `password`, API keys)
- [ ] No `.env` files in the diff
- [ ] Dependencies have no known critical vulnerabilities
- [ ] No `console.log` or `debugger` statements in production code

### 3. Documentation

- [ ] PR description explains what and why (not how)
- [ ] Breaking changes are called out
- [ ] Migration steps documented if applicable
- [ ] Relevant issue/ticket referenced

### 4. Go/No-Go

Answer these three questions:
1. **Would I be comfortable if this deployed at 5pm Friday?** If no, what's missing?
2. **Can this be rolled back in under 5 minutes?** If no, add a rollback plan.
3. **Does anyone else need to know about this?** If yes, notify them before merge.

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "CI will catch it" | CI catches what CI tests. It doesn't catch missing tests or logic errors |
| "It's just a small change" | Small changes cause big outages. The checklist is proportionally fast |
| "I already tested locally" | Testing and pre-flight are different. Did you check for secrets? Conflicts? |

## Verification

- [ ] All pre-flight checks pass
- [ ] Security scan found no issues
- [ ] PR description is complete
- [ ] Go/no-go questions answered affirmatively
