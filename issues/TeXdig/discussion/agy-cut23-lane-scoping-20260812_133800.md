# agy — cut-2/3 lane scoping and plan cross-examination (20260812_133800)

Scoping pass over the three deferred contract-tier lanes (`zones.jsonl`, `pointers.jsonl`,
`walk.jsonl`) against the landed cut-1/cut-2-slice implementation. Canon read first
([src/TeXdig/README.md](../../../src/TeXdig/README.md),
[core/contracts.ts](../../../src/TeXdig/core/contracts.ts),
[core/types.ts](../../../src/TeXdig/core/types.ts),
[brief](../briefs/engine-cut1-census-20260811_021819.md)), then current truth in
`src/TeXdig/census/`, `compile/`, `elaborate/`, `cli/`.

Evidence sampled from `artifacts/texdig-runs/batch-20260812_132923/texdig-jobs/` — 34 job
containers, the full ph-zigzag + kisungyou corpus. Corpus source spot-checks from
`ingestion/gauntlet/ph-zigzag/2403.08110v4/2403.08110v4-tex/`. Artifact citations are given as
`{slug}/{store}` plus the row's own address, since JSONL rows have no line identity worth citing.

Owner-decision items are tagged **[OWNER]** and are surfaced, not decided.

---

## 0. Corpus baseline (the numbers the three lanes have to live with)

Aggregated across all 34 job containers:

| Signal | Count |
| --- | --- |
| `macro-invocation` named `label` / `ref` / `cite` / `citep` / `eqref` | 1653 / 1473 / 961 / 547 / 435 |
| `Cref` / `citet` / `href` / `cref` / `autocite` / `pageref` / `nameref` | 105 / 45 / 42 / 32 / 11 / 3 / 1 |
| `cite`/`citep` sites carrying **more than one** argument span | 28 |
| `\newtheorem` environment-definitions (distinct names, incl. starred) | 30+ names; `theorem` 33, `proposition` 33, `corollary` 33, `lemma` 31, `definition` 30 |
| `environment` rows with `role:"generic"` that are theorem-like by `\newtheorem` | `proof` 152, `definition` 108, `theorem` 106, `proposition` 106, `lemma` 36 … |
| `tikzpicture` / `tikzcd` environments | 50 / 33 |
| `figure` / `table` / `algorithm` / `figure*` / `table*` (role `float`) | 223 / 56 / 22 / 13 / 4 |
| Sources with `role:"class-or-style"` | 12 files across **7 of 34** papers |
| Sources with `role:"unreachable-tex"` | 3 |
| `expansion.jsonl` rows, by status | 16471 — **all** `expanded`, 0 partial, 0 non-converging |
| Diagnostics: `span-synthesized` / `witness-disagreement` / `configured-gap` | 46509 / 673 / 34 (one per paper) |

The 12 in-tree binder files are: `acl2015.sty`, `arxiv.sty`, `jmlr2e.sty`, `kbordermatrix.sty`,
`my.sty`, `picins.sty` ×2, `quiver.sty`, `rmj-public.cls`, `sn-jnl.cls`, `svjour3.cls`. These are
the entire `bound-out-of-scope` population in this corpus.

---

## 1. `zones.jsonl` — compiled closure-sealed units

### 1.1 Inputs available today

- `entities.jsonl`: `environment` (with `role`), `math` (with `carrier`), `verbatim-inline`,
  `environment-definition` (`newtheorem`/`newenvironment`/`newfloat`/`configured`),
  `comment`. Environment and math are already cross-linked as overlays over one extent
  (`census/reconcile.ts:494-507`, `math.fenceEntityId` → the fence entity).
- `macros.jsonl`: `def:` rows with `deps` (def: ids), `seq`, `bodyText`, `elaborable`
  (`compile/macros.ts:91-103`).
- `expansion.jsonl`: `exp:` rows with `sourceSlice` + `expandedText` per invocation site.
- Validators pinned and present: `packages/node/node_modules/katex`,
  `packages/node/node_modules/node-tikzjax`.

### 1.2 Which census entities become zones

Mapping to `ZoneKind` (`core/contracts.ts:114-120`):

| ZoneKind | Basis available now | Status |
| --- | --- | --- |
| `math-inline` / `math-display` | `kind:"math"` entity + `mode` + `carrier` | **clean** |
| `verbatim` | `environment` role `verbatim` + `verbatim-inline` + verbatim strata | **clean** |
| `float` | `environment` role `float` | **clean for the 5 known names** |
| `theorem-like` | in-document `\newtheorem` names | **partial — see 1.3** |
| `diagram` | nothing derivable | **blocked — see 1.3** |

### 1.3 Three classifier gaps that hit zone kinds directly

**(a) Math-role vocabulary is short.** `KNOWN_MATH_ENVS` (`census/reconcile.ts:49-52`) omits
environments that appear in the corpus and are unambiguously math: `cases` 29, `aligned` 22,
`split` 18, `pmatrix` 17, `array` 15, `subequations` 5, `alignat*` 5, `smallmatrix`. Of these,
`alignat*` and `subequations` are *top-level* carriers, not interior structure — they will be
missed as display-math zones entirely, not merely mis-nested. The rest are interior and only
matter for `context.environments`. This is a small-vocabulary extension, not a heuristic, so it
sits inside doctrine — but it is a census change, not a compile-tier one.

