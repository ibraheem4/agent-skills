---
name: debugging-and-error-recovery
description: Use when encountering errors, unexpected behavior, or test failures. Systematic diagnosis over guessing.
---

# Debugging and Error Recovery

## Overview

Agents' second-most-common failure: ignoring error messages and retrying the same approach, or making random changes until something works ("shotgun debugging"). Diagnose errors systematically — read the error, form a hypothesis, test one thing. Never retry blindly.

## When to Use

- A test fails unexpectedly
- Runtime error or crash
- Behavior differs from expectation
- A build or CI pipeline fails

**Do not use** for performance issues (use performance optimization) or security vulnerabilities (use security skill).

## Core Process

### 1. Read the Error

Read the **entire** error message, including:
- Error type/code
- Stack trace (find YOUR code, not framework code)
- Context (what input, what state, what operation)

```
Do NOT:  "It says something about null"
Do:      "TypeError: Cannot read property 'name' of null at UserService.ts:42"
```

### 2. Reproduce

Before fixing anything, reproduce the error reliably:
- Write a test that triggers the failure
- Identify the minimal input that causes it
- Confirm it fails consistently (not flaky)

If you can't reproduce it, you can't verify your fix.

### 3. Hypothesize

Form a specific, testable hypothesis:

```
Bad:   "Something is wrong with the database"
Good:  "The query returns null because the user_id foreign key
        doesn't match — the join uses 'id' but should use 'user_id'"
```

### 4. Test the Hypothesis

Change **one thing** and observe the result. If the hypothesis is wrong, revert and form a new one.

```
Bisect strategy:
1. Is the input correct?          → Log/inspect input
2. Is the function called?        → Add a log at entry
3. Is the intermediate state ok?  → Log before the failing line
4. Is the output wrong?           → Compare expected vs actual
```

### 5. Fix and Verify

Apply the minimal fix. Run the reproducing test. Run the full suite. The test you wrote in step 2 is now a regression test.

### 6. Understand Why

After fixing, ask: why did this happen? Should we prevent this class of bug? Consider:
- Adding a type that makes this state unrepresentable
- Adding validation at the boundary
- Improving the error message for next time

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "Let me try a few things" | Random changes create new bugs. Diagnose first, then change |
| "I'll just restart it" | Restarting hides the cause. The bug will return |
| "It works on my machine" | Then the environments differ. That's a clue, not a dismissal |
| "The error message is useless" | The stack trace isn't. Find the line in YOUR code that triggered it |
| "I'll add more logging and wait" | Add targeted logging with a hypothesis, not scatter-shot prints |

## Red Flags

- Changing multiple things at once without testing each
- No reproduction step exists
- Fix applied without understanding root cause
- Error messages ignored in favor of guessing
- "Shotgun debugging" — trying random fixes until something works
- Reverting to a known-good state instead of understanding the failure

## Verification

- [ ] Error message was read completely, including stack trace
- [ ] Bug was reproduced with a test before fixing
- [ ] Only one hypothesis was tested at a time
- [ ] Root cause is understood and documented (in commit message or comment)
- [ ] Regression test exists and fails without the fix
- [ ] Full test suite passes after the fix
