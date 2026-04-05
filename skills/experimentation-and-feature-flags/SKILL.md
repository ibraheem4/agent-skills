---
name: experimentation-and-feature-flags
description: Use when launching a feature that needs controlled rollout, A/B testing, or a kill switch. Gate features behind flags before shipping.
---

# Experimentation and Feature Flags

## Overview

Ship features behind flags so they can be rolled out incrementally, measured, and rolled back without a deploy. Every user-facing change should be an experiment with a hypothesis and success metrics defined before launch.

## When to Use

- Launching any user-facing feature
- Changing behavior that affects metrics (engagement, latency, error rate)
- Rolling out infrastructure changes that could degrade performance
- Any change you might need to roll back faster than a deploy cycle

**Do not use** for internal tooling with no user impact or trivial copy changes.

## Core Process

### 1. Define the Hypothesis

Before writing code, state:

```
If we [change],
then [metric] will [improve/decrease] by [threshold],
because [reasoning].
```

Example: "If we add inline validation to the signup form, then signup completion rate will increase by 5%, because users currently abandon after seeing errors on submit."

### 2. Choose Metrics

| Type | Purpose | Example |
|------|---------|---------|
| **Primary** | What you're trying to move | Signup completion rate |
| **Guardrail** | What must NOT regress | Page load time, error rate |
| **Diagnostic** | Helps explain results | Form field interaction count |

### 3. Implement Behind a Flag

```typescript
if (featureFlags.isEnabled('inline-signup-validation', { userId })) {
  // New behavior
  return <InlineValidationForm />;
}
// Existing behavior (control)
return <StandardForm />;
```

Rules:
- Flag names are descriptive: `inline-signup-validation`, not `exp-123`
- Default is OFF (control behavior)
- Flag checks are at the highest level possible (not scattered through code)
- Clean up flags within 30 days of full rollout

### 4. Ramp Plan

Never go 0% → 100%. Use a staged rollout:

```
Day 1:  1% — Smoke test, check for crashes
Day 2:  5% — Monitor guardrail metrics
Day 3:  25% — Statistical significance starts building
Day 5:  50% — Enough data for preliminary read
Day 7:  100% — Full rollout if metrics are positive
```

At each stage, check:
- Are guardrail metrics stable?
- Are error rates normal?
- Is latency within bounds?

### 5. Measure and Decide

Wait for statistical significance before deciding. Don't peek and call it early.

| Result | Action |
|--------|--------|
| Primary metric improved, guardrails stable | Ship it — remove flag, delete control code |
| Primary metric flat, guardrails stable | Iterate or abandon — the hypothesis was wrong |
| Guardrail metrics regressed | Roll back immediately — investigate the regression |
| Inconclusive | Extend the experiment or increase sample size |

### 6. Clean Up

After the decision:
- Remove the flag check from code
- Delete the losing code path
- Document the result (what worked, what didn't, what you learned)

Stale flags are tech debt. Track them with tickets.

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "It's obviously better, we don't need to test" | Obvious improvements fail A/B tests all the time. Measure, don't assume |
| "Feature flags add complexity" | Deploying without a kill switch adds risk. The complexity is the safety mechanism |
| "We'll just deploy and watch the dashboard" | Watching dashboards isn't measurement. You need a control group and statistical rigor |
| "The sample size is too small for A/B testing" | Then use a staged rollout with guardrail monitoring. You can still ramp and roll back |
| "We'll clean up the flag later" | Set a calendar reminder for 30 days. Stale flags rot codebases |

## Red Flags

- Feature launched at 100% with no flag or rollback plan
- No metrics defined before launch
- Experiment called "successful" after 2 hours with 50 users
- Flags that have been in the codebase for months without cleanup
- Guardrail metrics not monitored during ramp
- Flag scattered across 10+ files instead of gated at one entry point

## Verification

- [ ] Hypothesis documented with specific metric and threshold
- [ ] Primary, guardrail, and diagnostic metrics defined
- [ ] Feature gated behind a flag with OFF as default
- [ ] Ramp plan exists with specific percentages and checkpoints
- [ ] Flag cleanup ticket created with a 30-day deadline
