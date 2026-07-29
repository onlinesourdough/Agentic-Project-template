# Automation

A triggered or scheduled workflow that moves work through explicit steps.

## Owns

Document the trigger, input, ordered steps, output, system owner for each step,
and which decisions are deterministic or AI-driven. Keep complex reusable
domain logic in a Service rather than the workflow engine.

## Boundaries

- Define duplicate handling, idempotency, retry, backoff, and timeouts.
- Provide replay or backfill, partial-failure handling, and a kill switch.
- Name the error channel, human review points, and operational owner.
- Keep a sanitized, versioned workflow source or export.
- Keep credentials and production payloads in their runtime owners.
- Let n8n or the selected workflow runtime own orchestration. Extract a small
  Service only when logic needs stronger tests, reuse, performance, or
  independent deployment.

An AIOS routine in which an agent reasons with business context and skills
remains AIOS work, even when Codex Automations schedules it. Use this shape
when a separate technical workflow, scheduled program, or event-driven
artifact must be built, versioned, activated, and operated.

## Deployment

Treat publish and activation as separate actions when the workflow platform
allows it. Record the version or export mapped to production, test with safe
data, verify credentials and error delivery, then activate with an immediate
disable path.

## Evidence

- one safe end-to-end run succeeds
- duplicate, retry, and failure paths are exercised
- production identity is traceable to the versioned source
- replay and disable procedures work
