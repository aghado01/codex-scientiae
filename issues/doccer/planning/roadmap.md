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

1. **Harvest seed read** (before any durable CLI contract): deep-read the four genealogy
   sources — masks.ps1 operations, latex.ps1 span producers, md-repair byte offsets, mdnav
   constructs (the density/mask calculus as it survives in the living lanes rides along) — and
   synthesize site records: where, what each operation improvises, which primitive it
   rediscovered or which verb it implies. Dense witnessed demand mints the **first verb set**
   and its task grain; single witnesses land in the consumer registry. The verb list is a
   living canon: shipped names and semantics hold steady (D8 discipline at the CLI surface);
   the namespace stays open.
2. **First CLI verbs (D13):** `doccer collect` (inventory + scope in, claims JSONL out) and a
   span-algebra verb — the macro-expansion witness as a working demo. Verbs are named
   **domain-agnostic capabilities**, never domain tasks: what to capture lives in
   **per-domain pattern stores** (the harvested latex `Rx*` registers and mdnav
   construct/noise tables are the first two packs), so codex adapters become capability calls +
   store entries + genuinely-domain policy — the D13 rewrite test. The pairing lift graduates
   to a `pair` verb once its engine contract lands; its open/close token rules are store
   entries, never the verb's knowledge. user-repl anatomy:
   hand-rolled router, per-verb files with no hot path, wire format extending the loader's JSON
   context with span/claim payloads, run manifests where verbs produce artifacts. The current
   `inspect`/`relate` commands are **disposable developer diagnostics** predating D13 (`relate`
   is operation-grain; `inspect` serializes an anonymous object outside the source-generated
   wire context) — reconcile or delete them when `collect` lands; they are not contracts.
3. **Adapters (last):** masks.ps1 reborn as a thin PS veneer over the DLL; LaTeX consumers
   migrated as thin consumers, old behavior as witness. This work generates F1's honest
   edit-plan requirements as a byproduct.
4. **Proactive contract closures, at discretion (D14):** F-UCD data-provenance record →
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