**(b) `theorem-like` is derivable but not uniformly.** In-document `\newtheorem` gives a clean,
non-magic-string derivation for `theorem`/`lemma`/`proposition`/… (33 papers define them). But
`proof` — 152 occurrences, the single most common theorem-like environment in the corpus — is
never `\newtheorem`'d; it comes from `amsthm`. It surfaces as an `environment-definition` with
`mechanism:"configured"` in only **4 of 34** papers, and those 4 get it from the `amsart` class
record, not from `amsthm` (which has no ctan record at all — see 1.5). So a configured-channel
basis for `theorem-like` would classify the *same environment* differently in 4 papers than in
the other 30.

**[OWNER] Zone-kind uniformity.** Either (i) `theorem-like` is derived **only** from in-document
`\newtheorem`/`\newenvironment`, and package-provided theorem environments stay
`kind:"generic"`-equivalent with a recorded reason (uniform, honest, loses `proof`); or (ii) the
ctan curation queue is closed for `amsthm`/`amsmath` first and the configured channel becomes the
basis (uniform only after curation). Option (i) is the only one available without new
configuration work; it should say so in the row rather than silently under-classifying.

**(c) `diagram` has no basis at all.** 83 tikz environments (`tikzpicture` 50, `tikzcd` 33) all
carry `role:"generic"`. `tikzcd` comes from `tikz-cd`, listed as unresolved in every
`configured-gap` diagnostic that mentions it (e.g. `2111.15058v3/diagnostics.jsonl`,
`census/configured-gap`). `quiver.sty` — an in-tree binder in `2403.08110v4` — is a `tikz-cd`
wrapper whose payload is `\tikzset` styling; its only macro definition is `\def\pv`
(`quiver.sty:30`). So diagram-hood is currently only nameable by environment name.

**[OWNER] Diagram basis.** `tikzpicture`/`tikzcd` as a `KNOWN_DIAGRAM_ENVS` small vocabulary is
the consistent move with the existing float/math/verbatim classifiers, and it is what the
encode-first doctrine's bare-arrow lexicon needs as an entry point. It is still a name list. The
alternative — deriving diagram-hood from a `tikz`/`tikz-cd` package summons — is document-level,
not per-site, and would sweep in non-diagram tikz usage. Naming the vocabulary is recommended;
the decision is whether that vocabulary lives in `reconcile.ts` beside the other three or in a
compile-tier zone classifier.

### 1.4 Are the closure joins expressible with the landed ids?

Partially. Three findings, in descending severity.

**(1) Environment definitions have no id in any store — theorem-like and diagram closure is
inexpressible today.** `Zone.closure` is typed `string[]` of `def:` ids
(`core/contracts.ts:159-160`), and `compile/macros.ts:28-30` filters strictly to
`kind === "macro-definition"`. `environment-definition` entities exist in `entities.jsonl` (they
have `ent:` ids) but never receive a `def:` id and never reach `macros.jsonl`. A `\begin{lemma}`
zone therefore cannot cite what defines it, and neither can a `tikzcd` zone. Every math /
verbatim / float zone is fine; every theorem-like and diagram zone is not.

**[OWNER] Where environment definitions live.** Either (i) `macros.jsonl` admits
environment-definition rows under a `defines: "macro" | "environment"` discriminator on
`MacroRecord` (one store, one id class, `closure` unchanged); or (ii) a new id class `env:` plus
a store, and `Zone.closure` widens to `(def:|env:)[]`. (i) is the smaller contract growth and
keeps `closure` a homogeneous join column; (ii) is cleaner if environment definitions later need
fields macros do not have (`counterRaw` already exists on the census entity and has nowhere to go).

**(2) `\let` alias chains are not followable from the store.** `MacroRecord` has no alias-target
field (`core/contracts.ts:172-191`). `let`-dialect rows carry `bodySpan`/`bodyText` (the target
token), and `elaborate/expand.ts:151-163` reconstructs the target by string-slicing that body and
walking chains at `:257-279`. A zone-closure consumer reading only `macros.jsonl` cannot follow
`\let\a\b` to `\b`'s definition — it would have to re-implement the slice-and-strip.

