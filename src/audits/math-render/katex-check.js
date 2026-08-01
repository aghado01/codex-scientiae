#!/usr/bin/env node
// KaTeX-backed engine for the dependency-neutral math-render audit capability.
// The caller supplies the KaTeX package directory explicitly; first-party source does not rely on a
// use-case-local node_modules tree or ambient Node resolution.
//
//   node katex-check.js --katex <package-dir> --file  <path.md>   [--strict]
//   node katex-check.js --katex <package-dir> --spans <path.json> [--strict]
//
// Exit 0 means a report was produced, including reports with render failures. Exit 2 means the audit
// could not run because its arguments, dependency, or input were invalid.
'use strict';

const fs = require('fs');
const path = require('path');

function argument(args, name) {
  const index = args.indexOf(name);
  return index >= 0 ? args[index + 1] : undefined;
}

function extractSpans(markdown) {
  // Code is literal data, not mathematical Markdown.
  markdown = markdown.replace(/```[\s\S]*?```/g, ' ').replace(/`[^`\n]*`/g, ' ');
  const spans = [];
  // Extract display spans first so nested single dollars inside \text{} remain part of the display.
  const remainder = markdown.replace(/\$\$([\s\S]*?)\$\$/g, (_match, content) => {
    spans.push({ kind: 'display', content: content.trim() });
    return ' ';
  });
  const inline = /(?<![\\$])\$(?!\$)([^$\n]+?)(?<!\\)\$(?!\$)/g;
  let match;
  while ((match = inline.exec(remainder)) !== null) {
    spans.push({ kind: 'inline', content: match[1].trim() });
  }
  return spans;
}

function validate(katex, spans, strict) {
  let ok = 0;
  const failures = [];
  for (const span of spans) {
    const kind = span.kind || (span.display ? 'display' : 'inline');
    try {
      katex.renderToString(span.content, {
        displayMode: kind === 'display',
        throwOnError: true,
        strict: strict ? 'error' : 'ignore',
      });
      ok++;
    } catch (error) {
      failures.push({
        id: span.id ?? null,
        kind,
        error: String(error.message).split('\n')[0],
        snippet: String(span.content).replace(/\s+/g, ' ').slice(0, 100),
      });
    }
  }
  return { total: spans.length, ok, failed: failures.length, failures };
}

function main() {
  const args = process.argv.slice(2);
  const strict = args.includes('--strict');
  const katexDir = argument(args, '--katex');
  const file = argument(args, '--file');
  const spanFile = argument(args, '--spans');

  try {
    if (!katexDir) throw new Error('--katex <package-dir> is required');
    if (Boolean(file) === Boolean(spanFile)) throw new Error('choose exactly one of --file or --spans');

    const katex = require(path.resolve(katexDir));
    const katexPackage = JSON.parse(fs.readFileSync(path.join(path.resolve(katexDir), 'package.json'), 'utf8'));
    const source = file ? path.resolve(file) : 'spans';
    const spans = file
      ? extractSpans(fs.readFileSync(file, 'utf8'))
      : JSON.parse(fs.readFileSync(spanFile, 'utf8'));
    const counts = validate(katex, spans, strict);
    const clean = counts.failed === 0;
    const report = {
      schema: 'math-render-audit/1',
      capability: 'math-render',
      engine: { name: 'katex', version: String(katexPackage.version) },
      status: clean ? 'pass' : 'fail',
      clean,
      ...counts,
      strict,
      source,
    };
    console.log(JSON.stringify(report));
  } catch (error) {
    console.error(`math-render input error: ${error.message}`);
    process.exit(2);
  }
}

main();
