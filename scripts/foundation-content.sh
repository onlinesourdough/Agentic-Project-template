#!/usr/bin/env bash
# Sourced by create-project.sh after destination and input validation.
# The caller supplies these validated generation inputs; fail on a broken call.
: "${project_name:?}" "${project_outcome:?}" "${in_place:?}" "${source_url?}"
: "${source_sha?}" "${canonical_url?}" "${staging_directory:?}" "${project_kind:?}"

markdown_name="$project_name"
markdown_name="${markdown_name//\\/\\\\}"
markdown_name="${markdown_name//\`/\\\`}"
markdown_name="${markdown_name//\[/\\[}"
markdown_name="${markdown_name//\]/\\]}"
markdown_outcome="$project_outcome"
markdown_outcome="${markdown_outcome//\\/\\\\}"
markdown_outcome="${markdown_outcome//\`/\\\`}"
markdown_outcome="${markdown_outcome//\[/\\[}"
markdown_outcome="${markdown_outcome//\]/\\]}"

if [[ -n "$canonical_url" ]]; then
  canonical_section="Canonical URL: [$canonical_url]($canonical_url)"
else
  canonical_section='Canonical location: this repository.'
fi

provenance='This repository was created from template material. The creation source was not recorded by this route.'
if $in_place; then
  provenance="Creation source: $source_url@$source_sha. This is historical provenance, not a runtime dependency."
fi

cat > "$staging_directory/AGENTS.md" <<EOF
# $markdown_name

Read [README.md](README.md) for the outcome and actual entrypoints and
[docs/README.md](docs/README.md) for the canonical foundation records. Read
only the context relevant to the change.

Discover installed AIOS methods through the native harness: aios-spec-work for
unresolved scope or technology, aios-build-work for implementation,
aios-review-work for acceptance, and aios-ship-work for authorized delivery.
For explicit foundation repair or transition to a software/defence factory,
use aios-project-foundation when available. Ordinary creation does not
authorize provisioning. Missing methods do not change this repository's
authority or make the product depend on AIOS at runtime.

Work in the current task; verify the selected root and keep one writer per
overlapping change. Preserve accepted action and destination authority.
Use synthetic fixtures and keep credentials and private data out of source,
logs, exports and client builds. Validate external input; enforce protected
actions at a trusted boundary. Make retried effects safe and bound resource use.
Add dependencies and infrastructure only for demonstrated responsibilities.

Update each owning document with ordinary code changes, or state why it has no
impact. Record checks and durable version-bound proof in CI/PR records linked
from [docs/README.md](docs/README.md). Review the diff, fix in-scope findings,
and report observed results and limits. [CLAUDE.md](CLAUDE.md) imports this
single instruction source. Local specialist methods belong in the
[skill index](.agents/skills/README.md), not copied generic AIOS procedures.
EOF
printf '%s\n' '@AGENTS.md' > "$staging_directory/CLAUDE.md"

cat > "$staging_directory/README.md" <<EOF
# $markdown_name

## Intended outcome

$markdown_outcome

$canonical_section

## Current state

This is a new repository with foundation documentation only. No application,
runtime, build, test, deployment, security control or outcome has been verified
by creation. The next implementation task must establish actual entrypoints,
checks and operational facts under its own authority.

## Work here

Start with [AGENTS.md](AGENTS.md), [CONTRIBUTING.md](CONTRIBUTING.md) and the
[documentation index](docs/README.md). Record real setup, interface and check
commands here when implemented. The repository starts with empty Git history
and no remote; the owner decides the first commit and canonical remote.

## Ownership and licensing

This repository is the technical source of truth. The responsible product and
operation owner has not been supplied; record that decision in this section
or the applicable operations record when established.

Licensing for newly authored project material is an unresolved owner decision.
[Template license notice](docs/template-license.txt) applies only to
template-derived starter material. It does not select a product license.

$provenance
EOF

cat > "$staging_directory/CONTRIBUTING.md" <<EOF
# Contributing

Use main plus short task branches until an owner accepts another branch policy.
Make a focused change, run the relevant implemented checks, review its diff,
and update the owning docs in the same change or explain no impact. Put
version-bound check and review evidence in the CI run or PR; link durable
records from [docs/README.md](docs/README.md) as they exist. A date-only
documentation refresh is not evidence.

For parallel agent tasks, use isolated checkouts fixed to a source SHA. Recheck
a reviewed patch when its base or candidate changes. No GitHub protections,
checks or deployment are enabled by these instructions alone.

Keep credentials and private security reports out of public issues and PRs.
Until a private reporting route is established, contact the repository owner
through an existing private channel. Do not publish exploit details to create
a reporting route.
EOF

cat > "$staging_directory/docs/README.md" <<EOF
# Documentation

[README](../README.md) owns the outcome, current state, entrypoints, owner and
creation provenance. [AGENTS](../AGENTS.md) owns compact agent behavior.
[Contributing](../CONTRIBUTING.md) owns the contribution workflow.

