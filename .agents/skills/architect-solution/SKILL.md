---
name: architect-solution
description: Design or revise the smallest owned software architecture, including solution boundaries, TypeScript or Python stack, dependency direction, data ownership, REST or other API contracts, integrations, and deployment units. Use before consequential implementation or when architecture, coupling, framework, persistence, or interface decisions need review.
---

# Architect Solution

Choose architecture after responsibility and acceptance are understood.

## Read

Read the selected shape, optional Application profile, current code and
contracts, and `references/architecture-principles.md`.

Read `references/api-design.md` when the solution exposes or consumes HTTP,
webhooks, public functions, queues, or another cross-owner contract.

## Design

1. State what the repository owns, consumes, and deliberately does not own.
2. Map actors, entrypoints, authoritative data, external systems, trust
   boundaries, and deployment units.
3. Reuse or buy non-core capabilities before creating a new owner.
4. Select the simplest runtime and current official scaffold that fit existing
   ownership and operator capability.
5. Define dependency direction and stable contracts before framework details.
6. Decide data, identity, failure, observability, and recovery ownership.
7. Check that the first vertical slice can be built and deployed independently
   of hypothetical future requirements.

Prefer TypeScript for web applications, shared web contracts, and integrations
where its ecosystem fits. Prefer Python for data, scientific, image, ML, or
existing Python workloads. Existing team and runtime ownership outrank either
default.

## Record only durable decisions

Return a compact architecture decision:

- shape, profile, runtime, and deployment unit
- owners and boundaries
- components and dependency direction
- contracts and source of truth
- first slice
- rejected complexity and non-goals
- risks that require a test, security review, or operational control

Update an existing README or architecture section when useful. Create an ADR
only for a costly, durable, or hard-to-reverse decision. Route visual and
handover documentation to `document-solution`.
