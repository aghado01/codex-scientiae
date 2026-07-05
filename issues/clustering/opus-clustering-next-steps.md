That reframes the deliverable, and it's the right instinct — because the consensus you need here and the unification you've parked in ThermoMapper are _the same abstraction wearing two costumes_. Let me make the connection precise, because it tells us exactly what altitude to build at.

**HDBSCAN's excess-of-mass and SPC's thermal stability are the same quantity.** HDBSCAN selects clusters by persistence along λ = 1/distance (a cluster's stability = the λ-interval it survives before splitting). SPC selects clusters by the _temperature_ interval a superparamagnetic cluster survives before the susceptibility peak dissolves it. Different filtration parameter (λ vs T), identical semantics: **cluster persistence along a monotone control parameter.** The common language that makes them interchangeable is the **merge-tree and its cophenetic distance** — the parameter level at which two points first fall in one cluster. Every hierarchical clusterer emits one; it's an ultrametric; and you're already half-way there in SPCX (there's a shared `Dendrogram`, plus `ThermalDendrogram`, `HierarchyEom`, and `LineagePersistence` all in the tree — the _structure_ is unified, it's the _semantics_ that aren't finished).

**This upgrades the pig consensus from a hack into that general concept.** My flat-partition union-find throws away the hierarchy. If instead each view emits a **cophenetic ultrametric** (geometry-HDBSCAN gives one from the dendrogram it _already produces_ — we walk it for de-frag; the provenance view gives a trivial one: same-binding-tag → level 0, else ∞, or IDF-graded), then consensus = **combine the views' cophenetic matrices** (your `SymmetrizationRule` min/max/mean _is_ the ultrametric combine) **→ single-linkage the combined matrix → cut.** That's Fred–Jain evidence accumulation generalized from _binary_ co-association ("did they co-cluster") to _graded_ cophenetic levels ("at what strength") — strictly more information, and completely algorithm-agnostic. The consensus never names HDBSCAN or Jaccard; it consumes lineages.

**So the thing to build is a thin `IClusterLineage`** — {monotone filtration axis, per-node persistence, `CopheneticLevel(i,j)`}. HDBSCAN satisfies it today, the provenance view satisfies it trivially, and SPC's `ThermalDendrogram` satisfies it later with zero change to the consensus code. That interface _is_ the "HDBSCAN and SPC speak the same language" abstraction you've been wanting — and it's also, not coincidentally, your persistence-as-primitive telos again: a merge-tree is 0-dimensional persistence, so consensus-over-merge-trees sits exactly on the SPC⇄HDBSCAN⇄PH junction ([[thermomapper-concept]], [[backbone-conditioned-persistence]]).

**The discipline that keeps this honest:** deploy the concrete pig fix _first_ — flat-partition union-find consensus is a perfectly good milestone-1, oracle-scored — then _earn_ the lineage/cophenetic abstraction as milestone-2 against the same benchmark, and only _then_ graft the validated abstraction back to ThermoMapper. Codex is the sandbox precisely because the pig oracle batch is a falsifiable test the abstraction has to pass; building the framework speculatively ahead of a working pig lane would invert that. The feedback direction stays codex → ThermoMapper, user-driven, after it works here.

Let me record this in the brief as the abstraction layer + the ThermoMapper feedback loop, and commit the whole brief update:

Now the memory note and the commit (brief only — the unrelated `reorg-plan.md` stays out):

Committed as `707ad98`. Here's where the design stands, recorded in the brief and memory:

**The Tier-2 architecture is now three layers, from concrete to general:**

1. **Pig fix (milestone-1, ships first):** images lane + geometry⊕provenance consensus via flat-partition union-find + Jaccard. Oracle-scored against the ph-zigzag batch.
2. **Lineage abstraction (milestone-2, earned by milestone-1):** consensus lifts to `IClusterLineage` — cophenetic ultrametrics combined by `SymmetrizationRule` → re-linkage → cut. Algorithm-agnostic; HDBSCAN's dendrogram already satisfies it.
3. **ThermoMapper feedback (user-driven, later):** SPC's `ThermalDendrogram` plugs into the same interface with zero consensus-code change — the unification you'd parked, now grounded in a falsifiable test.

The load-bearing insight I'd keep front of mind: **HDBSCAN excess-of-mass and SPC thermal-stability are the same quantity** (cluster persistence along a monotone parameter), so the merge-tree/cophenetic distance is the language that makes them interchangeable — which is why the pig consensus and the ThermoMapper unification are one abstraction, and why codex is a legitimate sandbox for it rather than a detour.

The discipline that keeps it from becoming speculative: the oracle batch (`compare.ps1`) is the gate. Nothing graduates from milestone-1 to milestone-2 until the `+38 / −8` tails actually collapse on real papers.

Practically, when you're ready to build, the entry point is the rewiring's `Invoke-Pdfdig.ps1` orchestrator + `src/hdbscan/` (Jaccard struct + a consensus module), and the first move is the PdfPig probe — it decides how much provenance is actually reachable, which is what determines whether the provenance view is strong or the dilation fallback carries more weight. Everything's committed and the memory carries the full arc into the next session.

Let me verify the actual source tree at `D:\aghado01\ThermoMapper\src` matches the snapshot's structure before I write paths into the brief — I'll probe the five clusters that matter (metrics, dendrogram, consensus primitives, SPC hierarchy, hashish):

Structure confirmed — the live tree at `D:\aghado01\ThermoMapper\src` matches the snapshot exactly; every target file is where the map says. That's all I need to write the navigation guide (mapping the points of interest is the ask; the actual milestone-2 spelunking of `HierarchyEom`/`LineagePersistence` stays deferred until milestone-1 ships). Adding the porting map to the brief:

Committed as `fcdd1b2`. The brief now carries a file-level porting map, verified against the live `D:\aghado01\ThermoMapper\src` tree (it matches the snapshot). Organized so a spelunking/porting session can work top-down:

**Milestone-1 (build the pig consensus) — PORT ~4 small files:**

- `maths/distance/Jaccard.cs` → wrap as `JaccardMetric : IDistanceMetric`
- `graphs/primitives/UnionFind.cs` + `EdgeFieldSymmetrization.cs`/`SymmetrizationRule.cs` (the AND/OR/weighted combine) + optional `mst/Boruvka.cs`
- SPC `UnionFindLabeler.cs` / `ThresholdCoMembership.cs` as labeling prior art

**Milestone-2 (the lineage abstraction) — STUDY, don't port yet:**

- `clustering/dendrogram/*` (incl. `ThermalDendrogram.cs`) for the `IClusterLineage` shape
- `spc/partitions/hierarchical/{HierarchyEom, LineagePersistence}.cs` — flagged as **the crux**: the EOM ≡ thermal-stability unification point

**Optional / Decline** are enumerated explicitly so nothing gets re-litigated — IDF+ContingencyTable optional; MinHash/LSH/fuzzy-hash/irrelevant-metrics/`CoMembership.cs` declined with reasons.

Two guardrails written into the map: **read-only** (port _into_ codex `src/hdbscan/`, never edit ThermoMapper — concurrent agents run there), and **re-verify at port time** in case the live tree drifted from this snapshot.

The clean entry point when you're ready to build: start with the Jaccard struct + a consensus module in `src/hdbscan/`, and the **PdfPig provenance probe** first — that's the gate that decides how strong the provenance view actually is, and everything downstream (τ, T_far, whether dilation-fallback carries weight) keys off it. The whole arc — ensemble spine, consensus logic, cross-algorithm abstraction, and now this porting map — is committed (`707ad98`, `fcdd1b2`) and mirrored in memory for the next session.
