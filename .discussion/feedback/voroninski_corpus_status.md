# **Vladislav Voroninski Corpus: Ingestion Status Report**

This document provides a comprehensive audit of the Vladislav Voroninski corpus ingestion, detailing where we stand on the preprocessing-to-finalization pipeline. 

The corpus comprises **15 academic papers** currently in the restoration membrane. All 15 papers have been successfully run through the deterministic preprocessing floor, with their chunk streams and scratch environments established.

---

## **Current Progress Dashboard**

| Paper / Slug | Title | Stage | Chunks | Pages | Actionable Hotspots | Next Actions |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- |
| **`1109.4499v1`** | [PhaseLift: Exact and Stable Signal Recovery...](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1109.4499v1/.scratch/1109.4499v1.md) | **Finalized** | 484 | 31 | **0** | Ready for Promotion |
| **`2008.10579v1`** | [Compressive Phase Retrieval: Optimal Sample Complexity...](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/2008.10579v1/.scratch/2008.10579v1.md) | **Finalized** | 874 | 62 | **0** | Ready for Promotion |
| **`1611.05985v3`** | [Compressed Sensing from Phaseless Gaussian...](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1611.05985v3/.scratch/1611.05985v3.md) | **Finalized** | 81 | 9 | **1** | Resolve remaining hotspot |
| **`1608.02165v1`** | [ShapeFit and ShapeKick for Robust, Scalable SfM...](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1608.02165v1/.scratch/1608.02165v1.md) | **Finalized** | 2028 | 16 | **5** | Resolve remaining hotspots |
| **`1611.03935v1`** | [An Proof of Convex Phase Retrieval... (PhaseMax)](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1611.03935v1/.scratch/1611.03935v1.md) | **Finalized** | 65 | 5 | **7** | Resolve remaining hotspots |
| **`1309.7669v1`** | [Quantum tomography from few full-rank observables.](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1309.7669v1/1309.7669v1.md) | Preprocessed | 161 | 16 | **10** | Perform repair pass & finalize |
| **`1404.3811v1`** | [A STRONG R.I.P., WITH AN APPLICATION TO ...](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1404.3811v1/1404.3811v1.md) | Preprocessed | 158 | 10 | **18** | Perform repair pass & finalize |
| **`1506.01437v2`** | [ShapeFit: Exact location recovery from corrupted...](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1506.01437v2/1506.01437v2.md) | Preprocessed | 426 | 34 | **49** | Perform repair pass & finalize |
| **`1602.04426v2`** | [On the low-rank approach for semidefinite programs...](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1602.04426v2/1602.04426v2.md) | Preprocessed | 260 | 22 | **25** | Perform repair pass & finalize |
| **`1606.04970v3`** | [The non-convex Burer-Monteiro approach works...](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1606.04970v3/1606.04970v3.md) | Preprocessed | 3810 | 19 | **66** | Perform repair pass & finalize |
| **`1705.07576v3`** | [Global Guarantees for Enforcing Deep Generative Priors...](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1705.07576v3/1705.07576v3.md) | Preprocessed | 437 | 33 | **84** | Perform repair pass & finalize |
| **`1804.02008v2`** | [Deterministic guarantees for Burer-Monteiro ...](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1804.02008v2/1804.02008v2.md) | Preprocessed | 339 | 28 | **64** | Perform repair pass & finalize |
| **`1807.04261v1`** | [Phase Retrieval Under a Generative Prior](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1807.04261v1/1807.04261v1.md) | Preprocessed | 537 | 28 | **21** | Perform repair pass & finalize |
| **`1812.04176v1`** | [A Provably Convergent Scheme for Compressive Sensing...](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1812.04176v1/1812.04176v1.md) | Preprocessed | 344 | 30 | **52** | Perform repair pass & finalize |
| **`2011.00288v2`** | [Optimal Sample Complexity of Subgradient Descent...](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/2011.00288v2/2011.00288v2.md) | Preprocessed | 161 | 14 | **28** | Perform repair pass & finalize |

---

## **Detailed Analysis**

