# latex-ingest — decisions

Locked decisions; amend by superseding entry, never by rewriting history. Evidence tier:
[discussions/](../discussions/) — especially the probe field notes
([probe-prose-channel-20260802.md](../discussions/probe-prose-channel-20260802.md)). Completed
work: [ledger.md](ledger.md). Ahead: [roadmap.md](roadmap.md).

- **D1 — Latent manuscript / presentation-last** (2026-08-02). The working representation is
  ordered pieces (a pre-markdown JSONL IR shaped like the latent manuscript); the markdown file
  is a serializer formality. Every downstream lane reads the representation, never re-mines the
  rendering. Canon capture: [latent-manuscript-doctrine-20260802.md](../discussions/latent-manuscript-doctrine-20260802.md).
- **D2 — Canonical protograph** (2026-08-02). The user designs the superset of manuscript node
  kinds and relation types; every run surjects source onto it, kernel classified never lost.
  Kinds are admitted from residue witnesses (mint = user), never speculated.
- **D3 — Knowability binary + both-directions checks** (2026-07-31→). Every fact is detected at
  the earliest knowable stage. Placeholder/store checks run in BOTH directions — text-driven
  (leaked) and store-driven (orphaned) — and both are hard corpus-wide invariants at 0.
- **D4 — Pre-inversion admission rule**. A stage may be built against the current string
  pipeline iff it reads SOURCE-side facts; anything that would mine emitted text waits for
  forward assembly.
- **D5 — Kernel two-sort** (2026-08-02). Typesetting marks that speak about the PAGE die in the
  surjection; marks that speak about ORDER/adjacency/containment survive as placement evidence
  (float specs, `\FloatBarrier` rows, placeins facts) consumed by the traversal's named
  placement policies.
- **D6 — Numbering = (mode, ordinal, regime); display = projection** (2026-08-02). `\appendix`
  is a recount + re-alphabet. Deliverable default = NORMALIZED (arabic 1-counting continuation,
  injectivity-guarded per document); `-FaithfulNumbering` renders the paper's own symbols.
  References render through the same projection as heads. Both projections always live in the
  model.
- **D7 — Layer semantics: STREAM + REFGRAPH → DOC GRAPH** (2026-08-03, user coinage
  "docstream"). docstream = the node set (seq / addr / parent; structural edges implicit in the
  addressing). latex refgraph = source-side reference machinery kept LaTeX-flavored (labels,
  sites, per-target resolution, danglers classified bib-missing / declared-unmapped /
  undeclared) — the layer where dangler cleanup happens. doc graph = the DERIVED composition
  (stream nodes + bib nodes, referential edges resolved onto addresses) — assembled, never
  independently scanned; tex-docgraph's name retires into this meaning.
- **D8 — Admitted kinds** (running). Spine: title, section, subsection, subsubsection, the
  `\newtheorem`-model kinds, proof (with extent), appendix (boundary node; letter renumbering is
  a projection, per D6). Channels: prose at paragraph grain, math (inline riding in prose +
  display interleaved), verb (two-grain: fences interleave, inline spans ride), alg (algorithmic
  + algorithm2e dialects), figure bundle, table bundle (caption + label + grid as one unit),
  diagram. Evidence rows: barrier, appendix signal, float specs, placeins facts.
- **D9 — Golden pin regeneration is deliberate only** — never to silence a failure not yet
  understood ([tests/latex-ingest.refs.Tests.ps1](../../../tests/latex-ingest.refs.Tests.ps1)).
- **D10 — Faithful-not-filtered stands**. Dangler cleanup fixes CONVERTER classes; author
  errors render honestly; editorial preferences (normalization) are flags with the faithful
  invariant retained.
- **D11 — Per-conversion artifacts** (work dir, UTF-8 no BOM): `{slug}.refs.jsonl`,
  `{slug}.docstream.jsonl`, `{slug}.refgraph.json`, `{slug}.docgraph.json`,
  `{slug}.diagrams.jsonl`; oracle counts in the run dir.
- **D12 — One IR, two producers (HARD constraint, 2026-08-04).** pdfdig and latex-ingest build
  the SAME target pre-markdown JSONL IR — the docstream realization of the protograph — aligned
  as far as the substrates allow. The gauntlet dev harness compares at the IR: discrete
  canonical chunks of latent manuscript derived from each source (spine vs spine, chunk vs
  chunk, edge sets), never markdown diffs. Lane differences live INSIDE the shared schema —
  epistemic status (observed vs proposed vs hole), total vs partial spine order, lane-shaped
  provenance (char offsets vs execution paths) — never as schema forks. Markdown remains a
  downstream projection both lanes share. Convergence evidence:
  [sol-pdfpig-ideation-20260804.md](../../pdfdig/discussions/sol-pdfpig-ideation-20260804.md).

