#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  bash scripts/create-project.sh DESTINATION --name "Project Name" \
    --outcome "The intended Project outcome" [--canonical-url URL]

  bash scripts/create-project.sh --in-place --name "Project Name" \
    --outcome "The intended Project outcome" --source-url URL \
    --source-sha SHA [--canonical-url URL]

DESTINATION must not already exist. --in-place converts the clean, verified APT
seed at the current Git root. Both routes create a fresh Project with no Git
commit and no remote.
USAGE
}

fail() {
  printf 'create-project: %s\n' "$1" >&2
  exit 1
}

if [[ $# -eq 0 ]]; then
  usage >&2
  exit 1
fi

in_place=false
destination_input=''
case "$1" in
  --help)
    usage
    exit 0
    ;;
  --in-place)
    in_place=true
    shift
    ;;
  *)
    destination_input="$1"
    shift
    ;;
esac
project_name=''
project_outcome=''
canonical_url=''
source_url=''
source_sha=''

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)
      [[ $# -ge 2 ]] || fail "--name requires a value"
      project_name="$2"
      shift 2
      ;;
    --outcome)
      [[ $# -ge 2 ]] || fail "--outcome requires a value"
      project_outcome="$2"
      shift 2
      ;;
    --canonical-url)
      [[ $# -ge 2 ]] || fail "--canonical-url requires a value"
      canonical_url="$2"
      shift 2
      ;;
    --source-url)
      [[ $# -ge 2 ]] || fail "--source-url requires a value"
      source_url="$2"
      shift 2
      ;;
    --source-sha)
      [[ $# -ge 2 ]] || fail "--source-sha requires a value"
      source_sha="$2"
      shift 2
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

[[ -n "$project_name" ]] || fail "--name is required"
[[ -n "$project_outcome" ]] || fail "--outcome is required"

if $in_place; then
  [[ -n "$source_url" ]] || fail "--source-url is required with --in-place"
  [[ -n "$source_sha" ]] || fail "--source-sha is required with --in-place"
else
  [[ -n "$destination_input" ]] || fail "destination is required"
  [[ -z "$source_url" && -z "$source_sha" ]] ||
    fail "--source-url and --source-sha require --in-place"
  case "$destination_input" in
    */) fail "destination must not end with a slash" ;;
  esac
fi

case "$project_name" in
  *$'\n'*|*$'\r'*) fail "--name must be a single line" ;;
esac
case "$project_outcome" in
  *$'\n'*|*$'\r'*) fail "--outcome must be a single line" ;;
esac

if [[ -n "$canonical_url" ]]; then
  case "$canonical_url" in
    http://*|https://*) ;;
    *) fail "--canonical-url must begin with http:// or https://" ;;
  esac
  case "$canonical_url" in
    *$'\n'*|*$'\r'*|*[[:space:]]*|*'('*|*')'*|*'['*|*']'*)
      fail "--canonical-url contains unsupported characters"
      ;;
  esac
fi

if $in_place; then
  case "$source_url" in
    http://*|https://*) ;;
    *) fail "--source-url must begin with http:// or https://" ;;
  esac
  case "$source_url" in
    *$'\n'*|*$'\r'*|*[[:space:]]*|*'('*|*')'*|*'['*|*']'*|*'`'*)
      fail "--source-url contains unsupported characters"
      ;;
  esac
  [[ "$source_sha" =~ ^[0-9a-f]{40}$ ]] ||
    fail "--source-sha must be a full lowercase 40-character Git SHA"
fi

source_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
[[ -d "$source_root/.agents/skills" ]] || fail "missing local skills"
[[ -f "$source_root/.agents/skills/README.md" ]] || fail "missing local skill index"
[[ -f "$source_root/LICENSE" ]] || fail "missing license"

