# yea, spc has its merits in theory but i feel like it might be overengineering here. I'm trying to see the throughline to getting my prototype MVP for pdfdig. I believe that the persistent homology / topology concepts complement the HDBSCAN clustering, and it recently occurred to me that some kind of decision tree method might be useful for closing a gap using typographic information. the idea originally started when i asked about XGBoost but then I realized that it would amount to caching a model that is persisted across test cases and what im trying to build is very much aimed at being self-contained within a document, hence my work so far with unsupervised ML so far. but this line of inquiry did highlight a potentially valuable avenue for moving the needle, and perhaps some other kind of tree-based method might be able to fit in in a way that's self-contained to complement or extend the HDBSCAN methods `D:\aghado01\codex-scientiae\issues\truffle\tree-methods-notes.md` ... there's also the original idea i had of adapting the membrane workflow concept which amounts to a stop-gap for shoring up any loose ends the deterministic/unsupervised processing doesn't quite disambiguate. Im feeling a little bit lost in the weeds and trying to see the forest, as it were

The forest is smaller than the notes make it appear:

> pdfdig’s MVP is a confidence-bounded, document-local converter—not a system that must algorithmically resolve every ambiguous PDF structure.

Its core throughline can be only three stages:

```text
Discover document-local structure
        ↓
Make evidence-bounded role decisions
        ↓
Route honest abstentions through the membrane
```

### 1. Discovery: HDBSCAN plus persistence

You already have this.

- Geometric HDBSCAN discovers figure structure.
- Typographic HDBSCAN discovers document-local style modes.
- The condensed trees provide the H0 persistence object and stability evidence.
- Defrag elbows, C′’s spine gap and the furniture cycle-rank rule already operationalize topological thinking.

The truffle stage-0 result is decisive: typography is crisp—9–24 modes per document, 0.1–3.1% noise, membership near 1.0, and broad stable plateaus. See [the stage-0 result](D:/aghado01/codex-scientiae/issues/truffle/design-notes.md:38).

That means neither SPC nor a better tree ensemble is currently needed to discover the modes. PH complements HDBSCAN by telling you which structures persist enough to trust and which documents lack a stable regime. For the MVP, that can remain an interpretation and selection principle over the hierarchy you already emit; it does not require another PH engine.

### 2. Resolution: a document-local ordinal decision tree

The open problem is not clustering. The probe showed `modes ≠ roles`: typography modes are real, but “larger bold mode” does not intrinsically mean H1, title, theorem label or run-in heading.

The smallest defensible semantic resolver is a hand-authored, document-calibrated decision list:

- body = dominant prose-compatible mode;
- math = math-font/baseline evidence;
- caption = cue plus figure adjacency plus document-local caption style;
- figure text = spatially inside a figure region;
- furniture = positionally periodic;
- footnote = smaller relative mode near the page bottom;
- heading = rarer and larger/bolder than body, preceded by whitespace, compatible with outline evidence and legal heading sequence.

Every threshold should be relative: mode rank, deviation from the body centroid, gap in em, page-position quantile. Every leaf should return either:

- `claim(role, evidence)`, or
- `abstain(reason)`.

That is already a tree-based method. It is interpretable, transient, document-local, and directly encodes typography’s universal ordinal conventions without introducing a cached model.

### Where the learned tree ideas stand

| Method                         | What it actually contributes                            | MVP verdict                                                  |
| ------------------------------ | ------------------------------------------------------- | ------------------------------------------------------------ |
| HDBSCAN condensed tree         | Stable typographic mode discovery                       | Keep                                                         |
| Ordinal decision tree/list     | Maps modes and context to defensible roles              | Build                                                        |
| CART trained to HDBSCAN labels | Assigns noise/stragglers back to modes                  | Defer—stage-0 noise is already tiny                          |
| Document-local role CART       | Extends high-confidence role anchors to ambiguous lines | Plausible second increment                                   |
| Isolation forest               | Ranks unusual lines for review                          | Defer until the work-list demonstrates a routing gap         |
| Unsupervised RF proximity      | Learns a mixed-feature similarity metric                | Defer—the hand-built feature space is not presently limiting |
| SPC                            | Resolves frustrated collective organization             | Post-MVP unless a named residual requires it                 |

One correction I would make to the current truffle proposal: a CART trained on HDBSCAN cluster labels cannot solve the semantic role gap. It merely approximates the existing mode assignment.

If a learned tree becomes useful, train a shallow per-document CART from high-confidence role anchors:

- captions securely attached by cue and geometry;
- body lines from the dominant prose mode;
- heading lines corroborated by bookmarks/outline;
- figure text enclosed by settled figure regions;
- formula lines supported by math-font structure.

