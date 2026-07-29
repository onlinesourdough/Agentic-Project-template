---
name: ship-solution
description: Prepare, release, deploy, activate, and verify a technical solution with a real recovery path. Use after review when publishing an Application, Service, Automation, Integration, or System change, or when changing CI, environments, secrets, migrations, deployment, rollback, replay, or operational ownership.
---

# Ship Solution

Ship only reviewed work. A green build is not a deployment result.

## Establish the release unit

Identify:

- exact commit and immutable artifact
- target environment and deployment owner
- required checks and authority
- configuration and secret ownership
- migration and compatibility order
- critical journey and failure signal
- rollback, replay, disable, restore, or reconciliation path
- operational owner

Ask before a production release, external publication, workflow activation,
destructive migration, or other consequential action unless the user already
gave specific authority.

## Keep delivery proportional

- Install from the lockfile and run the repository's real checks.
- Give CI and runtime credentials least privilege.
- Keep secrets out of code, logs, artifacts, and untrusted change execution.
- Pin third-party workflow actions to reviewed immutable versions.
- Add environments, artifacts, migrations, and automation only when the
  solution actually has them.

## Release and verify

1. Build the exact artifact from the reviewed commit.
2. Apply configuration and compatible state changes in the documented order.
3. Deploy or publish without activating when the platform allows separation.
4. Read the actual platform result.
5. Verify expected version, health, critical journey, interfaces, assets, logs,
   failure visibility, and recovery in the target environment.
6. Activate only after the gate passes.
7. Stop, disable, roll back, or recover when verification fails.

Shape-specific proof:

- **Application:** real browser journey, assets, server boundaries, and
  rollback.
- **Service:** health, caller contract, dependency failure, and previous
  artifact or forward recovery.
- **Automation:** safe run, published version, credentials, retries, replay,
  error channel, activation owner, and kill switch.
- **Integration:** both ends, delivery acknowledgement, timeout, retry, and
  reconciliation.
- **System:** reviewed technical truth, valid links, ownership, and incident
  route; no fake runtime deployment.

Report the commit, artifact, environment, platform result, smoke evidence,
recovery status, and any remaining operational risk.
