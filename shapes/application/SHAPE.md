# Application

A human-facing website, product, portal, dashboard, or internal tool.

## Owns

- the user journey and interface
- client/server boundaries
- application authorization and paid access when present
- the smallest useful vertical slice

Reuse existing identity, data, workflow, and backend owners. Add auth,
persistence, billing, analytics, queues, or runtime AI only when the slice
requires them.

## Boundaries

- Keep routes thin and presentational components free of server types.
- Keep domain rules outside framework entrypoints.
- Validate contracts at every external boundary.
- Put vendor calls in adapters or backend integrations.
- Keep private and paid decisions server-owned.
- Use explicit APIs for non-web clients and public integrations.

Select exactly one `PROFILE.md` for the primary runtime.

## Evidence

- relevant static checks, tests, and build pass
- the critical journey works in a real browser
- public, private, and paid boundaries behave as intended
- deployment failure and rollback are understood
