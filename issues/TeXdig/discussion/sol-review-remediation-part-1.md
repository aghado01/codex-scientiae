# ok, unleash the swarm

## Review verdict

TeXdig should pause cut-2 feature work. There is no P0, but several P1 defects mean the current stores cannot yet be treated as exact, durable evidence. The central problem is not the unresolved Agy design queue; it is that source attribution, spans, witness agreement, and binding chronology can already be false while all tests and gates pass.

### Release-blocking findings

1. **[P1] Frozen tree attribution is not verified.**
   TeXdig copies the manifest hash and checks only file count in [census.ts](/D:/aghado01/codex-scientiae/src/TeXdig/cli/census.ts:95). The seven-file fixture declares `123456…`, actually hashes to `7446a9cf…`, yet the emitted summary retains the fake value. Content can therefore change without changing the job identity or reported provenance.

2. **[P1] The final macro signature rewrites earlier syntax.**
   A document-global last-definition-wins registry is built in [parse-latex.ts](/D:/aghado01/codex-scientiae/src/TeXdig/census/parse-latex.ts:361) and reused for every source in [census.ts](/D:/aghado01/codex-scientiae/src/TeXdig/cli/census.ts:152). In the independently reproduced changed-arity case, an early `\foo{x}` swallowed the later `\renewcommand` as argument two, yielding span `26–63` and still reporting `agreement:"agreed"`.

3. **[P1] Expansion does not implement a chronological binding model.**
   [expand.ts](/D:/aghado01/codex-scientiae/src/TeXdig/elaborate/expand.ts:139) separates elaborable definitions and aliases, rather than comparing all binding events. Focused probes confirmed:
   - Later `\def` or `\let` bindings lose to older `\newcommand` bodies.
   - `\let` follows the target’s later redefinition instead of capturing its meaning.
   - Dormant nested definitions become globally active.
   - `\providecommand` overwrites existing definitions.
   - Group-local definitions leak globally.
   - Fixed-point expansion can see future definitions.

   Extracting the current resolver into a shared helper would consolidate incorrect semantics.

4. **[P1] Trusted entities can carry foreign-coordinate body spans.**
   [parse-latex.ts](/D:/aghado01/codex-scientiae/src/TeXdig/census/parse-latex.ts:633) validates an environment’s outer span but derives `bodySpan` from untrusted local-frame child coordinates. The fixture’s `cases` entity spans `717–791` while its body spans `1–48`; an existing 34-document artifact contains the same failure.

5. **[P1] Empty explicit syntax disappears.**
   [argContentSpan](/D:/aghado01/codex-scientiae/src/TeXdig/census/parse-latex.ts:148) returns nothing for empty content. Consequently:
   - `\newcommand{\foo}{}` is truncated from 19 characters to span `0–17`.
   - `\foo{}` becomes a token-only invocation.
   - `[1][]` loses its declared empty default.

   This breaks exact slices, argument substitution, fingerprints, and future pointer identity.

6. **[P1] “Agreed” does not establish compatible witnesses.**
   Fusion in [reconcile.ts](/D:/aghado01/codex-scientiae/src/TeXdig/census/reconcile.ts:147) often matches only by start offset. Different math or BibTeX extents can therefore be marked agreed. Separately, [Bib fields](/D:/aghado01/codex-scientiae/src/TeXdig/census/reconcile.ts:872) inherit their entry’s agreement despite carrying only one parser witness, inflating agreement summaries.

7. **[P1] `parsed:true` does not imply parsed or coverage-audited.**
   [source-graph.ts](/D:/aghado01/codex-scientiae/src/TeXdig/census/source-graph.ts:56) classifies `.sty/.cls/.dtx` as LaTeX but stratifies only `.tex/.bbl`; explicitly input styles are parsed raw, so comments and verbatim can mint entities. Exact `\input{fragment.txt}` targets are labeled parsed but skipped by the CLI entirely.

8. **[P1] Valid and inert LaTeX syntax are confused.**
   Confirmed cases include:
   - Missing `\input {chapter}` and `\addbibresource[options]{refs.bib}` in [source-graph.ts](/D:/aghado01/codex-scientiae/src/TeXdig/census/source-graph.ts:188).
   - Valid `\begin {equation}` disappearing in [scan-latex.ts](/D:/aghado01/codex-scientiae/src/TeXdig/census/scan-latex.ts:285).
   - `alltt` being wholly masked even though commands remain active.
   - Brace-delimited `\verb` leaking false include commands through [stratify.ts](/D:/aghado01/codex-scientiae/src/TeXdig/census/stratify.ts:112).