**[OWNER] `MacroRecord.aliasTarget?: string`** (a `def:` id, resolved at the alias's own seq).
This is the one field that makes `deps` a complete graph rather than a graph with silent holes.

**(3) `deps` silently drops unresolved names.** `compile/macros.ts:78-84` pushes a dep only when
the body name resolves to an in-document definition. Everything else — kernel names, package
names, in-tree-`.sty` names — vanishes. `deps` is therefore correct as *support closure over
in-document definitions* (which is what it is documented as) but is **not** a usable source for
`Zone.names`, which must list *every* direct control-sequence name with its verdict. Zones must
re-scan `bodyText`/zone slices lexically rather than reading `deps`. Worth stating in the zone
lane's own comments so the next reader does not mistake `deps` for the name set.

### 1.5 `bound-out-of-scope` — where the evidence comes from

This is the question the assignment flags, and it is the one where the tempting answer is wrong.

The state was coined precisely so that a name binding in an unparsed in-tree `.sty`/`.cls` is not
called `unresolved`, because that would poison isolability for natbib/acl-style papers
(`core/contracts.ts:122-128`). So the verdict needs **per-name** evidence. Four candidate bases
exist; only three are honest.

**B1 — in-tree binder register (proposed primary).** Run the existing lexical scanner
(`census/scan-latex.ts`) over `role:"class-or-style"` sources in a *definition-name-only* mode,
harvesting the defined csname and its span from `\newcommand`/`\providecommand`/`\def`/
`\DeclareRobustCommand`/`\newenvironment`/`\newtheorem` heads. Output is a name → (sourceId, span)
register — not entities, not claims, not coverage.

  Verified viable on the corpus: `kbordermatrix.sty` yields `@xarraycr` (`:12`), `kbldelim`
  (`:54`), `kbrdelim` (`:55`), `kbrowstyle` (`:57`), `kbcolstyle` (`:58`), `kbordermatrix`
  (`:73`), `@kbrowstyle` (`:90`), `cr` (`:95`); `quiver.sty` yields `pv` (`:30`). Both are in-tree
  binders for `2403.08110v4`, and `\kbordermatrix` is used in that paper's math. This is exactly
  the population the state exists for, and the register gives it a citable `path:line`.

  **[OWNER] Doctrine check.** README:21-22 says unparsed inventoried files are "sha-attested in
  `sources.jsonl`, nothing more." A binder register is *more*. The argument that it does not
  breach the gate: it mints no entity, claims no span, and enters no coverage account — gate 1
  explicitly scopes to *parsed* sources, and this is a lexical name index over unparsed ones. But
  "unparsed means unparsed" is a defensible reading too, and this needs an explicit ruling before
  it is built, not after. If the ruling is no, `bound-out-of-scope` loses its per-name basis for
  in-tree binders and falls back to B4, which is not per-name at all.

**B2 — configured/ctan declaration (already landed).** A name with a `configured`-dialect
definition row is bound by a named package at a named summoning site
(`census/configured.ts:96-118`). Target id is `def:configured/{package}:{name}`. Available now,
zero new work.

**B3 — kernel baseline.** `deps.ctan.macroInfo["latex2e"]` exists in the pin (confirmed:
`packages/node/node_modules/@unified-latex/unified-latex-ctan/index.cjs` requires
`./package/latex2e/index.cjs`). `census/configured.ts:53` deliberately skips `latex2e` as a
*summons* — correct for minting, since the document never asked for it — but it remains a
per-name registry of kernel names. A read-only lookup for verdict attribution mints nothing and
breaks no rule. Without it, `\frac`, `\textbf`, `\item` and every other kernel name lands in
`unresolved`, which is the same poisoning the state was invented to prevent, one layer down.

**B4 — "the document summons packages we have no record for" (recommended REJECT).** Every one of
the 34 papers carries a `census/configured-gap` diagnostic. The pinned ctan set is 18 packages
(`amsart`, `beamer`, `cleveref`, `exam`, `geometry`, `hyperref`, `latex2e`, `makeidx`,
`mathtools`, `multicol`, `nicematrix`, `systeme`, `xparse`, `tikz`, `xcolor`, `listings`,
`minted`, `enumerate`) — it does **not** include `amsmath`, `amsthm`, `graphicx`, `amssymb`,
`natbib`, or `biblatex`. So "this document summons unrecorded packages" is true of 100% of the
corpus and tells you nothing about any individual name. Using it as a basis would classify a
typo'd `\lable` identically to `\usepackage{amsmath}`'s `\dfrac`. Names with no B1/B2/B3 hit
should stay `unresolved`, with the reason string naming the configured gap as the *likely*
explanation.

**Proposed state machine** (all three verdicts carry `target`, `NameBinding` already allows it at
`core/contracts.ts:158`):

```
bound              ← governing def: row in macros.jsonl at the site's seq (incl. \let chains)
bound-out-of-scope ← B1 hit  → target "src:{path}" (+ span in the register)
                   | B2 hit  → target "def:configured/{pkg}:{name}"
                   | B3 hit  → target "kernel:latex2e"
unresolved         ← none of the above; reason names the configured-gap state
```

**[OWNER] One state or three?** Collapsing B1/B2/B3 into one `bound-out-of-scope` makes
isolability underivable from the binding alone: a B3 kernel name *is* isolable under katex (katex
implements the kernel), a B2 `mathtools` name usually is, and a B1 in-tree name never is without
parsing the binder. Either the state splits, or `NameBinding` grows a sibling `bindingBasis:
"in-tree-binder" | "package-record" | "kernel"` field. Recommending the field over the split —
three states remain three, and the basis becomes a first-class column for the isolability rule.

### 1.6 Isolability and validation

`Verdict` is three-state by design (`core/contracts.ts:130-135`) — use it. Proposed rule:

- `verdict: true` — every name in `Zone.names` is `bound` or basis `kernel`, and every `def:` in
  `closure` is present with a body. Reason cites the closure size.
- `verdict: null` — any name is `bound-out-of-scope` with basis `in-tree-binder` or
  `package-record`, or any closure member is non-`elaborable`. This is "stage-1 evidence cannot
  decide", which is the truth, and it is what `null` is for.
- `verdict: false` — reserved for a positively-witnessed failure (a name that is `unresolved`
  *and* whose absence is confirmed, or a closure cycle). Do not use `false` as a default; a bare
  negative that "silently improves later" is the failure mode the three-state comment names.

Validation (`ZoneValidation`, `core/contracts.ts:137-144`): katex for math zones, node-tikzjax for
diagram zones, `skipped` for verbatim/float/theorem-like, `unsupported-by-validator` where the
instrument declines a construct. Note `node-tikzjax` bundles a WASM TeX engine — 83 diagram zones
across 34 papers is tolerable, but it is seconds-per-zone, not milliseconds; it belongs behind an
explicit switch, not in the default worker path. **[OWNER]** whether cut-2 emits `skipped` for all
validation and cut-3 turns the instruments on, or whether katex (cheap, synchronous) runs from
cut 2.

### 1.7 First-cut cutline for zones

**In:** `math-inline`, `math-display`, `verbatim`, `float` zones; `names[]` with the full
three-basis binding verdict (B1+B2+B3); `closure` over `macros.jsonl` `deps`; `isolable` as
`true`/`null`; `validation.status: "skipped"` unless katex is ruled in; `context.environments`
from the enclosing environment entities.

**Out (declared in `summary.stores`, not silently absent):** `theorem-like` and `diagram` zones,
pending the env-definition-id and diagram-vocabulary decisions; `Zone.content` ContentPart arrays
for composite zones (needs the walk lane's content machinery — see 3.3).

---

## 2. `pointers.jsonl` — label declarations and pointer sites

### 2.1 The base-case problem, stated plainly

The doctrine — "pointer-hood derived transitively from definition bodies, never a fixed
vocabulary" (README:69, `core/contracts.ts:243-247`) — needs a base case, and the base case cannot
itself be derived. In this corpus `\ref` is invoked 1473 times and **defined zero times**; the same
holds for `\cite`, `\eqref`, `\Cref`. There is no in-document definition body to derive from
because the pointer primitives are kernel- and package-bound.

Read the doctrine as forbidding a fixed vocabulary as the *answer*, not as the *seed*: a declared
seed set plus transitive closure over in-document definition bodies. That is what actually
catches `\def\secref` and a redefined `\eqref`, and a pure-derivation reading catches nothing.

**[OWNER] Where the seed lives.** Candidates: a registered const beside `DiagnosticCodes`
(`core/types.ts:351`), a lane-config surface alongside the configured channel, or derivation from
the `cleveref`/`hyperref` ctan records (both are pinned, so `\cref`/`\Cref`/`\autoref`/`\nameref`
come free — but `\ref`/`\label` are `latex2e` and `\cite`/`\citep` are `natbib`, which is not
pinned). Recommending a registered const: it is small, it is auditable, and the ctan route is
holed exactly where the corpus is densest (961 `\cite` + 547 `\citep`).

### 2.2 Transitive derivation — and the corpus's counter-examples

The step: a definition is pointer-forming when its body lexically contains a seed name or an
already-derived pointer name. Bodies are inline in `macros.jsonl` (`bodyText`,
`compile/macros.ts:57-60`), so this is a fixpoint over that store.

**Do not ride `deps` for this.** As noted in 1.4(3), `deps` only contains names that resolve to
in-document definitions, so `\ref` inside a body never appears there. Re-scan `bodyText` with
`scanLatex` at compile time — bodyText is inline in the row, so this costs nothing and needs no
contract growth.

Corpus checks, both of which the derivation gets right and a name-based rule gets wrong:

- **False positives a name rule would produce.** `\theoremofref` (1 site) and `\propositionofref`
  (1 site) look maximally ref-shaped. Their bodies are `#1` and empty
  (`2403.08110v4/macros.jsonl`, `def:JACT.tex:4989-5021` bodyText `#1`;
  `def:JACT.tex:4677-4707` no bodySpan) — they are *title-text holders* for
  `\newtheorem*{ztheoremof}{Theorem \theoremofref}` (`JACT.tex`, definition block around offset
  4600-5100). Not pointers. Also present and equally misleading: `\labelsep` (6), `\reflectbox`
  (2), `\refsection`/`\endrefsection`, `\titlelabel`.
- **A third class the derivation surfaces and the contract has no room for.** `\descitem` (14
  sites) has body `\stepcounter{Item}\refstepcounter{desccounter}\item[#1 \Alph{desccounter} #2]`
  (`2112.02352v2/macros.jsonl`, `def:ArXiv_zigzag_update.tex:13726-13830`). `\refstepcounter`
  makes it **anchor-target-forming** — it sets what a subsequent `\label` attaches to. It is
  neither a `label-declaration` nor a `pointer-site`.

**[OWNER] Anchor-target-forming macros.** `PointerRecord` is a two-member union
(`core/contracts.ts:230-255`). Options: (i) ignore them in cut 2 and accept that `attachesTo` for
labels following a `\descitem` will be wrong or absent; (ii) add a third member
(`kind: "anchor-declaration"`) carrying the counter name; (iii) fold them into
`label-declaration` with a discriminator. The corpus population is small (14 sites, 1 paper) but
the failure is silent, which is the part that matters.

### 2.3 Key extraction — one landed defect and a cheap fix

`\label`/`\ref`/`\cite` invocation entities **do** carry `argumentSpans` (verified:
`2112.02352v2/entities.jsonl`, `"name":"label"` rows carry
`argumentSpans:[{sourceId:"ArXiv_zigzag_update.tex",startUtf16:15689,endUtf16:15698}]`). Keys are
a raw-stream slice of that span. Good.

But `reconcile.ts:454` maps `ps.args.map(a => a.span)` — dropping the `bracketed` flag that
`ParserArgSpan` carries (`census/parse-latex.ts:658`, `isBracketed`). `argumentSpans` is therefore
a positional list with no optional/mandatory discriminator. **28 `cite`/`citep` sites in the
corpus carry more than one argument span**, e.g. `\cite[Theorem 1.11]{Kirilov}`
(`JACT.tex:502`). Naive `argumentSpans[0]` yields the key `Theorem 1.11`.

Two fixes:
- **Cheap, no contract change:** at pointer-compile time, test `rawText[span.startUtf16 - 1]` for
  `{` vs `[`. The raw stream is evidence and the span is exact, so this is a legitimate
  re-derivation rather than a guess.
- **Durable, contract growth:** `argumentSpans?: { span: SourceSpan; bracketed: boolean }[]` on
  the `macro-invocation` entity (`core/types.ts:197`) — restores information the census already
  had and threw away.

**[OWNER]** Recommend the cheap fix for the first cut and the durable one when
`entities.jsonl` next takes a schema bump; the cheap fix quietly re-derives something the census
knew, which is the kind of thing that should not become permanent.

### 2.4 Derived pointer sites resolve through `expansion.jsonl` — for free

For a derived name like a `\newcommand`-defined `\secref`, the expansion lane has already done the
work: the `exp:` row's `expandedText` contains the expanded `\ref{...}` with the site's own
argument substituted (`elaborate/expand.ts:348-374`). 16471 rows, all `status:"expanded"`. So the
pointer lane can extract derived keys by scanning `expandedText` and origin-chain the pointer site
to the `exp:` id.

Two caveats, both real:
- `\def`/`\let`-dialect definitions never enter the expansion table (`elaborate/expand.ts:147`,
  and the module header states this as design). A `\def\secref{\ref{sec:#1}}` — exactly the case
  the doctrine names — produces **no** `exp:` row. Derived pointer-hood must fall back to lexical
  body scan + raw-argument slice for those. Two mechanisms, and the second one is the one the
  doctrine was written about.
- The 100%-`expanded` rate is not evidence that expansion is complete over the document. The
  population is pre-filtered: only `newcommand`-family and `math-operator` definitions build table
  entries (`elaborate/expand.ts:205-240`), `paired-delimiter` is explicitly excluded, and sites
  with no governing definition return early (`:319-320`). A zone or pointer lane must not read
  "16471/16471 expanded" as "all names resolved".

### 2.5 `label-declaration.attachesTo` — the corpus says positional, not containment

From `JACT.tex` (`ph-zigzag/2403.08110v4/2403.08110v4-tex/JACT.tex`):

- `:463` — `\section{Preliminaries and idea} \label{sec:genrank}` — the label is **after** the
  sectioning command, outside its arguments. Containment fails; nearest-preceding-anchorable wins.
- `:470` — `\begin{definition}\label{def:intervals}` — label as first interior node. Containment
  wins.
- `:510` — `\label{thm:krull-schmidt}` at the **end** of a theorem body opened at `:503`.
  Containment wins; any "first child" rule fails.
- `:472`, `:473` — `\label{item:convexity}` and `\label{item:interval3}` mid-paragraph in
  hand-numbered prose items. Nothing anchorable contains or precedes them but the paragraph.

So `attachesTo` needs: innermost containing zone/walk node if one exists, else nearest preceding
anchorable object on the shared seq scale (sectioning marker, float, math carrier), else absent.
`attachesTo` is already optional (`core/contracts.ts:235`) — absent must stay a real answer, not
be filled with the paragraph as a consolation.

`:536` — `%\label{eq:interval-mod}`, a commented-out label inside an `equation*`. Stratification
removes it before the census, correctly, so it produces no declaration; any `\ref` to that key is
genuinely unresolved. That is the right outcome and it is worth a fixture.

### 2.6 The references seam

`pointerClass: "citation"` sites resolve to `refitem:` ids
(`core/contracts.ts:249-252`), and `references.jsonl` is deferred. The join column exists —
`ReferenceItem.citeKeys` (`core/contracts.ts:218`) — so pointers can land first and references can
backfill by key equality.

The trap: `unresolvedKeys` on a citation site before `references.jsonl` exists would assert
"this key does not resolve" when the truth is "the lane that would resolve it has not run". That
is the placeholder-direction error, inverted.

**[OWNER] How to represent not-yet-resolvable.** Candidates: a per-row
`resolution: "complete" | "pending-references"`; or leaving `resolvedTargets`/`unresolvedKeys`
both empty for citation sites and relying on `summary.stores.deferred` to carry the statement.
The first is self-describing per row (which the contract-tier self-containment principle argues
for); the second adds no field. Either is defensible; silently populating `unresolvedKeys` is not.

### 2.7 First-cut cutline for pointers

**In:** `label-declaration` rows with key + span + seq + `attachesTo` (rule of 2.5);
`pointer-site` rows for the declared seed vocabulary and for derived names via `macros.jsonl` body
fixpoint; `pointerClass` split (citation ← cite-family seed, internal-ref ← ref-family seed);
`internal-ref` resolution edges fully computed against the label register; bracketed-flag
re-derivation for key extraction.

**Out:** citation `resolvedTargets` (pending references.jsonl, represented per the 2.6 decision);
anchor-target-forming macros (pending the union decision); `\def`-dialect derived pointers if the
lexical fallback is deferred — but that should not be deferred, since it is the doctrine's
headline case.

---

## 3. `walk.jsonl` — traversal-serialized structure

### 3.1 What breaks first: paragraph segmentation has no surviving signal

`WalkNode` has a `paragraph` member (`core/contracts.ts:92-99`), so segmentation is required. The
signal exists in the parse and is destroyed before emission:

`census/parse-latex.ts:684-687` lumps `string`, `whitespace`, **and `parbreak`** into one
undifferentiated `textRuns` array. `cli/census.ts:269-274` then maps those to spine claims with
role `text-run` or `blank-run` decided by *trimmed length* — so a `parbreak` and a single
intra-sentence newline are both `blank-run`. `cli/census.ts:279-290` adds every `\s+` run in the
raw text as another `blank-run`. Nothing downstream can tell a paragraph boundary from a line wrap.

This is the single blocking item for the walk lane, and it is a **census-tier** change, not a
compile-tier one — which matters for sequencing.

Smallest honest fix: preserve the node type at `parse-latex.ts:684` (a parallel `parbreaks:
SourceSpan[]`, or a typed run array) and give spine claims a `parbreak` role at
`cli/census.ts:269`. `PillarClaim.role` is a free label by design (`core/types.ts:328-329`), so
this needs no type change at all.

**[OWNER]** Alternative: the walk lane re-parses and works from the AST directly, where `parbreak`
nodes are present. That is more faithful (paragraph structure is genuinely a tree property) but it
would be the **fourth** parse of every file — `discoverDefinitions` (`cli/census.ts:164`),
`parseLatexWitness` (`:241`), and `expandDocument` (`elaborate/expand.ts:199`) each parse
independently today. If walk reads the AST, threading one AST out of pass 2 rather than adding a
parse is the version worth building.

### 3.2 Is `compile/traversal.ts`'s seq assignment sufficient?

It is correct for what it currently orders. Three things break as walk/zones/pointers land.

**(1) seq exists only for addresses that were requested — and adding requesters renumbers
everything.** `buildTraversalOrder` takes `startsBySource` as a parameter
(`compile/traversal.ts:39-43`) and `cli/census.ts:368-374` populates it from **entity spans
only**. Paragraph starts are not entity addresses, so paragraphs have no seq until walk adds its
addresses to the input — and because seq is a dense counter (`traversal.ts:73-77, 83-86`),
adding any address shifts every subsequent value. The `seq: 653` on
`def:ArXiv_zigzag_update.tex:11180-11216` in today's `macros.jsonl` is not the value the same row
will carry once walk lands.

Ids are span-addressed, so nothing *breaks* — but seq is not comparable across cuts, and any
consumer that persisted a seq is holding a stale number.

**[OWNER] Seq stability policy.** Options: (i) declare seq run-local and non-comparable across
schema versions (cheapest; must be written into `contracts.ts` beside the `Seq` comment at
`:60-70`, which currently reads as though seq were a property of the document); (ii) collect all
object addresses — entities, walk nodes, zones, pointer sites — in one pass before assigning, so
the numbering is minted once when all lanes exist (correct, but means seq churns once more when
walk lands and then stops); (iii) a gapped/rational scale. Recommending (ii) with (i) written
down as the interim statement for cut 2.

**(2) seq covers LaTeX sources only.** `cli/census.ts:365-367` filters `startsBySource` to
`parsed && language === "latex"`. `.bib` entities — 42 `bib-entry` and 256 `bib-field` rows in
`2111.15058v3` alone — get no seq. `references.jsonl` needs an order for `firstCitationSeq`
(that one is a *citation site* seq, so it is fine) but bib-side ordering for
`listPosition`/`ordinalBasis` has no scale. The `leftover` branch (`traversal.ts:99-111`) exists
exactly for this and is currently unreachable for `.bib` because those addresses are never
submitted. Not a cut-2 blocker; a references-lane blocker worth recording now.

**(3) One traversal per file, but a file can be `\input` twice.** `traversal.ts:62` returns early
on revisit — correct as *reachability* semantics, wrong as *reading-order* semantics for walk,
where a twice-included file contributes its nodes twice and `WalkNode.includeChain`
(`core/contracts.ts:89-90`) is singular per node. The corpus has 25 `included` sources across 34
papers; whether any is included twice is unverified.

**Evidence that would settle it:** count distinct `(fromSourceId, toSourceId)` include edges vs
distinct `toSourceId` per job — a duplicate `toSourceId` from two sites is the case. Cheap to
compute from `entities.jsonl` `kind:"include"` rows with `resolvedSourceId`; worth doing before
walk is designed, since the answer changes whether `WalkNode` needs an occurrence discriminator.

### 3.3 ContentPart arrays

`ContentPart = { text } | { ref }` (`core/contracts.ts:73`) is the only stored form; masking is
banned (README:88-90). Construction is mechanical from the census: walk the ordered set of
claims/entities within a paragraph or title span, emit raw-slice `text` parts for the gaps and
`ref` parts for entity/zone/pointer ids at their spans. The inputs are all present — spans are
exact and non-overlapping within a paragraph once overlays are collapsed to their outermost
member.

One shape question: `Zone.content` (`core/contracts.ts:156`) uses the same array form for
composite zones (float caption, theorem body). That means the ContentPart builder is shared
between the walk and zone lanes and should live in one compile-tier module, not be written twice.
It also means `Zone.content` cannot land before the builder exists — hence its exclusion from the
zone first cut in 1.7.

Note the overlay collapse is not free: an `equation` environment yields both an `environment` and
a `math` entity over the identical extent (`census/reconcile.ts:494-507`). The builder must pick
one `ref` — presumably the zone id, since zones are what the contract tier exposes — rather than
emitting two refs for one span or nesting them.

### 3.4 Anchors → zones

`kind: "anchor"` carries `zone: string` (`core/contracts.ts:100-108`). Since zone ids are
span-addressed, an anchor is minted at the zone's own start with the same seq (the overlay case
`traversal.ts:10-12` explicitly sanctions). Direct join, no growth needed. The only question is
which zones get anchors: the type comment says "a zone that interrupts the prose flow (floats,
display math, verbatim blocks)" — inline math would then be a `ref` inside a paragraph's
ContentPart array rather than an anchor. That reading is consistent and should be stated in the
lane's comments so both kinds of reference are not emitted for the same zone.

