[Page 6]

These three subspaces are mutually orthogonal with respect to the inner product (2.5). Moreover, Hodge theorem identifies the harmonic space H k ∆ ( M ) with the k -th de Rham cohomology group H k dR ( M ), which states that each harmonic form corresponds to exactly one equivalence class in H k dR ( M ). Therefore, the harmonic space H k ∆ ( M ) is fully determined by the manifold topology, and is finitedimensional with its dimension given by the Betti number dim H k ∆ ( M ) = β k .

## 2.1. Hodge decomposition for manifolds with boundary

In the presence of a nonempty boundary ∂ M , the two operators d and δ are not L 2 -adjoint, as integration by parts leads to [69]

$$
( d \omega , \eta ) = ( \omega , \delta \eta ) + \int _ { \partial M } \omega \wedge * \eta ,
$$

which contains a boundary term that may not vanish, and thus the decomposed subspaces in (2.8) are not orthogonal. However, certain boundary conditions can be enforced, ensuring the adjointness of the di ff erential d and the codi ff erential δ , thereby inducing an orthogonal decomposition of the space of di ff erential forms.

The most common choices of boundary conditions ensuring the adjointness of d and δ are the normal (Dirichlet) and tangential (Neumann) boundary conditions. A di ff erential form ω ∈ Ω k ( M ) is called normal (Dirichlet) if it gives zero when applied to tangent vectors of the boundary, or tangential (Neumann) if the same holds for its dual ⋆ω instead. Denote by Ω k n ( M ) the set of normal di ff erential k -forms and by Ω k t ( M ) the set of tangential di ff erential forms, i.e.,

$$
\Omega _ { n } ^ { k } ( M ) = \{ \omega \in \Omega ^ { k } ( M ) \, | \quad \omega | _ { \partial M } = 0 \} ;
$$

$$
\Omega _ { t } ^ { k } ( M ) = \{ \omega \in \Omega ^ { k } ( M ) | \quad ^ { * } \omega | _ { \partial M } = 0 \} .
$$

Following their definitions, the spaces Ω k n ( M ) and Ω m − k t ( M ) are isomorphic under the Hodge star operator ⋆ , also known as the Hodge duality. Moreover, the di ff erential d preserves the normal boundary conditions, while the codi ff erential δ preserves the tangential boundary conditions.

The Hodge-Morrey decomposition [43] states that there is a 3-component L 2 -orthogonal decomposition

$$
\Omega ^ { k } ( M ) = d \Omega _ { n } ^ { k - 1 } ( M ) \oplus \delta \Omega _ { t } ^ { k + 1 } ( M ) \oplus \mathcal { H } ^ { k } ( M ) ,
$$

The orthogonality of the decomposition directly comes from the adjointness of δ and d when enforcing the normal or tangential boundary conditions. For ω ∈ Ω k ( M ) , there is a unique decomposition of ω given as follows:

$$
\omega = d \alpha _ { n } + \delta \beta _ { t } + \eta ,
$$

where α n ∈ Ω k + 1 n ( M ), β t ∈ Ω k + 1 t ( M ), and η ∈ H k ( M ). Note that the potentials α n and β t are not uniquely determined as all α n + d η and β t + δγ with any η ∈ Ω k − 2 n ( M ) and γ ∈ Ω k + 2 t ( M ) serve as potentials for the same components. However, the issue can be addressed by enforcing gauge conditions, such as

$$
\delta \alpha _ { n } = 0 ,
$$
