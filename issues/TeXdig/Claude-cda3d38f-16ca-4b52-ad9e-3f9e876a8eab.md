
# i might be inclined to expand unified-latex-ctan with the missing things like Absent: amsmath, amsthm, graphicx, natbib, url, xy, algorithm-family e.g. maybe part of my answer is to engineer improvements and increased coverage in the tools rather than taking them at face value

That's a live option, and the census was actually built with a socket for it — let me ground what "a record" concretely is and what the configured channel consumes, so the authoring surface is factual.
Your instinct just got a sharp confirmation from the records themselves: **`\title` and `\author` are literally absent from upstream's `latex2e` record** (143 macros — `maketitle` yes, `section` yes, `title`/`author` no). The frontmatter leak in the probe wasn't a design failure of the walk's fold — it was a *coverage hole in the tool's data*. Same story one shelf over: `latex2e`'s environment record has 19 entries and is missing `center`, `flushleft/flushright`, `quote`, `quotation`, `abstract`, `verbatim`; and `amsart`'s environment record is confirmed empty. So "engineer the tools rather than take them at face value" isn't a maybe — several of the failures we just looked at *are* tool-coverage gaps, one data line each.

And the anatomy is favorable — a record is almost pure data:

```
mathllap -> {"signature":"o m"}
href     -> {"signature":"o m m"}
```

plus [configured.ts](src/TeXdig/census/configured.ts) semantics that matter for authoring: an entry with no signature at all binds as **known zero-arg** (so `amssymb` costs nothing but a name list), and an entry carrying an `argumentParser` (upstream code, e.g. verbatim-ish args) is detected and handled as its own evidence state. The census already keys records by document-summoned `\usepackage`/`\documentclass`, injects them *beneath* document discoveries (paper wins), and emits `census/configured-gap` as a ranked curation queue. The socket for exactly this work has been sitting there since the configured channel landed.

Three routes, and the house doctrine mostly decides between them: a **tracked in-repo overlay store** in the same record format, consumed by the configured channel beside the pinned records (packages/ stays pristine; provenance stays clean; needs one precedence ruling — document > house > upstream-ctan reads natural, since house exists to correct upstream); **upstream PRs** later, free because the format is theirs; and **never** patching the vendored copy, which a refresh would silently clobber. Worth noticing that T15's recommended fix already contains the seed of this — "baseline gains a pinned kernel name-set" *is* the first house record. Your idea generalizes it into a tier.

Calibration on the gap list, from what each package actually is:

| package | authoring cost | character |
|---|---|---|
| amssymb | trivial | zero-arg symbol names — bare list suffices |
| graphicx | small | ~a dozen signatures (`includegraphics` = `o m`, etc.) |
| natbib | small | cite family, `s o o m` shapes |
| url | tiny record, honest caveat | `\url` = `m`; hostile `%`/`#` URLs are a parser-level limit no record fixes |
| amsthm | small, entangled with T15(i) | `\newtheorem*`, `\theoremstyle`, `proof` env with `o` |
| amsmath | the big one | mostly *environment* records — align/gather/multline families plus matrix/cases interiors; authoring it forces the T18 carrier-vs-interior vocabulary, so it and T18 are one piece of work |
| xy, tikz-cd, algorithm-family | envelope-only | names + coarse signatures; interiors stay opaque dialect per T6 until earned |

Two things worth holding while you weigh it. There's a harvest shortcut: TeXstudio's `.cwl` completion corpus and LaTeX-Workshop's generated package data (same author as latex-utensils) encode signatures for hundreds of packages, machine-convertible into record shape — provenance/licensing needs a check before wholesale import, but as a draft-then-verify source it beats hand-typing. And one real sequencing dependency: expanding configured coverage before T15(i) lands would *amplify* the veto defect — every new record is new authority, and right now configured authority can falsely block document-level `\newtheorem`. The authority split wants to land first, then coverage grows behind it safely.

My lean, for what it's worth: the overlay store, with the kernel name-set and `latex2e` completions as its first entries — it's simultaneously the T15 fix, the frontmatter-leak fix, and the mechanism your gap queue has been waiting to feed.

---

# I want to modify the node_module source code

Alright — then let's look at exactly what we'd be modifying, because the answer differs depending on how that package ships its records and what the brewery restore would do to our edits.
The package is friendlier to this than typical npm dist — the records are **plain object literals in per-package modules**, not a minified bundle:

```js
// package/latex2e/index.cjs, line 278
maketitle: { renderInfo: { breakAround: true } },
date: { signature: "o m", renderInfo: { breakAround: true } },
```

So the modification surface is:

- **Edit an existing package's records**: `package/{pkg}/index.cjs` is what the loader actually executes (createRequire → CJS chain from the root `index.cjs`). Each package also ships an ESM twin `index.js` — nothing of ours loads it today, but I'd mirror every edit there so the two can never disagree later. Adding `title: { signature: "m" }` and `author: { signature: "m" }` to latex2e is literally two lines per file.
- **Add a missing package** (amsmath, amsthm, natbib…): new folder `package/amsmath/` with the same module shape, plus registration in the root `index.cjs`/`index.js` where the aggregate `macroInfo`/`environmentInfo` maps are assembled. A few of the existing packages (xcolor, listings, minted, tikz) live as code-split chunks at the root instead because they carry `argumentParser` code — data-only records don't need that.
- **No build step.** These are the runtime files; the census worker spawns a fresh `node` per run, so edits are live on the very next census.

One reality to hold, not to stop you: [restore-node.ps1](brewery/node/restore-node.ps1) runs `npm ci`, which **replaces the whole `node_modules` tree** — in-place edits survive until the next restore and then vanish without a trace. The house already owns the right idiom for exactly this situation: the latex-oracle patch lane — curated errata kept small, re-applied on every rebuild, failing loud when stale. A `brewery/node/patches/` step after `npm ci` is that idiom at the dependency tier, and it's what turns "I hacked node_modules" into "the house maintains an extended unified-latex-ctan." Worth wiring once the first edits settle; not needed to start.

The two-line latex2e edit is also the cleanest end-to-end proof of this whole direction: make it, re-run the probe census, and watch the `\title`/`\author` leak disappear from the walk with no TeXdig code touched. Want me to make that edit now, or do you want the wheel for the first one?

---

# right im aware of the hazard with restore_node. With my changes, i'm effectively forking that and whatever modules get changed become source code or at least cordoned off from the refresh cycle and replace the pinned dependencies and packages that would be managed by node precisely beacuse i dont want to overwrite my changes. my philosophy here is to just fill in gaps in the node modules and maybe eventually i can send that back to the remote source as a contribution, but in the mean time, im trying to pull back a layer of the present engineering work and to make the tools capable the way i need them to be. there is no one tool out there that will do i what i want, but it seems like alot of things that i was trying to deal with abstractly fit more naturally as feature enhancements and improved coverage in the node_module tools, not data stores in my pipeline

Understood — that's a real fork stance, not a patch stance: the changed modules graduate from "pinned external" to "house source," and npm's refresh cycle simply stops owning them. Before laying out the cordon mechanics, one fact matters a lot: **who else in the tree consumes `unified-latex-ctan`** — if other unified-latex members read it internally, the fork can either capture them too or miss them, depending on how we cordon. Checking now.
The probe just handed your philosophy its strongest evidence yet: **`util-parse` itself depends on `unified-latex-ctan`** — the base parser consumes these records internally — and there are zero nested copies, one flat installation. So filling in the records doesn't just feed TeXdig's configured channel; it **upgrades the parser itself**: argument attachment and environment processing inside unified-latex's own pipeline get the knowledge natively. Which recasts what the census's configured channel has been doing — injecting signatures from the outside is compensation for a starved tool. You're not adding a data store; you're feeding the machinery that was already built to eat this.

