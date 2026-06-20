[Page 1]

# PERSISTENT NERVES REVISITED

NICHOLAS J. CAVANNA AND DONALD R. SHEEHY

Introduction. The nerve of a cover is a simplicial complex corresponding to the collection of intersections of a cover of a nice topological space. Nerves show up all over computational geometry and topology as they provide a discrete representation of a continuous space. In fact if one has a good cover of a space, then the nerve has the same homotopy type, and thus homology, as the space. Nerves are used in surface reconstruction, homology inference, and homological sensor networks.

The Persistent Nerve Lemma, introduced by Chazal and Oudut [2], implies that given a growing collection of covers, e.g. convex sets, of suﬃciently nice growing topological spaces, the persistent homology of the spaces they cover is the same as that of the nerve of the covers, and furthermore, the maps between the spaces commute. This result has played a big part in the results on persistent homology and topological data analysis. The hypothesis of the lemma is the covers have contractible intersections.

Other researchers have worked within this setting altering the original assumption of good covers. Botnan and Spreemann [1] assumed knowledge of the interleaving between two cover ﬁltrations to bound the bottleneck distance between the persistence diagrams of the ﬁltrations of the nerves and the spaces. Govc and Skraba [3] bounded the bottleneck distance between the nerve and space persistence diagrams for simplicial complexes, given that the homology of the k -intersections of the ﬁltrations cover elements are ε -interleaved with 0, where the cover ﬁltration is deﬁned by the cover’s intersection with each step in the ﬁltered simplicial complex.

We consider a more general cover assumptionthat we have an arbitrary cover ﬁltration of a simplicial ﬁltration where the inclusion of any intersection of covers included into the next has the homology of a point. Our main result is that

Background. Let U = { U 1 ,...,U n } be a set of ﬁltrations, where U i = ( U α i ) α ≥ 0 . For each α ≥ 0, we denote U α = { U α 1 ,...,U α n } , and we note this is a cover of the space W α =   i ∈ [ n ] U α i , a simplicial complex. For v ⊆ [ n ], let U α v =   i ∈ v U α i . So U v = ( U α v ) α ≥ 0 is also a ﬁltration. α

The nerve of a collection of sets U is deﬁned as Nerve U α := { v ⊆ [ n ] | U α v   = ∅} and is a simplicial complex. The nerve ﬁltration is deﬁned as Nerve U := (Nerve U α ) α ≥ 0 When we consider the collection of spaces that each U α covers, we get the union ﬁltration , W := ( W α ) α ≥ 0 . The sets of U α form a good cover of W α if for all subsets v ⊆ [ n ], we have U α v is empty or contractible. For ﬁltrations, we say U is good cover of W if U α is a good cover of W α for all α ≥ 0. The Persistent Nerve Lemma implies that if U is a good cover of W , then Pers(Nerve U ) = Pers( W ).

glyph[negationslash]

We now will deﬁne the structure that will provide the link between the nerve ﬁltration and the union ﬁltration. From U α , there is a corresponding commutative diagram D U α , where the spaces are the nonempty sets U α v for v ⊆ [ n ] and there is an inclusion map U α v 0   → U α v 1 whenever v 1 ⊂ v 0 . Let Flag( n ) α be the set of ordered sequences of the form σ = ( v 0 ,...,v k ), k ≤ n , where v i ⊆ [ n ]. This can be interpreted as an ordering on the barycentric decomposition of Nerve U α . This is an abstract simplicial complex. We deﬁne the homotopy colimit of D U α as

$$
\hbar { o } c o l i m \ D \mathcal { U } ^ { \alpha } \colon = \bigcup _ { \sigma \in \text {Flag} ( n ) ^ { \alpha } } U _ { v _ { 0 } } ^ { \alpha } \times \sigma .
$$

The homotopy colimit yields another ﬁltration, B = ( B α ) α ≥ 0 , where B α = hocolim D U α . Note that hocolim D U α ⊆ W α × Flag( n ) α , and thus there are natural projections into W α and Nerve U α from B α for each α . The projection map b α : B α → W α is a homotopy equivalence for any cover of a paracompact space e.g. simplicial complexes, and by its naturality, we have Pers( B ) =

[Page 2]

![image 1](<PNV20XX/imageFile1.png>)

We use the following notation, in relation to σ = ( v 0 ,...,v k ), a k -simplex of N α . Let σ i = ( v 0 ,...,v i ) and ¯ σ i = ( v i ,...,v k ).

