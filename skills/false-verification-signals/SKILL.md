---
name: false-verification-signals
description: Use when a check has just passed or failed and you are about to report it. Some green results are replays and some red results are artifacts of the harness. Confirm the check actually ran against the code in front of you before believing either.
---

# False Verification Signals

## Overview

"Done means you ran something and read the output" has a failure mode: the output can be
about something other than what you think you tested. A cached task replays a run from
another checkout. A sandboxed probe reports a live service down. A row count of zero means
"no tenant scope", not "no rows".

Each of these produces a confident, plausible, well-formatted result. None of them announces
itself as false. This skill is the list of signals that lie, and the cheap confirmation for
each.

## When to Use

- Before reporting any test, lint, typecheck, or build result
- Before concluding a service, port, or database is down or empty
- When a result arrives suspiciously fast, or a failure count is implausibly large
- When verifying inside a worktree, container, or sandbox rather than the primary checkout

## Core Process

### 1. A cached task result is not a test run

In a monorepo with a task cache (turbo, nx, bazel), a full verification run in a fresh
worktree can complete in milliseconds by **replaying logs from a different checkout**. The
replayed output carries plausible test counts and timestamps and prints the *other*
checkout's file paths. Nothing in it says "stale".

When the point of the run is to verify rather than to go fast:

```sh
<task-runner> run typecheck test lint build --force
```

| Check | Trustworthy |
|---|---|
| Summary line | says `0 cached` — anything else is a replay |
| Wall time | plausible for the work claimed, not milliseconds |
| File paths in the log | name the checkout you are actually in |

### 2. Worktrees inside a repo poison test and lint runs

Test runners and linters generally do **not** honour `.gitignore`. A worktree stored inside
the repo is walked as if it were source, so a bare run reports failures from stale copies of
the code. Hundreds of failures with zero in the tree proper is the signature.

Re-run excluding the worktree directory before believing any local failure. Never "fix" a
failure that lives in a copy, and never report one — CI checks out without them and stays
green, so the finding is noise to a reviewer.

This is the mirror of §1: worktrees add **false failures** to the main checkout, while the
cache hides **real results** inside a worktree.

### 3. A sandboxed probe is evidence about the sandbox

Where the agent runtime filters network egress, loopback is usually filtered too. A port
probe or an HTTP request against a local dev server then reports closed or refused for a
service that is running normally.

Confirm liveness with something that does not cross the network — the process table, the
service manager, the container list — before concluding anything is down. A closed-port
result under a sandbox is not evidence about the service.

The same applies to any filesystem or socket path the sandbox denies: the error describes
the policy, not the system.

### 4. Zero rows can mean "no scope", not "no data"

Under `FORCE ROW LEVEL SECURITY`, the policy applies to the table owner too. A session that
sets no tenant scope gets **zero rows from a fully populated table** — working as designed,
not a leak and not an empty database.

Confirm with a path that bypasses or sets the scope: query as the superuser, or set the
scoping variable and role explicitly for the transaction. `pg_stat_user_tables.n_live_tup`
ignores RLS entirely, so a wild mismatch between it and a `select count(*)` is the tell.

Tables with RLS *enabled but not forced* still return rows to the owner, which makes the
zeros on neighbouring tables look even more like genuine emptiness.

### 5. A shared test database makes global counts meaningless

Where a test suite writes to the same database the dev server reads, and nothing tears it
down, the tables grow with every test run. Aggregate counts then measure fixture volume, not
real data — thousands of rows against a real book of zero.

Repeated or patterned names are the tell. Scope every count by the tenant or owner you
actually care about, and never conclude "the table is populated" from a global count.

### 6. A build can break a running server without crashing it

A build that writes into the same output directory a dev server is serving from will delete
the manifests underneath it. Every route then errors, the server does not notice, and it
never recovers on its own.

Likewise, in a monorepo, rebuilding shared packages restarts every watch-mode server that
depends on them. Probes fired during that window return connection-refused and read exactly
like a crash.

So: don't build against a live stack you are about to verify. Stop the server, build, clear
the output directory, restart.

## Common Rationalizations

| Excuse | Why It's Wrong |
|---|---|
| "The summary said all tasks succeeded" | It said they were *satisfied*. Cached and executed are different claims |
| "It ran in 200ms, the cache is working great" | That is the symptom, not the reassurance |
| "Hundreds of tests fail, the branch is broken" | Check where they live before you touch anything |
| "The port is closed, the service is down" | Only if your probe was allowed to reach it |
| "The table is empty" | Only if your session was allowed to see it |
| "I'll just rebuild quickly while it's running" | That is how the running server dies |

## Verification

- [ ] Any pass reported as verification ran with the cache disabled, and the summary says so
- [ ] The log's file paths name the checkout under test
- [ ] Local failures were reproduced with nested worktrees excluded
- [ ] "Down" and "empty" conclusions came from a path the sandbox and RLS do not filter
- [ ] Row counts are scoped to a tenant, not global, on any shared database
- [ ] No build was run against the stack being verified
