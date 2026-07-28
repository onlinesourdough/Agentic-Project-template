# System

A documentation-first repository for cross-repository architecture, ownership,
infrastructure, and operations.

Do not add runtime code or a package manifest to make it look like an
Application.

## Owns

- current system and deployment topology
- repository, domain, data, and workflow ownership
- important contracts and architecture decisions
- incident routing and operational runbooks
- target state and known gaps

Link to implementation repositories instead of duplicating their detail. Keep
current and target state distinct. Never commit secrets, customer data, private
incident payloads, or unsanitized runtime exports.

## Evidence

- a new operator can find each major responsibility and repository
- incidents can be routed from symptom to owner
- decisions and open gaps are traceable
- links resolve and sensitive material is absent
