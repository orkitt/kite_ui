import { access, readFile } from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';
import { extractRoutes, flattenPages, loadManifest } from './content-utils.mjs';

const root = path.resolve(process.cwd());
const publicDir = path.join(root, 'public');
const manifestPath = path.join(publicDir, 'docs', 'manifest.json');
const errors = [];

function fail(message) {
  errors.push(message);
}

async function exists(file) {
  try {
    await access(file);
    return true;
  } catch {
    return false;
  }
}

const manifest = await loadManifest(manifestPath);
const pages = flattenPages(manifest);
const routeSet = new Set();
const fileSet = new Set();

if (!manifest.site?.name || !manifest.site?.version) {
  fail('Manifest site.name and site.version are required.');
}

for (const page of pages) {
  if (!page.route?.startsWith('/')) fail(`Invalid route: ${page.route}`);
  if (routeSet.has(page.route)) fail(`Duplicate route: ${page.route}`);
  routeSet.add(page.route);

  if (!page.file?.endsWith('.html')) fail(`Page file must be HTML: ${page.file}`);
  if (fileSet.has(page.file)) fail(`Duplicate page file: ${page.file}`);
  fileSet.add(page.file);

  if (!page.title || !page.description) fail(`Missing metadata for ${page.route}`);

  const pagePath = path.join(publicDir, 'docs', 'pages', page.file);
  if (!(await exists(pagePath))) {
    fail(`Missing page file: ${page.file}`);
    continue;
  }

  const html = await readFile(pagePath, 'utf8');
  if (!/<h1[\s>]/i.test(html)) fail(`Page has no h1: ${page.file}`);
  if (/<script\b/i.test(html)) fail(`Page fragments must not contain scripts: ${page.file}`);

  for (const linkedRoute of extractRoutes(html)) {
    if (!routeSet.has(linkedRoute) && !pages.some((item) => item.route === linkedRoute)) {
      fail(`Broken internal route ${linkedRoute} in ${page.file}`);
    }
  }
}

for (const required of ['index.html', '404.html', 'app.js', 'styles.css', 'assets/kite-mark.svg', 'assets/favicon.svg']) {
  if (!(await exists(path.join(publicDir, required)))) fail(`Missing required asset: ${required}`);
}

if (errors.length) {
  console.error(`Kite docs validation failed with ${errors.length} issue(s):`);
  for (const error of errors) console.error(`  - ${error}`);
  process.exit(1);
}

console.log(`✓ Validated ${pages.length} documentation pages`);
console.log(`✓ Validated ${routeSet.size} unique routes`);
console.log('✓ Required site assets are present');
