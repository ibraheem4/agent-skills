---
name: performance-optimization
description: Use when optimizing code for speed, memory, or bundle size. Measure first, optimize the bottleneck, verify the improvement. Never optimize without profiling data.
---

# Performance Optimization

## Overview

Agents optimize the wrong things — making micro-optimizations to code that runs once while ignoring the N+1 query that runs 10,000 times. This skill enforces measure-first optimization: find the bottleneck with data, fix that specific bottleneck, and verify the improvement. Never optimize based on intuition.

Grounded in Google's approach to performance: "Premature optimization is the root of all evil" (Knuth), but measured optimization is engineering. Also draws from Stripe's approach to API latency budgets.

## When to Use

- User reports something is "slow"
- A performance regression is detected
- Building code that will handle high throughput
- Reviewing code with obvious performance issues (N+1 queries, unbounded loops)

**Do not use** for code that runs once (scripts, migrations, setup) or where correctness is more important than speed.

## Core Process

### 1. Define the Target

Before optimizing, establish what "fast enough" means:

| Metric | Typical Target |
|--------|---------------|
| API response (p50) | < 100ms |
| API response (p99) | < 500ms |
| Page load (LCP) | < 2.5s |
| Bundle size (JS) | < 200KB gzipped |
| Database query | < 50ms |
| Background job | Depends on SLO |

If there's no performance problem, there's nothing to optimize.

### 2. Measure the Baseline

Get actual numbers before changing anything:

```typescript
// Simple timing
const start = performance.now();
await operation();
console.log(`Duration: ${(performance.now() - start).toFixed(1)}ms`);
```

For APIs: check existing metrics (p50, p95, p99 latency).
For frontend: use Lighthouse, Core Web Vitals, or browser DevTools.
For queries: use `EXPLAIN ANALYZE` or query logging.

Record the baseline number. You need it to prove the optimization worked.

### 3. Find the Bottleneck

Profile, don't guess:

| Layer | How to Profile |
|-------|---------------|
| **Database** | `EXPLAIN ANALYZE` on slow queries. Look for sequential scans, missing indexes |
| **API** | Distributed tracing. Which span is longest? |
| **Frontend** | Lighthouse, bundle analyzer. What's the largest chunk? |
| **Algorithm** | Time individual operations. Is it O(n²) when it could be O(n)? |

Common bottlenecks agents should recognize without profiling:

```typescript
// N+1 query — fires a query per item
for (const user of users) {
  const orders = await db.orders.findByUser(user.id); // ← N queries
}

// Fix: batch query
const orders = await db.orders.findByUsers(users.map(u => u.id)); // ← 1 query
```

```typescript
// Unbounded result set
const allUsers = await db.users.findAll(); // ← loads entire table
const active = allUsers.filter(u => u.isActive);

// Fix: filter in the query
const active = await db.users.findAll({ where: { isActive: true } });
```

### 4. Optimize the Bottleneck Only

Fix the measured bottleneck. Don't optimize other things "while you're here."

Common optimizations by category:

**Database:**
- Add an index for slow queries
- Replace N+1 with batch queries or joins
- Add pagination (cursor-based, not offset)
- Cache frequently-read, rarely-written data

**API:**
- Parallelize independent calls (`Promise.all`)
- Add caching with appropriate TTL
- Reduce payload size (select specific fields, pagination)
- Move heavy work to background jobs

**Frontend:**
- Code split large bundles (lazy load routes)
- Optimize images (WebP, responsive sizes)
- Defer non-critical JavaScript
- Memoize expensive computations

**Algorithm:**
- Replace O(n²) with O(n log n) or O(n)
- Use hash maps for lookups instead of array scans
- Short-circuit early when possible

### 5. Verify the Improvement

Measure again with the same method as the baseline:

```
Before: p50 = 340ms, p99 = 1200ms
After:  p50 = 45ms,  p99 = 180ms
Change: 87% faster (p50), 85% faster (p99)
```

If the improvement isn't measurable, revert. Complexity without measurable benefit is a net negative.

### 6. Guard Against Regression

Add a test or monitoring that catches regressions:

```typescript
it('returns search results within 200ms', async () => {
  const start = performance.now();
  await searchService.search('test query');
  expect(performance.now() - start).toBeLessThan(200);
});
```

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "This looks slow, let me optimize it" | Looks slow ≠ is slow. Measure first |
| "Let me cache everything" | Caching adds complexity (invalidation, staleness). Only cache measured bottlenecks |
| "I'll use a more efficient algorithm" | If the input is always 10 items, O(n²) vs O(n) is irrelevant. Profile first |
| "Premature optimization is bad, so I'll skip it" | Measured optimization isn't premature. Known N+1 queries aren't premature to fix |
| "I optimized it but didn't measure the improvement" | Then you don't know if it worked. Measure before and after |

## Red Flags

- Optimizing without baseline measurements
- Micro-optimizing code that runs once
- Adding caching without understanding invalidation requirements
- Replacing readable code with "fast" code when there's no measured problem
- Optimizing multiple things at once (can't tell which helped)
- No regression test to guard the improvement

## Verification

- [ ] Performance target defined before optimizing
- [ ] Baseline measured with actual numbers
- [ ] Bottleneck identified through profiling, not guessing
- [ ] Only the bottleneck was optimized (no scope creep)
- [ ] Improvement measured and compared to baseline
- [ ] Regression guard in place (test or monitoring)
