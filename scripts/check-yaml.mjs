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
  parse(await readFile(file, "utf8"));
  console.log(`YAML OK: ${file}`);
}
