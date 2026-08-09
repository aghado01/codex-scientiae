# jsonl_engine brief — state at end of 2026-08-07 and the next sequence

Runstamp 20260807_141055. Handoff for the next session. No `issues/jsonl-engine/planning/` tier exists
yet; the decisions in section two are locked calls that belong in a `decisions.md` when it does, and
this runstamped brief stays the record of how they were reached.

Suite at exit: 10 passing, including the PowerShell JSOI v2 interop test.

## 1. Landed in code

- **Article rename.** `metadata.json` → `article.json`, `registries/document.py` → `article.py`,
  `DocumentMetadataRegistry` → `ArticleRegistry`, `$id` → `codex-scientiae/article/0.1`. Catalog is
  internally consistent; no dangling `math` child.
- **One schema for atom and row.** `inventory-row.schema.json` retired as redundant; an article object
  is inserted into `inventory.jsonl` verbatim. The nested `document` block hoisted to top level.
- **`RECORD_SCHEMA`** replaces `SCHEMA_NAME`/`SCHEMA_ID` — one attribute, since the registry already
  resolves `$id`, filename, and stem.
- **`HEADER_SCHEMA` out of code and into `schemas/header.schema.json`**, declarable per kind with the
  base as default. The two row categories are now declared the same way.
- **`Codec` as a kind declaration** — `UNICODE` (readable, refuses unpaired surrogates) and `ASCII`
  (escapes them losslessly). Escape or refuse, never substitute. Recorded in `.sig`.
- **Derived constants.** `SIG_SCHEMA_ID` read from `sig.schema.json`'s own `$id`; `DOTNET_TICKS_OFFSET`
  computed from the two epochs and verified equal to the literal it replaced.
- **`sig.schema.json`** authored and enforced — `verify_signature` validates the sidecar before
  trusting any of its values.
- **`json_document.py`** — `read_json_value` (parse only) and `read_json_document` (validator
  positional, no default, `None` declines explicitly). `SchemaRegistry.read_schema_file` is a
  classmethod, so a schema's authority is the meta-schema rather than a registry entry.
- **Schemas ship in-package** at `jsonl_engine/schemas/`, discovered `__file__`-relative. The registry
  no longer depends on repository layout.
- **`graph.primitive.schema.json`** demoted to a dormant reference with its stale `codex-scientiae/docgraph/0.1`
  `$id` corrected; a test asserts no kind declares it.
- **Python scaffolding** — `pyproject.toml` with hatchling (no egg-info anywhere), editable install,
  and the `src.shared.jsonl_engine` / `jsonl_engine` import fork closed.

## 2. Decided in conversation, not yet in code

- **`CATEGORY` above `KIND`.** Two families: **infrastructure** — invented by the project for its own
  logistics — and **evidence** — attested by a proceeding. Categories differ in *operations*, not just
  settings: a catalog can be regenerated, an exhibit cannot, so this is subclassing rather than an
  attribute.
- **The base class is misnamed after one of its categories.** `BaseArtifactRegistry` makes
  `ArticleRegistry` and `DocGraphRegistry` assert something untrue. Target shape:

  ```
  JsonlStore              what it IS
  ├── Catalog             materialized view, rebuildable        inventory
  ├── Ledger              append-only, outlives its sources     runs
  └── Exhibit             attested, immutable                   ref-graph
  ```

  "Catalog" is the working lane's own word — `inventory-catalog.ps1` never says registry — which frees
  *registry* for its general sense (`SchemaRegistry`, and `RegistryCatalog` → `KindRegistry`).
- **Three orthogonal axes**, previously collapsed: **category** (what it is), **discipline** (how it may
  be written), **role** (what it does for the pipeline). `article` is an Exhibit whose discipline is
  create-if-absent and whose role is sentinel — so "sentinel" needs no engine representation at all.
- **A fourth discipline** is needed: create-if-absent / validate-and-return / conflict-is-visible.
  `CREATE` overwrites, `SEALED` refuses to open, neither fits the sentinel.
- **A catalog's `RECORD_SCHEMA` is the schema of the thing it catalogs.** Article/inventory sharing one
  schema is the category behaving correctly, not a convenience. A proposed catalog that *can't* use its
  member's schema is projecting, and therefore isn't a catalog.
- **The container is a kind property**, not a function of record count. Started and reverted mid-edit;
  `ArticleRegistry` currently declares `NAME_FORMAT = "article.json"` but would still write JSONL.
- **ref-graph is the canonical exhibit.** The doc graph is an open composition (`stream + refgraph +
  TBD`) and cannot be schematized while its member set is accreting.

## 3. Defects found, not fixed

1. **Custom-counter overlap.** `$st.rt` in `Resolve-CustomCounters` is armed by `\refstepcounter` or an
   enumerate `\item` and never disarmed, so every subsequent `\label` to the end of the document claims
   a stale counter value. The label population is a multiset with contradictory numbers — 143 rows for
   75 keys on `2105.07025`, duplicated in 38 of 43 probe papers, every duplication involving `custom`.
   Confined to `$labels`; body rendering reads `$val` and is unaffected.
2. **`edge.site` doesn't join.** `Build-LatexRefGraph` increments `$si` in the inner target loop, so the
   field is a unique per-edge ordinal. `distinct == edges` on every probe paper. Correct only until the
   first multi-target `\cite`, then silently wrong. `refs.jsonl` numbers its site rows independently, so
   the two files disagree about what a site index is.
