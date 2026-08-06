# Spec Solution acceptance cases

These cases exercise the public instruction contract. They are not templates
for rewriting user source material; each expected response contains only the
evidence and readiness output needed for that input.

## Rough idea — BLOCKED

**Input:** “Make it easier for customers to understand their usage.” Existing
product sources show several customer roles but do not identify which role owns
the usage problem.

**Expected audit:**

- The rough idea is accepted without requesting a formal brief.
- The intended direction is RESOLVED from the request.
- The served user is MISSING and materially affects the shape of the result.
- The response asks one question only, with the best guess: “Which customer
  role should experience the first changed behavior? My best guess is existing
  account administrators because they already own usage review; the answer
  determines the relevant workflow and evidence.”
- The only gate is BLOCKED, naming the missing owner decision. It does not
  choose a stack or invent a repository.

## Developed brief — REVISE

**Input:** A brief resolves every required dimension, including the measurement
and recovery owners, but links `runbooks/deploy.md`. Repository history and the
README show that `runbooks/delivery.md` is now the canonical deployment and
recovery source.

**Expected audit:**

- The developed brief remains canonical and is not rewritten.
- Its supplied dimensions are RESOLVED and cited; the stale link is
  CONFLICTING with current repository truth.
- The only gate is REVISE with the minimal target patch:
  `Replace runbooks/deploy.md with runbooks/delivery.md in Sources and
  Recovery.`
- No unrelated architecture or product additions are returned.

## Near-complete specification — READY

**Input:** A specification resolves all required dimensions and links its
product source, API contract, data owner, deployment runbook, and recovery
rehearsal. One internal module name is absent but can be chosen reversibly by
the implementer.

**Expected audit:**

- Existing text is checked against the linked repository truth, not restated.
- The module name is INFERRED and labeled as low-risk technical discretion.
- The only gate is READY with a compact technical Build contract that cites the
  existing specification and lists ordered results with verification points.

## Existing-system change request — READY

**Input:** “Add idempotency to the existing payment webhook.” The repository
defines the caller contract, data authority, duplicate behavior, trust
boundary, deployment owner, alerts, rollback, and tests. The issue defines the
new replay-safe acceptance case and explicitly excludes provider migration.

**Expected audit:**

- The request is treated as a delta; the current system is not specified
  again.
- Repository facts are RESOLVED by inspecting the implementation, contract,
  tests, and runbook.
- The only gate is READY. The Build contract names the idempotency behavior,
  compatibility constraint, duplicate and recovery proof, non-goal, and
  unchanged Ship scope.

## AIOS-originated work — READY

**Input:** An AIOS lead links canonical decisions for intent, outcome, scope,
proof, measurement owner, and authority. The target repository resolves its
interfaces, data authority, trust boundary, operations, recovery, and local
Ship scope.

**Expected audit:**

- Upstream business decisions remain RESOLVED from the AIOS source and are not
  reopened or copied into a replacement brief.
- The worker audits only project-local technical truth and uses the existing
  bounded goal.
- The only gate is READY with a compact project-local Build contract. AIOS is
  not introduced as a runtime dependency.

## FastAPI profile is not a default

**Non-fit input:** A conventional browser CRUD change can remain in an existing
TypeScript system; it has no Python domain responsibility, new database
authority, or owned container operation.

**Expected:** The advanced-full-stack-python profile is not selected. Existing
ownership outranks the profile, and no authentication, PostgreSQL, Docker, or
Python layer is added because a template contains it.

**Fit input:** A new independently operated product has Python-owned specialist
domain logic, a justified React UI, PostgreSQL data authority, required
authentication and server authorization, a Docker delivery boundary, and a
named owner for deployment, secrets, monitoring, backup, restore, and updates.

**Expected:** The profile may be cited as an optional sourced reference after
all fit conditions are RESOLVED. The Build contract still names each added
responsibility, operator burden, verification, update path, and exit path; it
does not copy the upstream template into this repository.
