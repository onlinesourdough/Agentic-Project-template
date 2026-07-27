# Application Architecture

This document contains detailed Application patterns for the AI-native Solution
Template. Read the shared architecture and selected shape first, then use only
the sections required by the current runtime profile and slice.

## Goal

Build small web products with minimal maintenance, clear boundaries, and a clean path to change infrastructure later.

The architecture should be:

- simple enough for a small product
- modular enough to change data layer, analytics, auth, storage, or runtime
- component-based in React
- typed at the boundaries
- easy for agents to inspect and modify
- ready for web first, with mobile and desktop paths later

## Application Forms

Applications include more than subscription products. Treat the stack as a set
of capabilities to adopt deliberately.

Common forms:

| Form                       | Typical capabilities                                                             | Usually skip at first                                |
| -------------------------- | -------------------------------------------------------------------------------- | ---------------------------------------------------- |
| Landing page or portfolio  | React, routes, feature components, static content, optional Worker endpoints     | Auth, Stripe, D1, dashboards, queues                 |
| Content or newsletter site | React, routes, shared contracts, Worker/API adapters, email provider integration | Paid access, customer portal, complex database layer |
| Internal tool              | Auth, a selected backend profile, feature modules, and typed boundaries          | Stripe, public marketing flows, product analytics    |
| SaaS product               | Auth, a selected backend profile, billing, email, analytics, and webhooks        | Anything not needed by the first paid workflow       |

The rule is capability-driven architecture: add a folder, service, repository, adapter, schema, or integration when it protects a real boundary. Do not add files only to satisfy a diagram.

## Backend Profiles

Select one primary backend profile before creating persistence or server folders.

### Convex

Use Convex as the recommended profile when an application has authenticated product data, realtime state, collaboration, scheduling, search, AI workflows, or web and native clients sharing one backend.

```txt
React/TanStack client
        |
typed query, mutation, action, or HTTP call
        |
Convex public function
        |
authorization + application workflow + model helpers
        |
Convex database, scheduler, storage, search, and Components
```

Cloudflare still hosts the TanStack application and edge-specific responsibilities. Convex hosts backend functions and product data. Do not proxy ordinary Convex client traffic through a Worker.

### Cloudflare Native

Use Workers with optional D1 when the product is static or mostly static, needs a few edge endpoints, is straightforward relational CRUD, or benefits more from SQL and platform simplicity than realtime backend behavior.

This profile uses the conventional service, repository, and adapter model described later in this document.

### External Backend

Use an explicit HTTP API when the product requires Python/FastAPI, an existing MongoDB or PostgreSQL deployment, specialist compute, a separate data platform, or an independently deployed service.

The frontend still consumes stable contracts through feature-level hooks or API clients. The backend owns its internal architecture.

## Agent Interaction Modes

Runtime profile and agent interaction are independent decisions. Select one
backend profile, then choose the least autonomous interaction mode that delivers
the user outcome:

| Mode               | Product behavior                                                         |
| ------------------ | ------------------------------------------------------------------------ |
| Coding-agent-ready | Agents work on the repository through documented architecture and tests  |
| Agent-assisted     | A product agent drafts or recommends while the human performs the action |
| Agent-operated     | An agent invokes a bounded set of application-owned operations           |
| Automation-first   | Scheduled or event-driven agents run bounded workflows under supervision |

Do not create a separate implementation of product rules for the agent. Human,
API, CLI, automation, and agent surfaces should adapt to the same typed
operation when they need the same outcome. The operation resolves actor and
caller, validates inputs and outputs, enforces authorization, and owns side
effects.

Context is also an application contract. Project the smallest relevant route,
resource, selection, tenant, and permission context explicitly. Reload
authoritative data inside the operation rather than asking a model to infer
state from the DOM or trust supplied text.

Agent-callable mutations additionally require risk-appropriate approval,
idempotency, concurrency behavior, recovery, audit events, observability, and
agent evaluations. Keep deterministic code in control of critical rules and
irreversible effects.

The source template repository contains optional specialist guides for
agent-capable products and adoption into existing systems. Apply those guides
only when the solution context requires them.

## Capability Adoption

Use these defaults:

| Capability                      | Add when                                                                                      | Do not add when                                                                             |
| ------------------------------- | --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| `src/routes/`                   | The app has pages, loaders, actions, API routes, or route-level layout                        | Never; routes are always the entrypoint for routed apps                                     |
| `src/features/`                 | A page or workflow has multiple components, hooks, or local behavior                          | A single tiny component is easier to read inline                                            |
| `shared/` contracts and schemas | Data crosses a trust boundary: forms, API, webhook, storage, external service                 | The value is static copy or purely local UI state                                           |
| `src/services/`                 | There is workflow logic, branching, orchestration, or a use case name                         | A component only renders props                                                              |
| `convex/`                       | The Convex backend profile is selected                                                        | The app is static or uses another backend profile                                           |
| `src/repositories/`             | A Cloudflare-native or external backend persists data through replaceable storage             | Convex is selected and the interface would only wrap `ctx.db`                               |
| `src/adapters/`                 | Code talks to a database, vendor API, platform binding, analytics, payment, or email provider | A helper is pure and framework-free                                                         |
| `src/server/`                   | The app has server-only env, auth/session, dependency wiring, or server context               | The app is static and has no server runtime                                                 |
| `migrations/`                   | The app owns a database schema                                                                | There is no database                                                                        |
| Convex Components               | A maintained Component solves a bounded backend capability                                    | The capability is absent or the Component would own irreplaceable data without an exit plan |
| WorkOS AuthKit                  | Convex with TanStack Start needs authenticated SSR                                            | The product is public or uses another supported auth model                                  |
| Auth.js                         | A non-Convex app needs accounts or sessions and Auth.js fits its runtime                      | The site is public or the Convex profile uses a supported OIDC integration                  |
| Stripe                          | The product charges money                                                                     | There is no paid workflow                                                                   |
| Resend                          | The product sends transactional email                                                         | Signup is delegated to a newsletter platform or no email is sent                            |
| PostHog                         | Product decisions depend on event analytics                                                   | Basic traffic analytics is enough                                                           |

## Principles

- Start simple.
- Add abstraction only where it protects a real boundary.
- Keep product logic separate from infrastructure.
- Keep files small and named by what they do.
- Prefer typed contracts over implicit JSON shapes.
- Prefer feature folders for product workflows.
- Prefer adapters for external systems.
- Avoid framework, database, or vendor code inside domain and service logic.
- Preserve the selected backend's useful semantics instead of forcing every backend through the same abstraction.

## When To Add Abstraction

Use an interface or adapter when:

- a conventional backend talks to a replaceable database or data source
- the code talks to Stripe, Resend, PostHog, Cloudflare, or another external service
- the implementation may change later
- the code is hard to test without mocking an external system
- the same use case must work from web, API, mobile, or scripts

Do not add abstraction when:

- a helper is pure and small
- a component only renders UI
- a one-off route has no reuse and no external dependency
- the abstraction would only rename a single function
- a Convex repository would only pass `QueryCtx` or `MutationCtx` through another layer

The default is pragmatic: functions first, service classes only when constructor injection or multiple collaborators make the code clearer. In the Convex profile, public functions form the application boundary, model helpers own `ctx.db` access, and pure domain functions hold rules that do not need runtime context.

## Folder Structure

This is the full target shape. A real app should use the subset it needs today and add the rest when the product grows into it.

