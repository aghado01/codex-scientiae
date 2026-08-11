# agy — stage-1 output contract cross-examination

**Reviewed:** 2026-08-11. The TeXdig stage-1 output contract as proposed in discussion (three artifact
tiers, four gates, one id grammar), cross-examined against the then-committed `src/TeXdig/README.md`
and `src/TeXdig/core/types.ts`, the reboot notes (`issues/TeXdig/notes/*`),
`ingestion/inventory/CONVENTION.md`, `src/jsonl_engine/schemas/graph.primitive.schema.json`, and the
13 LaTeX deposits under `ingestion/inventory/`.

**Provenance:** para-agent journal stream `agent-agy`, turn 4, session
`eb1c2839-9721-4c42-9fa7-b558e63279b8`. That journal does not live in the repo. **This brief is the
durable record**; the original review text and its tool transcript are outside version control and
should not be assumed recoverable.

**Dispositions verified against:** `a214fd4..3159ade` — `src/TeXdig/README.md`,
`src/TeXdig/core/types.ts`, `src/TeXdig/core/contracts.ts` (renamed from `core/handoff.ts`).

**Disposition vocabulary:** `LANDED` (encoded in the amended contract, mechanism cited) ·
`ACCEPTED-PENDING-ENGINE` (design accepted, implementation not yet written) · `RESOLVED-DIFFERENTLY`
(answered by a different move than proposed) · `OPEN` (still undecided — collected at the end).

**Decisions taken since the review**, bearing on several findings below:

- Store names chosen: **`zones.jsonl`** (was "capsules", name undecided) and **`walk.jsonl`** (was
  "manuscript"). "protograph" → `graph.jsonl`; **handoff tier → contract tier**.
- Ordinals are **always** appearance-normalized 1-based, with the paper's own register preserved
  beside as `sourceLabel`/`listPosition` and a `census/ordinal-label-mismatch` diagnostic on
  deviation.
- The **jsonl_engine schema registry is the promotion destination**; `core/contracts.ts` is the
  in-language DTO layer and iterates until battle-tested.

---

## 1. Gaps

**G1 — Ordinal reference list not knowable for 5 of 13 deposits.** `.bib` but no `.bbl`:
`2607.16203v1` (two bibs), `2602.00217v3`, `2508.06105v2` (`logicrag.tex:653`), `2607.28881v2`,
`2506.07658v3`. Ordinal order is a bst program output (`unsrt` = citation order, `plain` = alpha).
Proposed `ordinal: null` + knowability qualifier.
→ **RESOLVED-DIFFERENTLY.** The ordinal became a TeXdig-owned quantity instead of a recovered one:
always normalized, 1-based, first-citation-appearance (`README.md:100-102`;
`contracts.ts:202` `OrdinalBasis`, `:206-222` `ReferenceItem`). Nothing is null because nothing is
being recovered. `ordinalBasis` records `appearance` / `list-order-fallback` / `list-appended`.

**G2 — The bibliography is a carrier, not a file role.** `2605.01664v1` has neither `.bib` nor
`.bbl`; `References.tex:1` is `\begin{thebibliography}{99}`, pulled by
`IEEE_Conference_main.tex:86`. `Proco.bbl:1` is the same carrier in a differently-named file.
→ **LANDED.** `EnvironmentRole` gains `bibliography` with the rule stated inline —
"the bibliography is a carrier the census finds, not a file role" (`types.ts:148-152`). `README.md:96-97`
lists inline `thebibliography` as a first-class reference witness.

**G3 — `\def`-defined reference macros make a vocabulary-driven pointer census blind.**
`2506.07658v3/math_commands.tex` and `2602.00217v3/math_commands.tex` `\def` `\figref`, `\secref`,
`\algref`, `\chapref`, and at `:35` **redefine `\eqref`**. A fixed cite/ref/eqref/cref vocabulary
misses every `\secref{...}` site and mis-attributes `\eqref`.
→ **LANDED.** Non-elaborable definitions now carry body extents (`types.ts:200-205`;
`contracts.ts:176-178` `bodySpan`/`bodyText`), and pointer-hood is "derived transitively from macro
definition bodies, not from a fixed vocabulary" (`contracts.ts:242-246`; `README.md:69`).

