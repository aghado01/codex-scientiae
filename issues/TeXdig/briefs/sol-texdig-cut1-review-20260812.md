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
