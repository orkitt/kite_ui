import { cp, mkdir, readFile, rm, writeFile } from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';
import { flattenPages, loadManifest, stripHtml } from './content-utils.mjs';

const root = path.resolve(process.cwd());
const publicDir = path.join(root, 'public');
const distDir = path.join(root, 'dist');

await rm(distDir, { recursive: true, force: true });
await mkdir(distDir, { recursive: true });
await cp(publicDir, distDir, { recursive: true });

const manifest = await loadManifest(path.join(publicDir, 'docs', 'manifest.json'));
const pages = flattenPages(manifest);
const searchIndex = [];

for (const page of pages) {
  const html = await readFile(path.join(publicDir, 'docs', 'pages', page.file), 'utf8');
  searchIndex.push({
    route: page.route,
    title: page.title,
    group: page.group,
    description: page.description,
    keywords: page.keywords || [],
    text: stripHtml(html),
  });
}

await writeFile(
  path.join(distDir, 'search-index.json'),
  `${JSON.stringify(searchIndex, null, 2)}\n`,
  'utf8',
);

await writeFile(
  path.join(distDir, 'build.json'),
  `${JSON.stringify({
    product: manifest.site.name,
    version: manifest.site.version,
    pages: pages.length,
    builtAt: new Date().toISOString(),
  }, null, 2)}\n`,
  'utf8',
);

console.log(`✓ Built Kite documentation (${pages.length} pages)`);
console.log(`✓ Output: ${distDir}`);
