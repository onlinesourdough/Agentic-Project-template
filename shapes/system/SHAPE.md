# System Shape

Use this shape for a cross-repository architecture, infrastructure, ownership,
or operational source of truth.

This may be a documentation-only repository. Do not add runtime code or a
package manifest to make it resemble an application.

## Required views

Maintain:

- current system overview
- repository and domain ownership map
- deployment topology and environments
- authoritative data and workflow owners
- important contracts between components
- architecture decision records
- incident triage flow
- operational runbooks
- target state and known gaps

Link to implementation repositories instead of duplicating their detailed
documentation.

## Decisions and change

Record why a boundary or platform was chosen, alternatives considered, owner,
and migration or rollback consequences. Keep current state distinct from target
state.

Configuration snapshots must be sanitized. Runtime workflow backups, secrets,
customer data, and private incident payloads belong in their dedicated secure
owners.

## Delivery gate

- a new operator can identify each major responsibility and repository
- current deployment and target state are distinguishable
- incidents can be triaged from symptom to owner
- decisions and open gaps are traceable
- links resolve and no secret or private export is committed