That same fact decides the cordon mechanics. A redirect inside `loader.ts` would be wrong — census would read your fork while `util-parse` silently kept resolving the stale pinned copy: two sources disagreeing invisibly, the exact failure this house exists to prevent. The fork has to **own the `node_modules` resolution position** so every bare-specifier consumer gets it. Two clean ways, both keeping the brewery lock authoritative for everything unforked:

- **Manifest-level**: brewery's `package.json` points the forked module at house source (`file:` dependency, plus an `overrides` entry so transitive consumers like util-parse resolve there too). `npm ci` materializes it as a link — restore *re-establishes* the fork instead of clobbering it, and edits in tracked source are live immediately.
- **Restore-step**: `restore-node.ps1` gains a post-`ci` step that replaces the registry-installed module with a junction to house source. Blunter, zero npm cleverness, literally "cordoned off from the refresh cycle."

Either way: the forked module's source is **tracked in git** (it stops being packages-tier the moment you edit it — your "becomes source code" is exactly right), it keeps a small provenance note (upstream name, version forked from — the merge base when upstream moves), and its `version` field stays `1.8.4` so semver ranges keep resolving. The installed modules are compiled output of an upstream TS monorepo, and since records are data literals, translating your additions into upstream-shaped PRs later is mechanical — fork-now, contribute-later sequences fine.

On the philosophy's reach — the fork has three tiers, and it's worth seeing how far it goes, because the deep end is where it retires the most pipeline machinery:

1. **Records** (data): title/author, the missing basic environments, whole absent packages. Cheap, immediate, parser-upgrading.
2. **Argument parsers** (small code): verbatim-catcode arguments (`\url` with `%`/`#`), the chunk-shaped packages.
3. **Parser fixes** (grammar surgery): the two corpus-confirmed instrument defects — csname truncation near `#` parameter tokens under `\makeatletter`, and the local-frame position lie in reparsed alignment environments. Census currently *works around* both (catcode arbitration, utensils backfill). Under your stance those are upstream defects to fix in the fork — and fixing them deletes compensation layers from census rather than adding to them.

One boundary I'd keep even at full reach: the two-instrument witness discipline isn't a workaround — a better instrument 1 retires the *arbitration hacks*, not the second witness. Agreement stays computed, per your own doctrine.

Two decisions are yours before anything moves: where adopted-fork source lives in the tree (it's a new tier — neither `packages/` pinned-external nor lane code, and the name should be yours), and which cordon mechanism. Say the word and I'll stand it up seeded with the latex2e completion, then re-run the probe census as the end-to-end proof.

---

# i just cloned unified-latex fork to D:\aghado01\packages\node-latex-deps\unified-latex . we can make modifications to that and build the custom solutions for deployment in codex scientiae

The clone is the right move — full source truth, upstream-shaped for eventual PRs. Let me survey what you've got: monorepo layout, build tooling, where the checkout sits relative to the pinned 1.8.4, and where the latex2e records live in source form.
Now the workspace install at the fork root — the one heavy step (wireit, vite, and friends):

---

# [Request interrupted by user for tool use]

---

# why don't we discuss further. i just cloned latex-utensils as well, and as my thinking changes in real time, what i really want to do is examine both projects and identify where they had gaps, and then merge them into a new unified solution that captures the capabilities in both

Both clones confirmed side by side under `node-latex-deps`. Good — let's discuss, because "merge them" has at least three genuinely different shapes, and the corpus already wrote the requirements list.

## What the gap analysis actually says

The two projects aren't competitors that each half-succeeded — they're different *purposes* that each fully succeeded:

| capability | unified-latex | latex-utensils |
|---|---|---|
| position fidelity | degrades through enrichment — reparse stages mint local frames, csname truncation near `#` | global, every node incl. sub/superscript — survives because nothing ever mutates |
| macro knowledge | argspec, ctan records, signature-driven argument attachment | none — arguments are lexical adjacency |
| expansion | full toolkit, corpus-verified convergent | none |
| environment semantics | `processEnvironments` + records | names only, but the *math-env family* is typed |
| verbatim family | parses `\verb`/verbatim, but the .bbl `\verb`-field misread came from here | first-class typed: verb, verbatim, minted, lstlisting |
| error posture | forgiving by design — recovers and keeps going | strict mode, typed SyntaxError with location |
| dialect grammars | align, tabular, tikz, xcolor, pgfkeys, systeme, **ligatures**, glue | one grammar |
| transformation | visit/replace/print, **to-mdast**, prettier | read-only |
| side channels | none | bibtexParser, latexLogParser (page numbers, file stacks) |

unified-latex is a *transformation engine* (semantics layered by mutating the tree — which is exactly why its positions rot). latex-utensils is a *faithful index* (positions sacred — which is exactly why it knows no semantics). The census's stratify/backfill/witness machinery exists *because* neither alone suffices. Your merge instinct is naming that compensation layer and pushing it down a tier.

## The three shapes of "merge"

**(A) Evolve the unified-latex fork toward utensils' virtues.** Position discipline becomes law inside the enrichment pipeline (annotation instead of mutation, or position-preserving reparse), catcode truncation fixed, verbatim family typed, strict mode added. Utensils is used as the *reference standard* for what "faithful" means — but stays unmerged. Most upstream-contributable; the surgery is at unified-latex's architectural heart, though, not its edges.

**(B) Build enrichment on utensils.** You'd be writing unified-latex's entire second half from scratch on a monolithic grammar, and porting the toolkit. I think this one's dominated — mentioning it only for completeness.

**(C) A new third package over both grammars as internal instruments** — fusion inside the tool. This is the census's parsing core productized: two independent sightings, computed agreement, honest disagreement, exported as *the parse result*. TeXdig then thins to a reader.

## The tension worth naming before choosing

Utensils' value to your doctrine isn't only its capabilities — it's that it **shares no code, grammar, or author** with unified-latex. That independence is what makes two-witness agreement mean something. Absorb utensils into a merged codebase and you've captured its features but *spent* the second witness — self-agreement is no agreement. So: (A) captures capabilities and keeps the independent instrument outside; (C) keeps both instruments alive but commits the tool itself to being a fusion instrument, heavier than what a generic consumer wants and exactly what a census-shaped consumer wants.

## And the thing neither upstream is — which may be what you're actually reaching for

If the merged solution is just "unified-latex + utensils features," it's a better parser. But there's a version of it that's a genuinely new kind of tool: **a parser that emits its own accounting.** Output = AST *plus* a byte-coverage ledger (every source byte claimed by a node or explicit residue) *plus* three-state honesty on every knowledge-dependent judgment (positions trusted/untrusted, names bound/unbound/indeterminate). That's your claims-as-currency and knowability binary — as a *parser invariant* rather than a pipeline discipline. Neither upstream will ever build it; their consumers don't want confessions. Yours is the consumer that does. Under that framing, both clones are organ donors to a tool whose defining feature came from neither.

Two questions I'd actually put to you, since they pick the shape: does anything beyond TeXdig consume this tool (that decides whether the AST contract stays unist-flavored, goes utensils-typed, or becomes its own thing) — and when you say "new unified solution," do you feel it as *one true parser* with utensils kept outside as the independent check (A), or as the *fusion instrument itself*, the census's core moved down a layer (C)?

---

# you're being academic. we can implement the superset of capabilities in a coherent manner into a separate node-latex-dep project, we just have to reconcile them. the synthesis can keep the witnesses by implementing mechanisms for both and making witnesses first class, just moved back a layer into these engines. so the plan is to identify gaps in both, merge the two projects into one coherent engine. based on their implementations, there might be places were we can improve algorithms, but also places where we need only add new types or coverage for things that were missing before

Right — one engine, superset capabilities, witnesses moved down into it as first-class citizens. Then the work starts where you said: identify the gaps grounded in the actual implementations. Let me read the load-bearing cores of both — node vocabulary, position model, argument model, grammar organization — since every reconciliation decision hangs off those four.
One more probe — utensils' location/options shape, and confirmation of where unified-latex's `Argument` nodes lose their positions:
Grounded now. Here's the reconciliation map by subsystem, each tagged with your two work classes — where the merge is **algorithm improvement** vs. where it's **new types/coverage**. This is read off the implementations, not the docs.

**1. Position model — the first ruling, and it's cheap to state.** Utensils: `location: Location` is *required on every node type*, dual-addressed (offset and line/column), with position-query tooling (`findNodeAt`, `PositionOs`/`PositionLc`). unified-latex: `position?:` optional — and the enrichment machinery exercises that optionality: `attach-arguments.ts` contains zero position logic, so `Argument` nodes are born unaddressed, and reparse stages mint local frames. The engine's law is utensils': location mandatory, and every enrichment stage derives spans from the contiguous tokens it consumed (`first.start..last.end` — mechanical, just never implemented). *[algorithm in the enrichment path; the type change is deleting one `?`]*

**2. Node vocabulary — superset, with one generalization.** Utensils has 31+ typed kinds vs unified-latex's 13 generic ones. Three groups to adopt outright: the verbatim family (`Verb`/`Verbatim`/`Minted`/`Lstlisting`), math micro-structure (`MathCharacter`, `MatchingDelimiters`, `MathDelimiters`, `Superscript`/`Subscript`, `AlignmentTab`), and the lexical distinctions (`Softbreak`/`Linebreak`, `ActiveCharacter`, `CommandParameter`, `Ignore`). *[types/coverage]* The interesting group is utensils' semantic command subtypes — `DefCommand`, `UrlCommand`, `HrefCommand`, `LabelCommand`, `AmsMathTextCommand`. That's knowledge *frozen into the grammar* — the rigid version of what unified-latex's records do dynamically. The engine keeps the typed outputs but drives them from the record registry instead of hardcoding, so `UrlCommand`-ness becomes a record-declared classification any package can add. *[algorithm: one mechanism replaces five special cases]*

**3. Argument model — where your witnesses become first-class.** Utensils attaches arguments by *lexical adjacency* (grammar-level `Group`/`OptionalArg`, no knowledge). unified-latex attaches by *signature* (record-driven, post-hoc, mutating). These aren't competing implementations to pick between — they're the two strata, and the engine implements **both mechanisms with the pairing recorded and agreement computed**: lexical sighting tier + knowledge-bound tier. That is the census's physical-token vs invocation-hull distinction relocated into the engine as its native argument model, and `census/{stratify,witness-equivalence,backfill-utensils}.ts` is the reference implementation to port down a layer. *[algorithm — the load-bearing one]*

**4. Grammar organization.** unified-latex's 11 modular grammars (core, align, ligatures, macro-substitutions, pgfkeys, systeme, tabular-spec, tex-glue, tikz, xcolor, xparse-argspec) are the extensible half — future dialects (biber `.bbl` vocabulary, xy envelopes) slot in as new grammars. *[coverage]* The defect is in *composition*: reparse without frame translation is exactly where local coordinates leak. Utensils contributes the operational virtues the core lacks: strict mode, typed `SyntaxError` with location, `startRule` (Root/Preamble), and a parse **timeout** (`TimeKeeper`) — bounded parsing that unified-latex has nowhere. *[algorithm: frame-preserving composition; types/coverage: the option surface]*

**5. Error posture → the accounting.** Utensils refuses loudly; unified-latex recovers silently. The engine does the third thing neither does: recovers *with confession* — unknown/error nodes carry spans, and the parse result includes the ledger: every source byte claimed by a node or standing as explicit residue. Your knowability binary as an engine invariant rather than a pipeline discipline. *[small algorithm, new types]*

**6. Knowledge registry.** The ctan records, document-derived definitions (`listNewcommands`), and summoning scopes (which package is active where) move from census-side injection into the engine as its registry mechanics. The whole gap-filling thread — `title`/`author`, missing basic environments, absent packages — lands here as pure coverage behind one mechanism. *[coverage, plus modest algorithm for summoning scope]*

**7. Side channels and toolkit.** Utensils brings `bibtexParser` and `latexLogParser` (page numbers, file stacks — the future compile side-channel reader) as engine members; unified-latex brings expansion, argspec, catcode region repair, the ligatures grammar, to-mdast/to-hast. Adoption and porting, no invention. *[coverage]*

**8. The output contract.** Parse result = typed nodes with mandatory locations + strata + computed agreements + ledger + diagnostics. That's the witnesses-moved-back-a-layer, stated as the engine's return type. TeXdig's census thins to a reader of it.

The deep pass to finish gap identification runs one subsystem at a time with both implementations open — and I'd start with **3 then 1**, because the argument-strata and position rulings fix the engine's AST contract, and everything else composes onto that. Two things are yours before I go deeper: the engine's name (it's a new project beside the two clones in `node-latex-deps`), and where you want this reconciliation ledger to live — in the new project's tree, or chat-only until it has a home.

