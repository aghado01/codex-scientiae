# TeXdig walk projection — the prose spine, holes and all

Date: 2026-08-26
Baseline: `main@fdb49a1d`
Status: sketch for owner reaction, not an accepted work order

## Why this exists

The owner's stated goal from TeXdig's outset was contiguous prose in reading order with section
headers, everything non-prose anchored out to be unpacked separately. The evidence-first ordering
delivered nine census stores — `sources`, `entities`, `occurrences`, `bindings`, `invocations`,
`claims`, `coverage`, `diagnostics`, `summary` — all of which are apparatus, none of which is the
manuscript. The manuscript stores are deferred, and `walk` sits fourth in the Cut-2 order behind
`macros` → `pointers` → `zones`.

That ordering appears to be a false dependency. The two things the prose spine actually needs are
landed:

- **Reading order across include boundaries.** [`SourceOccurrence`](../../../src/TeXdig/core/contracts.ts:81)
  carries `enterSeq` / `exitSeq` / `includeChain` / `parentOccurrenceId` with `state` of
  `entered` | `cycle-cut` | `deferred-context` (B1, `573e050`).
- **Hole locations.** [`InvocationOccurrence`](../../../src/TeXdig/core/contracts.ts:226) carries
  `seq`, `siteSpan`, and a three-state `binding` of `bound` | `unbound` | `indeterminate` (B3,
  `573e050`). Every non-`bound` invocation is a located hole.

The census also already emits the role vocabulary the spine folds over:
[`parse-latex.ts:1007`](../../../src/TeXdig/census/parse-latex.ts:1007) turns unified-latex
`parbreak` nodes into `paragraph-break` sightings, and
[`reconcile.ts:77`](../../../src/TeXdig/census/reconcile.ts:77) maps the sectioning commands.
Claim roles in evidence: `text-run`, `blank-run`, `paragraph-break`, `section`, `float`,
`verbatim`, `include-directive`, `asset`.

**Consequence: `walk.jsonl` is a pure projection over landed stores.** No new scan, no expansion,
no binding work. The B wave poured the foundation the spine wanted and then queued the spine
behind three more tiers.

## Proposed resequencing

Emit `walk` **before** `macros` / `pointers` / `zones`, so that everything downstream fills holes
in a document that already exists rather than assembling a document out of evidence at the end.
This is a change to the Cut-2 order in [roadmap.md](../planning/roadmap.md) and is the owner's
call; this brief proposes it and does not enact it.

Where it sits relative to the 0.3 acceptance close-list is also an owner call. The projection
does not depend on T15 (configured authority) or on the coverage patch, but it *reuses* the
coverage ledger discipline, so landing the coverage honesty fix first would avoid building the
walk-level ledger against a known-distorted one.

## Inputs

All five stores already emit at `texdig-census/0.3`:

| store | what the projection uses |
|---|---|
| `occurrences.jsonl` | traversal tree + `enterSeq`/`exitSeq` linearization + `state` |
| `entities.jsonl` | role-tagged spans in offset order |
| `claims.jsonl` | byte ledger for the coverage gate |
| `invocations.jsonl` | `siteSpan` + `binding.state` → hole locations |
| `sources.jsonl` | source text + fingerprints |

## The projection

1. **Traversal.** Occurrences form a tree by `parentOccurrenceId`, linearized by `enterSeq` /
   `exitSeq`. Descend only into `state: "entered"`.
2. **Local order.** Within an occurrence, sort its entities by `startUtf16`.
3. **Splice.** At an `include-directive` entity whose child occurrence is `entered`, recurse; on
   return, continue after the include span.
4. **Fold.** Walking the ordered stream:
   - `section` → close open paragraph, emit `section` node (level from command name, title from
     the argument span)
   - `paragraph-break` → close open paragraph
   - `text-run` → accumulate into current paragraph content
   - inline math → stays *inside* paragraph content
   - display math / `float` / `verbatim` → close paragraph, emit `anchor`
   - invocation with `binding.state ≠ "bound"` → emit `anchor` (hole); paragraph stays open

