[Page 13]

## 3.3. Topology-preserving construction of Laplacians

Preserving the topological structure is a major characteristic of the present work. However, preserving topological structure in various Laplacian operators is a nontrivial job. In this section, we present the detailed construction of topology-preserving Laplacians.

Note that, on the grid, the Hodge Laplacians and the BIG Laplacians are of the same sparsity patterns. For simplicity in exposition when discussing the spectrum analysis of the Laplacians, we let L k be a generic Laplacian matrix of the form

$$
L _ { k } = D _ { k } ^ { T } S _ { k + 1 } D _ { k } + S _ { k } D _ { k - 1 } S _ { k - 1 } ^ { - 1 } D _ { k - 1 } ^ { T } S _ { k } .
$$

Here, the Laplacian L k can be interpreted, under choices of boundary conditions and Hodge star accuracy, as either a Hodge Laplacian or BIG Laplacian (with S k set to identity) under tangential or normal boundary condition. The eigenvalues and eigenvectors of L k can be solved by considering the generalized eigenvalue problem

$$
L _ { k } W = \lambda S _ { k } W ,
$$

where λ is an eigenvalue and W is the associated eigenvector. To analyze the results, we perform the following transformation in the space of discrete forms: ¯ D k = S 1 / 2 k + 1 D k S − 1 / 2 k , ¯ L k = S − 1 / 2 k L k S − 1 / 2 k , and ¯ W = S 1 / 2 k W . Rewriting the formulas above yields a simplified form of the Laplacian

$$
\bar { L } _ { k } = \bar { D } _ { k } ^ { T } \bar { D } _ { k } + \bar { D } _ { k - 1 } \bar { D } _ { k - 1 } ^ { T } ,
$$

and a regular eigenvalue problem:

$$
\bar { L } _ { k } \bar { W } = \lambda \bar { W } .
$$

Note that the property ¯ D k ¯ D k − 1 = 0 is preserved. As the nonzero eigenvalues of ¯ D T k ¯ D k and ¯ D k ¯ D T k for each k are the same, given by the squared nonzero singular values of the discrete di ff erential ¯ D k , and each Laplacian ¯ L k is just the combination of ¯ D T k ¯ D k and ¯ D k − 1 D T k − 1 , the entire spectrum of the Laplacians can thus be studied through the singular values of discrete di ff erentials. Let

$$
\bar { D } _ { k } = U _ { k + 1 } \Sigma _ { k } V _ { k } ^ { T }
$$

be the singular value decomposition of ¯ D k , where U k + 1 and V k are orthogonal matrices and Σ k is a rectangular diagonal matrix with diagonal values given by the singular values of ¯ D k . It follows immediately from ¯ D k ¯ D k − 1 = 0 that

$$
\Sigma _ { k } V _ { k } ^ { T } U _ { k } \Sigma _ { k - 1 } = 0 .
$$

Therefore, the columns of V k corresponding to nonzero singular values of ¯ D k are orthogonal to columns of U k associated with nonzero singular values of ¯ D k − 1 . In addition, it follows from

$$
L _ { k } = V _ { k } \Sigma _ { k } ^ { 2 } V _ { k } ^ { T } + U _ { k } \Sigma _ { k - 1 } ^ { 2 } U _ { k } ^ { T }
$$
