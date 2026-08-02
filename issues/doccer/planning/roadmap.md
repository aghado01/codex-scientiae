# Doccer roadmap — what is ahead

Living document — current truth, corrected in place, holding only work **not yet done**.
Decisions and the question ledger live in [decisions.md](decisions.md); completed roadmap items
move to [ledger.md](ledger.md); arguments in the runstamped briefs under
[../briefs/](../briefs/); evidence in [../discussions/](../discussions/).

## Current state (2026-08-02)

Engine at `src/doccer` (`CodexSci.Doccer`), canon **D1–D24**, contract harness **1500 checks
green** (`dotnet run --project brewery/doccer/Doccer.Tests.csproj`). The capability inventory is
`src/doccer/README.md` — the in-repo contract surface; the completed-item record is the
[ledger](ledger.md). Tranches 0–3 are done: the substrate is complete, the lift vocabulary
lacks only materialize, the first D8 measure is landed. Delivery: `build-doccer.ps1` →
`packages/doccer` with `doccer.manifest.json` as provenance (`packages/` is untracked; refreshes
are local-only).

## Sequencing doctrine

Engines first; **codex-scientiae adapters last**. scriba-scientiae was aborted — codex is
renovated from the inside, so its converter/LaTeX lanes are the living lanes, and they become
thin consumers of doccer only after the doccer-native surface exists. Contracts gate work;
consumers witness (D14). Per-topic containment: `planning/` = living truth (decisions, roadmap,
ledger); `briefs/` = one small runstamped brief per chip iteration, guidance + that chip's
report appended on completion; `discussions/` = captured evidence.

## Queue

1. **Provisional DLL-reach adapters (active next):** during the latex-ingest rewrite, write
   provisional adapters that reach directly into the doccer DLL (`packages/doccer` payload)
   from PowerShell — **research instruments, deliberately site-local and disposable**. Their
   job is to clarify the working vocabulary and surface constructs for engine promotion
   through real usage; the abductive census runs live throughout (specimens → drawer). The
   sequencing doctrine holds because nothing durable is built against an unsettled surface —
   these instruments inform the durable veneer (item 4) but are not it.
2. **Pairing contract (candidate, at the user's call):** the one missing mechanism — ~7
   witnesses, composition-refusal argued (harvest addendum 2), fault residue as evidence
   built into the shape. Drafting proceeds when called; a `pair` capability follows the
   landed contract; open/close token rules are store entries, never the verb's knowledge.
3. **First CLI verbs (D13) — deferred pending surface design:** the operational terminology
   is marinating (candidate lexicon = harvest addenda 4/4a/4b — catalog, uncommitted; fiber
   vs textile metaphor registers unresolved), and the wire format deliberately waits on the
   latent-manuscript node-stream schema so it is not frozen prematurely. Verbs are named
   **domain-agnostic capabilities**, never domain tasks; what to capture lives in
   **per-domain pattern stores**; the algebra surfaces as an expression evaluator (drawer
   design). user-repl anatomy stands: hand-rolled router, per-verb files with no hot path,
   run manifests where verbs produce artifacts. The current `inspect`/`relate` commands are
   **disposable developer diagnostics** predating D13 — reconcile or delete when real verbs
   land; they are not contracts.
4. **Durable adapters (last):** masks.ps1 reborn as a thin PS veneer over the DLL; LaTeX
   consumers migrated as thin consumers, old behavior as witness; the provisional
   instruments of item 1 inform this veneer without becoming it. This work generates F1's
   honest edit-plan requirements as a byproduct.
5. **Proactive contract closures, at discretion (D14):** F-UCD data-provenance record →
   block/script facts; OffsetMap pressure-test (segment granularity, ambiguity encoding) if
   judged ripe; register columns only once the math-register design stabilizes; materialize (the
   last lift operation); a callable runtime Tier-1 runner exposing the harness-law checks, if a
   consumer wants them at run time.

Maturity-gated beyond that: F2 persisted batches → F4 indexed joins → F5 Tier-2/3 agreement
scoring → F6 markdown adapter and the mdnav succession (oracle harness on the doc-dive
fixtures; exceed mdnav precisely at its collapse points; conserve its instrument virtues).

## Standing practice — the abductive census

The demand census is **standing and abductive, never a read-everything sweep**. As doccer
integrates into live workflows (the latex-ingest end-to-end pass is the first named occasion),
every bespoke resolution encountered raises the question *"should this be reading doccer
instead?"* — hits become site records in the **future-consumer registry** (named witnesses
tagged to their F-families, replacing abstract triggers with counts), and helper utilities /
public-surface exposure grow opportunistically through the same evidence discipline that minted
the first verbs. The graveyard repair farm (`codex-scientiae-graveyard/legacy_code/tools`,
`repair_*` ×~30) is an evidence pool consulted when its family comes up — F1 edit plans — not
a gate on anything.

