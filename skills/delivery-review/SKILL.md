---
name: delivery-review
description: Perform a read-only pre-QA review of a software change against its work order, repository rules, correctness, security, shared contracts, governance boundaries, tests, and regression surface. Use after implementation or when asked to review a branch, diff, PR, or artifact; report actionable findings and do not edit, commit, publish, or approve the release.
---

# Delivery review

Review the changed behavior, not merely the patch shape. Treat passed checks as evidence, not proof that the acceptance contract is satisfied.

## Workflow

1. Read the work order, implementation record, applicable repository instructions, and full scoped diff. Resolve the base revision before assessing omissions.
2. Reconstruct the intended behavior and affected consumers. Verify that the change landed at the canonical implementation point identified during orientation.
3. Review in this order:
 - **Correctness:** acceptance criteria, state transitions, data scope, error paths, concurrency, recovery, and migration behavior.
 - **Security and governance:** authentication, authorization, secret handling, tenancy, audit attribution, resource limits, approval gates, and exact-payload integrity.
 - **Regression:** API/contract compatibility, shared consumers, configuration, generated artifacts, responsive states, and rollback.
 - **Architecture:** locked decisions, shared substrate versus vertical ownership, uniform consequential-action gate, connector/execution boundaries, and reuse of existing assets.
 - **Quality:** tests assert behavior, dead paths are removed only when safe, and complexity is proportional to the work order.
4. For UI changes, audit the theme when semantic tokens or Light/Dark/System behavior changed. Verify visual claims only when representative states and viewports were actually inspected.
5. Validate findings against current code before reporting them. Do not report style preference as a defect.
6. Run only focused checks needed to confirm a suspected issue or close an evidence gap. Do not repeat broad checks already passed without a reason.
7. Do not edit. Route accepted fixes back through `$implement-story` with a bounded repair scope.

## Output

Lead with the verdict: `pass`, `changes_required`, or `blocked`.

List findings by severity:

- **P0:** unsafe to continue; security, data loss, unauthorized action, or fundamentally broken acceptance.
- **P1:** likely correctness or regression failure that must be repaired before QA.
- **P2:** bounded maintainability or polish issue worth fixing in the current scope.

For every finding include the file and location, evidence, user/system impact, and smallest correct repair. Then report checks consulted or run, unverified states, and the handoff:

- no findings → QA evidence collection, then `$release-readiness`;
- findings → `$implement-story` with the accepted repair list;
- missing authority or product decision → `$shape-work` or the human owner.
