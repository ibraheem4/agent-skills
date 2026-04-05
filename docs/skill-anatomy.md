# Skill Anatomy

Every skill follows this structure. Use this as a template when creating new skills.

## File Structure

```
skills/your-skill-name/
  SKILL.md          # Required — main skill definition
  frameworks.md     # Optional — supporting decision frameworks
  references/       # Optional — reference materials
```

## SKILL.md Template

```markdown
---
name: your-skill-name
description: Use when [triggering condition]. [Brief description of what it does].
---

# Your Skill Name

## Overview

One to two sentences: what this skill does and why it matters.

## When to Use

- Condition 1
- Condition 2

**Do not use** for [exclusions].

## Core Process

### 1. First Step
[Details]

### 2. Second Step
[Details]

### 3. Third Step
[Details]

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "..." | ... |

## Red Flags

- Observable anti-pattern 1
- Observable anti-pattern 2

## Verification

- [ ] Exit criterion 1 (testable/observable)
- [ ] Exit criterion 2 (testable/observable)
```

## Guidelines

- **Description** must start with "Use when" — this is the activation trigger
- **Core Process** must be sequential numbered steps, not a knowledge dump
- **Common Rationalizations** must include specific excuses with factual rebuttals
- **Verification** criteria must be testable/observable, not subjective
- Keep the main SKILL.md under 200 lines — move reference material to supporting files
