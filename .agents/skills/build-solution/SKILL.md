---
name: build-solution
description: Build and test one complete vertical slice of a specified technical solution. Use when implementing or changing Application, Service, Automation, Integration, or System behavior after outcome, ownership, boundaries, and acceptance are sufficiently clear.
---

# Build Solution

Build the smallest complete behavior that can be observed through a real
interface.

If the intended behavior or boundary is still consequentially unclear, use
`spec-solution` first.

## Work in vertical slices

For each slice:

1. Name the behavior and the evidence that will prove it.
2. Write one focused failing test for deterministic behavior when practical.
3. Read the expected failure.
4. Implement only enough to pass.
5. Refactor while the test remains green.
6. Run the narrow check, then the repository's full relevant checks.
7. Exercise the real interface when mocks cannot prove the result.

For a bug, reproduce it first and keep the reproduction as a regression test.
Use a validator, build, browser, workflow run, or runtime check when a unit test
would be artificial.

## Write code agents and humans can change

- Keep modules cohesive with small, stable interfaces and meaningful depth.
- Keep route, handler, component, trigger, and framework entrypoints thin.
- Keep domain rules and irreversible policy deterministic.
- Runtime-validate external input and return stable, safe errors.
- Make retried side effects idempotent and bound timeouts, retries, reads, and
  concurrency.
- Reuse existing owners and sources of truth.
- Prefer obvious local code over speculative layers and generic abstractions.
- Add no auth, database, queue, cache, container, dependency, or runtime AI
  without a responsibility that needs it.

For HTTP interfaces, use consistent resources, methods, status codes, error
shapes, pagination, authentication, authorization, and compatibility. For user
interfaces, handle loading, empty, error, keyboard, responsive, and public
metadata behavior when relevant.

## Language baseline

- In TypeScript, keep strict types at boundaries, avoid silent casts, and share
  contracts without sharing framework types.
- In Python, use type hints and validated boundary models; keep framework code
  outside the calculation or domain core.
- Keep substantial Python computation behind a small Service interface instead
  of turning the frontend or workflow into a mixed-language codebase.

## Runtime baseline

Emit structured, redacted logs at meaningful boundaries. Include an execution
or request identifier, outcome, duration, and safe failure information when
useful. Never log secrets or unnecessary private payloads.

Finish with a working repository, the smallest complete slice, updated local
truth, and the exact evidence that proves it.
