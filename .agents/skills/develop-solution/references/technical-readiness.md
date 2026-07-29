# Technical Readiness

Use this reference to set up, audit, deploy, or hand over a solution. It is a
decision and evidence map, not a required document template.

## Inputs supplied to the project

The template does not invent:

- the intended outcome and acceptance evidence
- the user, workflow, or system being changed
- business rules, constraints, deadlines, and risk tolerance
- existing owners, access, authority, and sources of truth
- legal, privacy, compliance, or commercial requirements

These inputs may come directly from the user, an AIOS, an issue, a meeting, a
README, or another trustworthy source. Ask for only the missing decision that
would materially change the technical result.

## Roles

One person may hold several roles, but the responsibility must be explicit.

| Role                 | Owns                                                    |
| -------------------- | ------------------------------------------------------- |
| Outcome owner        | Intended result, acceptance, constraints, and authority |
| Solution owner       | Technical scope, boundaries, decisions, and tradeoffs   |
| Implementation owner | Code, configuration, tests, and change quality          |
| Platform owner       | Runtime, environments, access, secrets, and deployment  |
| Operational owner    | Health, incidents, recovery, cost, and handover         |

The coding agent assists these owners. It does not become the accountable owner
or grant itself authority.

## Readiness areas

Classify every area as **Ready**, **Not applicable**, **Missing**, or
**Blocked**. Ready requires observable evidence. Not applicable requires a
reason tied to the selected shape and slice.

| Area                 | Evidence                                                                   |
| -------------------- | -------------------------------------------------------------------------- |
| Responsibility       | What the repository owns, consumes, and does not own                       |
| Shape and profile    | One fitting shape and, for an Application, one profile                     |
| Runtime and stack    | Current official scaffold, versions, manifests, and rationale              |
| Architecture         | Clear modules, entrypoints, boundaries, and dependency direction           |
| Contracts and data   | Validated inputs/outputs, sources of truth, schemas, migrations            |
| Identity and trust   | Actor, caller, authorization, tenant scope, approvals                      |
| Security and privacy | Threats, secrets, sensitive data, dependency and access controls           |
| AI and autonomy      | Deterministic boundaries, context, tools, evaluations, human control       |
| Quality              | Formatting, lint, types, tests, contracts, and real-runtime acceptance     |
| Delivery             | Review path, CI, artifact identity, compatibility, and change evidence     |
| Deployment           | Environments, configuration, secrets, migrations, release and verification |
| Observability        | Health, logs, errors, metrics, freshness, performance, and cost            |
| Recovery             | Rollback, replay, disable, backup, restore, reconciliation, or export      |
| Operations           | Named owner, alerts, incidents, maintenance, runbooks, and support         |
| Handover and exit    | Understandable docs, portability, decommissioning, and known gaps          |

Apply depth in proportion to consequence. A static page can mark identity,
persistence, and migrations Not applicable; a paid multi-tenant Application
cannot.

## Conditional gates

Apply these only when the capability exists:

- **Durable state:** name the source of truth, schema owner, migration order,
  compatibility window, backup, restore, retention, and export path.
- **Identity, private, or paid access:** resolve actor and tenant outside user
  input, enforce authorization and entitlement server-side, and test denial.
- **External side effects:** define idempotency, retry ownership, timeouts,
  duplicate delivery, reconciliation, audit, and specific approval.
- **Public API, webhook, or integration:** validate signatures and schemas,
  bound rates and payloads, keep stable errors, and expose delivery failure.
- **Runtime AI or agent capability:** bound context and tools, validate
  structured input/output, keep policy and irreversible effects deterministic,
  define approval, evaluations, audit, cost limits, recovery, and a kill switch.

## Deployment gate

Before releasing or activating a change, verify:

1. exact commit and generated artifact
2. target platform and environment
3. required checks and review evidence
4. runtime configuration and secret ownership
5. migration order, compatibility, and backup when state changes
6. deployment authority and platform access
7. health, critical journey, and failure observability
8. rollback, replay, disable, or stop procedure
9. operational owner and incident route

Shape-specific activation:

- **Application:** deploy the selected frontend/backend release unit and smoke
  test the critical journey and assets.
- **Service:** deploy independently, verify health and contracts, and prove
  rollback.
- **Automation:** publish the versioned workflow, test safely, then activate;
  verify replay and kill switch.
- **Integration:** deploy the boundary, register external configuration, verify
  delivery and reconciliation, and plan secret rotation.
- **System:** publish reviewed technical truth and verify links, ownership, and
  incident routing; no fake runtime deployment is required.

## Completion

Do not average away a Missing or Blocked critical area. State unavailable
evidence explicitly. A change is complete only at the level its consequence
requires; deployment is complete only after the target environment is verified.
