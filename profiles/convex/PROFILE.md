# Convex

Use when an Application needs authenticated data, realtime collaboration,
scheduling, search, storage, or shared web and native state.

## Runtime

- current Convex Application scaffold
- validated public and internal functions
- GitHub Actions CI
- coordinated Convex and frontend deployment

Expected scripts are `lint`, `typecheck`, `test`, and `build`.

Use an isolated non-production `VITE_CONVEX_URL` for CI and environment-specific
`CONVEX_DEPLOY_KEY` values. Keep Cloudflare credentials scoped to the matching
environment. Never expose production deploy keys to pull requests or agent
worktrees.

Keep pure rules framework-free. Validate identity, authorization, input, and
return shapes in public functions. Use indexes and bounded reads. Use actions
for external or nondeterministic work. Do not wrap `ctx.db` in an interface that
only renames Convex.

## Deployment

Treat Convex functions, schema compatibility, generated types, and the frontend
as one coordinated release. The copied workflow deploys Convex and builds the
frontend against the resulting production URL before Cloudflare deployment.

Verify authenticated and unauthenticated journeys, queries, mutations, actions,
schedules, and logs that the slice actually uses. Keep the previous frontend
artifact deployable and use backward-compatible function/schema changes or a
tested forward recovery when data has changed.
