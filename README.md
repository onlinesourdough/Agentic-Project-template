# AI-first App Template

Build the smallest product that can work without assembling an expensive
supermarket stack first.

AI can produce software quickly. It can also multiply unclear architecture,
unnecessary services, weak access controls, and technical debt. This template
keeps product decisions, application boundaries, tests, monitoring, and
ownership explicit enough for both people and coding agents to understand.

It is a product-first architecture blueprint and bootstrap layer for:

- static sites and developer-product storefronts
- content libraries and internal tools
- Cloudflare-native applications
- realtime Convex applications
- products backed by an existing or specialist service

It is not a frozen starter project. Official scaffolds change over time, so the
template starts with the current official CLI and applies durable architecture,
delivery guidance, and workflows afterward.

## Five-minute quickstart

### 1. Classify the product

Choose the smallest profile that meets the product's current needs:

| Profile                                                      | Use it when                                                                                                           | Deployment                               |
| ------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| [`static-pages`](profiles/static-pages/PROFILE.md)           | The product is public and fully static                                                                                | GitHub Pages                             |
| [`cloudflare-native`](profiles/cloudflare-native/PROFILE.md) | The product needs edge endpoints or straightforward SQL persistence                                                   | Cloudflare Workers and optional D1       |
| [`convex`](profiles/convex/PROFILE.md)                       | The product needs authenticated data, realtime behavior, collaboration, scheduling, search, or shared web/native data | Cloudflare plus Convex                   |
| [`external`](profiles/external/PROFILE.md)                   | The product needs FastAPI, specialist compute, an existing database, or an independently deployed backend             | Cloudflare frontend plus an explicit API |

### 2. Create the current official scaffold

Static Pages:

```sh
npx @tanstack/cli@latest create my-product \
  --router-only \
  --blank \
  --toolchain eslint
```

Cloudflare-native:

```sh
npx @tanstack/cli@latest create my-product --deployment cloudflare
```

External backend:

```sh
npx @tanstack/cli@latest create my-product
```

Convex with TanStack Start:

```sh
npm create convex@latest -- -t tanstack-start
```

Follow the current official documentation if a CLI changes.

### 3. Apply this template

Clone this repository next to the new application, then run:

```sh
git clone --depth 1 https://github.com/gustavonline/app-template.git
```

```sh
node app-template/bin/apply-template.mjs \
  --target ./my-product \
  --profile cloudflare-native
```

Preview without writing:

```sh
node app-template/bin/apply-template.mjs \
  --target ./my-product \
  --profile cloudflare-native \
  --dry-run
```

The command copies the agent guide, architecture and delivery documents, CI,
and only the deployment workflow for the selected profile. It does not edit the
application's `package.json`; missing scripts are reported as explicit follow-up
actions.

### 4. Build one vertical slice

Read the copied `AGENTS.md`, choose the smallest user outcome, write or update
the relevant test, and add only the capabilities that slice requires.

## What AI-first means here

AI-first does not mean AI-only or maximally autonomous. It means:

- product intent and business rules are written down
- boundaries and trust decisions are explicit
- external inputs are runtime-validated
- deterministic code owns critical rules and side effects
- tests and monitoring provide evidence instead of confidence theatre
- humans can inspect, operate, recover, and hand over the system
- model, database, hosting, and vendor choices remain deliberate

## Capability menu

Use this as a menu, not a checklist:

- TypeScript, React, TanStack Start or TanStack Router
- Tailwind CSS and an optional Tailwind-compatible UI layer
- Cloudflare Workers, Pages, D1, R2, Queues, and Web Analytics when needed
- Convex for the dynamic application profile
- an explicit API for Python or independently deployed backends
- Auth.js or a Convex-compatible OIDC provider when accounts are required
- Stripe when the product charges money
- Resend when the product sends transactional email
- PostHog only when product decisions need behavioral analytics

The architecture deliberately does not install auth, billing, persistence,
analytics, queues, or AI infrastructure before the product needs them.

## Static storefronts and paid products

GitHub Pages is excellent for a public storefront, documentation, or free
resources. It is not an access-control boundary. Never include paid files,
secrets, or private source material in the Pages artifact.

Developer products can use a public static storefront, Stripe Payment Links,
and private-repository delivery when every buyer has a GitHub account. A paid
library for a broader audience should enforce entitlements on the server using
Cloudflare/D1 or Convex. See
[`docs/digital-products.md`](docs/digital-products.md).

## Proof through use

The
[static Pages reference](https://gustavonline.github.io/app-template-static-example/)
is a fresh official TanStack Router scaffold with the `static-pages` profile
applied and deployed through the included GitHub Actions workflow. Its
[source](https://github.com/gustavonline/app-template-static-example) stays
intentionally small.

[`resources.onlinesourdough.com`](https://resources.onlinesourdough.com) is the
first application migrated to these boundaries. It uses a Cloudflare-native
profile with server-side paid-content gating, shared API contracts, HTTP
adapters, feature hooks, tests, D1 migrations, and CI. Read the
[case study](docs/case-studies/onlinesourdough-resources.md).

## Repository map

- [`AGENTS.md`](AGENTS.md): operational rules for coding agents
- [`ARCHITECTURE.md`](ARCHITECTURE.md): detailed boundaries and backend models
- [`delivery/README.md`](delivery/README.md): tests, branches, CI, and releases
- [`profiles/`](profiles): adoption rules for each supported runtime shape
- [`bin/apply-template.mjs`](bin/apply-template.mjs): safe profile applicator
- [`ROADMAP.md`](ROADMAP.md): public direction and commercial boundary

## Status

`v0.1.x` is a public preview. Profile names, the apply manifest, and the core
architecture are documented, but may still change before `v1.0.0`. Breaking
changes are recorded in [`CHANGELOG.md`](CHANGELOG.md) with a migration note.

## Contributing and security

Contributions target `dev`; releases move from `dev` to `main`. Read
[`CONTRIBUTING.md`](CONTRIBUTING.md) before opening a pull request and
[`SECURITY.md`](SECURITY.md) before reporting a vulnerability.

MIT licensed. Built by Arc'IT and available through Online Sourdough Resources.
