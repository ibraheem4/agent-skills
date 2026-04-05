---
name: graceful-degradation
description: Use when building features that depend on external services, databases, or APIs. Design for partial failure — degrade, don't crash.
---

# Graceful Degradation

## Overview

External dependencies fail. Networks partition. Databases slow down. Design every integration point to degrade gracefully — return stale data, skip optional features, or show a meaningful fallback — instead of crashing the entire request.

## When to Use

- Calling any external API or third-party service
- Building features with multiple backend dependencies
- Designing retry/timeout/circuit-breaker strategies
- Any path where a dependency failure would cascade to users

**Do not use** for core data integrity operations where partial results are worse than failure (e.g., financial transactions).

## Core Process

### 1. Classify Dependencies

For every external call, ask: **is this critical or optional?**

| Classification | If it fails... | Strategy |
|---------------|----------------|----------|
| **Critical** | The request cannot succeed | Retry with backoff, then fail fast with clear error |
| **Optional** | The request can succeed without it | Skip, use cached/default data, hide the feature |

```
User profile page:
  ├── User data (database)        → Critical: fail if unavailable
  ├── Recommendations (ML service) → Optional: show "unavailable" placeholder
  ├── Activity feed (feed service)  → Optional: show cached version
  └── Avatar (CDN)                  → Optional: show default avatar
```

### 2. Set Timeouts

Every external call needs a timeout. No exceptions.

```typescript
// Bad: no timeout — hangs forever if dependency is slow
const result = await fetch(serviceUrl);

// Good: explicit timeout
const result = await fetch(serviceUrl, {
  signal: AbortSignal.timeout(3000), // 3 second timeout
});
```

Guidelines:
- p99 latency of the dependency + buffer = timeout
- If you don't know the p99, start at 3 seconds and tune down
- Timeout at the call site, not just the HTTP client

### 3. Implement Circuit Breakers

Prevent cascading failures by stopping calls to a failing dependency:

```
     Closed (normal)
         │
    error threshold exceeded
         │
         ▼
     Open (failing)  ──── timer expires ────→  Half-Open
         │                                        │
    all calls fail fast                    one probe request
                                                  │
                              success ◄───────────┤
                                │                 │
                          Close circuit     failure: re-open
```

States:
- **Closed**: Requests flow normally. Track failure rate.
- **Open**: All requests fail immediately (no call made). Return cached/default.
- **Half-Open**: Allow one probe request. If it succeeds, close. If it fails, re-open.

### 4. Cache Defensively

When a dependency is down, stale data is better than no data:

```typescript
async function getRecommendations(userId: string): Promise<Recommendation[]> {
  try {
    const fresh = await recommendationService.fetch(userId);
    await cache.set(`recs:${userId}`, fresh, { ttl: 3600 });
    return fresh;
  } catch {
    const cached = await cache.get(`recs:${userId}`);
    if (cached) {
      logger.warn('recommendations.stale_cache', { userId });
      return cached;
    }
    return []; // Empty fallback — UI shows "no recommendations"
  }
}
```

### 5. Fail Fast for Critical Paths

For critical dependencies, don't retry forever. Fail fast with a clear error:

```typescript
async function processPayment(order: Order): Promise<PaymentResult> {
  try {
    return await paymentGateway.charge(order, {
      timeout: 5000,
      retries: 2,
      backoff: 'exponential',
    });
  } catch (err) {
    // Don't degrade — payments must succeed or clearly fail
    throw new PaymentFailedError(
      'Payment processing unavailable. Please try again.',
      { cause: err, orderId: order.id }
    );
  }
}
```

### 6. Test Failure Modes

Don't just test the happy path. Test what happens when dependencies fail:

```typescript
describe('UserProfilePage', () => {
  it('renders with recommendations unavailable', async () => {
    recommendationService.fetch.mockRejectedValue(new Error('timeout'));
    const page = await renderProfile('user-1');
    expect(page).toContain('user-1 profile');
    expect(page).toContain('Recommendations unavailable');
  });
});
```

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "That service never goes down" | It will. And when it does, your service goes down too if you didn't plan for it |
| "Timeouts add complexity" | No timeout means unbounded wait. That's not simplicity, it's a latent outage |
| "Retries will handle it" | Retries without backoff and limits amplify failures. They turn partial outages into full ones |
| "The user needs real-time data" | Stale data shown in 100ms beats accurate data shown after a 30s timeout |
| "We'll handle failures when they happen" | By then you're in an incident. The time to design fallbacks is now |

## Red Flags

- External HTTP calls with no timeout
- A single dependency failure crashes the entire page/request
- Retry loops with no backoff, limit, or circuit breaker
- No cached fallback for non-critical data
- Error messages that expose internal dependency details to users
- Tests that only cover the happy path (all dependencies up)

## Verification

- [ ] Every external dependency classified as critical or optional
- [ ] All external calls have explicit timeouts
- [ ] Optional dependencies have fallback behavior (cache, default, skip)
- [ ] Critical dependencies fail fast with clear user-facing errors
- [ ] Tests exist for each dependency failure scenario
- [ ] No single dependency failure causes complete service unavailability
