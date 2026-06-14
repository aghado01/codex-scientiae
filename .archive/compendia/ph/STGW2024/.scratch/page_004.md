[Page 4]

The rest of this paper is organized as follows: Section 2 o ff ers a primer on the de Rham-Hodge theory on manifolds with boundaries; Section 3 presents our discretization for evolutionary de RhamHodge theory based on spectrum calculation of Laplacians associated with sublevel sets on Cartesian grids; Section 4 presents our construction for persistent de Rham-Hodge Laplacians both in the continuous setting and for given level set functions on Cartesian grids; Section 5 showcases preliminary studies on the applications of MTL; and Section 6 concludes the paper.

## 2. De Rham-Hodge theory

The de Rham-Hodge theory is an advanced mathematical framework that merges ideas from di ff erential geometry, algebraic topology, analysis, and partial di ff erential equations to study the properties of di ff erential forms on smooth manifolds. It plays a crucial role in understanding the topology and geometry of manifolds through di ff erential forms. The de Rham-Hodge theory consists of de Rham cohomology and Hodge theory. The former concerns di ff erential forms, exterior derivative, and cohomology groups, while the latter deals with Riemannian manifolds, Hodge star operator, Hodge Laplacian, and Hodge decomposition.

Let M be an m -dimensional smooth, orientable, compact Riemannian manifold with boundary. Denote by Ω k ( M ) the space of all di ff erential k -forms on M , i.e., the space of all smooth antisymmetric covariant tensor fields on M of degree k . The di ff erential d , also called exterior derivative, is the unique R -linear mapping from the space of k -forms Ω k ( M ) to the space of ( k + 1)-forms Ω k + 1 ( M ) satisfying the Leibniz rule with respect to the wedge product ∧ and the nilpotent property dd = 0. A key property of di ff erential forms is that they can be integrated over any orientable k -submanifolds of M . For any oriented ( k + 1)-submanifold S ⊂ M with boundary ∂ S , Stokes’ theorem, as a generalization of the Newton-Leibniz rule, states that the integral of a di ff erential k -form ω over ∂ S is equal to the integral of its di ff erential over S , i.e.,

$$
\int _ { S } d \omega = \int _ { \partial S } \omega .
$$

The di ff erential d generalizes and unifies the classical operators in vector calculus, such as gradient ∇ , curl ∇× , and divergence ∇· in R 2 and R 3 . For instance, in R 3 , 0-forms and 3-forms can be identified with scalar fields, while 1-forms and 2-forms can be identified with vector fields. In this case, the di ff erential d corresponds to the gradient operator ∇ when applied to 0-forms, the curl operator ∇× when applied to 1-forms, or the divergence operator ∇· when applied 2-forms. The nilpotent property dd = 0 directly leads to the vector field analysis identities ∇ × ∇ = 0 and ∇ · ∇× = 0.

A di ff erential form ω ∈ Ω k ( M ) is called closed if d ω = 0, or exact if there is a ( k − 1)-form ζ ∈ Ω k − 1 ( M ) such that ω = d ζ . Due to the property dd = 0, every exact form is closed. Thus, the
