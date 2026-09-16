---
name: founder-brief
description: Turn independently reviewed trust findings into a concise, evidence-linked founder brief. Use after a trust posture review and remediation review, for a scheduled founder update or an approval-ready draft; do not introduce unsupported claims, perform remediation, or send the brief without exact-content approval.
---

# Founder brief

Give the founder a decision surface, not a security data dump. Every material sentence must resolve to a reviewed finding or source revision.

## Workflow

1. Accept only independently reviewed findings, source-health results, approved exceptions, and bounded remediation proposals.
2. Lead with what changed, what requires a founder decision, and what is blocked. Separate present posture from trend and forecast.
3. Group the remaining content into healthy controls, material attention items, source gaps, remediation work, and approvals needed.
4. Preserve severity, confidence, owner, due boundary, and citations. Explicitly label stale, contradictory, missing, and unsupported knowledge.
5. Keep technical detail behind concise evidence references. Do not soften a material risk or promote an unreviewed proposal.
6. Produce a draft artifact and its digest. Sending through Slack or another channel requires approval over the exact digest; do not send from this skill.

## Output contract

Return a brief with: executive verdict, changes since the prior review, up to five attention items, source-health exceptions, remediation queue, exact decisions or approvals requested, citations, generated-at time, and content digest. End with `draft_not_sent` unless an independently recorded channel receipt proves the approved digest was sent.
