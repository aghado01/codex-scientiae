[Page 683]

- Figure 14.4 Comparison of the squared error (green) with the absolute error (red) showing how the latter places much less emphasis on large errors and hence is more robust to outliers and mislabelled data points.

0 z

E(z)

−1 1

can be addressed by basing the boosting algorithm on the absolute deviation |y − t| instead. These two error functions are compared in Figure 14.4.

14.4. Tree-based Models

There are various simple, but widely used, models that work by partitioning the input space into cuboid regions, whose edges are aligned with the axes, and then assigning a simple model (for example, a constant) to each region. They can be viewed as a model combination method in which only one model is responsible for making predictions at any given point in input space. The process of selecting a speciﬁc model, given a new input x, can be described by a sequential decision making process corresponding to the traversal of a binary tree (one that splits into two branches at each node). Here we focus on a particular tree-based framework called classiﬁcation and regression trees, or CART (Breiman et al., 1984), although there are many other variants going by such names as ID3 and C4.5 (Quinlan, 1986; Quinlan, 1993).

Figure 14.5 shows an illustration of a recursive binary partitioning of the input space, along with the corresponding tree structure. In this example, the ﬁrst step

- Figure 14.5 Illustration of a two-dimensional input space that has been partitioned into ﬁve regions using axis-aligned boundaries.


x2

|B|E| |
|---|---|---|
| |C|D|
|A| | |


- θ2
- θ3


x1

θ1 θ4