```txt
.
|-- src/
|   |-- routes/
|   |-- components/
|   |-- features/
|   |-- hooks/
|   |-- server/
|   |-- domain/
|   |-- services/
|   |-- repositories/
|   |-- adapters/
|   |-- config/
|   |-- lib/
|   |-- router.tsx
|   `-- styles.css
|-- convex/                 # Convex profile only
|-- shared/
|   |-- schemas/
|   |-- contracts/
|   `-- index.ts
|-- migrations/
|-- tests/
|-- delivery/
|-- AGENTS.md
`-- ARCHITECTURE.md
```

Responsibilities:

- `src/routes/`: TanStack Start route files, loaders, server functions, and API routes.
- `src/components/`: reusable UI components.
- `src/features/`: product-area UI, feature hooks, query options, and route helpers.
- `src/hooks/`: cross-feature browser hooks.
- `src/server/`: server-only env parsing, context creation, middleware, and dependency wiring.
- `src/domain/`: product concepts and business rules.
- `src/services/`: use cases and workflows.
- `src/repositories/`: data access interfaces.
- `src/adapters/`: implementations for D1, MongoDB, Postgres, KV, R2, Queues, Auth.js, Stripe, Resend, PostHog, and other integrations.
- `src/config/`: project-specific settings, env names, feature flags, and integration names.
- `src/lib/`: small pure helpers.
- `convex/`: Convex schema, public and internal functions, model helpers, HTTP actions, crons, Components, and generated API types.
- `shared/`: framework-free contracts, schemas, value objects, enums, DTOs, and pure helpers.
- `migrations/`: database migrations.
- `tests/`: service, adapter, route, webhook, and end-to-end tests.
- `delivery/`: branching, TDD, CI, and deployment guidance.

Convex profile:

```txt
.
|-- src/
|   |-- routes/
|   |-- components/
|   |-- features/
|   |   `-- projects/
|   |       |-- components/
|   |       `-- hooks/
|   |-- lib/
|   |   `-- convex.ts
|   |-- router.tsx
|   `-- styles.css
|-- convex/
|   |-- _generated/
|   |-- model/
|   |   `-- projects.ts
|   |-- integrations/
|   |-- schema.ts
|   |-- auth.config.ts
|   |-- convex.config.ts
|   |-- projects.ts
|   |-- http.ts
|   `-- crons.ts
|-- shared/
|   |-- contracts/
|   |-- domain/
|   `-- schemas/
|-- tests/
`-- convex.json
```

Do not create empty Convex files. `http.ts`, `crons.ts`, auth configuration, Components, integrations, and even `schema.ts` appear only when the product needs those capabilities. For a production product that owns data, add and enforce a schema before launch.

Minimal landing/content shape:

```txt
.
|-- src/
|   |-- routes/
|   |-- features/
|   |   `-- landing/
|   |       |-- components/
|   |       `-- hooks/
|   |-- services/
|   |-- adapters/
|   |-- config/
|   |-- lib/
|   |-- router.tsx
|   `-- styles.css
|-- shared/
|   `-- contracts/
`-- tests/
```

In this smaller shape, `services/`, `adapters/`, and `shared/` are still useful when the page talks to a newsletter provider, CMS, Worker, analytics endpoint, or other external system. If the site is fully static, even those folders can wait.

## Shared Library

Treat `shared/` like a small C# class library.

Rules:

- no React imports
- no Cloudflare imports
- no Convex imports or generated Convex types
- no database SDK imports
- no Stripe, Resend, PostHog, or Auth.js imports
- only contracts, schemas, value objects, enums, DTOs, and pure helpers

`shared/` is safe for:

- web app
- server functions
- API routes
- tests
- future Expo app
- future desktop app
- migration scripts
- CLI tools
- MCP tools

Example:

```txt
shared/
|-- schemas/
|   |-- user.schema.ts
|   |-- project.schema.ts
|   `-- subscription.schema.ts
|-- contracts/
|   |-- user.contract.ts
|   |-- project.contract.ts
|   `-- billing.contract.ts
|-- ids.ts
|-- result.ts
`-- index.ts
```

Use shared schemas at trust boundaries:

- browser form input
- server function input
- public API input
- webhook payloads after signature verification
- database reads when shape drift is possible
- migration scripts
- imports from external systems

## Feature Modules

Use feature folders for product areas. Keep cross-feature primitives in `shared/`, `src/domain/`, or `src/components/ui/`.

```txt
src/features/projects/
|-- components/
|   |-- ProjectCard.tsx
|   |-- ProjectForm.tsx
|   `-- ProjectList.tsx
|-- hooks/
|   |-- useCreateProject.ts
|   `-- useProjects.ts
|-- query-options.ts
|-- route-loaders.ts
`-- index.ts

src/domain/projects/
|-- project.ts
`-- project-rules.ts

src/services/projects/
|-- create-project-service.ts
|-- list-projects-service.ts
`-- update-project-service.ts

src/repositories/
`-- project-repository.ts

