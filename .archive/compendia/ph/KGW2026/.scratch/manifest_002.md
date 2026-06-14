# Manifest: Page 002

## REPAIR_MATH
- RAW: ```
P _ { C } ( \xi ) = \sum \dim ( C _ { i } ) \, \xi ^ { i }
```
  FIX: ```
\[
P _ { C } ( \xi ) = \sum \dim ( C _ { i } ) \, \xi ^ { i }
\]
```
- RAW: ```
P _ { C } ( \xi ) = \frac { 1 } { 1 - \xi ^ { q } } \sum \xi ^ { i } ( \dim ( H _ { i } ^ { N , q } ) - \dim ( H _ { i - q } ^ { N , N - q } ) ) .
```
  FIX: ```
\[
P _ { C } ( \xi ) = \frac { 1 } { 1 - \xi ^ { q } } \sum \xi ^ { i } ( \dim ( H _ { i } ^ { N , q } ) - \dim ( H _ { i - q } ^ { N , N - q } ) ) .
\]
```

## REPAIR_PROSE
- RAW: ```
In the standard homology setting, the boundary operator satisfies d 2 = 0. The homology defined using an N -nilpotent boundary map satisfying d N = 0 for an integer N ≥ 2 on N -chain complexes is called Mayer homology . This idea was first introduced by Mayer in 1942 [13]. The notion of an N -chain complex naturally arises as a graded object equipped with an N -nilpotent differential. From this structure, Mayer defined a family of homology groups depending on an additional parameter q , thereby extending the classical construction of cycles and boundaries.
```
  FIX: ```
In the standard homology setting, the boundary operator satisfies \( d^2 = 0 \). The homology defined using an \( N \)-nilpotent boundary map satisfying \( d^N = 0 \) for an integer \( N \geq 2 \) on \( N \)-chain complexes is called Mayer homology. This idea was first introduced by Mayer in 1942 [13]. The notion of an \( N \)-chain complex naturally arises as a graded object equipped with an \( N \)-nilpotent differential. From this structure, Mayer defined a family of homology groups depending on an additional parameter \( q \), thereby extending the classical construction of cycles and boundaries.
```
- RAW: ```
Shortly thereafter, Spanier further developed Mayer’s theory and clarified its relationship with classical homology [16]. In particular, he showed that Mayer homology coincides with standard homology when the coefficient field has prime characteristic p . Although Mayer’s original work remained relatively isolated for several decades, the underlying idea of N -complexes re-emerged in modern algebra. In particular, N -complexes have been systematically studied as natural generalizations of chain complexes, equipped with a differential satisfying d N = 0, giving rise to a family of homology theories indexed by integers 1 ≤ q ≤ N − 1. These structures provide a richer algebraic framework in which interactions between non-consecutive degrees become relevant.
```
  FIX: ```
Shortly thereafter, Spanier further developed Mayer’s theory and clarified its relationship with classical homology [16]. In particular, he showed that Mayer homology coincides with standard homology when the coefficient field has prime characteristic \( p \). Although Mayer’s original work remained relatively isolated for several decades, the underlying idea of \( N \)-complexes re-emerged in modern algebra. In particular, \( N \)-complexes have been systematically studied as natural generalizations of chain complexes, equipped with a differential satisfying \( d^N = 0 \), giving rise to a family of homology theories indexed by integers \( 1 \leq q \leq N - 1 \). These structures provide a richer algebraic framework in which interactions between non-consecutive degrees become relevant.
```
- RAW: ```
A major development in this direction is due to Kapranov [11], who introduced a q -analog of homological algebra in which the usual alternating signs are replaced by powers of a primitive N th root of unity. In this framework, one can define a Poincar´e polynomial at N th root of unity ξ
```
  FIX: ```
A major development in this direction is due to Kapranov [11], who introduced a \( q \)-analog of homological algebra in which the usual alternating signs are replaced by powers of a primitive \( N \)-th root of unity. In this framework, one can define a Poincaré polynomial at \( N \)-th root of unity \( \xi \)
```
- RAW: ```
for an N -complex, which vanishes for exact sequences. Moreover, when ξ = − 1, this polynomial recovers the Euler characteristic in the classical case N = 2. Later, Tikaradze [17] established a relation between the Poincar´e polynomial and Mayer homology groups, showing that for any 1 ≤ q ≤ N − 1 and p is the N th root of unity,
```
  FIX: ```
for an \( N \)-complex, which vanishes for exact sequences. Moreover, when \( \xi = -1 \), this polynomial recovers the Euler characteristic in the classical case \( N = 2 \). Later, Tikaradze [17] established a relation between the Poincaré polynomial and Mayer homology groups, showing that for any \( 1 \leq q \leq N - 1 \) and \( p \) is the \( N \)-th root of unity,
```
- RAW: ```
More recently, Mayer homology has found applications in topological data analysis and machine learning. In particular, persistent Mayer homology and the associated Mayer Laplacians have been introduced as extensions of persistent homology to N -complexes, providing refined topological and spectral invariants for complex data [15]. These constructions admit stability properties, such as Wasserstein stability of persistence diagrams, and have demonstrated effectiveness in capturing multi-scale features in large and heterogeneous datasets. Furthermore, persistent Mayer homology has been successfully applied in molecular data analysis, where it yields enriched topological descriptors for machine learning tasks. Notably, in the context of protein–ligand binding affinity prediction, Mayer-homology-based features have been shown to outperform classical approaches by encoding more detailed geometric and topological information across multiple scales [4]. This success motivates the in-depth study of Mayer homology.
```
  FIX: ```
More recently, Mayer homology has found applications in topological data analysis and machine learning. In particular, persistent Mayer homology and the associated Mayer Laplacians have been introduced as extensions of persistent homology to \( N \)-complexes, providing refined topological and spectral invariants for complex data [15]. These constructions admit stability properties, such as Wasserstein stability of persistence diagrams, and have demonstrated effectiveness in capturing multi-scale features in large and heterogeneous datasets. Furthermore, persistent Mayer homology has been successfully applied in molecular data analysis, where it yields enriched topological descriptors for machine learning tasks. Notably, in the context of protein–ligand binding affinity prediction, Mayer-homology-based features have been shown to outperform classical approaches by encoding more detailed geometric and topological information across multiple scales [4]. This success motivates the in-depth study of Mayer homology.
```
- RAW: ```
Path homology, also known as GLMY homology after Grigor'yan, Lin, Muranov, and Yau, was introduced in [8] as a homology theory for directed graphs that overcomes the limitations of classical simplicial and graph homology. In this framework, path complexes replace simplicial complexes, and chain groups are generated by directed paths, allowing the detection of nontrivial higher-dimensional structures in digraphs. The theory retains key features of classical homology, including chain complexes, homology groups, and functoriality, and was further developed in [9, 6, 7], where analogues of the Eilenberg-Steenrod axioms and additional structural properties were established. The applications of path homology span multiple fields, including molecular and materials science [1], network modeling [5, 20], and graph neural networks [18]. In the context of topological data analysis, persistent path homology [2] and persistent path Laplacian [19] have also been developed, providing refined multi-scale topological and spectral invariants. In addition, efficient computational methods have been proposed, including algorithms for computing 1-dimensional persistent path homology [3].
```
  FIX: ```
Path homology, also known as GLMY homology after Grigor'yan, Lin, Muranov, and Yau, was introduced in [8] as a homology theory for directed graphs that overcomes the limitations of classical simplicial and graph homology. In this framework, path complexes replace simplicial complexes, and chain groups are generated by directed paths, allowing the detection of nontrivial higher-dimensional structures in digraphs. The theory retains key features of classical homology, including chain complexes, homology groups, and functoriality, and was further developed in [9, 6, 7], where analogues of the Eilenberg-Steenrod axioms and additional structural properties were established. The applications of path homology span multiple fields, including molecular and materials science [1], network modeling [5, 20], and graph neural networks [18]. In the context of topological data analysis, persistent path homology [2] and persistent path Laplacian [19] have also been developed, providing refined multi-scale topological and spectral invariants. In addition, efficient computational methods have been proposed, including algorithms for computing \( 1 \)-dimensional persistent path homology [3].
```
