# Technology recommendations

Choose technology from the solution's responsibilities, risks, operator, and
existing ownership. These are starting points, not requirements.

## Choose what to own

1. Name the capability and owner.
2. Reuse a working system that already owns the responsibility.
3. Build only the differentiating or ownership-critical part.
4. Buy or rent generic capabilities when reduced operation justifies the
   dependency and exit path.
5. Self-host only when license, updates, security, observability, backup, and
   recovery have an owner.
6. Choose the smallest runtime that can deliver and recover the first complete
   result.

## Preferred starting points

| Responsibility | Starting point |
| --- | --- |
| Browser interface | TypeScript and React; Vite before a larger framework |
| Ordinary web capability | TypeScript when one language simplifies contracts and operation |
| Data, scientific, image, quant, or ML logic | Python |
| Visible orchestration and approvals | Existing workflow runtime or n8n |
| Local single-owner state | Files or SQLite |
| Shared relational truth | PostgreSQL |
| CI | Repository host's native CI |
| Static public delivery | GitHub Pages or an already-owned web platform |
| Portable runtime | OCI container only when deployment or handover needs it |
| Observability | Health checks and structured logs before a vendor platform |
| Infrastructure | Versioned configuration; IaC only when reproducibility needs it |

Do not add authentication, a database, queue, container platform,
observability vendor, or runtime AI because a starter includes it. Each layer
needs one responsibility and owner.

## Full Stack FastAPI Template

**Status:** Optional sourced option. It is not a default stack.

Official sources:

- [Full Stack FastAPI Template](https://github.com/fastapi/full-stack-fastapi-template)
- [FastAPI project generation](https://fastapi.tiangolo.com/project-generation/)

Do not copy or vendor the upstream into Solution-template. Review the current
upstream revision when a real project selects it.

### Fit conditions

All are required:

- Python materially benefits owned domain logic or already has an owner;
- a component-based React interface is needed;
- PostgreSQL is justified as shared relational authority;
- authentication and server-enforced authorization are required;
- Docker is justified for reproducible build, deployment, or handover; and
- an operated deployment has a named owner for application, data, secrets,
  updates, monitoring, backup, and recovery.

If any condition is missing or supplied only by the template, choose a smaller
stack.

### Responsibilities added

The selection adds a Python/FastAPI backend, React interface and API contract,
PostgreSQL schema and recovery, authentication and authorization, Docker
artifacts, and operated deployment. Keep domain logic separate from framework
delivery and trust decisions on the server boundary.

### Operator burden

The operator owns two dependency ecosystems, container images, PostgreSQL,
secrets, security updates, deployment configuration, monitoring, backups, and
recovery exercises. Reject the option when that work has no owner.

### Verification

Require backend domain/API tests including denial, frontend build and critical
browser journey, migration compatibility, container build/startup, deployment
health and failure visibility, secret isolation, exercised restore, and
application rollback or forward recovery.

### Update path

Compare the selected project with a named upstream revision. Apply only changes
whose responsibilities still fit, then repeat build, contract, migration,
security, and recovery checks. Never update automatically.

### Exit path

Keep application code, contracts, schema and exports, deployment configuration,
and recovery instructions under project ownership. Preserve the public contract
and data authority while replacing each responsibility explicitly.

## Selection check

Before accepting any technology, verify that:

- its role and source of truth are explicit;
- current official documentation and material cost or license terms were read;
- contracts can be checked by types, schemas, validators, or tests;
- build, operation, failure, and recovery are observable;
- secrets and operational state remain outside source code; and
- the operator can maintain or replace it after handover.

Language popularity is not proof of fit. Existing systems and owners win.
