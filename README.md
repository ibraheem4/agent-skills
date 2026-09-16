# Agent Skills

Behavioral guardrails and engineering workflows for AI coding agents. Each skill combats a specific agent failure mode — scope creep, blind retries, missing tests, hallucinated fixes — with step-by-step processes grounded in industry practices.

Draws from [Microsoft's Engineering Playbook](https://microsoft.github.io/code-with-engineering-playbook/), [Google's SWE Book](https://abseil.io/resources/swe-book), [Stripe's API design](https://stripe.com/docs/api), and [Netflix's resilience engineering](https://netflixtechblog.com/).

## Supported Tools

| Tool | Config File | Status |
|------|------------|--------|
| [Claude Code](https://claude.ai/code) | `CLAUDE.md` | Supported |
| [Codex](https://github.com/openai/codex) | `codex.md` / `AGENTS.md` | Supported |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | `GEMINI.md` | Supported |
| [OpenCode](https://github.com/nicholasgriffintn/opencode) | — | Planned |

## Why Agent-Specific Skills?

AI agents fail differently than humans:

| Agent Failure Mode | Human Equivalent | Skill That Fixes It |
|-------------------|-----------------|---------------------|
| Writes 500 lines without testing | Cowboy coding | [incremental-implementation](#build) |
| Retries the same failing approach | Stubbornness | `superpowers:systematic-debugging` |
| Adds features nobody asked for | Scope creep | [scope-discipline](#build) |
| Generates code with subtle security holes | Inexperience | [security-and-hardening](#review) |
| Leaves debug logs and TODOs in code | Carelessness | [shipping-and-launch](#ship) |
| Doesn't read existing code before editing | Arrogance | [code-review-and-quality](#review) |
| Over-engineers with premature abstractions | Resume-driven dev | [code-health-and-maintainability](#review) |
| Ignores error messages, guesses at fixes | Panic | `superpowers:systematic-debugging` |
| Deletes a repo that had unpushed work | Carelessness | [safe-repo-removal](#operate) |
| Kills a process that immediately respawns | Whack-a-mole | [find-hidden-services](#operate) |
| Reads the biggest log first | Chasing noise | [triage-failing-fleet](#operate) |
| Deletes committed files as "build output" | Overreach | [disk-reclaim](#operate) |
| Hardcodes one company into a reusable skill | Short-termism | [work-summary](#operate) |
| Calls unread mail a to-do list | Mistaking volume for signal | [work-queue](#operate) |

## Skills

### Build
- **[incremental-implementation](skills/incremental-implementation/)** — Never write more than 50 lines without running tests. Commit after every working change. *[Google: small CLs; Microsoft: atomic commits]*
- **[scope-discipline](skills/scope-discipline/)** — Surface assumptions, then do exactly what was asked. No extra features, no unsolicited improvements. *[Google: one logical change per CL]*
- **[api-and-interface-design](skills/api-and-interface-design/)** — Design the interface before the implementation. Consistent naming, minimal surface area, hard to misuse. *[Stripe: resource-oriented design, consistent error structure]*
- **[frontend-ui-engineering](skills/frontend-ui-engineering/)** — Composition over configuration, accessibility by default, no generic AI aesthetic. Includes reference library for 35+ components. *[Industry: WCAG, component architecture]*
- **[scroll-driven-animation](skills/scroll-driven-animation/)** — Scroll-linked motion that actually starts: pinning, reveal-on-enter, and why a scroll animation renders blank. *[Agent-specific]*
- **[ui-component-lookup](skills/ui-component-lookup/)** — Quick reference card for any component: anatomy, props, accessibility, anti-patterns
- **[better-accessibility](skills/better-accessibility/)** — Focus states, keyboard support, ARIA, forms and screen readers. For building or reviewing a component, not auditing a finished page. *[Industry: WCAG]*
- **[web-design-guidelines](skills/web-design-guidelines/)** — Review UI code against the Web Interface Guidelines. *[Industry: WIG]*
- **[tailwind-v4](skills/tailwind-v4/)** — CSS-first `@theme` configuration, the v3→v4 migration diffs, and why a dynamic class name silently fails to generate.
- **[context-engineering](skills/context-engineering/)** — Read before writing, load deliberately, verify don't assume. Manage what enters the context window. *[Agent-specific]*

### Verify
- **[verify-before-cite](skills/verify-before-cite/)** — A document is a claim, not evidence. Check the path, role or resource lives before following or repeating it. *[Agent-specific]*
- **[false-verification-signals](skills/false-verification-signals/)** — A cached run is a replay, a sandboxed probe is about the sandbox, and zero rows can mean no scope. Confirm the check ran. *[Agent-specific]*
- **[performance-optimization](skills/performance-optimization/)** — Measure first, optimize the bottleneck, verify the improvement. Never optimize without profiling data. *[Google: measure-first; Stripe: latency budgets]*

### Review
- **[code-review-and-quality](skills/code-review-and-quality/)** — Two-pass review: design pass, then code quality pass. Label findings by severity. *[Microsoft: two-pass model; Google: readability reviews]*
- **[security-and-hardening](skills/security-and-hardening/)** — DevSecOps shift-left checks: input validation, auth, secrets, dependencies. *[Microsoft: SDL; OWASP Top 10]*
- **[threat-modeling](skills/threat-modeling/)** — STRIDE threat analysis on data flow diagrams. Identify threats at design time, not after deployment. *[Microsoft: SDL]*
- **[code-health-and-maintainability](skills/code-health-and-maintainability/)** — Remove dead code. Improve names. Reduce nesting. Three similar lines are better than one wrong abstraction. *[Google: readability; Microsoft: code health]*

### Ship
- **[shipping-and-launch](skills/shipping-and-launch/)** — Pre-flight checklist: tests pass, no secrets, no debug logs, no TODOs without tickets. *[Microsoft: Engineering Fundamentals Checklist]*
- **[git-workflow-and-versioning](skills/git-workflow-and-versioning/)** — Conventional commits, branch naming, semantic versioning. Every commit compiles and passes tests. *[Google: trunk-based development]*
- **[review-response](skills/review-response/)** — Address every review comment: fix, acknowledge, or explain. Batch fixes, reply individually, resolve threads. *[Google: review turnaround]*
- **[pr-lifecycle](skills/pr-lifecycle/)** — Shepherd a PR to merge-readiness: monitor CI, fix failures, handle feedback, loop until green. Never merge automatically. *[Microsoft/Google: CI gates]*

### Operate
- **[graceful-degradation](skills/graceful-degradation/)** — Every external call needs a timeout. Classify dependencies as critical or optional. Degrade, don't crash. *[Netflix: Hystrix, circuit breakers, fallback hierarchy]*
- **[observability-and-monitoring](skills/observability-and-monitoring/)** — Structured logs, RED metrics, correlation IDs. Ship monitoring with the feature. *[Google: SRE; Microsoft: observability pillar]*
- **[safe-repo-removal](skills/safe-repo-removal/)** — Prove every commit is recoverable before deleting a repo. Five checks, a manifest, and a restore-tested bundle. *[Agent-specific]*
- **[find-hidden-services](skills/find-hidden-services/)** — A respawning process means you found one spawner, not all of them. Enumerate launchd, native-messaging hosts and MCP configs. *[Agent-specific]*
- **[triage-failing-fleet](skills/triage-failing-fleet/)** — Collapse logs to distinct lines, then walk the dependency chain backwards to the one upstream cause. *[Agent-specific]*
- **[disk-reclaim](skills/disk-reclaim/)** — Caches before working trees. Never assume `dist/` is untracked. *[Agent-specific]*
- **[local-bringup](skills/local-bringup/)** — Cold clone to an app you have seen working: toolchain pins, port and database collisions, and a screenshot as the bar. *[Agent-specific]*
- **[gcp-resource-sweep](skills/gcp-resource-sweep/)** — A resource's name tells you nothing about whether it is used. Prove it with evidence before deleting. *[Agent-specific]*
- **[mail-authentication-records](skills/mail-authentication-records/)** — SPF, DKIM and DMARC as live production controls: a wrong record silently drops real mail. *[Agent-specific]*
- **[google-workspace-sso-cutover](skills/google-workspace-sso-cutover/)** — Moving a tenant onto SSO without locking everyone out, including yourself. *[Agent-specific]*
- **[aws-infra](skills/aws-infra/)** — Pin the AZ, delegate subdomains instead of repointing an apex, and verify every role name against live IAM. *[Agent-specific]*
- **[oauth-social-providers](skills/oauth-social-providers/)** — A provider client secret is shown once; capture it before anything can destroy it, and check the gates that reject sign-ins for reasons unrelated to your credentials. *[Agent-specific]*
- **[session-handoff](skills/session-handoff/)** — Write a continuation prompt a cold session can act on: absolute paths, real shas, verified vs assumed, one next step. *[Agent-specific]*
- **[pr-preview-environments](skills/pr-preview-environments/)** — Per-PR ephemeral preview environments on AWS + GitHub Actions: label-gated spin-up, an isolated database per PR whose *name* is the safety gate, the OIDC trust split that keeps a PR-triggered role from becoming account admin, and a teardown that cannot report success while orphaning billable resources.
- **[work-summary](skills/work-summary/)** — Summarize one workspace's activity for any period across ten sources and post it. Profile-driven, no hardcoded org. *[Agent-specific]*
- **[work-queue](skills/work-queue/)** — The inverse: what is owed, not what is done. Nine sources into six ranked bands, each with the noise filter it needs. Read-only, profile-driven. *[Agent-specific]*

### Foundations
- **[agent-operating-principles](skills/agent-operating-principles/)** — Core behaviors: surface assumptions, stop when confused, don't be sycophantic, admit uncertainty. *[Agent-specific]*
- **[skill-authoring](skills/skill-authoring/)** — Create and revise reusable skills: the contract, the invariants, and a validator. *[Agent-specific]*
- **[engineering-fundamentals-checklist](skills/engineering-fundamentals-checklist/)** — Sprint 0 setup: CI, tests, branch protection, security scanning, monitoring. *[Microsoft: Engineering Fundamentals Playbook]*

## Skills we deliberately do not ship

Another plugin already does it better. Adopting beats duplicating: two skills matching the
same trigger means unpredictable selection, and the weaker one wins half the time.

| Not here | Use instead | Why |
|---|---|---|
| test-driven-development | `superpowers:test-driven-development` | 320 lines to our 128, with an explicit *verify-RED / verify-GREEN* step ours lacked. Our Google test-size classification survives in `engineering-fundamentals-checklist` |
| debugging-and-error-recovery | `superpowers:systematic-debugging` | Four phases with root-cause investigation and pattern analysis, against our six linear steps |

Checked and **kept** rather than deferred, because the overlap was apparent and not real:

- `review-response` — `superpowers:receiving-code-review` covers judgment (when to push back,
  forbidden responses); ours covers thread hygiene (reply to every comment, resolve threads)
- `frontend-ui-engineering` — `frontend-design` is 71 lines of aesthetic direction; ours is
  engineering plus accessibility, components, responsive and data-viz references
- `false-verification-signals` — `superpowers:verification-before-completion` is the
  first-order rule (run it, read it, then claim). Ours is the second-order one: six cases
  where you did run it, did read it, and were still deceived

## Design Philosophy

1. **Agent failure modes, not human advice** — Each skill targets a specific way agents break
2. **Process over prose** — Step-by-step workflows, not knowledge dumps
3. **Anti-rationalization** — Common excuses for skipping steps with factual rebuttals
4. **Industry-grounded** — Every practice is cited to a public engineering playbook or book
5. **Tool-agnostic core** — Skills work across Claude Code, Codex, and Gemini CLI

## Quick Start

### Claude Code
```bash
cp -r skills/ your-project/.claude/skills/
```

### Codex
```bash
cp -r skills/ your-project/.codex/skills/
```

### Gemini CLI
```bash
cp -r skills/ your-project/.gemini/skills/
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. See [docs/skill-anatomy.md](docs/skill-anatomy.md) for the skill template.

## License

MIT
