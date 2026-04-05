---
name: test-driven-development
description: Use when implementing new functionality or fixing bugs. Write a failing test first, make it pass, then refactor.
---

# Test-Driven Development

## Overview

Write the test before the code. The test defines the behavior; the implementation satisfies it. This produces minimal, correct code with built-in regression protection.

## When to Use

- Implementing any new function, method, or endpoint
- Fixing a bug (prove the bug exists with a test first)
- Refactoring (ensure behavior is preserved)

**Do not use** for exploratory prototyping or throwaway scripts.

## Core Process

```
   ┌──────────┐
   │  RED     │ ← Write a failing test
   │  (fail)  │
   └────┬─────┘
        │
   ┌────▼─────┐
   │  GREEN   │ ← Write minimal code to pass
   │  (pass)  │
   └────┬─────┘
        │
   ┌────▼─────┐
   │ REFACTOR │ ← Clean up, tests still pass
   │  (pass)  │
   └────┬─────┘
        │
        └──→ Next test
```

### 1. RED — Write a Failing Test

Write one test that describes the next behavior you need. Run it. It must fail.

```typescript
// RED: This test fails because createTask doesn't exist yet
describe('TaskService', () => {
  it('creates a task with title and default status', async () => {
    const task = await taskService.createTask({ title: 'Buy groceries' });
    expect(task.id).toBeDefined();
    expect(task.title).toBe('Buy groceries');
    expect(task.status).toBe('pending');
  });
});
```

If the test passes immediately, it's not testing new behavior — delete it or make it more specific.

### 2. GREEN — Make It Pass

Write the **minimum** code to make the test pass. No extra features, no premature abstractions. Hardcode if necessary — the next test will force you to generalize.

```typescript
// GREEN: Minimal implementation
class TaskService {
  async createTask(input: { title: string }) {
    return { id: crypto.randomUUID(), title: input.title, status: 'pending' };
  }
}
```

### 3. REFACTOR — Clean Up

With tests green, improve the code: extract helpers, rename variables, remove duplication. Run tests after every change.

### 4. Repeat

Pick the next behavior. Write a failing test. Make it pass. Refactor.

## Bug Fix Pattern (Prove-It TDD)

For bugs, reverse the flow:

1. **Reproduce** — Write a test that fails the same way the bug manifests
2. **Fix** — Change the code until the test passes
3. **Verify** — Run the full suite to ensure no regressions

The test is your proof that the bug existed and is now fixed.

## Test Pyramid

```
        ╱╲
       ╱E2E╲         5% — Critical user journeys only
      ╱──────╲
     ╱ Integr. ╲     15% — API boundaries, DB queries
    ╱────────────╲
   ╱    Unit      ╲   80% — Functions, classes, modules
  ╱────────────────╲
```

Default to unit tests. Reach for integration tests at system boundaries. Use E2E tests sparingly for critical paths.

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "I'll write tests after" | You won't. And if you do, they'll test the implementation, not the behavior |
| "Tests slow me down" | Tests slow you down now and save you 10x later. Debugging without tests is what's actually slow |
| "This code is too simple to test" | Simple code becomes complex code. The test documents the expected behavior for the next person |
| "I can't test this — it has dependencies" | That's a design signal. If it's hard to test, it's too coupled. Inject dependencies |
| "The test is harder than the code" | That means the interface is too complex. Simplify the interface, not the test |

## Red Flags

- Tests written after all the code is done
- Tests that test implementation details (mock internals, check call counts)
- No failing test exists before the fix
- Tests that pass on the first run without any production code changes
- Test file is longer than the implementation file (test overhead too high)

## Verification

- [ ] Every new function/method has at least one test written before the implementation
- [ ] Bug fixes include a regression test that fails without the fix
- [ ] All tests pass after refactoring
- [ ] No test depends on execution order or shared mutable state
- [ ] Test names describe behavior, not implementation ("creates a task" not "calls constructor")
