#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
spec="$repository_root/.agents/skills/spec-solution/SKILL.md"
cases="$repository_root/.agents/skills/spec-solution/examples/acceptance-cases.md"
choose="$repository_root/.agents/skills/choose-technology/SKILL.md"
fastapi="$repository_root/.agents/skills/choose-technology/references/full-stack-fastapi.md"
readme="$repository_root/README.md"
agents="$repository_root/AGENTS.md"
build="$repository_root/.agents/skills/build-solution/SKILL.md"
review="$repository_root/.agents/skills/review-solution/SKILL.md"
manage="$repository_root/.agents/skills/manage-skills/SKILL.md"

require_literal() {
  local needle="$1"
  local file="$2"
  if ! rg --fixed-strings --quiet -- "$needle" "$file"; then
    printf 'missing required contract text %q in %s\n' "$needle" "$file" >&2
    exit 1
  fi
}

for file in "$spec" "$cases" "$choose" "$fastapi" "$readme" "$agents" "$build" "$review" "$manage"; do
  [[ -f "$file" ]] || { printf 'missing required file: %s\n' "$file" >&2; exit 1; }
done

[[ ! -e "$repository_root/capability-profiles/advanced-full-stack-python.md" ]] || {
  printf 'obsolete FastAPI capability profile still exists\n' >&2
  exit 1
}

legacy_guide_stem="TECHNOLOGY"
legacy_guide_suffix=".md"
legacy_guide="$repository_root/${legacy_guide_stem}${legacy_guide_suffix}"
[[ ! -e "$legacy_guide" ]] || {
  printf 'obsolete root technology guide still exists\n' >&2
  exit 1
}
if rg -n -uu --glob '!.git/**' --glob '!node_modules/**' \
  "${legacy_guide_stem}${legacy_guide_suffix}" "$repository_root"; then
  printf 'obsolete root technology guide reference remains\n' >&2
  exit 1
fi

illustration_stem="solution-template-overview"
current_illustration="${illustration_stem}-v2.svg"
require_literal "![Solution-template workflow](assets/$current_illustration)" "$readme"
readme_image_count="$(rg -o --no-filename '!\[[^]]*\]\([^)]*\)' "$readme" | wc -l | tr -d '[:space:]')"
[[ "$readme_image_count" = 1 ]] || {
  printf 'README must contain exactly one illustration; found %s\n' "$readme_image_count" >&2
  exit 1
}

for superseded_extension in png svg; do
  superseded_illustration="${illustration_stem}.${superseded_extension}"
  [[ ! -e "$repository_root/assets/$superseded_illustration" ]] || {
    printf 'superseded illustration still exists: %s\n' "$superseded_illustration" >&2
    exit 1
  }
  if rg -n -uu --fixed-strings --glob '!.git/**' --glob '!node_modules/**' \
    "$superseded_illustration" "$repository_root"; then
    printf 'superseded illustration reference remains: %s\n' "$superseded_illustration" >&2
    exit 1
  fi
done

check_local_links() {
  local markdown="$1"
  local link target
  while IFS= read -r link; do
    target="${link#*](}"
    target="${target%)}"
    target="${target%%#*}"
    case "$target" in
      ''|http://*|https://*|mailto:*|\#*) continue ;;
    esac
    [[ -e "$(dirname -- "$markdown")/$target" ]] || {
      printf 'broken local link %s in %s\n' "$target" "$markdown" >&2
      exit 1
    }
  done < <(rg -o --no-filename '\]\([^)]*\)' "$markdown" || true)
}

while IFS= read -r markdown; do
  check_local_links "$repository_root/$markdown"
done < <(cd "$repository_root" && rg --files -uu --glob '*.md' \
  --glob '!.git/**' --glob '!node_modules/**')

for maturity in "Rough idea" "Developed brief" "Near-complete specification" "Existing-system change request"; do
  require_literal "$maturity" "$spec"
  require_literal "$maturity" "$cases"
done

for state in RESOLVED INFERRED MISSING CONFLICTING; do require_literal "$state" "$spec"; done
for gate in "### READY" "### REVISE" "### BLOCKED"; do require_literal "$gate" "$spec"; done

require_literal "Return exactly one gate" "$spec"
require_literal "construct the smallest build-ready contract" "$spec"
require_literal "measurement owner" "$spec"
require_literal "requested Ship scope" "$spec"
require_literal "constructs the missing project-local technical specification" "$readme"
require_literal "Design-template" "$readme"
require_literal "not introduced as a runtime dependency" "$readme"
require_literal "Before external search, dynamically inventory:" "$manage"
require_literal "project-local skills discovered from repository truth" "$manage"
require_literal "calling or containing AIOS context" "$manage"
require_literal "rather than hardcoded by name" "$manage"
require_literal "harness-native capabilities and personal or installed skills" "$manage"
require_literal "repository instructions and ordinary agent reasoning" "$manage"
require_literal "Reuse the first sufficient capability." "$manage"
require_literal "Stop when the inventory is sufficient." "$manage"
require_literal "Using an AIOS skill during work must not create an AIOS runtime dependency." "$manage"
require_literal ".agents/skills/choose-technology/SKILL.md" "$agents"
require_literal ".agents/skills/choose-technology/SKILL.md" "$readme"
require_literal "existing stack directly to" "$agents"
require_literal 'optional `manage-skills`' "$agents"
require_literal "only project technology-selection procedure" "$choose"
require_literal "existing working stack" "$choose"
require_literal "bypass this skill" "$choose"
require_literal "new or materially changed technology decision" "$choose"
require_literal ".agents/skills/manage-skills/SKILL.md" "$choose"
require_literal "do not install or invent" "$choose"
require_literal "references/full-stack-fastapi.md" "$choose"
require_literal "might independently satisfy every" "$choose"
require_literal "Do not load it for an existing working stack" "$choose"
require_literal "consumes that decision" "$choose"
require_literal "does not preload every technology reference" "$choose"
require_literal "Consume the Spec's resolved technology decision" "$build"
require_literal "do not reopen" "$build"
require_literal "contracts can be checked" "$choose"
require_literal "secrets and operational state remain outside source code" "$choose"
require_literal "maintain or replace every selected capability" "$choose"
require_literal "smallest runtime that can deliver and recover" "$choose"
require_literal "substantial reusable logic in a small service" "$choose"
require_literal "fit evidence" "$review"
require_literal "operator burden" "$review"
require_literal "verification and proof" "$review"
require_literal "exit path" "$review"
require_literal "Existing working stack bypass" "$cases"
require_literal 'routes directly to `build-solution`' "$cases"
require_literal "concrete specialist implementation gap" "$cases"
require_literal "Full Stack FastAPI reference" "$cases"

for heading in "## Fit conditions" "## Responsibilities added" "## Operator burden" "## Verification" "## Update path" "## Exit path"; do
  require_literal "$heading" "$fastapi"
done
for condition in Python React PostgreSQL authentication Docker "operated deployment"; do require_literal "$condition" "$fastapi"; done
require_literal "not a default stack" "$fastapi"
require_literal "https://github.com/fastapi/full-stack-fastapi-template" "$fastapi"
require_literal "https://fastapi.tiangolo.com/project-generation/" "$fastapi"
require_literal "Do not copy or vendor the upstream" "$fastapi"
require_literal "bash tests/validate-spec-solution.sh" "$readme"

printf 'spec-solution contract validation: PASS\n'
