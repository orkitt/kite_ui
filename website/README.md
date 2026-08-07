# Kite Documentation Website

A branded, responsive documentation site for the Kite Flutter scaffolding CLI.

## Features

- Docsify-inspired three-column documentation layout
- Dark and light themes with saved preference
- Responsive mobile sidebar
- Command palette and full-text documentation search
- Per-page table of contents with scroll tracking
- Copyable code examples and syntax accents
- Hash-based routing for GitHub Pages subdirectory compatibility
- Separate content files and one navigation manifest
- Dependency-free Node build, validation, and local server
- GitHub Pages deployment workflow

## Local development

```bash
cd website
npm run dev
```

Open `http://127.0.0.1:4173`.

## Validate and build

```bash
npm run validate
npm run build
npm test
```

Production files are written to `website/dist`.

## Content organization

```text
website/
├── public/
│   ├── assets/
│   ├── docs/
│   │   ├── manifest.json
│   │   └── pages/*.html
│   ├── app.js
│   ├── index.html
│   └── styles.css
├── scripts/
│   ├── build.mjs
│   ├── serve.mjs
│   └── validate.mjs
└── package.json
```

Add or reorder pages in `public/docs/manifest.json`. Each page is a standalone HTML fragment under `public/docs/pages`.
