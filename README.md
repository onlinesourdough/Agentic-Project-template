![Solution Template overview](assets/solution-template-overview.png)

# Solution Template

**Solution Template** is a minimal AI-native foundation for building the
smallest useful technical solution.

Use it when an application, service, automation, integration, library, or
system needs its own durable home, ownership, and lifecycle.

AI-native means that humans and agents can understand, change, verify, operate,
and recover the solution safely. Business intent and architecture come before
code and frameworks.

## Workflow

| Step   | Purpose                                                 |
| ------ | ------------------------------------------------------- |
| Spec   | Understand the outcome and choose the smallest solution |
| Build  | Create one complete, testable slice                     |
| Review | Check the result and remove unnecessary complexity      |
| Ship   | Release, verify, and preserve a recovery path           |

Natural language is the interface. The repository instructions make the
workflow repeatable without requiring a specific coding agent or platform.

## Start

1. Create a repository from this template, or open an existing project.
2. Add or link the context that explains the intended outcome.
3. Open the repository in a coding agent that reads `AGENTS.md`.
4. Ask:

> Spec the smallest useful solution for this outcome.

Continue naturally with:

> Build the first slice.

> Review and simplify it.

> Ship it when the evidence passes.

Before Build, make the README specific to the project and link to the canonical
Product Brief, issue, or other context source.

## Solution shapes

| Shape       | Examples                                                          |
| ----------- | ----------------------------------------------------------------- |
| Application | Website, product UI, mobile or desktop app, internal tool, or CLI |
| Service     | API, calculation, model, renderer, or bounded domain capability   |
| Automation  | n8n workflow, scheduled job, or event-driven process              |
| Integration | Webhook, adapter, proxy, bot boundary, or system connection       |
| Library     | Package, SDK, template, shared module, or reusable capability     |
| System      | Infrastructure, architecture, ownership, or operations repository |

Choose the primary responsibility of the repository. Supporting parts may use
other shapes without becoming separate projects.

## Technology and skills

Technology is chosen last. Existing ownership and a working system outrank
every recommendation.

- Prefer **TypeScript** for browser interfaces and ordinary web systems.
- Prefer **Python** for data, scientific, image, quant, and machine-learning
  capabilities.
- Prefer **n8n** or another workflow runtime for visible orchestration.
- Add databases, hosting, queues, containers, and observability only when a
  concrete responsibility needs them.
- Combine Build, Buy, Rent, and Self-host choices per responsibility when that
  creates a smaller and better-owned solution.

See [Technology recommendations](TECHNOLOGY.md) for the full decision guide.
The four included lifecycle skills are the default workflow. Add a specialist
skill only for a concrete project need; `manage-skills` handles that safely.

## Repository map

```text
Solution Template
├── AGENTS.md
├── .agents/skills/
│   ├── spec-solution/SKILL.md
│   ├── build-solution/SKILL.md
│   ├── manage-skills/SKILL.md
│   ├── review-solution/SKILL.md
│   └── ship-solution/SKILL.md
├── TECHNOLOGY.md
├── CLAUDE.md
├── assets/solution-template-overview.png
└── README.md
```

Start with one outcome, one owner, one repository, and one complete slice. Add
another layer only when the solution has a clear responsibility for it.
