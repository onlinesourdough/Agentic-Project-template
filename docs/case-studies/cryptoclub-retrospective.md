# CryptoClub: A Retrospective Multi-Shape System

CryptoClub is a customer platform whose architecture became explicit while the
system was already operating. It is useful evidence for the Solution Template,
but it is not presented as a clean greenfield implementation of the current
AIOS-to-solution method.

## What happened

Development began before Gustav's current AIOS existed. Applications,
automations, agents, data workflows, and small services accumulated as customer
needs became concrete.

The GitHub organization gradually became the shared system landscape.
Repository boundaries made domain ownership clearer, while the infrastructure
repository grew into a lightweight source of truth for cross-system
architecture, deployment, operations, and incidents.

The red thread therefore emerged retrospectively:

- working behavior was preserved
- authoritative owners were identified
- broad repositories were split by responsibility
- consumers stopped implicitly owning upstream data and workflows
- architecture and runbooks documented the system that actually existed

## Shape map

| Responsibility                                     | Solution shape |
| -------------------------------------------------- | -------------- |
| Member home and dashboard                          | Application    |
| Bounded market signal and backtest behavior        | Service        |
| Discord command verification and n8n forwarding    | Integration    |
| n8n workflows and shared market-data pipelines     | Automation     |
| Cross-repository architecture and infrastructure   | System         |
| Existing assistant and specialist-agent experience | Existing owner |

These responsibilities should not be collapsed into one application. They have
different contracts, deployment lifecycles, failure modes, and operators.

## Ownership lessons

### Applications consume; they do not automatically own

The member home can present market intelligence and link to the assistant
without owning the market pipelines, assistant conversations, or automation
runtime.

### Workflow engines orchestrate

n8n remains a valid owner for workflows that are primarily triggers, data
movement, delivery, and schedules. Complex reusable domain rules can move to a
bounded service without moving the entire workflow.

### Services stay bounded

A calculation or validation service owns its contract and deterministic domain
behavior. It does not need to become a general backend or duplicate every
upstream dataset.

### Integrations preserve sources of truth

A Discord proxy owns request verification, command mapping, and delivery to
n8n. Discord and n8n keep their own responsibilities; the proxy does not become
a second workflow engine.

### System repositories can be documentation-first

Cross-stack architecture, repository ownership, deployment topology, decisions,
and incident flow are valuable responsibilities even when the repository owns
no runtime code.

## How the process would work now

With an AIOS available earlier, business outcomes, constraints, workflows, and
existing owners could have been made explicit before each technical
intervention. When a technical change was justified, the Solution Template
could then have selected the smallest matching shape.

That does not mean the resulting platform would be one repository. A good
outcome may still be several small owners connected by explicit contracts.

## Why this is proof, not a rewrite plan

The current system should not be rebuilt to match a template. The retrospective
shows that the template can:

- describe a real mixed system without forcing one stack
- guide incremental boundary improvements
- recognize workflow and documentation repositories as first-class
- keep applications, services, integrations, and operations independently
  understandable
- make future decisions more deliberate without discarding proven work

Public descriptions of the customer system stay at this architectural level.
Credentials, customer data, private configuration, production addresses, and
incident payloads remain with their existing secure owners.
