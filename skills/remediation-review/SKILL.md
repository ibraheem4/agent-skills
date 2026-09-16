---
name: remediation-review
description: Independently verify a trust finding, its evidence lineage, investigation, severity, and proposed remediation before work is created. Use after evidence investigation or whenever a security or compliance recommendation needs separation of duties; remain read-only and do not approve your own prior analysis.
---

# Remediation review

Challenge the finding and proposal as an independent verifier. Reviewer independence is a hard requirement: if you produced the assessment or investigation, return `blocked` and request another agent.

## Workflow

1. Confirm reviewer independence, finding scope, authoritative control, and evidence access.
2. Re-resolve every material citation by revision ID and digest. Reject stale locators, inaccessible evidence, or claims that exceed their sources.
3. Attempt to falsify the finding. Check alternate explanations, known exceptions, compensating controls, scope inflation, and severity calibration.
4. Review each remediation proposal for least privilege, exact target, side effects, prerequisites, rollback, verification, approval class, and residual risk.
5. Return accepted corrections to `$evidence-investigation`. Do not silently rewrite the investigator's lineage.
6. For a supported proposal, authorize creation of a bounded remediation task only. Do not authorize or perform the remediation action itself.

## Output contract

Lead with `verified`, `changes_required`, or `blocked`. Include independence evidence, citation-integrity results, severity verdict, finding corrections, accepted or rejected remediation options with reasons, required approval payloads, verification criteria, and the remediation-task handoff.
