I'll dig into the doccer implementation, the issues discussions, and the doc-dive/mdnav tooling myself (no subagents, per your standing preference). Starting with the lay of the land.

Reading the remaining issue docs and the engine source now.

Now the engine source itself.

Now the doc-dive / mdnav side.

Now let me look at mdnav's implementation to ground the meta-reflection — checking size first, then reading strategically.

The contract harness passes — 954 checks. Now a quick mdnav pass over the doccer issues corpus.

Everything's read, verified, and the memory is updated. Here's the full picture.

## TL;DR

The doccer kernel is genuinely good — it implements the claims-first thesis from the issues discussions faithfully, the 954-check contract harness passes, and the README's honesty about what's deliberately absent holds up against the code. I found **one real defect**: [TextMaster.cs:27](src/doccer/Core/TextMaster.cs:27) computes the fingerprint via `Encoding.Unicode`, whose replacement fallback maps _every_ lone surrogate to U+FFFD (verified: both `0xD800` and `0xDC00` encode to `FD FF`). So two masters differing only in which unpaired surrogate they contain — a distinction `TextTopology` explicitly preserves as first-class atoms — get identical fingerprints and pass `IsCompatibleWith`. The identity layer is blind exactly where the topology is sighted. Fix is a one-liner: hash the raw code units (`MemoryMarshal.AsBytes(text.AsSpan())`) instead of round-tripping through an encoder — faster, too.

The meta-reflection turned out to be the richest part: **mdnav is a second, independent partial rediscovery of doccer** (after masks.ps1), which is strong evidence the abstraction is right — and the learning flows in _both_ directions.

## Implementation review

Beyond the fingerprint issue, the code survives scrutiny:

