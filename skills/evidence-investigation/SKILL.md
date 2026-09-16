---
name: evidence-investigation
description: Investigate one material security or compliance finding using authorized, read-only evidence and permission-filtered company knowledge. Use after a trust posture assessment identifies a finding that needs cause, blast-radius, confidence, contradiction, or remediation analysis; do not mutate a provider or close the finding.
---

# Evidence investigation

Determine what the evidence supports, what it does not support, and the smallest safe next move. Treat every source as scoped, revisioned, and potentially stale.

## Workflow

1. Accept one bounded finding with its evidence lineage, affected systems, severity, and open questions. Reject an unscoped request.
2. Confirm the active principal and source grants before retrieval. Authorization happens before ranking; never use inaccessible snippets as leads.
3. Form competing hypotheses. Gather the smallest read-only evidence set that can distinguish them, recording source revision, collection time, freshness, and locator.
4. Reconcile timestamps, identities, configuration state, audit events, control text, and known exceptions. Preserve contradictions instead of averaging them away.
5. State the most supported cause, affected boundary, blast radius, confidence, and remaining uncertainty. Distinguish observation from inference.
6. Propose bounded remediation options with expected outcome, prerequisites, risk, rollback, verification, and whether human approval is required.
7. Hand the investigation to an independent `$remediation-review`. Do not perform remediation or mark the finding resolved.

## Output contract

Return the finding ID, hypotheses considered, cited evidence revisions, chronology, supported cause, scope, confidence, contradictions, unknowns, remediation options, required approvals, and independent-review handoff. Use `supported`, `inconclusive`, or `blocked` as the investigation verdict.
