# Integration Shape

Use this shape for a webhook receiver, protocol adapter, proxy, bot boundary, or
translation layer between authoritative systems.

## Ownership map

Name:

- upstream owner
- downstream owner
- authentication and credential owner
- source of truth
- mapping and compatibility owner
- incident owner

An integration transports and translates responsibility. It does not become a
new system of record.

## Boundary behavior

Validate and test:

- signatures, tokens, or service identity
- accepted events or commands
- schema and semantic mapping
- timeouts, rate limits, and retries
- duplicate and out-of-order delivery
- acknowledgement behavior
- partial failure and reconciliation

Return stable errors without exposing credentials or downstream internals.

## Operations

Expose health that distinguishes runtime availability from downstream
configuration. Redact payloads in logs, make delivery failures observable, and
document command registration, secret rotation, replay, and rollback where
relevant.

## Delivery gate

- upstream and downstream contracts are explicit
- source-of-truth ownership is unchanged
- authentication and mapping have tests
- retry, duplicate, timeout, and downstream failure are verified
- operators can identify and replay or reconcile failed work
