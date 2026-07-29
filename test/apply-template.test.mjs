import assert from "node:assert/strict";
import { mkdtemp, mkdir, readFile, rm, writeFile } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { spawnSync } from "node:child_process";
import test from "node:test";
import { fileURLToPath } from "node:url";

const repositoryRoot = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  "..",
);
const applicator = path.join(repositoryRoot, "bin/apply-template.mjs");

async function createTarget({
  marker = "package.json",
  completeScripts = true,
} = {}) {
  const root = await mkdtemp(path.join(os.tmpdir(), "solution-template-test-"));

  if (marker === ".git") {
    await mkdir(path.join(root, ".git"));
    return root;
  }

  if (marker === "package.json") {
    const packageJson = {
      name: "fixture-solution",
      private: true,
      scripts: completeScripts
        ? {
            build: "echo build",
            lint: "echo lint",
            test: "echo test",
            typecheck: "echo typecheck",
          }
        : { build: "echo build" },
    };
    await writeFile(
      path.join(root, marker),
      `${JSON.stringify(packageJson, null, 2)}\n`,
    );
    return root;
  }

  await writeFile(path.join(root, marker), "# fixture\n");
  return root;
}

function apply(target, { extra = [], profile, shape } = {}) {
  const argumentsList = [applicator, "--target", target];
  if (shape) {
    argumentsList.push("--shape", shape);
  }
  if (profile) {
    argumentsList.push("--profile", profile);
  }
  argumentsList.push(...extra);

  return spawnSync(process.execPath, argumentsList, {
    cwd: repositoryRoot,
    encoding: "utf8",
  });
}

async function readManifest(target) {
  return JSON.parse(
    await readFile(path.join(target, ".solution-template.json"), "utf8"),
  );
}