Durable proof belongs in version-bound CI runs and PR records, linked here when
they exist. No implementation, CI run, PR review, deployment or outcome
measurement exists at creation. Record the revision, check, result and link
when evidence is produced.

Template-derived material carries a [scoped license notice](template-license.txt).
EOF

case "$project_kind" in
  general) ;;
  application|api|cli)
    cat >> "$staging_directory/docs/README.md" <<EOF

## Application records

[Architecture](../ARCHITECTURE.md) owns system boundaries and data flow.
[Design](../DESIGN.md) owns user interaction or interface contracts.
[Security](../SECURITY.md) owns trust boundaries and private reporting.
[Operations](operations.md) owns runbooks, ownership and operating evidence.
[Deployment](deployment.md) owns release, rollback and recovery.
[Infrastructure](infrastructure.md) owns selected environment resources.
These records start with known facts and explicit decisions still needed.
EOF

    cat > "$staging_directory/ARCHITECTURE.md" <<EOF
# Architecture

The intended outcome is: $markdown_outcome

No stack, components, data stores, network boundaries or runtime have been
selected by repository creation. During implementation, record the real
components, their responsibilities, data flow, trust boundaries and material
decisions here. Prefer one deployable unit until a second boundary has a
demonstrated responsibility. Link authoritative interface details from
[DESIGN.md](DESIGN.md) and operational resources from
[infrastructure.md](docs/infrastructure.md).
EOF

    if [[ "$project_kind" = application ]]; then
      cat > "$staging_directory/DESIGN.md" <<EOF
# Design

The intended outcome is: $markdown_outcome

No users, journeys, visual system or accessibility evidence were supplied.
During implementation, record actual users and critical journeys, interaction
and content decisions, responsive and accessible behavior, and the evidence
used to verify them. Keep working assets in design/ only when needed.
EOF
    else
      cat > "$staging_directory/DESIGN.md" <<EOF
# Interface contract

The intended outcome is: $markdown_outcome

The selected interface kind is $project_kind. No commands or endpoints,
schemas, authentication, error behavior or compatibility policy were supplied.
During implementation, record actual operations, inputs, outputs, errors,
versioning and examples here. Verify them through the real interface and link
version-bound evidence from [docs/README.md](docs/README.md).
EOF
    fi

    cat > "$staging_directory/SECURITY.md" <<EOF
# Security

No interface exposure, identity provider, authorization policy, security
contact or deployment environment has been supplied. During implementation,
classify each interface as local, public or protected; record trusted
authorization boundaries, sensitive data handling and verified denial paths.
Keep private reports out of public issues. The owner must establish a private
reporting contact before inviting external reports; until then, use an existing
private owner channel. Do not publish an unverified security contact.
EOF

    cat > "$staging_directory/docs/operations.md" <<EOF
# Operations

The operator, support route, service level, observability and operating
schedule are not established. Record the real owner, critical journeys,
health signals, incident route and runbooks here when implemented.

Default contribution flow is main plus short task branches. Before application
or factory code is merged, implement relevant required PR checks and a complete
verification and build batch every three hours. Scope PR lanes
conservatively, retaining necessary builds and tests. Cancel superseded PR
runs and serialize full work. Do not add a duplicate push workflow.

A scheduled interval needs a full run only when its exact revision lacks a
successful full scheduled or manual result. Its idle path is one small metadata
job without checkout, build, test or an extra acceptance runner; even that job
uses some Actions runtime. Manual full runs always execute. PR, manual and
missing-decision acceptance must not silently skip. Choose and verify actual
jobs, triggers and protections during implementation; these words enable none.

An optional dev branch needs explicit base and PR targets, promotion checks
and synchronization. Staging does not itself require dev or production
deployment. Link actual run and incident evidence from the [proof index](README.md).
EOF

    cat > "$staging_directory/docs/deployment.md" <<EOF
# Deployment and recovery

No provider, environment, artifact, release process or deployment authority
has been selected. Select actual targets during implementation; verify staging
or preview, rollback and a critical journey before CD. Do not infer a cloud
provider or Kubernetes from the project name.

When a release path exists, record the exact artifact and revision, required
configuration, promotion checks, disable or rollback steps, restore or replay
steps for stateful effects, and recovery rehearsal evidence. Link version-bound
results from the [proof index](README.md). No recovery path is tested at creation.
EOF

    cat > "$staging_directory/docs/infrastructure.md" <<EOF
# Infrastructure

No compute, database, queue, container, IaC, domain or secret store has been
selected. Record only deployed or accepted resources, ownership, configuration
source, cost bounds and restore dependencies as they become real. Stack-specific
manifests, lockfiles, pins, executable checks, safe config examples and
.dockerignore belong to their implementation and verification change.
EOF
    ;;
esac
