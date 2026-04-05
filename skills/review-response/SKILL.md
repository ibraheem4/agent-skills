---
name: review-response
description: Use when a PR has review comments that need to be addressed. Fetch comments, categorize them, fix actionable issues, reply to every comment, and resolve threads.
---

# Review Response

## Overview

Agents receive review feedback and need to act on it systematically — not cherry-pick easy comments or ignore hard ones. This skill ensures every comment gets a response: fixed, acknowledged, or explained. Batch all fixes into a single commit, reply to every comment individually, and resolve all threads.

Grounded in Google's code review expectations: respond within hours, address every comment, and distinguish blocking from non-blocking feedback.

## When to Use

- A PR has review comments (human or automated)
- CI/code scanning tools have flagged issues on a PR
- The user says "fix the review comments" or "address the feedback"

## Core Process

### 1. Fetch All Unresolved Comments

Get every unresolved review comment on the PR. Include:
- Human reviewer comments
- Automated review comments (code scanning, linters, bots)
- Thread resolution status (resolved vs. unresolved)

Filter to only **unresolved** threads. If all threads are resolved, report "No unresolved comments" and stop.

### 2. Read Context Before Responding

For each comment, read the referenced file at the flagged line. Understand the surrounding code before deciding what to do. Don't respond based on the comment text alone.

### 3. Categorize Each Comment

| Category | Criteria | Action |
|----------|----------|--------|
| **Actionable** | Real code issue — bug, security hole, missing validation, wrong logic | Fix it |
| **Acknowledged** | Valid concern but intentional design choice or out of scope | Reply explaining why |
| **False positive** | Doesn't apply, already fixed, or scanner error | Reply explaining |

Never ignore a comment. Every comment gets a response.

### 4. Fix Actionable Issues

- Make the **minimal fix** that addresses each comment
- Don't refactor surrounding code while fixing
- **Batch ALL fixes into a single commit** — not one commit per comment

```
fix: address PR review comments

[link to issue/ticket]
```

### 5. Reply to Every Comment

Reply to **every** comment — even false positives and acknowledged items:

| Category | Reply Pattern |
|----------|--------------|
| Fixed | "Fixed in {commit} — {brief description of change}" |
| Acknowledged | "Intentional — {reason}. {context about the design choice}" |
| False positive | "Not applicable — {explanation of why this doesn't apply}" |

Rules:
- Reply to each comment individually (don't batch replies)
- Be specific — "Fixed" alone is not enough. Say what changed
- For automated scanner comments, note whether the finding is new (introduced by this PR) or pre-existing

### 6. Resolve Threads

After replying, resolve each thread. If a thread cannot be resolved programmatically (some automated scanners don't support this), note it in the summary.

### 7. Verify and Report

Re-check that all threads are resolved. Report:

```
Review Response Summary:
- N comments addressed (X fixed, Y acknowledged, Z false positives)
- Commit: {sha} (if fixes were pushed)
- Unresolvable threads: {list, if any}
```

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "That comment is nitpicky, I'll skip it" | Reply acknowledging it even if you disagree. Ignoring comments signals you didn't read them |
| "I'll fix it in a follow-up" | Fix it now. Follow-ups don't happen. The reviewer is blocking on this |
| "The scanner is wrong" | Maybe. But reply explaining WHY it's wrong so the reviewer can verify |
| "I'll just push a fix and they'll see it" | Reply to the comment explicitly. Reviewers don't re-read every line of the new diff |
| "One commit per fix is cleaner" | It's noisier. Batch fixes into one commit — the reviewer reads the thread, not the commit history |

## Red Flags

- Comments left without any reply
- Fixes pushed without replying to the comment explaining what changed
- Multiple small commits instead of one batched fix commit
- "Fixed" as the entire reply (no context)
- Actionable comments categorized as "false positive" to avoid work
- Surrounding code refactored alongside review fixes

## Verification

- [ ] Every unresolved comment has a reply
- [ ] All actionable issues are fixed
- [ ] Fixes are batched into a single commit
- [ ] Each reply explains what was done (not just "Fixed")
- [ ] All resolvable threads are resolved
- [ ] Summary report includes counts by category
