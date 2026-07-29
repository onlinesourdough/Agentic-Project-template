---
name: develop-solution
description: Build, change, check, deploy, recover, or maintain the technical solution in the current repository. Use when a user asks to set up or architect a solution, implement a slice, review technical readiness, prepare or perform a deployment, diagnose operational gaps, or simplify an existing application, service, automation, integration, or system.
---

# Develop Solution

Operate this repository as a complete technical project. Do not require AIOS,
a particular planning system, a specific harness, or runtime AI.

## Start

1. Read the repository's existing instructions and project context.
2. Read `docs/solution-template/SHAPE.md`.
3. Read `docs/solution-template/PROFILE.md` when present.
4. Inspect `.solution-template.json`, manifests, commands, workflows, and the
   implementation relevant to the request.
5. Identify the requested outcome, current technical state, and evidence of
   completion.

Use context from any trustworthy source. Link to upstream business context when
useful; do not copy it into the project without a project-specific reason. If
one missing input would materially change the technical solution, ask one
precise question.

## Choose the workflow

Choose without presenting a menu unless the request is genuinely ambiguous:

- **Set up** when technical ownership, stack, boundaries, or commands are not
  yet established.
- **Build** when implementing or changing a defined slice.
- **Check** when auditing readiness, architecture, security, operations, or an
  existing solution.
- **Deploy** when preparing, releasing, verifying, rolling back, replaying, or
  disabling a change.

For Set up, Check, or Deploy, read
`references/technical-readiness.md`. For Build, read only the sections needed
by the current change.

## Set up

1. Confirm the selected shape and optional Application profile still fit.
2. Identify what this repository owns, consumes, and does not own.
3. Choose the current official scaffold, runtime, and dependencies only after
   responsibilities are clear.
4. Establish the smallest architecture, commands, tests, environment model,
   deployment path, observability, and recovery needed now.
5. Record project-specific technical truth in the shortest existing canonical
   artifact. Create a README section, ADR, contract, or runbook only when no
   suitable owner exists.
6. Classify every readiness area as **Ready**, **Not applicable**, **Missing**,
   or **Blocked**. Give a reason and evidence for Ready or Not applicable.

Do not create placeholder layers, fake workflows, or empty documentation merely
to complete the matrix.

## Build

1. Reuse existing owners, contracts, and working systems.
2. Define the smallest boundary or behavior under change.
3. Add or update a failing test first for deterministic behavior when
   practical.
4. Implement only the required capability and keep framework code at the edge.
5. Validate success, relevant failure paths, authorization, and recovery.
6. Run the repository's real checks and exercise the real runtime when mocks
   cannot prove the outcome.
7. Update only technical documentation made stale by the change.

## Check

1. Evaluate all areas in `references/technical-readiness.md`.
2. Inspect evidence rather than inferring readiness from file names.
3. Fix safe, local, unambiguous technical gaps when the request authorizes
   changes.
4. Do not invent owners, authority, business requirements, credentials, or
   production state.
5. Return the readiness classification, evidence, material gaps, and smallest
   next action.

## Deploy

1. Identify the exact commit, artifact, environment, platform owner, and
   operational owner.
2. Confirm checks, configuration, secrets, migrations, backups, and rollback or
   disable behavior.
3. Use the selected profile workflow when it fits. Otherwise implement or
   follow the target runtime's official deployment path; never fabricate a
   universal deploy.
4. Require explicit authority for production release or another consequential
   external action.
5. Read the deployment result, verify health and the critical journey, and
   confirm failure visibility.
6. Roll back, replay, disable, or stop when the release gate fails.

Never claim a deployment succeeded from a green build alone.

## Return

Report:

- selected workflow, shape, profile, and slice
- changed technical responsibilities and owners
- evidence from checks and runtime verification
- deployment and recovery status when relevant
- missing input or remaining risk

Keep the response proportional to the change. Do not turn every task into a
full architecture report.
