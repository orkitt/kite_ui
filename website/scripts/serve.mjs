import { createReadStream } from 'node:fs';
import { stat } from 'node:fs/promises';
import http from 'node:http';
import path from 'node:path';
import process from 'node:process';

const directory = path.resolve(process.cwd(), process.argv[2] || 'public');
const port = Number(process.env.PORT || 4173);
const host = process.env.HOST || '127.0.0.1';
const mime = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.webp': 'image/webp',
};

const server = http.createServer(async (request, response) => {
  const requestPath = decodeURIComponent(new URL(request.url, `http://${request.headers.host}`).pathname);
  let target = path.resolve(directory, `.${requestPath}`);

  if (!target.startsWith(directory)) {
    response.writeHead(403);
    response.end('Forbidden');
    return;
  }

  try {
    const info = await stat(target);
    if (info.isDirectory()) target = path.join(target, 'index.html');
  } catch {
    target = path.join(directory, '404.html');
  }

  try {
    const info = await stat(target);
    response.writeHead(target.endsWith('404.html') ? 404 : 200, {
      'Content-Type': mime[path.extname(target)] || 'application/octet-stream',
      'Content-Length': info.size,
      'Cache-Control': 'no-cache',
    });
    createReadStream(target).pipe(response);
  } catch {
    response.writeHead(500);
    response.end('Server error');
  }
});

server.listen(port, host, () => {
  console.log(`Kite docs: http://${host}:${port}`);
  console.log(`Serving: ${directory}`);
});
