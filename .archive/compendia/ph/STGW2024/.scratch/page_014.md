[Page 14]

that the spectrum of ¯ L k is given by the union of squared nonzero singular values of ¯ D k , ¯ D k − 1 , and 0, with the multiplicity of 0 given by the k -th Betti numbers. The columns of U k and V k corresponding to nonzero singular values, together with the set of harmonic forms, span the entire space of di ff erential k -forms.

In the case that dim( M ) = 3, for each type of boundary condition, we have four Laplacians of di ff erent degrees in total k = 0 , 1 , 2 , 3:

$$
\bar { L } _ { 0 } = \bar { D } _ { 0 } ^ { T } \bar { D } _ { 0 } ,
$$

$$
\bar { L } _ { 1 } = \bar { D } _ { 1 } ^ { T } \bar { D } _ { 1 } + \bar { D } _ { 0 } \bar { D } _ { 0 } ^ { T } ,
$$

$$
\bar { L } _ { 2 } = \bar { D } _ { 2 } ^ { T } \bar { D } _ { 2 } + \bar { D } _ { 1 } \bar { D } _ { 1 } ^ { T } ,
$$

$$
\bar { L } _ { 3 } = \bar { D } _ { 2 } \bar { D } _ { 2 } ^ { T } .
$$

Due to the aforementioned discussion on the spectrum of Laplacians and the duality of the normal and tangential boundary conditions, the spectral analysis of all Laplacians can be reduced to the singular spectra analysis of the three discrete di ff erentials ¯ D 0 , ¯ D 1 , and ¯ D 2 with one type of boundary condition. Note that the numerical evaluation of the singular values of these di ff erentials, in the simplicial mesh case, may di ff er for the two types of boundary conditions, as the degrees of freedom (DoF) for normal k -forms and tangent m − k forms are di ff erent. However, in the Cartesian representation, they are strictly equivalent to each other by shifting the grid in all directions of the axis by ℓ/ 2, so long as M is at least one grid spacing away from the boundary of the grid.

For the computation of the spectra of the Laplacians, we choose the normal boundary condition. The spectra of all Laplacians ¯ L k , n for compact domains in R 3 can be finally decomposed into three distinct parts: the squared singular values of the gradient of tangential scalar fields, denoted by T , the squared singular values of the gradient of normal scalar fields, denoted by N , and the squared singular values of the curl of tangential curl fields, denoted by C .

## 4. Persistent de Rham-Hodge Laplacians

In this section, we present the construction of the persistent de Rham-Hodge Laplacian on di ff erentiable manifolds, which is based on the filtration of manifolds induced by varying a single parameter (the filtration parameter). The spectra of Laplacians carry rich topological and geometric information of a manifold. Essentially, a single manifold does not provide enough information in practical applications like feature extraction for machine learning analysis. As such, instead of studying just a single manifold, one could examine the spectra of a family of manifolds by adjusting the filtration parameter. The spectra of the Laplacians from this family of manifolds could provide much more information than by considering just one, as the topology and geometry could change for di ff erent parameters. This single-parameter family of manifolds, called the evolution of manifolds, was first introduced in [18] based on tetrahedral meshes. We briefly recap the background.

The formal definition of the evolving manifold is given by a one-parameter family of immersions F c = F ( · , c ) with F : B × [ a , b ] → N being a smooth map, where B is called the base manifold, N is the ambient manifold, and c ∈ [ a , b ] is a real parameter within the interval. In practice, the most common way to define the evolution of manifolds without specifying B is through a level set function by adjusting the isovalues. Given a function f : N → [ a , b ], then in our case, we consider the sublevel
