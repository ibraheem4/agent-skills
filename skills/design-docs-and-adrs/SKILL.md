---
name: design-docs-and-adrs
description: Use when making architectural decisions or designing systems that affect multiple teams or services. Write the doc before writing the code.
---

# Design Docs and ADRs

## Overview

Design docs capture the *why* behind architectural decisions before implementation begins. ADRs (Architecture Decision Records) document specific choices and their tradeoffs. Both prevent knowledge loss and reduce costly reversals.

## When to Use

- Building a new service or major subsystem
- Changing a system boundary (API contract, data model, infrastructure)
- Making a decision that's expensive to reverse
- When multiple approaches exist and the choice isn't obvious

**Do not use** for minor implementation decisions, bug fixes, or changes confined to a single module.

## Core Process

### 1. Write the Design Doc

Use this structure (one page is ideal, three pages is the max):

```markdown
# Design: [System/Feature Name]

## Context
What problem are we solving? Why now?

## Goals and Non-Goals
Goals: what this design achieves
Non-goals: what this design explicitly does NOT solve

## Design

### Option A: [Name]
Description, tradeoffs, rough effort estimate

### Option B: [Name]
Description, tradeoffs, rough effort estimate

### Option C: [Name] (if applicable)
Description, tradeoffs, rough effort estimate

## Recommendation
Which option and why. Be specific about the deciding factors.

## Risks and Mitigations
What could go wrong? How do we detect and recover?

## Open Questions
What do we still need to figure out?
```

### 2. Review Before Implementing

The doc is the artifact for alignment. Share it with:
- People who will implement it
- People who will maintain it
- People whose systems it affects

Resolve disagreements in the doc, not in code review.

### 3. Record the Decision (ADR)

After the decision, write a short ADR:

```markdown
# ADR-NNN: [Decision Title]

**Status:** Accepted
**Date:** YYYY-MM-DD
**Context:** [Why we needed to decide]
**Decision:** [What we decided]
**Consequences:** [What changes as a result — both positive and negative]
```

ADRs are immutable. If a decision is reversed, write a new ADR that supersedes the old one.

### 4. Keep Docs Near the Code

Store design docs and ADRs in the repo, not in a wiki:
- `docs/design/` for design docs
- `docs/adr/` for ADRs
- Number ADRs sequentially: `001-use-postgres.md`, `002-event-sourcing.md`

Docs in the repo are versioned, reviewed, and discoverable. Wiki docs rot.

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "The code is the documentation" | Code shows what. It doesn't show why, what alternatives were considered, or what was explicitly excluded |
| "We'll document it after" | After never comes. And you'll forget the context and tradeoffs |
| "Design docs slow us down" | Implementing the wrong design is what slows you down. The doc takes hours; a wrong architecture takes months to fix |
| "Everyone already agrees" | Write it down anyway. Agreement without documentation becomes "I thought we agreed on something different" |
| "It's too small for a design doc" | Then write a smaller doc. An ADR is 5 lines |

## Red Flags

- Architectural decisions made in Slack threads with no record
- Design docs that describe the implementation but not the alternatives considered
- No ADRs in a codebase older than 6 months
- Design doc written after the implementation is complete
- "We've always done it this way" as justification for an architectural choice

## Verification

- [ ] Design doc written before implementation started
- [ ] At least two alternatives considered with tradeoffs documented
- [ ] Recommendation includes specific deciding factors
- [ ] Doc reviewed by implementers and affected teams before proceeding
- [ ] ADR recorded with status, date, context, decision, and consequences
- [ ] Docs stored in the repo, not a wiki
