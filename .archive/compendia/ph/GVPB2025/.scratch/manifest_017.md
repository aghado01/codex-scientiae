# Manifest: Page 017

## REPAIR_MATH
- RAW: ```
$$
\begin{cases} \widehat { P I } _ { p } ( 0 , 0 ) = & P I _ { p } ( 0 , 0 ) \\ \widehat { P I } _ { p } ( b / 2 , d / 2 ) = & P I _ { p } ( b , d ) + P I _ { p } ( b - 1 , d ) \\ & + P I _ { p } ( b , d - 1 ) + P I _ { p } ( b - 1 , d - 1 ) \\ \widehat { P I } _ { p } ( b / 2 , \infty ) = & P I _ { p } ( b , \infty ) + P I _ { p } ( b - 1 , \infty ) . \end{cases}
$$
```
  FIX: ```
\[
\begin{cases} \widehat { P I } _ { p } ( 0 , 0 ) = & P I _ { p } ( 0 , 0 ) \\ \widehat { P I } _ { p } ( b / 2 , d / 2 ) = & P I _ { p } ( b , d ) + P I _ { p } ( b - 1 , d ) \\ & + P I _ { p } ( b , d - 1 ) + P I _ { p } ( b - 1 , d - 1 ) \\ \widehat { P I } _ { p } ( b / 2 , \infty ) = & P I _ { p } ( b , \infty ) + P I _ { p } ( b - 1 , \infty ) . \end{cases}
\]
```

## REPAIR_PROSE
- RAW: ```
Algorithm 1 Zigzag algorithm Require: )

model, dataset, k NN , m reps ← extractRepresentations( model, dataset ) K ← [] for i ← 1 to model. getNumLayers() do graph ← kNearestNeighborsGraph( reps [ i ] , k NN K .append(graphExpansion( graph, m ) end for K int ← computeIntersectionLayers(K) f, times ← computeFiltrationTimes( K,K int ) Φ ← FastZigZag( f, times )
```
  FIX: ```
**Algorithm 1** Zigzag algorithm

**Require:** `model`, `dataset`, \( k_{NN} \), \( m \)
1. `reps` \( \leftarrow \) `extractRepresentations(model, dataset)`
2. `K` \( \leftarrow \) `[]`
3. **for** \( i \leftarrow 1 \) **to** `model.getNumLayers()` **do**
4. &nbsp;&nbsp;&nbsp;&nbsp;`graph` \( \leftarrow \) `kNearestNeighborsGraph(reps[i], \( k_{NN} \))`
5. &nbsp;&nbsp;&nbsp;&nbsp;`K.append(graphExpansion(graph, m))`
6. **end for**
7. \( K_{int} \leftarrow \) `computeIntersectionLayers(K)`
8. \( f \), `times` \( \leftarrow \) `computeFiltrationTimes(K, \( K_{int} \))`
9. \( \Phi \leftarrow \) `FastZigZag(f, times)`
```
- RAW: ```
It exploits two existing public codes that were developed for zigzag computations: D IONYSUS 2 [78] and FASTZIGZAG [59]. D IONYSUS 2 is a C ++ library for computing persistent homology, with a specific library for zigzag persistence. In our case, it has the role of extracting the filtration f and computing the times array, i.e. the list of layer indices to be associated with the birth and death of features. FASTZIGZAG allows to calculate efficiently the persistence diagram Pers p (Φ) by converting the input zigzag filtration to a non-zigzag filtration of an equivalent complex with the same length, and it then converts the obtained persistence intervals back to zigzag. The computational cost of our algorithm is O ( n 2 ∗ N layers ) + O ( m ω ) where the first part is the K NN graph creation cost for the input dataset at each layer, and the second part is the theoretical cost of FastZigZag with ω < 2 . 37286 . The algorithm performs well even for the relatively large datasets we employ for this analysis: with 10 K points embedded in a space with dimension d = 4096 , a number of neighbors for the k NN graph of k NN = 10 , and a maximum homology dimension of m = 10 on an AMD EPYC 7H12 it takes approximately 2 hours.
```
  FIX: ```
It exploits two existing public codes that were developed for zigzag computations: DIONYSUS 2 [78] and FASTZIGZAG [59]. DIONYSUS 2 is a C++ library for computing persistent homology, with a specific library for zigzag persistence. In our case, it has the role of extracting the filtration \( f \) and computing the times array, i.e. the list of layer indices to be associated with the birth and death of features. FASTZIGZAG allows to calculate efficiently the persistence diagram \( \text{Pers}_p(\Phi) \) by converting the input zigzag filtration to a non-zigzag filtration of an equivalent complex with the same length, and it then converts the obtained persistence intervals back to zigzag. The computational cost of our algorithm is \( \mathcal{O}(n^2 * N_{\text{layers}}) + \mathcal{O}(m^\omega) \) where the first part is the \( k_{NN} \) graph creation cost for the input dataset at each layer, and the second part is the theoretical cost of FastZigZag with \( \omega < 2.37286 \). The algorithm performs well even for the relatively large datasets we employ for this analysis: with 10K points embedded in a space with dimension \( d = 4096 \), a number of neighbors for the \( k_{NN} \) graph of \( k_{NN} = 10 \), and a maximum homology dimension of \( m = 10 \) on an AMD EPYC 7H12 it takes approximately 2 hours.
```
- RAW: ```
We extract hidden representations from all 33 transformer layers 16 and apply zigzag persistent homology with k = 2 neighbors and maximum simplex dimension 3. The point cloud at each layer comprises 12 tokens corresponding to the 12 different month prompts. We analyze two token positions: month tokens (semantic input) and answer tokens (given by the is token). So the point cloud at each layer comprises of 12 tokens for each prompt
```
  FIX: ```
We extract hidden representations from all 33 transformer layers[^16] and apply zigzag persistent homology with \( k = 2 \) neighbors and maximum simplex dimension 3. The point cloud at each layer comprises 12 tokens corresponding to the 12 different month prompts. We analyze two token positions: month tokens (semantic input) and answer tokens (given by the "is" token). So the point cloud at each layer comprises of 12 tokens for each prompt.
```
- RAW: ```
16 Layer 0 is the embedding layer.
```
  FIX: ```
[^16]: Layer 0 is the embedding layer.
```
