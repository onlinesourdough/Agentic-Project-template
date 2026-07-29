---
name: operate-solution
description: Design, implement, or audit proportional runtime operations including structured logging, health and readiness, metrics, tracing, performance, alerting, resilience, incidents, replay, recovery, and cost. Use when a deployed solution, service, automation, integration, or workflow must be observable and safely operated.
---

# Operate Solution

Make the critical journey, relevant failure, and recovery visible with the
smallest operational surface that works.

## Observe

1. Define the user- or caller-visible success and failure.
2. Add health or readiness only when a runtime consumer can act on it.
3. Emit structured events to the runtime output stream. Include time, level,
   event, outcome, duration, and request or execution ID when useful.
4. Never log secrets, tokens, full sensitive payloads, or unnecessary personal
   data.
5. Measure traffic, errors, latency, and saturation relevant to the solution;
   add freshness, queue depth, or business completion when those are stronger
   signals.
6. Add tracing only when a multi-hop path cannot be understood from correlated
   logs and metrics.
7. Alert on actionable symptoms with a named owner and runbook. Avoid alerts
   that nobody should act on.

## Resist failure

- Set explicit network timeouts.
- Retry only transient failures, only when the operation is safe or idempotent,
  with a bounded attempt count and backoff.
- Handle duplicate delivery and concurrent work deliberately.
- Add a circuit breaker only for a demonstrated dependency failure mode.
- Support graceful shutdown and interrupted work where the runtime requires it.
- Preserve rollback, replay, reconciliation, backup/restore, disable, or export
  according to the shape.
- Measure before adding caching, concurrency, replicas, or performance
  infrastructure.

## Workflow runtimes

For n8n or another workflow engine, identify trigger, credential owner,
execution history, error workflow or channel, retry behavior, replay procedure,
duplicate handling, published version, activation owner, and kill switch.
Version a sanitized source or export while keeping runtime credentials and
production payloads with the platform.

## Verify

Exercise the real critical journey and one relevant failure. Confirm the signal
reaches the intended operator and the recovery procedure works. Static or
non-runtime artifacts may correctly mark most operations Not applicable.

Primary references:

- [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)
- [The Twelve-Factor App: logs](https://12factor.net/logs)
- [The Twelve-Factor App: disposability](https://12factor.net/disposability)
