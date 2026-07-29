---
name: deliver-solution
description: Design, prepare, review, or perform CI, build, release, migration, deployment, activation, rollback, and publication for a technical solution. Use when changing GitHub Actions, environments, dependencies, artifacts, semantic versions, database migrations, cloud delivery, workflow activation, or production recovery.
---

# Deliver Solution

Separate verification, artifact creation, release, deployment, and activation.
A green build proves none of the later stages.

## Establish the release unit

Identify:

- exact commit and immutable artifact
- target platform and environment
- platform and operational owners
- checks, review, and deployment authority
- configuration and secret ownership
- migration order and compatibility
- post-deploy verification
- rollback, forward recovery, replay, disable, or stop path

Use the repository's current branch model. Do not impose Git Flow. Keep changes
small and use semantic versions only for a real public compatibility promise.

## CI

- Install from the lockfile and run the repository's real format, lint, type,
  test, contract, build, and workflow checks.
- Declare least `GITHUB_TOKEN` permissions and timeouts.
- Do not expose secrets to untrusted pull request code.
- Pin external Actions to reviewed full commit SHAs with the readable release
  version in a comment.
- Prefer short-lived workload identity or OIDC to long-lived cloud credentials
  when the platform supports it.
- Preserve useful failure artifacts without exposing sensitive data.

## Deploy

1. Keep build, release configuration, and runtime execution distinct.
2. Use the selected Application profile workflow only when it matches the real
   platform.
3. For durable state, use compatible expand/contract changes, backup or export,
   and a tested recovery order.
4. Publish but do not activate an Automation when the runtime supports separate
   steps.
5. Require explicit authority before a production or consequential external
   action.
6. Read the deployment result, then verify health, critical journey, assets,
   contract, failure visibility, and expected version in the target.
7. Stop or recover when the gate fails.

Non-Application shapes use their actual runtime or publication path; never add
a universal container or cloud workflow to make the repository look complete.

Primary references:

- [GitHub Actions secure use](https://docs.github.com/en/actions/reference/security/secure-use)
- [The Twelve-Factor App: build, release, run](https://12factor.net/build-release-run)
