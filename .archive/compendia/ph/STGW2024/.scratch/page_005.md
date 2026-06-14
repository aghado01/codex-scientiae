[Page 5]

$$
0 \longrightarrow \Omega ^ { 0 } ( M ) \stackrel { d } { \longrightarrow } \Omega ^ { 1 } ( M ) \stackrel { d } { \longrightarrow } \dots \stackrel { d } { \longrightarrow } \Omega ^ { m - 1 } ( M ) \stackrel { d } { \longrightarrow } \Omega ^ { m } ( M ) \to 0 .
$$

The k -th de Rham cohomology group, denoted by H k dR ( M ), is then defined to be the k -th homology of this chain complex, i.e., the quotient space of closed k -forms modulo the space of exact k -forms, i.e.,

$$
H _ { d R } ^ { k } ( M ) = \frac { \ker ( d \colon \Omega ^ { k } ( M ) \to \Omega ^ { k + 1 } ( M ) ) } { \dim ( d \colon \Omega ^ { k - 1 } ( M ) \to \Omega ^ { k } ( M ) ) } .
$$

The de Rham cohomology, by the de Rham theorem, is naturally isomorphic to the singular cohomology, and thus depends only on the manifold topology.

Let g be a Riemannian metric on M and ⟨· , ·⟩ g be the point-wise inner product induced by g on Ω k ( M ). The Hodge star operator ⋆ provides an isomorphism from the space of di ff erential k -forms Ω k ( M ) to the space of ( m − k )-forms Ω m − k ( M ), defined by the following formula:

$$
\omega \wedge * \eta = \langle \omega , \eta \rangle _ { g } \, \mu _ { g } ,
$$

where µ g is the volume form on M induced by g . The Hodge L 2 -inner product on the space of k -forms Ω k ( M ) can then be obtained by taking the integral of the formula (2.4)

$$
( \omega , \eta ) = \int _ { M } \omega \wedge * \eta .
$$

The codi ff erential δ : Ω k ( M ) → Ω k − 1 ( M ) is defined by

$$
\delta = ( - 1 ) ^ { m ( k - 1 ) + 1 } * d ^ { * } ,
$$

which also has the nilpotent property δδ = 0. We call a di ff erential form ω ∈ Ω k ( M ) co-closed if δω = 0, or co-exact if there is a ( k + 1)-form η ∈ Ω k + 1 ( M ) such that ω = δη . The codi ff erential δ , as the di ff erential d , also extends the classical gradient, curl, and divergence in vector calculus. In R 3 , it corresponds to −∇· , ∇× , and −∇ when applied to 1-forms, 2-forms, and 3-forms, respectively.

The Hodge Laplacian for di ff erential forms is defined as ∆ = d δ + δ d : Ω k ( M ) → Ω k ( M ). Its kernel, consisting of all di ff erential k -forms ω on M with ∆ ω = 0, is called the space of harmonic k -forms. We denote by H k ∆ ( M ) the space of harmonic k -forms and by H k ( M ) the space of k -forms that are both closed and co-closed, i.e., H k ( M ) = ker d ∩ ker δ . The latter space H k ( M ), known as the space of harmonic k -fields, is in general only a subset of the space of harmonic forms H k ( M ) ⊂ H k ∆ ( M ), and is infinite-dimensional [53]. However, in the case of closed manifolds where ∂ M = ∅ , the space of harmonic forms H k ∆ ( M ) reduces to the space H k ( M ) , as any harmonic form is both closed and co-closed. The result follows directly from the following formula:

$$
0 = ( \Delta \omega , \omega ) = ( ( d \delta + \delta d ) \omega , \omega ) = ( d \omega , d \omega ) + ( \delta \omega , \delta \omega ) ,
$$

due to the L 2 -adjointness of the codi ff erential δ and the di ff erential d on closed manifolds, i.e., ( d ω,η ) = ( ω,δη ).

The classical Hodge decomposition theorem for closed manifolds states that the space of di ff erential k -forms Ω k ( M ) can be decomposed as

$$
\Omega ^ { k } ( M ) = d \Omega ^ { k - 1 } ( M ) \oplus \delta \Omega ^ { k + 1 } ( M ) \oplus \mathcal { H } _ { \Delta } ^ { k } ( M ) .
$$
