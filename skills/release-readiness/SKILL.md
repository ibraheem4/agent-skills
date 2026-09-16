---
name: release-readiness
description: Determine whether a branch, pull request, package, migration, or deployment candidate has sufficient scope, review, QA, CI, rollback, approval, and evidence to ship. Use after implementation review and QA, before PR merge, package publication, production deployment, or customer delivery; this skill is a read-only gate and never performs the release.
---

# Release readiness

Issue a release verdict from current evidence. Do not confuse source durability, a pushed branch, or a passing build with a deployed and verified release.

## Entry evidence

Collect the work order, implementation record, delivery review verdict, QA report, current diff or PR, required CI results, release target, rollback approach, and pending approvals. Mark missing evidence explicitly.

## Gate

1. **Scope:** the diff matches the work order; unrelated or generated changes are understood; repository issue/branch/commit rules are satisfied.
2. **Acceptance:** every required behavior has evidence, including relevant failure, permission, responsive, migration, and recovery states.
3. **Review:** no unresolved P0/P1 finding remains. P2 deferrals have an owner or explicit acceptance.
4. **Quality:** required lint, typecheck, tests, builds, and visual checks passed against the candidate revision.
5. **Security:** no secret or sensitive data is added; authorization, tenancy, audit, limits, and dependency risks are resolved.
6. **Operations:** deployment order, configuration, migrations, monitoring, rollback, and post-release verification are defined for the target environment.
7. **Governance:** any production deployment, external publication, binding commitment, money movement, or destructive provider change has an attributable human approval for the exact immutable payload. The author or executing agent cannot approve its own consequential action.
8. **Traceability:** issue/work order, commit or artifact digest, checks, review, approval, execution target, and verification can be joined into one evidence thread.

## Verdicts

- `ready`: all required evidence is current and no gate is open.
- `conditional`: only named non-consequential checks or approvals remain; list the owner and exact closure evidence. Do not use this verdict to authorize execution.
- `blocked`: a P0/P1 issue, failed check, missing rollback, stale candidate, unauthorized payload, or material unknown prevents release.

## Output

```yaml
verdict: ready | conditional | blocked
candidate: branch, PR, commit, package, or artifact digest
target: environment or delivery destination
evidence:
 scope: pass | fail | missing
 acceptance: pass | fail | missing
 review: pass | fail | missing
 qa_ci: pass | fail | missing
 security: pass | fail | missing
 operations: pass | fail | missing
 governance: pass | fail | missing
open_items: []
approval_required: []
post_release_verification: []
next_owner: release-manager | engineer | qa | human-approver
```

State clearly that the verdict does not itself merge, publish, deploy, or authorize a consequential action.