9. **[P1] Filesystem enumeration can change artifact semantics.**
   Recursive `readdirSync` output is unsorted in [source-graph.ts](/D:/aghado01/codex-scientiae/src/TeXdig/census/source-graph.ts:74). It controls source rows, signature merge winners, and unsorted expansion emission. Nested includes also prefer the containing file’s directory before the compilation root, potentially selecting a different source than the actual build.

10. **[P1] Expansion has no output-size budget.**
    [expand.ts](/D:/aghado01/codex-scientiae/src/TeXdig/elaborate/expand.ts:330) limits rounds, not nodes or text. A doubling recursive definition can grow toward \(2^{25}\) nodes; count-stable recursion is mislabeled `partial` rather than non-converging.

### Material P2 findings

- Xparse defaults/delimiters, paired delimiters, `newenvironment` ending bodies, and starred math operators are marked elaborable without faithful attachment or expansion.
- `alignat`/`alignat*` are absent as math carriers; Bib entries never receive their declared interior `bodySpan`.
- [macros.ts](/D:/aghado01/codex-scientiae/src/TeXdig/compile/macros.ts:62) produces unsound dependency edges for self, forward, nested, and rebound definitions.
- [traversal.ts](/D:/aghado01/codex-scientiae/src/TeXdig/compile/traversal.ts:44) collapses repeated include occurrences.
- [coverage.ts](/D:/aghado01/codex-scientiae/src/TeXdig/census/coverage.ts:50) silently clips foreign, negative, and overlong spans, allowing coverage gates to pass corrupted evidence.
- [claims.ts](/D:/aghado01/codex-scientiae/src/TeXdig/census/claims.ts:35) emits floats only as fences although the contract requires fence plus envelope.
- The scanner always treats `@` as a control-word letter outside `\makeatletter`.
- Whole-file parse diagnostics lack structured source identity; malformed UTF-8 is silently converted to U+FFFD.
- Emission has landed, but no TeXdig schemas exist in the normative registry promised by [contracts.ts](/D:/aghado01/codex-scientiae/src/TeXdig/core/contracts.ts:7) and [README.md](/D:/aghado01/codex-scientiae/src/TeXdig/README.md:79).
- [emit.ts](/D:/aghado01/codex-scientiae/src/TeXdig/census/emit.ts:41) overwrites stores sequentially and non-atomically. A failed rerun can leave a stale summary alongside partially replaced stores.
- The adapter records a resolved Node path only as metadata; [run-census.ps1](/D:/aghado01/codex-scientiae/src/TeXdig/run-census.ps1:143) resolves `node` again in the child environment.

## Assessment of the Agy report

The report is directionally strong, but its sequencing is premature.

| Claim                                             | Verdict                                                                                                                       |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Environment definitions lack compiled IDs         | Confirmed                                                                                                                     |
| Argument delimiter metadata is lost               | Confirmed, but `bracketed:boolean` is insufficient; `{`, `[`, bare-token, implicit-star, and empty forms must remain distinct |
| Paragraph identity is erased                      | Confirmed; a walk blocker                                                                                                     |
| Seq renumbers as requested addresses change       | Confirmed                                                                                                                     |
| Governing-resolution logic is duplicated          | Confirmed, with deeper semantic disagreements                                                                                 |
| `cases` disagreements are resolved, nothing to do | Refuted; token agreement improved, but body coordinates remain corrupt                                                        |
| `\let` chains are not followable from macros      | Qualified; some dependency links exist, but capture semantics and governing provenance are wrong                              |
| Empty-body fingerprint is itself defective        | Qualified; the definite bug is the missing/truncated body span, while empty-hash policy remains an owner decision             |
| Repeated includes may affect the snapshot         | Resolved negatively for this snapshot: 25 resolved include/input edges, zero repeated resolved targets                        |
| 100% expansion means incomplete population        | Confirmed and strengthened; some “expanded” rows are also semantically wrong                                                  |

## Recommended repair order

