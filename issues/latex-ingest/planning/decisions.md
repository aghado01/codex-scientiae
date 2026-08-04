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
