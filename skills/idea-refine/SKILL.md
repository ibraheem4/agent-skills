---
name: idea-refine
description: Use when sharpening a raw idea into a concrete specification. Diverge, converge, then output a one-pager.
---

# Idea Refine

## Overview

Take a vague idea and sharpen it into a concrete, actionable specification through structured divergent and convergent thinking.

## When to Use

- A feature request is vague or underspecified
- Exploring multiple approaches before committing
- Turning a user problem into a technical solution

## Core Process

### Phase 1: Diverge — Expand the Idea

Apply these lenses to generate alternatives:

1. **Inversion** — What if we solved the opposite problem?
2. **Constraint removal** — What would we build with unlimited time/resources?
3. **Simplification** — What's the simplest version that delivers value?
4. **Combination** — Can we combine this with an existing feature?
5. **10x version** — What would this look like at 10x scale?

### Phase 2: Converge — Evaluate and Select

Score each variant on:
- **Impact** — How much value does this deliver?
- **Effort** — How long to build and maintain?
- **Risk** — What could go wrong?

Select the variant with the best impact/effort ratio.

### Phase 3: Output — One-Pager

Write a spec document:

```markdown
# [Feature Name]

## Problem
What user problem does this solve?

## Solution
What are we building? (one paragraph)

## Non-goals
What are we explicitly NOT doing?

## Success criteria
How do we know this worked?

## Open questions
What do we still need to figure out?
```

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "The idea is clear enough" | Clear to you isn't clear to the team. Write it down |
| "We don't have time to spec" | You don't have time to build the wrong thing twice |
| "Just start coding and see" | Exploration is fine — but call it a spike and timebox it |

## Verification

- [ ] At least 3 alternatives were considered
- [ ] Selected approach has clear rationale
- [ ] One-pager includes problem, solution, non-goals, and success criteria
- [ ] Open questions are listed (not hidden)