Then apply it only when its rules remain stable under page-wise resampling or bootstrap perturbation. Emit the relative rules, use them for that document, and discard the tree. That is self-supervised completion rather than persistent transfer learning.

### 3. Completion: the membrane is part of the MVP

I would stop thinking of the membrane as an embarrassing stopgap. It is the explicit completion semantics for cases the converter correctly refuses to guess.

The original pdfdig design already has the right ladder:

1. Deterministic extraction establishes the certain majority and computes its boundary.
2. Flagged residue receives gated model/agent proposals.
3. Rare terminal ambiguity goes to human review.

That contract is stated in the [workflow ladder](D:/aghado01/codex-scientiae/issues/pdfdig-lane/pdfdig-ps-converter.md:450), and the pdfdig handoff already preserves converter uncertainty as dispatchable `flags[]` rather than calling it corruption. See [membrane handoff](D:/aghado01/codex-scientiae/issues/pdfdig-lane/membrane-handoff.md:41).

A prototype that converts 95% automatically, identifies the uncertain 5% precisely, and resolves it through an audited membrane is more complete than one that silently guesses 100%.

### The MVP cut line I would use

1. Finish the existing A3/D probe fork.

   A3 closes the last reader-visible PRIMARY misses if bounded; D proceeds only with clean object alignment and equation separation. Do not let truffle pre-empt that localization work.

2. Close deliverable width.

   F1/F2—image placement and publish carry-up—matter more to an MVP than another clustering family. A converter whose figures never reach the final compendium is not end-to-end.

3. Productionize only the minimal truffle stack.
   - typographic feature emitter;
   - per-document HDBSCAN modes;
   - mode descriptors and persistence/stability;
   - ordinal role decision list;
   - heading-sequence grammar;
   - explicit abstentions/work-list output.

4. Exercise membrane completion end-to-end.

   Bare PDF → IR → automatic claims → flagged residue → gated proposal/review → final Markdown and images.

5. Run the transport corpus and freeze an MVP.

   The acceptance report should include:
   - automatic coverage;
   - precision of asserted roles;
   - wrong-auto-claim count;
   - abstain/membrane-routing rate;
   - final unresolved count;
   - end-to-end artifact completeness.

Everything else—SPC, RF proximity, isolation forest, persistent XGBoost, broad PH machinery—needs to purchase entry by solving a measured residual after that cut.

One reason you feel lost is that [the truffle design](D:/aghado01/codex-scientiae/issues/truffle/design-notes.md:6) still begins with the original supervised architecture, while its later [July 17 rescope](D:/aghado01/codex-scientiae/issues/truffle/design-notes.md:219) rejects that doctrine. The document contains both the abandoned road and the current road as if they were simultaneously live.

The current road, reduced to one sentence, is:

> HDBSCAN discovers stable document-local typographic modes; ordinal structural rules make only justified role claims; the membrane resolves the explicitly surfaced remainder.

That is a coherent prototype MVP—and it is much closer than the expanding research board makes it feel.

# this decision tree you are describing sounds like the jurisdiction of an LLM-in-the-loop of the MCP based on membrane. codex-membrane proper was about the docling repair workflow, what i'm suggesting in something architecturally similar and potentially sharing primitives, but distinct in what the models are prompted to do and what information gets doled out to them. but maybe i'm wrong and i shouldn't immediately punt this to the model-in-the-loop stopgap and push the automated model-free workflow further

You’re not wrong. I would revise my previous recommendation: semantic role assignment should not become a mandatory learned-tree tier in the MVP. Once typography and geometry leave two plausible interpretations, a decision tree starts becoming an impoverished surrogate for the bounded reasoning your pdfdig-specific model loop should perform.

But that does not mean punting early. The right boundary is:

> Push automation until it has localized the ambiguity and exhausted PDF-intrinsic evidence; then give the model a small adjudication problem, not a conversion job.

### The automated lane should own

- faithful PdfPig extraction;
- geometric and typographic HDBSCAN modes;
- persistence/stability measurements;
- body-font and math-font identification;
- recurring furniture;
- bookmarks/outline witnesses;
- caption cues and figure adjacency;
- relative typography;
- candidate generation;
- structural vetoes;
- explicit uncertainty and competing hypotheses.

Typography remains valuable, but primarily for candidate generation and veto:

- “This cannot be an H1 because it is body-sized and sequence-illegal.”
- “These are the two plausible caption blocks.”
- “This line is an outlier relative to the body mode.”
- “The evidence cannot distinguish run-in heading from bold paragraph lead.”

That last case should not be forced through increasingly intricate rules.

### The model loop should own

