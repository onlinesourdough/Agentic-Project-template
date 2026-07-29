---
name: implement-slice
description: Implement one minimal, complete vertical slice or focused refactor while preserving ownership, contracts, framework boundaries, and a working repository. Use for multi-file code or configuration changes after the intended behavior and boundary are sufficiently clear.
---

# Implement Slice

Build the smallest complete path that produces observable value.

## Prepare

1. Read repository instructions, shape, profile, relevant architecture, and
   current implementation.
2. State the behavior, boundary, acceptance evidence, and explicit non-goals.
3. Use `test-solution` before or alongside implementation when deterministic
   behavior changes.
4. Split broad work by vertical outcome or highest technical risk, not by
   framework layer.

## Implement

For each increment:

1. Change one coherent behavior.
2. Keep route, handler, trigger, or framework entrypoints thin.
3. Runtime-validate external input and preserve stable output contracts.
4. Keep domain rules independent of framework and vendor types.
5. Keep side effects explicit, bounded, and idempotent when retried.
6. Reuse existing owners, utilities, and sources of truth.
7. Run the narrowest relevant check, then the repository's real gate before
   completion.

Prefer obvious code over speculative abstraction. Three local repetitions may
be cheaper than a premature framework. Do not add a database, queue, container,
cache, service, design pattern, or dependency for a hypothetical future.

## Shape checks

- **Application:** complete one real user journey; include loading, empty,
  error, keyboard, responsive, and public metadata behavior when relevant.
- **Service:** complete one caller contract with health and bounded dependency
  failure; no UI or persistence by default.
- **Automation:** keep trigger and orchestration visible; version a sanitized
  workflow source or export; move only substantial reusable logic into code.
- **Integration:** preserve upstream and downstream ownership; expose mapping,
  acknowledgement, timeout, and reconciliation.
- **System:** change technical truth or infrastructure only; do not add fake
  runtime code.

## Finish

Confirm the slice works through the real boundary, relevant failure is visible,
recovery remains possible, and unrelated files were not “cleaned up.” Route
stale technical truth to `document-solution` and release work to
`deliver-solution`.
