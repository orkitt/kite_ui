const state = {
  manifest: null,
  pages: [],
  currentRoute: '/',
  searchIndex: [],
  selectedSearchIndex: 0,
  observer: null,
};

const elements = {
  doc: document.querySelector('#doc-content'),
  sidebarNav: document.querySelector('#sidebar-nav'),
  tocNav: document.querySelector('#toc-nav'),
  sidebar: document.querySelector('#sidebar'),
  sidebarBackdrop: document.querySelector('#sidebar-backdrop'),
  mobileMenu: document.querySelector('#mobile-menu'),
  themeToggle: document.querySelector('#theme-toggle'),
  searchTrigger: document.querySelector('#search-trigger'),
  searchDialog: document.querySelector('#search-dialog'),
  searchInput: document.querySelector('#search-input'),
  searchResults: document.querySelector('#search-results'),
  searchClose: document.querySelector('#search-close'),
  toast: document.querySelector('#toast'),
};

const icons = {
  arrow: '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m9 18 6-6-6-6"/></svg>',
};

function normalizeRoute(hash = window.location.hash) {
  const raw = hash.replace(/^#/, '') || '/';
  const route = raw.startsWith('/') ? raw : `/${raw}`;
  return route.length > 1 ? route.replace(/\/+$/, '') : route;
}

function getAllPages(manifest) {
  return manifest.groups.flatMap((group) =>
    group.pages.map((page) => ({ ...page, group: group.title })),
  );
}

async function fetchJson(path) {
  const response = await fetch(path, { cache: 'no-cache' });
  if (!response.ok) throw new Error(`Failed to load ${path}`);
  return response.json();
}

async function fetchText(path) {
  const response = await fetch(path, { cache: 'no-cache' });
  if (!response.ok) throw new Error(`Failed to load ${path}`);
  return response.text();
}

function renderSidebar() {
  elements.sidebarNav.innerHTML = state.manifest.groups
    .map((group) => `
      <section class="sidebar-group">
        <span class="sidebar-group-title">${escapeHtml(group.title)}</span>
        ${group.pages.map((page) => `
          <a class="sidebar-link" data-route="${page.route}" href="#${page.route}">
            <span>${escapeHtml(page.title)}</span>
            ${page.badge ? `<span class="nav-badge">${escapeHtml(page.badge)}</span>` : ''}
          </a>
        `).join('')}
      </section>
    `)
    .join('');
}

function setActiveSidebar(route) {
  document.querySelectorAll('.sidebar-link').forEach((link) => {
    const active = link.dataset.route === route;
    link.classList.toggle('active', active);
    if (active) link.setAttribute('aria-current', 'page');
    else link.removeAttribute('aria-current');
  });
}

function slugify(text) {
  return text
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9\s-]/g, '')
    .replace(/\s+/g, '-')
    .replace(/-+/g, '-');
}

function decorateHeadings() {
  const headings = [...elements.doc.querySelectorAll('h2, h3')];
  const used = new Set();
  for (const heading of headings) {
    let id = heading.id || slugify(heading.textContent);
    let next = id;
    let count = 2;
    while (used.has(next)) next = `${id}-${count++}`;
    used.add(next);
    heading.id = next;
  }
  return headings;
}

function renderToc(headings) {
  if (!headings.length) {
    elements.tocNav.innerHTML = '<span class="toc-link">Overview</span>';
    return;
  }
  elements.tocNav.innerHTML = headings
    .map((heading) => `<a class="toc-link level-${heading.tagName.slice(1)}" href="#${state.currentRoute}?section=${heading.id}" data-heading="${heading.id}">${escapeHtml(heading.textContent)}</a>`)
    .join('');

  elements.tocNav.querySelectorAll('.toc-link').forEach((link) => {
    link.addEventListener('click', (event) => {
      event.preventDefault();
      document.getElementById(link.dataset.heading)?.scrollIntoView({ behavior: 'smooth', block: 'start' });
      history.replaceState(null, '', `#${state.currentRoute}?section=${link.dataset.heading}`);
    });
  });

  state.observer?.disconnect();
  state.observer = new IntersectionObserver((entries) => {
    const visible = entries
      .filter((entry) => entry.isIntersecting)
      .sort((a, b) => a.boundingClientRect.top - b.boundingClientRect.top)[0];
    if (!visible) return;
    elements.tocNav.querySelectorAll('.toc-link').forEach((link) => {
      link.classList.toggle('active', link.dataset.heading === visible.target.id);
    });
  }, { rootMargin: '-90px 0px -72% 0px', threshold: 0 });
  headings.forEach((heading) => state.observer.observe(heading));
}

