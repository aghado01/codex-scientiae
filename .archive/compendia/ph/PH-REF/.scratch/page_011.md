[Page 11]

and hence the factorization

$$
H ( M _ { b } ) \rightarrow H ( \mathcal { K } ) \rightarrow H ( M _ { c } ) .
$$

Since K is (a geometric realization of) a ﬁnite simplicial complex, H ( K ) is ﬁnite dimensional and so H ( M b ) → H ( M c ) has ﬁnite rank.  

Theorem 5.7 . Let f,g : M → R be q-tame. Then for any integer k ,

$$
d _ { b } ( d g m _ { k } ( f ) , d g m _ { k } ( g ) ) \leqslant \| f - g \| _ { \infty } = \sup _ { x \in M } | f ( x ) - g ( x ) |
$$

where dgm k ( f ) (resp. dgm k ( g ) ) is the persistence diagram of the persistence module ( H k ( f − 1 ( −∞ ,r ])) | r ∈ R ) (resp. ( H k ( g − 1 ( −∞ ,r ])) | r ∈ R ) ) where the linear maps are the one induced by the canonical inclusion maps between sublevel sets.

Proof. Denoting δ = f − g ∞ we have that for any r ∈ R , f − 1 ( −∞ ,r ]) ⊂ g − 1 ( −∞ ,r + δ ]) and g − 1 ( −∞ ,r ]) ⊂ f − 1 ( −∞ ,r + δ ]). This interleaving between the sublevel sets of f induces a δ -interleaving between the persistence modules at the homology level and the result follows from the direct application of Theorem 5.3.  

5.3. Stability for Spaces. It sometimes occurs in that one has to compare data sets that are not sampled from the same ambient space. Fortunately, the notion of Hausdorﬀ distance can be generalized to the comparison of any pair of compact metric spaces, giving rise to the notion of Gromov-Hausdorﬀ distance .

Two compact metric spaces ( M 1 ,ρ 1 ) and ( M 2 ,ρ 2 ) are isometric if there exists a bijection φ : M 1 → M 2 that preserves distances, i.e. ρ 2 ( φ ( x ) ,φ ( y )) = ρ 1 ( x,y ) for any x,y ∈ M 1 . The Gromov-Hausdorﬀ distance measures how far two metric space are from being isometric.

Deﬁnition 5.8. The Gromov-Haudorﬀ distance d GH ( M 1 ,M 2 ) between two compact metric spaces is the inﬁmum of the real numbers r 0 such that there exists a metric space ( M,ρ ) and two compact subspaces C 1 ,C 2 ⊂ M that are isometric to M 1 and M 2 and such that d H ( C 1 ,C 2 ) r .

Theorem 5.3 also implies a stability result for the persistence diagrams of ﬁltrations built on top of data.

Theorem 5.9 . Let X and Y be two compact metric spaces and let Filt( X ) and Filt( Y ) be the Vietoris-Rips of ˇ Cech ﬁltrations built on top X and Y . Then

$$
d _ { b } \left ( d g m ( F i l t ( \mathbb { X } ) ) , d g m ( F i l t ( \mathbb { Y } ) ) \right ) \leqslant 2 \, d _ { G H } ( \mathbb { X } , \mathbb { Y } ) ,
$$

where dgm(Filt( X )) and dgm(Filt( Y )) denote the persistence diagram of the ﬁltrations Filt( X ) and Filt( X ) .

Proof. See [CdSO14, Theorem 5.2].

glyph[square]

Remark 5.10. (i) This bound is worst-case tight. Indeed, take X = { 0 , 1 } ⊂ R and Y = { 0 , 1 + 2 ε } , for ε > 0 (see Figure 6a). Then d GH ( X , Y ) = ε , dgm 0 (Filt( X )) = { (0 , ∞ ) , (0 , 1) } and dgm 0 (Filt( Y )) = { (0 , ∞ ) , (0 , 1 + 2 ε ) } , so that

d b (dgm 0 (Filt( X )) , dgm 0 (Filt( Y ))) = ε = 2d GH ( X , Y ) .
