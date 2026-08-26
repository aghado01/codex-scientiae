# TeXdig decision canon

Living document — states what is decided **now**, corrected in place as decisions evolve.
Arguments and evidence live in [../notes/](../notes/) (founding thread
`TeXdig-chat-019fe5a1…`), [../briefs/](../briefs/), and [../discussion/](../discussion/) — in
particular the swarm review + 0.2 plan (`sol-review-remediation-part-1.md`), the B-wave status
review (`sol-texdig-b-wave-report.md`), the pre-B punch-list (`fable-feedback-20260812.md`), and
the agy decision index (`agy-cut23-lane-scoping-20260812_133800.md`, §6). Completed work is
recorded in [ledger.md](ledger.md); everything ahead in [roadmap.md](roadmap.md).
`src/TeXdig/README.md` is the in-repo contract surface and must agree with this file.

Status vocabulary: **ruled** = explicit owner ruling; **approved-with-plan** = carried by the
owner's approval of the 0.2 eight-wave plan (2026-08-12), open to re-ruling item-by-item;
**landed** = in code at the cited commit; **OPEN** = awaiting owner ruling.

## Doctrine (owner-ruled, standing)

- **Knowability binary.** Record what is knowable from the evidence at this stage; defer the rest
  explicitly, with a diagnostic. Never speculate, never let a placeholder point the wrong way.
- **Witnessed evidence.** Independent instruments sight the same source; agreement is computed at
  fusion, never asserted. Disagreement is honest output, not failure.
- **Claims as currency.** Every byte is claimed by a pillar or stands as residue; coverage is a
  ledger (`claimed + residue = length`). The chronology tier extends the same ledger discipline to
  time: every definition is an event with an outcome.
- **Faithful, not filtered.** Census transcribes; interpretation belongs downstream. Editorial
  judgment is promotion-tier work.
- **The latent manuscript.** The destination is the traversal-serialized hypergraph (walk, zones,
  graph) — the semantic quotient of the source. The kind/relation superset is the owner's design
  surface; RELATIONS in `core/contracts.ts` is canon-in-formation, to strike, rename, extend.
- **House nomenclature primacy.** The owner's coinages are canonical in store, field, and code
  vocabulary. The B-wave compile tier arrived in Sol's compiler idiom and has not yet had the
  owner's naming pass (roadmap item).

## Decisions

| # | decision | status |
|---|---|---|
| T1 | Five boundary stakes: reboot-not-refactor; IR = typed attributed hypergraph; manuscript = semantic quotient of a surjection; math register = conservative notation-preserving KaTeX; diagrams = bare-arrow lexicon inside the math channel | ruled 2026-08-09 (founding thread); standing |
| T2 | Stage-1 tier structure (contract / evidence / audit stores) and one id grammar `{class}:{locator}` as verbatim join key; content refs always array-form | ruled 2026-08-10; landed a214fd4→80dd0f0 |
| T3 | Ordinal doctrine: reference ordinals normalized 1-based by first appearance; the paper's own register preserved beside, never as, the ordinal | ruled; standing (references tier deferred) |
| T4 | Bib/BBL symmetric reachability; unreachable sources inventoried with diagnostics | ruled 2026-08-12 |
| T5 | Overlays generous: one semantic unit may claim under two roles (e.g. `\bibliography` = include AND envelope-marker) | ruled 2026-08-12 |
| T6 | Pillars are accounting labels only; role strings carry richness; `macro-invocation` stays envelope catch-all until earned otherwise | ruled 2026-08-12 |
| T7 | Physical census is physical-token-only: an invocation entity spans its control-sequence token; argument hulls are binding-dependent and live on the invocation tier | approved-with-plan; landed 09b5468 |
| T8 | Occurrence-tier identities `occ:`/`bind:`/`inv:`; `seq` is a bundle-local projection over occurrence addresses, never persistent identity; occurrence ids are route-derived, sequence-independent | approved-with-plan; landed 573e050 |
| T9 | `\let` captures its governing meaning at assignment time, immutably; unsupported definitions install opaque meanings and still shadow older ones | approved-with-plan; landed 573e050 |
| T10 | Nested, conditional, and argument-context definitions are catalogued with context/activation evidence and never speculatively mutate the environment; census proves context lexically (`\if…\fi` stack, group frames), branch evaluation deferred | approved-with-plan; landed 573e050 |
| T11 | Argument taxonomy: kind (mandatory/optional/star/token/embellishment/until) × source (explicit/omitted/default) × delimiter (brace/bracket/bare-token/implicit/none); explicit-empty survives as zero-length contentSpan inside a nonempty extent | approved-with-plan; landed 573e050 |
| T12 | No 0.1→0.2 converter: stores regenerate from source; corrupt coordinates and missing occurrence history are not reconstructible | approved-with-plan |
| T13 | Runstamps are `YYYYMMDD_HHmmss[_NN]` — ISO date order so directory names sort chronologically. The `YYYYDDMM` text formerly in AGENTS.md/tests-README was a transposition leaked from a Sol-drafted brief | **ruled 2026-08-13**; docs aligned 7816325; owner cleans mis-stamped dirs |
| T14 | Environment definitions use `def:` identity with a `defines:"macro"\|"environment"` discriminator; no separate `env:` class | approved-with-plan; landed |
| T15 | **Configured-channel authority.** Pinned CTAN parser-support records are signature evidence, NOT install manifests. Two distinct defects (b-wave gauntlet, 4-and-4): (i) configured installs falsely veto document `\newtheorem` preconditions; (ii) pinned `latex2e` record lacks kernel names (`\top`, `\epsilon`, `\arraystretch`) so kernel renewals go invalid. Recommended shape: configured evidence never blocks document-level preconditions; baseline gains a pinned kernel name-set. Blanket "indeterminate activation" rejected — it would degrade 23 correct installs | **OPEN — top release blocker** |
| T16 | `bound-out-of-scope` basis (what evidence marks a name bound in an unparsed in-tree file). Three-state shape is frozen and not reopened; only the basis is undecided. Consumer (zones) deferred, so decision rides Cut 3 scoping | OPEN (deferred with its consumer) |
| T17 | Empty-body fingerprint policy: hash the empty body vs omit the fingerprint (agy D14). Plan prose says known-empty hashes empty; field is optional and unenforced | OPEN |
| T18 | Math-environment vocabulary: split top-level carriers from interior structures (`equation` vs `split`/`aligned`/`cases`) or explicitly defer the classification | OPEN (defer-or-fix on the close-list) |
| T19 | Agy D1–D16 dispositions: D1, D3, D4, D9, D11–D13, D15 absorbed into T7–T14 contracts (D4 by relocation to BindingMeaning; D15 partial — see dead-codes roadmap item); D2 narrowed to T16; D14 = T17; D5–D8, D10 remain feature-round; D16 (zone validation) skipped until Cut 3 | recorded 2026-08-13 |
| T20 | **Section titles inherit the hole discipline recursively.** `WalkNode.section.title` is `ContentPart[]` and titles carry markup (`\emph`, inline math, `\ref`), so title content folds under the same rules as body prose and admits the same anchor vocabulary — no separate title machinery. A title containing an unresolved invocation carries a hole anchor exactly as a paragraph would, and its length counts toward the hole fraction | **ruled 2026-08-26**; [brief](../briefs/walk-projection-prose-spine-20260826_100238.md) |
