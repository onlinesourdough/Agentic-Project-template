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

async function createTarget(scripts = true) {
  const root = await mkdtemp(path.join(os.tmpdir(), "app-template-test-"));
  const packageJson = {
    name: "fixture-app",
    private: true,
    scripts: scripts
      ? {
          build: "echo build",
          lint: "echo lint",
          test: "echo test",
          typecheck: "echo typecheck",
        }
      : { build: "echo build" },
  };
  await writeFile(
    path.join(root, "package.json"),
    `${JSON.stringify(packageJson, null, 2)}\n`,
  );
  return root;
}

function apply(target, profile, extra = []) {
  return spawnSync(
    process.execPath,
    [applicator, "--target", target, "--profile", profile, ...extra],
    {
      cwd: repositoryRoot,
      encoding: "utf8",
    },
  );
}

for (const [profile, deployment] of [
  ["static-pages", "deploy-github-pages.yml"],
  ["cloudflare-native", "deploy-cloudflare.yml"],
  ["convex", "deploy-cloudflare-convex.yml"],
]) {
  test(`applies the ${profile} profile and only its deployment`, async () => {
    const target = await createTarget();
    try {
      const result = apply(target, profile);
      assert.equal(result.status, 0, result.stderr);
      const workflowDirectory = path.join(target, ".github/workflows");
      assert.equal(
        await readFile(path.join(workflowDirectory, deployment), "utf8"),
        await readFile(
          path.join(repositoryRoot, "delivery/github-actions", deployment),
          "utf8",
        ),
      );

      const manifest = JSON.parse(
        await readFile(path.join(target, ".app-template.json"), "utf8"),
      );
      assert.equal(manifest.profile, profile);
      assert.deepEqual(manifest.missingScripts, []);
      const expectedCi = profile === "convex" ? "ci-convex.yml" : "ci.yml";
      assert.equal(
        await readFile(path.join(workflowDirectory, "ci.yml"), "utf8"),
        await readFile(
          path.join(repositoryRoot, "delivery/github-actions", expectedCi),
          "utf8",
        ),
      );
      assert.deepEqual(
        manifest.appliedFiles.filter((file) => file.includes("deploy-")),
        [`.github/workflows/${deployment}`],
      );
    } finally {
      await rm(target, { recursive: true, force: true });
    }
  });
}

test("external profile copies CI without a deployment workflow", async () => {
  const target = await createTarget();
  try {
    const result = apply(target, "external");
    assert.equal(result.status, 0, result.stderr);
    const manifest = JSON.parse(
      await readFile(path.join(target, ".app-template.json"), "utf8"),
    );
    assert.equal(
      manifest.appliedFiles.some((file) => file.includes("deploy-")),
      false,
    );
    assert.equal(
      manifest.appliedFiles.includes(".github/workflows/ci.yml"),
      true,
    );
  } finally {
    await rm(target, { recursive: true, force: true });
  }
});

test("dry-run writes nothing", async () => {
  const target = await createTarget();
  try {
    const result = apply(target, "static-pages", ["--dry-run"]);
    assert.equal(result.status, 0, result.stderr);
    await assert.rejects(readFile(path.join(target, "AGENTS.md"), "utf8"));
    await assert.rejects(
      readFile(path.join(target, ".app-template.json"), "utf8"),
    );
  } finally {
    await rm(target, { recursive: true, force: true });
  }
});

test("refuses conflicts and force replaces them", async () => {
  const target = await createTarget();
  try {
    await writeFile(path.join(target, "AGENTS.md"), "customer content\n");
    const refused = apply(target, "convex");
    assert.equal(refused.status, 2);
    assert.match(refused.stderr, /refusing to overwrite/);
    assert.equal(
      await readFile(path.join(target, "AGENTS.md"), "utf8"),
      "customer content\n",
    );

    const forced = apply(target, "convex", ["--force"]);
    assert.equal(forced.status, 0, forced.stderr);
    assert.match(
      await readFile(path.join(target, "AGENTS.md"), "utf8"),
      /# Agent Guide/,
    );
  } finally {
    await rm(target, { recursive: true, force: true });
  }
});

test("reports missing scripts without mutating package.json", async () => {
  const target = await createTarget(false);
  try {
    const before = await readFile(path.join(target, "package.json"), "utf8");
    const result = apply(target, "static-pages");
    assert.equal(result.status, 0, result.stderr);
    assert.match(result.stderr, /npm run lint/);
    assert.equal(
      await readFile(path.join(target, "package.json"), "utf8"),
      before,
    );
    const manifest = JSON.parse(
      await readFile(path.join(target, ".app-template.json"), "utf8"),
    );
    assert.deepEqual(manifest.missingScripts, ["lint", "typecheck", "test"]);
  } finally {
    await rm(target, { recursive: true, force: true });
  }
});

test("rejects invalid profiles and targets", async () => {
  const target = await createTarget();
  try {
    assert.equal(apply(target, "unknown").status, 1);
    const missing = path.join(target, "missing");
    await mkdir(missing);
    assert.equal(apply(missing, "external").status, 1);
  } finally {
    await rm(target, { recursive: true, force: true });
  }
});
