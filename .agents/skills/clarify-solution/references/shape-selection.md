# Shape Selection

Select by repository responsibility, not by framework or perceived prestige.

| Shape       | Choose when this repository owns                           | Typical examples                                                     |
| ----------- | ---------------------------------------------------------- | -------------------------------------------------------------------- |
| Application | A human-facing experience                                  | Landing page, content library, portal, dashboard, full-stack product |
| Service     | One reusable technical capability behind a stable contract | Image renderer, calculation API, worker, bounded domain capability   |
| Automation  | A triggered or scheduled sequence of operational steps     | n8n workflow, scheduled job, event-driven process                    |
| Integration | Translation and reliable delivery between existing owners  | Webhook receiver, adapter, proxy, sync boundary                      |
| System      | Cross-repository technical truth and operation             | Infrastructure, topology, ownership map, runbooks                    |

## Choose the smallest boundary

- Use an **Application** when the value is primarily delivered through a user
  interface. A static public site is still an Application.
- Use a **Service** when multiple callers need the same deterministic or
  specialist capability and it deserves independent deployment or ownership.
  Call it a Service; do not split it further merely to use a distributed style.
- Use an **Automation** when the main artifact is the sequence itself. Keep
  orchestration in n8n or the chosen workflow runtime and move substantial,
  reusable, or test-sensitive logic into a Service only when that boundary
  earns its cost.
- Use an **Integration** when both upstream and downstream remain authoritative
  and this repository owns mapping, delivery, and reconciliation—not the data.
- Use a **System** when the deliverable is architecture or infrastructure truth,
  not fake runtime code.

One outcome may require several repositories with different shapes. Do not make
one repository own unrelated responsibilities.

## AIOS agent work versus technical automation

Keep work in AIOS when an agent primarily reasons with business context and
skills, even if Codex Automations schedules it. That is an agentic operating
routine, not automatically a Solution Template Automation.

Use this template when there is a separate technical artifact to build and
operate:

- an n8n workflow with triggers, credentials, retries, replay, and activation
- a scheduled or event-driven program
- a stable Service called by a workflow
- an Integration between systems
- an Application or System change

A mixed design is normal:

```text
AIOS or human intent
  → n8n orchestration
    → small Service for deterministic specialist work
      → existing system of record
```

Keep context and reasoning with AIOS, orchestration with the workflow owner,
bounded computation with the Service, and authoritative data with its existing
owner.

## Application profiles

- `static-pages`: public build output only; landing pages and public content
  libraries fit here.
- `cloudflare-native`: edge application with optional server routes and D1.
- `convex`: application whose web and backend release as one coordinated unit.
- `external`: frontend consuming an independently deployed backend.
