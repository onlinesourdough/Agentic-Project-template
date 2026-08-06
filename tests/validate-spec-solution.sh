#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
spec="$repository_root/.agents/skills/spec-solution/SKILL.md"
cases="$repository_root/.agents/skills/spec-solution/examples/acceptance-cases.md"
technology="$repository_root/TECHNOLOGY.md"
readme="$repository_root/README.md"
agents="$repository_root/AGENTS.md"

require_literal() {
  local needle="$1"
  local file="$2"
  if ! rg --fixed-strings --quiet -- "$needle" "$file"; then
    printf 'missing required contract text %q in %s\n' "$needle" "$file" >&2
    exit 1
  fi
}

for file in "$spec" "$cases" "$technology" "$readme" "$agents"; do
  [[ -f "$file" ]] || { printf 'missing required file: %s\n' "$file" >&2; exit 1; }
done

[[ ! -e "$repository_root/capability-profiles/advanced-full-stack-python.md" ]] || {
  printf 'obsolete FastAPI capability profile still exists\n' >&2
  exit 1
}

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

for heading in "### Fit conditions" "### Responsibilities added" "### Operator burden" "### Verification" "### Update path" "### Exit path"; do
  require_literal "$heading" "$technology"
done
for condition in Python React PostgreSQL authentication Docker "operated deployment"; do require_literal "$condition" "$technology"; done
require_literal "It is not a default stack" "$technology"
require_literal "https://github.com/fastapi/full-stack-fastapi-template" "$technology"
require_literal "https://fastapi.tiangolo.com/project-generation/" "$technology"
require_literal "Do not copy or vendor the upstream" "$technology"
require_literal "bash tests/validate-spec-solution.sh" "$readme"

printf 'spec-solution contract validation: PASS\n'
