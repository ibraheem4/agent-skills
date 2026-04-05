---
name: threat-modeling
description: Use when designing systems that handle user data, authentication, or external inputs. Identify threats using STRIDE before writing code.
---

# Threat Modeling

## Overview

Threat modeling identifies security risks during design — not after deployment. Use the STRIDE framework to systematically enumerate threats against each component in your system's data flow. This practice originates from Microsoft's Security Development Lifecycle (SDL) and is required for all production systems that handle sensitive data.

## When to Use

- Designing a new service or API
- Adding authentication, authorization, or data storage
- Introducing a new external integration or data flow
- Before any design review for security-sensitive components

**Do not use** for purely internal tooling with no user data or external exposure.

## Core Process

### 1. Diagram the Data Flow

Draw a data flow diagram (DFD) showing:
- **External entities** — users, third-party APIs, other services
- **Processes** — your code, services, functions
- **Data stores** — databases, caches, file systems
- **Data flows** — arrows showing what data moves where
- **Trust boundaries** — lines separating different privilege levels

```
┌──────────┐    HTTPS     ┌──────────┐    SQL      ┌──────────┐
│  Browser  │────────────→│  API     │────────────→│ Database  │
│ (external)│             │ Server   │             │          │
└──────────┘              └────┬─────┘             └──────────┘
                               │
              ─ ─ ─ ─ ─ ─ ─ ─ ┼ ─ ─ ─ ─ ─  Trust Boundary
                               │
                          ┌────▼─────┐
                          │  Auth    │
                          │ Service  │
                          └──────────┘
```

### 2. Apply STRIDE to Each Component

For every element in the diagram, ask:

| Threat | Question | Example |
|--------|----------|---------|
| **S**poofing | Can an attacker pretend to be someone else? | Forged auth tokens, session hijacking |
| **T**ampering | Can data be modified in transit or at rest? | SQL injection, man-in-the-middle, unsigned config |
| **R**epudiation | Can a user deny performing an action? | Missing audit logs, unsigned transactions |
| **I**nformation Disclosure | Can sensitive data leak? | Error messages with stack traces, unencrypted PII |
| **D**enial of Service | Can the system be made unavailable? | Unbounded queries, missing rate limits, resource exhaustion |
| **E**levation of Privilege | Can a user gain unauthorized access? | Missing auth checks, IDOR, privilege escalation |

### 3. Prioritize Threats

Rate each threat:

| Factor | Scale |
|--------|-------|
| **Likelihood** | Low / Medium / High |
| **Impact** | Low / Medium / High / Critical |
| **Priority** | Impact × Likelihood → address High/Critical first |

### 4. Define Mitigations

For each prioritized threat, specify a concrete mitigation:

| Threat | Mitigation |
|--------|-----------|
| Spoofing: forged tokens | JWT with short expiry + refresh tokens, validate issuer |
| Tampering: SQL injection | Parameterized queries only, never string concatenation |
| Info disclosure: error details | Generic error messages to clients, detailed logs server-side |
| DoS: unbounded queries | Pagination required, max page size enforced, rate limiting |
| Elevation: IDOR | Authorization check on every resource access, not just routes |

### 5. Validate

After implementation, verify each mitigation is in place:
- Security-focused code review
- Automated scanning (SAST, DAST)
- Penetration testing for high-priority threats

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "We'll do a security review later" | Later means after the architecture is set. Fixing design-level security issues in code review is 10x more expensive |
| "It's an internal service" | Internal services are the first target after initial compromise. Zero trust means threat-model everything |
| "The framework handles security" | Frameworks provide tools. STRIDE identifies the threats your framework doesn't know about — your specific data flows |
| "Threat modeling takes too long" | A 30-minute STRIDE session prevents weeks of incident response. The DFD alone improves system understanding |
| "We don't have security expertise" | STRIDE is a checklist, not a skill. Any engineer can ask "can this input be tampered with?" |

## Red Flags

- No data flow diagram exists for a service handling user data
- Auth checks only at the API gateway, not at the service level
- Error responses include stack traces or internal details
- No rate limiting on public endpoints
- Audit logs missing for sensitive operations
- "We trust the caller" without verification

## Verification

- [ ] Data flow diagram created with all components, data stores, and trust boundaries
- [ ] STRIDE applied to every component crossing a trust boundary
- [ ] Each identified threat has a documented mitigation
- [ ] High/Critical threats have mitigations implemented before launch
- [ ] Mitigations verified through code review or automated scanning
