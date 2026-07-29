![Solution Template overview](assets/solution-template-overview.png)

# Solution Template

**Solution Template** is a minimal AI-native foundation for turning a real
problem into the smallest useful technical solution.

It gives a coding agent one simple workflow:

| Step   | Purpose                                                                         |
| ------ | ------------------------------------------------------------------------------- |
| Spec   | Understand the outcome, choose the solution shape, and plan the smallest slices |
| Build  | Implement and test one complete vertical slice at a time                        |
| Review | Check the result against intent and simplify the changed area                   |
| Ship   | Release, verify, and preserve a real recovery path                              |

Natural language is the interface. The skills make the process repeatable
without forcing a framework, platform, or large software methodology.

Use the template when the result needs an independent lifecycle: it must be
possible to understand, develop, operate, access, or hand over the solution
without the original owner's workspace. A schedule, credential, agent, growing
file count, or internal versus external audience does not decide that boundary.

## Start

1. Bring the canonical context: a Product Brief, issue, existing README,
   architecture note, customer source, or the durable decisions from a
   conversation.
2. Ask the agent to confirm that an independent repository is justified. If an
   existing process, tool, or workspace should own the capability, stop before
   creating a repository unless you explicitly override the recommendation.
3. Create a private repository from this template.
4. Open it in Codex or another coding agent that reads `AGENTS.md`.
5. Describe the result you want and say:

> Help me spec the smallest solution that can create this result.

The agent asks one question at a time when something consequential is unclear.
When the spec is sufficient, continue naturally:

> Build the first slice.

> Review and simplify the change.

> Ship it when the evidence passes.

Before Build begins, replace this guide with a project-specific README. Link to
the canonical context instead of copying it. Record the project's outcome,
status and current slice, ownership and boundaries, shape and architecture,
dependencies, working commands, delivery path, operation, and recovery as those
facts become known.

## Solution shapes

| Shape       | Examples                                                                    |
| ----------- | --------------------------------------------------------------------------- |
| Application | Landing page, content library, internal tool, portal, or full-stack product |
| Service     | API, calculation, image renderer, algorithm, or bounded capability          |
| Automation  | n8n workflow, scheduled job, or event-driven process                        |
| Integration | Webhook, adapter, proxy, bot boundary, or system connection                 |
| System      | Architecture, infrastructure, ownership, and operational repository         |

The shape describes what the repository owns. It does not prescribe its size
or vendor.

## Stack defaults

Use **React, TypeScript, and TanStack** for Applications. Prefer TypeScript
end-to-end when one language keeps the product simpler.

Use **Python** for a separate Service when its core capability benefits from
Python's quant, data, image, scientific, or machine-learning ecosystem. A
heatmap renderer or trading algorithm can therefore be Python without making
Python the default backend for every Application.

Use **n8n** or another workflow runtime for orchestration. Move logic into a
Service only when it needs stronger tests, reuse, performance, or independent
operation.

Existing ownership and a working system outrank every default.

## Repository map

```text
Solution Template
├── AGENTS.md
├── .agents/skills/
│   ├── spec-solution/SKILL.md
│   ├── build-solution/SKILL.md
│   ├── review-solution/SKILL.md
│   └── ship-solution/SKILL.md
├── CLAUDE.md
├── assets/solution-template-overview.png
└── README.md
```

`AGENTS.md` contains the stable engineering rules. Each skill is loaded only
when its part of the workflow is relevant.

## Keep it small

Start with the outcome, one owner, one repository, one deployable unit, and one
vertical slice. Add auth, data, queues, billing, containers, runtime AI, or
additional services only when the solution has a concrete responsibility for
them.

A delivered artifact is not automatically production-ready. Delivery,
recovery, and outcome are separate gates: the artifact can be deployed while
the business or operational outcome remains pending.
