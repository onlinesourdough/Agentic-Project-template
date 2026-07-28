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
TypeScript is not required.

## Evidence

- contract and deterministic behavior tests pass
- auth, invalid input, timeout, retry, and dependency failure are exercised
- deployment and rollback can be performed independently
- logs are structured and redacted
