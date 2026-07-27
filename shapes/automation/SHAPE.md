# Automation Shape

Use this shape for an n8n workflow, scheduled job, event-driven process, or
other orchestration whose main responsibility is moving work between steps.

## Process contract

Document:

- trigger and schedule
- accepted input
- ordered steps and decision points
- output and delivery target
- system owner for every step
- expected KPI, latency, and freshness
- deterministic versus AI-driven steps

Keep complex reusable domain logic in a bounded service. Keep orchestration in
the workflow engine.

## Reliability

Define:

- idempotency and duplicate handling
- retry ownership and backoff
- replay or backfill procedure
- partial failure and compensation
- timeout behavior
- error channel and incident owner
- human review points
- kill switch

Never hide paid access, security policy, or irreversible decisions inside an
unreviewed model prompt.

## Source control

Keep a sanitized, versioned source or export when the workflow engine is not
itself the durable review history. Separate raw backups from curated domain
documentation. Never commit credentials, execution payloads, or private
production exports.

## Delivery gate

- one end-to-end run succeeds with safe test data
- duplicate, retry, and failure paths are exercised
- credentials remain in the runtime secret store
- source/export and production workflow identity are traceable
- replay, disable, and incident procedures are documented
- ongoing time or cost savings are measurable
