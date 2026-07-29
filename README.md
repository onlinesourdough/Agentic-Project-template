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

## Start

1. Create a private repository from this template.
2. Open it in Codex or another coding agent that reads `AGENTS.md`.
3. Describe the result you want and say:

> Help me spec the smallest solution that can create this result.

The agent asks one question at a time when something consequential is unclear.
When the spec is sufficient, continue naturally:

> Build the first slice.

> Review and simplify the change.

> Ship it when the evidence passes.

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