The object of the search, stated once: the engine's **latent path-space** — every capability
reachable by composing the primitives (D12 keeps that space open; verbs signpost dense routes
through it, never wall it off). A verb **names** a latent call path, making it a reachable
capability at task grain; the **capability surface** — the doccer public API — is the named
subset, carved from the path-space by witnessed demand. Census abduction therefore yields
finds of exactly two kinds: an **unnamed latent path** (the engine already composes it — a
verb candidate; `collect` and the span algebra are this kind, `SpanSet` being already
complete) or a **missing path** (no composition reaches it — an engine-contract candidate;
the pairing lift is this kind). The rewrite test's "refusal to collapse" is what
distinguishes the second kind from permanent adapter policy.

Process discipline for the census — three rules, all guarding one failure mode: **conflating
fact-finding research with conclusions**:

1. **Catalog before naming.** Capture the candidate, its contract shape, and its integration
   points first; promotion — a verb name, an implementation — is always a later, separate act
   of evaluation over the catalog, never simultaneous with capture. The catalog is a
   **research device, not code** — tabulated field observations, the way a naturalist pins
   specimens long before declaring taxonomy, and most specimens never become species. Its
   form is the site-record line already in use (where · what it improvises · suspected bin ·
   family tag), living in the discussion docs; it gets no schema, no tooling, and no home in
   the engine.
2. **Composition before extension.** Before any find is declared a missing mechanism, attempt
   to compose it from existing primitives plus a named policy. Success means it was a missing
   *example*, not a missing mechanism — the deliverable is a recipe (documentation or a store
   entry), never engine work. Every mechanism claim carries the failed-composition argument as
   a proof obligation. (The pairing lift passes: stack-discipline matching is not expressible
   as a composition of the current operations.)
3. **Residuals stay visible.** When a site needs a judgment — which claim wins, what "near"
   means, whether to rewrite — that judgment is orchestration. The engine exposes the evidence
   and the policy hooks, never the judgment. (The pairing fault residue is the template: the
   engine emits `unclosed`/`dangling`/`mismatched` as evidence; remedies belong to consumers.)

Census finds therefore land in four bins: **unnamed latent path** (verb candidate) · **missing
example** (recipe / store entry — cheap, no engine work) · **missing mechanism**
(engine-contract candidate, composition-refusal argued) · **permanent adapter policy**.

## Open questions in play

- See [decisions.md § Open](decisions.md): register/value/metadata columns (entangled with the
  math-register design), the meaning of "register" in sol's Tier-1 list, and the named
  per-line terminator-kind view (unscheduled). All Tranche-2 stragglers are closed — see the
  [ledger](ledger.md).

## Standing context for future sessions

- Decision canon, this roadmap, and the ledger are the entry points; `src/doccer/README.md` is
  the in-repo contract surface and must stay in agreement.
- MarkPig legwork = historical evidence, never amended. mdnav relation = succession + spec
  witness, no cross-talk (its three strata: pseudo-parsing → supplanted eventually; instrument
  verbs → spec witness; doc-dive skill semantics → permanently above the engine).
- Doccer is expected to graduate cross-project; anything a graduated doccer would need must live
  in the C# surface, not PowerShell (D13 boundary test).
