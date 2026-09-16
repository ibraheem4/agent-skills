---
name: trust-posture-review
description: Assess the current security and compliance posture from authorized identity-provider, cloud, and source-control records. Use for a scheduled or founder-requested trust review, source-health check, control drift assessment, or material finding triage; remain read-only and create proposals rather than remediation.
---

# Trust posture review

Produce a reproducible point-in-time assessment. A material claim without a resolvable source revision is an unsupported claim, not a finding.

## Workflow

1. Fix the review scope, review time, source grants, expected source set, control baseline, and freshness thresholds.
2. Inspect source health before posture. Label each expected source `fresh`, `stale`, `missing`, `revoked`, or `failed`; never treat silence as healthy.
3. Compare current evidence to the authoritative control and decision records. Preserve contradictory evidence and state which authority governs.
4. Record only material findings. For each, include affected boundary, observed state, expected state, evidence revision IDs, freshness, severity, confidence, and why it matters.
5. Hand material findings to `$evidence-investigation`. Do not infer root cause during initial assessment.
6. Separate bounded remediation proposals from actions. Do not change provider state, identity, access, repositories, policies, or evidence.
7. Hand the complete assessment and source-health record to an independent `$remediation-review` owner.

## Output contract

Return:

- review scope and timestamp;
- source-health table with revision identifiers;
- control posture summary;
- material findings with citations, severity, confidence, and lineage;
- stale, missing, contradictory, and unsupported knowledge;
- investigation handoffs and bounded remediation proposals;
- explicit statement that no remediation was performed.

Use `pass`, `attention_required`, or `blocked` as the overall verdict. A missing authoritative source that prevents a material conclusion makes the review `blocked`, not `pass`.