### 3.5 Gate 4

"Every content-bearing claim reachable from `walk.jsonl`; orphans are diagnostics"
(README:29-31). Concretely: every `claims.jsonl` row with `pillar:"spine"` and role `text-run`
must be span-contained in some walk paragraph or section title. That is the same interval
arithmetic `census/coverage.ts` already does — reuse it rather than writing a second interval
engine.

Posture should match cut 1's: compute and report, do not require PASS (brief:62-64 — "they need
not PASS … their honest reporting is the point").

**[OWNER] Diagnostic registry growth.** Orphan reporting needs a registered code; free strings are
banned (`core/types.ts:349-352`). Candidates across all three lanes: `walk/orphan-claim`,
`zones/unresolved-name`, `pointers/unresolved-key`, `pointers/duplicate-label`. Note that two
registered codes are still unemitted and are cut-2 territory by the brief's own reckoning
(brief:118-119): `census/unknown-environment` and `census/opaque-region` — the zone lane is where
they finally fire.

### 3.6 First-cut cutline for walk

**In:** `section` nodes from `envelope-marker` entities with `marker:"section"` (`title` from
`titleSpan`, `reconcile.ts:413-415`; `level` from the command name; starred forms already
preserved at `:410-411`); `paragraph` nodes once the parbreak signal exists; `anchor` nodes for
float/display-math/verbatim zones; `includeChain` from the traversal's file stack; gate-4 orphan
audit reported, not enforced.

