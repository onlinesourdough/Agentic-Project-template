#!/usr/bin/env node

import { access, mkdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const templateRoot = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  "..",
);
const supportedProfiles = new Set([
  "static-pages",
  "cloudflare-native",
  "convex",
  "external",
]);
const expectedScripts = ["lint", "typecheck", "test", "build"];

function usage() {
  return `Apply AI-first App Template guidance to an official scaffold.

Usage:
  node bin/apply-template.mjs --target <path> --profile <profile> [options]

Required:
  --target <path>       Existing application with package.json
  --profile <profile>   static-pages | cloudflare-native | convex | external

Options:
  --dry-run             Report changes without writing files
  --force               Replace files whose contents differ
  --help                 Show this help`;
}

function fail(message, exitCode = 1) {
  console.error(`Error: ${message}`);
  process.exitCode = exitCode;
}

function parseArguments(argv) {
  const result = {
    dryRun: false,
    force: false,
    profile: undefined,
    target: undefined,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const argument = argv[index];

    if (argument === "--help") {
      return { ...result, help: true };
    }

    if (argument === "--dry-run") {
      result.dryRun = true;
      continue;
    }

    if (argument === "--force") {
      result.force = true;
      continue;
    }

    if (argument === "--target" || argument === "--profile") {
      const value = argv[index + 1];
      if (!value || value.startsWith("--")) {
        throw new Error(`${argument} requires a value`);
      }

      result[argument === "--target" ? "target" : "profile"] = value;
      index += 1;
      continue;
    }

    throw new Error(`unknown option: ${argument}`);
  }

  return result;
}

async function pathExists(filePath) {
  try {
    await access(filePath);
    return true;
  } catch {
    return false;
  }
}

async function readJson(filePath) {
  try {
    return JSON.parse(await readFile(filePath, "utf8"));
  } catch (error) {
    throw new Error(
      `cannot read valid JSON from ${filePath}: ${error.message}`,
    );
  }
}

async function plannedFiles(profile) {
  const common = [
    ["AGENTS.md", "AGENTS.md"],
    ["ARCHITECTURE.md", "docs/app-template/ARCHITECTURE.md"],
    ["delivery/README.md", "docs/app-template/DELIVERY.md"],
    [`profiles/${profile}/PROFILE.md`, "docs/app-template/PROFILE.md"],
  ];
  const continuousIntegration =
    profile === "convex"
      ? "delivery/github-actions/ci-convex.yml"
      : "delivery/github-actions/ci.yml";
  common.push([continuousIntegration, ".github/workflows/ci.yml"]);
  const deployment = {
    "cloudflare-native": [
      [
        "delivery/github-actions/deploy-cloudflare.yml",
        ".github/workflows/deploy-cloudflare.yml",
      ],
    ],
    convex: [
      [
        "delivery/github-actions/deploy-cloudflare-convex.yml",
        ".github/workflows/deploy-cloudflare-convex.yml",
      ],
    ],
    external: [],
    "static-pages": [
      [
        "delivery/github-actions/deploy-github-pages.yml",
        ".github/workflows/deploy-github-pages.yml",
      ],
    ],
  };

  return [...common, ...deployment[profile]].map(([source, destination]) => ({
    content: readFile(path.join(templateRoot, source), "utf8"),
    destination,
    source,
  }));
}

async function main() {
  let options;
  try {
    options = parseArguments(process.argv.slice(2));
  } catch (error) {
    fail(error.message);
    console.error(`\n${usage()}`);
    return;
  }

  if (options.help) {
    console.log(usage());
    return;
  }

  if (!options.target || !options.profile) {
    fail("--target and --profile are required");
    console.error(`\n${usage()}`);
    return;
  }

  if (!supportedProfiles.has(options.profile)) {
    fail(
      `unsupported profile "${options.profile}". Choose: ${[
        ...supportedProfiles,
      ].join(", ")}`,
    );
    return;
  }

  const targetRoot = path.resolve(process.cwd(), options.target);
  const packagePath = path.join(targetRoot, "package.json");
  if (!(await pathExists(packagePath))) {
    fail(`target must contain package.json: ${targetRoot}`);
    return;
  }

  const targetPackage = await readJson(packagePath);
  const scripts = targetPackage.scripts ?? {};
  const missingScripts = expectedScripts.filter((script) => !scripts[script]);
  const templatePackage = await readJson(
    path.join(templateRoot, "package.json"),
  );
  const files = await plannedFiles(options.profile);

  const resolvedFiles = await Promise.all(
    files.map(async (file) => ({
      ...file,
      content: await file.content,
      destinationPath: path.join(targetRoot, file.destination),
    })),
  );
  const manifest = {
    templateVersion: templatePackage.version,
    profile: options.profile,
    appliedFiles: resolvedFiles.map((file) => file.destination).sort(),
    missingScripts,
  };
  resolvedFiles.push({
    content: `${JSON.stringify(manifest, null, 2)}\n`,
    destination: ".app-template.json",
    destinationPath: path.join(targetRoot, ".app-template.json"),
    source: "generated manifest",
  });

  const conflicts = [];
  const actions = [];

  for (const file of resolvedFiles) {
    if (!(await pathExists(file.destinationPath))) {
      actions.push({ file, state: "create" });
      continue;
    }

    const current = await readFile(file.destinationPath, "utf8");
    if (current === file.content) {
      actions.push({ file, state: "unchanged" });
      continue;
    }

    if (!options.force) {
      conflicts.push(file.destination);
      continue;
    }

    actions.push({ file, state: "replace" });
  }

  if (conflicts.length > 0) {
    fail(
      `refusing to overwrite changed files:\n${conflicts
        .map((file) => `  - ${file}`)
        .join("\n")}\nRun again with --force only after reviewing them.`,
      2,
    );
    return;
  }

  for (const action of actions) {
    const prefix = options.dryRun ? "Would" : "Will";
    console.log(`${prefix} ${action.state}: ${action.file.destination}`);

    if (options.dryRun || action.state === "unchanged") {
      continue;
    }

    await mkdir(path.dirname(action.file.destinationPath), {
      recursive: true,
    });
    await writeFile(action.file.destinationPath, action.file.content, "utf8");
  }

  if (missingScripts.length > 0) {
    console.warn("\nAction required: add or map these package scripts:");
    for (const script of missingScripts) {
      console.warn(`  - npm run ${script}`);
    }
  }

  const changed = actions.filter((action) => action.state !== "unchanged");
  console.log(
    `\n${options.dryRun ? "Dry run complete" : "Template applied"}: ${
      options.profile
    } (${changed.length} file${changed.length === 1 ? "" : "s"})`,
  );
}

await main();
