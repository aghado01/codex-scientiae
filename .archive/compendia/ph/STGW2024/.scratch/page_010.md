[Page 10]

The discrete codi ff erential, by definition of its smooth counterpart (2.6), can be assembled from the discrete di ff erential and Hodge star operators as δ I k = ( S I k − 1 ) − 1 D I k − 1 S I k . Note that the discrete counterpart of the Hodge Laplacian ∆ = d δ + δ d by replacing the di ff erential and codi ff erential operators results in a nonsymmetric matrix. Instead, we consider the counterpart of ⋆ ∆ as the discrete Hodge Laplacian given by

$$
L _ { k } ^ { I } = ( D _ { k } ^ { I } ) ^ { T } S _ { k + 1 } ^ { I } D _ { k } ^ { I } + S _ { k } ^ { I } D _ { k - 1 } ^ { I } ( S _ { k - 1 } ^ { I } ) ^ { - 1 } ( D _ { k - 1 } ^ { I } ) ^ { T } S _ { k } ^ { I } ,
$$

where the operators are considered to be null for k < 0 or k > m .

![In this image, we can see some text and numbers.](<STGW2024/imageFile3.png>)

O-cell

2-cell

1-cell

dual 2-cell

dual 1-cell

dual O-cell

Figure 2. An example of the primal and dual grid cells for the 2D case. The top row highlights the primal cells, and the bottom row presents their corresponding dual cells.

## 3.2. Discrete di ff erential forms and operators on M

Compared to the case of simplicial or polygonal meshes, where the projection matrices to the interior can be straightforward to implement with the boundary elements explicitly labeled, modeling the manifold M as the volume bounded by a level set surface leads to delicate computation of the projection matrices. Note that the boundary of M using grid representation typically intersects with boundary k -cells instead of being its supersets. We restrict the computation to relevant cells by implementing the two types of boundary conditions through the inclusion or exclusion of the entire k -cells. We use the strategy as in [58] for the computation of projection matrices for each type of boundary condition: for the normal boundary condition, we include all cells if at least one of its vertices is inside or on the boundary of M , while for the tangential boundary condition, we include all cells with at least one of the vertices of the corresponding dual cells is inside or on the boundary. We refer to the former set of cells as the normal support and the latter as the tangential support. In contrast to the mesh case, it is important to note that neither the normal nor the tangential support is necessarily a superset of the other. See Figure 3 for one example showing the distinction of these two supports for 1-forms.