---

# why dont you scan both of the forks under node-latex-deps and tell me which root-level subdirectoriesand filetypes are of interest as raw material for the new superset project. i'll collect them and make a reposnapshot to streamline the cross-project analysis

Scan complete. Here's the raw-material curation for the snapshot, per fork.

## latex-utensils — small and dense: almost everything real lives in `src/`

**Include:**

| path | why |
|---|---|
| `src/latex/` | the core: `latex.pegjs` (the position-faithful grammar), `latex_parser.ts`, `latex_parser_types.ts` (the 31-kind typed vocabulary), `find_all.ts`/`matcher.ts` (position-query tooling), `stringify.ts`, plus the `*_simple.d.ts`/`*_trace.d.ts` declaration pairs for the generated parsers |
| `src/bibtex/` | `bibtex.pegjs` + parser + types — the .bib side channel |
| `src/latex_log/` | `latex_log.pegjs` + parser + types — the compile-log side channel |
| `src/pegjs/` | `pegjs_types.ts` (the `Location` contract every node carries) and `timeout.ts` (the bounded-parse mechanism) |
| `test/` | `test_latex_parser*.ts` etc. = the behavioral spec, plus `latex_log/` holding 12 real `.log` fixtures |
| `sample/`, `types/`, `bin/`, `dev/` | sample `.tex` inputs, ambient types, and the grammar→parser build mechanics — all tiny |
| root `package.json`, `README.md`, `CHANGELOG.md` | build scripts (how the .pegjs get compiled) and orientation |

**Exclude:** `.git`, `.github`, `.vscode`, `docs/` (generated typedoc), `package-lock.json`, lint/tsconfig/typedoc configs.

Filetype census confirms density: 24 `.ts` + 3 `.pegjs` + 12 `.log` fixtures is the entire substance.

## unified-latex — take `packages/` selectively plus two root pockets

**Include:**

