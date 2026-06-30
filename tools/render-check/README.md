# render-check — KaTeX render-validity gate

The objective math standard for codex-scientiae markdown (STANDARDS.md §1): every embedded math span must
**render clean under KaTeX**. KaTeX-strict-clean implies it renders on GitHub's MathJax (MathJax is more
permissive), so this is the portable bar.

This is a tiny Node tool (`katex-check.js`) that renders each math span with `katex.renderToString` and reports
the ones KaTeX rejects, with the exact error (e.g. `Undefined control sequence: \R`). The PowerShell library
shim `src/render-check.ps1` (`Test-MathRenders`) is how the membrane / oracle call it.

```
node katex-check.js --file  <path.md>   [--strict]
node katex-check.js --spans <path.json> [--strict]   # JSON [{content, display, id}]
```

`katex` is pinned in `package.json` for reproducible benchmarking — run `npm install` here once. Node lives in
the portable env (PDenv/node); `Test-MathRenders` locates it.

"Renders clean under KaTeX" subsumes several membrane detectors as special cases: `alignment_outside_env`
(bare `&` → KaTeX error), `unbalanced_delimiters` (parse failure), `glyph_name_leak` (undefined control
sequence). This tool is the ground-truth render gate those heuristics approximate.
