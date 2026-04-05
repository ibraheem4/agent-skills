---
name: observability-and-monitoring
description: Use when adding logging, metrics, or tracing to code. Instrument for diagnosis, not just recording.
---

# Observability and Monitoring

## Overview

Observability is the ability to understand a system's internal state from its external outputs. Good instrumentation answers "why is this broken?" not just "is this broken?" Ship instrumentation with the feature, not after the first incident.

## When to Use

- Adding any production code path
- Debugging a system with insufficient visibility
- Setting up monitoring for a new service

## Core Process

### 1. The Three Pillars

| Pillar | Answers | When to Use |
|--------|---------|-------------|
| **Logs** | What happened? | Debugging specific requests, audit trails |
| **Metrics** | How is the system behaving? | Dashboards, alerts, trend analysis |
| **Traces** | Where did the time go? | Cross-service latency, bottleneck identification |

### 2. Structured Logging

Logs must be structured (JSON), not free-text:

```typescript
// Bad: grep-hostile, no context
console.log(`User ${userId} created order`);

// Good: structured, searchable, correlated
logger.info('order.created', {
  userId,
  orderId,
  itemCount: items.length,
  totalAmount,
  traceId: ctx.traceId,
  duration_ms: Date.now() - startTime,
});
```

Rules:
- Use dot-namespaced event names: `order.created`, `payment.failed`
- Include correlation IDs (`traceId`, `requestId`) on every log
- Log at boundaries (entry/exit of services, external calls)
- Never log secrets, PII, or full request/response bodies

### 3. RED Metrics

Every service exposes the RED signals:

| Signal | What | How |
|--------|------|-----|
| **R**ate | Requests per second | Counter, labeled by endpoint |
| **E**rrors | Failed requests per second | Counter, labeled by type |
| **D**uration | Latency distribution | Histogram with p50/p95/p99 |

```typescript
// Middleware pattern
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    httpRequestDuration.observe(
      { method: req.method, route: req.route, status: res.statusCode },
      duration
    );
    if (res.statusCode >= 500) {
      httpErrorsTotal.inc({ method: req.method, route: req.route });
    }
  });
  next();
});
```

### 4. USE Metrics for Resources

For infrastructure components (databases, queues, pools):

| Signal | What | Alert When |
|--------|------|-----------|
| **U**tilization | % of capacity used | > 80% sustained |
| **S**aturation | Queue depth / backlog | Growing over time |
| **E**rrors | Failures per second | Any sustained errors |

### 5. Dashboards

Every service gets a dashboard with:
- **Top row**: Golden signals (request rate, error rate, latency p50/p99)
- **Middle**: Resource utilization (CPU, memory, connections, disk)
- **Bottom**: Business metrics (signups, orders, API calls by consumer)

The dashboard should answer "is the service healthy?" in under 10 seconds.

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "We have logs, that's enough" | Logs answer "what happened to this request." Metrics answer "is the system healthy right now." You need both |
| "Monitoring adds overhead" | The overhead of a counter increment is nanoseconds. The overhead of debugging blind is hours |
| "We'll add it when we need it" | You need it during the incident. Adding it during the incident is too late |
| "Our cloud provider handles monitoring" | Cloud metrics show infrastructure. They don't show your application's behavior |

## Red Flags

- Unstructured logs (`console.log` with string concatenation)
- No correlation IDs — can't trace a request across services
- Metrics only for infrastructure, not application behavior
- Dashboard that requires scrolling through 30 panels to find problems
- Logging PII or secrets

## Verification

- [ ] All logs are structured (JSON) with correlation IDs
- [ ] RED metrics (rate, errors, duration) exported for every endpoint
- [ ] No secrets or PII in log output
- [ ] Service dashboard exists and answers "is it healthy?" in 10 seconds
- [ ] Log levels are appropriate (info for normal flow, warn for recoverable, error for failures)
