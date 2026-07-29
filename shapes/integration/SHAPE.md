# Integration

A webhook, adapter, proxy, bot boundary, or other connection between
authoritative systems.

## Owns

Own translation and delivery, not a new system of record. Name the upstream,
downstream, credentials, mapping, compatibility, and incident owners.

## Boundaries

- Validate service identity, signatures, accepted events, and commands.
- Test schema and semantic mapping.
- Define timeouts, rate limits, retries, duplicates, ordering, and
  acknowledgement.
- Make partial failure and reconciliation observable.
- Redact payloads and downstream internals from logs and errors.

## Deployment

Deploy the boundary and register webhooks, commands, callbacks, or credentials
as explicit external configuration. Verify both ends, document secret rotation,
and keep a way to pause delivery and reconcile messages after recovery.

## Evidence

- auth and mapping tests pass
- timeout, retry, duplicate, and downstream failure are exercised
- failed work can be identified, replayed, or reconciled
- source-of-truth ownership remains unchanged
