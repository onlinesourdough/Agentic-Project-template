---
name: review-solution
description: Review code, architecture, contracts, security, documentation, delivery, operations, or overall technical readiness using concrete evidence. Use for pull request review, pre-release checks, adoption audits, handover, Definition of Done, or when deciding whether a solution is actually ready.
---

# Review Solution

Review against the intended outcome and repository responsibility, not an
imaginary ideal architecture.

Read `references/technical-readiness.md` for a project-wide, release, adoption,
or handover audit. For a narrow code review, load only the relevant specialist
skill and readiness rows.

## Inspect

1. Establish the requested behavior, selected shape/profile, scope, and changed
   boundaries.
2. Read the implementation, tests, contracts, workflows, and runtime evidence.
3. Check correctness and failure paths before style.
4. Verify claims by running or reading the authoritative check.
5. Classify every applicable readiness area as **Ready**, **Not applicable**,
   **Missing**, or **Blocked**.

Use severity:

- **P0:** active compromise, data loss, or production outage
- **P1:** likely incorrect, insecure, or unrecoverable behavior
- **P2:** material maintainability, operability, or edge-case gap
- **P3:** useful improvement that does not block the stated outcome

Do not report speculative complexity, personal style preferences, or missing
enterprise machinery as defects. Do report duplicated ownership, unstable
contracts, untested policy, unsafe side effects, invisible failure, and
unproven deployment.

## Return

Lead with actionable findings ordered by severity and exact location. Then
state:

- readiness classification and evidence
- tests or runtime paths checked
- unavailable evidence
- smallest next action
- deployment and recovery status when relevant

If there are no findings, say so and name residual risks or evidence limits.
Fix issues only when the request authorizes changes.
