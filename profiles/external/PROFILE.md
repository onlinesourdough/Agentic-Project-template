# External Backend

Use when an existing or specialist backend owns Application behavior.

## Runtime

- TypeScript frontend with a stable HTTP contract
- GitHub Actions CI for the frontend
- backend-owned deployment, monitoring, migrations, and rollback

Expected frontend scripts are `lint`, `typecheck`, `test`, and `build`.

The template copies no generic deployment workflow because containers, regions,
credentials, callbacks, and rollback belong to the actual backend.

Keep DTOs and schemas at the boundary, backend types out of presentational
components, and persistence and background work with the backend. Validate
external input independently on both sides and cover compatibility with
contract, integration, and end-to-end tests.

## Deployment

Define frontend and backend release ownership separately. Use compatible API
changes, deploy in the safe order, and keep environment-specific API origins
and credentials outside the bundle. The copied CI validates only the frontend;
the backend must provide its own real checks and deployment evidence.

Verify the deployed frontend against the target backend, including auth,
timeouts, error mapping, and the critical journey. Roll back each release unit
through its owning platform.
