# Models-removed trace — the deterministic floor and the hole census

**Status:** delivered 2026-07-23 · executes [models-removed-trace-brief.md](./models-removed-trace-brief.md) · frame from [sol-reboot-distillate.md](./sol-reboot-distillate.md) §7
**Verified against local checkouts:** ODL `5717af9` (2026-06-29), MinerU `79d6d8d` (2026-07-10) — identical to the commits pinned in the source maps; all path:line receipts below re-verified against these working copies. All four of the brief's entry-point line numbers re-located exactly (`pipeline_magic_model.py:70`, `para_split.py:417`, `model_json_to_middle_json.py:216`, `pp_doclayoutv2.py:719`).
**Path shorthand:** `odl:` = `packages/opendataloader-pdf/java/opendataloader-pdf-core/src/main/java/org/opendataloader/pdf/` · `m:` = `packages/MinerU/mineru/`
**Marks:** **[code path:line]** observed in current source · **[doc]** from the commit-pinned maps (sol-opendataloader-vs-minerU.md / sol-minerU-breakdown.md), not re-read in source · **[inferred]** judgment.

---

## 0. Verifications owed (distillate §2)

### C7 — VERIFIED, and sharper than stated

- `DEFAULT_BETA = 2.0` [code odl:processors/readingorder/XYCutPlusPlusSorter.java:50], with the code's own comment "(effectively disabled)" [code :47-49]. The cross-layout threshold is `beta * maxWidth` [code :166] and the candidate test is `width >= threshold` [code :177], where `maxWidth` is the maximum over the same population [code :154-162]. No element can be twice as wide as the widest element, so at the default the cross-layout branch is **mathematically unreachable** on any non-degenerate page — not merely "effectively" disabled. `OVERLAP_THRESHOLD` [:56] and `MIN_OVERLAP_COUNT` [:59] are consequently dead code at default.
- The density preference: `preferHorizontalFirst = densityRatio > densityThreshold` is computed [code :121-122] and threaded through every recursion [code :331, :364, :371, :391-394] but **never read**. Cut selection is purely "both gaps ≥ `MIN_GAP_THRESHOLD`, larger gap wins" [code :342-356]; a gap tie goes vertical [code :348]. The javadoc claim "used as tiebreaker" [code :328] is false. `DEFAULT_DENSITY_THRESHOLD` [:53] is therefore dead too.
- What actually runs: recursive largest-gap projection cuts (≥ 5 pt) plus one live refinement — when the vertical gap is small, elements narrower than 10% of region width (page numbers, footnote markers) are dropped and the cut retried [code :65-68, :418-441]. The C7 verdict stands: ODL's ordering quality lives upstream in normalization/consolidation, not in XY-Cut++'s advertised enhancements.

### C5 — VERIFIED

`PPDocLayoutV2ReadingOrder` [code m:model/layout/pp_doclayoutv2.py:719] is a learned transformer-encoder head. Detection boxes are per-class thresholded [code :63-90, :852-853], class ids remapped through `DEFAULT_CLASS_ORDER` [code :92-119, :864], and `(boxes, labels, mask)` fed to the head [code :866-870]; geometry enters via a **learned** position-relation bias embedding [code :334-388; config :241-243]. Output is an S×S pairwise logit matrix decoded by deterministic voting: sigmoid → votes[j] = Σ<sub>i&lt;j</sub> P(i→j) + Σ<sub>i&gt;j</sub> (1−P(j→i)) → argsort → rank [code :935-947]. Exactly the distillate's "boxes+classes → pairwise logits → votes → rank". Every downstream MinerU pass consumes this rank as `index` [code :1384].

---

## 1. Deterministic floor inventory

