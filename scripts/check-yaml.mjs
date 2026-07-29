import { readdir, readFile } from "node:fs/promises";
import path from "node:path";
import { parse } from "yaml";

async function collect(directory) {
  const entries = await readdir(directory, { withFileTypes: true });
  const files = [];

  for (const entry of entries) {
    const entryPath = path.join(directory, entry.name);
    if (entry.isDirectory()) {
      files.push(...(await collect(entryPath)));
    } else if (entry.name.endsWith(".yml") || entry.name.endsWith(".yaml")) {
      files.push(entryPath);
    }
  }

  return files;
}

const directories = [".agents", ".github", "delivery"];
const files = [];

for (const directory of directories) {
  try {
    files.push(...(await collect(directory)));
  } catch (error) {
    if (error.code !== "ENOENT") {
      throw error;
    }
  }
}

for (const file of files.sort()) {
  const content = await readFile(file, "utf8");
  parse(content);

  if (
    file.includes(`${path.sep}workflows${path.sep}`) ||
    file.startsWith(path.join("delivery", "github-actions"))
  ) {
    for (const match of content.matchAll(/^\s*uses:\s*([^#\s]+)/gm)) {
      const action = match[1];
      if (action.startsWith("./") || action.startsWith("docker://")) {
        continue;
      }

      const reference = action.split("@").at(-1);
      if (!/^[a-f0-9]{40}$/.test(reference)) {
        throw new Error(
          `${file}: external Action must use a reviewed full commit SHA: ${action}`,
        );
      }
    }
  }

  console.log(`YAML OK: ${file}`);
}
