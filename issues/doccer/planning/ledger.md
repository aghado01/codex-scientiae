# Doccer ledger — completed roadmap items

Planning document, sibling to [decisions.md](decisions.md) and [roadmap.md](roadmap.md): when a
roadmap item closes, it moves here with its date, the contracts it minted, and its witness. The
roadmap holds only what is ahead; this file holds what has landed. Not a changelog — entries are
roadmap-item grain, corrected in place if wrong (the judgment rule applies); the full arguments
and per-chip reports live in the runstamped briefs under [../briefs/](../briefs/), the evidence
in [../discussions/](../discussions/).

| item | closed | contracts | witness |
|---|---|---|---|
| Tranche 0 — correctness (fingerprint hashes raw UTF-16 code units; identity distinguishes lone surrogates) | 2026-08-01 | D1 | [founding brief](../briefs/fable-doccer-dev-brief-20260801_222912.md) |
| Tranche 1 — decision canon + README as contract surface | 2026-08-01 | D2–D14 minted | [founding brief](../briefs/fable-doccer-dev-brief-20260801_222912.md) |
| Tranche 2 — substrate completion (interned columns, run views, suppression queries, JSONL loader, `ExecutionScope`, Tier-1 invariants; harness 1263) | 2026-08-01 | implements D3–D6, D9, D12 | founding brief + [tranche2 reply](../briefs/tranche2-reply-20260801.md) |
| PerLine = content extent, terminator excluded | 2026-08-01 | D15 | post-Tranche-2 chip; recorded in decisions |
| Sol review answered — transactional collection, set-theoretic intersection + `FindContaining`, capture-group/enum validation, test-gap closures, package manifest + delivered-payload smoke (harness 1263→1330) | 2026-08-02 | D16, D17; D9 extended | [review + response appendix](../discussions/sol-doccer-review-20260802.md) |
| T2-2 — `CultureInvariant` as engine invariant; `ECMAScript` rejected (harness →1340) | 2026-08-02 | D18 | decisions row; Turkish-I witness in harness |
| Tranche 3a — `TextSlice` + total bijective rebase (harness →1407) | 2026-08-02 | D19; D20 (T2-1); T2-5 documented | [3a brief + report](../briefs/fable-doccer-t3a-brief-20260802_005408.md) |
| Tranche 3b — basis-stamped group/project views, `ClaimFacts` (harness →1456) | 2026-08-02 | D21; D22 (T2-4) | [3b brief + report](../briefs/fable-doccer-t3b-brief-20260802_011103.md) |
| Tranche 3c+3d — gap cadence (first D8 measure) + named lookup orders (harness →1500; **Tranche 3 closed**) | 2026-08-02 | D23, D24; D8 status advanced | [3c+3d brief + report](../briefs/fable-doccer-t3cd-brief-20260802_012056.md) |
| Delivery/provenance lane — `build-doccer.ps1` gates on harness, smoke-tests the delivered DLL/CLI, writes `doccer.manifest.json` | 2026-08-02 | — | script + manifest in `packages/doccer` |
| Harvest seed read + census establishment — four genealogy files deep-read into site records + capability view; grok latex-ingest dive verified (pairing → ~7 witnesses, one refuted bug claim, F1 upgraded architectural); reshape concepts joined (knowability axis, claims-as-currency); census = standing abductive practice with process rules and four find-bins; candidate operational lexicon cataloged (uncommitted); verb mint **deliberately deferred to usage** — provisional DLL-reach adapters chosen over premature CLI commitment | 2026-08-02 | D13 sharpened (capabilities, pattern stores, rewrite test); census doctrine + latent-manuscript doctrine scribed; no engine mints | [harvest doc + addenda 1–4b](../discussions/fable-doccer-harvest-seed-20260802.md); [latent-manuscript doctrine](../../latex-ingest/discussions/latent-manuscript-doctrine-20260802.md) |
| K0 — many-sorted carrier and law registry: separated valid boundaries, located extents, nonempty Allen intervals, claim occurrences, later facts, and later origins; reserved sort-specific operation names; assigned assurance owners and concrete Lean reactivation triggers | 2026-08-04 | D25; no engine surface added | [K0 chip brief](../briefs/sol-doccer-k0-carrier-law-registry-20260804_151356.md) |
| K1a — immutable `AllenRelationSet`: private thirteen-bit value, canonical constants/construction, Boolean algebra, subset/membership, deterministic enumeration, and pointwise converse; all 8192 values plus the six-boundary classifier bridge checked (harness 1500→1561) | 2026-08-04 | D26; first K1 chip | [K1a chip brief](../briefs/sol-doccer-k1a-allen-relation-set-20260804_152127.md) |
| K1b–K4 sequencing adjudication — separated completion priority from type dependency; narrowed K1b migration; made K2 a jointly specified selection/pairing tranche; moved terminal join replacement to K2b; separated selection membership from ordering; co-designed geometry-only K3 with the identity-bearing K4a graph; shifted bounded witnesses into their owning tranches | 2026-08-04 | D27; no engine surface added | [sequencing brief](../briefs/sol-doccer-k1b-k4-resequencing-20260804_184200.md) |
| K1b — canonical Allen semantic closure: literal 169-cell `AllenCompose` table; independent endpoint-predicate JEPD and exhaustive \(D_6\) oracle (15 intervals, 3,375 triples, 409 atomic triads); composition laws and adjacent-gap boundary; durable validation filters migrated without touching the terminal join (harness 1561→1577; **K1 closed**) | 2026-08-04 | D28 | [K1b chip brief](../briefs/sol-doccer-k1b-allen-composition-20260804_203325.md) |
| Joint K2 contract freeze — exact occurrence bases and order; `ClaimSelection` integrations; direct reference `ComposePairs`; complete middle witnesses; one-way Allen-image inclusion with adjacent-gap non-converse; terminal-join transition owner; pairing residue; concrete deferred-Lean reactivation gate (planning-only, harness remains 1577) | 2026-08-04 | D29; no engine surface added | [joint K2 contract brief](../briefs/sol-doccer-k2-joint-contract-20260804_214547.md) |
| K2a — immutable exact-batch `ClaimSelection`: validated construction, Boolean occurrence algebra, value equality/hash, ascending-ordinal enumeration, explicit `ClaimOrder` record projections, identity-forgetting `Coverage()`, and selection-backed grouping/cadence/suppression conveniences; all 64 subsets and 4,096 ordered pairs on a bounded basis plus a 70-claim word-boundary witness (harness 1577→1651) | 2026-08-04 | D30; first K2 implementation chip | [K2a chip brief](../briefs/sol-doccer-k2a-claim-selection-20260804_221441.md) |
| K2b — exact `ClaimPairView`: derived Allen-labeled occurrence edges, ordinal identity, converse, projections, exact-basis semijoins, direct `ComposePairs`, basis-stamped complete middle witnesses, executable one-way Allen bridge, and terminal `IntervalJoins.Join` projection; 16 bounded relations, 256 differential compositions, 4,096 associative triples, and 3,375 atomic witness paths (harness 1651→1733) | 2026-08-05 | D31; second K2 implementation chip | [K2b chip brief](../briefs/sol-doccer-k2b-claim-pair-view-20260805_022512.md) |
| K2c — strict stack `PairingResult`: exact role selections and named compatibility-policy stamp; forward one-to-one noncrossing `ClaimPairView` matches; complete unclosed/dangling/mismatched residue with correlated mismatch pairs; explicit identity-forgetting paired envelopes; environment/fence witnesses, combined adversarial residue, and all 5,461 two-key words through length six against an independent oracle (harness 1733→1779; **K2 closed**) | 2026-08-05 | D32; final K2 implementation chip | [K2c chip brief](../briefs/sol-doccer-k2c-pairing-result-20260805_093203.md) |
| Joint K3/K4 read-ahead and contract freeze — retained the flat-before-policy-before-hierarchy macro-order, but changed the internal course before code: the located algebra and minimal identity-bearing graph projection now form one core chip; one geometry closure feeds a distinct ordinal-bearing path layer; `SelectionResidual` stays out of pre-policy K4a; the chunk witness is budget-admissible rather than costed; and K4b starts with objective-structured flat-path execution instead of a universal solver. Reason: parallel claim paths collapse under geometry projection, while arbitrary subset objectives do not define one reusable optimizer before packing/laminar result families exist (planning-only; harness remains 1779) | 2026-08-05 | D33; joint K3/K4a contract frozen, implementation pending | [joint K3/K4a contract brief](../briefs/sol-doccer-k3-k4a-joint-contract-20260805_105443.md) |

## Notes worth keeping beside the table

- **Tier-1 precision** (from the sol review): the callable runtime runner (`ValidateIntrinsic`)
  checks atom coverage and claim bounds only; reconstruction, line consistency, suppression
  laws, resolution determinism, and interning round-trip are harness **test laws**. A runtime
  Tier-1 runner exposing them is a named, unscheduled candidate (roadmap queue, discretionary).
- **Tranche 3a finding**: the anticipated PerLine mid-line-window caveat dissolved — collection
  commutes with rebase for both execution scopes, because both routes match identical sliced
  region strings. Stated in D19.
- **Repo events, same day**: `packages/` was untracked (refreshes are local-only; the manifest
  is the provenance), then `packages/` and `node_modules/` were purged from all history —
  every pre-rewrite commit hash changed, and in-repo citations were remapped. Older clones'
  hashes will not resolve.
- **Sequencing corrections** (sol review, folded into the queue at the time): Tranche 3 was
  split into per-law-surface chips, and the harvest survey was moved ahead of the first durable
  CLI contract so the survey grounds the verb grain.