Both systems minus trained models: ODL loses only its optional hybrid backends; MinerU loses layout roles, reading order, formula/OCR/table content — and keeps its assembly half. Union, in pipeline order. ODL's own stage sequence receipt: `processDocument` [code odl:processors/DocumentProcessor.java:246] → filter :304 → hidden text :321 → cluster tables :334 → decoration/borders/special/lines :346-351 → headers/footers + lists-1 :358-359 → paragraphs/lists-2/headings :370-373 → captions :391 → neighbor lists/tables + heading levels + nesting :398-401 → reading order `sortContents` :854-866 → sanitize :188-190.

| # | Stage | Decision made | Evidence consumed | Mechanism | Sys | Borrow verdict |
|---|---|---|---|---|---|---|
| F1 | Object decode | chars/images/line-art with geometry, font, style, Unicode | content streams, fonts, ToUnicode, MCIDs | veraPDF chunk parser [doc] | ODL | **skip** — PdfPig lane owns this; adopt only the normalize-before-ordering discipline |
| F2 | Evidence cleanup | drop duplicate/decorative/tiny/off-page; merge same-style chunks; U+FFFD rate per page | chunk geometry + style overlap | `ContentFilterProcessor` [doc; odl:processors/ContentFilterProcessor.java:53-86] | ODL | **adopt** — cleanup precedes all semantics; FFFD rate doubles as health signal |
| F3 | Document routing | native-text vs OCR route | sampled chars, Unicode-map errors, CID/font pathologies, image coverage | ~30 named thresholds, pure function [code m:utils/pdf_classify.py:17-49; classify :94] | MinerU | **adapt** — richest existing text-health signal catalog; route → abstain/flag, never silent switch |
| F4 | Rule geometry | line-art → h/v rules → table-border candidates | path art | `LinesPreprocessingConsumer` (veraPDF dep) [doc], invoked [code odl:processors/DocumentProcessor.java:634] | ODL | **adapt** — the rules channel as typed evidence |
| F5 | Text-line assembly | chunks/spans → lines; space reinsertion | baseline + height compatibility, x-gaps | `ONE_LINE_PROBABILITY` gate [code odl:processors/TextLineProcessor.java:38]; y-overlap 0.6 merge + l→r sort [code m:utils/span_block_fix.py:52, :130] | both | **adopt** — independently twice-invented, near-identical; markpig has it |
| F6 | Span binding | which native chars fill which region | char bbox ∩ region bbox via grid index | `txt_spans_extract` [code m:utils/span_pre_proc.py:43], `SpanBlockMatcher` [code :234-306], `fill_char_in_spans` [code :311] | MinerU | **adopt, generalized** — evidence-attachment between any two geometric layers, not model-specific [inferred] |
| F7 | Script roles | sub/superscript runs within a span | char height/center vs body axis | `_classify_char_script_roles` [code m:utils/span_pre_proc.py:536; ratios :376-377] | MinerU | **skip** — markpig's assembler is richer; note the convergent design |
| F8 | Paragraph merge | lines → paragraphs | leading, alignment, font compatibility, indentation | ordered merge-hypothesis cascade [doc; gate odl:processors/ParagraphProcessor.java:34] | ODL | **adapt** — cascade = ranked hypotheses; keep second-bests instead of first-accept [inferred] |
| F9 | Document para pass | split/merge blocks incl. cross-page continuation | line indents, end punctuation, list flags | `para_split` [code m:backend/pipeline/para_split.py:417; internals :16-263]; cross-page merge [code m:backend/utils/para_block_utils.py:319-347] | MinerU | **adapt** — closest existing code to S8 flow assembly (distillate §5) |
| F10 | Lists | labels, items, continuation, cross-page joins | recurring label lexemes + intervals, alignment | two-pass `ListProcessor` [doc; gates odl:processors/ListProcessor.java:49-58]; list/index test [code m:backend/pipeline/para_split.py:59] | both | **adapt** — label recurrence-across-pages is already a whole-document instrument |
| F11 | Headings + levels | heading-hood; document heading hierarchy | neighbor contrast + document font statistics | gate [code odl:processors/HeadingProcessor.java:44]; `detectHeadingsLevels`+`LevelProcessor` [code odl:processors/DocumentProcessor.java:400-401]; deterministic title post-pass [code m:utils/title_level_postprocess.py] | both | **adapt** — the doc-statistics half is proto-global-discovery; emit as factors, not verdicts |
| F12 | Furniture | headers/footers/page numbers removed but retained | cross-page geometric/text recurrence in top/bottom bands | ranked-candidate comparison [doc; odl:processors/HeaderFooterProcessor.java:156]; label-based discard ledger [code m:backend/pipeline/pipeline_magic_model.py:508] | both | **adopt** — recurrence evidence + discard-ledger both already committed (distillate §5) |
| F13 | Furniture relabel | boundary blocks relabeled by anchors | header/footer/number anchor y-boundaries; 30%/70% page bands | deterministic post-pass wrapped around the layout model [code m:model/layout/pp_doclayoutv2.py:1373-1490; bands :1443-1444] | MinerU | **adapt** — anchor-propagation is a reconciliation move; currently trusts model anchors [inferred] |
| F14 | Table geometry | bordered tables; borderless candidates; structure normalization | rule intersections; token alignment/gaps | `TableBorderProcessor` [code odl:processors/TableBorderProcessor.java:39-47]; cluster consumer [doc]; `TableStructureNormalizer` [code odl:processors/TableStructureNormalizer.java:36-44] | ODL | **adapt** — geometry-first table floor; semantic recovery stays a hole (§3) |
| F15 | Caption linking | caption ↔ figure/table attachment | proximity within offset radii; cue text | `CaptionProcessor` [code odl:processors/CaptionProcessor.java:35-39]; visual-parent search [code m:backend/pipeline/pipeline_magic_model.py:340, :461] | both | **adopt** — twice-invented attach-by-geometry; codex has the caption lane already |
| F16 | Formula numbers | equation number → `\tag{}` on its formula | bbox overlap with formula block; sequence sanity pass | [code m:backend/utils/formula_number.py:16-168] | MinerU | **adopt** — wholly deterministic; fills a named markpig gap [doc] |
| F17 | Cross-page merges | table continuation; neighbor lists/tables | geometry + structure compatibility across the boundary | `can_merge_tables`/`merge_table` [code m:utils/table_merge.py:686, :1123]; `checkNeighborLists/Tables` [code odl:processors/DocumentProcessor.java:398-399] | both | **adapt** — the reconcile-stage floor |
| F18 | Reading order | linear order per page | projected whitespace gaps only | recursive largest-gap cuts ≥ 5 pt + narrow-outlier retry [code odl:processors/readingorder/XYCutPlusPlusSorter.java:331-513] (§0 C7) | ODL | **adapt** — as ONE proposal source, never the owner (distillate §5) |
| F19 | Difficulty triage | route page → Java vs backend | FFFD rate, table borders, grid/line patterns, large-image geometry | fixed priority chain with hand confidences [doc; constants odl:hybrid/TriageProcessor.java:52-116] | ODL | **adapt** — as hotspot-priority/health features, not routing [inferred] |
| F20 | Sanitize + emit | object graph → JSON / middle.json → markdown | assembled graph | `ContentSanitizer` [code odl:processors/DocumentProcessor.java:188-190]; renderers [code m:backend/pipeline/pipeline_middle_json_mkcontent.py:968] | both | **skip** — our EMIT is a boring projection off the final IR by design |

