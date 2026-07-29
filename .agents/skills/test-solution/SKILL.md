---
name: test-solution
description: Test-drive deterministic behavior and design risk-based verification across unit, contract, integration, end-to-end, workflow, and real-runtime boundaries. Use when adding behavior, fixing a bug, changing a contract, refactoring, or deciding what evidence can actually prove a solution works.
---

# Test Solution

Use tests to drive behavior and expose risk, not to chase coverage.

## Select evidence

1. State the behavior and failure being protected.
2. List the smallest meaningful cases before coding.
3. Choose the lowest test boundary that proves each case without hiding the
   real risk.
4. Identify what mocks cannot prove and reserve a real integration or runtime
   check for it.

## Red–Green–Refactor

For deterministic behavior:

1. **Red:** add one focused test and read the expected failure.
2. **Green:** implement the minimum behavior that passes.
3. **Refactor:** improve names and structure while keeping the suite green.
4. Repeat with the next meaningful case.

For a bug, reproduce it first and preserve the reproduction as a regression
test. For risky legacy refactoring, add characterization tests before changing
behavior.

TDD is not mandatory for prose, generated files, exploratory spikes, or
configuration that is better proven by a validator or real runtime. State the
alternative evidence instead of creating a fake unit test.

## Match tests to boundaries

- **Unit:** pure policy, calculations, parsing, state transitions.
- **Contract:** schemas, API errors, compatibility, generated clients.
- **Integration:** database, filesystem, vendor adapter, queue, framework
  wiring.
- **End-to-end:** critical user or caller journey only.
- **Automation:** step transforms, duplicate/retry behavior, safe end-to-end
  execution, replay, and error workflow.
- **Deployment:** artifact, environment, health, smoke journey, and recovery.

Test success and relevant denial, invalid input, timeout, partial failure,
concurrency, duplicates, and recovery. Do not mock code you own merely to make a
test easier. Do not claim a mocked database, browser, workflow, or cloud
deployment proves the real boundary.

## Finish

Run the repository's actual format, lint, type, test, build, contract, and
workflow checks that the change can affect. Read every result. Report skipped
evidence and why.

Primary reference: [Test Driven Development](https://martinfowler.com/bliki/TestDrivenDevelopment.html).