**Out:** paragraph nodes if the parbreak decision has not landed (in which case walk emits
sections + anchors only and says so in `summary.stores`); anchors for zone kinds the zone lane
deferred.

---

## 4. Cross-cutting findings

**F1 — Three copies of "governing definition at this seq".** `compile/macros.ts:78-82` and
`elaborate/expand.ts:246-255` each implement latest-definition-strictly-before-site independently,
with different tie-breaking (`macros.ts` falls back to the *last* candidate on forward reference;
`expand.ts` returns undefined). Zones and pointers both need a third copy. This is the single
shared primitive of cut 2 and should be extracted to `compile/binding.ts` before any of the three
lanes is written — it is also the natural home for the `NameBinding` verdict oracle of 1.5.
The differing forward-reference behavior should be reconciled deliberately while extracting, not
inherited twice.

**F2 — Nested definitions are recorded as if they were document-level.** `JACT.tex` contains
`\newenvironment{propositionof}[1]{\renewcommand{\propositionofref}{#1}\zpropositionof}{...}`.
The inner `\renewcommand` is minted as an independent `macro-definition` with its own seq
(`2403.08110v4/macros.jsonl`, `def:JACT.tex:4806-4842`, `seq:145`, bodyText `#1`). But it does not
fire at seq 145 — it fires each time `propositionof` is used. Shadowing resolution on the shared
seq scale will therefore report `\propositionofref` as redefined at a document position where
nothing changed. `elaborate/expand.ts:79-91` already refuses to descend into definition arguments
for the *expansion* walk; the *census* has no equivalent guard, and the deferral is invisible in
`macros.jsonl`. Affects zone closure and any shadowing verdict.
**[OWNER]** — whether `MacroRecord` grows a `deferred: boolean` / `definedWithin: string` (a
`def:` id), or the census stops minting nested definitions as top-level rows.

