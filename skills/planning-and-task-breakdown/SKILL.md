---
name: planning-and-task-breakdown
description: Use when starting a feature, epic, or multi-step task that needs to be broken into shippable increments.
---

# Planning and Task Breakdown

## Overview

Break ambiguous work into small, concrete, independently shippable tasks. Each task should be completable in a single session with a clear definition of done.

## When to Use

- Starting a new feature or epic
- A task description is vague or multi-step
- Work spans multiple files or systems
- You're about to write code without a clear plan

**Do not use** for single-file bug fixes or trivial changes.

## Core Process

### 1. Understand the Goal

Read the full requirement. Ask clarifying questions before planning. Identify:
- What does "done" look like?
- Who are the users/consumers?
- What are the constraints (time, backward compat, etc.)?

### 2. Map the Scope

List every change needed. Be exhaustive, then trim:

```
- [ ] Database schema changes
- [ ] API endpoint(s)
- [ ] Business logic / service layer
- [ ] UI components
- [ ] Tests (unit, integration, e2e)
- [ ] Documentation
- [ ] Migration / rollback plan
```

### 3. Slice Vertically

Each task should deliver a thin, working slice — not a horizontal layer. Bad: "build all the models." Good: "create user registration end-to-end with one field."

```
Vertical slice (good):           Horizontal layer (bad):
┌─────────────┐                  ┌─────────────────────────┐
│ UI: form    │                  │ All models              │
│ API: route  │  ← shippable    ├─────────────────────────┤
│ DB: table   │                  │ All controllers         │
│ Test: e2e   │                  ├─────────────────────────┤
└─────────────┘                  │ All views               │
                                 └─────────────────────────┘
```

### 4. Order by Dependency

Sequence tasks so each one builds on the last. The first task should be the smallest thing that proves the approach works (a "walking skeleton").

### 5. Define Exit Criteria

Each task gets:
- A one-line description of what changes
- Acceptance criteria (what to verify)
- Files likely touched

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "I'll figure it out as I go" | Exploration without a plan produces sprawling diffs that are hard to review and easy to break |
| "Planning is overhead for small tasks" | If it's truly small, planning takes 30 seconds. If planning feels hard, the task isn't small |
| "I can't plan without coding first" | Write a spike/prototype task first. Planning the spike is still planning |
| "The requirements will change anyway" | Plans are cheap to revise. Unplanned code is expensive to revise |

## Red Flags

- A single task touches more than 5 files
- Tasks have no clear definition of done
- The first task requires everything else to be done before it works
- No tests are mentioned in any task

## Verification

- [ ] Every task is independently shippable (could be merged alone)
- [ ] Every task has a one-line description and acceptance criteria
- [ ] Tasks are ordered by dependency (no circular deps)
- [ ] The first task is the smallest possible proof of approach
- [ ] Total task count is between 3 and 10 (re-slice if outside this range)
