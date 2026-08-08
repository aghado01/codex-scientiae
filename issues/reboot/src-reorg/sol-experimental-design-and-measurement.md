Saturday 1:10 AM
well why dont you review the ingestion/gauntlet results so far where i have a collection pdf and latex pair-matched source, with my latex converter oracle deterministically rendering the pdf-converter's target

Saturday 1:15 AM

Worked for 1h 44m 15s
I reviewed the stable snapshot after the latest 20260718_024528 calibration run completed. My candid conclusion:

The gauntlet already validates pdfdig as a worthwhile research program, but it does not yet validate faithful PDF→manuscript transfer. It currently proves useful deterministic signal recovery—especially captioned figures—and exposes repeatable failure mechanisms. Math and headings remain substantially pre-semantic.

What is actually tested
Corpus Role Current coverage
ph-zigzag diagram calibration 10 pig + oracle pairs
voroninski figure calibration 23 pig + oracle pairs
kisungyou paired-source transport 23 pig + oracle pairs
mapper untouched transport 9 oracles, 0 pig runs
spc PDF-only stress 8 pig runs, no oracle
So there are 65 LaTeX oracle documents, but only 56 currently pair with pdfdig. There is also no corpus-wide final pdfdig Markdown to compare—the paired experiment presently ends mostly at classified IR.

One major experimental confound: ph-zigzag and voroninski use config 9cdb1eeed4a1, while kisungyou and SPC still use 99c9e1c1acea. Calibration-versus-transport numbers are therefore not from one pinned converter build.

The figure subsystem is genuinely promising
Current primary results—captioned pig regions versus LaTeX figure floats:

Corpus Exact Under Over Mean absolute error
ph-zigzag 9/10 1 0 0.40
voroninski 18/23 5 0 0.35
kisungyou 12/23 10 1 1.00
Only one of 56 papers over-counts captioned figures, and that paper has a low-confidence oracle with missing source assets. Caption cues are therefore acting as a very effective precision filter.

But the primary score hides the uncaptioned population:

Corpus Pig uncaptioned regions Oracle inline diagrams
ph-zigzag 80 78
voroninski 225 0
kisungyou 164 0
In kisungyou, 115 of the 164 uncaptioned regions have no explicit region flag; in voroninski, 197 of 225 are unflagged. caption: null still provides implicit uncertainty, but every kind=figure region is currently rendered to PNG.

The primary metric also conflates detection and caption attachment. For 1810.02906v1, the score says 13 versus 19 figures, delta −6. Yet pig found 17 total figure regions: four appear to be caption-missed floats, leaving closer to two actual region misses. Labeling the whole deficit “raster-blindness” is misleading.

The gate should therefore report separately:

visual-region recall;
float grouping;
caption-link precision/recall;
residual uncaptioned candidates;
inline-diagram fidelity.
The current comparison explicitly defines captioned count as “did we find the real figures,” which is too compressed for this distinction: Compare-FigureCounts.ps1 (line 213).

Math and headings show the real manuscript problem
I ran a conservative structural audit against the oracle Markdown. Heading matches are exact after stripping numbering, punctuation, case, and spacing. Formula groups are important because the adapter normally turns each group into a $$...$$ manuscript block.

Corpus Heading precision / recall Formula groups / oracle display blocks Unflagged formula groups
kisungyou 0.428 / 0.797 7,068 / 1,583 = 4.46× 3,790
ph-zigzag 0.405 / 0.662 2,752 / 275 = 10.01× 1,711
voroninski 0.552 / 0.775 11,634 / 2,050 = 5.68× 5,640
This is not yet the planned aligned fidelity scorer, so it should not be treated as a final grade. But the degree of oversegmentation is unambiguous: across the 56 pairs, pdfdig produces 21,454 formula groups for 3,908 oracle display blocks, and 52% of those formula groups carry no flag.

Two concrete failures explain it:

In 1810.02906v1, inline subscripts such as $A_{ij}$ receive their own PDFPig line IDs because they sit on displaced baselines. The main prose becomes effectively “For a binary network, = 1…,” while A\_{ij} is emitted separately as a display formula. See the detached inline node (line 74).

