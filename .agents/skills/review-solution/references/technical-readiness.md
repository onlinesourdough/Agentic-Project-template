# Technical Readiness

Use this evidence map for project-wide setup, review, release, adoption, or
handover. It is not a required document template.

## Supplied inputs

The project does not invent the intended outcome, user or caller, acceptance,
business rules, constraints, authority, risk tolerance, existing owners, or
legal and commercial requirements. These may come from a person, AIOS, issue,
meeting, README, or another trustworthy source.

## Accountable roles

One person may hold several roles. A coding agent assists but never becomes the
accountable owner or grants itself authority.

| Role                 | Owns                                                |
| -------------------- | --------------------------------------------------- |
| Outcome owner        | Intended result, acceptance, constraints, authority |
| Solution owner       | Technical scope, boundaries, decisions, tradeoffs   |
| Implementation owner | Code, configuration, tests, change quality          |
| Platform owner       | Runtime, environments, access, secrets, deployment  |
| Operational owner    | Health, incidents, recovery, cost, handover         |

## Readiness areas

Classify every row as **Ready**, **Not applicable**, **Missing**, or
**Blocked**. Ready requires observable evidence; Not applicable requires a
reason tied to the selected shape and slice.

| Area                 | Owner skill          | Evidence                                                            |
| -------------------- | -------------------- | ------------------------------------------------------------------- |
| Responsibility       | `clarify-solution`   | Repository owns, consumes, and does not own                         |
| Shape and profile    | `clarify-solution`   | One fitting shape and optional Application profile                  |
| Runtime and stack    | `architect-solution` | Current scaffold, versions, manifests, rationale                    |
| Architecture         | `architect-solution` | Boundaries, components, dependency direction, deploy units          |
| Contracts and data   | `architect-solution` | Validated I/O, sources of truth, schemas, migrations                |
| Implementation       | `implement-slice`    | Small complete slice, framework edges, scoped change                |
| Identity and trust   | `secure-solution`    | Actor, caller, authorization, tenant, approvals                     |
| Security and privacy | `secure-solution`    | Threats, secrets, sensitive data, dependencies, access              |
| AI and autonomy      | `secure-solution`    | Bounded context/tools, deterministic policy, evaluation, control    |
| Quality              | `test-solution`      | Static checks, behavior, contracts, failures, real-runtime evidence |
| Documentation        | `document-solution`  | Current setup, decisions, contracts, operations, links              |
| Delivery             | `deliver-solution`   | Review, CI, artifact identity, compatibility, provenance            |
| Deployment           | `deliver-solution`   | Environment, config, secrets, migration, release verification       |
| Observability        | `operate-solution`   | Health, logs, errors, metrics, freshness, performance, cost         |
| Recovery             | `operate-solution`   | Rollback, replay, disable, restore, reconcile, export               |
| Operations           | `operate-solution`   | Named owner, alerts, incidents, maintenance, support                |
| Handover and exit    | `document-solution`  | Understandable truth, portability, decommissioning, gaps            |

Apply depth in proportion to consequence. A landing page can mark identity and
persistence Not applicable; a paid multi-tenant Application cannot.

## Conditional gates

- **Durable state:** source of truth, schema owner, migration order,
  compatibility, backup, restore, retention, export.
- **Identity, private, or paid access:** trusted actor and tenant,
  server-enforced authorization and entitlement, tested denial.
- **External side effect:** idempotency, retry ownership, timeout, duplicates,
  reconciliation, audit, specific approval.
- **Public API, webhook, or Integration:** auth or signature, schema, limits,
  stable error, compatibility, delivery failure.
- **Automation:** trigger, credential owner, published source, retries, replay,
  error channel, activation, kill switch.
- **Runtime AI:** bounded context/tools, validated I/O, deterministic policy,
  approval, evaluations, audit, cost limit, recovery, kill switch.

## Deployment gate

Verify exact commit and artifact, target environment, checks and review,
configuration and secret ownership, migration order and backup, deployment
authority, health and critical journey, failure visibility, recovery procedure,
and operational owner.

Activation by shape:

- **Application:** deploy the selected release unit and smoke-test journey and
  assets.
- **Service:** deploy independently, verify health and contract, prove recovery.
- **Automation:** publish, test safely, activate, verify replay and kill switch.
- **Integration:** deploy boundary, register external configuration, verify
  delivery and reconciliation.
- **System:** publish reviewed truth and verify links, ownership, and incident
  routing; no fake runtime deployment.

Do not average away a Missing or Blocked critical area. Deployment is complete
only after target-environment verification.
