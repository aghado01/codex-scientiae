# Scriba Scientiae — design charter

**Status:** founding charter (2026-07-20), distilled from the codex-scientiae converter campaign
(retrospective: codex `issues/retrospective/architecture-retrospective-20260720.md`). This is the
reboot's constitution: the problems the system exists to solve, the principles that survived
contact with real corpora, the lane anatomy every component follows, and the measurement
discipline that decides what lands.

---

## §0 Purpose and positioning

Scriba converts technical documents — PDF and LaTeX source — into one canonical, faithful,
KaTeX-renderable markdown register. Two intake realities, one target:

- **LaTeX source exists** → parse/transform of a structured language (texdig). Near-lossless;
  math passes through. Its output doubles as the per-document **ground truth** the PDF lane is
  measured against.
- **Only the PDF exists** → an inverse problem over print geometry (pdfdig). Perception is
  deterministic (PdfPig born objects); interpretation is confidence-bounded and carries its
  uncertainty as flags.

**Against the field.** Docling/opendataloader-pdf and MinerU are the named contrasts:

- *Docling/opendataloader*: VLM-primary at intake — hallucinations enter the substrate where
  nothing downstream can falsify them; geometry that could falsify them is discarded; output is
  trusted verbatim. Scriba's intake is deterministic by construction; models never perceive.
- *MinerU* (recon: `issues/sol-experimental-design-and-measurement.md`): the strongest learned
  competitor — its hybrid backend even runs layout-model + native-text + VLM channels. The
  decisive difference: MinerU **resolves channel disagreement internally and emits a single
  answer**; scriba **preserves disagreement as a first-class artifact** (flags, witness records,
  abstentions) because disagreement is precisely the dispatch signal for the reasoning tier.
  MinerU is a candidate third intake/oracle lane someday (scans, tables); it is not the
  architecture.

The core wager: **perception/interpretation separation.** Perception stays algorithmic and
reproducible. Interpretation — the semantics — is split by jurisdiction (§6): forced decisions in
code, judgment calls dispatched to a reasoning tier with evidence and a verifier. VLM-primary
systems conflate the two at intake; scriba never does.

## §1 The canonical problems

The problem inventory the whole system decomposes into. Each entry: the problem, the lesson
learned in the codex campaign, current status.