async function assertStandaloneCore(target, manifest, shape) {
  const templatePackage = JSON.parse(
    await readFile(path.join(repositoryRoot, "package.json"), "utf8"),
  );
  assert.equal(manifest.templateVersion, templatePackage.version);

  for (const [source, destination] of [
    ["AGENTS.md", "AGENTS.md"],
    ["CLAUDE.md", "CLAUDE.md"],
    [
      ".agents/skills/develop-solution/SKILL.md",
      ".agents/skills/develop-solution/SKILL.md",
    ],
    [
      ".agents/skills/develop-solution/agents/openai.yaml",
      ".agents/skills/develop-solution/agents/openai.yaml",
    ],
    [
      ".agents/skills/develop-solution/references/technical-readiness.md",
      ".agents/skills/develop-solution/references/technical-readiness.md",
    ],
    [
      ".claude/skills/develop-solution/SKILL.md",
      ".claude/skills/develop-solution/SKILL.md",
    ],
    [`shapes/${shape}/SHAPE.md`, "docs/solution-template/SHAPE.md"],
  ]) {
    assert.equal(
      await readFile(path.join(target, destination), "utf8"),
      await readFile(path.join(repositoryRoot, source), "utf8"),
    );
    assert.equal(manifest.appliedFiles.includes(destination), true);
  }

  for (const removedFile of [
    "docs/solution-template/LIFECYCLE.md",
    "docs/solution-template/ARCHITECTURE.md",
    "docs/solution-template/DELIVERY.md",
    "docs/solution-template/APPLICATION_ARCHITECTURE.md",
  ]) {
    assert.equal(manifest.appliedFiles.includes(removedFile), false);
  }

  for (const aiosFile of ["CONTEXT.md", "MEMORY.md", "CONNECTIONS.md"]) {
    assert.equal(manifest.appliedFiles.includes(aiosFile), false);
  }

  const skill = await readFile(
    path.join(target, ".agents/skills/develop-solution/SKILL.md"),
    "utf8",
  );
  assert.match(skill, /name: develop-solution/);
  assert.match(skill, /Do not require AIOS/);
  assert.match(skill, /## Deploy/);
  assert.doesNotMatch(skill, /projects\//);

  const readiness = await readFile(
    path.join(
      target,
      ".agents/skills/develop-solution/references/technical-readiness.md",
    ),
    "utf8",
  );
  for (const area of [
    "Responsibility",
    "Shape and profile",
    "Runtime and stack",
    "Architecture",
    "Contracts and data",
    "Identity and trust",
    "Security and privacy",
    "AI and autonomy",
    "Quality",
    "Delivery",
    "Deployment",
    "Observability",
    "Recovery",
    "Operations",
    "Handover and exit",
  ]) {
    assert.match(readiness, new RegExp(`\\|\\s+${area}\\s+\\|`));
  }
  for (const role of [
    "Outcome owner",
    "Solution owner",
    "Implementation owner",
    "Platform owner",
    "Operational owner",
  ]) {
    assert.match(readiness, new RegExp(`\\|\\s+${role}\\s+\\|`));
  }
  assert.match(readiness, /## Deployment gate/);
  for (const shapeName of [
    "Application",
    "Service",
    "Automation",
    "Integration",
    "System",
  ]) {
    assert.match(readiness, new RegExp(`\\*\\*${shapeName}:\\*\\*`));
  }

  assert.equal(
    await readFile(path.join(target, "CLAUDE.md"), "utf8"),
    "@AGENTS.md\n",
  );
  assert.match(
    await readFile(
      path.join(target, ".claude/skills/develop-solution/SKILL.md"),
      "utf8",
    ),
    /\.\.\/\.\.\/\.\.\/\.agents\/skills\/develop-solution\/SKILL\.md/,
  );
  assert.match(
    await readFile(
      path.join(target, ".agents/skills/develop-solution/agents/openai.yaml"),
      "utf8",
    ),
    /\$develop-solution/,
  );
}

for (const [profile, deployment] of [
  ["static-pages", "deploy-github-pages.yml"],
  ["cloudflare-native", "deploy-cloudflare.yml"],
  ["convex", "deploy-cloudflare-convex.yml"],
]) {
  test(`applies the application/${profile} combination`, async () => {
    const target = await createTarget();
    try {
      const result = apply(target, { profile, shape: "application" });
      assert.equal(result.status, 0, result.stderr);

      const manifest = await readManifest(target);
      assert.equal(manifest.shape, "application");
      assert.equal(manifest.profile, profile);
      assert.deepEqual(manifest.detectedProjectMarkers, ["package.json"]);
      assert.deepEqual(manifest.missingScripts, []);
      await assertStandaloneCore(target, manifest, "application");

      assert.equal(
        await readFile(
          path.join(target, ".github/workflows", deployment),
          "utf8",
        ),
        await readFile(
          path.join(repositoryRoot, "delivery/github-actions", deployment),
          "utf8",
        ),
      );
      assert.deepEqual(
        manifest.appliedFiles.filter((file) => file.includes("deploy-")),
        [`.github/workflows/${deployment}`],
      );
      assert.equal(
        manifest.appliedFiles.includes("docs/solution-template/PROFILE.md"),
        true,
      );
      assert.equal(manifest.appliedFiles.length, 10);
      assert.match(
        await readFile(
          path.join(target, "docs/solution-template/PROFILE.md"),
          "utf8",
        ),
        /## Deployment/,
      );
    } finally {
      await rm(target, { recursive: true, force: true });
    }
  });
}

test("external application copies CI without a deployment workflow", async () => {
  const target = await createTarget();
  try {
    const result = apply(target, {
      profile: "external",
      shape: "application",
    });
    assert.equal(result.status, 0, result.stderr);

    const manifest = await readManifest(target);
    assert.equal(
      manifest.appliedFiles.some((file) => file.includes("deploy-")),
      false,
    );
    assert.equal(
      manifest.appliedFiles.includes(".github/workflows/ci.yml"),
      true,
    );
    await assertStandaloneCore(target, manifest, "application");
    assert.equal(manifest.appliedFiles.length, 9);
    assert.match(
      await readFile(
        path.join(target, "docs/solution-template/PROFILE.md"),
        "utf8",
      ),
      /## Deployment/,
    );
  } finally {
    await rm(target, { recursive: true, force: true });
  }
});

for (const [shape, marker] of [
  ["service", "pyproject.toml"],
  ["automation", ".git"],
  ["integration", "requirements.txt"],
  ["system", ".git"],
]) {
  test(`applies ${shape} guidance without application workflows`, async () => {
    const target = await createTarget({ marker });
    try {
      const result = apply(target, { shape });
      assert.equal(result.status, 0, result.stderr);

      const manifest = await readManifest(target);
      assert.equal(manifest.shape, shape);
      assert.equal(manifest.profile, null);
      assert.deepEqual(manifest.detectedProjectMarkers, [marker]);
      assert.deepEqual(manifest.missingScripts, []);
      assert.equal(
        manifest.appliedFiles.some((file) =>
          file.startsWith(".github/workflows/"),
        ),
        false,
      );
      assert.equal(
        manifest.appliedFiles.includes("docs/solution-template/PROFILE.md"),
        false,
      );
      assert.equal(manifest.appliedFiles.length, 7);
      await assertStandaloneCore(target, manifest, shape);
    } finally {
      await rm(target, { recursive: true, force: true });
    }
  });
}

test("infers application for the legacy profile-only interface", async () => {
  const target = await createTarget();
  try {
    const result = apply(target, { profile: "static-pages" });
    assert.equal(result.status, 0, result.stderr);
    assert.match(result.stderr, /deprecated/i);
    const manifest = await readManifest(target);
    assert.equal(manifest.shape, "application");
    assert.equal(manifest.profile, "static-pages");
  } finally {
    await rm(target, { recursive: true, force: true });
  }
});

test("requires a profile for applications and rejects it for other shapes", async () => {
  const target = await createTarget();
  try {
    assert.equal(apply(target, { shape: "application" }).status, 1);
    assert.equal(
      apply(target, { profile: "external", shape: "service" }).status,
      1,
    );
  } finally {
    await rm(target, { recursive: true, force: true });
  }
});

test("dry-run writes nothing", async () => {
  const target = await createTarget({ marker: "go.mod" });
  try {
    const result = apply(target, {
      extra: ["--dry-run"],
      shape: "service",
    });
    assert.equal(result.status, 0, result.stderr);
    assert.match(result.stdout, /AI-native Solution Template dry run complete/);
    await assert.rejects(readFile(path.join(target, "AGENTS.md"), "utf8"));
    await assert.rejects(
      readFile(path.join(target, ".solution-template.json"), "utf8"),
    );
  } finally {
    await rm(target, { recursive: true, force: true });
  }
});

test("refuses conflicts and force replaces template-owned files", async () => {
  const target = await createTarget();
  try {
    await writeFile(path.join(target, "AGENTS.md"), "customer content\n");
    const refused = apply(target, {
      profile: "convex",
      shape: "application",
    });
    assert.equal(refused.status, 2);
    assert.match(refused.stderr, /refusing to overwrite/);
    assert.equal(
      await readFile(path.join(target, "AGENTS.md"), "utf8"),
      "customer content\n",
    );

    const forced = apply(target, {
      extra: ["--force"],
      profile: "convex",
      shape: "application",
    });
    assert.equal(forced.status, 0, forced.stderr);
    assert.match(
      await readFile(path.join(target, "AGENTS.md"), "utf8"),
      /# Agent Guide/,
    );
  } finally {
    await rm(target, { recursive: true, force: true });
  }
});

test("reports missing application scripts without mutating package.json", async () => {
  const target = await createTarget({ completeScripts: false });
  try {
    const before = await readFile(path.join(target, "package.json"), "utf8");
    const result = apply(target, {
      profile: "static-pages",
      shape: "application",
    });
    assert.equal(result.status, 0, result.stderr);
    assert.match(result.stderr, /npm run lint/);
    assert.equal(
      await readFile(path.join(target, "package.json"), "utf8"),
      before,
    );
    const manifest = await readManifest(target);
    assert.deepEqual(manifest.missingScripts, ["lint", "typecheck", "test"]);
  } finally {
    await rm(target, { recursive: true, force: true });
  }
});

test("preserves the legacy manifest", async () => {
  const target = await createTarget();
  try {
    const legacy = '{"templateVersion":"0.1.0","profile":"static-pages"}\n';
    await writeFile(path.join(target, ".app-template.json"), legacy);
    const result = apply(target, {
      profile: "static-pages",
      shape: "application",
    });
    assert.equal(result.status, 0, result.stderr);
    assert.equal(
      await readFile(path.join(target, ".app-template.json"), "utf8"),
      legacy,
    );
    await readManifest(target);
  } finally {
    await rm(target, { recursive: true, force: true });
  }
});

test("rejects invalid shapes, profiles, options, and unmarked targets", async () => {
  const target = await createTarget();
  const unmarked = await mkdtemp(
    path.join(os.tmpdir(), "solution-template-empty-"),
  );
  try {
    assert.equal(apply(target, { shape: "unknown" }).status, 1);
    assert.equal(
      apply(target, { profile: "unknown", shape: "application" }).status,
      1,
    );
    assert.equal(
      apply(target, { extra: ["--unknown"], shape: "service" }).status,
      1,
    );
    assert.equal(apply(unmarked, { shape: "system" }).status, 1);
  } finally {
    await rm(target, { recursive: true, force: true });
    await rm(unmarked, { recursive: true, force: true });
  }
});