The display equation
\dot c*i(t)=\sum*{j\sim i}(c_j(t)-c_i(t))
is split among an unflagged standalone ∑, prose fragments, and a different malformed formula group. The flags correctly catch part of the damage, but not the whole broken semantic unit.

This means the critical missing layer is not chiefly symbol recognition. It is 2-D reassociation before deciding inline versus display versus prose.

Headings have an analogous premature-commitment problem. The outline matcher uses containment in both directions and does not enforce a one-to-one monotone assignment: pdfdig-classify.ps1 (line 449). Consequently, ordinary body lines containing “simulation study” are matched to the Simulation Study bookmark and promoted as headings.

A second edge case is even cleaner: all 16 detected heading lines in 2111.15058v3 are marked outline_fragment, largely because bookmarks include section numbers while printed headings do not. The adapter demotes every lone outline fragment, producing zero headings for that paper: pdfdig-adapter.ps1 (line 170).

SPC confirms that typography is a real transport boundary:

BWD1997: 2,293 heading-candidate lines from 4,726 nodes; known font-role fraction 3.58%.
PKWang2020: 407 heading-candidate lines from 1,248 nodes; known font-role fraction 5.77%.
The local nodes do carry unknown_font_role, which is good. What is missing is escalation from pervasive local uncertainty to a document-level verdict such as “semantic role labels are unusable.”

Determinism is partly demonstrated
Across 46 calibration paper/config combinations having at least two completed runs:

classified node JSONL was byte-identical in 46/46;
figure JSONL was byte-identical in only 5/46.
The latter does not necessarily prove stochastic clustering. One same-hash pair differed because a caption changed from truncated to complete—probably code evolution under an unchanged 0.2.0 version and unchanged config hash. So the stronger finding is that the build fingerprint is incomplete: it hashes configuration, not the implementation that produced the artifact.

There is also a live-run race. Run discovery treats a pig run as available as soon as its envelope exists: runs.ps1 (line 68). But the completion manifest is written only after classification, figures, and image export: Invoke-Pdfdig.ps1 (line 81). During this review, the harness briefly selected partially written runs. Additionally, pig_run currently records .runs rather than the runstamp because it climbs one parent too far.

What is not yet being measured
The intended scorer is still explicitly “not yet built”: aligned-fidelity-scoring.md (line 3). The math-bank and structural-skeleton oracle are also still design-only: math-bank-oracle-lane.md (line 3).

Consequently, the gauntlet does not yet measure:

aligned math-token or AST fidelity;
accepted-unit false-confidence rate;
heading hierarchy precision/recall officially;
prose reading order and duplication;
equation identity and cross-reference retention;
how completely flags cover actual oracle disagreements;
how much the ambiguity envelope compresses the eventual LLM workload.
The oracle target itself also needs pinning. The Markdown is written at the paper root while counts are runstamped, and the sidecar does not record source, oracle-output, or converter-build hashes. If equation identity belongs to the manuscript semantics, it also needs enrichment: the 65 oracle Markdown documents contain 4,272 display blocks but only 32 \tag{} occurrences.

My verdict
Your central idea survives this review—perhaps more strongly than before—but with a refinement:

pdfdig should not commit early to a manuscript. It should deterministically construct and rank competing manuscript hypotheses.

HDBSCAN and persistent topology are well suited to producing a hierarchy of candidate components. They should not be forced to choose the final semantic partition. The manuscript IR should preserve:

born atoms and provenance;
geometric and typographic relations;
alternative grouping hypotheses;
accepted high-confidence semantic units;
explicit unresolved competitions;
stable mappings from every manuscript unit back to PDF evidence.
The most useful next benchmark is therefore not a weighted “conversion score.” It is a small aligned Stage-0 evaluator reporting:

oracle-unit coverage;
fidelity among automatically accepted units;
false-confidence rate;
ambiguity recall—how often wrong units were flagged;
residual compression—how much evidence must reach the MCP/LLM;
deterministic canonical hash under a pinned build.
That would test your actual thesis. Right now, further tuning of figure clustering risks polishing the best subsystem while the math/manuscript boundary remains unmeasured. The paired-source gauntlet is absolutely worth keeping; it is already doing its most valuable job—falsifying premature semantic decisions in a precise, localizable way.