3. **`tex-docgraph.ps1` is orphaned** — nothing dot-sources or calls it — and claims the docgraph name
   while its own header calls it a typed reference graph. Superseded: the label→type binding it existed
   to protect is carried on every mature label record via `$maps.types`.
4. **`DocGraphRegistry` is an invented stub.** `RECORD_SCHEMA = None`, and `add_node`/`add_edge` match
   no producer in the converter.
5. **`NAME_FORMAT`'s `{stem}`** has exactly one user, `docgraph.py`. If that goes, `get_output_path(stem=…)`
   is a parameter with no consumer.
6. **The probe ledger's round trip is untested.** `article.schema.json` now accepts check objects with
   the `outcome` enum, and `src/logistics/probe-ledger.ps1` emits them, but nothing has carried one
   through to a written manifest.
7. **Two probe branches unexercised** (carried from `TODO.md`, still valid). All 11 deposits are
   `tar+gzip` with `single-candidate` entrypoints, so all 77 records came back `passed`. The
   `not-applicable` paths need a single-TeX gzip archive and a `-MainTex` case.

## 4. Sequence for next session

Dependency-ordered, with the reason each precedes the next.

1. **Consume-once in `Resolve-CustomCounters`** — disarm `$st.rt` when a `\label` reads it. Verify first
   against a paper that actually exercises lettered proof cases; that's the feature the walk exists for
   and this is the one fix that could regress it.
2. **Move `$si` to the outer loop** so `edge.site` names a site.
3. **Then `ref-graph.schema.json`** — records `row` ∈ `label|site|edge`, header carries `stats` +
   `faithful_render`, `danglers` not emitted (it duplicates 208 of 314 edge objects on the worst probe
   and is recoverable as `resolved == false`). Steps 1 and 2 are **mandatory** first: writing the schema
   now would pin identity fields that don't identify anything.
4. **`docgraph.py` → `ref_graph.py`**, `KIND = "ref-graph"`, `NAME_FORMAT = "ref-graph.jsonl"` — no
   stem, since the run directory already carries the slug.
5. **`tex-docgraph.ps1` to the graveyard.**
6. **Container declaration** on the kind.
7. **`CATEGORY` layer and the `JsonlStore`/`Catalog`/`Exhibit`/`Ledger` rename.** Cheapest before another
   kind lands, most expensive after — so there's an argument for pulling this ahead of 3 and 4.
8. **`python -m jsonl_engine deposit`** — the invocable surface. Unblocks `New-LatexSourceDeposit`,
   which currently throws at the boundary with the exact command it attempted.

## 5. Open questions

1. **Is `projection` evidence or configuration?** It was called evidence, but if only the converter reads
   it and it's hand-maintained it behaves like `{slug}-latex.patch.jsonl` — authored rules, validated on
   read, never emitted — which may be a fourth category rather than a variant of exhibit.
2. **Does ref-graph supersede `refs.jsonl` and `refgraph.json` on landing, or is there a transition?**
   Neither has a runtime reader today and the corpus is due for a wipe, so immediate supersession
   strands nothing — but that's a call, not an inference.
3. **When does the create-if-absent discipline land** — with the `CATEGORY` layer, or with the deposit
   verb that needs it?
4. **Base class name.** `JsonlStore` fits the what-it-is slot — everything in a JSONL container is one —
   and `artifacts/` already claims "artifact" for regenerable output, which is wrong for half the
   hierarchy. The name is currently occupied by a *specialization*: in `jso-ops/jsonl-store-v2.ps1` a
   "JsonlStore" is a JSONL file **under a policy**, exposed as `New-JsonlStorePolicy`,
   `Create-JsonlStore`, `Add-JsonlStoreRecords`, `Remove-JsonlStoreRecords`, `Subtract-JsonlStore`,
   `Sort-JsonlStore`. That file is dormant — nothing in `src/` dot-sources it; its only consumer is
   `tests/shared/jsonl-store-v2.Tests.ps1` — and it is precisely what the Python engine supersedes, so
   the name frees by retiring what is already replaced.

   Two details. `jsonl-v2.ps1` retains `Get-JsonlStoreInfo` and `Complete-JsonlStore`, but those sit in
   the primitive tier and use "store" in the generic sense; they do not conflict with the base-class
   reading. And `jsonl-store-v2.ps1` is **the only implementation of the slots the Python engine still
   lacks** — `KeyPointer`/`KeyMode`/`KeySelector`, `UniqueKey`, `KeyComparison`, `CanonicalSort`,
   including the subtlety that inventory sorts ordinally while deduplicating case-insensitively. It is
   the specification for that work and wants reading before retirement, the same disposition as
   `inventory-catalog.ps1`.
5. **Do the ref-graph's inputs persist as atoms** — `labels`, `sites`, `citeMap`, `AllLabels`? That
   turns the ref-graph into a rebuildable view over evidence and makes the stage resumable. Cross-ref:
   [devops brief](../../devops/briefs/opus-resumable-stages-run-ledger-generational-gc-20260807_135748.md).

## 6. `TODO.md` reconciliation

The docstring item is **done for the Python engine** — all module docstrings rewritten declaratively per
the new `AGENTS.md` dev guideline — and **still open** for the three PowerShell modules in
`src/logistics` and, per the note there, most of the repository. The unexercised-probe-branch item stands
as written and is carried above as defect 7.
