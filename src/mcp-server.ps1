#requires -Version 7.0
<#
  src/mcp-server.ps1 — a pure-PowerShell MCP server over the restoration membrane.

  MCP is a protocol, not a runtime: newline-delimited JSON-RPC 2.0 on stdin/stdout, one
  compact JSON object per line. stdout carries protocol frames ONLY — all logging goes to
  stderr, and every membrane call's output is captured (never left to render to stdout) so
  the stream stays clean. This server exposes serving.ps1's membrane as tools, rooted at a
  work dir where <paper>.chunks.jsonl artifacts live; every tool is paper-addressed, so the
  same server serves one document (depth-1) or a whole batch (depth-n) unchanged.

  Launch from a client's MCP config (-NoProfile keeps the profile off stdout):
    pwsh -NoProfile -File src/mcp-server.ps1 [-Root <ingestion-subtree>]

  -Root defaults to <repo>/ingestion (the raw-input boundary); which subtree to survey is a
  per-call concern, carried by the optional `scope` arg on list_documents/get_batch_summary/dispatch.
  The server's purview is the whole repo: read/repair are scoped to -Root (ingestion), while the
  post-finalize publish lane writes into -CompendiaRoot (<repo>/compendia by default).

  Tools: 29 ops. The paper-addressed membrane ops (list_documents … get_enrichables); `latex_convert`, the
  id-addressed LaTeX-oracle input lane (staged arXiv source -> codex markdown ground truth, the benchmark
  answer key); `render_check` + `markdown_lint`, the paper/path-addressed validity gates (does the math render
  under KaTeX; does the markdown structure conform to the standard); plus the post-finalize lane that closes
  the loop into the published corpus: `publish` (promote a
  finalized deliverable into compendia/{topic}/) and three path-addressed tools over promoted markdown —
  `repair_headings`, `update_doc_contents`, `splice_md` (the byte-offset analog of propose_edit).
  Prompts: restoration_procedure (serves PROCEDURE.md).
#>

[CmdletBinding()]
param(
    [string]$Root = (Join-Path (Split-Path -Parent $PSScriptRoot) 'ingestion'),
    [string]$CompendiaRoot = (Join-Path (Split-Path -Parent $PSScriptRoot) 'compendia'),
    [string]$ProtocolVersion = '2025-06-18'
)

. "$PSScriptRoot/serving.ps1"
. "$PSScriptRoot/restructure.ps1"
. "$PSScriptRoot/preprocess.ps1"
. "$PSScriptRoot/finalize.ps1"
. "$PSScriptRoot/md-repair.ps1"
. "$PSScriptRoot/publish.ps1"
. "$PSScriptRoot/latex-ingest.ps1"   # the LaTeX oracle lane (latex_convert): arXiv source -> codex markdown
. "$PSScriptRoot/render-check.ps1"   # math render-validity gate (render_check): does every span render in KaTeX
. "$PSScriptRoot/md-lint.ps1"        # markdown structure lint (markdown_lint): the non-math half of the standard

$ServerInfo = @{ name = 'codex-membrane'; version = '0.1.0' }