**F3 — All bodiless definitions share one fingerprint.** `compile/macros.ts:88-89` hashes
`bodyText ?? signatureRaw ?? ""`. `\newcommand{\propositionofref}{}` and
`\newcommand{\theoremofref}{}` both carry
`fingerprint: "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"` — the sha256 of
the empty string (`2403.08110v4/macros.jsonl`, `def:JACT.tex:4677-4707` and
`def:JACT.tex:4880-4906`). For the cross-corpus specimen store the fingerprint is documented to
serve, every empty-bodied definition in the corpus is one specimen. Low severity, but the
fingerprint is documented as impossible to backfill consistently, so it is worth settling now
rather than after another 34 papers.
**[OWNER]** — whether an empty body should hash at all, or emit `fingerprint: null`.

**F4 — `span-synthesized` is 46509 of 47346 diagnostics (98%).** At `severity:"info"` it is
correctly not a defect, but it dominates `diagnostics.jsonl` by two orders of magnitude and will
bury the codes the three new lanes emit. Not a correctness issue; a legibility one. Options: move
hull synthesis to a per-source count in `summary.json` (the information is already on the entity
via `spanProvenance`), or split audit-tier files. **[OWNER]**, low priority.

**F5 — 673 `witness-disagreement` diagnostics corpus-wide.** The cut-1 report cites first light at
5527/5547 agreed; the batch aggregate holds up. `2111.15058v3` now shows 5561/5561 agreed with
zero residue — the `cases`-frame disagreements from first light are resolved. Nothing to do; noted
so the number is not re-litigated.