src/adapters/d1/
`-- d1-project-repository.ts

shared/schemas/
`-- project.schema.ts
```

Rules:

- Feature components can import feature hooks and UI primitives.
- Feature hooks can call query options, server functions, or typed API clients.
- Feature hooks must not import Stripe, D1, Resend, or other SDKs.
- Services can import domain rules, schemas, and repository interfaces.
- Adapters can import SDKs and platform bindings.
- `index.ts` files export the public feature surface only.

In the Convex profile, feature hooks may import the generated `api` and official Convex query helpers. Presentational components should receive application DTOs through props rather than importing `Doc<"table">` or calling generated APIs directly. This keeps UI composition reusable while retaining Convex's end-to-end typing in the hook layer.

## React Component Model

Component types:

- `src/routes/*`: route entrypoints. Load data, set layout, call feature components.
- `src/components/ui/*`: small reusable UI primitives.
- `src/components/layout/*`: shell, navigation, page layout, sidebar, topbar.
- `src/features/*/components/*`: feature-specific UI.
- `src/features/*/hooks/*`: feature-specific browser/query hooks.

Rules:

- Components should be pure.
- Keep components small enough to inspect in one screen.
- Pass data through props before reaching for context.
- Lift state to the closest common parent when components need to coordinate.
- Use composition instead of deep prop drilling when a component owns layout slots.
- Do not call server SDKs, database code, Stripe, Resend, or PostHog directly from components.
- Keep forms local where possible; submit through feature hooks or route/server functions.
- Keep components presentational unless they are route components or workflow components.

Example:

```tsx
type ProjectCardProps = {
  project: ProjectSummary;
  onOpen: (projectId: string) => void;
};

export function ProjectCard({ project, onOpen }: ProjectCardProps) {
  return (
    <button type="button" onClick={() => onOpen(project.id)}>
      <h2>{project.name}</h2>
      <p>{project.summary}</p>
    </button>
  );
}
```

## State Model

Use the smallest state owner that works.

| State type                    | Owner                                                                                                  |
| ----------------------------- | ------------------------------------------------------------------------------------------------------ |
| Server data                   | TanStack Query; Convex subscriptions through the official TanStack integration when Convex is selected |
| URL/search params             | TanStack Router                                                                                        |
| Route params and loaders      | TanStack Router                                                                                        |
| Form draft state              | Local component or form hook                                                                           |
| Dialog/open/close state       | Local component or small UI hook                                                                       |
| Theme/sidebar/app shell state | App shell context or small persisted hook                                                              |
| Auth/session facts            | Server session plus query/cache state                                                                  |
| Business state                | Server/domain model, not browser globals                                                               |
| Cross-platform contracts      | `shared/` schemas and DTOs                                                                             |

Rules:

- Do not duplicate server state into local state.
- Do not use `useEffect` to derive render data from props or state.
- Use derived values during render when possible.
- Use effects only to synchronize with external systems: browser APIs, subscriptions, timers, analytics, focus, or storage.
- Use TanStack Query invalidation after mutations instead of manually syncing lists.
- Let Convex subscriptions update affected query results; do not add manual invalidation unless a non-Convex cache also needs it.
- Keep optimistic updates rare and explicit.
- Add global state only when state is genuinely shared across distant UI and cannot live in URL, server cache, or a parent component.

## Hooks

Hooks should express reusable UI behavior, browser effects, or query/mutation workflows.

Good hook use:

- `useProjects()` wraps a project list query.
- `useCreateProject()` wraps a mutation and invalidation.
- `useTheme()` wraps persisted browser theme state.
- `useDebouncedValue()` wraps reusable browser timing behavior.
- `useAnalytics()` wraps product event capture.

Avoid:

- hooks that hide business rules
- hooks that call third-party SDKs directly
- hooks that mutate external state during render
- hooks that exist only to avoid passing one prop
- effects that transform data for rendering

Query hook:

```ts
export function projectsQueryOptions() {
  return queryOptions({
    queryKey: ["projects"],
    queryFn: () => listProjects(),
  });
}

export function useProjects() {
  return useSuspenseQuery(projectsQueryOptions());
}
```

Mutation hook:

```ts
export function useCreateProject() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: createProject,
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ["projects"] });
    },
  });
}
```

Convex query hook with TanStack Start:

```ts
export function useProjects() {
  return useSuspenseQuery(convexQuery(api.projects.listMine, {}));
}
```

Convex mutation hook:

```ts
export function useCreateProject() {
  return useConvexMutation(api.projects.create);
}
```

Keep generated API imports in feature hooks or route data helpers. Convex's reactive queries update after mutations, so this hook does not manually synchronize a second copy of server state.

## Server And Client Boundary

For Cloudflare-native and external backends, use TanStack server functions for:

- app-internal reads and writes
- type-safe calls from route loaders, actions, hooks, and components
- data that should not expose a public REST endpoint

Use server routes for:

- Stripe webhooks
- health checks
- mobile app APIs
- desktop app APIs
- file upload/download endpoints
- third-party integrations
- stable public API surfaces

For Convex, clients call public queries and mutations through the generated API. Use actions for external services or nondeterministic work, internal functions for backend-only operations, and HTTP actions for webhooks or clients that cannot use a Convex client library. Do not add a duplicate TanStack server function or Worker endpoint around normal Convex calls.

For static or mostly-static webapps, it is valid to have no server functions at all. Use explicit Worker/API routes only for the dynamic parts that exist: newsletter signup, contact forms, content feeds, webhooks, health checks, or third-party integrations.

Rules:

- TanStack server functions and routes validate input with shared schemas.
- Every public Convex function has argument validators, return validators where practical, and an explicit authentication/authorization decision.
- Use internal Convex functions for operations that clients must not call directly.
- Services or Convex application functions do authorization and business decisions.
- Conventional repositories do persistence through interfaces; Convex model helpers use the typed function context directly.
- Adapters own infrastructure details.
- External clients never depend on internal server function shapes.
- Mobile and desktop clients use stable Convex public functions or explicit API routes, not internal web-only assumptions.

## Convex Backend Profile

Convex replaces the conventional application server, repository implementation, database connection, subscription layer, and part of the job infrastructure. Treat it as a backend runtime, not as a database SDK hidden behind a generic repository.

### Ownership

- `convex/schema.ts` owns tables, validators, and indexes.
- Public query and mutation files own the client-visible application API.
- `convex/model/` owns reusable typed database access and document-to-DTO mapping.
- `shared/domain/` owns pure business rules that do not need a Convex context.
- Actions own calls to Stripe, Resend, AI providers, and other external systems.
- `convex/http.ts` owns backend webhooks and explicit HTTP endpoints.
- `convex/convex.config.ts` installs Components.
- Feature hooks own generated client API imports.
- UI components render application DTOs and remain unaware of database documents.

Public query example:

```ts
import { v } from "convex/values";
import { query } from "./_generated/server";
import { requireUserId } from "./model/auth";
import { listProjectsByOwner, toProjectSummary } from "./model/projects";

const projectSummary = v.object({
  id: v.string(),
  name: v.string(),
  summary: v.string(),
});

export const listMine = query({
  args: {},
  returns: v.array(projectSummary),
  handler: async (ctx) => {
    const ownerId = await requireUserId(ctx);
    const projects = await listProjectsByOwner(ctx, ownerId);

    return projects.map(toProjectSummary);
  },
});
```

This public function is intentionally thin, but it is not a pass-through. It validates the boundary, establishes identity, enforces ownership through its model query, and maps internal documents to a stable return shape.

### Functions

- Queries read data and are reactive. Keep them deterministic and index-backed.
- Mutations write data transactionally. Enforce invariants before writing.
- Actions call external APIs or use nondeterministic runtimes. They access data through queries and mutations.
- Prefer a mutation that records user intent and schedules an internal action over calling an action directly from the client.
- HTTP actions handle Stripe and provider webhooks, service callbacks, and explicit HTTP clients.
- Public functions are internet-accessible application endpoints. Internal functions are backend-only.
- Await every database write, scheduler call, and other promise.
- Use indexes and bounded reads; avoid unbounded `.collect()` and post-query filtering.

Install the recommended Convex ESLint rules in generated projects. Require function argument validators, use explicit table IDs, and enable stricter query rules when the data can grow.

### Authentication And Authorization

Authentication identifies the caller; each public function still decides whether that caller may perform the requested operation.

- Use WorkOS AuthKit as the first option when TanStack Start needs authenticated SSR.
- Clerk, Auth0, or another supported OIDC provider is valid when product requirements justify it.
- Convex Auth is an option for client-oriented React and React Native apps, but its beta status and current SSR support must be reviewed before selection.
- Auth.js is not the default for the Convex profile.
- Centralize helpers such as `requireUserId`, `requireMembership`, and `requireRole`.
- Filter reads by the authorized owner or tenant through indexes; do not load a document and assume the client was allowed to name its ID.
- Verify webhook signatures before parsing trusted provider events, and make side effects idempotent.
- Use internal functions whenever the client has no reason to invoke an operation.

### Components

Convex Components bundle functions, schema, data, and scheduling in isolated backend modules. They are useful for bounded capabilities such as rate limiting, durable workflows, aggregation, collaboration, and agent threads.

Rules:

- Install a Component only when it removes meaningful product work.
- Check maintenance status, documentation, version, license, and production suitability.
- Call Components through application-owned wrapper functions rather than exposing their API throughout the UI.
- Pass only the data and callbacks the Component needs.
- Do not place irreplaceable source-of-truth product data in a Component without a documented export and migration path.
- Register Components in `convex-test` when testing code that uses them.

### Cloudflare Relationship

For this profile:

- Cloudflare Workers runs the TanStack application, SSR, static assets, redirects, headers, and genuinely edge-owned endpoints.
- Cloudflare Web Analytics measures site traffic.
- Convex runs product queries, mutations, actions, HTTP actions, scheduled work, search, storage, and database operations.
- PostHog remains optional product analytics; Convex operational insights are not a replacement for product event analytics.
- R2 is optional for media-heavy products where its storage or egress model is materially better than Convex file storage.
- D1 is normally absent. Adding both D1 and Convex requires a clearly documented ownership boundary.

Do not duplicate authorization or business workflows across Workers and Convex. One system owns each write.

### Portability And Exit

The portable boundary is the application contract, not Convex's internal document API.

- Return stable DTOs with application field names instead of exposing raw documents.
- Normalize `_id` and `_creationTime` at the public boundary when those fields should not become permanent API semantics.
- Keep pure domain rules and cross-platform contracts outside `convex/`.
- Keep generated API usage inside feature hooks and route data helpers.
- Export important product data regularly and test that exports can be parsed.
- Document which features depend on realtime subscriptions, scheduling, search, storage, or Components.
- Treat migration to PostgreSQL or MongoDB as an API and behavior migration, not merely an adapter change.
- Self-hosting preserves the Convex programming model but requires operating its backend, dashboard, persistence, and storage; it does not run as a Cloudflare Worker.

### Cost And Operations

Before production, review the current Convex pricing and limits for the selected region. Track:

- function calls, including subscription updates
- database storage and I/O
- action compute and external API usage
- file storage and egress
- text and vector search
- concurrent sessions and function limits
- backup, log streaming, exception reporting, and support requirements

Use the free plan for development and low usage only while its hard limits are acceptable. Move to Starter before hard limits can interrupt real users, and require an explicit business decision before adopting a higher fixed-cost plan.

### Agent Workflow

Use Convex's maintained agent files instead of copying static Convex guidance into an application forever:

```sh
npx convex ai-files install
npx convex ai-files status
```

For an isolated local agent environment:

```sh
npm ci
npx convex dev --once
```

The CLI can provision a local backend in a non-interactive environment. Use a separate expiring cloud dev deployment and scoped deploy key when an agent needs public webhooks, cloud environment defaults, or dashboard access. Never share a production deploy key with an agent worktree. The Convex MCP server is optional and beta; scope it to the intended development deployment.

## Conventional Data Layer And Adapter Mapping

This section applies to Cloudflare-native and external backends. Skip it when Convex is selected, and skip it entirely until the product owns persistent data. A landing page that reads public content from a CMS or submits a newsletter signup does not need repository interfaces or migrations on day one. It may still need adapters for the CMS, email platform, or Worker endpoint.

Repository interface:

```ts
export interface ProjectRepository {
  findById(id: ProjectId): Promise<Project | null>;
  listByOwner(ownerId: UserId): Promise<ProjectSummary[]>;
  save(project: Project): Promise<void>;
  delete(id: ProjectId): Promise<void>;
}
```

D1 adapter:

```ts
export class D1ProjectRepository implements ProjectRepository {
  constructor(private readonly db: AppDatabase) {}

  async findById(id: ProjectId): Promise<Project | null> {
    const row = await this.db.query.projects.findFirst({
      where: (projects, { eq }) => eq(projects.id, id),
    });

    return row ? toProject(row) : null;
  }
}
```

MongoDB adapter:

```ts
export class MongoProjectRepository implements ProjectRepository {
  constructor(private readonly collection: ProjectCollection) {}

  async findById(id: ProjectId): Promise<Project | null> {
    const document = await this.collection.findOne({ _id: id });
    return document ? toProject(document) : null;
  }
}
```

Service code does not change when the data layer changes:

```ts
export class GetProjectService {
  constructor(private readonly projects: ProjectRepository) {}

  async execute(input: GetProjectInput) {
    const project = await this.projects.findById(input.projectId);

    if (!project) {
      throw new NotFoundError("Project not found");
    }

    return project;
  }
}
```

Adapter mapping rules:

- Domain models do not expose raw database rows.
- Database IDs are normalized into shared/domain ID types.
- Date/time values are normalized at adapter boundaries.
- JSON columns are parsed with shared schemas.
- External enum/string values are mapped to domain enums.
- Mappers are tested.
- Migration scripts reuse mappers where possible.
- Adapters can be replaced without touching routes, UI, or services.

Data-layer migration process:

1. Add the new adapter next to the old adapter.
2. Implement the same repository interfaces.
3. Add mapper tests for the new storage shape.
4. Add a migration/export script that reads through old repositories and writes through new repositories.
5. Run migration against staging data.
6. Run service tests against both adapters.
7. Switch dependency wiring in `src/server/context.ts`.
8. Keep the old adapter read-only until production data is verified.
9. Remove the old adapter only after rollback is no longer needed.

Dependency wiring should be centralized:

```ts
export function createServerContext(env: Env): ServerContext {
  const db = createD1Client(env.DB);

  return {
    repositories: {
      projects: new D1ProjectRepository(db),
      users: new D1UserRepository(db),
    },
    services: createServices(),
  };
}
```

Changing the data layer should normally mean changing wiring plus adapter files, not the whole app.

## Mobile And Desktop Path

The first product is web-first. The architecture must still make mobile and desktop possible later.

Mobile path:

- Use Expo when a native mobile app is needed.
- Keep mobile-safe contracts in `shared/`.
- With Convex, use its React Native client against the same public functions and keep platform UI separate.
- With other backends, expose mobile APIs through stable server routes.
- Keep React web UI components separate from domain logic.
- Reuse schemas, DTOs, services where runtime-safe, and API clients.
- Build native screens separately when web components do not translate cleanly.

Desktop path:

- Use Tauri when a lightweight desktop wrapper is enough.
- Keep desktop-only file system, tray, and OS integration behind adapters.
- Let the desktop app use the same Convex backend or stable server routes as mobile when online.
- Add local persistence behind repository interfaces if offline mode becomes a requirement.

## Testing

Use test-driven development where behavior matters: domain rules, services, adapters, webhooks, paid access, migrations, agent-callable operations, and bug fixes.

Scale the test layers to the application form. A public landing page may only
need contract tests, service tests, and a build check. A SaaS app should add
route, adapter, webhook, auth, billing, and end-to-end coverage as those
capabilities appear.

Minimum checks for a real scaffold:

- `typecheck`: TypeScript strict mode across app, shared, and server code.
- `unit`: services, domain logic, selectors, mappers, and validation.
- `adapter`: D1, MongoDB, Postgres, Stripe, Resend, and storage adapters where relevant.
- `convex`: public/internal functions, authorization, validators, model helpers, indexes, Components, and scheduled workflows through `convex-test`.
- `convex integration`: important runtime behavior against a real local or isolated cloud backend when the mock cannot prove it.
- `route`: server functions and API routes.
- `webhook`: Stripe webhook signature and idempotency behavior.
- `agent evaluation`: representative tasks, forbidden outcomes, approval
  boundaries, and tool-selection behavior that deterministic tests cannot prove.
- `e2e`: signup, login, checkout, dashboard access, and subscription cancellation.

Minimum production gate:

```sh
npm run typecheck
npm run test
npm run build
```

`convex-test` is a fast mock and does not enforce every runtime limit or production behavior. Keep pure rules under ordinary unit tests, use `convex-test` for function behavior, and add real-backend or end-to-end coverage for critical auth, webhook, scheduling, search, and integration paths.

## Official References

- [TanStack Start quickstart](https://docs.convex.dev/quickstart/tanstack-start)
- [TanStack Start client integration](https://docs.convex.dev/client/tanstack/tanstack-start/)
- [Functions](https://docs.convex.dev/functions/overview)
- [Authentication](https://docs.convex.dev/auth/overview)
- [Components](https://docs.convex.dev/components)
- [Testing](https://docs.convex.dev/testing/overview)
- [Agent Mode](https://docs.convex.dev/cli/agent-mode)
- [Self-hosting](https://docs.convex.dev/self-hosting)
- [Import and export](https://docs.convex.dev/database/import-export/)
- [Pricing](https://www.convex.dev/pricing)
- [Limits](https://docs.convex.dev/production/state/limits)