### **1. Finished and Ready for Promotion (2 Papers)**
These papers have `pending == 0` actionable hotspots remaining, have been successfully compiled into deliverables in their `.scratch` directories, and pass the `Find-MathClosureIssues` validation checks.
* **[1109.4499v1](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1109.4499v1/.scratch/1109.4499v1.md)** — *PhaseLift: Exact and Stable Signal Recovery from Magnitude Measurements via Convex Programming*
  * **Status**: 100% complete, verified clean math closures.
  * **Files**: [Finalized MD](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1109.4499v1/.scratch/1109.4499v1.md), [References Sidecar](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1109.4499v1/.scratch/references/1109.4499v1.md), [Ledger](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1109.4499v1/.scratch/1109.4499v1.ledger.jsonl)
* **[2008.10579v1](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/2008.10579v1/.scratch/2008.10579v1.md)** — *Compressive Phase Retrieval: Optimal Sample Complexity with Deep Generative Priors*
  * **Status**: 100% complete, verified clean math closures.
  * **Files**: [Finalized MD](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/2008.10579v1/.scratch/2008.10579v1.md), [References Sidecar](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/2008.10579v1/.scratch/references/2008.10579v1.md), [Ledger](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/2008.10579v1/.scratch/2008.10579v1.ledger.jsonl)

> [!TIP]
> Both papers are ready to be promoted into the main corpus following the promotion steps.

---

### **2. Provisionally Finalized (3 Papers)**
These papers have been run through `finalize` but still carry outstanding hotspots that prevent them from meeting the "finished" threshold for promotion. 
* **`1611.05985v3`** — *Compressed Sensing from Phaseless Gaussian Measurements...*
  * **Status**: 1 remaining hotspot.
  * **Details**: [Chunk 38](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1611.05985v3/.scratch/1611.05985v3.chunks.jsonl#L38) on Page 6 has unwrapped inline math:
    `Now, if $m > 3 . 5 2 \cdot ˜ C 5 1 ( \alpha / 20 ) 5 \xi 2 k log 2$ nξ 2 3 . 5 2 k then $\delta$ := $˜ C 1 ( s m log 2 n s ) 1 / 5 < \alpha 20$ , where $s = 3 . 5 2 \xi 2 k$ .`
* **`1608.02165v1`** — *ShapeFit and ShapeKick for Robust, Scalable Structure from Motion*
  * **Status**: 5 remaining hotspots.
  * **Details**: Mostly `needs_review` tasks flags for metadata or inline math.
* **`1611.03935v1`** — *An Elementary Proof of Convex Phase Retrieval... (PhaseMax)*
  * **Status**: 7 remaining hotspots.
  * **Details**: Needs repair on `intertext` issues, `unbalanced_delimiters`, and `prose_in_formula` (e.g. [Chunk 14](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/ingestion/corpora/voroninski/1611.03935v1/.scratch/1611.03935v1.chunks.jsonl#L14) on Page 2).

---

### **3. Preprocessed Only (10 Papers)**
These papers were preprocessed today (`6/22/2026` between `5:45 AM` and `5:51 AM`). They have not yet undergone membrane repairs or finalization and have substantial numbers of flagged/actionable chunks (ranging from 10 to 84).

---

## **Action Plan & Next Steps**

### **Step 1: Promote the Finished Papers**
Move the completed deliverables of `1109.4499v1` and `2008.10579v1` to the `corpora/VladVoroninski/` directory following the project's promotion rules:
1. Move body: `.scratch/{slug}.md` &rarr; `corpora/VladVoroninski/{slug}.md`
2. Move bibliography: `.scratch/references/{slug}.md` &rarr; `corpora/VladVoroninski/References/{slug}-references.md`
3. Edit the promoted body to update its references link from `references/{slug}.md` to `../References/{slug}-references.md`.

### **Step 2: Clean Up the Remaining Hotspots in Provisionally Finalized Papers**
Use `propose_edit`, `retype_chunk`, `split_chunk`, or `merge_chunks` to resolve the flagged hotspots in `1611.05985v3`, `1608.02165v1`, and `1611.03935v1`, then run `finalize` to compile clean versions.

### **Step 3: Run Swarm / Repair Loop on Preprocessed Papers**
For the remaining 10 papers, run the worker loop (dispatching chunks, proposing edits, applying, and then finalizing).