---

## 5. Sequencing recommendation

Ordered by what unblocks what, smallest honest cut first.

1. **`compile/binding.ts` — shared substrate.** The governing-definition resolver (F1) plus the
   `NameBinding` verdict oracle (B1 register + B2 configured + B3 kernel, per 1.5). Nothing else
   in cut 2 is honest without it, and both lanes below consume it. Requires the B1 doctrine
   ruling first — that is the one blocking question in this whole scoping pass.

2. **`pointers.jsonl` first cut.** Highest evidence density, needs no new census signal, and the
   `internal-ref` half resolves completely today. Lands the derived-pointer fixpoint — the
   doctrine's headline mechanism — against real corpus counter-examples that are already
   identified (2.2). Leaves the references seam explicitly open (2.6).

3. **`zones.jsonl` first cut — math/verbatim/float only.** Consumes the binding oracle; defers
   `theorem-like` and `diagram` behind the env-definition-id decision (1.4(1)) and the diagram
   vocabulary decision (1.3c). `Zone.content` waits for the ContentPart builder.

4. **Census-tier parbreak signal**, then **`walk.jsonl`**, then the **single-pass seq address
   collection** (3.2(1)) and the shared ContentPart builder (3.3). Walk is last because it is the
   only lane that needs a change in the census tier, and because its anchors consume zone ids.
   Gate 4 lands here, reported not enforced.

