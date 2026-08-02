# Doccer Tranche 3c+3d chip brief — gap cadence + priority-aware lookup (Tranche 3 closeout)

Runstamp 20260802_012056. One brief for both remaining chips (they are small, independent, and
executed in one sitting — a single coordinated chip per the user's chipping guidance). Same
piloting session as 3a/3b; executed in-session. Canon: [planning/decisions.md](../planning/decisions.md)
(D1–D22), [planning/roadmap.md](../planning/roadmap.md). Harness: 1456 checks green.

## 3c — gap cadence, the first named density measure (D8)

The mdnav template was consulted directly (`doc-dive/mdnav/mdnav.mjs`, `cadence(starts,
docBytes)`): gaps between successive construct **starts**; outputs median gap, cv (sd/mean —
near 0 = evenly spaced/partitioning, above ~1 = bursty/content), and span fraction
(last−first)/doc; interpretation thresholds (cv < 0.6, span > 0.6, ≥4 occurrences) live in the
CALLER. The engine measure must keep that D10 line: compute facts whenever they are defined,
embed no meaning thresholds.

Contract to close (D8 declaration discipline — every component named):

- **Name**: `GapCadence.Measure` — the name pins the semantics; a start-to-start gap is THE
  measure. An end-to-start interstice measure would be a *separate named measure*, never a
  parameter (D8: no generic verbs, no semantic knobs).
- **Numerator facts**: gap count; median gap (the template's upper-median convention, stays in
  the integer value domain); mean gap; gap cv (template: 0 when mean is 0); span fraction.
  Facts are present whenever defined — ≥2 population members give gaps, fewer give absent
  (null) statistics; the ≥4 meaning-threshold belongs to consumers.
- **Denominator / window basis**: an explicit window (default = master extent), validated by
  the master; span-fraction denominator = window length; declared address unit rides the stamp
  (`AddressUnit.Utf16CodeUnit` — mdnav measured bytes; doccer measures code units, and saying
  so is the point of basis stamping).
- **Boundary policy**: the measure anchors on claim **starts**; the window admits a claim iff
  its start lies within the window. Stated, not implied.
- **Exclusions**: caller predicate (D3 discipline — suppression/selection is query policy);
  the result records the measured population as ordinals in deterministic start order
  (`Sorted` order), so the exclusion is *evidence on the result*, not a lost delegate.
- **Basis stamp** (D21): Source batch, Master, Window, Unit, Ordinals on the result object.

## 3d — priority-aware lookup (D2/D5 realized at the query surface)

- `ClaimOrder` enum: `Geometry` (the existing stable start-order) and `PriorityThenGeometry`
  (priority **descending** — the D2 max-priority default posture — then start asc, end desc,
  then ordinal: a total order, so determinism needs no stability argument).
- Optional `order` parameter on `FindIntersecting` and `FindContaining`, defaulting to
  `Geometry` (no behavior change for existing callers). Resolution order = query policy (D5);
  the data model does not change. Undefined casts refused (D9). Pure per-query ordering —
  acceleration structures are F4's business.

## Law surface

3c: template agreement on an evenly spaced population (cv 0, median = spacing, span fraction
exact); bursty population (cv > 1); upper-median convention on even gap counts; exclusion
predicate + ordinals evidence; window admission by start (straddling starts in, outside starts
out) and window-length denominator; degenerate populations (empty, singleton, pair, empty
window); insertion-order independence (measured in start order); determinism; stamps
reference-equal. 3d: default order unchanged; priority-descending order with geometry ties
stable; equal-geometry equal-priority falls to ordinal; both query forms honor the parameter;
undefined order refused; determinism.

## Boundaries

No generic density verb, no thresholds in the engine, no acceleration (F4), no new claim
mutation paths. Keep README/planning in agreement; targeted commits citing this brief; payload
refresh after engine changes. This closes Tranche 3; the harvest survey is next in the queue.

## Done criteria

Contracts recorded (D23 gap cadence, D24 lookup order; D8 status advanced), laws green with
new check count, README/planning updated, payload refreshed, report appended below.

---

## Report

Completed 2026-08-02, in-session by the minting agent (same mode as 3a/3b). Harness
**1456 → 1500 checks green**; payload refreshed via `build-doccer.ps1`. **Tranche 3 is
closed.**

**3c — gap cadence (D23):** `src/doccer/Algebra/GapCadence.cs`. Contract landed exactly as
briefed: the name pins start-to-start semantics; facts (count, upper-median gap, mean, cv with
the template's mean-zero convention, span fraction) present whenever defined — ≥2 members —
and absent otherwise; window basis declared and validated, admitting by claim start, its
length the span-fraction denominator; `AddressUnit` on the stamp; exclusions = caller
predicate, recorded as measured ordinals in deterministic start order. The D10 line held with
no temptation: mdnav's ≥4-occurrence guard and cv thresholds appear nowhere in the engine —
the harness instead witnesses that an evenly spaced population reports cv 0 and a bursty one
reports cv > 1, leaving "evenly" and "bursty" to the caller.

**3d — lookup order (D24):** `ClaimOrder` on `SortedSpanLookup.FindIntersecting` /
`FindContaining`, default `Geometry` (zero behavior change — witnessed by asserting the named
default equals the unnamed call). `PriorityThenGeometry` = priority desc, start asc, end desc,
ordinal — a total order, so determinism is structural rather than argued from sort stability.
Undefined casts refused at entry, before any gathering.

**Laws landed** (`GapCadenceMeasuresTheTemplateFacts`, `GapCadenceDeclaresItsBasis`,
`LookupOrderIsAQueryPolicy`): template agreement (even spacing → cv 0, median = spacing, span
0.8; bursts → cv > 1), upper-median on even gap counts, insertion-order independence with
ordinals evidence, window admission by start (straddler excluded, not clamped), degenerate
populations reporting absence not judgment, determinism on repeat, stamps reference-equal;
lookup default regression, priority ordering with ordinal ties, point-query parity, undefined
order refusal.

**Tranche 3 closeout state**: contracts D19–D24; all Tranche-2 stragglers closed; D7 lift
vocabulary complete except materialize; D8 doctrine now has its template instance. Next in
queue: the harvest survey (feeds the CLI verb list), then CLI verbs, adapters last.
