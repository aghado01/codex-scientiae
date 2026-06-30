#!/usr/bin/env node
// katex-check.js — the codex render-validity gate. Math is rendered by KaTeX (the thing only JS can do);
// PowerShell (src/render-check.ps1) orchestrates. "Renders clean under KaTeX" is the objective math standard
// (STANDARDS.md §1) — the strict bar implies it renders on GitHub's MathJax.
//
//   node katex-check.js --file  <path.md>    [--strict]   # extract $$..$$ / $..$ from a markdown file
//   node katex-check.js --spans <path.json>  [--strict]   # validate a JSON array [{content, display, id}]
//
// Always prints one compact JSON line: {total, ok, failed, failures:[{id,kind,error,snippet}], strict, source}.
// Exit 0 on a produced report (pass or fail — read .failed), 2 on an input/usage error.
'use strict';
const fs = require('fs');
const katex = require('katex');

function extractSpans(md) {
  // drop fenced + inline code so $-looking content inside code is not treated as math
  md = md.replace(/```[\s\S]*?```/g, ' ').replace(/`[^`\n]*`/g, ' ');
  const spans = [];
  // display $$..$$ first (multiline); inner single-$ (e.g. $z$ in \text{}) stays in the content
  const rest = md.replace(/\$\$([\s\S]*?)\$\$/g, (_m, c) => { spans.push({ kind: 'display', content: c.trim() }); return ' '; });
  // inline $..$ on the remainder (unescaped, not $$, single line)
  const inlineRe = /(?<![\\$])\$(?!\$)([^$\n]+?)(?<!\\)\$(?!\$)/g;
  let m;
  while ((m = inlineRe.exec(rest)) !== null) spans.push({ kind: 'inline', content: m[1].trim() });
  return spans;
}

function validate(spans, strict) {
  let ok = 0;
  const failures = [];
  for (const s of spans) {
    const kind = s.kind || (s.display ? 'display' : 'inline');
    try {
      katex.renderToString(s.content, { displayMode: kind === 'display', throwOnError: true, strict: strict ? 'error' : 'ignore' });
      ok++;
    } catch (e) {
      failures.push({ id: s.id ?? null, kind, error: String(e.message).split('\n')[0], snippet: String(s.content).replace(/\s+/g, ' ').slice(0, 100) });
    }
  }
  return { total: spans.length, ok, failed: failures.length, failures };
}

function main() {
  const args = process.argv.slice(2);
  const strict = args.includes('--strict');
  const fi = args.indexOf('--file');
  const si = args.indexOf('--spans');
  let spans, source;
  try {
    if (fi >= 0 && args[fi + 1]) { source = args[fi + 1]; spans = extractSpans(fs.readFileSync(source, 'utf8')); }
    else if (si >= 0 && args[si + 1]) { source = args[si + 1]; spans = JSON.parse(fs.readFileSync(source, 'utf8')); }
    else { console.error('usage: katex-check.js (--file <md> | --spans <json>) [--strict]'); process.exit(2); }
  } catch (e) { console.error('input error: ' + e.message); process.exit(2); }
  const report = validate(spans, strict);
  report.strict = strict;
  report.source = source;
  console.log(JSON.stringify(report));
}
main();
