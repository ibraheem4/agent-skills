---
name: pr-lifecycle
description: Use after opening a PR to shepherd it to merge-readiness. Monitor CI, fix failures, handle review feedback, and loop until green. Never merge — report readiness and let the human decide.
---

# PR Lifecycle

## Overview

Opening a PR is not the end — it's the start of a feedback loop. Agents must monitor CI, respond to automated reviews, fix failures, and verify everything is green before reporting readiness. This skill encodes the full post-PR loop: observe → diagnose → fix → verify → repeat.

The critical guardrail: **never merge automatically**. Report readiness, let the human merge.

## When to Use

- After opening a PR (post-`/ship`)
- When asked to "babysit this PR" or "get this PR ready"
- When CI is failing on an open PR
- When automated review comments appear

## Core Process

```
Pre-flight (clean working tree)
        │
        ▼
Validate PR state (open? mergeable?)
        │
        ▼
Wait for automated reviews
        │
        ▼
  Comments found? ──yes──→ review-response skill
        │                        │
        no                   Push fixes
        │                        │
        ▼                        ▼
  CI passing? ◄──────────────────┘
        │
       yes──→ Report: "PR ready for merge"
        │
        no──→ Diagnose + fix ──→ loop (max 3 cycles)
```

### 1. Pre-flight

Ensure the working tree is clean before starting the loop:

- Stage any uncommitted changes that affect CI (source files, config, lockfiles)
- Sync the lockfile (`npm ci` / `pnpm install --frozen-lockfile`)
- Push all pre-flight changes before proceeding

### 2. Validate PR State

Check that the PR is still open and mergeable:
- If closed or merged, abort
- If there are merge conflicts, report them (don't resolve automatically without user approval)
- Checkout the PR branch if not already on it

### 3. Wait for Automated Reviews

If the project uses automated code review (GitHub Copilot, CodeRabbit, SonarCloud, etc.):
- Wait for the review to complete (poll with reasonable intervals — 30s, max 10 minutes)
- If no automated review appears after the timeout, skip to CI check

### 4. Handle Review Comments

When review comments arrive, invoke the **review-response** skill:
1. Fetch all unresolved comments
2. Categorize: actionable / acknowledged / false-positive
3. Fix actionable issues, batch into a single commit
4. Reply to every comment
5. Resolve all threads
6. Push and wait for CI to re-trigger

### 5. Verify CI

Check CI status. For each failing check:

#### Distinguish new vs. pre-existing failures

Compare against the base branch. If a check was already failing before this PR, mark it as **pre-existing** — it's not a blocker.

#### Diagnose and fix new failures

| Failure Type | Approach |
|-------------|----------|
| Test failure | Read the test output. Find the failing assertion. Fix the code or the test |
| Lint error | Read the error. Apply the fix. Don't disable the rule |
| Type error | Read the error. Fix the type, don't add `any` or `@ts-ignore` |
| Build failure | Read the build log. Fix the compilation error |
| Security scan | Evaluate: fix if actionable, acknowledge if false positive |

For each fix:
- Make the minimal change
- Batch all fixes into a single commit
- Push and re-check CI

#### Retry limit

**Max 3 fix-and-retry cycles.** If CI keeps failing after 3 rounds:
- Stop
- Report what's failing and what was tried
- Let the human investigate

### 6. Report Readiness

Once all checks pass (or only pre-existing failures remain):

```
PR #{number} — Ready for Merge

Reviews:  {N comments resolved (X fixed, Y acknowledged)}
CI:       {N/M checks passing}
Pre-existing: {list any, or "None"}

→ Ready for human review and merge
```

**Never merge the PR.** Always leave the final merge decision to the human.

## Guardrails

| Rule | Rationale |
|------|-----------|
| **Never merge** | Humans make the ship decision. Agents prepare |
| **Never force-push** | Force-push destroys review context and CI history |
| **Max 3 fix cycles** | Prevents infinite loops. If 3 rounds can't fix it, escalate |
| **Batch fixes** | One commit per cycle, not one commit per issue |
| **Pre-existing ≠ blocker** | Don't waste cycles on failures that existed before this PR |
| **10-minute timeout** | Don't wait forever for automated reviews |

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "CI is flaky, I'll just re-run it" | If it's flaky, note it. But don't assume failure is always flakiness — read the output first |
| "The test failure is unrelated" | Prove it by checking if it fails on the base branch too. Don't assume |
| "I'll just merge and fix in the next PR" | Broken main blocks everyone. Fix it now or don't merge |
| "The review comment is wrong, I'll ignore it" | Reply explaining why you disagree. Don't leave comments unanswered |
| "I can force-push to clean up the history" | Force-push destroys review threads and CI context. Use regular push |

## Red Flags

- PR merged without CI passing
- Review comments left without replies
- Force-push used during the babysit loop
- More than 3 fix attempts without stopping to reassess
- Pre-existing failures treated as new blockers
- Agent attempts to merge without human approval

## Verification

- [ ] All automated review comments addressed (replied + resolved)
- [ ] CI is green (or only pre-existing failures remain)
- [ ] No force-pushes in the PR history
- [ ] Fix attempts stayed within 3 cycles
- [ ] Final status reported to the user
- [ ] PR was NOT merged by the agent
