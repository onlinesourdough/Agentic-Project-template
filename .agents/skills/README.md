# Repository specialist skills

Keep only Project- or domain-specific repeatable methods and evals at
`.agents/skills/<name>/SKILL.md`. Shared Spec, Build, Review, Ship, technology
selection and generic repository audits come from the installed AIOS plugin,
outside the Project payload. Do not copy, wrap, rename or symlink those methods
into this shelf. The template neither owns nor auto-updates this Project.

For a concrete specialist gap, inventory existing Project-local,
harness-native, installed, and Global capabilities. Reuse a sufficient method;
install external skills through the chosen harness or plugin only within
explicit authority, including authorization already granted in the session. An
installed optional manager may help. Cross-Project and Global Skills remain
independently owned. See the root AGENTS.md for shared routing.

No repository-specific skill is currently needed. Add one only for a concrete
repeatable specialist responsibility.

Give every maintained specialist `SKILL.md` a quoted SemVer in YAML frontmatter
under `metadata.version`, initially `"1.0.0"`. Version each skill independently
of the Project or package: patch for compatible corrections, minor for compatible
capabilities, major for breaking invocation or operating-contract changes. Bump
only affected skills; do not create placeholder skills or generic copies.

Keep discovery descriptions short and specific to the recurring responsibility.
Read supporting references only when they change the current task's decisions.
Validate frontmatter, version, local links and inventory when authoring a skill;
use a representative behavior check when its operating contract changes.
