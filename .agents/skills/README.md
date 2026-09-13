# Repository specialist skills

Keep repeatable project- or domain-specific methods and evaluations at
`.agents/skills/<name>/SKILL.md`. Shared AIOS methods, including Spec, Build,
Review, Ship, design, content and human-writing, are discovered through the
native harness. Do not copy or wrap them here. See [AGENTS.md](../../AGENTS.md)
for local requirements and routing.

For a concrete specialist gap, inspect project-local and installed capabilities,
reuse a sufficient method, and install only within the session's authority.
Cross-project skills stay with their owning harness or plugin. No local skill
is currently needed; add one only for a recurring specialist responsibility.

Keep descriptions short and specific, and read supporting references only when
they affect the task. Give each maintained specialist skill a quoted SemVer in
YAML `metadata.version`, initially `"1.0.0"`: patch for compatible corrections,
minor for compatible capabilities, major for breaking invocation or contract
changes. Validate frontmatter and local links; verify representative behavior
when its operating contract changes.
