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

async function assertCommonGuidance(target, manifest, shape) {
  for (const [source, destination] of [
    ["AGENTS.md", "AGENTS.md"],
    ["LIFECYCLE.md", "docs/solution-template/LIFECYCLE.md"],
    ["ARCHITECTURE.md", "docs/solution-template/ARCHITECTURE.md"],
    ["delivery/README.md", "docs/solution-template/DELIVERY.md"],
    [`shapes/${shape}/SHAPE.md`, "docs/solution-template/SHAPE.md"],
  ]) {
    assert.equal(
      await readFile(path.join(target, destination), "utf8"),
      await readFile(path.join(repositoryRoot, source), "utf8"),
    );
    assert.equal(manifest.appliedFiles.includes(destination), true);
  }

  assert.equal(
    manifest.appliedFiles.includes(
      "docs/solution-template/AGENT_CAPABILITIES.md",
    ),
    false,
  );
  assert.equal(
    manifest.appliedFiles.includes(
      "docs/solution-template/ADOPTING_EXISTING_APPS.md",
    ),
    false,
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
      await assertCommonGuidance(target, manifest, "application");

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
        manifest.appliedFiles.includes(
          "docs/solution-template/APPLICATION_ARCHITECTURE.md",
        ),
        true,
      );
      assert.equal(
        manifest.appliedFiles.includes("docs/solution-template/PROFILE.md"),
        true,
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
    await assertCommonGuidance(target, manifest, "application");
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
        manifest.appliedFiles.includes(
          "docs/solution-template/APPLICATION_ARCHITECTURE.md",
        ),
        false,
      );
      assert.equal(
        manifest.appliedFiles.includes("docs/solution-template/PROFILE.md"),
        false,
      );
      await assertCommonGuidance(target, manifest, shape);
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
