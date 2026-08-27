# Optional orchestration boundary tracer

This sanitized fixture is copied with every generated Project as technology
selection evidence. It proves a small deterministic service can remain
code-owned while an optional workflow runtime owns visible orchestration. It is
not an n8n installation, a workflow catalogue, a provider recommendation, or a
runtime dependency.

## Scenario and readiness

The representative Project normalizes up to four internal work items for a
human approval. Its initial envelope is at most 25 deliveries and 100 items in
one calendar month. There is no customer data, external send, credential, or
live workflow in this fixture.

The Project owns the request/result schemas, deterministic normalization,
idempotency record, tests, workflow digest, and local recovery replay. A
workflow owner may own a visible trigger, approval wait, schedule, integration
sequence, bounded retry, and error route. The workflow platform owner separately
owns hosting, identity, credential binding, upgrades, backups, restore, and
availability. Importing, activating, scheduling, binding credentials, or
calling an external system needs separate Ship authority.

## Technology decision

**Current explicit selection: code-only.** The Project uses the deterministic
service and local replay without a workflow runtime. The representative has no
confirmed workflow-platform capacity, backup/restore rehearsal, or accountable
platform owner for an activated workflow, so a hybrid cannot yet be the
smallest reliable operating shape. This leaves the service independently useful
and the human approval visible through the Project's existing manual process.

Observed 2026-08-27 from [n8n pricing](https://n8n.io/pricing/): Cloud plans
are measured by monthly workflow executions, where one execution is one full
workflow run regardless of its steps; the current Starter and Pro free trials
include 2,500 executions. This tracer's maximum 25 deliveries would be 25
executions only if each delivery causes one full run. A free trial does not
prove a durable operating capacity or ownership boundary, so it is not selected
as the Project's runtime.

| Shape | Decision | Why |
| --- | --- | --- |
| Code-only | Selected | The smallest current owner: deterministic normalization, schema validation, conflict-safe idempotency, error result, and replay all operate without an external runtime. |
| Workflow-only | Rejected for this scenario | A Code node would make reusable deterministic normalization, schemas, and recovery less independently testable and owned. |
| Hybrid | Eligible alternative, not selected | It becomes smaller only after an existing named platform owner confirms current capacity and recovery and visible approval, trigger, schedule, integration, bounded retry, and error routing actually require a workflow runtime. The service retains domain truth. |

The apparently free static-delivery option is rejected: it cannot own the
trusted service contract or visible approval path and would shift the missing
runtime and recovery burden elsewhere. This is an ownership decision, not a
price comparison.

Current official evidence consulted for a real decision:

- [n8n pricing](https://n8n.io/pricing/) for the dated execution basis and
  current 2,500-execution Starter/Pro trial boundary above.
- [n8n Insights](https://docs.n8n.io/administer/observe-and-log/track-usage-with-insights)
  for the production-execution view a future workflow platform owner would use.
- [n8n queue mode](https://docs.n8n.io/deploy/host-n8n/configure-n8n/scaling/enable-queue-mode)
  for one documented runtime operating model.
- [GitHub Pages limits](https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits)
  for the rejected static-delivery candidate's boundary.

For a future hybrid, the designated workflow platform owner—not the Project
code owner—observes the n8n Insights production-execution count and error
route, plus the trial-expiry date in the approved platform's billing view. The
exact re-evaluation trigger is any one of: 20 executions in one calendar month
(five before the 25-delivery envelope), a trial expiry within seven calendar
days, or a dated pricing-page check that no longer confirms the execution basis
and 2,500-execution trial observation above. Evidence of any trigger stops
activation or scale-up until that owner records current capacity for at least
25 executions, backup/restore evidence, and an exit to code-only replay. Until
then, the current code-only Project operator records deliveries locally and
does not activate a workflow. The recovery path is to disable any future
workflow, retain delivery identifiers, and run the local mock replay after
correcting the safe input.

No portable n8n skill is justified by this one tracer. Repeated reviewed
evidence would be required before proposing one.

## Local proof

Run from a generated Project or this seed with Node.js installed:

```sh
node .agents/skills/choose-technology/examples/optional-n8n-boundary-tracer/test/replay.mjs
```

The test executes both versioned JSON Schema documents through a test-local
evaluator, fails if either uses vocabulary the evaluator does not implement,
and cross-checks representative cases at the service boundary. It proves
invalid and whitespace-only input, timeout, bounded retry, identical duplicate
delivery/idempotency, conflicting delivery-ID reuse and error routing, partial
failure, sanitized workflow digest, and deterministic mock replay. It does not
contact n8n or an external service.

The [workflow digest](workflow/n8n-workflow.digest.json) is deliberately not an
importable live export. It records only the reviewed orchestration boundary and
contains no credentials, private endpoint, instance identifier, or customer
data.
