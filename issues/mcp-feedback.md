Findings
[P1] math_evidence probably disappears for current pig runs.
[serving.ps1 (line 401)](D:/aghado01/codex-scientiae/src/serving.ps1:401) derives the paper directory from the chunks path, then [math-evidence.ps1 (line 121)](D:/aghado01/codex-scientiae/src/pdf-converter/math-evidence.ps1:121) looks for {paper}/{slug}.letters.jsonl. But Invoke-Pdfdig writes letters under .runs/{stamp}/pig/ via [Invoke-Pdfdig.ps1 (line 61)](D:/aghado01/codex-scientiae/src/pdf-converter/Invoke-Pdfdig.ps1:61). So get_slice can silently omit evidence even when the converter produced it. I’d make evidence resolution run-aware, probably by deriving the pig lane dir from the chunk run.

[P1] publish does not appear to know about pdfdig-rendered images yet.
Pdfdig writes images/manifests into .runs/{stamp}/pig/images and .runs/{stamp}/pig/images.jsonl in [pdfdig-images.ps1 (line 42)](D:/aghado01/codex-scientiae/src/pdf-converter/pdfdig-images.ps1:42), but [publish.ps1 (line 163)](D:/aghado01/codex-scientiae/src/publish.ps1:163) still expects the older Docling-style {paper}/{slug}/imageFileN.png directory and extracts figure refs from {slug}.md. That means a pdfdig-only lane can have usable rendered figures and still publish with none.

[P2] The MCP story advertises pig conversion, but the tool surface does not expose it.
[mcp-server.ps1 (line 66)](D:/aghado01/codex-scientiae/src/mcp-server.ps1:66) says preprocess consumes already-produced IR and does not convert PDFs, while the initialization copy later describes the pig workflow as running Invoke-Pdfdig first at [mcp-server.ps1 (line 474)](D:/aghado01/codex-scientiae/src/mcp-server.ps1:474). The catalog/switch do not seem to include a pdfdig_convert/invoke_pdfdig tool. If intentional, fine; if not, this is the main workflow papercut for agents.

[P2] LaTeX diagram tests look stale against the current converter.
latex-ingest.ps1 now uses $script:DiagramStore at [latex-ingest.ps1 (line 759)](D:/aghado01/codex-scientiae/src/latex-ingest.ps1:759), but [latex-ingest.Tests.ps1 (line 160)](D:/aghado01/codex-scientiae/tests/latex-ingest.Tests.ps1:160) still asserts $script:TikzStore and .env. That kind of drift is especially risky here because the diagram/oracle layer is part of your converter spec, not a cosmetic side path.
