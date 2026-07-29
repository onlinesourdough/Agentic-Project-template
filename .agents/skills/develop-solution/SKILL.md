---
name: develop-solution
description: Route broad software work through the smallest relevant project skills. Use when setting up, building, changing, checking, deploying, recovering, or maintaining an Application, Service, Automation, Integration, or System and the task spans more than one specialist area.
---

# Develop Solution

Operate this repository as a self-contained technical project. AIOS, a specific
agent harness, runtime AI, and any particular framework are optional.

## Start

1. Read repository instructions and the existing project context.
2. Read `docs/solution-template/SHAPE.md` and, for an Application,
   `docs/solution-template/PROFILE.md`.
3. Inspect `.solution-template.json`, manifests, commands, workflows, and the
   implementation relevant to the request.
4. Identify the smallest skill set that can complete the requested outcome.

Do not load every skill for every task.

## Route

| Need                                                                      | Skill                |
| ------------------------------------------------------------------------- | -------------------- |
| Missing intent, scope, shape, owner, or acceptance                        | `clarify-solution`   |
| Boundaries, stack, data, API, integration, or architecture                | `architect-solution` |
| One complete code or configuration increment                              | `implement-slice`    |
| TDD, regression, contract, integration, or runtime tests                  | `test-solution`      |
| Trust, identity, authorization, secrets, privacy, or supply chain         | `secure-solution`    |
| README, ADR, OpenAPI, diagram, runbook, or handover truth                 | `document-solution`  |
| CI, release, migration, deployment, activation, or rollback               | `deliver-solution`   |
| Logging, health, metrics, performance, resilience, incidents, or recovery | `operate-solution`   |
| Code review, technical readiness, or completion evidence                  | `review-solution`    |

Invoke a specialist directly when the task is already narrow. For a larger
slice, use this default order and skip irrelevant steps:

```text
Clarify → Architect → Test + Implement → Secure/Document → Review
                                                ↓
                                      Deliver → Operate
```

`Test + Implement` is a short Red–Green–Refactor loop, not two separate project
phases. Delivery and operations are included only when the request or current
risk reaches them.

## Keep the route small

- Do not run clarification when the outcome and technical boundary are already
  explicit.
- Do not produce an architecture report for a local mechanical change.
- Do not add auth, persistence, containers, queues, observability platforms, or
  runtime AI without a demonstrated responsibility.
- Do not require a task document, branch model, ceremony, or artifact merely
  because a skill mentions it.
- Ask one precise question when one missing decision would materially change
  the result.

## Return

Report the selected shape, profile, slice, skills used, changed responsibilities,
verification evidence, and any remaining risk. Never claim deployment or
runtime success from build output alone.
