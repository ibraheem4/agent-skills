---
name: developer-experience
description: Use when setting up a new project, onboarding engineers, or when local development is painful. Optimize for time-to-first-commit.
---

# Developer Experience

## Overview

Developer experience (DevEx) measures how quickly an engineer can go from clone to running code to merged PR. The target is the "F5 Contract" — clone, configure, press run, and the system works end-to-end with debugging attached. Every friction point in this loop is a tax paid by every engineer on every change.

## When to Use

- Setting up a new project or repository
- Onboarding a new team member (their friction IS your DevEx debt)
- When local development requires more than 3 manual steps
- When engineers routinely say "it works on my machine"

## Core Process

### 1. Measure the Baseline

Time two things:
- **Time to First Run** — from `git clone` to seeing the app running locally
- **Time to First Commit** — from clone to a locally verified change ready for PR

If either exceeds 30 minutes, DevEx needs investment.

### 2. The F5 Contract

The goal:

```
git clone <repo>
cp .env.example .env        # configure secrets/env
make dev                     # single command — everything starts
```

Requirements:
- Single command to build, test, and run
- Dependencies documented with exact versions
- External services mocked or containerized locally
- Hot reload for development iteration

### 3. Standardize Commands

Every repo uses the same entry points, regardless of language or framework:

| Command | Purpose |
|---------|---------|
| `make dev` | Start local development environment |
| `make test` | Run all tests |
| `make build` | Create production build |
| `make lint` | Run linters and formatters |
| `make clean` | Remove build artifacts |

Consistency across repos means engineers don't re-learn tooling when switching projects.

### 4. Minimize Remote Dependencies

Don't require cloud accounts, VPNs, or shared dev databases to run locally:

| Dependency | Local Alternative |
|-----------|-------------------|
| Cloud database | Docker container or embedded (SQLite, PGlite) |
| Message queue | Docker container (Redis, RabbitMQ) |
| External API | Mock server or recorded responses |
| Auth provider | Dev mode bypass or local mock |
| CDN/Storage | Local filesystem |

Use dependency injection to toggle between real and local implementations.

### 5. Treat Onboarding Issues as Bugs

New team members are uniquely positioned to find undocumented setup steps. Their experience is a signal, not noise:

- Every "it didn't work for me" is a README bug — fix it immediately
- Every "I had to ask someone" is missing documentation — add it
- Every "I didn't know about that" is an onboarding gap — update the guide

### 6. Designate a DevEx Champion

One team member actively owns developer experience:
- Curates a DevEx improvement backlog
- Tests setup instructions on a fresh machine quarterly
- Advocates for tooling improvements in sprint planning

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "Setup is a one-time cost" | It's paid by every new engineer, every fresh machine, every CI runner, and every time someone says "just works on my laptop" |
| "Real developers can figure it out" | Smart people solving solvable setup problems is waste. Document it once, save everyone's time |
| "Docker is too heavy for local dev" | A 2-minute Docker start beats a 2-hour manual setup. And it actually reproduces the production environment |
| "The README is fine" | Test it. Clone the repo on a clean machine and follow only what's written. If you need tribal knowledge, the README isn't fine |
| "DevEx improvements aren't features" | Every minute saved on setup is multiplied by every engineer on every change. It compounds faster than features |

## Red Flags

- Setup instructions reference tools that aren't installed by the setup script
- "Ask [person] for the dev credentials" appears in docs
- Local development requires a VPN or shared cloud resource
- Different engineers have different local setups that "work for them"
- No `.env.example` file — engineers copy secrets from Slack messages
- README says "see wiki" for setup instructions (wikis rot faster than READMEs)

## Verification

- [ ] A new engineer can run the project in under 30 minutes following only written docs
- [ ] Single command starts the full local development environment
- [ ] No cloud accounts or shared resources needed for local development
- [ ] `.env.example` file exists with all required variables documented
- [ ] Setup instructions tested on a fresh machine within the last quarter
