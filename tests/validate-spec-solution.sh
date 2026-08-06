#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
spec="$repository_root/.agents/skills/spec-solution/SKILL.md"
cases="$repository_root/.agents/skills/spec-solution/examples/acceptance-cases.md"
technology="$repository_root/TECHNOLOGY.md"
profile="$repository_root/capability-profiles/advanced-full-stack-python.md"
readme="$repository_root/README.md"

require_literal() {
  local needle="$1"
  local file="$2"

  if ! rg --fixed-strings --quiet -- "$needle" "$file"; then
    printf 'missing required contract text %q in %s\n' "$needle" "$file" >&2
    exit 1
  fi
}

for file in "$spec" "$cases" "$technology" "$profile" "$readme"; do
  if [[ ! -f "$file" ]]; then
    printf 'missing required file: %s\n' "$file" >&2
    exit 1
  fi
done

for maturity in "Rough idea" "Developed brief" "Near-complete specification" "Existing-system change request"; do
  require_literal "$maturity" "$spec"
  require_literal "$maturity" "$cases"
done

for state in "RESOLVED" "INFERRED" "MISSING" "CONFLICTING"; do
  require_literal "$state" "$spec"
done

for dimension in "Intended change and constraints" "Served party" "Proof" "Result boundary" "Canonical truth" "Repository gate" "Authority and risk" "Contracts and data" "Lifecycle"; do
  require_literal "$dimension" "$spec"
done

for gate in "### READY" "### REVISE" "### BLOCKED"; do
  require_literal "$gate" "$spec"
done

require_literal "Return exactly one gate" "$spec"
require_literal "Audit technical specifications of any maturity or construct the missing contract from rough input" "$spec"
require_literal "construct the smallest build-ready contract" "$spec"
require_literal "constructed project-local specification" "$spec"
require_literal "measurement owner" "$spec"
require_literal "requested Ship scope" "$spec"
require_literal "audit only project-local technical truth" "$spec"
require_literal "Rough idea — READY by construction" "$cases"
require_literal "missing technical specification is constructed" "$cases"
require_literal "minimal target patch" "$cases"
require_literal "Upstream business decisions remain RESOLVED" "$cases"
require_literal "not introduced as a runtime dependency" "$cases"
require_literal "constructs the missing project-local technical specification" "$readme"

for heading in "## Fit conditions" "## Responsibilities added" "## Operator burden" "## Verification" "## Update path" "## Exit path"; do
  require_literal "$heading" "$profile"
done

for condition in "Python" "React" "PostgreSQL" "authentication" "Docker" "operated deployment"; do
  require_literal "$condition" "$technology"
  require_literal "$condition" "$profile"
done

require_literal "It is not a default stack" "$technology"
require_literal "This is not a default stack" "$profile"
require_literal "https://github.com/fastapi/full-stack-fastapi-template" "$profile"
require_literal "https://fastapi.tiangolo.com/project-generation/" "$profile"
require_literal "The advanced-full-stack-python profile is not selected" "$cases"
require_literal "Do not copy or vendor the upstream" "$profile"
require_literal "bash tests/validate-spec-solution.sh" "$readme"

printf 'spec-solution contract validation: PASS\n'
