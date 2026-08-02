# The latent manuscript — presentation-last doctrine

Captured 2026-08-02 from session discussion (Fable scribing the user's articulation). Joins
[operations-oriented-extraction](operations-oriented-extraction.md) and
[claude-working-backwards](claude-working-backwards.md) as the reshape's third concept doc —
the two of them diagnose *where* and *when*; this names the disease they orbit. Discussion-tier
capture; graduates to latex-ingest planning canon when that tier is minted.

## The failure mode, named

latex-ingest starts from a tarball and works toward assembling a markdown file. Its original
failure was **rushing to the markdown file and then trying to clean it up** — not being
comprehensive about everything in between. That is premature serialization: the manuscript's
structure was collapsed into a presentation format before it was ever captured as structure,
and from that point on every downstream lane must **re-mine the manuscript from its own
rendering** — toc-engine re-scans headings the converter emitted, the subject index `IndexOf`s
strings it wrote itself, the sentinel counts damage a restore loop already measured and
discarded, md-repair does archaeology on a building we just built.

The failure is hard to see because every post-hoc pass is locally reasonable. The defect is
architectural: **the working representation is wrong**, so every fix lands on the wrong side
of the serialization boundary. The knowability binary (working-backwards) diagnoses each
symptom — detected later than knowable — but the disease is singular: the pipeline discards
the latent manuscript as it goes, then spends its second half trying to recover it.

## The inversion

**The meat of the pipeline is capturing and assembling the ordered pieces.** The document
travels as pieces — with identity, order, and provenance — not as one string being mutated
toward markdown. The target working representation is a **pre-markdown JSONL representation
of the document that has the shape of the latent manuscript**: ordered pieces (prose blocks,
math spans, theorem environments, figures and captions, labels and their referents) captured
at the moment each is knowable, during LaTeX parsing — pulled back from wherever they
currently happen late.

**The markdown file is a formality at the end of the process and not much else** — a
serializer over the assembled representation. Consequences:

- TOC, subject index, and label maps *fall out of* the representation — they are properties
  of pieces captured at parse time, never re-derived from emitted text.
- The five placeholder families die: protection-by-`@@string@@` exists only because regions
  must survive string mutation; when the document is pieces, the piece boundary *is* the
  protection.
- Store-driven restores die with them: assembly of ordered pieces is total by construction,
  and "no placeholder remains" becomes an assertion inside the serializer — a backstop
  against "impossible," which is all the md-bundle sentinel ever should have been.
- Cleanup lanes shrink toward zero: there is nothing to clean up in a rendering that was
  emitted from a correct model.

## Doccer's exact fit

Doccer's tools analyze **fragments or contiguous bodies of text that need not be markdown** —
which is precisely what the in-between of this pipeline is made of.

- **Fragments are first-class** (D12: masters scale down — a `TextMaster` is a coordinate
  space, not "the document"). Resolving a given macro in isolation = mint a master over the
  macro body, analyze there, with fragment-local claims that refuse parent validation until
  explicitly rebased.
- **Assembly is the D19 weave**: slice/rebase plus `ToParentInto` — several fragment-bound
  builders woven into one parent-bound batch. The already-queued macro-expansion witness demo
  is this whole vision in miniature: capture, transform in isolation, weave back.
- **The piece stream is claims-shaped.** The D13 JSONL wire format is the seed of the piece
  representation; F2 (persisted batches) is its maturation. Addendum 3's conclusion —
  strings-as-currency forces re-derivation, claims-as-currency preserves knowability — taken
  to its full consequence: **the currency is the document.**
- Analysis capabilities (collect, span algebra, pair) run per-fragment or per-assembly at any
  stage of the pipeline — never against markdown, because markdown does not exist until the
  end.

The vocabulary closes its own loop: doccer's CLI names **latent call paths** through the
engine; the reshaped pipeline captures the **latent manuscript** inside the source. Both
programs are the same move — make latent structure explicit as first-class, addressable
pieces, and let everything downstream become a query or a serialization.

## The graph refinement (same day)

**The latent manuscript is a graph, not a sequence.** It carries internal references — labels
and their referents, citations, figure–caption bonds, theorem–proof bonds — so it is not
fundamentally a serial procession of objects; its original rendering is merely *one
linearization* of it. Three structural claims:

1. **Transfer = surjection onto the canonical spine.** The latex-to-markdown process
   surjectively maps variable document-source serial bytes onto canonical manuscript nodes:
   total on source, many-to-one onto the spine, with the map's kernel — typesetting and
   painting — **classified, never lost** (faithful-not-filtered, formalized). The
   surjectivity audit is a coverage query: every source byte lands in a node's provenance or
   in an explicitly classified typesetting span. "Not comprehensive about everything in
   between" becomes impossible to repeat silently.
2. **Presentation = traversal.** After the graph is constructed during the pipeline, the
   markdown is a walk of it in reading order. Placement decisions — figures, captions,
   relative to first reference — are **named policies of the walk**, not properties of the
   document (the caption-relocation lane is the existing post-hoc instance; under the
   inversion it becomes a traversal policy). The walk separates typesetting/painting from the
   semantic narrative and hierarchical structure inherent to the reading.
3. **Levels — do not conflate (user correction, same day).** The **manuscript graph** is the
   *canonical schema*: the primitive manuscript-node kinds and relationship types that
   documents are surjected **onto**. A **document** is a *realization* of those primitives
   and their relationships. The **docgraph** (`tex-docgraph.ps1`) is neither: it is the
   source-encoded relational overlay — pointer sites and their targets (prose→theorem,
   citation→bib entry) as this particular source encodes them, captured upstream because
   that is where the binding is knowable. It is a *conceptual parallel* to the manuscript
   graph (a graph-shaped capture under the same discipline: cues-as-data, loud-fail, JSONL)
   and *part and parcel of the process* — evidence the surjection consumes when realizing
   canonical relationships — but *not the manuscript graph itself*. The surjection is
   therefore **two-sorted**: source bytes → canonical node instances; source-encoded pointer
   machinery → canonical relationship instances — kernel classified in both sorts
   (docgraph's own header: "cross-reference machinery is typesetting furniture"; the binding
   is what survives). `bibliotecha/corpora/KisungYou/2605.20681v1.chunks.jsonl`
   reverse-engineers one realization's spine from an (imperfect) markdown output — 58 nodes,
   `seq`/`addr`/`parent` triple addressing, provenance spans, anchors; math/prose/figure
   content nodes deliberately not yet teased out.

Doccer resonances, precise: the founding kernel already implements **reference join** beside
the thirteen Allen relations — edges are join-shaped over claims; the spine constructor is
the total-partition specimen in the census drawer (mdnav's totality geometry); nodes are
coarse-grain claims whose `seq`/`addr`/`parent` are basis-stamped views of one claim set;
forward provenance spans point into *source* (byte grain → F3-relevant), not markdown.

## The channel refinement (same day)

The toy specimen is a prototype of the **prose spine** — sections/subsections with bodies,
references at the end — with the math channel still *embedded* in the prose bodies. The
refinement: extract math blocks as **first-class nodes interleaved with prose blocks**, with
hierarchical structure and reading order preserved in the addressing — a math block
interleaved under a section carries the *same* section/subsection addressing as its prose
neighbors (structural identity retained on every row), while `seq` preserves the interleaved
reading order and `kind`/`kind_index` make the math nodes first-class.

The property this locks in: **every view is a query over one flat stream.** Section tree =
group-by parent; reading order = sort by seq; math bank = filter by kind; prose-only skeleton
= its complement; channels (prose, math, later figure/caption) = interleaved projections of
one representation. No view is a separate artifact. This is D12 (tree-as-query) and D21
(basis-stamped views) at manuscript grain. Corollaries: `Store-Math`/`@@LMATH@@` was always
node capture forced to encode itself as string placeholders; the oracle lane's "one tap, two
consumers — math bank + structure skeleton" was the channel decomposition avant la lettre,
reunified here as filters over the stream; serialization degenerates to *walk seq, render
each kind* — the markdown formality is a foreach.
