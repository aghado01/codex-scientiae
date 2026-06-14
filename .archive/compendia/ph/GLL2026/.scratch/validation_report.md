# Validation Report — GLL2026

> **44 issue(s)** across 3 page file(s). Address in page slices before running assemble_pages.py.

## page_004.md

- Line 5: Alternate math delimiter \[ \] or \( \) — use $ or $$: …In Section 3.1 , we provide an overview of the basic process of the Ma
- Line 7: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Filter function selection . To obtain general theoretical guarantees, 
- Line 13: Alternate math delimiter \[ \] or \( \) — use $ or $$: …In this paper, we employ linear projections as filter functions, for w
- Line 17: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Input: A point set \( X \subseteq \mathbb{R}^2 \) , clustering paramet
- Line 19: Alternate math delimiter \[ \] or \( \) — use $ or $$: …# Output: Mapper graph \( G \) of \( X \)
- Line 21: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- 1: Construct the initial Mapper graph \( G \)
- Line 22: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- 2: Set \( V_{split} = \emptyset \) .
- Line 25: Alternate math delimiter \[ \] or \( \) — use $ or $$: …set \( X_i \) corresponding to the node \( v_i \) in \( G \) do
- Line 27: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- 4: Compute the number of intervals \( S_i \) corresponding to \( X_i
- Line 33: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- 5: if \( S_i \geq 2 \) then
- Line 34: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Next, we compute the covariance matrix \( \Sigma = ( \sigma_{i,j} ) \)
- Line 35: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- 6: Add the node \( v_i \) to \( V_{split} \)
- Line 44: Alternate math delimiter \[ \] or \( \) — use $ or $$: …nodes in \( V_{split} \) that belong to the same connected component i
- Line 46: Alternate math delimiter \[ \] or \( \) — use $ or $$: …The eigenvector corresponding to the largest eigenvalue of \( \Sigma \
- Line 48: Alternate math delimiter \[ \] or \( \) — use $ or $$: …10: for each point set \( X_i \) corresponding to the node \( v_i \) i
- Line 50: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Construct the Mapper subgraph \( G_i \) corresponding to \( X_i \) usi
- Line 56: Alternate math delimiter \[ \] or \( \) — use $ or $$: …for each point set \( X_{nei} \) corresponding to neighboring node \( 
- Line 60: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Clustering method and parameter calculation . To guarantee the topolog
- Line 62: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Merge all nodes in \( G_i \) where their corresponding point sets inte
- Line 66: Alternate math delimiter \[ \] or \( \) — use $ or $$: …- 15: Replace \( v_i \) with all nodes from \( G_i \) .
- Line 70: Alternate math delimiter \[ \] or \( \) — use $ or $$: …edges to \( G \) according to the edge addition rule of the Mapper alg
- Line 72: Alternate math delimiter \[ \] or \( \) — use $ or $$: …graph based on \( X \) , where an edge is drawn between two distinct p
- Line 74: Alternate math delimiter \[ \] or \( \) — use $ or $$: …18: return \( G \)
- Line 80: Alternate math delimiter \[ \] or \( \) — use $ or $$: …The parameter \( \delta \) should satisfy the following conditions:

## page_005.md

- Line 17: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Fig. 3: Generation of the initial Mapper graph, \( \theta_{ov} = 0.2 \
- Line 19: Alternate math delimiter \[ \] or \( \) — use $ or $$: …where \( \mathrm{rch} \) and \( \rho \) denote the reach and convexity
- Line 21: Alternate math delimiter \[ \] or \( \) — use $ or $$: …taken as the center of its corresponding bounding box, an upper bound 
- Line 23: Alternate math delimiter \[ \] or \( \) — use $ or $$: …singular points (i.e., points of tangential discontinuity), the numeri
- Line 25: Alternate math delimiter \[ \] or \( \) — use $ or $$: …issue later. Cover construction. Given the filter function \( f : X \t
- Line 31: Alternate math delimiter \[ \] or \( \) — use $ or $$: …where \( \ell(\cdot) \) denotes the Lebesgue measure on \( \mathbb{R} 

## page_007.md

- Line 3: Alternate math delimiter \[ \] or \( \) — use $ or $$: …First, we merge all adjacent nodes in \( V_{split} \) into a single no
- Line 5: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Next, for each node \( v_i \) in \( V_{split} \), we use \( f^{\perp} 
- Line 7: Alternate math delimiter \[ \] or \( \) — use $ or $$: …node \( v_i \) and one of its neighboring nodes \( v_j \) may be assig
- Line 9: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Finally, we add new edges to modified graph \( G \) between nodes foll
- Line 11: Alternate math delimiter \[ \] or \( \) — use $ or $$: …ation. Specifically, the nodes in the lowest connected subgraph of \( 
- Line 15: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Using the two-step Mapper algorithm, we can generate the Mapper graph 
- Line 19: Alternate math delimiter \[ \] or \( \) — use $ or $$: …\( B_1(u,v) \in [u_s, u_e] \times [v_s, v_e] \). A boundary point is a
- Line 25: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Due to the overestimation property of the subdivision method, we need 
- Line 31: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Then we define a node \( v_{bou} \) as a boundary node if its correspo
- Line 33: Alternate math delimiter \[ \] or \( \) — use $ or $$: …A singular point is a point where the curve does not have a unique tan
- Line 35: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Finally, we partition \( P_{1,u,v} \) based on the connection relation
- Line 43: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Thus, through such grouping, we can partition \( P_{1,u,v} \) into sev
- Line 45: Alternate math delimiter \[ \] or \( \) — use $ or $$: …In Fig. 5(c), yellow and blue circles mark boundary nodes and singular
- Line 49: Alternate math delimiter \[ \] or \( \) — use $ or $$: …Unlike algebraic methods, subdivision methods inherently preserve corr
