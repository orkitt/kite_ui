import { readFile } from 'node:fs/promises';

export function stripHtml(html) {
  return decodeEntities(
    html
      .replace(/<script\b[^>]*>[\s\S]*?<\/script>/gi, ' ')
      .replace(/<style\b[^>]*>[\s\S]*?<\/style>/gi, ' ')
      .replace(/<[^>]+>/g, ' ')
      .replace(/\s+/g, ' ')
      .trim(),
  );
}

export function decodeEntities(value) {
  return value
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&amp;', '&')
    .replaceAll('&quot;', '"')
    .replaceAll('&#039;', "'")
    .replaceAll('&nbsp;', ' ');
}

export function extractRoutes(html) {
  const routes = new Set();
  const regex = /href=["']#(\/[^"]*?)["']/g;
  for (const match of html.matchAll(regex)) {
    routes.add(match[1].split('?')[0]);
  }
  return [...routes];
}

export async function loadManifest(path) {
  const raw = await readFile(path, 'utf8');
  return JSON.parse(raw);
}

export function flattenPages(manifest) {
  return manifest.groups.flatMap((group) =>
    group.pages.map((page) => ({ ...page, group: group.title })),
  );
}