- choosing between structurally plausible interpretations;
- run-in heading versus bold lead-in;
- semantic caption recognition when cues are absent;
- deciding whether a typography anomaly is intentional emphasis;
- bounded reconstruction where linguistic meaning is necessary;
- returning `none/abstain` when the evidence remains insufficient.

The distinction is not “easy versus hard.” It is identifiability:

| Question                                                              | Proper home                  |
| --------------------------------------------------------------------- | ---------------------------- |
| Can it be derived from PDF facts and universal structural invariants? | Automated lane               |
| Can additional document-local statistics settle it?                   | Automated probe              |
| Does it require understanding what the text means?                    | Model loop                   |
| Is the underlying glyph/content absent or corrupt?                    | Escalate; do not hallucinate |

### A sibling to codex-membrane, not codex-membrane itself

Your distinction is correct. The existing membrane repairs Docling-produced chunks. A pdfdig resolver would share the control-plane architecture while having a different data plane and mandate.

Shared primitives:

- work-item discovery;
- bounded slices;
- typed proposals;
- gates;
- apply;
- audit;
- leases/retries;
- terminal review.

Different task:

- Docling membrane: “Repair corruption in this already-produced representation.”
- pdfdig resolver: “Adjudicate between these structural interpretations of faithful PDF observations.”

The pdfdig model should receive an evidence packet such as:

- target line/block/region IDs;
- bounded neighbouring text;
- page crop if visual evidence matters;
- typographic mode and rank relative to body;
- geometric relationships;
- outline/bookmark evidence;
- HDBSCAN lineage/stability;
- competing candidate roles or attachments;
- why the automated resolver abstained;
- permitted actions.

Then ask a narrow question:

> Choose `heading`, `bold_lead`, or `none`, and cite which supplied evidence supports the choice.

Not:

> Inspect this paper and fix its structure.

That compartmentalization preserves pdfdig’s deterministic center.

### What to do with the tree idea

I would convert truffle Stage 1 from “build a role classifier” into a **role-boundary probe**:

1. Emit typographic modes and relative features.
2. Apply only high-confidence document-local anchors.
3. Use the oracle offline to measure precision, coverage and abstention by role.
4. Produce a census of unresolved cases.
5. Classify each residual as:
   - missing feature;
   - insufficient document-local sample;
   - structural ambiguity;
   - genuinely semantic ambiguity.

Only then decide whether another automated method is justified.

A transient tree remains useful in two limited ways:

- Offline microscope: fit reference trees to see which features may contain unused signal; distill only independently defensible PDF-intrinsic rules.
- Per-document completer: propagate exceptionally strong role anchors through a shallow, auditable tree—but only if page-wise resampling shows stable rules.

I would not train CART merely on HDBSCAN mode labels. That only reconstructs the mode partition and does not solve `mode → semantic role`.

Likewise, the heading grammar should initially be a veto, not a promoter. “H1→H3 is illegal” can reject a proposal safely; it cannot prove that a bold line is a heading. This repeats the strongest lesson of the figure lane: structural priors veto far more reliably than they assert.

### Why automation still deserves another push

The automated work before the model is not wasted even when it abstains:

- It minimizes model calls.
- It makes prompts local and legible.
- It gives the proposal gate objective invariants.
- It prevents the model from rewriting faithful content.
- Its audit records reveal recurring ambiguity classes that can later be distilled into deterministic fixes.
- It supplies an oracle-free confidence vocabulary for bare PDFs.

So the membrane-style layer is not an alternative to further automation. It creates the feedback boundary that makes further automation disciplined.

### My revised MVP throughline

```text
PDF-intrinsic extraction
    ↓
geometric + typographic mode discovery
    ↓
high-precision anchors and structural vetoes
    ↓
resolved claims ───────────────→ final assembly
    ↓ abstain
localized pdfdig work item
    ↓
bounded model proposal
    ↓
deterministic gate + audit
    ↓
apply or terminal review
```

The key MVP experiment is therefore not “tree versus LLM.” It is measuring the boundary:

- What fraction resolves automatically?
- At what precision?
- What fraction routes to the model?
- How large is each evidence packet?
- How often does the gate reject a proposal?
- Which residue classes recur enough to automate next?

That gives you a natural stopping rule. Keep pushing the model-free lane while a measurable PDF-intrinsic signal remains unspent. Stop when the residual is semantic or the next rule would trade transparent abstention for silent false confidence.

So I would neither punt the whole role problem to the model nor insist that a tree finish it. Let HDBSCAN, topology, typography and deterministic constraints reduce the problem to a small set of well-formed questions. The pdfdig-specific membrane sibling answers those questions under gates. That is a coherent MVP architecture rather than a stopgap.