**G4 — `\newtheorem`/`\newenvironment` had no census kind, so "theorem-like" zones had no
provenance.** `2607.28881v2/Fragility_of_Value...tex:19-23` declares five theorem environments;
identifying them by hardcoded name list violates the no-magic-string doctrine.
→ **LANDED.** New census kind `environment-definition` with
`mechanism: newtheorem | newenvironment | newfloat` and `counterRaw` (`types.ts:209-218`), feeding
`ZoneKind` `theorem-like` (`contracts.ts:118`).

**G5 — Control-sequence names outside `[A-Za-z]+`.** `math_commands.tex:60` `\def\1{\bm{1}}`;
`\DeclareMathOperator*` (`2607.28881v2:25`); `@`-names under `\makeatletter`. Span ids survive;
name-keyed joins (`definedName`, closure keys, binding verdicts) do not.
→ **LANDED** as a declared rule: csnames "recorded byte-exact and case-sensitive… must survive as
join keys" (`types.ts:190-195`). Residual **ACCEPTED-PENDING-ENGINE**: the lexer's tokenization
boundary (`\1` vs `\1␣`) is not written down anywhere yet.

**G6 — An "included" file can be preamble; macros had no place in the order space.**
`math_commands.tex:3` is `\usepackage{...}` inside an `\input`ed file.
→ Order space **LANDED**: one shared `seq` covers walk nodes, zones, **macro records**, and pointer
sites, and macro shadowing resolves on the same scale (`contracts.ts:58-68`, `MacroRecord.seq :172`;
`README.md:91-92`). Preamble-in-include needs no contract change but is
**ACCEPTED-PENDING-ENGINE**: the traversal must not assume `documentclass`/`begin-document` live in
the entrypoint.

**G7 — In-tree unparsed `.sty`/`.cls` poison the closure verdict.** `2602.00217v3` ships
`natbib.sty`+`icml2026.sty`; `2506.05725v1`/`2606.28796v1` ship `acl.sty`; four deposits ship
`llncs.cls`. Calling `\citep` "unresolved" is false — it binds in-tree, in a file stage 1 chose not
to parse.
→ **LANDED.** `NameBinding = "bound" | "bound-out-of-scope" | "unresolved"` (`contracts.ts:126`),
with the rationale recorded at `:120-125`.

**G8 — Case-insensitive include resolution forks the join key.** `IEEE_Conference_main.tex:80` is
`\input{Introduction}`; the file is `introduction.tex`. Accepted by the deposit
(`CONVENTION.md:85`), i.e. resolved on a case-insensitive filesystem. That paper does not build on
Linux.
→ **LANDED.** `census/include-case-mismatch` diagnostic, with the canonicalization rule (on-disk
casing wins) and the "a finding, not something to smooth over" framing (`types.ts:353-354`).

**G9 — Deposits with no LaTeX tree.** `2410.02707v4`, `2607.09648v1`, `2607.11883v1` hold only a
`.pdf` — no `-tex/`, no `article.json`.
→ **LANDED.** "PDF-only deposits are refused at planning, not failed at the worker"
(`README.md:111-112`).

**G10 — `\bibliographystyle` absent from `IncludeDirective`,** though it names the ordering policy
and is the only in-document link to an in-tree `.bst` (`Proco.tex:587`; `2502.19413v2/main.tex:96`,
*after* `\bibliography{main}` at `:95`).
→ **LANDED.** `IncludeDirective` gains `bibliographystyle`, framed as "a resource tie, not a file
inclusion", with the source-order caveat (`types.ts:162-172`); `README.md:97` lists it as an ordering
witness. Residual wording: `SourceRole`'s `bibliography-style` comment still reads "already baked
into any `.bbl`" (`types.ts:49`), which is the rationale G1 partly displaced.

**G11 — The handoff tier was not self-contained.** Closure as macro-ids resolving to slice
*references* means a consumer holding only the artifacts container can render nothing.
→ **RESOLVED-DIFFERENTLY.** Inline slices were already the intent and are now stated as the tier's
defining property: "every row downstream interprets carries its exact source slice inline… the
deposit tree is evidence substrate, not part of the contract" (`README.md:59-61`;
`contracts.ts:2-5`). Concretely `Zone.text` (`:150-151`), `MacroRecord.bodyText` (`:178`),
`ReferenceItem.formattedText` (`:221`), `FrontmatterRecord.text` (`:270`).

## 2. Contradictions

**C1 — Pipeline order.** `notes.md:21-23` built the include graph *before* parsing; `README.md`
stratified comments first. The corpus settles it: `logicrag.tex:656` is
`% \input{reproducibilityCheckList}` — a commented include of a file absent from the tree, which a
pre-parse graph builder would report as `census/unresolved-include`.
→ **LANDED.** "comment/verbatim stratification precedes **everything** — including include-graph
construction… This supersedes the parse-after-graph ordering in the early notes"
(`README.md:49-52`), with the corpus case cited in place.

