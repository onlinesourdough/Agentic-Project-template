# Online Sourdough Resources

[`resources.onlinesourdough.com`](https://resources.onlinesourdough.com) is the
first product migrated to the AI-native Solution Template boundaries.

## Product shape

It is a paid, practical library for guides, lessons, templates, tools, and
software resources. It deliberately avoids becoming a heavy course or community
platform before those capabilities are needed.

## Selected profile

Cloudflare-native:

- React frontend hosted on Cloudflare
- Cloudflare Functions for server-owned routes
- D1 for entitlement state and migrations
- Stripe and email integrations behind server boundaries
- server-side paid-content redaction

## Template boundaries in use

- shared API contracts define browser/server shapes
- HTTP calls live behind adapters
- feature hooks own UI-facing remote state
- route and shell components do not own vendor transport details
- paid access is enforced by the backend
- tests cover route normalization, runtime API policy, and content redaction
- CI runs lint, typecheck, tests, and build

## What this proves

The template can guide an authenticated paid-content product without installing
every possible SaaS capability or forcing it through a frozen starter project.
The architecture was applied to an existing application incrementally and kept
the product deployable throughout the migration.

This is proof of adoption, not a universal performance or cost claim. Future
case studies should publish measured baselines before describing a result as
proven.
