# Agent Skills — Gemini CLI

Behavioral guardrails for AI coding agents. Each skill in `skills/` targets a specific agent failure mode with a step-by-step process grounded in industry practices (Microsoft, Google, Stripe, Netflix).

## Critical Skills (apply always)

- **scope-discipline** — Do exactly what was asked. No extra features, no unsolicited refactors
- **incremental-implementation** — Never write more than 50 lines without running tests

## Available Skills

| Skill | Agent Failure Mode It Fixes |
|-------|----------------------------|
| scope-discipline | Adding features nobody asked for |
| incremental-implementation | Writing 500 lines without testing |
| test-driven-development | Shipping code without tests |
| debugging-and-error-recovery | Retrying the same failing approach |
| code-review-and-quality | Missing subtle bugs in generated code |
| security-and-hardening | Introducing injection vectors, hardcoded secrets |
| shipping-and-launch | Leaving debug logs and TODOs in code |
| graceful-degradation | Not handling dependency failures |
| code-health-and-maintainability | Over-engineering with premature abstractions |
| api-and-interface-design | Inconsistent interfaces, poor error design |
| safe-repo-removal | Deleting a repo that had unpushed work |
| find-hidden-services | Killing a process that immediately respawns |
| triage-failing-fleet | Reading the biggest log instead of the first failure |
| disk-reclaim | Deleting committed files as build output |
| work-summary | Hardcoding one company into a reusable skill |
| false-verification-signals | Reporting a cached replay as a passing test run |
| session-handoff | Writing a handoff that says "the worktree" instead of the path |
| verify-before-cite | Repeating a resource name from a doc that never existed |
| local-bringup | Claiming an app runs without ever opening it |
| aws-infra | Repointing an apex's nameservers, or deriving an AZ that forces a replace |
| pr-preview-environments | Trusting `pull_request` on a role that holds admin |
