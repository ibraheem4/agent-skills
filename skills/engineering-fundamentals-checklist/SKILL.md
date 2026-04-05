---
name: engineering-fundamentals-checklist
description: Use at project kickoff, sprint boundaries, or before milestones. A comprehensive pre-flight checklist covering source control, testing, CI/CD, security, observability, and developer experience.
---

# Engineering Fundamentals Checklist

## Overview

A comprehensive checklist of engineering fundamentals that every project should have in place. Based on [Microsoft's Engineering Fundamentals Playbook](https://microsoft.github.io/code-with-engineering-playbook/). Use this at project start (Sprint 0), at sprint boundaries to catch drift, and before milestone deliveries.

## When to Use

- Starting a new project or service (Sprint 0)
- Onboarding to an existing project (audit what's missing)
- Before a milestone delivery or production launch
- During retrospectives to identify process gaps

## Core Process

### Sprint 0 Essentials

These must be in place before writing feature code:

#### Source Control
- [ ] Main branch is protected — no direct commits
- [ ] Branch policy requires PR with at least one approval
- [ ] Commit messages follow a convention (Conventional Commits)
- [ ] `.gitignore` covers build artifacts, dependencies, secrets, IDE files
- [ ] Sensitive files (`.env`, credentials) are never committed

#### CI/CD
- [ ] CI pipeline defined in the repo (not just in a UI)
- [ ] Every commit triggers build + test
- [ ] Pipeline includes: build, unit tests, lint, security scan
- [ ] Build status badge in README
- [ ] Broken builds block PR merges
- [ ] CD deploys to at least one non-production environment

#### Testing
- [ ] Unit test framework configured and running in CI
- [ ] Code coverage tool configured with minimum threshold (80%)
- [ ] Integration tests exist for external boundaries (DB, APIs)
- [ ] Tests are deterministic — no flaky tests in the suite

#### Security
- [ ] Credential scanning in CI (detect-secrets, git-secrets, or equivalent)
- [ ] Static analysis for security flaws (CodeQL, Semgrep, or equivalent)
- [ ] Dependencies scanned for known vulnerabilities
- [ ] Secrets stored in environment variables or secret manager, never in code
- [ ] Threat model exists for components handling user data

#### Observability
- [ ] Structured logging with correlation IDs
- [ ] Health check endpoint exists
- [ ] Key metrics exported (request rate, error rate, latency)
- [ ] Alerts configured for critical failures
- [ ] Dashboard answers "is the service healthy?" in 10 seconds

#### Developer Experience
- [ ] README with setup instructions that work (test on a fresh machine)
- [ ] Single command to build, test, and run locally
- [ ] Development environment documented (required tools, versions)
- [ ] Working agreement documented in the repo

### Ongoing Checks (Every Sprint)

- [ ] No new code merged without tests
- [ ] No increase in technical debt without a tracking ticket
- [ ] Retrospective conducted with at least one actionable experiment
- [ ] Design reviews held for stories with architectural impact
- [ ] PR review turnaround within agreed SLA (e.g., 24 hours)

### Pre-Milestone Checks

- [ ] All Definition of Done criteria met for every story
- [ ] Performance/load testing completed for user-facing paths
- [ ] Security review completed for new attack surface
- [ ] Runbook exists for new production components
- [ ] Rollback plan documented and tested

## Definition of Done — Three Levels

**Feature/Story:**
- Acceptance criteria met
- Code reviewed and approved
- Unit tests written and passing
- Integration tests passing
- Documentation updated
- Merged to main

**Sprint:**
- All story DoDs met
- Backlog groomed for next sprint
- No critical bugs open
- Sprint demo completed
- Retrospective conducted

**Release/Milestone:**
- All sprint DoDs met
- Performance testing passed
- Security review passed
- Monitoring and alerting verified
- Stakeholder sign-off obtained

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "We'll set up CI later" | CI in Sprint 0 prevents broken builds from day one. Every day without CI is a day of accumulating integration pain |
| "Coverage thresholds are arbitrary" | 80% isn't magic, but it catches the team that writes zero tests. The threshold is a floor, not a ceiling |
| "We don't need a working agreement" | Unwritten rules create confusion. Written ones create alignment. It takes 30 minutes to write one |
| "The README is good enough" | If a new engineer can't run the project in under 30 minutes, the README isn't good enough |
| "Retrospectives are a waste of time" | Then your retrospectives are run badly. Fix the format, don't skip the practice |

## Red Flags

- Project has been running for weeks with no CI pipeline
- No tests exist and nobody has noticed
- README setup instructions don't work
- No branch protection on main
- Secrets committed to the repo (even once — they're in git history forever)
- No retrospectives happening

## Verification

- [ ] All Sprint 0 checklist items are complete
- [ ] Definition of Done is documented and agreed upon
- [ ] Working agreement exists in the repo
- [ ] A new team member can set up and run the project in under 30 minutes
