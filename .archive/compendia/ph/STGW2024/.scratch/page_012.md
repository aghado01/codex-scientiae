[Page 12]

$$
L _ { k , n } = D _ { k , n } ^ { T } S _ { k + 1 , n } D _ { k , n } + S _ { k , n } D _ { k - 1 , n } S _ { k - 1 , n } ^ { - 1 } D _ { k - 1 , n } ^ { T } S _ { k , n } ,
$$

$$
L _ { k , t } = D _ { k , t } ^ { T } S _ { k + 1 , t } D _ { k , t } + S _ { k , t } D _ { k - 1 , t } S _ { k - 1 , t } ^ { - 1 } D _ { k - 1 , t } ^ { T } S _ { k , t } .
$$

The null spaces of these discrete Hodge Laplacians, as in the continuous case, are fully determined by the topology of the underlying manifold M , since they only depend on the di ff erential and projection matrices. The dimension of the kernel of L k , n is given by the Betti number β m − k , while the dimension of the kernel of L k , t is given by β k . Here, the Betti number β k presents directly the number of k -dimensional holes on the manifold M . For instance, β 0 gives the number of connected components, β 1 gives the number of tunnels, and β 2 provides the number of closed cavities, respectively. The spectra of these Laplacians, in addition, could be used to study the geometric information of the manifold. It is known that the nonzero eigenvalues of the Laplacians provide rich insights into the shape of a manifold. For instance, the Fiedler value, defined as the smallest nonzero eigenvalue of a graph Laplacian, describes connectivity. As another example, the multiplicity of eigenvalues can reveal certain symmetries of the shape.

Remark 4. The two types of discrete Hodge Laplacians (3.9) not only provide rich geometrical and topological information of the underlying manifold, but also play a central role in the computation of the discrete Hodge decomposition (2.22) of di ff erential forms for compact domains in 2D and 3D Euclidean spaces. In particular, they can be utilized, by resolving the rank deficiencies, to compute the potentials of the decomposed components in Hodge decomposition on normal or tangential support satisfying the corresponding boundary conditions. In addition, as the kernel sizes of Laplacians are finite, their eigenvectors corresponding to 0 eigenvalues, for each k, form a basis for the space of normal or tangential harmonic fields.

Note that the discrete Hodge stars in the Eulerian setting are almost identical to rescaled identity matrices. Therefore, the computations of the Hodge Laplacian can be further simplified by replacing the Hodge stars with identity matrices, leading to the definition of the BIG Laplacians as follows:

$$
L _ { k , n } ^ { B } = D _ { k , n } ^ { T } D _ { k , n } + D _ { k - 1 , n } D _ { k - 1 , n } ^ { T } ,
$$

$$
L _ { k , t } ^ { B } = D _ { k , t } ^ { T } D _ { k , t } + D _ { k - 1 , t } D _ { k - 1 , t } ^ { T } .
$$

The BIG Laplacians were introduced in [52] for bounded domains to facilitate the comparison and contrast of the Hodge Laplacians and the combinatorial Laplacians. They preserve the Hodge Laplacian’s capability to perform di ff erential calculus but also retain the discrete nature of combinatorial Laplacians. The convergence of the spectra of the BIG Laplacians to Hodge Laplacians has been discussed in [52], showing that the spectra of (3.11) converge to those of Hodge Laplacians up to a scaling value ℓ − 2 when enforcing the boundary conditions. This scaling value ℓ − 2 is exactly the ratio between the missing scaling factor ℓ m − 2( k + 1) in L k and the missing factor ℓ m − 2 k of S k . As the BIG Laplacians produce results similar to those obtained from the discrete Hodge Laplacians with less computation, they can also be used to study the geometric and topological information of the underlying manifolds.

Note that the dual grid is also a Cartesian grid staggered with the primal grid by a replacement of ℓ/ 2 in all three axial directions of the Cartesian coordinates. For the study of the spectra of these Laplacians, one only needs to implement one type of boundary condition, for instance, the normal boundary condition, as Lk , n defined on the primal grid with normal boundary conditions is equivalent to Lm -k , t defined on its dual grid with tangential boundary conditions.