**C2 — KaTeX cannot express what the closure contains.** No optional-argument defaults
(`\newcommand{\pair}[2][d]`, `sol-latex-extraction-part-1.md:134`), no xparse signatures — so
validation would report validator limits as document defects.
→ **LANDED.** `ValidationStatus` gains `unsupported-by-validator` (`contracts.ts:135`), alongside
instrument + version on `ZoneValidation` (`:137-142`).

**C3 — `references.jsonl` is interpretation; stage 1 declares itself mechanical**
(`README.md:5-6`).
→ **RESOLVED-DIFFERENTLY.** Not by moving the store to cut 2, but by making the reconciliation
rule-registered and deterministic: one canonical item per resolved identity, per-field provenance
"under a registered merge policy", disagreements as findings (`README.md:94-104`;
`contracts.ts:204`, `:218-219`). The genuinely interpretive residue is named and exiled: "Structuring
formatted `.bbl` text into fields when no `.bib` exists is interpretation and stays downstream"
(`README.md:103-104`).

**C4 — `frontmatter.json` had no span addressing,** violating gate 3; and `\author` as a parsed list
is interpretation. The abstract may live in another file (`2502.19413v2/main.tex:86`
`\input{sections/abstract}`).
→ **LANDED.** Store is now `frontmatter.jsonl` with span-anchored rows
(`contracts.ts:264-272`); gate 3 says so explicitly (`README.md:27-28`); the author blob stays one
row and splitting it is downstream (`contracts.ts:259-263`).

**C5 — "attribute-compatible but unregistered" reproduces the refgraph situation** the primitive's
own description criticizes (`graph.primitive.schema.json:5`).
→ **ACCEPTED-PENDING-ENGINE.** Renamed `graph.jsonl`; both-ends-anchored, address-valued, "to be
registered against the primitive, not left as an unregistered convention" (`contracts.ts:278-287`;
`README.md:71`), with the registry named as the promotion destination and golden-fixture
`validate-json` as the DTO↔schema tie (`README.md:79-82`). Registration itself has not happened.

**C6 — Container granularity** disagreed between `README.md` (per document) and
`src/batch-adapters/README.md:62` (per job).
→ **LANDED.** "one document per batch-executor job, the job container is the document container
(`Writes` root)" (`README.md:56-57`).

## 3. Risks

**R1 — Inline masking tokens are the mechanism the reboot was called to kill**
(`sol-notes-note-quite-right.md:12`; `src/shared/md-sentinels.ps1:22`, where a leaked `@@LMATH0@@`
is a registered shipped-defect class).
→ **RESOLVED-DIFFERENTLY / adopted wholesale.** The array form is now the *only* stored form:
`ContentPart = { text } | { ref }` (`contracts.ts:70-71`), and masked text is demoted to a debug
rendering, "never an artifact", with the shipped-defect precedent recorded as the reason
(`README.md:88-90`; `contracts.ts:16-17`).

**R2 — `seq` is a derived integer in a store of span addresses;** re-resolving an include shifts
every seq while no id changes.
→ **LANDED.** Ordering is made reconstructible without trusting the integer: rows carry traversal
context, `WalkNode.includeChain` on every variant (`contracts.ts:65-67`, `:88`, `:96`, `:105`).

**R3 — Coverage gate over unparsed and binary files** (`llncs.cls` would drown the residue signal;
"UTF-16 unit" is undefined for `2502.19413v2/supplementary/heidrich2023legal.pdf`).
→ **LANDED.** Gate 1 now reads "every UTF-16 unit of every **parsed** source file"; unparsed
inventoried files "sit outside this gate: they are sha-attested in `sources.jsonl`, nothing more"
(`README.md:19-22`).

**R4 — Verdicts computed from incomplete inputs, shipped as booleans** that silently improve later.
→ **LANDED.** `Verdict { verdict: boolean | null; reason; version }` (`contracts.ts:128-133`),
carried by `Zone.isolable` (`:160`).

**R5 — No document-independent key for an identical definition.**
`2506.07658v3/math_commands.tex` and `2602.00217v3/math_commands.tex` are the same file in two
deposits (388 definition sites each) — the exact input the persistent unique-specimen store wants
(`preliminary_research.txt:12-16`).
→ **LANDED.** `MacroRecord.fingerprint`, sha256 of the normalized body, "stamped at emission because
it is impossible to backfill consistently later" (`contracts.ts:182-187`).