D13–D17 were first recorded in the infrastructure canon as D30–D34 and relocated here on
2026-08-04 under infrastructure D35 (application boundaries preserved): they are latex-ingest
application semantics, not shared contracts. Implementation witness: commit `05419f3`.

- **D13 — `metadata.json` is the local document manifest; raw package metadata stays raw**
  (2026-08-04, relocated from infrastructure D30). Each document deposit uses
  `{slug}/metadata.json` as its single bounded local metadata object and as the source for rows
  materialized into localized parent `inventory.jsonl` stores. A provider archive's
  `00README.json`, when present, remains byte-for-byte under the stable `{slug}-tex/` extraction;
  automation may record it as a preserved package member but does not base the manifest on it,
  rename it, or mistake it for the complete document manifest. The archive and extraction are
  stable source material, while subsequent conversion output belongs to runstamped artifacts.
- **D14 — Document manifests are evidence-composed, not single-file extracts** (2026-08-04,
  relocated from infrastructure D31). `metadata.json` merges explicitly attributed facts from
  provider/acquisition records, deposited-file inspection, optional document-embedded
  declarations, and curated corrections. Automation discovers the actual entrypoint and resolves
  inputs; it does not assume `main.tex`, and source declarations supplement rather than silently
  override provider identity. Local presence, paths, formats, sizes, and checksums are measured
  from deposited files. Conflicts remain visible and refreshes preserve curated data.
- **D15 — `source-ready` is a standalone transactional sentinel** (2026-08-04, relocated from
  infrastructure D32). Source-deposit initialization is prerequisite housekeeping and does not
  start or become an implicit phase of a latex-ingest conversion run. It expands a selected
  archive into a private sibling, rejects unsafe archive members and invalid or ambiguous LaTeX
  source, normalizes the archive name, and publishes the stable `{slug}-tex/` tree before
  atomically creating `metadata.json` last. The sentinel means source validation and publication
  completed; it does not mean bibliography is complete or conversion succeeded.
  A missing sentinel after source-tree publication is recoverable only by independently
  re-extracting the archive and comparing tree fingerprints. A mismatch is a conflict, never an
  overwrite. Existing sentinels are validated and returned without rewrite. Provider metadata is
  optional, and short-lived locking/private paths must be cleaned rather than becoming persistent
  per-document sidecars. The current implementation and schema remain provisional until corpus
  vetting and converter migration are complete.
- **D16 — Source-deposit paths are scoped addresses, not machine identity** (2026-08-04,
  relocated from infrastructure D33). The initializer has no compiled-in drive, checkout, profile,
  temp, or artifacts root. The caller supplies or relatively addresses the document directory;
  subordinate archive/provider paths resolve against that stable scope, and LaTeX entrypoints
  resolve against the source tree. Imports resolve from the importing script. Persisted paths use
  forward slashes relative to the document directory. Absolute paths are ephemeral resolved
  addresses used for confinement and I/O and never enter `metadata.json`.
  Filesystem equality and containment follow the host's case semantics, while archive/tree
  inventory rejects case-colliding portable names deliberately. Deterministic tree fingerprints
  sort normalized relative paths ordinally so checkout location, current directory, locale, and
  enumeration order cannot change the digest.
- **D17 — Production latex-ingest is manifest-only; legacy inference is an import boundary**
  (2026-08-04, relocated from infrastructure D34). `Invoke-ArxivLatexToMarkdown` consumes a
  validated `metadata.json`/document directory and does not unpack, initialize, infer
  archive/slug layout, recognize `{slug}-latex/`, or accept source-work overrides. Conversion
  operates over a resolved-source engine and writes all generated ref/doc/diagram/oracle evidence
  to the run directory so the source fingerprint remains stable.
  The old archive/slug entrypoint, retired helper names, reuse semantics, and arbitrary
  source-work paths live only in `latex-ingest-compat.ps1`. Its conventional path standardizes
  through `Initialize-LatexSourceDeposit`; an explicit bypass is warned and labeled `compat-*`,
  never represented as a compliant deposit. New callers must not import the compatibility surface.