# --- tool catalogue: name -> description + JSON-Schema for arguments ---
# paper addressing (shared): a unique slug, or an ingestion-root-relative path when the slug is ambiguous
$PaperArg = @{ type = 'string'; description = 'a document slug (must be unique under the ingestion root — an ambiguous slug ERRORS listing the candidates) or an ingestion-root-relative paper-dir path to disambiguate, e.g. "compendia/membrane-testing/2508.11646v1". Resolves to the paper''s LATEST run; pin a specific run with @, e.g. "2508.11646v1@20260701_203601" (legacy dir: "@.scratch") — list_documents reports each paper''s latest_run.' }
$Tools = @(
    @{ name = 'list_documents'
       description = 'Survey the ingestion root: every paper raw with whether it has been preprocessed and its current milestone stage. Each row carries `lanes` — which IR intake dialect(s) exist for the paper: "opendataloader" ({slug}.json, the docling-era converter) and/or "pdfdig" ({slug}.pdfdig.json + {slug}.nodes.jsonl, the in-house deterministic PdfPig lane). Body-blind. The "Go" starting point.'
       inputSchema = @{ type = 'object'; properties = @{ scope = @{ type = 'string'; description = 'optional subtree under the ingestion root to survey, e.g. "compendia/ph" or "codices" (default: whole ingestion root)' } } } }
    @{ name = 'preprocess'
       description = 'START a fresh workflow: run the staged pipeline on a document''s raw IR, landing the enriched chunk stream + sidecars in a NEW runstamped dir ({paper}/.runs/{yyyyMMdd_HHmmss}/) and logging the preprocessed milestone. TWO IR LANES are accepted (see list_documents `lanes`; choose with the optional `lane` arg, default prefers opendataloader when both exist): "opendataloader" = docling-era IR — heading recovery + furniture detection run downstream to compensate converter damage; "pdfdig" = the in-house deterministic lane — headings arrive PRE-typed (typography + PDF-outline cross-derivation; heading recovery is skipped), inline math carries $-seams with geometric sub/superscripts, formula chunks are grouped display-math lines (2-D assembly pending), page furniture is already dropped, ligatures/symbol corrections already applied; node flags[] are the converter''s own uncertainty markers, not detected corruption. The result echoes ir_lane (+ lane_notes on pdfdig). Every call creates a new run — prior runs are never touched, but the new run becomes the paper''s current view (the result flags a displaced run that carries applied/finalized work, with its @pin address). To CONTINUE existing work use the read/repair tools, which resolve the latest run or any pinned {paper}@{run}. Batch on-ramps: preprocess only docs list_documents shows unprepped.'
       inputSchema = @{ type = 'object'; properties = @{ paper = $PaperArg; lane = @{ type = 'string'; enum = @('auto','opendataloader','pdfdig'); description = 'IR intake lane (default auto: opendataloader if present, else pdfdig)' } }; required = @('paper') } }
    @{ name = 'latex_convert'
       description = 'The LaTeX ORACLE: convert a staged arXiv LaTeX source into codex-standard markdown — the near-lossless, algorithmic ground truth used as the answer key for benchmarking docling-repair conversion quality (the benchmark workflow). This is the in-house alternative to pandoc/latexml — do NOT shell out to pandoc. It expands \newcommand macros to primitives (renderable KaTeX), wraps alignment envs in \begin{aligned}, resolves \cite/\ref/\eqref to numbers, numbers theorems/lemmas, and emits a references section. Reads the staged _inbox/<id>/<id>.tar.gz, unpacks the source into a runstamped working dir beside it (.runs/{stamp}/tex — persisted like any other intermediate, so the math-bank/skeleton lanes can re-read it), writes _inbox/<id>/<id>.latex.md, and carries referenced figures out beside the deliverable; returns the path + stats (bytes, macros, sections, references, figures, diagrams, run). Requires the "source" artifact staged first via codex-arxiv fetch (artifacts: ["source"]) — a PDF-only paper has no LaTeX source.'
       inputSchema = @{ type = 'object'; properties = @{ id = @{ type = 'string'; description = 'arXiv id whose LaTeX source is already staged in _inbox, e.g. 1611.03935' } }; required = @('id') } }
    @{ name = 'render_check'
       description = 'Validate that every math span in a markdown deliverable RENDERS under KaTeX — the objective math standard (STANDARDS §1): KaTeX-strict-clean implies it renders on GitHub''s MathJax. Reports total/ok/failed plus each failure with its exact KaTeX error (undefined control sequence, unbalanced delimiters, bare & outside an environment — the render-level view of the membrane detectors). Address by `paper` (its latest run''s finalized <slug>.md) OR a repo-relative `path` (e.g. the LaTeX oracle _inbox/<id>/<id>.latex.md, or a promoted compendia file). strict=true is the KaTeX-strict bar. Requires node + the pinned katex in tools/render-check.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; path = @{ type = 'string'; description = 'repo-relative .md path (alternative to paper)' }; strict = @{ type = 'boolean'; description = 'KaTeX-strict bar (default false)' } } } }
    @{ name = 'markdown_lint'
       description = 'Structure-lint a markdown deliverable with markdownlint against the codex-aligned config (heading hierarchy §5, spacing hygiene §4; line-length disabled since the codex removes hard wraps). The NON-math half of the standard — math render-validity is the separate render_check gate. Reports each issue with line + rule (e.g. MD022 blanks-around-headings, MD012 no-multiple-blanks, MD018 no-missing-space-atx). Address by `paper` (latest run''s <slug>.md) OR a repo-relative `path`. Requires node + markdownlint in tools/md-lint.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; path = @{ type = 'string'; description = 'repo-relative .md path (alternative to paper)' } } } }
    @{ name = 'get_inventory'
       description = 'The in-play artifacts registered for a document: each durable file with stage, record count, byte size, and source (the build chain). The object-state window, complementing the milestone ledger.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' } }; required = @('paper') } }
    @{ name = 'finalize'
       description = 'Close the loop: serialize the repaired chunk stream into the corpus deliverable — a {slug}.md body (H1 title, Contents, sections at depth, block math fenced) plus a references/{slug}.md bibliography sidecar, per STANDARDS.md. First pass writes into the document''s current run dir. Returns counts; pending = flagged chunks still unresolved (the deliverable is provisional while pending > 0). Logs the finalized milestone.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' } }; required = @('paper') } }
    @{ name = 'review_document'
       description = 'The one sanctioned holistic read, and the only pass that reads the assembled body for sense. The membrane is body-blind by design — the repair loop works scoped slices and never re-reads the whole paper. Call this ONCE at the end, after repairs are applied: it assembles the deliverable and returns the full body + references sidecar plus the still-flagged chunks (id + reason). Content IS the return here. NOTE: faithful means the LaTeX is structurally valid (delimiters/environments balance), NOT that the math is correct — the gate never reads an equation for meaning; that is this pass. Read every display equation as a statement and check: completeness (ends mid-operator? degenerate \substack / \max with no body? thinner than its label?), prose smuggled into \text{} that duplicates a neighbouring paragraph, a symbol that appears in exactly one equation (hallucination tell), and figure captions that do not match the paper subject. Fix anything you catch with propose_edit on the named chunk, then review again; if an equation is destroyed beyond in-place repair, recover from source (acquire the arXiv LaTeX).'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' } }; required = @('paper') } }
    @{ name = 'get_summary'
       description = 'Body-blind metadata map of one document: title, zones, section count, repaired/flagged counts, remaining hotspots by type, enrichable count (orthogonal to flagged/pending).'
       inputSchema = @{ type = 'object'; properties = @{ paper = $PaperArg }; required = @('paper') } }
    @{ name = 'get_enrichables'
       description = 'Post-fidelity enrichment lane: surface unwrapped ASCII-math candidates from prose chunk content (faithful, math_dirt<2), bucketed safe-wrap vs lossy and labeled auto/review/escalate. Separate from dispatch; does not move flagged/pending. Tier 1 is propose-only — worker confirms each safe-wrap via propose_edit.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' } }; required = @('paper') } }
    @{ name = 'get_hotspots'
       description = 'The graded work-list for a document: each flagged chunk with id, page, grade, corruption_type, section, agreement (0-1 structural-ambiguity score, lower = more disputed; a span takes the min over its members), preview. Hotspots may span multiple chunks, returning span (array of ids) and kind (e.g. fragmented_formula).'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; type = @{ type = 'string'; description = 'optional corruption_type filter' } }; required = @('paper') } }
    @{ name = 'get_slice'
       description = 'Return exactly one chunk by id (plus optional +/- context neighbours), seeked via the .jidx index. Can optionally bound the forward range precisely with to_id. The anchor record also carries a body-light work_order: the composed, ordered (structural-before-content) list of EVERY issue in the deliverable, each with its repair recipe and localized spans ([start,end) offsets where known — unwrapped_math today) — work the whole order in one pass. A forward range (id..to_id) is the fragmented-formula span deliverable; the order leads with the merge instruction and pools all members'' issues.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; context = @{ type = 'integer'; description = 'neighbours each side (default 0)' }; to_id = @{ type = 'integer'; description = 'optional explicit upper bound id for exact range slicing' } }; required = @('paper', 'id') } }
    @{ name = 'propose_edit'
       description = 'Pointed surgical fix on one chunk: replace a UNIQUE find-string with replace (empty replace = delete). Never regenerates the chunk -- send only the diff. Stacks on prior staged edits; reports whether the result is clean or still flagged (with diagnostic). The hard gate is commit. PREFER this over propose_repair.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; find = @{ type = 'string'; description = 'exact substring to replace; must occur exactly once in the current content' }; replace = @{ type = 'string'; description = 'replacement text (empty string deletes the find)' }; source = @{ type = 'string' } }; required = @('paper', 'id', 'find', 'replace') } }
    @{ name = 'propose_repair'
       description = 'Wholesale fallback: stage full replacement content for one chunk. Use ONLY when corruption is so total there is no anchor for propose_edit. Accepted only if it passes the corruption detector; a rejection returns the precise delimiter diagnostic.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; content = @{ type = 'string' }; source = @{ type = 'string' } }; required = @('paper', 'id', 'content') } }
    @{ name = 'apply'
       description = 'Fold all staged proposals for a document into the stream (only clean ones merge; still-flagged stay staged), clear the leases merged, and log the milestone. NOT a git commit.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' } }; required = @('paper') } }
    @{ name = 'release'
       description = 'Free leased work-units abandoned by a worker so they can be re-dispatched. Pass ids to release some, or omit to release all of a document.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; ids = @{ type = 'array'; items = @{ type = 'integer' } } }; required = @('paper') } }
    @{ name = 'retype_chunk'
       description = 'Structural: change the type of one chunk (e.g. a formula mis-typed as prose). In place, no id change; re-grades the chunk. Rejects geometry impossibilities (prose mislabeled as formula, bare alignment outside an env); unbalanced content is allowed — the content-repair path fixes it after retype.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; new_type = @{ type = 'string'; description = 'e.g. formula | prose | heading | table | list' } }; required = @('paper', 'id', 'new_type') } }
    @{ name = 'split_chunk'
       description = 'Structural: split one chunk into two at a UNIQUE marker (the marker begins the second chunk). Renumbers ids + rebuilds the index, so re-orient after. Refuses while content proposals are staged. Rejects when either half would orphan delimiters (unbalanced across the cut).'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; before = @{ type = 'string'; description = 'unique substring that starts the second chunk' } }; required = @('paper', 'id', 'before') } }
    @{ name = 'merge_chunks'
       description = 'Structural: merge a contiguous run of chunks into one (e.g. a formula fragmented across chunks). Renumbers ids + rebuilds the index, so re-orient after. Refuses while content proposals are staged. Rejects geometry impossibilities (prose mislabeled as formula, bare alignment) and merges that WORSEN delimiter balance; partial-balance fragmented-formula joins pass so the worker can close the seam after merge.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; ids = @{ type = 'array'; items = @{ type = 'integer' }; description = 'contiguous chunk ids' } }; required = @('paper', 'ids') } }
    @{ name = 'get_batch_summary'
       description = 'Body-blind batch map: per document under the server root, counts (chunks, pages, repaired, actionable, handoff) plus the actionable byte-size. The orchestrator plans and budgets the whole batch from this without reading any bodies.'
       inputSchema = @{ type = 'object'; properties = @{ scope = @{ type = 'string'; description = 'optional subtree under the ingestion root to survey, e.g. "compendia/ph" or "codices" (default: whole ingestion root)' } } } }
    @{ name = 'dispatch'
       description = 'Return the next bundle of agent-actionable work-unit pointers (paper, id, grade, section, seam, agreement — never content) whose total size fits a byte budget, ORDERED by ascending agreement (most structurally-disputed first; a stable sort, so ties keep document order and re-runs reproduce). Ranking only: the work-SET and budget gate are unchanged, only the order moves. The orchestrator fans its workers over them. Stateless: commit between dispatches. May return span (array of ids) and kind for grouped hotspots. Each pointer also carries issues (the multi-issue profile of its deliverable) for routing; the full composed work-order is returned at get_slice time.'
       inputSchema = @{ type = 'object'; properties = @{ budget_bytes = @{ type = 'integer'; description = 'max total content bytes in the bundle (default 40000)' }; paper = @{ type = 'string'; description = 'optional: restrict to one document' }; scope = @{ type = 'string'; description = 'optional subtree under the ingestion root to draw work from, e.g. "compendia/ph" or "codices" (default: whole ingestion root)' } } } }
    @{ name = 'search'
       description = 'Restoration-native query over a document: filter chunks by any combination of zone, section (regex), grade, type, page, content (regex). Returns body-light pointers (id, page, type, grade, section, preview), capped at limit.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; zone = @{ type = 'string' }; section = @{ type = 'string'; description = 'regex' }; grade = @{ type = 'string'; description = 'faithful|repaired|needs_review|needs_repair|suspect|unrecoverable' }; type = @{ type = 'string'; description = 'prose|formula|heading|table|list' }; page = @{ type = 'integer' }; contains = @{ type = 'string'; description = 'content regex' }; limit = @{ type = 'integer' } }; required = @('paper') } }
    @{ name = 'get_audit'
       description = 'Provenance of what the pipeline removed or changed. No filter -> per-kind counts; with id or kind -> the matching records. Kinds: discards (figure debris), repair (excised tails), apply (agent before/after), structure (retype/split/merge).'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; kind = @{ type = 'string'; description = 'discards|repair|apply|structure' } }; required = @('paper') } }
    @{ name = 'mark_unrecoverable'
       description = 'Terminal escalation: the agent tried and cannot repair this chunk from the export. Sets fidelity=unrecoverable (the rare hand-off that earns re-extraction by the successor) and drops any staged edit. Use sparingly -- a high unrecoverable rate indicts the repair attempt, not the export.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; reason = @{ type = 'string' } }; required = @('paper', 'id') } }
    @{ name = 'request_review'
       description = 'Human check-in: queue a chunk for the supervising user with a message (surfaces as review_pending in get_summary). Use when uncertain rather than guessing.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; id = @{ type = 'integer' }; message = @{ type = 'string' } }; required = @('paper', 'id', 'message') } }
    @{ name = 'publish'
       description = 'Close the loop into the published corpus: promote a finalized deliverable from its run-dir staging into compendia/{topic}/. (Re)materializes via finalize, then writes {slug}.md (figure links rewritten to the nested images/{slug}/ form), the references/{slug}.md sidecar, and only the figures the body references (images/{slug}/imageFileN). Upserts the paper''s _CONTENTS.md block non-destructively — replaced in place if present (thematic ordering preserved), else appended and flagged for the curator. Refuses while the deliverable is provisional (pending>0) unless force=true. Pass dry_run=true to preview the full manifest without moving anything. Logs the published milestone.'
       inputSchema = @{ type = 'object'; properties = @{ paper = @{ type = 'string' }; topic = @{ type = 'string'; description = 'compendia subfolder, e.g. "ph" or "mapper"' }; force = @{ type = 'boolean'; description = 'publish even while pending>0' }; dry_run = @{ type = 'boolean'; description = 'preview the manifest, move nothing' } }; required = @('paper', 'topic') } }
    @{ name = 'repair_headings'
       description = 'Detect + (optionally) auto-fix over-promoted headings in a PROMOTED markdown file by byte-offset anchor: float captions ("Figure 1 ...") and theorem-environment labels ("Proposition 3 ...") demote to bold; furniture / fused-body / table-fragment headings are isolated as escalations. With apply=false (default) it only reports; with apply=true it lands the confident fixes back-to-front. Returns a digest plus the escalation list, each carrying the {offset,length,raw} anchor to hand to splice_md. Path is repo-relative (e.g. "compendia/ph/1907.04889v2.md").'
       inputSchema = @{ type = 'object'; properties = @{ path = @{ type = 'string'; description = 'repo-relative path to a .md file' }; apply = @{ type = 'boolean'; description = 'land the confident fixes (default: report only)' } }; required = @('path') } }
    @{ name = 'update_doc_contents'
       description = 'Regenerate a promoted document''s "## Contents" block from its current KEEP headings (H2+), so the in-doc TOC stops listing demoted/escalated headings and dead anchors. Indentation is hierarchical (2 spaces per heading level); an existing References sidecar link is preserved. apply=false (default) reports the entry count; apply=true rewrites the block. Run after repair_headings. Path is repo-relative.'
       inputSchema = @{ type = 'object'; properties = @{ path = @{ type = 'string'; description = 'repo-relative path to a .md file' }; apply = @{ type = 'boolean' } }; required = @('path') } }
    @{ name = 'splice_md'
       description = 'The byte-offset analog of propose_edit for promoted markdown (no JSON/IR post-promotion): replace exactly `length` bytes at byte `offset` with `replacement`. Pass `expect` (the current bytes at that span, e.g. an escalation''s `raw`) and a stale/shifted offset fails loudly instead of corrupting. This is how an agent lands a hand-authored fix for a repair_headings escalation. Path is repo-relative. UTF-8 no-BOM; offsets index on-disk bytes so SMP math / ligatures stay exact.'
       inputSchema = @{ type = 'object'; properties = @{ path = @{ type = 'string'; description = 'repo-relative path to a .md file' }; offset = @{ type = 'integer' }; length = @{ type = 'integer' }; replacement = @{ type = 'string' }; expect = @{ type = 'string'; description = 'optional guard: the exact bytes currently at [offset,+length]' } }; required = @('path', 'offset', 'length', 'replacement') } }
)

# --- prompt catalogue: the Layer-2 procedure, served so a client injects it into the agent's context ---
# MVP is one prompt (the membrane is depth-invariant, so a single procedure text serves orchestrator and
# worker alike); a later role-split (orchestrator_procedure / worker_procedure) + a constitution prompt slot here.
$Prompts = @(
    @{ name = 'restoration_procedure'
       description = 'The canonical restoration workflow: the law of exposure, the orchestrator batch loop, the per-unit worker loop, the repair playbook by corruption_type, and escalation. Inject at the start of a repair session.' }
)
function Get-PromptText([string]$name) {
    switch ($name) {
        'restoration_procedure' { return [System.IO.File]::ReadAllText((Join-Path $PSScriptRoot 'PROCEDURE.md'), [System.Text.UTF8Encoding]::new($false)) }
        default { throw "prompt not found: $name" }
    }
}

# --- helpers ---
# Paper addressing delegates to serving.ps1 (Resolve-PaperDir and friends): a bare slug must be
# UNIQUE under $Root — an ambiguous slug throws listing the candidates (never first-hit-wins) —
# or an ingestion-root-relative paper-dir path disambiguates. Chunks resolve to the LATEST run
# unless the address pins one ({paper}@{run}). Every resolution records WHICH run it landed on
# ($script:RunCtx) so the tool result can echo it — the agent must never have to guess its run.
function Resolve-Paper([string]$paper) {
    $c = Resolve-PaperChunks -Root $Root -Paper $paper
    $script:RunCtx = [pscustomobject]@{ paper = ((Split-Path -Leaf $c) -replace '\.chunks\.jsonl$', ''); run = (Get-RunName $c) }
    return $c
}
function Resolve-Source([string]$paper, [string]$lane = 'auto') {
    if ([string]::IsNullOrWhiteSpace($lane)) { $lane = 'auto' }
    return Resolve-PaperSource -Root $Root -Paper $paper -Lane $lane
}
# Work-scope (runtime concern): empty -> the whole ingestion root; else a subtree under it,
# full-path-normalized and confined to $Root (no escaping via .. or absolute paths).
function Resolve-Scope([string]$scope) {
    if ([string]::IsNullOrWhiteSpace($scope)) { return $Root }
    $rootFull = [System.IO.Path]::GetFullPath($Root)
    $full     = [System.IO.Path]::GetFullPath((Join-Path $rootFull $scope))
    $sep      = [System.IO.Path]::DirectorySeparatorChar
    $rootPfx  = $rootFull.TrimEnd($sep) + $sep
    if (-not ("$full$sep").StartsWith($rootPfx, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "scope escapes the ingestion root: '$scope'"
    }
    return $full
}
# Resolve a path-addressed argument (promoted markdown) for the md-repair lane. Accepts a repo-relative
# path (e.g. "compendia/ph/1907.04889v2.md") or an absolute one, normalizes it, and confines it to the
# repo root (the server's purview) — no escaping via .. or a foreign drive. Must be an existing file.
function Resolve-RepoPath([string]$path) {
    if ([string]::IsNullOrWhiteSpace($path)) { throw "path required" }
    $repoFull  = [System.IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
    $candidate = if ([System.IO.Path]::IsPathRooted($path)) { $path } else { Join-Path $repoFull $path }
    $full      = [System.IO.Path]::GetFullPath($candidate)
    $sep       = [System.IO.Path]::DirectorySeparatorChar
    $repoPfx   = $repoFull.TrimEnd($sep) + $sep
    if (-not "$full".StartsWith($repoPfx, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "path escapes the repo root: '$path'"
    }
    if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { throw "file not found: $path" }
    return $full
}
# Resolve a markdown deliverable to lint/render-check: a `path` (repo-relative, e.g. the oracle or a promoted
# file) takes precedence; else a `paper` resolves to the finalized <slug>.md sibling of its latest run's chunk stream.
function Resolve-Deliverable([string]$paper, [string]$path) {
    if (-not [string]::IsNullOrWhiteSpace($path)) { return Resolve-RepoPath $path }
    if (-not [string]::IsNullOrWhiteSpace($paper)) {
        $md = (Resolve-Paper $paper) -replace '\.chunks\.jsonl$', '.md'
        if (-not (Test-Path -LiteralPath $md)) { throw "no finalized deliverable for '$paper' (run finalize first): $md" }
        return $md
    }
    throw 'provide paper or path'
}

function Invoke-Tool([string]$name, $arguments) {
    $script:RunCtx = $null   # set by Resolve-Paper when this call addresses a paper's chunk stream
    switch ($name) {
        'list_documents' { $out = @(Get-IngestionScan -Root (Resolve-Scope $arguments.scope)) }
        'preprocess'     { $out = Invoke-Preprocess -JsonPath (Resolve-Source $arguments.paper $arguments.lane) }
        'latex_convert' {
            $id = [string]$arguments.id
            if ([string]::IsNullOrWhiteSpace($id) -or $id -notmatch '^[\w.\-]+$') { throw "invalid arXiv id: '$id'" }
            $dir = Join-Path $Root "_inbox/$id"
            $tarItem = if (Test-Path -LiteralPath $dir) { Get-ChildItem -LiteralPath $dir -Filter '*.tar.gz' -File -ErrorAction SilentlyContinue | Select-Object -First 1 } else { $null }
            $tar = if ($tarItem) { $tarItem.FullName } else { @(Invoke-Crawl -Root $Root -Patterns "**/_inbox/$id/*.tar.gz" -Semantics Include) | Select-Object -First 1 }
            if (-not $tar) { throw "no staged LaTeX source (.tar.gz) for '$id' under _inbox -- stage it first with codex-arxiv fetch (artifacts: source)" }
            $out = Invoke-ArxivLatexToMarkdown -TarGz $tar -Slug $id -OutDir (Split-Path -Parent $tar)   # lane tag is added by the write target -> {id}-latex.md (STANDARDS §9)
        }
        'render_check'  { $out = Test-MathRenders  -Path (Resolve-Deliverable ([string]$arguments.paper) ([string]$arguments.path)) -Strict:([bool]$arguments.strict) }
        'markdown_lint' { $out = Test-MarkdownLint -Path (Resolve-Deliverable ([string]$arguments.paper) ([string]$arguments.path)) }
        'get_inventory'  { $out = Get-Inventory (Resolve-Paper $arguments.paper) }
        'finalize'        { $out = Invoke-Finalize  -ChunksPath (Resolve-Paper $arguments.paper) }
        'review_document' { $out = Get-FinalReview  (Resolve-Paper $arguments.paper) }
        'get_summary'  { $out = Get-IrSummary -ChunksPath (Resolve-Paper $arguments.paper) }
        'get_enrichables' { $out = @(Get-Enrichables -ChunksPath (Resolve-Paper $arguments.paper)) }
        'get_hotspots' {
            $p = Resolve-Paper $arguments.paper
            $out = if ($arguments.type) { Get-IrHotspots -ChunksPath $p -Type ([string]$arguments.type) } else { Get-IrHotspots -ChunksPath $p }
        }
        'get_slice'    { $out = Get-Slice -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -Context ([int]$arguments.context) -ToId $(if ($null -ne $arguments.to_id) { [int]$arguments.to_id } else { -1 }) }
        'propose_edit' {
            $src = if ($arguments.source) { [string]$arguments.source } else { 'worker' }
            $out = Add-RepairEdit -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -Find ([string]$arguments.find) -Replace ([string]$arguments.replace) -Source $src
        }
        'propose_repair' {
            $src = if ($arguments.source) { [string]$arguments.source } else { 'worker' }
            $out = Add-RepairProposal -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -Content ([string]$arguments.content) -Source $src
        }
        'apply'        { $out = Invoke-RepairApply -ChunksPath (Resolve-Paper $arguments.paper) }
        'release'      { $rids = if ($arguments.ids) { [int[]]@($arguments.ids) } else { @() }; $out = Clear-Leases -ChunksPath (Resolve-Paper $arguments.paper) -Ids $rids }
        'retype_chunk' { $out = Set-ChunkType -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -NewType ([string]$arguments.new_type) }
        'split_chunk'  { $out = Split-Chunk   -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -Before ([string]$arguments.before) }
        'merge_chunks' { $out = Merge-Chunks  -ChunksPath (Resolve-Paper $arguments.paper) -Ids ([int[]]@($arguments.ids)) }
        'get_batch_summary' { $out = @(Get-BatchSummary -Root (Resolve-Scope $arguments.scope)) }
        'dispatch' {
            $bud = if ($arguments.budget_bytes) { [long]$arguments.budget_bytes } else { 40000 }
            $eff = Resolve-Scope $arguments.scope
            $out = if ($arguments.paper) { Invoke-Dispatch -Root $eff -BudgetBytes $bud -Paper ([string]$arguments.paper) } else { Invoke-Dispatch -Root $eff -BudgetBytes $bud }
        }
        'search' {
            $out = Search-Chunks -ChunksPath (Resolve-Paper $arguments.paper) `
                -Zone ([string]$arguments.zone) -Section ([string]$arguments.section) -Grade ([string]$arguments.grade) `
                -Type ([string]$arguments.type) -Page $(if ($null -ne $arguments.page) { [int]$arguments.page } else { -1 }) `
                -Contains ([string]$arguments.contains) -Limit $(if ($arguments.limit) { [int]$arguments.limit } else { 50 })
        }
        'get_audit'          { $out = Get-Audit -ChunksPath (Resolve-Paper $arguments.paper) -Id $(if ($null -ne $arguments.id) { [int]$arguments.id } else { -1 }) -Kind ([string]$arguments.kind) }
        'mark_unrecoverable' { $out = Set-Unrecoverable -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -Reason ([string]$arguments.reason) }
        'request_review'     { $out = Add-ReviewRequest -ChunksPath (Resolve-Paper $arguments.paper) -Id ([int]$arguments.id) -Message ([string]$arguments.message) }
        'publish' {
            $out = Invoke-Publish -ChunksPath (Resolve-Paper $arguments.paper) -CompendiaRoot $CompendiaRoot `
                -Topic ([string]$arguments.topic) -Force:([bool]$arguments.force) -DryRun:([bool]$arguments.dry_run)
        }
        'repair_headings'     { $out = Repair-MdHeadings -Path (Resolve-RepoPath ([string]$arguments.path)) -Apply:([bool]$arguments.apply) }
        'update_doc_contents' { $out = Update-MdContents  -Path (Resolve-RepoPath ([string]$arguments.path)) -Apply:([bool]$arguments.apply) }
        'splice_md' {
            $p = Resolve-RepoPath ([string]$arguments.path)
            $out = if ($null -ne $arguments.expect) {
                Set-MdSpan -Path $p -Offset ([int]$arguments.offset) -Length ([int]$arguments.length) -Replacement ([string]$arguments.replacement) -Expect ([string]$arguments.expect)
            } else {
                Set-MdSpan -Path $p -Offset ([int]$arguments.offset) -Length ([int]$arguments.length) -Replacement ([string]$arguments.replacement)
            }
        }
        default        { throw "unknown tool: $name" }
    }
    # --- run visibility: every paper-addressed result names the run it operated on, so the agent
    #     never has to guess which run is active. Object results carry paper/run in place; list
    #     results are enveloped as {paper, run, count, items}. (dispatch/get_batch_summary rows
    #     carry per-row run themselves — they are root-scoped, not paper-addressed.)
    if ($script:RunCtx -and $null -ne $out) {
        if ($out -is [System.Management.Automation.PSCustomObject]) {
            if (-not $out.PSObject.Properties['paper']) { $out | Add-Member -NotePropertyName paper -NotePropertyValue $script:RunCtx.paper }
            if (-not $out.PSObject.Properties['run'])   { $out | Add-Member -NotePropertyName run   -NotePropertyValue $script:RunCtx.run }
        } elseif ($out -is [System.Collections.IEnumerable] -and $out -isnot [string]) {
            $out = [pscustomobject]@{ paper = $script:RunCtx.paper; run = $script:RunCtx.run; count = @($out).Count; items = @($out) }
        }
    }
    $text = if ($null -eq $out) { '(no output)' } else { $out | ConvertTo-Json -Depth 12 -Compress }
    return @{ content = @(@{ type = 'text'; text = $text }) }
}

# Belt-and-suspenders around the tool dispatch: a stray Write-Host/Write-Warning/Write-Verbose/
# Write-Debug inside a membrane call must never reach a stdout frame. PowerShell cannot redirect a
# stream to stderr directly (`n>&2` is reserved), so we merge the Information(6)/Warning(3)/
# Verbose(4)/Debug(5) streams into success and split by record type: the tool's stream-1 result
# (a hashtable) is returned; everything else is forwarded to stderr. (The SetOut backstop already
# routes host writes to stderr; this catches any host variant that bypasses [Console]::Out.)
function Invoke-ToolGuarded([string]$name, $arguments) {
    $result = $null
    Invoke-Tool $name $arguments 3>&1 4>&1 5>&1 6>&1 | ForEach-Object {
        if ($_ -is [System.Collections.IDictionary]) { $result = $_ }   # the tool result
        else { [Console]::Error.WriteLine([string]$_) }                 # diagnostics -> stderr
    }
    return $result
}

# --- own the protocol channel at the .NET level, pinned to UTF-8 (no BOM) ---
# Redirected std streams on Windows otherwise default to the ANSI/OEM code page, which collapses
# SMP Unicode (𝔼, surrogate pairs) and accented glyphs to '?'/U+FFFD on both read and write. We
# take explicit ownership before any frame moves: a UTF-8 reader on stdin, a UTF-8 auto-flushing
# writer on stdout, and we point the ambient Console.Out at stderr so a stray host write from a
# dot-sourced lib lands in the log, never mid-frame on stdout.
# Belt-and-suspenders: pin the console code page to UTF-8 too. The StreamReader/Writer below already
# own the protocol channel, so this does NOT fix the channel — it protects any *child* process the
# server (or a future tool) spawns from inheriting the host's ANSI/OEM (cp1252) code page. (The
# encoding crashes in the field briefs were in agent-authored scratch scripts, not this server.)
[Console]::InputEncoding  = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$utf8 = [System.Text.UTF8Encoding]::new($false)                                   # no BOM
$script:Rpc = [System.IO.StreamWriter]::new([Console]::OpenStandardOutput(), $utf8); $script:Rpc.AutoFlush = $true
$script:In  = [System.IO.StreamReader]::new([Console]::OpenStandardInput(),  $utf8)
[Console]::SetOut([Console]::Error)   # backstop: ambient console-out -> stderr (frames go via $script:Rpc)

# Server-side logging: stderr only, never stdout (stdout carries protocol frames exclusively).
function Write-Log([string]$m) { [Console]::Error.WriteLine($m) }

# --- JSON-RPC framing (one compact line per message; stdout = protocol only) ---
function Write-Rpc($id, $result) {
    $script:Rpc.WriteLine((@{ jsonrpc = '2.0'; id = $id; result = $result } | ConvertTo-Json -Depth 16 -Compress))
}
function Write-RpcError($id, [int]$code, [string]$message) {
    $script:Rpc.WriteLine((@{ jsonrpc = '2.0'; id = $id; error = @{ code = $code; message = $message } } | ConvertTo-Json -Depth 8 -Compress))
}

# Startup ceremony, part 1: confirm the root is a real directory. A missing/!directory root is a
# deployment error, not a work state -- and the crawler (crawl.ps1) treats a dead root and an empty
# one identically (both yield nothing), so an agent reading only a projection can't tell "nothing to
# do" from "dead mount". We disambiguate at the ceremony: a dead root is fatal here; part 2 (the
# discovery walk in `initialize`) hands the agent its bearings. With the derived default root this
# fatal path is rare by construction.
$script:Fatal = $null
$script:Readiness = $null   # cached discovery summary, surfaced to the agent via initialize.instructions
$script:Initialized = $false
if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
    $script:Fatal = "ingestion root not found or not a directory: $Root -- correct the -Root launch argument or create the directory and reconnect, or escalate to the user. The server cannot survey documents or resolve papers until the root mounts."
    Write-Log "FATAL: $script:Fatal"
} else {
    Write-Log "codex-membrane MCP server up (root=$Root)"
}

# --- main loop: newline-delimited JSON-RPC from stdin until EOF ($script:In.ReadLine() -> $null) ---
while ($null -ne ($line = $script:In.ReadLine())) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    try { $req = $line | ConvertFrom-Json } catch { Write-RpcError $null -32700 'parse error'; continue }

    $hasId = $null -ne $req.PSObject.Properties['id']
    $id = if ($hasId) { $req.id } else { $null }

    # Daemon backstop: no single request may crash the loop. tools/call has its own isError handling;
    # this catches anything else (a survey throwing on a malformed unit, etc.) and keeps the server up.
    try {
    if (-not $script:Initialized -and $req.method -ne 'initialize' -and $req.method -ne 'ping') {
        if ($hasId) { Write-RpcError $id -32600 "not initialized" }
        continue
    }
    switch ($req.method) {
        'initialize' {
            $pv = if ($req.params.protocolVersion) { [string]$req.params.protocolVersion } else { $ProtocolVersion }
            $result = @{ protocolVersion = $pv; capabilities = @{ tools = @{}; prompts = @{} }; serverInfo = $ServerInfo }
            # Ceremony part 2: the discovery walk IS the handshake. Hand the agent its bearings via
            # `instructions` (clients inject this into the agent's context) so it never infers state from
            # a possibly-empty projection. Walk once, cache; a dead root reports its diagnostic instead.
            if ($script:Fatal) {
                $result.instructions = "error: $($script:Fatal)"
            } else {
                if ($null -eq $script:Readiness) {
                    try {
                        $scan = @(Get-IngestionScan -Root $Root)
                        $prepped = @($scan | Where-Object { $_.prepped }).Count
                        # This connection IS your session: it is already live and persistent. Drive the whole
                        # workflow by calling these tools directly. Do NOT launch pwsh, dot-source the .ps1
                        # libraries, or pipe JSON-RPC into mcp-server.ps1 yourself -- that re-cold-starts a
                        # throwaway server and is the source of shell boilerplate/syntax churn. Shell is for
                        # out-of-band work only (git, staging new inputs into ingestion/), never to reach the membrane.
                        $useTools = "This connection is your live, persistent session -- call the codex-membrane tools directly; never shell out to pwsh / mcp-server.ps1 to reach the membrane."
                        $script:Readiness = if ($scan.Count -eq 0) {
                            "codex-membrane: ingestion root '$Root' mounted but EMPTY -- 0 documents discovered (no {slug}/{slug}.json under it). Confirm this is the intended tree, pass a different -Root, or escalate to the user; do not assume there is simply no work. $useTools"
                        } else {
                            "codex-membrane: serving ingestion root '$Root' -- $($scan.Count) document(s) discovered, $prepped preprocessed. Begin with get_batch_summary (orchestrator re-ground) or list_documents; narrow a survey with the optional scope arg. RUN MODEL: a paper's work lives in runstamped runs ({paper}/.runs/{stamp}); preprocess always STARTS a new run, the other tools CONTINUE the latest (or any pinned {paper}@{run}), and every paper-addressed result echoes the run it operated on -- read it back rather than assuming. The repair workflow is in PROCEDURE.md. $useTools"
                        }
                        Write-Log "discovery: $($scan.Count) document(s), $prepped preprocessed under $Root"
                    } catch {
                        # A single malformed unit in the batch (corrupt .chunks.jsonl / .ledger.jsonl) must not
                        # crash the handshake. Mount anyway, but warn the agent that a unit is unreadable and
                        # that surveys may be affected until it is isolated -- repair or escalate.
                        $script:Readiness = "codex-membrane: serving ingestion root '$Root', but the discovery walk hit a malformed unit ($($_.Exception.Message)). A corrupt unit in the batch can disrupt surveys until isolated -- escalate to the user or identify and repair/quarantine the bad unit before relying on a batch survey."
                        Write-Log "discovery error (non-fatal): $($_.Exception.Message)"
                    }
                }
                $result.instructions = $script:Readiness
            }
            $script:Initialized = $true
            Write-Rpc $id $result
        }
        'notifications/initialized' { }
        'tools/list' { Write-Rpc $id @{ tools = $Tools } }
        'prompts/list' { Write-Rpc $id @{ prompts = $Prompts } }
        'prompts/get' {
            $pname = [string]$req.params.name
            try {
                $text = Get-PromptText $pname
                $desc = (@($Prompts | Where-Object { $_.name -eq $pname }) | Select-Object -First 1).description
                Write-Rpc $id @{ description = $desc; messages = @(@{ role = 'user'; content = @{ type = 'text'; text = $text } }) }
            } catch {
                Write-RpcError $id -32602 "prompt not found: $pname"
            }
        }
        'tools/call' {
            if ($script:Fatal) {
                # Brief, in-feed notification: the working dir never mounted. Agent corrects or escalates.
                Write-Rpc $id @{ content = @(@{ type = 'text'; text = "error: $($script:Fatal)" }); isError = $true }
            } else {
                try {
                    Write-Rpc $id (Invoke-ToolGuarded ([string]$req.params.name) $req.params.arguments)
                } catch {
                    Write-Rpc $id @{ content = @(@{ type = 'text'; text = "error: $($_.Exception.Message)" }); isError = $true }
                }
            }
        }
        'ping' { Write-Rpc $id @{} }
        default { if ($hasId) { Write-RpcError $id -32601 "method not found: $($req.method)" } }  # notifications ignored
    }
    } catch {
        if ($hasId) { Write-RpcError $id -32603 "internal error: $($_.Exception.Message)" }
        Write-Log "request error ($($req.method)): $($_.Exception.Message)"
    }
}
