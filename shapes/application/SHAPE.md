# Application Shape

Use this shape for a human-facing website, dashboard, portal, digital product,
internal tool, or SaaS application.

## Required context

Confirm:

- the primary user and valuable journey
- public, authenticated, private, or paid boundaries
- existing identity, data, workflow, and backend owners
- the first independently useful vertical slice
- web, mobile, desktop, and integration consumers that exist now

## Choose one runtime profile

| Profile           | Use when                                                       |
| ----------------- | -------------------------------------------------------------- |
| static-pages      | The output is public and fully static                          |
| cloudflare-native | Edge endpoints or straightforward relational persistence exist |
| convex            | Authenticated realtime application data or workflows exist     |
| external          | An existing or specialist backend owns application behavior    |

Do not select a database or auth provider before the slice needs one.

## Implementation boundaries

- Keep route files thin.
- Keep presentational components free of server and database types.
- Put cross-boundary schemas and DTOs in framework-independent modules.
- Put workflows in services for conventional backends.
- Put vendor calls in adapters or backend integrations.
- Keep paid access and authorization server-owned.
- Use explicit API routes for non-web clients and public integrations.
- Reuse existing backends instead of proxying or duplicating their state.

The companion `APPLICATION_ARCHITECTURE.md` contains detailed TanStack,
Cloudflare, Convex, conventional backend, auth, billing, data, and migration
patterns. Apply only the sections required by the chosen profile and slice.

## First slice

1. Write or update the behavior test.
2. Define the smallest cross-boundary contract.
3. Implement the domain or workflow behavior.
4. Add the selected backend boundary only when needed.
5. Add feature hooks and small components.
6. Add the route entrypoint.
7. Run lint, typecheck, tests, and build.
8. Verify the critical journey in a real browser.

## Do not add by default

- auth for a public site
- persistence for static content
- billing before a paid workflow exists
- analytics without a decision it will inform
- queues or realtime infrastructure without asynchronous or collaborative work
- runtime agents without an agent-capable user outcome

## Delivery gate

- selected profile matches the deployed runtime
- public/private/paid boundaries are enforced in the correct runtime
- route, contract, component, and infrastructure boundaries are intact
- application checks and the critical browser journey pass
- deployment, health, rollback, and ownership are documented