By our ε -goodness assumption we have maps on the chains c v : C ∗ ( U α v ) → C ∗ +1 ( U α + ε v ) that are chain homotopies between the identity map and the map to a ﬁxed point x v . By composition, we obtain a map for all k ≥ 0, c α : C k : ( B α ) → C k +1 ( W α + t ), where t = ( k +1) ε . This maps acts on τ × σ ∈ C ∗ ( B α ), as follows.

Uœ+1

U8i,2}

{1,2}

{1,2}

Figure 1. A cover ﬁltration that is not good, but is 2-good.

$$
c ^ { \alpha } ( \tau \times \sigma ) \colon = ( c _ { v _ { k } } \circ \dots \circ c _ { v _ { 0 } } ) ( \tau ) .
$$

We now deﬁne the map q α ( σ ) := c α ( x v 0 × ¯ σ 1 ) .

Pers( W ). hocolim D U α is also know as the MayerVietoris blowup complex.

Composing the aforementioned we get a map a α = q α ◦ p α : C ∗ ( B α ) → C ∗ ( W α + t ), and we have that c α is a chain homotopy between a α and b α . The key ingredient to this instruction is that given a chain map f : C ∗ ( B α ) → C ∗ ( W α + t ), we can ”lift” this to a chain map ¯ f : C ∗ ( B α ) → C ∗ ( B α + t ) as follows.

Results. We do not assume that the cover is good. Rather, given a cover U , we say it is ε good if for all v ⊆ [ n ], and for all α ≥ 0, the inclusions U α v   → U α + ε v have the homology of a point, so any nontrivial topology of U α v dies at U α + ε v . Note that when ε = 0, we have the exact hypothesis of the Persistent Nerve Lemma. Our main result is the following.

$$
\bar { f } ( \tau \times \sigma ) \colon = \sum _ { i = 0 } ^ { k } f ( \tau \times \sigma _ { i } ) \times \bar { \sigma } _ { i } . \\
$$

This lifting operation also preserves chain homotopies on the new spaces. Thus we have a chain homotopy ¯ c α between ¯ a α and ¯ b α . By deﬁning a lift of q α as ¯ q α ( σ ) :=   k i =0 q α ( σ i ) × ¯ σ i , we get our desired maps. Note that in the construction, t = ( k + 1) ε , leading to the bound in the main theorem. α α α

Theorem 1. If U = { U 1 ,...,U n } is a set of ﬁltrations that is an ε -good cover of the simplicial ﬁltration W =   n i =1 U i , then

$$
d _ { B } ( P e r s _ { r } ( \mathcal { W } ) , P e r s _ { r } ( N e r v e \, \mathcal { U } ) ) \leq ( r + 1 ) \varepsilon . \quad _ { t = 1 } ^ { 0 }
$$

Thus the bottleneck distance of the persistence diagrams for the r -th persistent homology of the simplicial ﬁltration and the nerve ﬁltration is bounded above ( r +1) ε . Furthermore, the bottleneck distance is upper-bounded by ( D + 1) ε , where D is the maximal dimension of the nerve.

Since the maps ¯ a and p ◦ ¯ q are natural by construction, they commute with the shift homomorphisms at the homology level, and thus induce the interleaving homomorphisms between N and B , implying our result.

An overview of the proof is as follows. One has the equality Pers( W ) = Pers( B ), and thus one must ﬁnd an interleaving between the chains of N α and B α to prove the theorem, where N α is the barycentric subdivision of Nerve U α . Deﬁne N = ( N α ) α ≥ 0 . Since N α is homeomorphic to Nerve U α , for all α , it follows that Pers( N ) = Pers(Nerve U ). For each vertex v of N α , there is a corresponding nonempty set U α v . There exists a projection p α : B α → N α , which we use to deﬁne a map ¯ q α from N α to B α + t , where t is a function of ε , such that p α + t ◦ ¯ q α commutes with N α   → N α + t and ¯ q α ◦ p α is chain homotopic to the inclusion b α : B α   → B α + t .

# References

- [1] Magnus Bakke Botnan and Gard Spreemann. Approximating persistent homology in Euclidean space through collapses. Applicable Algebra in Engineering, Communication and Computing , pages 1–29, 2015.
- [2] Fre´de´ric Chazal and Steve Yann Oudot. Towards persistence-based reconstruction in euclidean spaces. In Proceedings of the Twenty-fourth Annual Symposium on Computational Geometry , SCG ’08, pages 232–241, New York, NY, USA, 2008. ACM.
- [3] Dejan Govc and Primoz Skraba. An approximate nerve theorem. arXiv , https://arxiv.org/pdf/1608.06956v2.pdf, 2016.


