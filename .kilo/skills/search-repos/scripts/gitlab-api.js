'use strict';
/**
 * gitlab-api.js — shared GitLab REST API helpers (CommonJS)
 *
 * Consumed by gitlab-search-blobs and gitlab-search-all-projects.
 * All configuration comes from env vars set by the AI agent:
 *   GITLAB_SEARCH_URI    — API base, e.g. https://gitlab.example.com/api/v4
 *   GITLAB_SEARCH_TOKEN  — Personal access token with read_api scope
 */

function requireEnv() {
  const uri   = (process.env.GITLAB_SEARCH_URI || '').replace(/\/$/, '');
  const token = process.env.GITLAB_SEARCH_TOKEN || '';
  if (!uri)   { console.error('Error: GITLAB_SEARCH_URI is not set');   process.exit(1); }
  if (!token) { console.error('Error: GITLAB_SEARCH_TOKEN is not set'); process.exit(1); }
  return { uri, token };
}

/** Encode a project path (group/project) for use in URL segments. */
function encodeProject(idOrPath) {
  const s = String(idOrPath);
  return s.includes('/') && !s.includes('%') ? encodeURIComponent(s) : s;
}

const sleep = ms => new Promise(r => setTimeout(r, ms));

/**
 * Fetch a single GitLab API URL with automatic retry on 429 (rate limit).
 * Respects Retry-After header; falls back to exponential backoff (max 30s).
 * Throws on non-2xx after maxRetries exhausted.
 */
async function apiFetch(url, token, maxRetries) {
  if (maxRetries === undefined) maxRetries = 5;
  let attempt = 0;
  while (true) {
    const resp = await fetch(url, { headers: { 'PRIVATE-TOKEN': token } });
    if (resp.status === 429) {
      if (attempt >= maxRetries) {
        const body = await resp.text();
        throw new Error('HTTP 429 (rate limit, gave up after ' + maxRetries + ' retries) ' + url + ': ' + body);
      }
      const retryAfter = resp.headers.get('retry-after');
      const waitMs = retryAfter
        ? parseFloat(retryAfter) * 1000
        : Math.min(1000 * Math.pow(2, attempt), 30000);
      process.stderr.write('  \u23F3 Rate limited \u2014 waiting ' + Math.round(waitMs / 1000) + 's (attempt ' + (attempt + 1) + '/' + maxRetries + ')...\n');
      await sleep(waitMs);
      attempt++;
      continue;
    }
    if (!resp.ok) {
      const body = await resp.text();
      throw new Error('HTTP ' + resp.status + ' ' + url + ': ' + body);
    }
    return resp;
  }
}

/** Fetch all pages of a paginated GitLab endpoint (x-next-page header). */
async function fetchAllPages(token, firstUrl) {
  const items = [];
  let url = firstUrl;
  while (url) {
    const resp = await apiFetch(url, token);
    const page = await resp.json();
    if (Array.isArray(page)) items.push(...page);
    const nextPage = resp.headers.get('x-next-page');
    if (!nextPage) break;
    const u = new URL(url);
    u.searchParams.set('page', nextPage);
    url = u.toString();
  }
  return items;
}

/**
 * Run async task factories with bounded concurrency.
 * Returns array of { status:'fulfilled', value } | { status:'rejected', reason }
 */
async function pool(tasks, concurrency) {
  const results = new Array(tasks.length);
  let next = 0;
  async function worker() {
    while (next < tasks.length) {
      const idx = next++;
      try {
        results[idx] = { status: 'fulfilled', value: await tasks[idx]() };
      } catch (err) {
        results[idx] = { status: 'rejected', reason: err.message };
      }
    }
  }
  await Promise.all(Array.from({ length: Math.min(concurrency, tasks.length) }, worker));
  return results;
}

/** Search blobs in one project. Returns array of blob result objects. */
async function searchProjectBlobs(uri, token, projectId, searchTerm, opts) {
  const perPage = (opts && opts.perPage) || 20;
  const ref     = opts && opts.ref;
  const params  = new URLSearchParams({ scope: 'blobs', search: searchTerm, per_page: String(perPage) });
  if (ref) params.set('ref', ref);
  const url  = uri + '/projects/' + encodeProject(projectId) + '/search?' + params;
  const resp = await apiFetch(url, token);
  const data = await resp.json();
  return Array.isArray(data) ? data : [];
}

/** Fetch HEAD commit SHA for a project. Returns sha string or null on error. */
async function fetchHeadSha(uri, token, projectId) {
  try {
    const url  = uri + '/projects/' + encodeProject(projectId) + '/repository/commits?per_page=1';
    const resp = await apiFetch(url, token);
    const data = await resp.json();
    return Array.isArray(data) && data.length ? data[0].id : null;
  } catch (_) {
    return null;
  }
}

/** Build the effective search term (keyword + optional inline filter). */
function buildSearchTerm(keyword, filter) {
  return filter ? keyword + ' ' + filter : keyword;
}

// Parse a scope URL glob and return { group | null }.
//   "https://host/*/*"      -> { group: null }    (all projects, membership=true)
//   "https://host/group/*"  -> { group: 'group' } (one group + subgroups)
function parseScopeUrl(scopeUrl) {
  const url   = new URL(scopeUrl.trim());
  const parts = url.pathname.replace(/^\//, '').split('/').filter(Boolean);
  if (parts.length >= 2 && parts[parts.length - 2] === '*') {
    return { group: null };
  }
  const group = parts.slice(0, -1).join('/');
  return { group: group || null };
}

/** Print blob results in human-readable format. */
function printBlobResults(results, projectPath) {
  if (!results.length) return;
  const uniquePaths = [...new Set(results.map(r => r.path))];
  if (projectPath) console.log('\u2705 ' + projectPath);
  for (const filePath of uniquePaths) {
    const hits    = results.filter(r => r.path === filePath);
    const first   = hits[0];
    const snippet = first.data.trimEnd().split('\n').slice(0, 3).join('\n');
    console.log('   \uD83D\uDCC4 ' + filePath + '  (line ' + first.startline + ', ref: ' + first.ref + ')');
    console.log('      ' + snippet.replace(/\n/g, '\n      '));
  }
  if (projectPath) console.log();
}

module.exports = {
  requireEnv, encodeProject, apiFetch, fetchAllPages,
  pool, searchProjectBlobs, fetchHeadSha,
  buildSearchTerm, parseScopeUrl, printBlobResults,
};
