# Math-render audit

`math-render` is a reusable audit of mathematical Markdown. It answers whether
each emitted math span renders under the configured engine and returns a
structured, persistable report. It is not owned by any converter: LaTeX ingest
is its first workflow consumer, and future PDF-to-Markdown workflows can apply
the same contract to extracted math.

KaTeX is the current engine, not the capability boundary. The first-party
PowerShell and JavaScript live here; the third-party dependency is declared by
`brewery/node/package.json` and restored into `packages/node/node_modules`:

```powershell
./brewery/node/restore-node.ps1
```

## Interface

```powershell
. ./src/audits/math-render/math-render.ps1

Invoke-MathRenderAudit -Path ./paper.md -Strict
Invoke-MathRenderAudit -Path ./paper.md -Strict -OutputPath ./artifacts/example/audits/math-render.json
Invoke-MathRenderAudit -Spans @(
    @{ content = '\frac{1}{2}'; display = $true; id = 'formula-1' }
)
```

The report schema is `math-render-audit/1`. Render failures are report data
(`status: fail`, `clean: false`) rather than process failures, allowing an
agentic workflow to inspect and repair them. Missing dependencies, invalid
input, and engine failures throw because no trustworthy audit was produced.

The caller owns the durable report location. LaTeX ingest currently writes
`artifacts/latex-ingest/runs/{stamp}/{slug}/audits/math-render.json`; another
workflow should place the same report beneath its own run.