1. **Restore evidence integrity:** recompute or explicitly verify tree fingerprints; strict decoding; deterministic enumeration; `parsed ⇒ parser + coverage`; atomic publication.
2. **Repair census syntax and spans:** site-time signatures, explicit empty/bare/delimited arguments, containment invariants, source-attributed diagnostics, and kind-specific witness equivalence.
3. **Design one chronological binding-event model:** direct definitions, non-elaborable shadowing, `\let` capture, `providecommand`, scoping, nested activation, repeated occurrences, and expansion size limits.
4. **Lock durable contracts:** register schemas and golden validation, then resume pointers, zones, parbreak/walk, and the remaining owner decisions.

## Verification and state

- Pester 6 direct run: **52/52 passed**, recorded in [pester.xml](/D:/aghado01/codex-scientiae/artifacts/test-runs/20261208_192848_texdig-review/direct/pester.xml).
- Batch executor: **2/2 jobs passed**.
- Existing [34-document snapshot](/D:/aghado01/codex-scientiae/artifacts/texdig-runs/batch-20260812_132923) was queried narrowly; no full corpus rerun was performed.
- Every `src/TeXdig` implementation file was assigned and reviewed. High-risk census findings were independently reproduced.
- No source edits, staging, or commits were made. The ignored review test artifacts were retained. An unrelated modification to `issues/mcp-servers/rate-policy.md` appeared during the review, and the untracked last-turn file remains; both were left untouched.

# alright lets make a scoped, multi-step/waved plan for a swarmed remediation of these issues to get TeXdig in shape for the next round of development

The right remediation is an eight-wave `0.2` migration. It separates physical source evidence from runtime occurrences before repairing bindings or expansion:

`raw bytes → physical census → source occurrences → binding events → invocation occurrences → expansion`

This supersedes the sequencing in the [Agy report](/D:/aghado01/codex-scientiae/issues/TeXdig/discussion/agy-cut23-lane-scoping-20260812_133800.md) using the defects established by the [swarm review](/D:/aghado01/codex-scientiae/issues/TeXdig/briefs/sol-texdig-cut1-review-20260812.md).

## Program boundary

In scope:

- Source identity, decoding, graph construction, stratification, spans, witnesses, claims, and coverage.
- Occurrence-aware traversal and chronological binding.
- Site-time argument attachment and bounded expansion.
- Registered schemas, deterministic output, atomic publication, runner/adapter reproducibility.
- Focused fixtures, canaries, and final 34-document validation.

Deferred:

- `zones.jsonl`, `pointers.jsonl`, `walk.jsonl`, references, graph projection, and KaTeX/TikZ validation.
- Full TeX execution: arbitrary conditionals, dynamic `\csname`, catcode mutation, constructed include paths, and complete xparse processors.
- A `0.1 → 0.2` JSONL converter. Missing arguments, corrupt coordinates, and occurrence history cannot be reconstructed.
- Dependency upgrades unless a pinned unified-latex utility demonstrably cannot satisfy the new contract.

## Wave 0 — Freeze the `0.2` contract and red witnesses

Recommended decisions:

1. A physical `macro-invocation` entity spans its control-sequence token, not a binding-dependent hull.
2. Add occurrence-tier identities:
   - `occ:` — one execution occurrence of a physical source.
   - `bind:` — one definition/binding event.
   - `inv:` — one invocation occurrence with its governing binding, actual syntax hull, and typed arguments.

3. `seq` is a bundle-local projection over occurrence addresses, never persistent identity.
4. `macros.jsonl` becomes declaration/specimen evidence. Replace binding-claiming `deps` with lexical `nameRefs`; execution order belongs in `bindings.jsonl`.
5. `\let` captures its governing meaning at assignment time. Unsupported definitions still install opaque meanings and shadow older definitions.
6. Nested, conditional, and unsupported scoped definitions remain cataloged with context but do not speculatively mutate the environment.
7. Arguments distinguish mandatory/optional/star, explicit/omitted, brace/bracket/bare/implicit, full extent, content extent, and derived default.
8. Known empty bodies hash the empty body; absent or unknowable bodies have no body fingerprint.
9. Environment definitions use `def:` identity with a `defines:"macro"|"environment"` discriminator.
10. Preserve an exact paragraph-break evidence record now; construction of walk paragraphs remains deferred.
11. Keep zone validation `skipped` until Cut 3.

Work:

- Root freezes [types.ts](/D:/aghado01/codex-scientiae/src/TeXdig/core/types.ts), [contracts.ts](/D:/aghado01/codex-scientiae/src/TeXdig/core/contracts.ts), schema IDs, and summary/store-version conventions.
- Add separate test containers for source fidelity, witness fusion, traversal, binding, expansion, and emission.
- Capture every reviewed P1 as a failing focused witness. Do not commit a deliberately red main state; land each test with its repair.

Exit gate: field shapes, ID grammar, supported-semantics cutline, migration policy, and test matrix are frozen.

## Wave 1 — Trusted source and publication boundary

Parallel lanes:

- Source lane: buffered source snapshot, canonical tree fingerprint, strict decoding, deterministic inventory, directive scanner, root-relative resolution, reached-file classification.
- Runtime lane: explicit Node executable propagation, runtime version recording, staging-directory emission, schema validation, atomic publish, refusal to overwrite an existing bundle.
- Root: integrate through [census.ts](/D:/aghado01/codex-scientiae/src/TeXdig/cli/census.ts), [emit.ts](/D:/aghado01/codex-scientiae/src/TeXdig/census/emit.ts), runner, and adapter.

Required behavior:

- Read source bytes once; compute the canonical tree digest from those exact buffers.
- Refuse manifest hash or count mismatch before analysis.
- Parse every successfully reached `\input` target as effective LaTeX regardless of suffix.
- `parsed:true` only after decoding, analysis, claims, and coverage succeed.
- Sort portable paths ordinally and reject case collisions.
- Support `\input {x}`, `\include {x}`, and `\addbibresource[options]{x.bib}`.
- Synchronize compile-root resolution semantics with the necessary logistics/procurement seams.
- Treat in-tree reached styles/classes as source evidence; configured CTAN declarations remain separate external candidates.

Exit gate:

- Same-count mutations and renames are refused.
- Fixture manifest contains its real fingerprint.
- Invalid UTF-8 cannot become replacement text.
- Two identical runs produce byte-identical published bundles.
- Interrupted emission cannot leave a valid-looking partial bundle.

## Wave 2 — Exact spans and honest evidence

Parallel lanes:

- Span lane: new shared span validation/hull primitives, diagnostic source attribution, pre-emission invariant checking.
- Parser lane: empty arguments/bodies, environment bodies, exact declaration syntax, definition context.
- Fusion lane: kind-specific witness equivalence and agreement basis.

Changes:

- Remove the global final-signature registry from physical census parsing.
- Preserve zero-length content spans inside nonempty explicit delimiter extents.
- Reject or omit corrupt derived spans; never serialize them.
- Require every nested span to be same-source and contained by its owner.
- Match witnesses by construct-specific identity, not common start offset.
- Distinguish two-instrument agreement from configured or stratifier authority.
- Remove inherited agreement from Bib fields.
- Fix `@` catcode state, escaped math closers, CRLF paragraph detection, whitespace environment fences, `alltt`, and brace-delimited `\verb`.
- Invalid coverage claims receive no credit and produce defects rather than being clipped.

During this cutover, any binding-derived store that cannot satisfy `0.2` is omitted and declared deferred. Known-false legacy expansion must not be retained merely to keep the store present.

Exit gate:

- Zero invalid primary or nested spans in fixtures.
- The `cases` body is contained or explicitly omitted with a diagnostic.
- Empty `{}` and `[]` survive.
- No same-start/different-extent entity is called agreed.
- Agreement summaries recompute exactly from emitted evidence.

## Wave 3 — Complete physical census and occurrence traversal

Three parallel lanes:

1. BibTeX:
   - Quote/escape-aware entry scanner.
   - Entry interiors, field/value witnesses, concat parts.
   - Explicit versus implicit comments.
   - Document-wide collision diagnostics.

2. LaTeX carriers:
   - Top-level versus interior math-environment vocabularies.
   - Two-body environment definitions.
   - Paragraph-break evidence.
   - Float fence-plus-envelope claims.
   - Validated coverage algebra.

3. Occurrences:
   - New `occurrences.jsonl`.
   - Active-stack cycle detection instead of global `visited`.
   - Repeated and diamond includes produce distinct occurrences.
   - Sequence keys use `(occurrenceId,startUtf16)`.
   - Includes inside dormant definition bodies do not execute.

Exit gate:

- Double/diamond includes remain distinct; cycles terminate deterministically.
- Every `parsed:true` source has exactly one coverage row.
- Every fenced Bib entry has a contained interior.
- No one-witness Bib field claims two-witness agreement.
- Every float has both required claims.
- Permuted source/edge inputs produce identical stores.

