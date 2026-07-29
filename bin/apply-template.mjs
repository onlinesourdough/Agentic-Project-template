#!/usr/bin/env node

import { access, mkdir, readFile, readdir, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const templateRoot = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  "..",
);
const supportedShapes = new Set([
  "application",
  "service",
  "automation",
  "integration",
  "system",
]);
const supportedProfiles = new Set([
  "static-pages",
  "cloudflare-native",
  "convex",
  "external",
]);
const projectMarkers = [
  ".git",
  "package.json",
  "pyproject.toml",
  "requirements.txt",
  "go.mod",
  "Cargo.toml",
];
const expectedApplicationScripts = ["lint", "typecheck", "test", "build"];

function usage() {
  return `Seed an existing target with the AI-native Solution Template.

Usage:
  node bin/apply-template.mjs --target <path> --shape <shape> [options]

Required:
  --target <path>       Existing repository or scaffold
  --shape <shape>       application | service | automation | integration | system

Application:
  --profile <profile>   static-pages | cloudflare-native | convex | external

Options:
  --dry-run             Report changes without writing files
  --force               Replace template-owned files whose contents differ
  --help                Show this help

Compatibility:
  --profile without --shape infers application during the v0.x preview.`;
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
    shape: undefined,
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

    if (
      argument === "--target" ||
      argument === "--shape" ||
      argument === "--profile"
    ) {
      const value = argv[index + 1];
      if (!value || value.startsWith("--")) {
        throw new Error(`${argument} requires a value`);
      }

      const key = argument.slice(2);
      result[key] = value;
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

async function detectProjectMarkers(targetRoot) {
  const results = await Promise.all(
    projectMarkers.map(async (marker) => ({
      exists: await pathExists(path.join(targetRoot, marker)),
      marker,
    })),
  );

  return results
    .filter((result) => result.exists)
    .map((result) => result.marker);
}

function applicationFiles(profile) {
  const files = [
    [`profiles/${profile}/PROFILE.md`, "docs/solution-template/PROFILE.md"],
  ];
  const continuousIntegration =
    profile === "convex"
      ? "delivery/github-actions/ci-convex.yml"
      : "delivery/github-actions/ci.yml";
  files.push([continuousIntegration, ".github/workflows/ci.yml"]);

  const deployment = {
    "cloudflare-native": [
      "delivery/github-actions/deploy-cloudflare.yml",
      ".github/workflows/deploy-cloudflare.yml",
    ],
    convex: [
      "delivery/github-actions/deploy-cloudflare-convex.yml",
      ".github/workflows/deploy-cloudflare-convex.yml",
    ],
    external: null,
    "static-pages": [
      "delivery/github-actions/deploy-github-pages.yml",
      ".github/workflows/deploy-github-pages.yml",
    ],
  };

  if (deployment[profile]) {
    files.push(deployment[profile]);
  }

  return files;
}

async function collectFiles(directory) {
  const directoryPath = path.join(templateRoot, directory);
  const entries = await readdir(directoryPath, { withFileTypes: true });
  const files = [];

  for (const entry of entries.sort((left, right) =>
    left.name.localeCompare(right.name),
  )) {
    const relativePath = path.posix.join(directory, entry.name);
    if (entry.isDirectory()) {
      files.push(...(await collectFiles(relativePath)));
    } else if (entry.isFile()) {
      files.push(relativePath);
    }
  }

  return files;
}

async function plannedFiles(shape, profile) {
  const skillFiles = [
    ...(await collectFiles(".agents/skills")),
    ...(await collectFiles(".claude/skills")),
  ];
  const files = [
    ["AGENTS.md", "AGENTS.md"],
    ["CLAUDE.md", "CLAUDE.md"],
    ...skillFiles.map((file) => [file, file]),
    [`shapes/${shape}/SHAPE.md`, "docs/solution-template/SHAPE.md"],
  ];

  if (shape === "application") {
    files.push(...applicationFiles(profile));
  }

  return files.map(([source, destination]) => ({
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

  if (!options.target) {
    fail("--target is required");
    console.error(`\n${usage()}`);
    return;
  }

  if (!options.shape && options.profile) {
    options.shape = "application";
    console.warn(
      "Deprecated: --profile without --shape currently infers --shape application. Add the shape explicitly.",
    );
  }

  if (!options.shape) {
    fail("--shape is required");
    console.error(`\n${usage()}`);
    return;
  }

  if (!supportedShapes.has(options.shape)) {
    fail(
      `unsupported shape "${options.shape}". Choose: ${[
        ...supportedShapes,
      ].join(", ")}`,
    );
    return;
  }

  if (options.shape === "application") {
    if (!options.profile) {
      fail("--profile is required for the application shape");
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
  } else if (options.profile) {
    fail("--profile is only valid for the application shape");
    return;
  }

  const targetRoot = path.resolve(process.cwd(), options.target);
  const detectedProjectMarkers = await detectProjectMarkers(targetRoot);
  if (detectedProjectMarkers.length === 0) {
    fail(
      `target must be an existing repository or scaffold containing one of: ${projectMarkers.join(
        ", ",
      )}`,
    );
    return;
  }

  const packagePath = path.join(targetRoot, "package.json");
  if (
    options.shape === "application" &&
    !detectedProjectMarkers.includes("package.json")
  ) {
    fail("application target must contain package.json");
    return;
  }

  let missingScripts = [];
  if (detectedProjectMarkers.includes("package.json")) {
    const targetPackage = await readJson(packagePath);
    if (options.shape === "application") {
      const scripts = targetPackage.scripts ?? {};
      missingScripts = expectedApplicationScripts.filter(
        (script) => !scripts[script],
      );
    }
  }

  const templatePackage = await readJson(
    path.join(templateRoot, "package.json"),
  );
  const files = await plannedFiles(options.shape, options.profile);
  const resolvedFiles = await Promise.all(
    files.map(async (file) => ({
      ...file,
      content: await file.content,
      destinationPath: path.join(targetRoot, file.destination),
    })),
  );
  const manifest = {
    templateVersion: templatePackage.version,
    shape: options.shape,
    profile: options.profile ?? null,
    detectedProjectMarkers,
    appliedFiles: resolvedFiles.map((file) => file.destination).sort(),
    missingScripts,
  };
  resolvedFiles.push({
    content: `${JSON.stringify(manifest, null, 2)}\n`,
    destination: ".solution-template.json",
    destinationPath: path.join(targetRoot, ".solution-template.json"),
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

  if (options.shape !== "application") {
    console.log(
      "\nNo universal CI or deployment workflow was installed. Follow the selected shape guide and the target runtime's official tooling.",
    );
  }

  const changed = actions.filter((action) => action.state !== "unchanged");
  const selection =
    options.shape === "application"
      ? `${options.shape}/${options.profile}`
      : options.shape;
  console.log(
    `\n${options.dryRun ? "AI-native Solution Template dry run complete" : "AI-native Solution Template applied"}: ${selection} (${changed.length} file${changed.length === 1 ? "" : "s"})`,
  );
}

await main();
