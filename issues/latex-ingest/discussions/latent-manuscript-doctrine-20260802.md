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