5. **Deferred to cut 3 as already planned:** validation instruments (katex/node-tikzjax), isolated
   evaluation, `references.jsonl`, `graph.jsonl`.

The math-role vocabulary extension (1.3a) is a census change that should ride step 4 with the
parbreak change rather than being done twice — but note that step 3 emits math zones *before* it,
so `alignat*` and `subequations` carriers will be missing from the first zone cut. Declaring that
in `summary.stores` is cheaper than reordering.

---

## 6. Owner-decision index

| # | Decision | Blocks |
| --- | --- | --- |
| D1 | Binder register over unparsed `.sty`/`.cls` — permitted, or does README:21-22 forbid it? | binding oracle, all of cut 2 |
| D2 | `bound-out-of-scope` as one state + `bindingBasis` field, or three states | zone isolability |
| D3 | Environment definitions get `def:` rows (+`defines` discriminator) or a new `env:` class | theorem-like + diagram zone closure |
| D4 | `MacroRecord.aliasTarget` for `\let` chains | closure completeness |
| D5 | `theorem-like` derived from in-document `\newtheorem` only, or ctan curation first | zone-kind uniformity |
| D6 | `KNOWN_DIAGRAM_ENVS` small vocabulary — accept or find another basis | diagram zones |
| D7 | Pointer seed vocabulary — registered const, lane config, or ctan-derived | pointers lane |
| D8 | Anchor-target-forming macros (`\refstepcounter`) — third union member or ignored | `attachesTo` correctness |
| D9 | `argumentSpans` bracketed flag — re-derive at compile time or restore on the entity | citation key extraction |
| D10 | Not-yet-resolvable citations — per-row `resolution` field or empty + `stores.deferred` | pointers/references seam |
| D11 | Parbreak signal — spine claim role, or walk reads a threaded AST | walk paragraphs |
| D12 | Seq stability — run-local declaration now, single-pass collection at walk, or gapped scale | cross-cut seq comparability |
| D13 | Nested definitions (F2) — `deferred` flag, `definedWithin`, or stop minting them | shadowing verdicts |
| D14 | Empty-body fingerprint (F3) — hash the empty string or emit null | specimen store identity |
| D15 | New diagnostic codes for the three lanes; `UnknownEnvironment`/`OpaqueRegion` finally fire | gate 4 + zone/pointer reporting |
| D16 | katex from cut 2, or all validation `skipped` until cut 3 | zone validation |

## 7. Unknowns with the evidence that would settle them

- **Is any source `\input` twice in the corpus?** Count `kind:"include"` entities grouped by
  `resolvedSourceId` per job; a `resolvedSourceId` appearing at two distinct sites is the case.
  Settles whether `WalkNode` needs an occurrence discriminator (3.2(3)).
- **How many invocation names resolve to nothing under B1+B2+B3?** Set-difference the invoked
  names against `macros.jsonl` `definedName`s, the configured decls, the latex2e record, and the
  binder register. If that residual is small, `unresolved` is a real defect signal; if it is large,
  the verdict machinery is decorative and D2 changes shape. This is the highest-value measurement
  before writing the zone lane, and it can be computed from the artifacts already on disk plus one
  scan of the 12 binder files.
- **Do the 3 `unreachable-tex` sources contain definitions the document uses?** If yes, the
  binding oracle has a fourth basis to consider; if no, they stay pure diagnostics.
