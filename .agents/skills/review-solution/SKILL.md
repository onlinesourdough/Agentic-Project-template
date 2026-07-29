---
name: review-solution
description: Review and simplify a technical change against its intended outcome using concrete evidence. Use before merge or shipping, for pull requests and code review, or when checking correctness, test quality, architecture, security, operability, scope, and unnecessary complexity.
---

# Review Solution

Review the actual change against the intended behavior and repository
responsibility, not an imaginary ideal architecture.

## Inspect

1. Establish the comparison point and intended outcome.
2. Read the diff, relevant code, project-local agents and skills, workflow
   exports, interfaces, configuration, infrastructure, contracts, architecture,
   runbooks, tests, and runtime evidence.
3. Run or inspect the checks that can actually prove the change.
4. Review correctness and failure paths before style.

Review these gates:

- **Intent:** the change implements the agreed outcome without scope creep.
- **Correctness:** success, denial, invalid input, partial failure, duplicates,
  concurrency, and recovery behave as relevant.
- **Evidence:** tests observe public behavior; mocked or static evidence is not
  claimed as runtime proof.
- **Simplicity:** names are clear, modules are cohesive, interfaces are small,
  and abstractions earn their cost.
- **Ownership:** responsibilities, data authority, and framework boundaries are
  not duplicated or blurred; project truth has one canonical owner.
- **Lifecycle:** the repository still merits independent ownership, and it does
  not duplicate a smaller existing owner without justification.
- **Security:** trust, authorization, secrets, private data, dependencies, and
  external side effects are handled proportionally.
- **Operation:** important failure is visible and rollback, replay, disable,
  restore, rebuild, or reconciliation is real and has been exercised when the
  risk requires it.

## Simplify the changed area

Preserve behavior while removing unnecessary indirection, speculative
generality, duplicate branches, pass-through wrappers, dead code, and comments
that restate the code. Prefer fewer concepts, not merely fewer lines.

Stay inside the changed responsibility. Ask before deleting public interfaces,
data, compatibility behavior, or code whose ownership is uncertain.

## Return

Lead with findings by severity and exact location:

- **Critical:** likely wrong, insecure, destructive, or unrecoverable.
- **Required:** material quality, boundary, test, or operational gap.
- **Improvement:** worthwhile simplification or maintainability improvement.

End with **PASS** or **FAIL**, checks performed, evidence that was unavailable,
and the smallest next action. A Critical or Required finding fails the gate.
Fix findings only when the request authorizes changes.
