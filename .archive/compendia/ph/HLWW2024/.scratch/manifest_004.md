# Manifest: Page 004

## REPLACE_TABLES
*(No tables found on this page)*

## REPAIR_MATH
- RAW: ```
\pi _ { d } ( X \otimes L ^ { q } ( \mathbb { Z } ) ) \stackrel { ( * ) } { \longrightarrow } \pi _ { d } ( X \otimes \tau _ { \leq 0 } L ^ { q } ( \mathbb { Z } ) ) \to \pi _ { d - 1 } ( X \otimes \tau _ { \geq 1 } L ^ { q } ( \mathbb { Z } ) ) \to \pi _ { d - 1 } ( X \otimes L ^ { q } ( \mathbb { Z } ) )
```
  FIX: ```
\[
\pi _ { d } ( X \otimes L ^ { q } ( \mathbb { Z } ) ) \stackrel { ( * ) } { \longrightarrow } \pi _ { d } ( X \otimes \tau _ { \leq 0 } L ^ { q } ( \mathbb { Z } ) ) \to \pi _ { d - 1 } ( X \otimes \tau _ { \geq 1 } L ^ { q } ( \mathbb { Z } ) ) \to \pi _ { d - 1 } ( X \otimes L ^ { q } ( \mathbb { Z } ) )
\]
```

## REPAIR_PROSE
- RAW: ```
(xi) Using the above, Ranicki [Ran79] shows that the space of paths from tso( P ) to 0 inside Ω ∞ + d S alg ( P ) is canonically equivalent to the topological manifold block structure space S ( P ). In particular, the topological block structure space S ( M ) of a topological manifold M identiﬁes canonically with Ω ∞ + d +1 S alg ( M ). Likewise, [BFMW96] ought to give an identiﬁcation of the homology manifold block structure space S H ( P ) with the space of paths from tso( P ) to 0 inside Ω ∞ + d S alg ( P ).

space ( P ) with the space of paths from tso( P ) to 0 inside Ω ( P ).
```
  FIX: ```
(xi) Using the above, Ranicki [Ran79] shows that the space of paths from \( \operatorname{tso}(P) \) to \( 0 \) inside \( \Omega^{\infty+d} \mathbb{S}^{\text{alg}}(P) \) is canonically equivalent to the topological manifold block structure space \( \mathcal{S}(P) \). In particular, the topological block structure space \( \mathcal{S}(M) \) of a topological manifold \( M \) identifies canonically with \( \Omega^{\infty+d+1} \mathbb{S}^{\text{alg}}(M) \). Likewise, [BFMW96] ought to give an identification of the homology manifold block structure space \( \mathcal{S}^H(P) \) with the space of paths from \( \operatorname{tso}(P) \) to \( 0 \) inside \( \Omega^{\infty+d} \mathbb{S}^{\text{alg}}(P) \).
```

- RAW: ```
Again, our results below imply that this last claim suﬀers from the defect indicated in point (viii): Even its consequence on π 0 currently relies on the existence of euclidean normal bundles for homology manifolds, see [BFMW24].
```
  FIX: ```
Again, our results below imply that this last claim suffers from the defect indicated in point (viii): Even its consequence on \( \pi_0 \) currently relies on the existence of euclidean normal bundles for homology manifolds, see [BFMW24].
```

- RAW: ```
Before coming to our main results, the construction of certain Poincare´ complexes, we prove the following positive result about the existence of euclidean reductions of Spivak normal ﬁbrations of oriented Poincare´ complexes.
```
  FIX: ```
Before coming to our main results, the construction of certain Poincaré complexes, we prove the following positive result about the existence of euclidean reductions of Spivak normal fibrations of oriented Poincaré complexes.
```

- RAW: ```
1. Proposition. Let X be an oriented d -dimensional Poincare´ complex such that ro( X ) = 0 . Then the following statements are equivalent:

- (i) The Spivak normal ﬁbration of X admits a reduction to a stable euclidean bundle,
- (ii) there exists a degree one map M → X where M is an oriented closed topological manifold, and 1 1
- (iii) the fundamental class [ X ] ∈ H d ( X ; Z [ 2 ]) lifts to a fundamental class in ko d ( X )[ 2 ] .
```
  FIX: ```
1. Proposition. Let \( X \) be an oriented \( d \)-dimensional Poincaré complex such that \( \operatorname{ro}(X) = 0 \). Then the following statements are equivalent:

- (i) The Spivak normal fibration of \( X \) admits a reduction to a stable euclidean bundle,
- (ii) there exists a degree one map \( M \to X \) where \( M \) is an oriented closed topological manifold, and
- (iii) the fundamental class \( [X] \in H_d(X; \mathbb{Z}[1/2]) \) lifts to a fundamental class in \( \operatorname{ko}_d(X)[1/2] \).
```