function syntaxHighlight(code, language) {
  if (!['bash', 'shell', 'yaml', 'json', 'dart'].includes(language)) return escapeHtml(code);
  let highlighted = escapeHtml(code);
  if (language === 'bash' || language === 'shell') {
    highlighted = highlighted
      .replace(/(^|\n)(\s*)(kite|dart|flutter|npm|python3|cd|git|unzip)(?=\s|$)/g, '$1$2<span class="token-command">$3</span>')
      .replace(/(^|\n)(\s*)(#.*)$/g, '$1$2<span class="token-comment">$3</span>');
  }
  if (language === 'json' || language === 'yaml') {
    highlighted = highlighted
      .replace(/(&quot;[^&]*?&quot;)(?=\s*:)/g, '<span class="token-type">$1</span>')
      .replace(/:\s*(&quot;[^&]*?&quot;)/g, ': <span class="token-string">$1</span>')
      .replace(/\b(true|false|null)\b/g, '<span class="token-keyword">$1</span>')
      .replace(/\b(\d+(?:\.\d+)?)\b/g, '<span class="token-number">$1</span>');
  }
  if (language === 'dart') {
    highlighted = highlighted
      .replace(/\b(class|final|const|abstract|interface|extends|implements|return|required|import|part|factory|async|await|void|Future|Map|String|Object)\b/g, '<span class="token-keyword">$1</span>')
      .replace(/(&#39;.*?&#39;|&quot;.*?&quot;)/g, '<span class="token-string">$1</span>')
      .replace(/(\/\/.*)$/gm, '<span class="token-comment">$1</span>');
  }
  return highlighted;
}

function decorateCodeBlocks() {
  elements.doc.querySelectorAll('pre code').forEach((code) => {
    const pre = code.parentElement;
    if (pre.parentElement?.classList.contains('code-block')) return;
    const languageClass = [...code.classList].find((item) => item.startsWith('language-'));
    const language = languageClass?.replace('language-', '') || 'text';
    const raw = code.textContent.replace(/^\n|\n$/g, '');
    const wrapper = document.createElement('div');
    wrapper.className = 'code-block';
    wrapper.innerHTML = `
      <div class="code-header">
        <span>${escapeHtml(language === 'shell' ? 'terminal' : language)}</span>
        <button class="copy-code" type="button">Copy</button>
      </div>
      <pre><code class="language-${language}">${syntaxHighlight(raw, language)}</code></pre>
    `;
    wrapper.querySelector('.copy-code').addEventListener('click', async (event) => {
      await navigator.clipboard.writeText(raw);
      event.currentTarget.textContent = 'Copied';
      showToast('Copied to clipboard');
      setTimeout(() => { event.currentTarget.textContent = 'Copy'; }, 1400);
    });
    pre.replaceWith(wrapper);
  });
}

function decorateFileTrees() {
  elements.doc.querySelectorAll('.file-tree').forEach((tree) => {
    const text = tree.textContent;
    tree.innerHTML = escapeHtml(text)
      .split('\n')
      .map((line) => {
        const trimmed = line.trim();
        const isFolder = trimmed.endsWith('/') || /[├└]──\s+[^.\s]+\/?$/.test(line);
        return `<span class="${isFolder ? 'folder' : 'file'}">${line}</span>`;
      })
      .join('\n');
  });
}

function decorateTables() {
  elements.doc.querySelectorAll('table').forEach((table) => {
    if (table.parentElement?.classList.contains('table-wrap')) return;
    const wrapper = document.createElement('div');
    wrapper.className = 'table-wrap';
    table.replaceWith(wrapper);
    wrapper.append(table);
  });
}

function addPageNavigation(page) {
  const index = state.pages.findIndex((item) => item.route === page.route);
  const previous = index > 0 ? state.pages[index - 1] : null;
  const next = index < state.pages.length - 1 ? state.pages[index + 1] : null;
  if (!previous && !next) return;
  const nav = document.createElement('nav');
  nav.className = 'next-prev';
  nav.setAttribute('aria-label', 'Documentation pagination');
  nav.innerHTML = `
    ${previous ? `<a class="page-nav-link previous" href="#${previous.route}"><span class="page-nav-label">Previous</span><span class="page-nav-title">← ${escapeHtml(previous.title)}</span></a>` : '<span></span>'}
    ${next ? `<a class="page-nav-link next" href="#${next.route}"><span class="page-nav-label">Next</span><span class="page-nav-title">${escapeHtml(next.title)} →</span></a>` : ''}
  `;
  elements.doc.append(nav);
}

function showToast(message) {
  elements.toast.textContent = message;
  elements.toast.classList.add('show');
  clearTimeout(showToast.timer);
  showToast.timer = setTimeout(() => elements.toast.classList.remove('show'), 1800);
}

function closeSidebar() {
  document.body.classList.remove('sidebar-open');
  elements.mobileMenu.setAttribute('aria-expanded', 'false');
}

async function renderRoute() {
  const routeWithQuery = normalizeRoute();
  const [route, query] = routeWithQuery.split('?');
  const page = state.pages.find((item) => item.route === route);
  state.currentRoute = route;
  closeSidebar();
  window.scrollTo({ top: 0, behavior: 'instant' });
  setActiveSidebar(route);

  if (!page) {
    elements.doc.innerHTML = `
      <section class="error-page">
        <strong>404</strong>
        <h1>That page is not flying here.</h1>
        <p>The documentation route could not be found.</p>
        <a class="button-link primary" href="#/">Return home</a>
      </section>
    `;
    document.title = 'Page not found · Kite';
    elements.tocNav.innerHTML = '';
    return;
  }

  elements.doc.innerHTML = '<div class="loading-state"><span class="loader"></span><p>Loading documentation…</p></div>';
  try {
    const html = await fetchText(`docs/pages/${page.file}`);
    elements.doc.innerHTML = html;
    decorateCodeBlocks();
    decorateFileTrees();
    decorateTables();
    const headings = decorateHeadings();
    renderToc(headings);
    addPageNavigation(page);
    document.title = `${page.title} · Kite Documentation`;
    document.querySelector('meta[name="description"]')?.setAttribute('content', page.description);

    if (query?.startsWith('section=')) {
      const section = decodeURIComponent(query.replace('section=', ''));
      requestAnimationFrame(() => document.getElementById(section)?.scrollIntoView({ behavior: 'instant' }));
    }
  } catch (error) {
    elements.doc.innerHTML = `
      <section class="error-page">
        <strong>!</strong>
        <h1>Documentation failed to load</h1>
        <p>${escapeHtml(error.message)}</p>
        <button class="button-link primary" type="button" onclick="location.reload()">Try again</button>
      </section>
    `;
  }
}

function escapeHtml(value = '') {
  return String(value)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;');
}

function initializeTheme() {
  const stored = localStorage.getItem('kite-docs-theme');
  const preferred = window.matchMedia('(prefers-color-scheme: light)').matches ? 'light' : 'dark';
  document.documentElement.dataset.theme = stored || preferred;
}

function toggleTheme() {
  const next = document.documentElement.dataset.theme === 'dark' ? 'light' : 'dark';
  document.documentElement.dataset.theme = next;
  localStorage.setItem('kite-docs-theme', next);
}

function openSearch() {
  if (!elements.searchDialog.open) elements.searchDialog.showModal();
  elements.searchInput.value = '';
  state.selectedSearchIndex = 0;
  renderSearchResults('');
  requestAnimationFrame(() => elements.searchInput.focus());
}

function closeSearch() {
  if (elements.searchDialog.open) elements.searchDialog.close();
}

function highlight(text, query) {
  if (!query) return escapeHtml(text);
  const safe = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  return escapeHtml(text).replace(new RegExp(`(${safe})`, 'ig'), '<mark>$1</mark>');
}

function scoreResult(item, query) {
  const q = query.toLowerCase();
  const title = item.title.toLowerCase();
  const keywords = (item.keywords || []).join(' ').toLowerCase();
  const text = item.text.toLowerCase();
  let score = 0;
  if (title === q) score += 120;
  if (title.startsWith(q)) score += 70;
  if (title.includes(q)) score += 45;
  if (keywords.includes(q)) score += 30;
  if (text.includes(q)) score += 12;
  for (const token of q.split(/\s+/).filter(Boolean)) {
    if (title.includes(token)) score += 18;
    if (keywords.includes(token)) score += 10;
    if (text.includes(token)) score += 3;
  }
  return score;
}

function renderSearchResults(query) {
  const trimmed = query.trim();
  const results = trimmed
    ? state.searchIndex
        .map((item) => ({ ...item, score: scoreResult(item, trimmed) }))
        .filter((item) => item.score > 0)
        .sort((a, b) => b.score - a.score)
        .slice(0, 9)
    : state.searchIndex.slice(0, 7);

  state.activeSearchResults = results;
  state.selectedSearchIndex = Math.min(state.selectedSearchIndex, Math.max(0, results.length - 1));

  if (!results.length) {
    elements.searchResults.innerHTML = `<div class="search-empty"><strong>No documentation found</strong><span>Try a command, generator, or architecture name.</span></div>`;
    return;
  }

  elements.searchResults.innerHTML = results.map((item, index) => `
    <a class="search-result ${index === state.selectedSearchIndex ? 'selected' : ''}" href="#${item.route}" data-index="${index}">
      <div class="search-result-top"><span class="search-result-group">${escapeHtml(item.group)}</span></div>
      <h3>${highlight(item.title, trimmed)}</h3>
      <p>${highlight(item.description, trimmed)}</p>
    </a>
  `).join('');

  elements.searchResults.querySelectorAll('.search-result').forEach((result) => {
    result.addEventListener('mouseenter', () => {
      state.selectedSearchIndex = Number(result.dataset.index);
      updateSearchSelection();
    });
    result.addEventListener('click', closeSearch);
  });
}

function updateSearchSelection() {
  elements.searchResults.querySelectorAll('.search-result').forEach((result, index) => {
    result.classList.toggle('selected', index === state.selectedSearchIndex);
  });
  elements.searchResults.querySelector('.search-result.selected')?.scrollIntoView({ block: 'nearest' });
}

function bindEvents() {
  window.addEventListener('hashchange', renderRoute);
  elements.themeToggle.addEventListener('click', toggleTheme);
  elements.mobileMenu.addEventListener('click', () => {
    const open = document.body.classList.toggle('sidebar-open');
    elements.mobileMenu.setAttribute('aria-expanded', String(open));
  });
  elements.sidebarBackdrop.addEventListener('click', closeSidebar);
  elements.searchTrigger.addEventListener('click', openSearch);
  elements.searchClose.addEventListener('click', closeSearch);
  elements.searchInput.addEventListener('input', (event) => {
    state.selectedSearchIndex = 0;
    renderSearchResults(event.target.value);
  });
  elements.searchInput.addEventListener('keydown', (event) => {
    const max = (state.activeSearchResults?.length || 1) - 1;
    if (event.key === 'ArrowDown') {
      event.preventDefault();
      state.selectedSearchIndex = Math.min(max, state.selectedSearchIndex + 1);
      updateSearchSelection();
    }
    if (event.key === 'ArrowUp') {
      event.preventDefault();
      state.selectedSearchIndex = Math.max(0, state.selectedSearchIndex - 1);
      updateSearchSelection();
    }
    if (event.key === 'Enter') {
      const selected = state.activeSearchResults?.[state.selectedSearchIndex];
      if (selected) {
        window.location.hash = selected.route;
        closeSearch();
      }
    }
  });
  elements.searchDialog.addEventListener('click', (event) => {
    if (event.target === elements.searchDialog) closeSearch();
  });
  document.addEventListener('keydown', (event) => {
    if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === 'k') {
      event.preventDefault();
      openSearch();
    }
    if (event.key === 'Escape') {
      closeSidebar();
      closeSearch();
    }
  });
}

async function bootstrap() {
  initializeTheme();
  bindEvents();
  try {
    state.manifest = await fetchJson('docs/manifest.json');
    state.pages = getAllPages(state.manifest);
    renderSidebar();
    try {
      state.searchIndex = await fetchJson('search-index.json');
    } catch {
      state.searchIndex = state.pages.map((page) => ({ ...page, text: page.description, keywords: [] }));
    }
    await renderRoute();
  } catch (error) {
    elements.doc.innerHTML = `<section class="error-page"><strong>!</strong><h1>Kite docs could not start</h1><p>${escapeHtml(error.message)}</p></section>`;
  }
}

bootstrap();