1. **Origin identification** — what made this PDF (pdfTeX / office / journal rewriter) decides
   every downstream prior. *Lesson:* producer strings lie (arXiv's pikepdf rewrite); use an
   evidence ladder (producer → creator → font domains) and record which cue decided. SOLVED,
   ported (producer-map store + font evidence).
2. **Segmentation & reading order** — columns, blocks, flow. *Lesson:* RecursiveXYCut works but
   is a single unwitnessed CLAIM lane; reading-order errors are the least falsifiable defect.
   OPEN: needs a second witness (geometric clustering view; disagreement → flag).
3. **Role identification** ("how do we identify headings?") — the general form is **style-palette
   recovery**: a document's typography is emitted from a small latent palette (the style file);
   recover the palette, assign roles to *configurations* (not lines) via a small relational
   grammar (recurrence, ordinal anchors, alternation with body, position, outline witness).
   *Lesson:* order statistics win where typography is quantized (TeX); the ladder degrades on
   continuous-jitter producers (office/journal) — that is where mixture-model palette recovery
   earns entry. Decision granularity at the configuration level dissolves the rare-class problem.
   PARTIALLY SOLVED (calibration ladder + outline witness ported); palette formulation is the
   reboot's redesign.
4. **Math register isolation** — which glyphs are math. *Lesson:* font-role evidence (CMMI/CMSY/
   MSBM…) is strong but not universal (cmbright sets math in SF → document flag, not a guess).
   SOLVED for TeX-origin; oracle-free corpora rely on the same evidence with health flags.
5. **Glyph→LaTeX mapping** — the re-encoding of math, which **implicitly defines the mathdig
   standard** (§4). *Lesson:* store-driven symbol maps (font-aware, provenance-tagged) + 1.5-D
   script nesting by size-tier inversion solve the dominant failure class deterministically.
   SOLVED to 1.5-D.
6. **2-D math structure** — fractions, matrices, aligned blocks. *Lesson:* don't guess; flag
   `needs_2d_assembly` and bridge geometry to the reasoning tier as a text projection
   (math-evidence: glyph table + spatial sketch), verifier-gated. OPEN (deterministic tier is the
   C# AST project's job; agent tier handles the residual meanwhile).
7. **Figure identity** ("what are the figures?") — cluster ink, then veto. *Lesson stack:* per-page
   HDBSCAN over path bboxes with a physical metric (rectangle-gap, em-normalized); structural
   priors VETO figure-hood and never assert it; consensus OR-combines geometry with
   content-stream evidence; monster pages pre-aggregate. PRIMARY population SOLVED on
   calibration corpora (0 over-detections anywhere). OPEN residuals are mechanism-classes:
   glyph-built diagrams (tikz-cd — empty path lane), bitmap caption starvation.
8. **Caption/float association** — cue-typed attachment with guards; bounded rescue for
   fragmented caption heads. *Lesson:* probes must localize failure along the lane pipeline
   before any fix (the four-layer probe form). SOLVED for vector-figure corpora; starves on
   bitmap-heavy and pre-2000 journal layouts.
9. **Tables** — UN-MODELED. No table lane exists; tables currently leak through as prose. The
   honest gap the reboot must eventually close (MinerU's wired/wireless table stack is the
   benchmark to beat or borrow-as-oracle).
10. **References & citations** — solved on the texdig side (resolution + inline bibliography);
    PDF-side extraction remains heuristic. PARTIAL.
11. **Uncertainty carriage** — every stage's doubt must survive to the repair surface. *Lesson:*
    flags are the currency (`unknown_font_role`, `suspect_reading_order`, `needs_2d_assembly`,
    doc-level flags); the adapter *spends* born signals so downstream never re-derives them.
    SOLVED as a pattern; the reboot makes margins uniform (§6).
12. **Serialization & gates** — chunk stream → markdown per the standard; render_check (KaTeX)
    + markdown_lint as validity gates; review as the one holistic semantic pass. *Lesson:* gates
    measure validity, not truth — valid-but-wrong is invisible to them by design; that residual
    belongs to the reasoning tier. SOLVED / known blind spot named.
13. **Measurement** — the parity problem: how far is a conversion from the oracle? *Lesson:*
    two-population scoring with mechanism attribution and oracle-confidence annotation kills
    error cancellation; object-level acceptance beats aggregates. SOLVED for figure counts;
    OPEN as the general aligned typed fidelity metric (the conversion-metric design), which is
    the reboot's measuring instrument to build.

## §2 The constitution — principles that survived contact

1. **Perception ≠ interpretation.** Deterministic intake; no VLM perceives for the pipeline.
2. **Measurement ≠ opinion.** The substrate records; classifiers opine downstream, calibrated
   from the document itself; when uncertain they flag, never guess.
3. **Priors veto, never assert.** Structural priors may only remove/demote candidates. The
   observable form: the zero-over invariant at the gate.
4. **Document-local calibration.** Every threshold is a relative, em-normalized statistic of the
   document's own typography. This is why knobs transport out-of-sample.
5. **Rules-as-data with epistemic classes.** Four kinds of knowledge, four homes: *measurements*
   (recomputed, never stored) · *world registers* (stores/ — document-independent production
   facts, specimen-validated, admission test in stores/README) · *policy* (config — every value a
   gate-licensed degree of freedom carrying its calibration provenance) · *document errata*
   (patch sidecars beside the paper). What is none of these is a *judgment* → agent tier.
6. **Witnesses over oracles-in-code.** Independent evidence lanes (outline, content stream,
   letters, future segmentation witness); agreement is silent confirmation, disagreement is a
   flag. Never resolve disagreement silently (the MinerU contrast).
7. **Config-gated ladders, replayable.** Absent block = disabled; knobs land default-OFF, pass
   the gate, then default-ON; old fixtures replay byte-identically. Determinism everywhere;
   anything stochastic is seed-pinned.
8. **Artifact-decoupled stages.** Every stage reads the previous stage's files from a runstamped
   dir (`.runs/{stamp}/{lane}/`); any stage re-runs alone; newest-wins with pinnable runs.
9. **The oracle coupling.** The easy lane measures the hard lane: texdig output is the answer
   key; the gate imports the same counting code that wrote the sidecars. One counter model.
10. **Two-population scoring + mechanism attribution + object-level acceptance.** Aggregates
    cancel; populations and mechanisms don't. A gate emits a work-list, not a scalar.
11. **Probe first, predeclare valuation.** Probes localize (layered along the lane), never merely
    detect; when two thrusts optimize different objectives, fix the decision rule before probing.
12. **Distillation, not delegation.** The reasoning tier sees the same evidence the converter
    had, projected into its modality, and its proposals pass a deterministic verifier. It never
    receives an answer from a sidecar, and it never sits inside an instrument.
13. **Codepoint safety.** UTF-8-no-BOM explicit on every content I/O; SMP math and ligatures
    round-trip; U+FFFD is flagged, never replaced. Ordinal string operations (culture traps).
14. **Engines are black boxes behind the lane.** Clustering/solvers as CLIs with policy in the
    lane; engines swappable once the (features, metric, model) formulation is right.

## §3 Lane anatomy — the structural rule of the reboot

Every problem lane (§1) ships the same anatomy, or it doesn't ship:

- **Evidence inputs** — which substrate lanes/artifacts it reads.
- **An oracle contract** — what ground truth scores it (texdig sidecar, skeleton, render check),
  and the documented gap where no oracle can exist (PDF-only corpora → oracle-free health
  signals).
- **A gate** — populations, mechanisms, invariants; wired into the gauntlet battery (§5).
- **A config block** — epistemically annotated (structural | fitted:{probe, gate-commit} |
  lifecycle-flag).
- **A dispatch surface** — what it flags/abstains, with evidence briefs for the reasoning tier.

**No lane without a gate.** A solver whose defects can't be measured doesn't get built; the
oracle and gate are designed *first* (this ordering is the single biggest lesson of the codex
campaign — the figure lane only became tractable when the two-population gate existed).

## §4 mathdig — the register, spec-first

The codex converters *implicitly* defined the target math register through their behavior
(symbol-map choices, seam grammar, assembler output). The reboot inverts this: **mathdig is a
written spec with validators, and every producer targets it.**

- The register: canonical KaTeX-renderable markdown math — `$…$` / `$$…$$` seams, nesting
  grammar for scripts, the canonical symbol set (what Unicode passes through, what maps to
  commands), flag vocabulary for unresolved constructs.
- Three producers, one register: texdig (macro-expanded pass-through), pdfdig (assembled from
  geometry), membrane repairs (agent proposals). One measurement space: the parity metric
  compares same-register token streams — the point of the target-register decision.
- Validators are the contract: render_check (does it compile), register-conformance (is it
  canonical), and the math bank aligner downstream.
- mathdig is ENCODING, never extraction: it does not read PDFs and it does not solve math; the
  -dig extractors feed it.

## §5 The gauntlet operating system

The battery lives in-repo at `gauntlet/battery/{corpus}/` (charter: `gauntlet/CHARTER.md`);
regenerable runs under git-ignored `.runs/`. The methodology, operationalized:

- **Corpus roles.** *Calibration* (ph-zigzag, voroninski): the only corpora knobs may be fitted
  against. *Transport* (mapper, kisungyou): gate run UNTOUCHED at milestones. *Stress*
  (spc, PDF-only): oracle-free instruments only. Accession is transport-by-default; promotion to
  calibration is an explicit recorded decision. "A knob calibrated everywhere is validated
  nowhere."
- **The increment loop.** Probe (localizing) → predeclared decision rule → implement behind a
  default-OFF knob → offline ablation harness with knobs pinned on both sides → gate BOTH
  calibration corpora (baseline must reproduce recorded numbers first) → read the render /
  eyeball the crops → default-ON + record in the frontier → transport runs at milestones.
- **Acceptance.** Object-level precision/recall against object-level truth for assertion work;
  population invariants (PRIMARY untouched, zero-over) for veto work; never aggregate deltas.
- **The record system.** Dated frontier briefs (superseding, `issues/{topic}/frontier-YYYYMMDD.md`)
  = forward plan; an engineering-plan log = history; probe headers = iteration records; sentinel
  page sets = fast regression eyes; the specimen registry = curriculum and regression suite;
  `pig-run.json`-style manifests = per-mechanism census of every run.
- **Instruments are agent-free forever.** The gate, oracle counters, sidecars, and dispatcher
  never contain model output.
- **Extension rule.** Each new problem lane (§1) plugs in by defining its oracle, populations,
  and mechanism vocabulary before its solver — headings are next (oracle = texdig structure
  skeleton; score identity + level + order), then the full parity metric as the unified gate.

## §6 The jurisdiction ladder

Interpretation is tiered; routing is always tier-0 (mechanical — the agent never decides what
the agent decides):

- **Tier 0 — forced.** Evidence determines the answer (calibration with margin, store facts,
  geometry). Code decides. All routing/triggering lives here. Uniform *margin emission* is the
  reboot upgrade: every calibrated decision reports its confidence the way flags already do.
- **Tier 1 — propose-only.** Code proposes, agent confirms (the enrichment idiom).
- **Tier 2 — agent-adjudicated.** Agent proposes from a typed evidence brief (the math-evidence
  template generalized: question + distilled evidence + bounded answer space + named verifier);
  a deterministic gate accepts. Semantic assembly, witness-disagreement adjudication,
  valid-but-wrong review live here.
- **Tier 3 — human.** No verifier exists: editorial promotion, oracle curation, store admission.

The agent tier is held to gauntlet standards: decision classes scored object-level against the
oracle on dual-availability papers; abstention honored as an outcome.

### The resolution ladder — preserved disagreement is only a virtue if resolution is engineered

A witness disagreement resolves through four mechanical rungs, all automated:

1. **Typed dominance rules** (tier 0) — most disagreement classes have a principled,
   gate-validated winner (outline wins heading existence, typography wins tier; consensus m1's
   inclusive OR). Explicit policy, not silent arbitration.
2. **Arbiter evidence on demand** (tier 0) — a disagreement triggers computing a third signal
   too expensive to compute globally (local baseline-flow check when block order and letter
   order disagree). Disagreement as a trigger for targeted computation, still deterministic.
3. **Agent adjudication** (tier 2) — bounded question, both witnesses' evidence in the brief,
   deterministic verifier on the answer. No human in the loop; reliability per decision class is
   a measured number.
4. **Safe degradation** — every disagreement class declares its conservative default (emit prose
   not heading; never claim figure-hood) and the flag rides into the deliverable. The pipeline
   never blocks; an unresolved case yields an honest artifact, not a wrong one.

**The flywheel:** every agent adjudication is a labeled specimen (evidence in, verified answer
out). When a class accumulates specimens showing a consistent pattern, the pattern is promoted
to a tier-0 rule through the normal gate discipline, and the class leaves the agent's
jurisdiction — the system grows MORE deterministic over time. The standing instrument is the
**disagreement census** per corpus: volume, type, auto-resolution rate, resolution correctness
vs oracle. High-volume/low-resolution classes are the prioritized backlog. (This is the
operational contrast with MinerU: a fixed internal policy that never records what it overrode
cannot improve this way.)

## §7 Keep / rebuild / drop (from codex)

**Keep (port as-is, they earned it):** the stores + admission discipline; runstamped artifact
layout; JSONL substrate conventions (.jidx/.sig, UTF-8-no-BOM); the figure-lane veto ladder and
its config; hdbscan engine + trust harness; texdig's expand→resolve→protect→transform→restore
architecture + patch-errata lane; md-register (the ONE figure register); math-assembler +
math-evidence; Compare-FigureCounts + the ablation harness + probes; the gauntlet charter and
battery; the protocol clauses; render/lint gates.

**Rebuild differently:** role identification as palette recovery + configuration-level grammar
(§1.3) replacing line-ladder special cases; segmentation gains a second witness; the membrane
sheds docling-damage compensation (born-signals intake only — the adapter dialect becomes the
native node contract, not a transitional bridge); classify-config split by epistemic class;
tables designed from scratch against an external oracle; uniform margin emission.

**Drop / leave behind:** docling/opendataloader intake (legacy — codex keeps it for its corpus);
the banded metric (parked by verdict — carry the verdict, not the code); corpus-repair sweeps
that belong to the library repo.

## §8 Open decisions (named, not defaulted)

1. **Version control** — the working tree is not yet a git repo; init + remote (`aghado01/
   scriba-scientiae`) before any further reorg, so the migration itself has history.
2. **Repo boundaries** — three siblings now: *codex-scientiae* (the library: corpora, membrane
   serving, publish planes), *scriba-scientiae* (converter dev + gauntlet), *MarkPig* (the C#
   AST tier). The battery corpora were copied here: decide the sync/ownership story with codex
   (recommendation: scriba owns the battery going forward; codex keeps the reader shelf).
3. **What of the membrane comes along** — repair loop + MCP surface: which tools move here vs
   stay serving the codex library (publish/reader tools clearly stay).
4. **Languages — DECIDED 2026-07-20.** Two shipping languages, one artifact contract between
   them: **C# engines** (perception + hot paths — PdfPig is .NET, the hdbscan engine and MarkPig
   already are; publish as dotnet tools/NuGet, namespace `Scriba.*`) and **TypeScript drivers**
   (orchestration, MCP servers — the reference SDK is TS; dispatch + the resolution ladder, with
   disagreement/evidence-brief schemas as typed JSONL contracts; the render/raster toolchain is
   already Node). **Python permitted in `probes/` only** (sklearn/numpy research instruments —
   probes graduate by their findings, never their code). Rust/Go declined: the perf tier is
   already C# and nothing PdfPig-shaped exists there. PowerShell retires with honors (its lab
   superpower was free in-process .NET interop — exactly what the fattened C# engine boundary
   replaces). **Migration sequence:** fatten the C# engine first (the pdfdig chain as a
   self-contained dotnet CLI emitting the JSONL lanes), thin the driver to orchestration over
   artifacts, then the driver rewrite — the gauntlet runs throughout because the gate consumes
   artifacts, not code.
5. **MinerU as optional oracle lane** — for tables/scans; strictly verification-side if ever.