verify_in_place_seed() {
  local seed_root="$1"
  local git_top source_branch source_remotes actual_source_url actual_push_url
  local actual_source_sha source_status

  git_top="$(git -C "$seed_root" rev-parse --show-toplevel 2>/dev/null)" ||
    fail "--in-place source is not a Git worktree"
  [[ "$git_top" = "$seed_root" ]] ||
    fail "--in-place source is not the exact Git top level"
  source_branch="$(git -C "$seed_root" symbolic-ref --quiet --short HEAD 2>/dev/null)" ||
    fail "--in-place source must be on branch main"
  [[ "$source_branch" = main ]] ||
    fail "--in-place source must be on branch main"
  source_remotes="$(git -C "$seed_root" remote)"
  [[ "$source_remotes" = origin ]] ||
    fail "--in-place source must have only the origin remote"
  actual_source_url="$(git -C "$seed_root" remote get-url --all origin 2>/dev/null)" ||
    fail "--in-place source has no origin URL"
  [[ "$actual_source_url" = "$source_url" ]] ||
    fail "--in-place source URL mismatch: expected $source_url"
  actual_push_url="$(git -C "$seed_root" remote get-url --push --all origin 2>/dev/null)" ||
    fail "--in-place source has no origin push URL"
  [[ "$actual_push_url" = "$source_url" ]] ||
    fail "--in-place source push URL mismatch: expected $source_url"
  actual_source_sha="$(git -C "$seed_root" rev-parse HEAD 2>/dev/null)" ||
    fail "--in-place source has no HEAD revision"
  [[ "$actual_source_sha" = "$source_sha" ]] ||
    fail "--in-place source revision mismatch: expected $source_sha"
  source_status="$(git -C "$seed_root" status --porcelain=v1 \
    --untracked-files=all --ignored=matching)"
  [[ -z "$source_status" ]] || fail "--in-place source must be clean"
}

if $in_place; then
  current_root="$(pwd -P)"
  [[ "$current_root" = "$source_root" ]] ||
    fail "--in-place must run from the APT seed root: $source_root"
  verify_in_place_seed "$source_root"

  destination="$source_root"
  destination_parent="$(dirname "$source_root")"
  destination_name="$(basename "$source_root")"
else
  destination_name="$(basename "$destination_input")"
  destination_parent_input="$(dirname "$destination_input")"
  [[ "$destination_name" != "." && "$destination_name" != ".." ]] ||
    fail "destination must name a child directory"
  [[ -d "$destination_parent_input" ]] ||
    fail "destination parent must already exist: $destination_parent_input"

  destination_parent="$(cd "$destination_parent_input" && pwd -P)"
  destination="$destination_parent/$destination_name"
  case "$destination/" in
    "$source_root/"*) fail "destination must be outside the seed" ;;
  esac
  if [[ -e "$destination" || -L "$destination" ]]; then
    fail "destination already exists: $destination"
  fi
fi

staging_directory="$(mktemp -d "$destination_parent/.project-create.XXXXXX")"
recovery_directory=''
seed_moved=false
project_installed=false
cleanup() {
  local exit_status=$?
  trap - EXIT HUP INT TERM
  set +e

  if [[ -n "$staging_directory" && -e "$staging_directory" ]]; then
    rm -rf "$staging_directory"
  fi

  if $seed_moved && ! $project_installed; then
    if [[ ! -e "$source_root" && -d "$recovery_directory" ]]; then
      if mv "$recovery_directory" "$source_root"; then
        printf 'create-project: restored verified seed after failed transition: %s\n' \
          "$source_root" >&2
      else
        printf 'create-project: recovery required; verified seed retained at: %s\n' \
          "$recovery_directory" >&2
      fi
    elif [[ -d "$recovery_directory" ]]; then
      printf 'create-project: recovery required; verified seed retained at: %s\n' \
        "$recovery_directory" >&2
    fi
  elif $project_installed && [[ -d "$recovery_directory" ]]; then
    printf 'create-project: recovery cleanup required; verified seed retained at: %s\n' \
      "$recovery_directory" >&2
  elif [[ -n "$recovery_directory" && -d "$recovery_directory" ]]; then
    rmdir "$recovery_directory" 2>/dev/null ||
      printf 'create-project: unused recovery directory retained at: %s\n' \
        "$recovery_directory" >&2
  fi

  exit "$exit_status"
}
trap cleanup EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

mkdir -p "$staging_directory/.agents"
cp -R "$source_root/.agents/skills" "$staging_directory/.agents/skills"
cp "$source_root/LICENSE" "$staging_directory/LICENSE"

cat > "$staging_directory/.gitignore" <<'GITIGNORE'
.DS_Store
node_modules/
dist/
build/
coverage/
.cache/
.tmp/
.env
.env.*
!.env.example
GITIGNORE

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

