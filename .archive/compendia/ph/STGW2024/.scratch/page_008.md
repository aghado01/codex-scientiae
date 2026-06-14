[Page 8]

Remark 3. In fact, let H k co = H k ( M ) ∩ δ Ω k + 1 ( M ) and H k ex = H k ( M ) ∩ d Ω k − 1 ( M ) . The space of harmonic fields H k ( M ) can be further orthogonally decomposed for smooth manifolds

$$
\mathcal { H } ^ { k } ( M ) = & \mathcal { H } _ { c o } ^ { k } ( M ) \oplus \mathcal { H } _ { n } ^ { k } ( M )
$$

$$
= & \mathcal { H } _ { e x } ^ { k } ( M ) \oplus \mathcal { H } _ { t } ^ { k } ( M ) ,
$$

which results in the Hodge-Morrey-Friedrichs decomposition given as follows:

$$
\Omega ^ { k } ( M ) = d \Omega _ { n } ^ { k - 1 } ( M ) \oplus \delta \Omega _ { t } ^ { k + 1 } ( M ) \oplus \mathcal { H } _ { c o } ^ { k } ( M ) \oplus \mathcal { H } _ { n } ^ { k } ( M )
$$

$$
= d \Omega _ { n } ^ { k - 1 } ( M ) \oplus \delta \Omega _ { t } ^ { k + 1 } ( M ) \oplus \mathcal { H } _ { e x } ^ { k } ( M ) \oplus \mathcal { H } _ { t } ^ { k } ( M ) .
$$

In particular, if M is a compact domain in Euclidean spaces, then there is a unique orthogonal 5component decomposition

$$
\Omega ^ { k } ( M ) = d \Omega _ { n } ^ { k - 1 } ( M ) \oplus \delta \Omega _ { t } ^ { k + 1 } ( M ) \oplus \mathcal { H } _ { n } ^ { k } ( M ) \oplus \mathcal { H } _ { t } ^ { k } ( M ) \oplus ( d \Omega ^ { k - 1 } ( M ) \cap \delta \Omega ^ { k + 1 } ( M ) ) ,
$$

as the spaces H k n ( M ) and H k t ( M ) are L 2 -orthogonal, instead of just being transversal for compact manifolds in general [56]. Due to the correspondence between di ff erential forms and vector fields in the low-dimensional Euclidean spaces, the implementation of this 5-component Hodge decomposition has been applied and implemented to the study of vector fields for surface triangle meshes, for tetrahedral meshes [69] and for regular Cartesian grids [58].

As we mainly focus on applications of compact domains in R 3 , to study the geometric and topological information of the underlying manifolds, there are eight Laplacians to be considered, which are defined on the spaces of di ff erential k -forms with k = 0 , 1 , 2 , 3 satisfying either the normal or the tangential boundary conditions. However, thanks to the duality between the space of normal fields and tangential fields, the study of the spectra of these eight Laplacians reduces to that of four Laplacians on one of the two types of boundary conditions, and finally to the singular spectra of three di ff erential operators, applied to di ff erential forms of degree k = 0 , 1 , 2 , 3 [18]. Further details will be discussed in the next section for the discretization of Laplacians.

## 3. Discretization and construction of Laplacians

In this section, we elaborate on the discretization of the Hodge Laplacian and introduce the boundary-induced graph (BIG) Laplacian for compact domains in low-dimensional Euclidean spaces [52]. Although the theory works for 2D compact domains, for the remainder of the paper we focus only on compact domains in R 3 , as we target mainly 3D applications. We use discrete exterior calculus (DEC) to discretize all di ff erential operators and di ff erential forms on regular Cartesian grids, as it allows for e ffi cient and accurate numerical algorithms relying on just matrix algebra, while keeping the L 2 orthogonality between di ff erent components in Hodge decomposition. In addition, the constructed discrete di ff erential operators and di ff erential forms in DEC approximate their smooth analogs. For the characterization of the underlying manifold, we choose the Eulerian formulation, where the manifold is given as a sublevel set of a level set function defined on a regular Cartesian grid. Another common way, called the Lagrangian formulation, discretizes the manifold as simplicial
