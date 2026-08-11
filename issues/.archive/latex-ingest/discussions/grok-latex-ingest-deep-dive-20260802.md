`latex.ps1` is the easy case you already named: it is already a mask-algebra client. The interesting harvest is almost entirely in `latex-ingest.ps1`, plus a few structural scanners that still live as ad-hoc passes even when masks exist nearby.

Below is a first-pass map of **missed opportunities** — places that do Doccer-shaped work (regions, scope, nesting, evidence spans, protected contexts) without a Doccer-like substrate.

---

### Already on a Doccer-like path (skip)

These are the good examples, not the harvest:

| Mechanism                                             | Where                                             |
| ----------------------------------------------------- | ------------------------------------------------- |
| Comment − verbatim = real comments                    | `Get-TexCommentMask`                              |
| Expandable / prose regions                            | `Get-TexExpandableMask`, `Get-TexProseMask`       |
| Math structure overlay + complement → prose density   | `Test-IsMath`, `Get-ProseInFormulaSpans`          |
| Bare `&` − env coverage                               | `Test-AlignmentOutsideEnv`                        |
| Comment strip via mask when available                 | `Remove-TexComments`                              |
| Macro expansion scoped to expandable text (attempted) | `Expand-LatexMacros` uses `Get-TexExpandableMask` |

Those are adapter-shaped compositions over interval algebra. The rest is where the converter still invents its own geometry.

---

### Missed opportunity clusters

#### 1. Protect / restore as a private span registry

The whole pipeline is organized around **stash → transform → restore**:

- `Protect-VerbatimBlocks` → `@@VERBn@@`
- `Protect-LatexMath` / `Store-Math` → `@@LMATHn@@` / `@@LDISPn@@`
- `Convert-Algorithms` → `@@ALGn@@`
- `Add-Diagram` → flagged markers / diagram store

**What Doccer would own:** claim kinds for those regions (`verbatim`, `math.inline`, `math.display`, `algorithm`, `diagram`), a frozen batch of extents, and later a Boolean mask for “protected.”
**What stays domain:** the _content_ of each stash (KaTeX rewrite rules, diagram transpile, algorithm list formatting).

Missed opportunity: every later pass must _know not to touch_ placeholders by accident. With claims, “operate only outside math+verb+alg” is one `Suppression.Admitted` (or complement of a union of kinds), not tribal knowledge about `@@…@@` strings.

#### 2. Delimiter pairing scanners that are really region collectors

`Convert-DisplayDollars` and `Protect-InlineDollarSpans` are careful O(n) TeX-faithful scanners (brace depth, escapes, `\(…\)` in reading order). They already _think_ in intervals; they just never emit them as first-class claims.

Missed opportunity:

- Emit `math.display` / `math.inline` claims while scanning.
- Hand the interiors to domain adapters (`Store-Math` lowering, xy/tikz encode-first).
- Let later stages query “all math spans” instead of depending on placeholder survival.

Same pattern for `Get-LatexBalance` / `Get-EnvironmentBalance`: they compute structure, then throw most of it away and keep a residual or a single fault. A claim batch of env open/close events (or nested env extents) would feed both diagnostics and repair spans.

#### 3. Environment / float coverage reinvented several times

| Need                             | Current approach                                                           |
| -------------------------------- | -------------------------------------------------------------------------- |
| Env coverage for `&` check       | `Get-EnvironmentSpans` (stack + regex) — good, mask-based                  |
| Theorem/eq/figure counters       | `Build-LabelMaps` — `IndexOf('\\end{…')` + substring                       |
| Float blanking for oracle counts | Regex replace of whole `figure` envs                                       |
| Cross-ref walk                   | `Convert-CrossRefEnvs` — single ordered regex over section/begin/end/label |

Missed opportunity: **one environment claim pass** (begin/end with name, optional star, optional note, nesting) would replace:

- stack scans for coverage
- `IndexOf` segmenting for label maps
- float blanking for “diagrams outside floats”
- part of the cross-ref walk’s structural backbone

Numbering policy and display strings stay domain; “this extent is env `theorem` nested in …” is engine-shaped.

#### 4. Macro expansion: scoped matching with full-string offsets

`Expand-LatexMacros` does something subtle and fragile:

1. Build expandable mask
2. `Get-MaskedText -Keep` → a **new string** of admitted regions only
3. Match macros on that string
4. Apply replacements using those match indices against the **original** `$Text`

Unless `Get-MaskedText` preserves offsets (or the code remaps them), region-local indices and master indices are not the same coordinate space. That is exactly the class of bug Doccer’s scoped collector is designed to prevent: match **inside** each admitted interval, then lift by `region.Start + localIndex`.

Missed opportunity: treat expandable regions as a `SpanSet` scope and run macro recognition as scoped collection + edit plan, not “blank/keep then hope indices still mean the same thing.”

#### 5. Brace-group surgery as repeated local parsers