## Wave 4 — Chronological binding compiler

Primary additions:

- `compile/binding.ts`
- Reworked [macros.ts](/D:/aghado01/codex-scientiae/src/TeXdig/compile/macros.ts)
- `bindings.jsonl`

The compiler consumes declaration evidence in occurrence order and emits each operation’s outcome:

- installed
- skipped-existing
- invalid-precondition
- opaque
- deferred
- unsupported

Initial supported semantics:

- Correct `new`, `renew`, and `provide` preconditions.
- Definition-time `\let` capture.
- Top-level `def`-family and paired-delimiter declarations install opaque meanings when not elaborable.
- Configured candidates activate at their package/class summon sites rather than through global `Map.set`.
- Nested, conditional, and unimplemented scoped effects remain explicit and conservative.
- Ordinary body references resolve at call time.

Exit gate:

- Later `\def` and `\let` block fallback to older `\newcommand`.
- Alias capture survives target redefinition.
- Dormant nested definitions never activate lexically.
- Forward body references cannot see future definitions.
- Every binding outcome links to physical declaration and occurrence provenance.

## Wave 5 — Site-time invocation attachment

Add an occurrence-level `invocations.jsonl` or equivalent frozen contract from Wave 0.

For every runtime macro token:

- Resolve the governing binding event.
- Select that event’s signature.
- Attach raw syntax at that occurrence only.
- Preserve typed slots and derived defaults separately.
- Link back to the physical token entity and occurrence.
- Emit truthful unsupported-signature outcomes for exotic xparse forms.

Initial supported grammar: verified `m`, `o`, `O{…}`, and `s`, plus paired-delimiter `s o m` attachment. Paired-delimiter elaboration may remain unsupported.

Exit gate:

- An early one-argument call remains exactly itself after a later two-argument renewal.
- The same physical site may have different occurrence attachments under repeated inclusion.
- Empty and bare-token arguments survive exactly.
- No invocation hull crosses a later definition or unrelated structural construct.
- Census, binding, and invocation resolution name the same governing event.

## Wave 6 — Event-driven, resource-bounded expansion

Rewrite [expand.ts](/D:/aghado01/codex-scientiae/src/TeXdig/elaborate/expand.ts) around binding events and invocation rows.

Required outcomes include:

- `expanded`
- `partial`
- `unbound`
- `bound-out-of-scope`
- `unsupported`
- `non-converging`
- `budget-exceeded`
- `toolkit-error`

Use versioned configuration data for substitution steps, depth, AST nodes, derived UTF-16 length, include depth, and occurrence count. Provisional ceilings should be calibrated on canaries before being frozen.

Exit gate:

- Direct, mutual, stable-count, and growing recursion terminate truthfully.
- Future definitions are invisible to earlier calls.
- Aliases inside expanded bodies use captured meanings.
- Definition-body mentions do not become runtime expansions.
- Literal `\#1` is not treated as a parameter token.
- Expansion candidate, attempted, and status totals reconcile exactly.

## Wave 7 — Release-candidate verification

First run focused tests through both public paths:

1. Exact Pester files through `tests/run.ps1`.
2. The same files through `tests/parallel.ps1`.
3. Complete `tests/TeXdig`.
4. JSON Schema conformance.
5. Two-run bytewise determinism.
6. Affected logistics, procurement, and batch-adapter containers.

Then run four canaries:

- `2205.11338v3-6755463e96a8` — includes and style/class files.
- `2210.00916v2-521045695046` — `addbibresource`, Bib and BBL.
- `2111.15058v3-54250eec3f99` — substantial Bib evidence.
- `1810.02906v1-ca4acf0a74c1` — known float specimen.

The full 34-document rerun is a separate final authorization gate. Audit it with targeted `jso-jackson` invariant and delta queries.

Corpus acceptance:

- Manifest and recomputed fingerprints agree.
- Zero invalid or non-contained emitted spans.
- Zero agreed rows violating their declared evidence policy.
- Parsed-source/coverage bijection holds.
- Summaries and store row counts recompute.
- All stores validate against registered schemas.
- Every bundle is complete, atomic, and deterministic.
- Expansion failures are explicit outcomes, not silent exclusions.
- ID/count changes are classified as expected `0.1 → 0.2` migration effects or investigated defects.

## Swarm operating model

