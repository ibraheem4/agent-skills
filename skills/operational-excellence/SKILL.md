---
name: operational-excellence
description: Use when building features that run in production. Design for operability — monitoring, alerting, runbooks, and incident response.
---

# Operational Excellence

## Overview

Production code needs more than correctness — it needs operability. Every feature should be observable, alertable, and recoverable. Think about how on-call will diagnose problems at 2am.

## When to Use

- Building or modifying any production service
- Adding a new endpoint, job, or background process
- After an incident (to prevent recurrence)
- Reviewing code that will serve production traffic

## Core Process

### 1. Define SLOs

Before shipping, define what "working" means:

| SLO | Target | Measurement |
|-----|--------|-------------|
| Availability | 99.9% (8.7h downtime/year) | Health check success rate |
| Latency | p50 < 100ms, p99 < 500ms | Request duration histogram |
| Error rate | < 0.1% of requests | 5xx / total requests |

If the service doesn't meet its SLOs, nothing else matters until it does.

### 2. Add Observability

Every production path needs three signals:

**Logs** — Structured, with correlation IDs:
```typescript
logger.info('payment.processed', {
  userId, orderId, amount, duration_ms,
  trace_id: ctx.traceId,
});
```

**Metrics** — Counters, histograms, gauges:
```typescript
requestDuration.observe({ method, route, status }, elapsed);
activeConnections.set(pool.size);
errorsTotal.inc({ type: 'validation', endpoint });
```

**Traces** — Distributed tracing across service boundaries. Propagate trace context through all calls.

### 3. Configure Alerts

Alert on symptoms (SLO violations), not causes:

| Alert | Good | Bad |
|-------|------|-----|
| Symptom | "Error rate > 1% for 5 min" | "Exception in PaymentService" |
| Symptom | "p99 latency > 2s for 10 min" | "Slow query detected" |
| Symptom | "Success rate < 99% for 5 min" | "CPU > 80%" |

Rules:
- Every alert must have a runbook link
- If an alert fires and requires no action, delete it
- Page for user-facing impact. Ticket for everything else

### 4. Write Runbooks

For every alert, document:

```markdown
## Alert: payment-error-rate-high

### Impact
Users cannot complete purchases.

### Diagnosis
1. Check error logs: `grep payment.error | tail -50`
2. Check downstream dependencies: payment gateway status page
3. Check recent deploys: `git log --since="2 hours ago"`

### Mitigation
1. If caused by recent deploy: rollback
2. If downstream is down: enable fallback payment provider
3. If unknown: page the payments team lead

### Escalation
- payments-oncall@company.com
- #payments-incidents Slack channel
```

### 5. Conduct Postmortems

After every incident (SEV-1 or SEV-2):

1. **Timeline** — What happened, when, minute by minute
2. **Root cause** — The actual cause, not the trigger
3. **Impact** — Users affected, duration, revenue impact
4. **Action items** — Specific, assigned, with deadlines
5. **Blameless** — Focus on systems, not people

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "We'll add monitoring later" | You won't know it's broken until a user reports it. Ship monitoring with the feature |
| "The logs are enough" | Logs tell you what happened. Metrics tell you something is happening. Alerts tell you NOW |
| "Nobody reads runbooks" | They do at 2am when they're paged. That's exactly when quality matters most |
| "Our service is simple, it won't go down" | Simple services go down for simple reasons — expired certs, full disks, dependency failures |
| "Postmortems are blame sessions" | Then your culture is broken. Fix the process, don't skip it |

## Red Flags

- Production service with no health check endpoint
- Alerts without runbooks
- Logs with no structure or correlation IDs
- No SLO defined for a user-facing service
- Incident response is "look at the logs and figure it out"
- Postmortems that end with "be more careful next time"

## Verification

- [ ] SLOs defined for availability, latency, and error rate
- [ ] Structured logging with correlation IDs on all production paths
- [ ] Metrics exported for request rate, duration, and error count
- [ ] Alerts configured for SLO violations (symptoms, not causes)
- [ ] Every alert has a linked runbook with diagnosis and mitigation steps
- [ ] Health check endpoint exists and is monitored