**Floor summary [inferred]:** every floor stage consumes *typography, geometry, or recurrence* — exactly the feature families the reboot's typed views formalize. Nothing here does whole-document discovery first: every mechanism is page-local, with cross-page passes bolted on afterward (F10/F12/F17). The floor is real and broad — but its order of operations is the thing the reboot inverts.

---

## 2. Constants census

Curated to load-bearing + instructively-dead; the full sweep found **104** `static final` numerics in ODL core alone (sandbox scan, this session). "LB?" = does it actually gate behavior in current code (cf. beta).

| Constant | Site | Role | LB? | Document-conditioned replacement (one clause) |
|---|---|---|---|---|
| `DEFAULT_BETA = 2.0` | odl:…/XYCutPlusPlusSorter.java:50 | cross-layout width gate | **NO — kills its own branch** (§0) | S14: sweep→plateau / per-regime estimate / bridge inference |
| `DEFAULT_DENSITY_THRESHOLD = 0.9` | :53 | axis preference | **NO — computed, never read** | resurrect as a density-regime *view*, not a scalar |
| `OVERLAP_THRESHOLD = 0.1` / `MIN_OVERLAP_COUNT = 2` | :56/:59 | cross-layout corroboration | NO — unreachable at default beta | subsumed by region-role clustering |
| `MIN_GAP_THRESHOLD = 5.0` | :63 | min projected gap to cut | YES | gap distribution per document: column-gap mode vs leading mode |
| `NARROW_ELEMENT_WIDTH_RATIO = 0.1` | :68 | outlier filter on cut retry | YES | width-regime membership instead of a fixed fraction |
| `ONE_LINE_PROBABILITY = 0.75` | odl:processors/TextLineProcessor.java:38 | same-line acceptance | YES | per-document baseline/leading regime; calibrate on within-doc self-agreement |
| `DIFFERENT_LINES_PROBABILITY = 0.75` | odl:processors/ParagraphProcessor.java:34 | paragraph-merge gate | YES | same regime; retain both hypotheses near threshold |
| `HEADING_PROBABILITY = 0.75` / `BULLETED… = 0.1` | odl:processors/HeadingProcessor.java:44-45 | heading acceptance / bullet demotion | YES | typography-regime contrast from global clustering |
| `LIST_ITEM_PROBABILITY = 0.7`, `…BASELINE_DIFFERENCE = 1.2`, `…X_INTERVAL_RATIO = 0.3` | odl:processors/ListProcessor.java:49-51 | list-item geometry gates | YES | label-recurrence posterior over the document |
| `CAPTION_PROBABILITY = 0.75`, offsets `= 1` | odl:processors/CaptionProcessor.java:35-39 | caption attach gate + search radius | YES (offsets look neutral [inferred]) | caption-style regime + global bipartite assignment |
| `MAX_HEADER_FOOTER_GAP = 30.0` | odl:processors/HeaderFooterProcessor.java:156 | furniture band | YES | page-template regime from recurrence clustering |
| Triage family (`LINE_RATIO 0.3`, `MIN_LARGE_IMAGE_RATIO 0.11`, `MIN_IMAGE_ASPECT 1.75`, `MIN_LINE_COUNT_FOR_TABLE 8`, …) | odl:hybrid/TriageProcessor.java:52-116 | difficulty router | YES (two computed signals deliberately disabled after FP experiments [doc :684-703]) | become hotspot-priority features, not a router |
| `TABLE_INTERSECTION_PERCENT = 0.01` | odl:processors/AbstractTableProcessor.java:37 | overlap identity guard | YES | fine as-is — identity, not tuning [inferred] |
| TableStructureNormalizer 9 constants | odl:processors/TableStructureNormalizer.java:36-44 | under-segmentation repair | YES | row-band clustering under document leading |
| `MIN_CONTRAST_RATIO = 1.2` | odl:processors/HiddenTextProcessor.java:31 | hidden-text physics | YES | fine as-is [inferred] |
| levels `X_GAP_MULTIPLIER = 0.3` | odl:utils/levels/LevelInfo.java:26 | nesting indent unit | YES | indent-regime clustering |
| FFFD ratio ≥ 0.30 | odl:processors/ContentFilterProcessor.java:53-86 [doc] | extraction-failure page signal | YES | keep as an absolute health floor |
| pdf_classify family (~30 named) | m:utils/pdf_classify.py:17-49 | native-vs-OCR route | YES | port wholesale as *signals*; decisions → abstention/flags |
| per-class conf 0.4–0.5 + global 0.45 | m:model/layout/pp_doclayoutv2.py:64-90, :915 | detection acceptance | YES | dies with the model; lesson: per-kind acceptance is regime-dependent |
| dedupe IoU 0.9 · nested-formula overlap 0.7 · inline-vs-display cover ratio | m:model/layout/pp_doclayoutv2.py:1499-1500, :1360-1368 | box reconciliation post | YES | survives as generic region-reconcile ops on any proposal source |
| `merge_spans_to_line` 0.6 | m:utils/span_block_fix.py:52 | same-line y-overlap | YES | leading regime |
| span-fill: overlap 0.5 · contrast 0.17 · space `width*0.25` · `MAX_NATIVE 65535` · PUA family | m:utils/span_pre_proc.py:93/:282, :220, :637, :17, :18-22 | binding + OCR-fallback gates | YES | binding stays mechanical; thresholds → char-metric regimes |
| para_split: indent `0.7*line_height` · closed-area 0.26/0.36 · vote ratios 0.8/0.5/0.4 | m:backend/pipeline/para_split.py:125-126, :144-151, :174-211 | list/index/para discrimination votes | YES | densest cluster of magic votes in either system — exactly S5 Refine + typographic-role territory [inferred] |
| wireless `cls_score < 0.9` · `ocr_score < 0.8` drop | m:backend/pipeline/batch_analyze.py:667, :909 | model-output trust gates | YES | generalize into the per-decision confidence ledger |
| script-role ratios 0.9 / 0.15 | m:utils/span_pre_proc.py:376-377 | sub/superscript geometry | YES | markpig equivalent exists; compare calibrations |

