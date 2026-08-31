---
name: choose-technology
description: Select the smallest technology after responsibilities, ownership, risks, operation, recovery, and proof are known. Use only for a new or materially changed technology decision; bypass a working stack when the change does not materially alter it, and identify concrete specialist gaps without copying generic management skills into the Project.
---

# Choose Technology

Use this as the only project technology-selection procedure. It is a
conditional decision aid, not a default stack catalog, install manifest, or
reason to preload stack-specific skills.

## Route

1. Run `spec-project` first. The intended result, served party, ownership,
   boundaries, risks, operation, recovery, and proof must be resolved enough
   for a Build contract.
2. If a working stack already owns the responsibilities and the change does
   not materially alter technology, bypass this skill. Record the existing
   stack as the resolved decision and go directly to `build-project`.
3. For a new or materially changed technology decision, select the smallest
   capabilities after the contract is ready. Do not choose from popularity or
   from a starter's included layers.
4. If a concrete specialist implementation gap remains, follow the inventory
   and authority boundary in the [local skill index](../README.md). Add only a
   justified, reviewed Project- or domain-specific local skill; do not install
   or invent stack-specific skills in the Project.
5. Hand the resolved decision and its evidence to `build-project`. Build
   consumes that decision and does not preload every technology reference.

## Select the smallest fit

For each material responsibility, name its owner and choose Build, Buy, Rent,
or Self-host. Reuse a working system with a clear owner; build only
differentiating or ownership-critical capability. Choose the smallest runtime that can deliver and recover
the first complete result. Buy or rent generic capability when
reduced operation justifies the dependency and exit path. Self-host only when
license, updates, security, observability, backup, and recovery have an owner.

Derive candidates from the Project's resolved responsibilities, current
systems, constraints, and owners. Inspect current official sources for the
smallest plausible options only after those facts are known; compare their
contracts, operating burden, failure and recovery behavior, update path, and
exit path. Do not retain a starter catalogue or default stack in Project truth.

Do not add authentication, persistence, queues, containers, observability
services, or runtime AI because a starter includes them. Each layer needs one
demonstrated responsibility and one owner.

For a material external capability, inspect current official documentation,
pricing or plan limits, license, operational responsibilities, and exit options
when they can affect architecture, cost, ownership, or handover. Record the
observation date and source link with the decision evidence. Do not copy
volatile prices into Project guidance, create a free-tier catalogue, or treat a
discovery catalogue as pricing authority.

## Cost and usage acceptance case

When an initial low-cost or low-usage assumption can alter the chosen shape,
make it an explicit acceptance case before selection. This is evidence for a
specific Project, not a default provider recommendation:

1. State the realistic initial usage envelope and the compute, storage, egress,
   workflow, database, API, or other boundary that could create an overage.
2. Eliminate a capability that the Project does not need, and compare the
   smallest code-only, managed/workflow-only, and hybrid shapes when each could
   plausibly own the responsibility.
3. For each material external candidate, record a dated link to current
   official plan, limit, or pricing terms; record only the material conclusion,
   not a copied price table. Discovery catalogues can suggest candidates but
   are not fit or pricing evidence.
4. Name the owner who sees usage or failure, one bounded guardrail, the stop
   condition that requires re-evaluation before activation or scale-up, and the
   backup, recovery, and replacement path.
5. Reject an apparently free option when it cannot own the contract, hides an
   overage boundary, or moves unacceptable operations to the owner. Explain why
   the selected shape is smaller in total responsibility, not merely in price.

A concrete Project selects an orchestration runtime, schemas, tests, or
workflows only when real responsibilities justify them. Visible triggers,
approvals, schedules, integrations, bounded retries, and error routing may
belong to that runtime; reusable deterministic domain logic remains in tested
Project code and can be replayed independently. The template supplies no
orchestration default or bundled runtime artifacts.

Before accepting the decision, verify that:

- each role and source of truth is explicit;
- contracts can be checked by types, schemas, validators, or tests;
- build, operation, failure, and recovery are observable;
- secrets and operational state remain outside source code; and
- the operator can maintain or replace every selected capability after
  handover.

Language popularity is not proof of fit. Existing systems and owners win.

## Return one decision

Record one explicit technology decision with:

- the responsibilities, source of truth, owner, and trust boundary;
- existing systems reused and Build, Buy, Rent, or Self-host choices;
- fit evidence and the operator burden for every added layer;
- contracts, dependencies, cost or license concerns, and failure behavior;
- verification for build, operation, denial or failure, and recovery;
- dated official cost or usage evidence, guardrail, visibility owner, and stop
  condition when cost or usage affects the decision; and
- update and replacement or exit paths; and
- residual risks and any capability gap routed through the selected harness's
  authorized method.

Do not return a catalog of unselected stacks. If the decision is not
independently justified, keep the existing stack or choose the smaller
capability and continue to `build-project`.