**R6 — Zone ids are tree-scoped, so identity does not survive across paper versions;** the
benchmark/challenge-library lane will want cross-version identity.
→ **OPEN.** `MacroRecord.fingerprint` gives definitions a document-independent key, but zones have
no analogue and no out-of-scope statement was written.

## 4. Questions — answers as landed

| # | Question | Answer | Where |
| --- | --- | --- | --- |
| Q1 | With no `.bbl`, is `ordinal` null or the store absent? | Neither — ordinal is always normalized and TeXdig-owned | `README.md:100-102` |
| Q2 | Is `thebibliography` a carrier found wherever it occurs? | Yes; `EnvironmentRole.bibliography` | `types.ts:148-152` |
| Q3 | Body spans for `\def`/`\let`? | Yes — extent knowable when expansion is not | `types.ts:200-205` |
| Q4 | Where do `\newtheorem`/`\newenvironment` live? | New census kind `environment-definition` | `types.ts:209-218` |
| Q5 | Third binding state for in-tree unparsed `.sty`/`.cls`? | `bound-out-of-scope` | `contracts.ts:126` |
| Q6 | Do macros get `seq`, or a second scale? | One shared scale; shadowing resolves on it | `contracts.ts:58-68` |
| Q7 | Does a consumer need the deposit tree? | No — inline slices; tree is evidence substrate | `README.md:59-61` |
| Q8 | Are unparsed/binary files inside gate 1? | Outside; sha-attested only | `README.md:19-22` |
| Q9 | Is the graph store registered? | To be registered against the primitive — **not yet done** | `contracts.ts:283` |
| Q10 | Which of {reference reconciliation, author split, isolability} are stage 1? | References yes (registered merge policy); author split downstream; isolability filled in cut 2 | `README.md:94-104`, `contracts.ts:259-263`, `README.md:108-109` |

## 5. Naming

Candidates offered for the then-unnamed capsules store, ranked: `segments.jsonl` (recommended —
store name and join noun agree), `carriers.jsonl` (house word, but already means *delimiter form* at
`types.ts:138`), `seals.jsonl`, `excerpts.jsonl`, `unpackables.jsonl`. A separate flag: naming the
traversal store `manuscript.jsonl` would collide with the *latent manuscript* doctrine already live
in the lane; `traversal.jsonl` suggested.

→ **RESOLVED-DIFFERENTLY.** Owner chose **`zones.jsonl`** and **`walk.jsonl`** — neither from the
candidate list. The manuscript-collision flag was accepted and acted on (`walk.jsonl` replaced
`manuscript.jsonl`); `carriers` was correctly declined on the overload the review itself named. Also
renamed since: "protograph" → `graph.jsonl`, handoff tier → **contract tier**, `core/handoff.ts` →
`core/contracts.ts`.

---

## Still open

1. **R6 — cross-version zone identity.** Definitions got a `fingerprint`; zones did not, and no
   out-of-scope statement exists. Decide before the benchmark/challenge-library lane needs it.
2. **C5 / Q9 — `graph.jsonl` registration.** Accepted in principle and stated as intent
   (`contracts.ts:283`), not executed. Until a schema with an `$id` `$ref`s
   `graph-primitive/0.1`, the store is exactly the unregistered convention the primitive's
   description warns about (`graph.primitive.schema.json:5`).
3. **DTO ↔ registry conformance has no fixtures.** `README.md:79-82` names golden-fixture
   `validate-json` as the mechanism that keeps `core/contracts.ts` and the registered schemas in
   agreement. Neither the schemas nor the fixtures exist yet, so nothing currently detects drift.
4. **G5 residual — csname tokenization boundary.** Byte-exact recording is declared
   (`types.ts:190-195`); the lexer rule separating `\1` from `\1␣`, and the treatment of `@`-names
   across `\makeatletter`, is not.
5. **G6 residual — preamble material in included files.** No contract change needed, but nothing
   records the constraint that envelope markers may be split across files; an engine that assumes
   `documentclass`/`begin-document` in the entrypoint will pass tests on most of the corpus and fail
   on `2506.07658v3` / `2602.00217v3`.
6. **G10 residual — stale rationale.** `types.ts:49` still justifies not parsing `.bst` with
   "already baked into any `.bbl`", which no longer holds for the five bib-without-bbl deposits.
   The role is right; the sentence is now half-true.
