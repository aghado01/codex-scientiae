[Page 11]

![In the image we can see a diagram.](<STGW2024/imageFile4.png>)

Figure 3. Distinction of normal supports (left) and tangential supports (right) for primal 1forms in a 2D Cartesian grid.

In the computation of the discrete Hodge star operators, it is essential to consider and incorporate the boundary conditions. Following the procedure in [58], we keep the dual cell volumes and adjust the primal cell volumes for normal boundary conditions, and do conversely for tangential boundary conditions with the primal cell volumes kept and the dual cell volumes changed. To be specific, when dealing with normal (resp., tangential) boundary conditions, we only compute the volume of the region of the primal (resp., dual) k -cells within the boundary ∂ M for the denominator (resp., numerator) of the ratio in the discrete Hodge star matrix, and leave the dual (resp., primal) cell volumes in the numerator (resp., denominator) unchanged. Each unaltered k -cell has a k -volume of ℓ k . In addition, for numerical stability, we do not alter the volume of outside primal k -cells, and perturb the level set function evaluated at primal / dual grid points to have an absolute value above ϵ = 10 − 5 ℓ , which ensures well-behaved fractional k -volumes. We denote by S I k , n and S I k , t the diagonal Hodge star matrices defined on the entire grid I m corresponding to the normal and tangential boundary conditions, respectively.

The projection matrix to the corresponding support, for each type of boundary condition, can be constructed from the identity matrices by eliminating the rows corresponding to k -cells outside the support. Denote by P k , n the projection matrix for k -cells onto the normal support and by P k , t the one onto the tangential support. We then obtain a new set of di ff erential and Hodge star operators for M :

$$
D _ { k , n } = P _ { k + 1 , n } D _ { k } P _ { k , n } ^ { T } , \quad S _ { k , n } = P _ { k , n } S _ { k , n } ^ { I } P _ { k , n } ^ { T } .
$$

$$
D _ { k , t } = P _ { k + 1 , t } D _ { k } P _ { k , t } ^ { T } , \ \ S _ { k , t } = P _ { k , t } S _ { k , t } ^ { \prime } P _ { k , t } ^ { T } .
$$

The nilpotent property D k + 1 , n D k , n = 0 and D k + 1 , t D k , t = 0 still holds for both boundary conditions due to D I k + 1 D I k = 0 and the following observations:

$$
P _ { k + 1 , n } ^ { T } P _ { k + 1 , n } D _ { k } ^ { l } P _ { k , n } ^ { T } = D _ { k } ^ { l } P _ { k , n } ^ { T } , \quad P _ { k + 1 , l } D _ { k } ^ { l } P _ { k , l } ^ { T } P _ { k , t } = P _ { k + 1 , l } D _ { k } ^ { l } .
$$

The discrete Hodge L 2 -inner products of the two types of discrete k -forms on the manifold M for these two boundary conditions are then given by

$$
( \xi ^ { k } , \zeta ^ { k } ) ^ { n } = ( \xi ^ { k } ) ^ { T } S _ { k , n } \zeta ^ { k } ,
$$

$$
( \xi ^ { k } , \zeta ^ { k } ) ^ { t } = ( \xi ^ { k } ) ^ { T } S _ { k , t } \zeta ^ { k } ,
$$

AIMS Mathematics whose domains are the discrete Ω k n ( M ) and the discrete Ω k t ( M ), respectively. Finally, we assemble the two types of discrete Hodge Laplacians as in the mesh case:
