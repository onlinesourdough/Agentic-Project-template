import assert from "node:assert/strict";
import { readFile, readdir } from "node:fs/promises";
import path from "node:path";
import { parse } from "yaml";

const expectedSkills = [
  "architect-solution",
  "clarify-solution",
  "deliver-solution",
  "develop-solution",
  "document-solution",
  "implement-slice",
  "operate-solution",
  "review-solution",
  "secure-solution",
  "test-solution",
];

async function directories(root) {
  return (await readdir(root, { withFileTypes: true }))
    .filter((entry) => entry.isDirectory())
    .map((entry) => entry.name)
    .sort();
}

async function validateSkill(skillName, root) {
  const skillPath = path.join(root, skillName, "SKILL.md");
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
  assert.equal(metadata.name, skillName);
  assert.equal(typeof metadata.description, "string");
  assert(metadata.description.length > 40);
  assert(
    content.split("\n").length <= 500,
    `${skillPath}: keep the skill body below 500 lines`,
  );
  assert.doesNotMatch(content, /\bTODO\b|\bFIXME\b/);

  console.log(`Skill OK: ${skillPath}`);
}

const canonicalRoot = ".agents/skills";
const adapterRoot = ".claude/skills";
const canonicalSkills = await directories(canonicalRoot);
const adapterSkills = await directories(adapterRoot);

assert.deepEqual(
  canonicalSkills,
  expectedSkills,
  "unexpected canonical skills",
);
assert.deepEqual(adapterSkills, expectedSkills, "Claude adapters must match");

for (const skillName of expectedSkills) {
  await validateSkill(skillName, canonicalRoot);
  await validateSkill(skillName, adapterRoot);

  const metadataPath = path.join(
    canonicalRoot,
    skillName,
    "agents/openai.yaml",
  );
  const metadata = parse(await readFile(metadataPath, "utf8"));
  assert.equal(typeof metadata.interface.display_name, "string");
  assert(metadata.interface.display_name.length > 0);
  assert.equal(typeof metadata.interface.short_description, "string");
  assert(metadata.interface.short_description.length > 0);
  assert(
    metadata.interface.default_prompt.includes(`$${skillName}`),
    `${metadataPath}: default prompt must reference $${skillName}`,
  );

  const adapter = await readFile(
    path.join(adapterRoot, skillName, "SKILL.md"),
    "utf8",
  );
  assert(
    adapter.includes(`../../../.agents/skills/${skillName}/SKILL.md`),
    `${skillName}: Claude adapter must route to the canonical skill`,
  );
}

const router = await readFile(
  ".agents/skills/develop-solution/SKILL.md",
  "utf8",
);
for (const skillName of expectedSkills.filter(
  (name) => name !== "develop-solution",
)) {
  assert(
    router.includes(`\`${skillName}\``),
    `develop-solution must route to ${skillName}`,
  );
}

assert.equal(
  await readFile("CLAUDE.md", "utf8"),
  "@AGENTS.md\n",
  "CLAUDE.md must remain a thin AGENTS.md adapter",
);