| path | why |
|---|---|
| `packages/*/index.ts`, `packages/*/libs/**/*.ts` | all engine algorithms — parse pipeline, arguments, macros, argspec, environments, catcode, align, visit/match/replace/scan/split, print-raw, to-mdast/to-hast |
| `packages/unified-latex-util-pegjs/grammars/*.pegjs` | the 11 modular grammars (core + align, ligatures, macro-substitutions, pgfkeys, systeme, tabular-spec, tex-glue, tikz, xcolor, xparse-argspec) |
| `packages/unified-latex-types/libs/` | the 13-kind AST vocabulary + position model |
| `packages/unified-latex-ctan/package/*/` and its `index.ts`/`utils/` | every record file (`provides.ts` per CTAN package) — note this includes our uncommitted `title`/`author` seed edit, which I'd leave in deliberately |
| `packages/support-tables/` | a find: **`katex-support.json`** (KaTeX-renderable macro inventory as data — the render_check floor's vocabulary) and **`ligature-macros.json`** (typographic surjection data) |
| `packages/*/tests/**` | vitest suites with inline LaTeX cases + the 7 `.tex` / 3 `.snap` fixtures — the behavioral spec of every subsystem |
| `packages/*/package.json` | the dependency topology between members (who consumes whom — load-bearing for the merge) |
| `packages/*/README.md` | per-member API summaries (44 files, cheap) |
| `scripts/` | build mechanics worth understanding: `esbuild-pegjs-loader.mjs` (how grammars compile), `make-package.mjs` (publish layout), and **`table-generation/`** — the machinery that *generates* the support tables, i.e. a harvest pipeline already written |
| root `package.json`, `README.md`, `CHANGELOG.md` | workspace topology + version archaeology |

**Exclude — important, two of these are my pollution:** `node_modules/` at root **and per-package** (the 1,521-package install I ran), `packages/*/dist/` (build output present in some members), `.git`, `.github`, `examples/`, `test/` at root (that's cjs/esm *packaging* checks, not behavior), `package-lock.json`, `lerna.json`, and the per-package `tsconfig`/`typedoc`/`vite.config` scaffolding.

## Filetype summary for the snapshot profile

**`.pegjs`** (14 across both — the crown jewels), **`.ts`** (sources + tests), **`.d.ts`** (utensils' generated-parser declarations), **`.json`** only selectively (the two support-tables data files + `package.json` manifests), **`.tex`/`.snap`/`.log`** (fixtures), **`.md`** (per-package READMEs + roots).

One framing note for the analysis pass: the two support-tables files plus `scripts/table-generation/` are worth flagging in the manifest as their own group — they're evidence that upstream already treats knowledge-as-data with generation machinery, which is exactly the mechanism the superset engine's registry generalizes. When your snapshot is ready, point me at the `*_tree.md` manifest and I'll run the cross-project gap analysis against the eight-subsystem map.

---

# this is too complicated for reposnapshot at the moment, plus reposnapshot isn't meant to ingest docs with code, or pre-serialized formats like json or logs

Fair — pared to reposnapshot's lane, it collapses to two rules:

**latex-utensils** → `src/` and `test/`, filetypes `.ts` + `.pegjs` (≈24 + 3 files). That's the parsers, grammars, type contracts, and the behavioral tests; the `.log` fixtures and `sample/` fall away with the filetype filter.

**unified-latex** → `packages/`, filetypes `.ts` + `.pegjs`, excluding `**/node_modules/**` and `**/dist/**` (≈363 + 11 files). That one rule captures every member's `libs/`, `index.ts`, the 11 grammars, all the ctan `provides.ts` records (seed edit included), the type definitions, and the vitest suites — whose LaTeX cases live inline in `.ts`, so the behavioral spec rides along anyway.

Deliberately left behind, to read in place from the clones when a subsystem pass needs them: the two support-table `.json` data files, the `.log`/`.tex` fixtures, and the root `scripts/` build mechanics. None of them need to travel in the payload.

That's the whole spec — roughly 400 source files across both. Point me at the `*_tree.md` when the snapshot lands.

---

# ok i'm setting aside the target directories as copies under superset/ D:\aghado01\packages\node-latex-deps\superset, am i missing anything here

Staging is spec-clean now: **401 files — 387 `.ts` + 14 `.pegjs`**, nothing else. `latex-utensils/{src,test}` (the `bin` under `src` is CLI source, so it stays), `unified-latex/packages` with all 36 members. Everything pruned: node_modules, dist, `.git`, build output, and the json/md/log/tex types — so the support-table data files and log fixtures stay behind in the live clones for direct reads when a subsystem pass wants them.

That's snapshot-ready. Point me at the `*_tree.md` manifest once reposnapshot has run and I'll start the cross-project gap analysis against the reconciliation map.

---

# ok how does this look D:\aghado01\packages\node-latex-deps\superset\.snapshot\20260830_210200\superset_tree.md

The snapshot is sound. Verification against the staging: **401/401 files** (27 latex-utensils across s001–s002, 374 unified-latex across s003–s017), all 14 grammars present, clean per-project grouping, shards at the ~65KB quota (≈16K tokens each — good bite size). The seed-edited `latex2e/provides.ts` rode along at its expected ~12.3KB. One shard (s016) is a single 78KB row — that's `unified-latex-to-pretext.test.ts`, an unsplittable single file, by design.

Three minor notes, none requiring a re-run: the ~36 `vite.config.ts` files survived the `.ts` filter (~40KB of harmless build-config noise); a bench file rode along similarly; and upstream has a typo'd test filename (`unifiex-latex-attach-arguments.test.ts`) that legitimately exists in *two* packages — not a snapshot artifact.

More interesting: the manifest itself already **expands the reconciliation map** — the clone contains members that were never in our pinned set, and several are load-bearing for the engine:

- **`unified-latex-util-packages`** — `list-packages.ts`: a `\usepackage` inventory walker. That's the *summoning mechanics* for the knowledge registry, already written upstream.
- **`unified-latex-to-pretext`** — a large conversion machine (30+ files) with `break-on-boundaries`, `expand-user-defined-macros`, `replace-quote-ligatures`, `report-unsupported-macro-mathjax` — the most complete worked example of "LaTeX AST → structured document" in either codebase, directly adjacent to the codex markdown mission.
- **`unified-latex-cli`** — expansion plugins and an `enclosing-position` util (someone upstream also fought the position problem).
- **`unified-latex-lint`** — a rule framework: 9 rules with a uniform shape; relevant as prior art for the engine's diagnostics contract.
- The ctan members with **dialect parser code inside** (systeme, tikz, tabularx, listings, minted, xcolor — including a full color-expression evaluator and 22KB of predefined colors) — confirming the records-plus-parser duality the registry design has to accommodate. Also note `tabularx` exists as a package folder but never made it into the aggregate `macroInfo` — an upstream aggregation gap to verify during the pass.

Ready to start the cross-project analysis. My proposed first bite stays as argued: **argument model + position model** — utensils' `latex.pegjs` + `latex_parser_types.ts` read against unified-latex's `gobble-single-argument.ts`/`attach-arguments.ts` + the `util-parse` pipeline (`parse.ts`, `process-macros-and-environments.ts`, `reparse-math.ts`). That's ~8 rows, well within one pass, and it fixes the engine's AST contract. Say go and I'll dive.

---

# ok, lets begin the review, with the intention of potentially initializing a new TexDig project that will result from this synthesis, and will become a key dependency of codex-scientiae. keep in mind, im thinking open source project with the orientation of these packages being resuable tools for others to use, not just bespoke customizations for my immediate needs. i want to do this right

Beginning the review — and the open-source framing is now a design input: this isn't "patch what I need," it's "build the engine both upstreams should have been." I'll record the direction in memory, then pull the first bite from the snapshot: position model + argument model, the two rulings that fix the engine's AST contract.
## Review installment 1 — position model + argument model

Read this bite: both type contracts, utensils' Location/error/options layer, unified-latex's full parse pipeline (`parse` → `plugin-from-string` → `process-macros-and-environments` → `reparse-math`), and the argument machinery (`gobble-single-argument`, `attach-arguments`). Five findings, then draft rulings.

**F1 — The two projects are siblings, not strangers.** Both LICENSEs are MIT with the *same copyright line*: "Michael Brade, Jason Siefken" (utensils 2015–2019, unified-latex 2015–2022). They descend from one ancestral PEG grammar and diverged. Three consequences: licensing for the synthesis is trivial (MIT×MIT, preserve the shared attribution); the census's "two independent witnesses" were **less independent than assumed at the grammar tier** — common root, divergent evolution, so their agreement is weaker evidence than true independence would provide; and the OSS story writes itself — this is a family reunification, which is also *why* the node models rhyme well enough to merge.

**F2 — Upstream's default parse means "every package is always loaded."** `plugin-from-string.ts` flattens all ctan records: `Object.assign({}, ...Object.values(macroInfo), macros)`. No summoning, no scoping — and same-name collisions resolve silently by package insertion order (beamer and multicol, merged last, shadow everything). Your summon-site registry isn't house idiosyncrasy; it's a correctness improvement upstream visibly lacks. Engine registry: scoped activation, collisions as diagnostics.

**F3 — The position destruction isn't one defect; it's three mechanisms, all caught in this bite.** (a) `reparse-math.ts`: `arg.content = parseMathMinimal(printRaw(arg.content))` — prints content to a *new string* and reparses at offset 0. That single line is the local-frame class the corpus measured and the census's span-arbitration compensates for. Its guard, `wasParsedInMathMode`, is a heuristic (looks for multi-char strings or `^`/`_`). (b) `findBracePositions` splits multi-char string nodes via `cloneStringNode = Object.assign({}, node, {content})` — **the clone inherits the original's position while carrying different content.** Positions aren't dropped there; they're *falsified* — two nodes claiming one span. (c) `arg()` mints `Argument` nodes with no position, and in the group case discards the group node — whose exact extent, braces included, was in hand at that moment. All three violate one law, and all three become local fixes once locations are mandatory: slice-and-translate instead of print-and-reparse; split spans arithmetically when splitting strings; synthesized containers take the hull of what they consumed.

**F4 — The gobbler is genuinely good machinery worth keeping.** xparse-typed dispatch (mandatory/optional/star/token/until/embellishment), TeX-correct single-token mandatory arguments, a deliberate **right-to-left attachment scan** for right-associativity, an idempotency guard, and an `argumentParser` escape hatch for dialect packages. Gaps: multi-token `until` is unimplemented (a `console.warn` — the census implemented this; it can flow back), an unfound *mandatory* argument falls through into the optional path and silently yields null where TeX would error — wants a diagnostic, and `console.warn` is the entire error channel. The confession-ledger contrast in one line.

**F5 — utensils' law has one wrinkle the superset must out-strict.** `Space`/`Softbreak` carry `location: undefined` — whitespace is positionless, which the ledger invariant can't accept; the engine's law is stricter than either parent. And the frozen-knowledge problem is vivid in one type: `LabelCommand`'s name union is `'label'|'ref'|'eqref'|'autoref'|'cref'` — no `\Cref`, no `\vref`, can't extend without a grammar edit. Record-driven classification is confirmed as the fix. One nice precedent: `AstPreamble.rest` returns the unparsed remainder as a raw string — a crude but honest confession, ancestor of the residue ledger.

**Draft rulings (R1–R7)** for the engine's design doc: **R1** locations mandatory on every node, whitespace included — no constructor without a span. **R2** enrichment never prints-and-reparses; it slices source by span with frame translation. **R3** string splits split spans arithmetically. **R4** synthesized containers take the hull of consumed nodes. **R5** registry is scoped/summoned; collisions are diagnostics, never silent. **R6** semantic classification is record-driven, never grammar-frozen. **R7** the error channel is a diagnostics contract; nothing goes to `console.warn`.

**Next bite:** the grammar pair itself — utensils `latex.pegjs` (16.7KB) against unified's `latex.pegjs` (12.3KB), read side by side. That tests the shared-ancestor hypothesis directly, maps what each grammar knows that the other doesn't (verbatim family, math micro-structure, strictness, `#` parameter tokens — the catcode truncation likely lives there), and is the substrate every ruling above lands on. Say go, or redirect.

---

# ok go

## Review installment 2 — the grammar pair

Both grammars read in full. The comparison is unusually productive because they turn out to be *diffable* — and the diffs are exactly the corpus's conflict classes.

**F6 — Ancestry confirmed in the text itself.** Same `\[`/`\]` display-math productions, same verb arbitrary-delimiter trick (`end:. & {return end == e}`), near-identical math-env name lists, same `\0` catcode-9 ignore, same nonchar-token shape. These are one grammar's descendants, specialized by consumer: utensils toward *editor indexing* (positions, speed, strictness), unified toward *transformation* (mutable nodes, records). The synthesis has a common skeleton to merge back onto.

**F7 — The fault lines were visible in the grammar diff all along.** Each grammar hardcodes an *opposite default* on the same undecidable:

| fault | utensils | unified-latex | engine ruling |
|---|---|---|---|
| `@` in command names | **always** a letter (`(char/'@')+`) | **never** at grammar tier (patched later by region reparse) | catcode mode driven by tracked `\makeatletter` regions — the census already computes them (→R8) |
| star | absorbed into the name — even across space (`\section *`!) | left as a token; consumed later by argspec `s` | xparse model canonical; lexical star kept as a sighting (→R9) |
| `^`/`_` in text mode | typed nodes always | plain strings | mode-dependent, per the corpus ruling |
| `\par` | a `parbreak` node | an ordinary macro | parbreak — with the macro sighting preserved |

That table *is* the census's catcode-arbitration and conflict classes, discovered at their source. The engine replaces four hardcoded biases with explicit modes.

**F8 — T18 has upstream precedent.** utensils maintains *two* env lists: carriers (`equation`, `align`, `gather`, …) vs interiors (`aligned`, `cases`, `split`, `matrix` family — under a rule literally typo'd `mahtAlignedEnvName`). unified has one flat list that **misclassifies `split` as a carrier and omits the matrix family entirely**. The carrier/interior split your T18 wants is already half-built upstream; the engine makes it record-driven and fixes unified's misclassification.

**F9 — The argument strata are formally the two *bounds* of the true hull.** utensils' grammar attaches *greedily*: every adjacent group or `[…]` becomes an arg — the lexical **upper bound** on what the macro could consume. unified attaches only what records license — the knowledge-**exact** hull. Neither is wrong; they're the two ends of the estimate, and "agreement" is the signature confirming the lexical guess. That's the cleanest formal statement yet of the census's physical-token vs invocation-hull tiers, and it's what the engine's paired strata compute natively.

**F10 — Port-both-ways inventory.** unified wins: the comment model (ownline/sameline, leading-whitespace, parbreak-preserving — far richer than utensils' out-of-band comment map), inline verbatim commands (`\lstinline`, `\mintinline`, `\mint` — utensils lacks all three), `filecontents`, and a **position-total base grammar** (`createNode` stamps `location()` on every node — confirming bite 1: all position sins are enrichment-tier, the foundation is sound). utensils wins: `Preamble` start rule with honest `rest`, timeout checks *inside* productions, fast-path word/space optimizations, `\left…\right` and sized-delimiter typing, sub/superscripts *with attached argument* in math, `\def` parameter/body structure, balanced-brace URL strings, and grammar-level environment name-match strictness. Verbatim is half-done in each (utensils types the env family but not inline forms; unified parses both but types inconsistently — its minted env comes out as a generic `environment`) — the engine unifies the family. One shared defect: both tokenize text to their consumer's granularity (unified splits at punctuation and even re-parses numbers; utensils splits at brackets) — the engine emits maximal runs and leaves granularity to serialization.

**Rulings added:** **R8** catcode handling is an explicit lexer mode fed by tracked regions, never a hardcoded bias. **R9** star is an xparse argument; the lexical token survives as a sighting. **R10** math-env vocabulary is two-tier (carrier/interior), record-driven. **R11** comments are ledger-claiming typed nodes with unified's semantics. **R12** verbatim is one typed family across env and inline forms. **R13** text runs are maximal; granularity belongs to serialization. **R14** timeout and fast paths are kept; positions are never an opt-out flag.

**Next bite:** the compensation layer both projects grew around these faults — `util-catcode` in full (`reparse-macro-names.ts`, `special-regions.ts`, `regions.ts` — where the csname-truncation-near-`#` defect should be pinned to a line) plus `process-environment.ts` and the argspec parser, which completes the meaning tier. After that we're positioned to draft the engine's AST contract — the first real artifact of the new project. Go?

---

# ok next bite

## Review installment 3 — the compensation layer, and the truncation bug nailed

**F11 — The csname-truncation defect is now pinned to its exact mechanism.** `reparseMacroNamesInArray` repairs `@`-names *pairwise*: macro at `i`, string at `i+1`, glue if the macro's last char **or** the string's first char is in the allowed set. That gate assumes run-strings (`\m@th` → macro `m` + string `"@th"` → one glue). But **math mode's fallback emits single-char strings** — `\m@th` in math becomes `m` + `"@"` + `"t"` + `"h"` — and the repair walks: glue `"@"` (gate: `@`∈set ✓) → glue `"t"` (macro now ends `@` ✓) → try `"h"`: macro ends `t` ✗, string starts `h` ✗ → **stop. Result: `m@t`** — the corpus artifact, character for character. Letter-after-letter continuations can't pass a gate built for `@`-boundaries. So: the census's catcode arbitration compensates a repair layer that itself compensates a lexer-mode gap. Under R8 (catcode as a lexer mode over tracked regions — regions the census already knows how to find), *both* layers delete. One credit is due here: this file is the only code read so far that does **correct position arithmetic on mutation** (the partial-glue branch adjusts both nodes' offsets) — proof the discipline was achievable all along; it just wasn't a law.

**F12 — The region machinery beneath it has its own defects, and dissolves anyway.** `findRegionInArray` cannot nest — a second `\makeatletter` before `\makeatother` silently overwrites the first region's start, and an end-without-start pushes a region whose `start` is `undefined`. Regions are also computed per-array, so a region opened inside a group and closed outside can't pair. All moot under lexer-mode tracking, which handles nesting and crossing on the token stream naturally. Worth keeping from this layer: the mode *vocabulary* — upstream supports both at-letter (`@`) and expl3 (`_`, `:`), and the engine should too — and `refineRegions`' interval algebra as generic tooling if anything ever needs interval overlap again.

**F13 — argspec is near-complete, with three sharp gaps.** The grammar covers the full xparse zoo (`s t o O d D e E r R m v b u`, `!` no-leading-whitespace) and `printRaw` round-trips it. Gaps: the **`+` (long) prefix is parsed and then discarded** — `\long`-ness never reaches the record; **default arguments are flattened to printed strings** (`groupToStr`) — the origin of the corpus's lost-defaults class; and multi-token `until` is parsed by the spec grammar but unimplemented in the gobbler — the spec and the interpreter silently disagree about their own capability set.

**F14 — Environments reveal the record surface's third capability.** `processEnvironment` gobbles env arguments *from the head of the body* (grammar-tier env args live in content) using the same gobbler — good unification precedent — and then applies `envInfo.processContent`, meaning records can carry **content-transforming code**, alongside `signature` and `argumentParser`. Minor upstream sloppiness in the same file pair: the environments plugin warns with copy-pasted *macro* wording and carries a defensively dead throw.

**Rulings added.** **R15** — names lex mode-correctly at parse time; there is no post-hoc name-gluing layer in the engine, by design. **R16** — argspec records carry long-ness and *structured* defaults, and the spec grammar and gobbler must be proven capability-equal by a shared conformance table (spec feature ↔ interpreter case ↔ test), so they can never silently diverge again. **R17** — the record capability surface is declared and typed: `{signature, argumentParser, processContent, renderInfo, classification}` — five extension points, not an ad-hoc bag.

**Next bite — the definition/expansion machinery**, the last big unified-side algorithm block and the one the C-waves care about: `newcommand.ts` (12KB — how `\newcommand`/xparse definitions are read into specs), `expand-macros.ts` + `parse-macro-substitutions.ts` + the `macro-substitutions.pegjs` grammar (how substitution actually executes), and `info-specs.ts` (the `renderInfo` vocabulary — the record metadata R17 needs to absorb). ~17KB. After that, one closing bite on utensils' query/stringify layer + ligatures + to-mdast, and we're positioned to draft the engine's AST contract. Go?

---

# go

## Review installment 4 — definitions and expansion

**F15 — The expansion engine is more complete than its reputation, with one crude edge.** `createMacroExpander` parses the definition body once (hash-numbers become typed nodes — `#12` correctly reads as parameter 1 then "2", `##` de-doubles), applies **omitted-optional defaults** (an empty-marked argument plus a `defaultArg` triggers a parse of the default text), and handles arguments that reference *other* arguments by iterating substitution to a bounded fixed point (≤10 rounds). Leftover hash-numbers after that are circular references — and here's the crude edge: they're replaced with a literal string **`-Circular-` in the content**. A confession, but as payload, invisible to any gate. Same pattern as the gobbler's `console.warn`: upstream *detects* the pathological cases and then whispers.

**F16 — Third position-falsification mechanism found, and it's the biggest.** Expansion output is `structuredClone` of the cached definition body — so every expansion site receives **the definition site's positions, replicated verbatim**. Ten uses of `\foo` produce ten trees all claiming the definition's coordinates. Bite 1 found positions dropped (arguments) and forged-by-split (string clones); this is forged-by-replication. The fix shape is one the family already owns: expansion output is *derived content with an origin map* — {definition span, invocation span, per-argument provenance} — exactly doccer's `PieceOrigin` and the census's `exp:` origin chains, moved into the engine.

**F17 — `renderInfo` is four concerns wearing one name.** The full vocabulary (`info-specs.ts`): formatting hints (`breakAround`, `hangingIndent`), **parse-changing semantics** (`inMathMode` — it selects which macros get math-reparsed; it drives *parsing*, not rendering), argument-language flags (`pgfkeysArgs`, `sysdelims`), and documentation (`namedArguments`). Even the expansion defaults travel through `_renderInfo.defaultArg`. So records aren't metadata riding on the parse — they're parse *drivers* misfiled under a rendering name. That sharpens R17: the engine's record facets must be declared by role — parse-semantic, argument-language, serialization-hint, documentation — because upstream demonstrates what happens when they share a bag.

**F18 — The definition reader's vocabulary is narrower than the census already achieved.** `listNewcommands` sees `\newcommand`/`\renewcommand`/`\providecommand` plus the eight xparse forms (Expandable variants included — good), synthesizing xparse signatures from LaTeX-style definitions (`[n][default]` → `O{default} m…`, confirming the corpus fix). Beamer's overlay argument is handled by a **argument-count switch** with a positional-name table — functional, fragile, but the named-args-table idiom itself is worth keeping. Absent entirely: `\newenvironment` families, `\def`/`\let`, `\DeclareMathOperator`, `\DeclarePairedDelimiter` — all of which the census's dialect tier already reads. The engine's definition vocabulary is the census's superset, not upstream's. One genuinely novel pattern to keep: `macro-substitutions.pegjs` runs a **PEG grammar over an array of AST nodes** (via `decorateArrayForPegjs` with predicate options) — grammar-driven scanning of token streams, reusable machinery utensils has no equivalent of.

**Rulings added.** **R18** — expansion output is origin-mapped derived content (definition span + invocation span + per-argument provenance); circularity and non-convergence are typed diagnostic outcomes, never content strings. **R19** — record facets are declared by role; parse-changing flags like `inMathMode` leave the "render" bag. **R20** — the definition-reading vocabulary adopts the census superset (newcommand + xparse + newenvironment families, `\def`/`\let`, math-operator, paired-delimiter), each via the named-args table idiom.

**Closing bite next:** utensils' query/serialization layer (`find_all`, `matcher`, `stringify` — the position-query tooling R1 makes universal) plus the ligatures pair (`ligature-lookup`, `parse` + the support table linkage) and the `to-mdast` trio — the markdown terminal. ~20KB. The two remaining big algorithm blocks (`visit.ts`, `replace-streaming-command.ts`) I'd defer to implementation-time deep reads — they're internally coherent and their contracts are already visible from call sites. After the closing bite: **the engine's AST contract draft**, rulings R1–R20 applied, as the first artifact of the new project. Go?

---

# closing bite, go

## Review installment 5 (closing) — query layer, serialization, ligatures, and the markdown terminal

**F19 — utensils' `find()` has a real search bug.** The single-result `find` descends into the *first* child-bearing sibling and `return`s whatever that subtree yields — **including `undefined`** — so any match living in a later sibling's subtree is unreachable. `findAll` is correct (it concatenates); `find` abandons the search after one failed branch. Also noted: `getChildNodes` enumerates `content` before `args`, so traversal order isn't document order for environments, and `findNodeAt` silently *cannot* resolve positions inside `Space`/`Softbreak` — the location-less-whitespace wrinkle (F5) surfacing as a query-layer blind spot. R1 keeps earning its place.

**F20 — utensils' `stringify` is a cautionary tale about reconstruction serializers.** Three concrete lossiness bugs in one file: `\text{...}` serializes its Group argument by string concatenation — emitting literal **`\text{[object Object]}`**; every `Linebreak` prints as `\\` (the `name` field — `\\*`, `\newline`, `\linebreak[n]` — is dropped); `verbatim*` prints as `verbatim` (name ignored). Plus heuristic space insertion by lookahead. It reconstructs from typed fields and loses whatever the fields don't carry — exactly why the engine gets two serializers by role rather than one like this.

**F21 — the `Pattern` DSL is a keeper.** `pattern(guard).child(guard).matchAll(nodes)` with typed parent chains in the results — an ergonomic, typed query surface that composes beautifully with mandatory spans. Engine adopts the shape (on top of a fixed `find`).

**F22 — the ligature subsystem is the typographic surjection, and it has a hidden coupling to fix.** The machinery is complete and good: a PEG-over-node-arrays scanner (triple/double/mono rules, accent-macro + split-string handling), a substitution table covering dashes, curly quotes, guillemets, `\dots`, the full escape family, and Unicode *spacing* semantics (`\,`→U+2009, `\quad`→U+2003, `~`→NBSP), extended by the `ligature-macros.json` accent table — and it's correctly mode-gated (text only, via visit's built-in `inMathMode` context tracking, which is itself a note: unified's traversal is already mode-aware). The coupling: `--` is detected as *two adjacent single-char string nodes* — i.e., **ligature detection currently depends on the punctuation confetti** that R13 abolishes. Under maximal text runs, the scanner must find ligatures *inside* runs, substring-wise. The table survives; the detection basis changes. Also one bias to adjudicate: straight `"` maps unconditionally to a *closing* curly quote.

**F23 — the markdown terminal is a bridge, not a converter.** `to-mdast` = `to-hast` → `rehype-remark` with two handlers (inline math → raw `$…$` HTML node, display math → a fenced `math` code block). LaTeX→markdown detours through an HTML model, and the math comes out in neither your inline register nor your display convention. Verdict for the codex mission: upstream `to-mdast` is a comparison oracle, not the path — the convergent envelope needs a direct AST→mdast serializer under the house register, which the walk-realization design already anticipated. (`to-pretext`, per the manifest, is the better worked example of a *direct* structured serializer and stays on the implementation-time reading list with `visit.ts` and `replace-streaming-command.ts`.)

**Rulings added.** **R21** — two serializers by declared role: *source realization* slices spans (never reconstructs); *derived-content printing* uses typed printers proven by round-trip tests. **R22** — the typographic surjection is substring-capable (independent of tokenization granularity), mode-gated, and driven by the support-table data. **R23** — the markdown terminal is direct AST→mdast under the canonical register; the hast detour is retained only as an oracle.

## Review wrap

Reading phase complete — five installments, F1–F23, R1–R23, all grounded in source. One byproduct worth naming for the open-source posture: the review produced an **upstream gift list** — eleven concrete, reportable findings (the `find()` early-return, `\text{[object Object]}`, linebreak/`verbatim*` name loss, `m@t` truncation gate, non-nesting regions, the silent mandatory-arg fallthrough, the discarded `+`/long prefix, `split` misclassified as a carrier, `tabularx` missing from the aggregate, `latex2e` missing `title`/`author`, the copy-pasted warning). Filing those as issues/PRs against both upstreams — independent of the synthesis — is cheap goodwill and establishes the project's relationship with its ancestors before it ships anything.

Next per plan: **draft the engine's AST contract** — the node vocabulary, span law, strata, record facets, and output contract with R1–R23 applied. That's the first real artifact of the new project, and it wants to live in the project's own tree. Two things are yours before I write it: the project's name (it initializes `node-latex-deps/<name>` — you floated it becoming the new TeXdig), and whether the contract draft starts as a design doc in that tree or in chat for a round of discussion first.

---

# well , maybe there's a good reason for the HTML intermediate layer. Just because their implementation mangles my math register sensibilities doesn't mean we can't change that

Fair challenge, and on reflection you're right — I collapsed two different judgments into one verdict. Let me separate them.

**What the hast layer actually buys, architecturally.** Three real assets. First, ecosystem leverage: one conversion (LaTeX→hast) unlocks every rehype/remark consumer — markdown is just *one* of the targets that fall out, alongside HTML, DOM, highlighting, sanitization, and anything else that speaks unist. A direct LaTeX→mdast path serves exactly one target and forfeits the rest. Second, and more substantively: the hard structural work of converting LaTeX *at all* — streaming commands becoming scoped elements, paragraph wrapping, list/table linearization, flow-vs-phrasing normalization — happens once, in the `pre-html-subs` machinery we saw in the manifest, and rehype-remark's HTML→markdown logic is battle-tested against a decade of edge cases a bespoke serializer would rediscover one bug at a time. HTML's flow/phrasing content model is honestly a decent approximation of markdown's block/inline distinction. Third: the layer is *designed* for exactly the correction you're describing — `rehype-remark` takes handlers, and the register-mangling I complained about is a **15-line default handler file** that the options mechanism exists to override. Emitting `{type: "html", value: "$…$"}` and a `math`-language code fence was upstream avoiding a dependency, not an architectural commitment: swap the handlers to emit the `mdast-util-math` vocabulary (`inlineMath`/`math` nodes) and remark's own serializer renders `$…$` / `$$…$$` under configurable conventions — the house register becomes a *configuration of the existing stage*, not a bypass of it.

There's also a pattern-level point worth acknowledging: a staged pipeline through a source-neutral document model, with realizations rendered off it, is *your own architecture* — it's the same instinct that puts a settled intermediate between source and markdown in the codex design. Upstream landed on the same shape; they just picked hast as the neutral model and then under-invested in the markdown realization's defaults.

**What survives of the original finding.** Two facts, downgraded from verdict to acceptance criteria. The defaults don't meet the register — fixable as above. And the real question, the one that should decide this rather than my aesthetics: **does provenance survive the hops?** unist nodes all carry `position`, so the plumbing exists — but through `wrap-pars`, streaming-command scoping, environment substitution, and rehype-remark's restructuring, origin may thin from "span-mapped" to "roughly attributed." For an engine whose output contract is origin-mapped (R18, R21), the staged path has to *demonstrate* that a character in the emitted markdown can still name its source span, or say honestly where it can't. That's testable, not arguable.

**R23, revised:** the markdown terminal keeps the staged architecture (LaTeX AST → document model → mdast → serialization); the math register is enforced through the handler/serializer configuration surface, using the standard math node vocabulary; and the stage boundary carries an explicit provenance requirement — each hop preserves or explicitly degrades origin, audited, with a direct serializer remaining only as the fallback if the audit fails structurally rather than fixably. The upstream default handlers move to the gift list as a contribution candidate (register-correct math handlers would benefit every downstream user, not just us).

The provenance audit is concrete work I can do from the snapshot when we get there — `unified-latex-plugin-to-hast`, `wrap-pars`, `streaming-command-subs`, and `katex-subs` are all in the shards, and the question "where does position stop flowing" is answerable by reading them the same way we read everything else. I'd slot it into the contract-drafting phase, since the output contract's origin-map clause depends on the answer.

---

# well, regarding latex-utensils, at least one thing i think they have to offer is the more complex bibliography-related files coverage. that was the main reason i pulled latex-utensil in in the first place. unless there was something i overlooked at the time in unified-latex

Good question to pin down precisely — let me check the one bib-adjacent thing unified-latex *does* have, which we flagged in the manifest but haven't read: `to-pretext`'s `biblio-csl.ts` and `bibinfo.ts`. That's the candidate for "something overlooked."
Checked precisely, and your original judgment stands: **you overlooked nothing.** unified-latex has zero BibTeX-language capability — no bibtex grammar among its eleven, no bibtex member among its 36 workspaces. utensils' `bibtexParser` is the pair's only `.bib` instrument, and it's a good one: typed entries, `@string`, `@preamble`, value kinds including abbreviation references and `#`-concatenation — parse-only, with resolution (`@string` substitution, concat, crossref inheritance) left to the consumer, which the census already planned to own and which now becomes an engine feature.

But the read turned up what unified-latex *does* have, and it's more interesting than a parser — `biblio-csl.ts` is an **un-renderer**. It takes the LaTeX AST of formatted `\bibitem` bodies — i.e., bibtex's *output*, a `.bbl` where the style has already executed and destroyed the field structure — and abducts CSL metadata back out of typographic convention: `\newblock` segmentation into author/title/rest, *emphasis means title* (or container-title later in the entry), *bold number means volume*, regex harvest of DOIs, URLs, page ranges, parenthesized years, "vol./no./ed." markers, author-list splitting on "and"/"&" with comma-inversion, particle (`van`/`von`/`della`…) and suffix (`jr`/`III`) handling, `\bysame` resolving to the previous entry's authors, and a final classify into article-journal/book/webpage/document.

That's worth pausing on doctrinally: **a styled `.bbl` sits on the rendered side of its own little rendering pathway**, and upstream had to build abduction-from-typography to cross back — inside the LaTeX lane. Which maps exactly onto your reference witness-ladder: when you hold the `.bib`, you read *declarations*; when you hold only the styled `.bbl`, you *abduct*; when you hold both, they're two witnesses of the same bibliography to fuse under T3 identity. The declarative half of that ladder is utensils; the abductive half turns out to already exist in unified-latex — undisciplined (it returns `null` silently on entries it can't crack, guesses its classification, and its heuristics are anglophone-biased), but real machinery worth keeping and putting under confession.

So the engine's bibliography subsystem assembles as:

- **`.bib`** — utensils' parser ported as a member, plus the small resolution passes as engine semantics.
- **bibtex-styled `.bbl`** — parses as LaTeX everywhere; `biblio-csl`'s conventions become the abduction tier, upgraded to emit diagnostics instead of silent nulls.
- **biber-styled `.bbl`** (`\entry`/`\field`/`\strng` vocabulary) — covered by *neither* upstream, corpus-proven need from `2210.00916v2`: net-new engine coverage, and a genuine differentiator.
- **Cite-command surface** — natbib/biblatex records via the registry (already on the gap list).

**R24:** the bibliography subsystem treats `.bib` as declaration (parse + resolve), styled `.bbl` as abduction-with-confession, biber `.bbl` as a first-class dialect, and fuses coexisting sources as witnesses under normalized-ordinal identity.

Two small bonuses from the same read: `bibinfo.ts`/`author-info` is a frontmatter gatherer (`\author`/`\email`/`\keywords`/`\subjclass` → structured frontmatter) relevant to that channel's design — and notably, all of this machinery is built *on the `htmlLike` intermediate encoding* and internally reuses `parseLigatures` during text flattening, which quietly corroborates your defense of the staged intermediate from last turn: it's what upstream's own most sophisticated conversion work is written against.

---

# well, if a bbl is closer to the rendered side, woudln't it be easier to just convert that into the markdown formatted reference section?

Yes — and that observation puts the abduction machinery back in its proper, much smaller place. I over-valued it last turn because it's impressive machinery; you've just pointed out it's solving *upstream's* problem, not yours. PreTeXt is a structured format that **demands** fields — `<author>`, `<title>`, `<volume>` — so upstream had no choice but to abduct structure out of the styled text. Markdown demands nothing of the kind. A markdown reference section is *formatted text*, and the styled `.bbl` already **is** the formatted text — the exact rendering the paper's own toolchain produced, in the style its readers saw. Converting it is nearly the identity surjection, same as prose: `{\em title}` → emphasis, bold volume → bold, `\url` → link, `\newblock` → separator, ligatures through the standard table. Faithful-not-filtered even settles the style question: re-rendering references in some *other* style from abducted fields would be editorial work the transcription tier has no business doing.

What survives from the structured side is only the **envelope**, and it's cheap and deterministic: `\bibitem` boundaries, keys, optional-arg labels, and order — which is exactly what T3 needs to anchor inline citations to entries, and exactly what your witness-ladder already assigned the `.bbl` ("order/label oracle"). Entry *boundaries* yes; field *abduction* no. Your own canon had this right before I got excited about the shiny parser.

One honest asymmetry to keep in view, because it inverts the picture: **biber `.bbl` is not on the rendered side.** `\entry`/`\field`/`\strng` is a data format — biblatex executes the style *inside the document compile*, so for biber papers the styled reference text exists nowhere in any source artifact. There, "just convert the rendered side" has nothing to convert: the markdown section must be *generated* from fields under some convention. That's the one place a formatting decision is unavoidable — so it gets made once, declared as a house rendering convention rather than hidden, and flagged on the output as generated-not-transcribed. The two `.bbl` dialects thus take opposite paths for a principled reason, not an accident.

And the abduction tier (`biblio-csl`-descended) demotes to **optional enrichment on the library plane**: structured metadata for catalogs, cross-referencing, and resolving references against external indices — where `.bib` declarations rank first when they exist and abduction is the fallback when only a styled `.bbl` does. It never touches the document text.

**R24, revised:** the destination path for references is `.bbl` envelope (boundaries, keys, labels, ordinals per T3) plus per-entry body through the standard prose surjection — faithful to the paper's own styling; biber `.bbl` renders from fields under a single declared house convention, marked as generated; field-level structure recovery is an opt-in enrichment for the metadata plane (`.bib` declarations first, styled-`.bbl` abduction as fallback), never a dependency of conversion.

There's a generalizable principle in what you just did, worth carrying into the contract draft: **the destination's demand sets the recovery bar** — structure recovered beyond what the destination requires is enrichment, opt-in and priced separately, never on the critical path. It's the same cut that kept theorem-hood out of the base node vocabulary and macro semantics out of the prose spine.

---

# <command-name>/model</command-name>
            <command-message>model</command-message>
            <command-args>claude-sonnet-5</command-args>

---

# <local-command-stdout>Set model to claude-sonnet-5</local-command-stdout>

---

# <command-message>chat-export</command-message>
<command-name>/chat-export</command-name>
<command-args>to `D:\aghado01\codex-scientiae\issues\TeXdig` with thinking</command-args>
