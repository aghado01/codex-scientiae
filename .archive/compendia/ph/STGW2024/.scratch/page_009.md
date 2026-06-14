[Page 9]

## 3.1. Discretization on entire grid

Denote by I m a rectangular m -dimensional regular Cartesian grid with k -cells oriented according to their alignments with the coordinate axes. The entire grid I m can be treated as a cell complex tessellating a rectangular domain in R m , where each k -cell is a k -dimensional hypercube with edge length ℓ . A continuous di ff erential k -form ω on I m , following the de Rham map, can be discretized by its integral value over each oriented k -cell σ i , given as W i = σ i ω [19]. The discrete di ff erential on discrete k -forms of the grid I m is then encoded by a sparse matrix D I k , which stores the signed incidence between ( k + 1)-cells and k -cells and is given as the transpose of the cell boundary operator ∂ T k + 1 on ( k + 1)-cells following from Stokes’ theorem σ d ω = ∂σ ω . An illustration of the chain complex formed by boundary operator ∂ for a simple grid complex with a single 2D cell can be seen in Figure 1, which is a straightforward generalization of the chain complex on simplicial complexes. Note that the boundary of the boundary of a cell always results in a 0 chain, i.e., ∂∂ = 0, whose transpose immediately produces D I k + 1 D I k = 0, thus preserving the nilpotent property in the continuous setting.

![The image consists of a blue rectangular shape with a white circle inside it. The circle has an arrow pointing from the left to the right. The arrow is pointing towards the center of the blue shape.](<STGW2024/imageFile2.png>)

Figure 1. The chain complex of a single-cell grid formed by the boundary operator: from the face, to its edges, and to their vertices.

The discrete Hodge star establishes a one-to-one correspondence between discrete k -forms on the primal grid I m and discrete ( m − k )-forms on its dual grid, given as the translated grid with grid points located at the m -cell centers of I m , based on the following formula:

$$
\frac { 1 } { | \sigma _ { k } | } \int _ { \sigma _ { k } } \omega \approx \frac { 1 } { | \ast \, \sigma _ { k } | } \int _ { \ast \sigma _ { k } } \ast \omega ,
$$

where ⋆σ k is the dual ( m − k )-cell formed by the dual grid points located at the centers of the primal m -cells incident to σ k . See Figure 2 for an illustration of the correspondences between the primal and dual cells in the Cartesian grid case. Following from the discretization of di ff erential forms, this correspondence leads to a diagonal matrix S I k with diagonal entries given by the ratio between the volumes of the dual ( m − k )-cells and the primal k -cells, ℓ m − k /ℓ k = ℓ m − 2 k . The associated discrete Hodge L 2 -inner product (2.5) of two discrete k -forms V k and W k on grid I m is then given by

$$
( V _ { k } , W _ { k } ) ^ { I } = V _ { k } ^ { T } S _ { k } ^ { I } W _ { k } .
$$
