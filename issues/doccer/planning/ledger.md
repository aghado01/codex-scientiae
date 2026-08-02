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
  CLI contract so the survey freezes the verb grain.