**Census read [inferred]:** the load-bearing constants cluster into four families — *leading/baseline units* (0.6, 0.75, 1.2, 0.7·lh), *page-fraction bands* (0.1, 0.3, 30%/70%, 0.11), *vote ratios* (0.8/0.5/0.4), and *trust gates on model output* (0.8, 0.9). The first three are all per-document estimable from the same typography/page-template regimes stage 2 discovers; the fourth dissolves when hypotheses are preserved instead of gated. The beta lesson generalizes: the *dead* constants sit precisely where a universal value couldn't be found (cross-layout, density) — the code shipped with the feature off.

---

## 3. Model census with hole interfaces

Pipeline backend only; MinerU roster assembled at [code m:backend/pipeline/model_init.py:231-291], per-page sequence at [code m:backend/pipeline/batch_analyze.py:408].

| Model | I/O contract | Surrounding deterministic code assumes | Hole interface — any replacement must emit |
|---|---|---|---|
| **PP-DocLayoutV2 detector** (RT-DETR derivative) [code m:model/layout/pp_doclayoutv2.py:790-895; init model_init.py:261] | page image → ≤ N boxes × 25 classes + scores, 0–1000 coords | complete typed page coverage; dedupable (IoU 0.9); header/footer/number anchors exist for F13; every span finds a block or is discarded/OCR'd | typed region hypotheses `(bbox, kind, score)` per page, kinds mapping onto manuscript-ir kinds; explicit residual instead of silent completeness; ambiguity preserved |
| **PP-DocLayoutV2 reading-order head** [code :719, decode :935-947] (§0 C5) | (boxes, class-ids) → S×S pairwise logits → total rank | a single total order (`index`) per page consumed by everything downstream [code :1384] | total preorder + per-adjacency confidence; partial order acceptable only with an added linearization step [inferred] — stage-5 jurisdiction |
| **MFR** — UniMERNet-small default / PP-FormulaNet_plus-M [code model_init.py:62, :244-258] | formula crop → LaTeX string | content embedded verbatim; `\tag{}` attached by geometry regardless of content (F16) | LaTeX + per-structure confidence + abstention; planned filler = markpig assembler + masked-hotspot agent |
| **OCR det+rec** (Paddle-style) [code model_init.py:133-146, :269-272] | image → text boxes + strings + scores | accepted OCR text has equal standing with native text once past gates (score ≥ 0.8, contrast ≥ 0.17) | off-MVP boundary; keep as health-triggered escalation, never silent substitution |
| **Table stack** — orientation cls + wired/wireless cls + two recognizers [code model_init.py:72-114, :274-289] | table crop → HTML | HTML treated as opaque content, except cross-page merge parses its structure [code m:utils/table_merge.py] | cell grid with row/col spans + per-cell provenance; HTML only as projection |
| **llm_aided title levels** (optional) [code m:utils/llm_aided.py; deterministic fallback m:utils/title_level_postprocess.py] | heading list → level assignment | pass is optional; pipeline runs without it | precedent for the bounded agent-assist socket in a mechanical pass — matches the supervisory-socket doctrine [inferred] |
| **ODL hybrid backends** (optional — Docling server / Hancom AI) [code odl:hybrid/HancomAISchemaTransformer.java:102-125; TextSimilarity.java:25] | page image → labeled regions (18-int scheme) → native text grafted back at similarity ≥ 0.5 | backend output is page-truth; single winner, no voting [doc] | boundary note only — ODL-minus-models = ODL minus this lane entirely |
| **MinerU vlm / hybrid backends** | out of scope per brief | — | boundary: same middle.json contract [doc] |

