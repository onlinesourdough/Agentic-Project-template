# Service

A bounded API, worker, calculation, or domain capability without a primary
human-facing interface.

## Owns

State one domain responsibility and the stable contract it exposes. Keep
upstream data, caller workflows, and infrastructure with their existing owners.

## Boundaries

- Validate inputs, outputs, identity, authorization, and error shapes.
- Keep domain logic independent of HTTP, queues, functions, and frameworks.
- Define timeout, resource, retry, idempotency, and concurrency behavior.
- Add persistence only when the service owns durable state.
- Make health, configuration failure, and dependency failure observable.

Use the language and current official scaffold that fit the responsibility.
Prefer TypeScript for web contracts and integrations when its ecosystem fits.
Prefer Python for data, scientific, image, ML, or existing Python workloads.
Existing ownership and operator capability outrank either default.

## Deployment

Use the runtime's official build and deployment path. Keep environments and
configuration explicit, validate configuration at startup, deploy
independently, verify readiness and contracts, and retain the previous
deployable artifact or another proven rollback path.

## Evidence

- contract and deterministic behavior tests pass
- auth, invalid input, timeout, retry, and dependency failure are exercised
- deployment and rollback can be performed independently
- logs are structured and redacted