`Get-LatexBracedArg`, `Get-BraceGroupEnd`, `Replace-BracedCommand`, and many while-loops that rewrite `\cmd{…}` are a family of **nested-delimiter region finders**.

Missed opportunity at the engine layer is not “parse TeX braces in C#,” but:

- a small **scanner-shaped claim producer** for balanced groups (or command+args extents),
- then domain rewrite rules as edit plans over those claims.

Today every command family reimplements “find `\foo`, walk braces, splice string.”

#### 6. Diagram grid parsing: depth-0 splits without claims

`Convert-XyDiagramBody` / `Convert-TikzcdDiagram` split cells on depth-0 `\\` and `&` with a hand-rolled depth counter. That is interval structure (row spans, cell spans, arrow attachments) used once for transpile, then discarded.

Missed opportunity: even a lightweight claim set `{row, cell, arrow-spec}` would make “what failed encode-first?” inspectable and would let residual diagrams share structure with the work-list instead of only storing raw source strings.

#### 7. Soft corruption detectors: regex over whole math strings

In `latex.ps1`, several soft signals are already mask-aware (prose-in-formula, alignment outside env). Others are still whole-string regex:

- glyph leaks
- dangling operators
- bare number rows
- degenerate `\substack`
- self-cancelling subexpressions

Missed opportunity: run these **only inside** math claims (or only in display math), as collectors with kinds, then validate with forbidden relations / agreement rules. Right now scope is “the string we happened to pass in,” which works for chunk-level grading but does not compose with a document-wide claim batch.

#### 8. Subject index and byte offsets

`Get-LatexSubjectIndex` finds emitted headers with `IndexOf` and records **UTF-8 byte** starts. That mixes:

- string search in the finished markdown
- a different address unit (bytes vs UTF-16)

Missed opportunity long-term is F3 (byte addressing) + claims recorded **at emission time** (the walk already has kind/number/label). The code comments already say the label should not be scraped back from markdown; the same applies to position: emit a claim when writing `**Theorem 2.1**`, don’t rediscover it.

#### 9. Comment / conditional / declaration stripping as opaque deletes

Still mostly regex surgery on the full body:

- `\begin{comment}…\end{comment}`, `\iffalse…\fi`, `CCSXML`
- `Remove-LatexDeclarations` (brace-aware, but not claim-producing)
- bibliography env drop

Missed opportunity: emit `comment.block`, `conditional.false`, `declaration` claims (or at least extents), then delete via an explicit edit plan. Today deletion is invisible; you cannot ask “what was removed?” or “did we strip inside verbatim?” except by trusting pass order (`Protect-VerbatimBlocks` first).

#### 10. Algorithmic and float body handling

`Format-Algorithmic` / `Convert-Algorithms` do structural parsing of `\If`/`\While`/… with brace-aware args, then stash markdown lists. Captions and nested algorithmic envs are found with regex over the float interior.

Missed opportunity is milder: domain-heavy. The Doccer-shaped piece is only “algorithm float extent” and “algorithmic body extent” as claims so caption extraction and math protection order stay queryable.

---

### How to classify each for the harvest

Using your three-layer discipline:

| Observation                                       | Likely layer                                                                          |
| ------------------------------------------------- | ------------------------------------------------------------------------------------- |
| Region kinds: math / verb / comment / env / float | **Engine** (generic claim types) or inventory data                                    |
| Scoped match + lift offsets                       | **Engine** (already exists; latex should call it)                                     |
| Nested begin/end extents                          | **Engine-ish scanner** or declarative inventory + small scanner adapter               |
| Macro expand only in expandable mask              | **Composition** of existing primitives; fix coordinate bug                            |
| KaTeX rewrites, `\text` normalization, glyph maps | **Domain adapter**                                                                    |
| Theorem numbering policy, cleveref, biblatex      | **Domain / orchestration**                                                            |
| Encode-first diagram grids                        | **Domain**, maybe with optional structural claims                                     |
| Protect/restore placeholders                      | **Replace with claims + edit plans** over time; not a new engine verb named “Protect” |

---

### Highest-value misses (if you only chase a few)

1. **Math/verbatim/algorithm regions as claims** instead of `@@…@@` — unblocks every later “don’t touch protected text” rule.
2. **Environment claim pass** shared by alignment checks, label maps, oracle “outside float,” and cross-ref structure.
3. **Macro expansion on true scoped intervals** (match in region, lift to master) — correctness, not just style.
4. **Edit-plan shaped deletes** for comments/declarations/conditionals — makes stripping auditable.
5. **Emission-time object claims** for the subject index — stop recovering structure from rendered markdown.

`masks.ps1` shows the destination for (1)–(2) style work. The rest of `latex-ingest` is still mostly **string rewriting with tribal pass order**, which is exactly where Doccer’s “claims first; queries apply policy” would remove missed structure rather than only cleaning up masks that already exist.

I can next turn any one cluster into a harvest table (current function → candidate claim kinds → engine vs adapter vs leave-alone) if you want that as the working survey format.
