import { readdir, readFile } from "node:fs/promises";
import path from "node:path";
import markdownLinkCheck from "markdown-link-check";

async function collect(directory) {
  const entries = await readdir(directory, { withFileTypes: true });
  const files = [];

  for (const entry of entries) {
    if (entry.name === ".git" || entry.name === "node_modules") {
      continue;
    }

    const entryPath = path.join(directory, entry.name);
    if (entry.isDirectory()) {
      files.push(...(await collect(entryPath)));
    } else if (entry.name.endsWith(".md")) {
      files.push(entryPath);
    }
  }

  return files;
}

function check(markdown, file) {
  return new Promise((resolve, reject) => {
    markdownLinkCheck(
      markdown,
      {
        baseUrl: `file://${path.resolve(path.dirname(file))}/`,
        retryOn429: true,
        timeout: "10s",
      },
      (error, results) => {
        if (error) {
          reject(error);
          return;
        }

        const failed = results.filter((result) => result.status === "dead");
        if (failed.length > 0) {
          reject(
            new Error(
              `${file} has dead links:\n${failed
                .map((result) => `  - ${result.link}`)
                .join("\n")}`,
            ),
          );
          return;
        }

        console.log(`Links OK: ${file}`);
        resolve();
      },
    );
  });
}

for (const file of (await collect(".")).sort()) {
  await check(await readFile(file, "utf8"), file);
}