- **Allen relations** ([AllenRelation.cs](src/doccer/Algebra/AllenRelation.cs)) — correct and total over non-empty half-open intervals; `Inverse` is a proper involution.
- **SpanSet** ([SpanSet.cs](src/doccer/Algebra/SpanSet.cs)) — the merge-sorted `Intersect`/`Subtract` walks are correct (I traced the equal-end and gap-cancellation cases). Normalization merges _adjacent_ spans, which is Boolean-correct: as a set of covered offsets, touching spans are the same set. The distinct-runs representation is properly deferred to the coalesced-run family the README lists as absent.
- **TextTopology** ([TextTopology.cs](src/doccer/Core/TextTopology.cs)) — the cursor-based tiling invariant is genuinely stronger than sum-of-lengths (an overlap and a gap can cancel; the cursor can't lie). CRLF/NEL/LS/PS line semantics agree between `Build` and `TextMaster.GetLineSpan`. One contract decision worth writing down: `Project` of an _empty_ span returns the one-line range containing its position — defensible, but it's a convention, and the level-projection spec work in [sol-doccer-next-steps.md](issues/doccer/sol-doccer-next-steps.md) should name it rather than inherit it silently.
- **RegexCollector** ([RegexCollector.cs:110](src/doccer/Collector/RegexCollector.cs:110)) — per-region matching genuinely cannot bridge exclusions; this is the direct fix for the `Get-MaskedText` blanking hole the next-steps doc proved. One sharp edge: an empty match **throws** mid-collection ([RegexCollector.cs:132](src/doccer/Collector/RegexCollector.cs:132)), so one rule like `foo|` poisons the whole batch. Loud-by-design is right, but consider validating rules up front (test each regex against `""`) so the failure names the rule at load time rather than mid-sweep.
- **Laminarizer** ([LaminarView.cs](src/doccer/Algebra/LaminarView.cs)) — deterministic, equal geometries ride as groups, residue preserved. Note the greedy max-priority acceptance doesn't maximize total accepted priority — that's fine as the documented default, and it strengthens the case (from the grok discussion) for making the resolution policy an explicit named parameter later rather than an implicit property of the algorithm.
- Reference `Join` and validation are O(n·m)/O(n²) as advertised — semantics-first, correctly labeled.

The three issues docs form a coherent arc — vision statement → gap taxonomy (specified-but-unimplemented vs contracts-not-yet-safe) → open-question analysis — and the code's omissions match the docs' deferrals exactly. That discipline is rare and worth protecting.

## The mdnav dive

I ran mdnav over `issues/doccer/` itself (artifacts to scratchpad, repo untouched). It performed exactly as designed: flagged `heading h1` as the delimiter of the discussion doc (cv=0.41 — your turns), showed D003's structure starting at H2 (grain `1/7/17` — the "H1 is a title" signature), and surfaced D001's `breaks=7≠h1-1` disagreement. Composition flags told the story before reading: `[prose94]` on the pasted-response unit vs `[prose35 list24 code17]` on the design turn.

## Meta-reflection: doccer ⇄ mdnav

**mdnav is convergent partial doccer.** masks.ps1 compressed doccer's ontology into Boolean coverage; mdnav independently re-derived a _different_ subset — immutable masters, half-open spans in one address space, digest-guarded anchors, a coverage ledger stamped with the grain that produced it, refusal to mutate sources, residual honesty (`PREAMBLE`, `BODY`, `UNBROKEN`). Two independent tools re-inventing overlapping fragments of the same substrate is the strongest empirical argument yet that the doccer abstraction is the right one.

**Where mdnav commits the representation collapse doccer exists to fix.** `constructRuns` resolves conflicts at scan time — one kind per run, first `LINE_KIND` match wins, fence state is global. Concretely: a fenced block inside a blockquote (`> ` prefix defeats the fence regex) is silently just "blockquote"; setext headings are flagged as suspects but can never _disagree_ with ATX claims because there's no representation for disagreement; multi-line HTML is "reported rather than pretended away" because line-scoped regex can't hold it. Each of these is a doccer claim-pair (quote `Contains` fence; ATX-collector vs setext-collector disputing the same line) that mdnav's single-tiling model cannot express. And several mdnav internals are hand-rolled doccer operations: the noise-span dedupe at [mdnav.mjs:243](../../utils/skills-dev/doc-dive/mdnav/mdnav.mjs) (sort by start, prefer outer span) _is_ the Laminarizer's ordering; `compositionOf` reassigning noise bytes out of containing constructs _is_ labeled `SpanSet.Subtract`; fence-aware heading recognition _is_ scoped collection; `mergeSpans`/`coveredWithin` _is_ a mini SpanSet. The H1-vs-breaks `aligned` verdict is a scalar shadow of an Allen join — doccer would tell you _which_ units cross which segments, not just that counts differ.

**What mdnav teaches doccer** — this direction matters just as much:

1. **Density done right, by example.** The next-steps doc says "density" conflates ≥3 measures and must be decomposed before any `Density` verb ships. mdnav's cadence is the existence proof: it names its measure exactly (gaps between construct starts; median, cv, span fraction), names its exclusion (paragraphs, with a reason), and reports a threshold as stderr _advice_, never a classification. That's the template for each named density variant.
2. **The level-projection rule already has a solved form.** mdnav's answer to cross-grain comparison — unit counts are not comparable across a depth change, so all arithmetic happens in the invariant byte coordinate, and every measurement is stamped with its basis — is precisely the contract the "lift" untangling needs: _cross-grain measures must be stated in master coordinates, and every derived measure carries the basis that produced it._
3. **The sidecar is field-tested persisted-batch prior art.** `D001.index.json` is a persisted claim batch in embryo: schema version, content hash as authority with an mtime fast path, stale-anchor warnings, windows preserved across refresh keyed on hash. The deferred persisted-format contract should crib this identity/staleness design rather than invent one.
4. **mdnav's design rule and the admission test** ("presume about the reading process, never the content"; the five-question test in [skill-draft-notes.md](../../utils/skills-dev/doc-dive/skill-draft-notes.md)) are the operational twins of "the engine decides nothing about meaning; syntax lives in adapters." The doccer README's non-goals fence could adopt the admission-test form — a generative criterion instead of an enumeration.

**The concrete convergence move.** Don't port mdnav to doccer now — it's 1,165 zero-dependency lines, tested, and doing its job. Instead, treat mdnav as the **behavioral oracle for doccer's eventual Markdown adapter**: a Tier-2 two-population harness (exactly your figure-count-oracle pattern) where the doccer markdown inventory must reproduce mdnav's index — fence-scoped headings, breaks, blockquote runs, noise species — on the doc-dive fixture corpus, with divergences localized rather than scored. mdnav's acceptance fixtures (CRLF, multibyte, fenced heading-like text, setext, headingless) transfer directly. Where doccer then _exceeds_ the oracle is exactly the collapsed-claim list above: quote-nested fences, setext/ATX disagreement, multi-line HTML, and the H1×breaks Allen join.
