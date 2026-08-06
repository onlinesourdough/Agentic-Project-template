# Advanced full-stack Python

**Status:** Optional sourced capability profile. This is not a default stack.

Use the official Full Stack FastAPI Template as a starting reference only when
every fit condition below is resolved. Do not copy or vendor the upstream
template into Solution-template.

## Official sources

- [Full Stack FastAPI Template repository](https://github.com/fastapi/full-stack-fastapi-template)
- [FastAPI project generation documentation](https://fastapi.tiangolo.com/project-generation/)

Re-read both sources at selection and update time. Record the reviewed upstream
revision or release in the adopting project's technical truth rather than
assuming this profile proves current compatibility.

## Fit conditions

All conditions are required:

- the owned domain capability materially benefits from Python or already has a
  Python owner;
- users need a component-based React interface;
- PostgreSQL is justified as the durable shared relational data authority;
- authentication and server-enforced authorization are required;
- Docker is justified for reproducible build, deployment, or handover; and
- an operated deployment is justified, with a named operator for the deployed
  application, database, secrets, updates, monitoring, and recovery.

If any condition is missing, inferred, or supplied only by the template,
choose a smaller stack. Ordinary web CRUD, a static interface, a Python-only
service, or an existing platform does not earn this profile by itself.

## Responsibilities added

- Python/FastAPI backend and domain boundary
- React browser interface and its API contract
- PostgreSQL schema, migrations, backup, restore, and data ownership
- authentication, authorization policy, secret handling, and denial behavior
- Docker build and runtime artifacts
- operated deployment, health signals, logs, upgrades, and recovery

Keep stable domain logic separate from framework delivery code. Keep
authorization and other trust decisions on the server boundary.

## Operator burden

The operator maintains Python and browser dependency ecosystems, container
images, PostgreSQL, credentials and secrets, security updates, deployment
configuration, monitoring, backups, and recovery exercises. Reject the profile
when that continuing work has no named owner or when a managed or existing
system owns it more simply.

## Verification

Before Ship, require evidence proportionate to the risk:

- backend domain and API contract tests, including invalid and denied access;
- frontend build and critical browser journey against the real contract;
- schema migration and compatibility checks;
- Docker image build and configured service startup;
- deployment health, structured failure visibility, and secret isolation; and
- exercised database restore plus application rollback or forward recovery.

Tests prove behavior; the named measurement owner still verifies the intended
outcome after delivery.

## Update path

Re-read the official sources, compare the adopting project with the selected
upstream revision, review dependency and migration changes, and apply only
changes whose responsibilities still fit. Run the same build, contract,
migration, security, and recovery checks. Never update from the template
automatically or replace owned project truth with upstream defaults.

## Exit path

Keep application code, API contracts, PostgreSQL schema and exports, deployment
configuration, and recovery instructions under project ownership. To leave the
profile or replace the upstream template, preserve the public contract and data
authority, export and migrate PostgreSQL safely, replace authentication and
deployment responsibilities explicitly, and verify the same critical journey
and recovery path on the successor stack.