historical_provenance=''
if $in_place; then
  historical_provenance="## Historical provenance

- Creation source: \`$source_url@$source_sha\`
- This reference records the source used at creation. It is not a runtime
  dependency or a competing source of Project truth.
"
fi

cat > "$staging_directory/AGENTS.md" <<EOF
# $markdown_name

Build and operate the smallest independent Project that creates this outcome:

> $markdown_outcome

## Start

Read this file and [README.md](README.md), then only the canonical context
relevant to the change. Revisit independent ownership when it changes. Run the
project-local Spec before implementation when scope, ownership, boundaries,
proof, or contracts are not already clear.

Ask one question only when a missing owner decision materially changes the
Project. Keep resolved context intact and record technical inferences locally.

## Route

| Work | Skill |
| --- | --- |
| Technical scope, boundaries, proof, or contracts | \`.agents/skills/spec-project/SKILL.md\` |
| New or materially changed technology decision | \`.agents/skills/choose-technology/SKILL.md\` |
| Implementation | \`.agents/skills/build-project/SKILL.md\` |
| Correctness, security, simplicity, and proof review | \`.agents/skills/review-project/SKILL.md\` |
| Authorized delivery, deployment, activation, or recovery | \`.agents/skills/ship-project/SKILL.md\` |
| Periodic whole-repository health check | \`.agents/skills/audit-project/SKILL.md\` |

See the [local skill index](.agents/skills/README.md) for the flat layout,
ownership boundary, and specialist-gap route.

Keep one lifecycle record across Spec, Build, Review, revisions, and any
authorized Ship. The Project repository is canonical after creation.
For a clear mechanical change, record only the delta and its check in the
current session; do not recreate a full specification or lifecycle record.

## Before completion

Verify behavior through the real interface or validator. Run affected checks
supported by the Project, proportional to risk. Check failure,
denial, duplicate, and recovery behavior as relevant. Keep the README and
[proof record](docs/proof.md) current with actual evidence.

## Ownership and recovery

Record current responsibility in [docs/ownership.md](docs/ownership.md),
acceptance evidence in [docs/proof.md](docs/proof.md), and the tested recovery
path in [docs/recovery.md](docs/recovery.md). Keep secrets and private data out
of source, logs, exports, and client builds.
EOF

cat > "$staging_directory/README.md" <<EOF
# $markdown_name

## Outcome

$markdown_outcome

This repository is the canonical home of the Project. It owns the Project's
instructions, skills, implementation, proof, recovery, and lifecycle. Context
from other repositories or systems is copied as needed and is not a runtime
dependency.

$canonical_section

## Start

Read [AGENTS.md](AGENTS.md), then consult the ownership, proof, or recovery
records in [docs/](docs/) when relevant to the change. Run the project-local
Spec when a build-ready technical contract is not already resolved. Continue from this repository root
for Build, Review, authorized Ship, and operation.

## Lifecycle

\`intent → project-local spec → build ↔ review → authorized ship → owned result\`

The public local routes are:

- [Spec](.agents/skills/spec-project/SKILL.md)
- [Technology choice](.agents/skills/choose-technology/SKILL.md), only for a
  new or materially changed decision
- [Build](.agents/skills/build-project/SKILL.md)
- [Review](.agents/skills/review-project/SKILL.md)
- [Ship](.agents/skills/ship-project/SKILL.md), only with owner authority
- [Audit](.agents/skills/audit-project/SKILL.md), periodically
- [Local skill index](.agents/skills/README.md)

## Ownership and recovery

- [Ownership](docs/ownership.md) records the owner and canonical sources.
- [Proof](docs/proof.md) records acceptance and outcome measurement.
- [Recovery](docs/recovery.md) records rollback, rebuild, restore, replay, or
  reconciliation evidence as the Project requires.

The repository was initialized with fresh empty Git history and no remote. The
Project owner makes the first commit and adds a canonical remote when ready.
See [LICENSE](LICENSE) for the applicable license.
EOF

mkdir -p "$staging_directory/docs"
cat > "$staging_directory/docs/ownership.md" <<EOF
# Ownership

## Canonical Project

- Name: $markdown_name
- Outcome: $markdown_outcome
- Technical source of truth: this repository
- Lifecycle owner: record the person or team responsible for decisions,
  operation, and handover

## Responsibilities

Record one owner for each material responsibility, data source, external
dependency, trust boundary, and operational decision. Link to the authoritative
contract rather than copying it into this record.

| Responsibility | Source of truth | Owner | Failure or escalation route |
| --- | --- | --- | --- |
| Project outcome | [README.md](../README.md) | To be recorded | To be recorded |
| Implementation | This repository | To be recorded | To be recorded |
| Operation | To be recorded | To be recorded | To be recorded |
| Recovery | [recovery.md](recovery.md) | To be recorded | To be recorded |

## Boundary

The Project is canonical after creation. Context providers and adjacent
repositories may be referenced as inputs, but they do not own this Project's
runtime truth.

$historical_provenance
EOF

cat > "$staging_directory/docs/proof.md" <<EOF
# Proof

## Intended outcome

$markdown_outcome

## Acceptance evidence

Record the real interface, validator, rehearsal, or runtime journey that proves
the outcome. Keep command output or links to durable evidence with the change.

- [ ] Success behavior verified
- [ ] Invalid or denied behavior checked where relevant
- [ ] Duplicate, partial-failure, and recovery behavior checked where relevant
- [ ] Documentation and local links checked

## Security and denial evidence

Classify each interface as local-only, intentionally public, or protected and
record its callers and trust boundary. When protection is relevant, record the
chosen authentication mechanism, server-side authorization rule, and evidence
for a permitted request plus missing, invalid, expired or replayed, and
authenticated-but-forbidden requests as applicable.

- [ ] Production security misconfiguration fails closed where protection is required
- [ ] Secrets and private data are absent from source, client builds, logs, and
  evidence
- [ ] External input, resource use, retries, concurrency, and cost are bounded
  as relevant
- [ ] Security-relevant failures are visible without exposing sensitive data

## Measurement

- Outcome signal: To be recorded
- Measurement owner: To be recorded
- Measurement point or window: To be recorded

Tests prove behavior and delivery. Record an outcome as pending until its
measurement window has elapsed.
EOF

cat > "$staging_directory/docs/recovery.md" <<EOF
# Recovery

## Recovery owner

Record the person or team who can disable, roll back, rebuild, restore, replay,
or reconcile the Project and who owns the recovery decision.

## Current path

Document the actual deployment or operating shape, the last known good
artifact, required configuration, and the exact recovery command or runbook.
Do not place secrets in this record.

1. Identify the affected artifact or state.
2. Stop or disable the unsafe operation when applicable.
3. Apply the tested rollback, rebuild, restore, replay, or reconciliation path.
4. Verify the critical journey and failure visibility.
5. Record the result in [docs/proof.md](proof.md) and return to operation only
   with owner authority.

## Rehearsal

- Last recovery rehearsal: To be recorded
- Result and evidence: To be recorded
- Remaining risk: To be recorded
EOF

if ! git -C "$staging_directory" -c init.defaultBranch=main init --quiet; then
  fail "could not initialize generated Project Git repository"
fi

if $in_place; then
  verify_in_place_seed "$source_root"
  recovery_directory="$(mktemp -d \
    "$destination_parent/.apt-seed-recovery.XXXXXX")"
  rmdir "$recovery_directory"

  if ! mv "$source_root" "$recovery_directory"; then
    fail "could not move the verified seed into recovery position"
  fi
  seed_moved=true
  verify_in_place_seed "$recovery_directory"

  if ! mv "$staging_directory" "$source_root"; then
    fail "could not install the generated Project at the final root"
  fi
  project_installed=true
  staging_directory=''

  if ! rm -rf "$recovery_directory"; then
    fail "Project installed but verified seed recovery cleanup failed"
  fi
  recovery_directory=''
  seed_moved=false
  trap - EXIT HUP INT TERM
  printf 'Initialized Project in place: %s\n' "$destination"
  printf 'Re-enter Project root before continuing: %s\n' "$destination"
else
  if [[ -e "$destination" || -L "$destination" ]]; then
    fail "destination appeared during creation: $destination"
  fi
  mv "$staging_directory" "$destination"
  staging_directory=''
  trap - EXIT HUP INT TERM
  printf 'Created Project: %s\n' "$destination"
fi