To avoid shared-worktree collisions:

| Owner           | Exclusive files                                                                                                      |
| --------------- | -------------------------------------------------------------------------------------------------------------------- |
| Root integrator | `core/types.ts`, `core/contracts.ts`, `cli/census.ts`, `census/emit.ts`, schemas, README, runner/adapter integration |
| Source lane     | source snapshot/graph, stratifier, LaTeX scanner, claims, coverage, upstream resolution parity                       |
| Witness lane    | span primitives, parsers, reconciliation, configured declarations, backfill, Bib scanner/evidence                    |
| Binding lane    | occurrence traversal, binding compiler, macros, argument attachment, expansion, limit config                         |

Rules:

- Freeze interfaces before dispatching each wave.
- No file has two writers within a wave.
- Agents do not stage, commit, or run broad suites.
- Root stages named paths only and commits green wave results directly to `main`.
- One cohesive commit per lane plus at most one integration commit per wave.
- Preserve unrelated worktree changes.
- Test artifacts remain under `artifacts/test-runs/YYYYDDMM_HHmmss[_NN]`.

## Agy decision disposition

Remediation absorbs D1, D3, D4, D9, and D11–D15 into the new source/occurrence/binding contracts. D2 and D5–D8/D10 remain feature-round decisions. D16 remains `skipped` until Cut 3.

TeXdig is ready for the next development round only after Wave 7. At that point pointers, zones, and walk can be rescoped against trustworthy invocation, binding, and paragraph evidence instead of compensating for `0.1`.

No files were changed while preparing this plan. The next bounded action, when authorized, is **Wave 0 only**.

# ok, plan approved. lets execute the first 3 waves and then re-assess the planning based on the results

## Remediation

Waves 0–2 are accepted and committed to `main` as `09b5468` (`harden TeXdig physical census baseline`).

Key outcomes:

- `texdig-census/0.2` is now a physical-token-only, source-regenerated contract.
- Exact buffered bytes, source hashes, canonical tree hash, UTF-16 coordinates, deterministic ordering, and worker-side tree confinement are enforced.
- Witness fusion uses kind-specific equivalence; non-agreed entities require linked diagnostics.
- Six normative stores have registered schemas, exhaustive runtime validation, atomic no-clobber publication, pinned Node identity, and an exact 11-store deferred surface.
- Binding-derived invocation hulls, expansion, macros, and traversal artifacts remain honestly deferred.
- Unrelated ingestion relocations remain untouched.

Verification: **103/103 tests passed across 7 public batch containers**, with zero failures, errors, or skips. Static gates covered 23 TypeScript files, 8 PowerShell files, 6 schemas, and a clean diff check. Evidence: [accepted batch run](/D:/aghado01/codex-scientiae/artifacts/test-runs/20261208_223812_texdig-waves012-accepted).

### Reassessed next waves

1. **B0 — Contract and declaration-evidence lock**

   Decide occurrence/scope IDs, declaration operations, configured-package chronology, environment-definition policy, and `bound-out-of-scope` basis. Also reconcile the remaining upstream containing-file resolver in [latex.py](/D:/aghado01/codex-scientiae/src/procurement/source/latex.py:208) with TeXdig’s compile-root semantics.

2. **B1 — Occurrence traversal**

   Represent repeated includes and explicit cycle cuts without duplicating physical entities.

3. **B2 — Chronological binding interpreter**

   One authoritative resolver for shadowing, `new`/`renew`/`provide`, group restoration, `\gdef`, dormant nested definitions, opaque bindings, and exact `\let` capture.

4. **B3 — Invocation attachment**

   Produce occurrence-specific hulls and typed arguments, preserving empty, omitted/default, brace, bracket, bare-token, star, embellishment, and deferred forms.

5. **C1–C3 — Elaboration**

   Rewrite expansion to consume binding and invocation stores; add deterministic resource budgets; then expand supported dialect coverage.

6. **Downstream Cut 2**

   Land `macros`, pointers, zones, walk, references/frontmatter, then graph projection—each with schema, closed joins, deterministic reruns, and matching atomic publication changes.

The legacy `compile/traversal.ts`, `compile/macros.ts`, and `elaborate/expand.ts` should be treated as rewrite inputs, not reconnected unchanged.

::git-stage{cwd="D:/aghado01/codex-scientiae"}
::git-commit{cwd="D:/aghado01/codex-scientiae"}
