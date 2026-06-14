# Validation Report — GVPB2025

> **46 issue(s)** across 6 page file(s). Address in page slices before running assemble_pages.py.

## page_004.md

- Line 39: Alternate math delimiter \[ \] or \( \) — use $ or $$: …We aim to study internal representations by tracking statistical chang
- Line 41: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\[
- Line 43: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\]
- Line 49: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\[
- Line 51: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\]
- Line 53: Alternate math delimiter \[ \] or \( \) — use $ or $$: …where we define \( L \equiv N \) layers for conciseness. This sequence

## page_005.md

- Line 3: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Comparison to similar frameworks. A distinguishing feature of our meth
- Line 5: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Zigzag Persistence Diagram. The output of the zigzag algorithm is then
- Line 11: Alternate math delimiter \[ \] or \( \) — use $ or $$: …We thus work with a zigzag filtration naturally indexed by \(\{ 0, 1, 
- Line 13: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Effective Persistence Image. The pairs generated within Pers p (Φ) can
- Line 19: Alternate math delimiter \[ \] or \( \) — use $ or $$: …where \(PI_p\) is the effective persistence image for the \(p\)-dimens
- Line 23: Alternate math delimiter \[ \] or \( \) — use $ or $$: …The collection of \(PI_p\)s taken over all \(p\) contains all the info
- Line 25: Alternate math delimiter \[ \] or \( \) — use $ or $$: …^4 The repetition of a pair \([b, d]\) indicates that multiple holes i
- Line 27: Alternate math delimiter \[ \] or \( \) — use $ or $$: …^5 Note that this operation does not modify the information about the 

## page_006.md

- Line 3: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Births’ Relative Frequency. A useful way to summarize a persistence di
- Line 15: Alternate math delimiter \[ \] or \( \) — use $ or $$: …is a weight with varying exponent \( \alpha \). 6 For negative values 
- Line 17: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Inter-Layer Persistence. To better track the persistence of features a
- Line 23: Alternate math delimiter \[ \] or \( \) — use $ or $$: …where \( M_1 = \min(\ell_1, \ell_2) \); \( M_2 = \max(\ell_1, \ell_2) 
- Line 29: Alternate math delimiter \[ \] or \( \) — use $ or $$: …where we fix one of the two layers and average over all other layers, 
- Line 39: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Each prompt is processed from these datasets to extract the last token
- Line 45: Alternate math delimiter \[ \] or \( \) — use $ or $$: …8 Note that equation 7 is well-defined only when \( \beta_p(\ell) > 0 

## page_016.md

- Line 13: Alternate math delimiter \[ \] or \( \) — use $ or $$: …where each \( X_i \) is a topological space and each arrow \( \longlef
- Line 15: Alternate math delimiter \[ \] or \( \) — use $ or $$: …If we apply a homology functor \( H_p \) with coefficients in a field 
- Line 21: Alternate math delimiter \[ \] or \( \) — use $ or $$: …It is proven in [31] that the algebraic classification of zigzag modul
- Line 27: Alternate math delimiter \[ \] or \( \) — use $ or $$: …where \( I_i = k \) for \( b \leq i \leq d \), and \( I_i = 0 \) other
- Line 29: Alternate math delimiter \[ \] or \( \) — use $ or $$: …The zigzag persistence diagram of a filtration \( \chi \) in dimension
- Line 35: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Each interval \( [b, d] \) is called persistence interval and is thoug
- Line 37: Alternate math delimiter \[ \] or \( \) — use $ or $$: …In our approach, the use of intersection layers is essential for compu
- Line 39: Alternate math delimiter \[ \] or \( \) — use $ or $$: …For an interval \( [b, d] \) in the zigzag persistence diagram of dime
- Line 45: Alternate math delimiter \[ \] or \( \) — use $ or $$: …The relationship between the persistence image and the effective persi
- Line 47: Alternate math delimiter \[ \] or \( \) — use $ or $$: …$^{13}$ In our setting we say a \( p \)-dimensional holes “dies”, we m

## page_017.md

- Line 3: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\[
- Line 5: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\]
- Line 13: Alternate math delimiter \[ \] or \( \) — use $ or $$: …**Require:** `model`, `dataset`, \( k_{NN} \), \( m \)
- Line 14: Alternate math delimiter \[ \] or \( \) — use $ or $$: …1. `reps` \( \leftarrow \) `extractRepresentations(model, dataset)`
- Line 15: Alternate math delimiter \[ \] or \( \) — use $ or $$: …2. `K` \( \leftarrow \) `[]`
- Line 16: Alternate math delimiter \[ \] or \( \) — use $ or $$: …3. **for** \( i \leftarrow 1 \) **to** `model.getNumLayers()` **do**
- Line 17: Alternate math delimiter \[ \] or \( \) — use $ or $$: …4. &nbsp;&nbsp;&nbsp;&nbsp;`graph` \( \leftarrow \) `kNearestNeighbors
- Line 20: Alternate math delimiter \[ \] or \( \) — use $ or $$: …7. \( K_{int} \leftarrow \) `computeIntersectionLayers(K)`
- Line 21: Alternate math delimiter \[ \] or \( \) — use $ or $$: …8. \( f \), `times` \( \leftarrow \) `computeFiltrationTimes(K, \( K_{
- Line 22: Alternate math delimiter \[ \] or \( \) — use $ or $$: …9. \( \Phi \leftarrow \) `FastZigZag(f, times)`
- Line 24: Alternate math delimiter \[ \] or \( \) — use $ or $$: …It exploits two existing public codes that were developed for zigzag c
- Line 34: Alternate math delimiter \[ \] or \( \) — use $ or $$: …We extract hidden representations from all 33 transformer layers[^16] 

## page_024.md

- Line 16: Alternate math delimiter \[ \] or \( \) — use $ or $$: …1. `layersToRemove` \( \leftarrow \) `[]`
- Line 17: Alternate math delimiter \[ \] or \( \) — use $ or $$: …2. **for** \( l \leftarrow 1 \) **to** `model.getNumLayers()` **do**
- Line 18: Alternate math delimiter \[ \] or \( \) — use $ or $$: …3. &nbsp;&nbsp;&nbsp;&nbsp;**if** \( Z_1[l] > \max * \text{threshold} 
