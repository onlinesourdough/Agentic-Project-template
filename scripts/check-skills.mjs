import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import path from "node:path";
import { parse } from "yaml";

const skillPaths = [
  ".agents/skills/develop-solution/SKILL.md",
  ".claude/skills/develop-solution/SKILL.md",
];

for (const skillPath of skillPaths) {
  const content = await readFile(skillPath, "utf8");
  const match = content.match(/^---\n([\s\S]+?)\n---\n/);
  assert(match, `${skillPath}: missing YAML frontmatter`);

  const metadata = parse(match[1]);
  assert.deepEqual(
    Object.keys(metadata).sort(),
    ["description", "name"],
    `${skillPath}: frontmatter must contain only name and description`,
  );
  assert.match(metadata.name, /^[a-z0-9-]{1,63}$/);
  assert.equal(metadata.name, path.basename(path.dirname(skillPath)));
  assert.equal(typeof metadata.description, "string");
  assert(metadata.description.length > 40);

  console.log(`Skill OK: ${skillPath}`);
}

const interfaceMetadata = parse(
  await readFile(".agents/skills/develop-solution/agents/openai.yaml", "utf8"),
);
assert.equal(interfaceMetadata.interface.display_name, "Develop Solution");
assert(
  interfaceMetadata.interface.default_prompt.includes("$develop-solution"),
);
assert.equal(
  await readFile("CLAUDE.md", "utf8"),
  "@AGENTS.md\n",
  "CLAUDE.md must remain a thin AGENTS.md adapter",
);

const claudeAdapter = await readFile(
  ".claude/skills/develop-solution/SKILL.md",
  "utf8",
);
assert(
  claudeAdapter.includes("../../../.agents/skills/develop-solution/SKILL.md"),
  "Claude skill must route to the canonical skill",
);
