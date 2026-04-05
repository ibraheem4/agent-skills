---
name: code-review-and-quality
description: Use when reviewing code changes before merge. Multi-axis review with severity labeling.
---

# Code Review and Quality

## Overview

Review code across five axes: correctness, readability, architecture, security, and performance. Label findings by severity so authors know what blocks merge vs. what's a suggestion.

## When to Use

- Reviewing a pull request or diff before merge
- Self-reviewing your own changes before submitting
- Auditing code quality of an unfamiliar codebase

**Do not use** for design reviews (use planning skill) or security-focused audits (use security skill).

## Core Process

### 1. Understand Context

Before reading code, understand:
- What problem does this PR solve?
- What issue/ticket does it reference?
- What changed at a high level? (file list, diff stats)

### 2. Read Tests First

Tests tell you what the code is supposed to do. If there are no tests, that's your first finding.

### 3. Review Implementation

Walk through the diff file-by-file. For each change, evaluate:

| Axis | Questions |
|------|-----------|
| **Correctness** | Does it do what it claims? Edge cases handled? Off-by-one? Null safety? |
| **Readability** | Can a new team member understand this in 5 minutes? Clear names? |
| **Architecture** | Does it follow existing patterns? Is the abstraction level right? |
| **Security** | Input validated? Secrets exposed? Injection vectors? |
| **Performance** | N+1 queries? Unnecessary allocations? Missing indexes? |

### 4. Label Findings

Every comment gets a severity prefix:

| Severity | Meaning | Blocks Merge? |
|----------|---------|---------------|
| `critical:` | Bug, security issue, data loss risk | Yes |
| `required:` | Must fix — wrong pattern, missing test, broken contract | Yes |
| `nit:` | Style, naming, minor cleanup | No |
| `consider:` | Suggestion — alternative approach worth evaluating | No |
| `fyi:` | Context for the author, no action needed | No |

### 5. Summarize

End with a short summary: overall impression, top concerns, and a clear approve/request-changes/comment verdict.

## Change Size Guidelines

| Lines Changed | Assessment |
|---------------|-----------|
| < 100 | Ideal — easy to review thoroughly |
| 100–300 | Acceptable — may need two passes |
| 300–1000 | Too large — ask author to split |
| > 1000 | Reject — cannot review effectively |

If a PR is too large, suggest splitting strategies:
- **Stack**: Sequential PRs that build on each other
- **By feature**: Each PR delivers one user-visible change
- **By layer**: Separate data, logic, and presentation (last resort)

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "I trust the author" | Trust doesn't catch typos, edge cases, or assumptions you don't share |
| "The tests pass" | Tests verify what was tested. They don't verify what was missed |
| "It's a small change" | Small changes cause big outages. The review is proportionally fast anyway |
| "I don't understand this area" | That's the most important code to review — fresh eyes catch assumptions |
| "They'll fix it in a follow-up" | Follow-ups don't happen. If it matters, fix it now |

## Red Flags

- PR has no tests and no justification for skipping them
- All comments are "LGTM" with no specific feedback
- Review completed in under 2 minutes for a non-trivial PR
- No severity labels — every comment looks equally important
- Reviewer only comments on style, ignoring correctness and architecture

## Verification

- [ ] Every finding has a severity label (critical/required/nit/consider/fyi)
- [ ] Correctness and security axes were explicitly evaluated
- [ ] Tests were read before implementation
- [ ] Large PRs (300+ lines) were flagged for splitting
- [ ] Summary includes a clear verdict (approve/request-changes)