**T18 is not a dependency.** Inline-vs-display is lexical (delimiter kind). The carrier-vs-interior
distinction T18 concerns — `equation` vs `split` / `aligned` / `cases` — only ever occurs *inside*
a display carrier, so it never surfaces at walk level.

## Anchor taxonomy

Anchors are not one thing; collapsing them destroys the signal. Each kind maps to a landed field.

| anchor kind | derived from | future |
|---|---|---|
| `zone` | `float` / `verbatim` / display-math entity | never fills — correctly not prose |
| `unbound` | `invocation.binding.state = "unbound"` | filled by the macro tier |
| `indeterminate` | `invocation.binding.state = "indeterminate"` (carries `causeIds`) | filled by the macro tier |
| `unentered-source` | occurrence `state` = `cycle-cut` \| `deferred-context` | filled by traversal work or an explicit ruling |

Only the last three are **holes**. The first is a correct, permanent anchor. Keeping them distinct
is what makes hole fraction a quality measure rather than a count of non-prose material.

## Zones, minimally

Every anchor needs a zone id. Mint zone records now carrying only `id`, `kind`, `span`, `text` —
all deterministic — and let `closure`, `isolable`, `validation`, and `names` arrive with the real
zones tier. The `zone:` id grammar is stable under T2; the record grows. This is what allows
`walk.jsonl` to emit while `zones.jsonl` remains substantively deferred.

## The honesty gate

Extend the existing ledger one tier up. **Every UTF-16 unit of every entered source is either
inside a paragraph's content, inside a section title, inside an anchored zone's span, or is
explicit residue.** Same `claimed + residue = length` discipline, now over the walk. This is the
check that proves the spine did not silently drop prose.

Derived signal to track per document:

```
hole fraction = Σ(UTF-16 length under hole anchors) / Σ(entered-source UTF-16 length)
```

It should fall monotonically as the macro tier lands and must never rise. A rise is a regression
in binding coverage, not a change in the corpus.

## Deliberately out of scope

- Expansion. An unresolved invocation stays a hole; the walk never guesses.
- Zone closure, isolability, validation.
- `pointers`, `references`, `frontmatter`, `graph`.
- Markdown emission. The walk is the IR, not the render.

## Exit signal

1. Walk coverage ledger balances on the bounded three-document gauntlet.
2. Hole fraction emitted per document in `summary.json`.
3. Two-run bytewise determinism on `mini_article`, with deposited digests (per the standing
   determinism-proof item on the close-list).
4. **The reading test.** Concatenate `paragraph` content in `seq` order for `mini_article` and
   read it. If it reads as continuous prose, the projection works. This is the right acceptance
   test for the first artifact that is supposed to *be* the document, and a human can adjudicate
   it in under a minute.

## Ruled during drafting — T20

**Section titles inherit the hole discipline recursively** (owner ruling, 2026-08-26; recorded as
T20 in [decisions.md](../planning/decisions.md)).

`WalkNode.section.title` is `ContentPart[]` and titles carry markup — `\emph`, inline math,
`\ref`. Title content therefore folds under the same rules as body prose and admits the same
anchor vocabulary. No separate title machinery: a title containing an unresolved invocation
carries a hole anchor exactly as a paragraph would, and its UTF-16 length counts toward the hole
fraction. Titles are also inside the coverage ledger, so a dropped title cannot pass silently
either.

## Provenance

Sketched in session with the owner, 2026-08-26, from a reading of the landed B-wave contracts.
Companion context: the pdf-prose pilot (added `9d8a28d9`) was an independent reach for the same
object from the PDF side — contiguous prose in reading order with non-prose anchored out. Its
disposable doccer witness demonstrated the anchored-hole discipline this brief adopts for
unresolved invocations: each float collapsed to a single `U+FFFC` occupying one code unit, so a
non-text object still held coordinates in the spine.

The pilot has been evicted from the tree to `graveyard/codex-scientiae/src/pdf-prose` (WIP —
residue cleanup outstanding). Also recoverable at
`git show 9d8a28d9:src/pdf-prose/witness-doccer-spine.ps1`.
