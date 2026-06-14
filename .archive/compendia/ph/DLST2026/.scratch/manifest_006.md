# Manifest: Page 006

## REPAIR_MATH
- RAW: ```
B ^ { - } \colon = \{ x \in B \, | \, \varphi \left ( [ 0 , T ) , x \right ) \not \subset B , \forall T > 0 \} \, ,
```
  FIX: ```
$$
B ^ { - } \colon = \{ x \in B \, | \, \varphi \left ( [ 0 , T ) , x \right ) \not \subset B , \forall T > 0 \} \, ,
$$
```
- RAW: ```
\text {Inv} _ { T } ( B , \varphi ) \subset \text {int} \, B ,
```
  FIX: ```
$$
\text {Inv} _ { T } ( B , \varphi ) \subset \text {int} \, B ,
$$
```
- RAW: ```
\text {Inv} _ { T } ( B ) \colon = \{ x \in B \, | \, \varphi ( [ - T , T ] , x ) \subset B \} .
```
  FIX: ```
$$
\text {Inv} _ { T } ( B ) \colon = \{ x \in B \, | \, \varphi ( [ - T , T ] , x ) \subset B \} .
$$
```

## REPAIR_PROSE
- RAW: ```
is closed and for all T > 0 we have
```
  FIX: ```
is closed and for all \( T > 0 \) we have
```
- RAW: ```
In particular, every isolated invariant set S admits an isolating block B such that Inv B = S . An example of an isolating block (the gray region) for a saddle point with the exit set marked in orange is depicted in Figure 3 . Using an isolating block, we can compute the homological Conley index, given by Con( S ) : = [ H 0 ( B,B − ), H 1 ( B,B − ), H 2 ( B,B − )], where H d ( B,B − ) represents the relative (singular) homology of degree d calculated over the field k = Z 2 . In particular, for attracting equilibria, A and E , repelling equilibria, R and T , saddle S and repelling periodic orbit O in the example, we have Con( A ) = Con( E ) = [ k, 0 , 0], Con( R ) = Con( T ) = [0 , 0 ,k ], Con( S ) = [0 ,k, 0], and Con( O ) = [0 ,k,k ]. Note that each type of an isolated invariant set in this example admits a different Conley index. We refer to [ 34 ] for a brief introduction to Conley index theory.
```
  FIX: ```
In particular, every isolated invariant set \( S \) admits an isolating block \( B \) such that \( \text{Inv} \, B = S \). An example of an isolating block (the gray region) for a saddle point with the exit set marked in orange is depicted in Figure 3. Using an isolating block, we can compute the homological Conley index, given by \( \text{Con}(S) := [H_0(B, B^-), H_1(B, B^-), H_2(B, B^-)] \), where \( H_d(B, B^-) \) represents the relative (singular) homology of degree \( d \) calculated over the field \( k = \mathbb{Z}_2 \). In particular, for attracting equilibria, \( A \) and \( E \), repelling equilibria, \( R \) and \( T \), saddle \( S \) and repelling periodic orbit \( O \) in the example, we have \( \text{Con}(A) = \text{Con}(E) = [k, 0, 0] \), \( \text{Con}(R) = \text{Con}(T) = [0, 0, k] \), \( \text{Con}(S) = [0, k, 0] \), and \( \text{Con}(O) = [0, k, k] \). Note that each type of an isolated invariant set in this example admits a different Conley index. We refer to [34] for a brief introduction to Conley index theory.
```
- RAW: ```
We say that an isolated invariant set S in φ λ continues to S ′ in φ λ ′ if there exists a set B , which is an isolating block in φ τ for all τ ∈ [ λ,λ ′ ], Inv φ λ B = S and Inv φ λ ′ B = S ′ . It follows that the Conley index is preserved through a continuation; however, the structure of the invariant set isolated by B may change significantly.
```
  FIX: ```
We say that an isolated invariant set \( S \) in \( \varphi_\lambda \) continues to \( S' \) in \( \varphi_{\lambda'} \) if there exists a set \( B \), which is an isolating block in \( \varphi_\tau \) for all \( \tau \in [\lambda, \lambda'] \), \( \text{Inv}_{\varphi_\lambda} B = S \) and \( \text{Inv}_{\varphi_{\lambda'}} B = S' \). It follows that the Conley index is preserved through a continuation; however, the structure of the invariant set isolated by \( B \) may change significantly.
```
- RAW: ```
Consider again the first step in our example. The Hopf bifurcation at the north pole turns the repelling equilibrium R into attracting equilibrium E and periodic orbit O . With a proper isolating block around the north pole one can show that R continues into the union of E , O , and the trajectories connecting them, which together form an isolated invariant disc, which we denote by D (compare the invariant part of the set N 2 for λ = 0 and λ = 1 in Figure 5). Note that such a disc behaves globally as a repeller; in particular, its Conley index is the same as that of R , that is [0 , 0 , k ]. However, D can be decomposed into E and O . As a result of this split the total rank of the Conley indices increases by two. In particular, we argue, that the degree 2 generator of D , which continues from R , has been passed to O through the bifurcation. Moreover, the split of D into two subcomponents created a new pair of coupled generators, in this case of degree 0 and 1. We record these events in the Conley-Morse persistence barcode shown in Figure 2. In particular, the degree 2 generator of R at λ = 0 is represented by the orange bar that continues to λ = 1 (and further). For a λ ∈ (0 , 1), two new bars are born representing the emergence of generators through the described split; the dashed line indicates that they are coupled (in the sense captured by Theorem 5.12). From the remaining part of the diagram we can read off further qualitative changes in the dynamics, for instance, we can see that for certain λ ∈ (2 , 3), the periodic orbit breaks creating two equilibria. The diagram tells that their Conley indices inherit generators from the orbit. Finally, for λ ∈ (3 , 4), two equilibria and their Conley indices annihilate each other, which is reflected by the ending of the corresponding bars.
```
  FIX: ```
Consider again the first step in our example. The Hopf bifurcation at the north pole turns the repelling equilibrium \( R \) into attracting equilibrium \( E \) and periodic orbit \( O \). With a proper isolating block around the north pole one can show that \( R \) continues into the union of \( E \), \( O \), and the trajectories connecting them, which together form an isolated invariant disc, which we denote by \( D \) (compare the invariant part of the set \( N_2 \) for \( \lambda = 0 \) and \( \lambda = 1 \) in Figure 5). Note that such a disc behaves globally as a repeller; in particular, its Conley index is the same as that of \( R \), that is \( [0, 0, k] \). However, \( D \) can be decomposed into \( E \) and \( O \). As a result of this split the total rank of the Conley indices increases by two. In particular, we argue, that the degree 2 generator of \( D \), which continues from \( R \), has been passed to \( O \) through the bifurcation. Moreover, the split of \( D \) into two subcomponents created a new pair of coupled generators, in this case of degree 0 and 1. We record these events in the Conley-Morse persistence barcode shown in Figure 2. In particular, the degree 2 generator of \( R \) at \( \lambda = 0 \) is represented by the orange bar that continues to \( \lambda = 1 \) (and further). For a \( \lambda \in (0, 1) \), two new bars are born representing the emergence of generators through the described split; the dashed line indicates that they are coupled (in the sense captured by Theorem 5.12). From the remaining part of the diagram we can read off further qualitative changes in the dynamics, for instance, we can see that for certain \( \lambda \in (2, 3) \), the periodic orbit breaks creating two equilibria. The diagram tells that their Conley indices inherit generators from the orbit. Finally, for \( \lambda \in (3, 4) \), two equilibria and their Conley indices annihilate each other, which is reflected by the ending of the corresponding bars.
```