**Hole-census read [inferred]:** three of the five substantive holes — layout roles, reading order, table *structure* — are decisions the reboot re-poses as whole-document/posterior problems; they are partly artifacts of page-local decomposition, not intrinsic to the subproblems. The two holes that survive any decomposition are formula recognition and OCR — precisely where codex already commits to masked-hotspot adjudication and an out-of-MVP boundary respectively.

---

## 4. Jurisdiction map (keyed to distillate §3 stage numbers)

| Stage | Floor pieces → borrow | Holes → {clustering / posterior / agent} |
|---|---|---|
| **0 CONTRACT** | only analogue: middle.json staged-IR pattern [doc] | ours alone — neither system measures against an external reference; the LaTeX twin is the departure |
| **1 ATOMS** | F1–F4; F19 signals; pdf_classify (F3) as intake health | none — pure borrow territory |
| **2 GLOBAL** | *empty in both systems*; nearest things are the recurrence bolt-ons (F10 label intervals, F12 furniture recurrence, F11 doc font statistics) | net-new → **clustering**; the bolt-ons become its seed views [inferred] |
| **3 DECOMPOSE** | F5–F8, F14 geometry; F18 gap proposals | layout-role typing (detector hole) → **clustering proposes, posterior selects**; §2's leading/band/vote families are the priors to re-estimate per document (S14 generalized) |
| **4 RECONCILE** | F9, F13, F15–F17 | both systems resolve conflicts internally and store one winner — hypothesis preservation is net-new → **clustering (co-association) + posterior** |
| **5 INFER** | F18 only | the deepest hole: reading order is the one place MinerU spent a transformer (C5) exactly where ODL's determinism demonstrably collapsed (C7) → **posterior inference** over the latent manuscript graph; both systems' orders enter as proposal-ledger entries (S13) |
| **6 ADJUDICATE** | none | llm_aided is the lone precedent → **agent** (semantic interpretation + reconciliation per distillate §7) |
| **7 REGISTER** | F7 script roles; F16 formula numbers; MinerU's mask-formulas-during-OCR channel-separation discipline [doc] | formula content (MFR hole) → **masked hotspots + agent**; math/prose boundary → **contrastive clustering** |
| **8 EMIT** | F20 pattern | none — skip; markdown is a projection |

**Composite verdict [inferred]:** the deterministic floor covers stages 1, 3-geometry, 4-mechanics, and 7-attachments nearly end-to-end; the holes concentrate at stages 2, 5, 6 — global discovery, ordering inference, and semantic adjudication — which is exactly where the reboot places clustering, posterior inference, and the agent swarm. The two reference systems, subtracted, independently confirm the reboot's decomposition: what they automated is what we borrow; what they modeled is what we re-pose.