- RAW: ```
Proof. An argument of Sullivan’s shows that (i) implies that there exists a degree one normal map M → X for some closed topological manifold M , see [Wal99, Prop. 10.2] or [LM24, Theorem 7.19] for the smooth case. Using topological transversality [KS77] the same argument applies to the topological case. In particular, (i) implies (ii). Given (ii), we ﬁnd that [ M → X ] determines an element of MSTop d ( X ) which lifts the fundamental class [ X ] ∈ H d ( X ; Z ). In particular, after inverting 2, one may use the Sullivan–Ranicki orientation MSTop[ 1 2 ] → τ ≥ 0 L s ( Z )[ 1 2 ] ≃ ko[ 1 2 ] to lift the fundamental class in H d ( X ; Z [ 1 2 ]) to ko d ( X )[ 1 2 ]. See [LN18, Corollary 5.4 & following Remark] for an equivalence L s ( Z )[ 1 2 ] ≃ KO[ 1 2 ] of E ∞ ring spectra and [LNS23, Section 8] for perspectives on the Sullivan–Ranicki orientation and general information about π 0 Map E ∞ (MSTop[ 1 2 ] , ko[ 1 2 ]). 1 Finally, consider the exact sequence
```
  FIX: ```
Proof. An argument of Sullivan’s shows that (i) implies that there exists a degree one normal map \( M \to X \) for some closed topological manifold \( M \), see [Wal99, Prop. 10.2] or [LM24, Theorem 7.19] for the smooth case. Using topological transversality [KS77] the same argument applies to the topological case. In particular, (i) implies (ii). Given (ii), we find that \( [M \to X] \) determines an element of \( \operatorname{MSTop}_d(X) \) which lifts the fundamental class \( [X] \in H_d(X; \mathbb{Z}) \). In particular, after inverting 2, one may use the Sullivan–Ranicki orientation \( \operatorname{MSTop}[1/2] \to \tau_{\geq 0} \mathbb{L}^s(\mathbb{Z})[1/2] \simeq \operatorname{ko}[1/2] \) to lift the fundamental class in \( H_d(X; \mathbb{Z}[1/2]) \) to \( \operatorname{ko}_d(X)[1/2] \). See [LN18, Corollary 5.4 & following Remark] for an equivalence \( \mathbb{L}^s(\mathbb{Z})[1/2] \simeq \operatorname{KO}[1/2] \) of \( E_\infty \) ring spectra and [LNS23, Section 8] for perspectives on the Sullivan–Ranicki orientation and general information about \( \pi_0 \operatorname{Map}_{E_\infty}(\operatorname{MSTop}[1/2], \operatorname{ko}[1/2]) \). 1 Finally, consider the exact sequence
```

- RAW: ```
and recall that the second to last group contains the element ro( X ) which is sent to ro( X ) = 0 in the ﬁnal group above. Note that the map labelled ( ∗ ) is 2-locally surjective, as follows from the 2-local splitting of L q ( Z ) into Eilenberg-Mac Lane spectra. Away from 2, we may use the equivalence L q ( Z )[ 1 2 ] ≃ KO[ 1 2 ] so that under assumption (iii) 2 the map ( ∗ )[ 1 2 ] is also surjective, showing that ro( X ) = 0 and hence (i).
```
  FIX: ```
and recall that the second to last group contains the element \( \operatorname{ro}(X) \) which is sent to \( \operatorname{ro}(X) = 0 \) in the final group above. Note that the map labelled \( (*) \) is 2-locally surjective, as follows from the 2-local splitting of \( \mathbb{L}^q(\mathbb{Z}) \) into Eilenberg-Mac Lane spectra. Away from 2, we may use the equivalence \( \mathbb{L}^q(\mathbb{Z})[1/2] \simeq \operatorname{KO}[1/2] \) so that under assumption (iii) 2 the map \( (*)[1/2] \) is also surjective, showing that \( \operatorname{ro}(X) = 0 \) and hence (i).
```

- RAW: ```
/square

We note that ro( X ) = 0 is implied by tso( X ) = 0, in which case the following also appears in [BFMW24].
```
  FIX: ```
\( \square \)

We note that \( \operatorname{ro}(X) = 0 \) is implied by \( \operatorname{tso}(X) = 0 \), in which case the following also appears in [BFMW24].
```

- RAW: ```
2. Corollary. Let X be an oriented Poincare´ complex with ro( X ) = 0 . If dim( X ) ≤ 6 , then the Spivak normal ﬁbration admits a reduction to a stable euclidean bundle.
```
  FIX: ```
2. Corollary. Let \( X \) be an oriented Poincaré complex with \( \operatorname{ro}(X) = 0 \). If \( \dim(X) \leq 6 \), then the Spivak normal fibration admits a reduction to a stable euclidean bundle.
```

- RAW: ```
1 By a result of Sullivan’s [MM79, 5.12 & 5.24], one has Map E ∞ (MSTop[ 1 2 ] , ko[ 1 2 ]) ≃ Map E ∞ (MSO[ 1 2 ] , ko[ 1 2 ]). 2

Note that for E any spectrum, the canonical map π d ( X ⊗ τ ≥ 0 E ) → π d ( X ⊗ E ) is an isomorphism.
```
  FIX: ```
1 By a result of Sullivan’s [MM79, 5.12 & 5.24], one has \( \operatorname{Map}_{E_\infty}(\operatorname{MSTop}[1/2], \operatorname{ko}[1/2]) \simeq \operatorname{Map}_{E_\infty}(\operatorname{MSO}[1/2], \operatorname{ko}[1/2]) \). 2

Note that for \( E \) any spectrum, the canonical map \( \pi_d(X \otimes \tau_{\geq 0} E) \to \pi_d(X \otimes E) \) is an isomorphism.
```
