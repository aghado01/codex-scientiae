[Page 683]

![Figure 14.4](../../../../../images/imageFile328.png)
**Figure 14.4** Comparison of the squared error (green) with the absolute error (red) showing how the latter places much less emphasis on large errors and hence is more robust to outliers and mislabelled data points.

can be addressed by basing the boosting algorithm on the absolute deviation $|y - t|$ instead. These two error functions are compared in Figure 14.4.

## 14.4. Tree-based Models

There are various simple, but widely used, models that work by partitioning the input space into cuboid regions, whose edges are aligned with the axes, and then assigning a simple model (for example, a constant) to each region. They can be viewed as a model combination method in which only one model is responsible for making predictions at any given point in input space. The process of selecting a speciﬁc model, given a new input $\mathbf{x}$, can be described by a sequential decision making process corresponding to the traversal of a binary tree (one that splits into two branches at each node). Here we focus on a particular tree-based framework called classiﬁcation and regression trees, or CART (Breiman et al., 1984), although there are many other variants going by such names as ID3 and C4.5 (Quinlan, 1986; Quinlan, 1993).

Figure 14.5 shows an illustration of a recursive binary partitioning of the input space, along with the corresponding tree structure. In this example, the ﬁrst step divides the whole of the input space into two regions according to whether $x_1 \le \theta_1$ or $x_1 > \theta_1$ where $\theta_1$ is a parameter of the model. This creates two subregions, each of which can then be subdivided independently. For instance, the region $x_1 \le \theta_1$ is further subdivided according to whether $x_2 \le \theta_2$ or $x_2 > \theta_2$, giving rise to the regions denoted A and B. The recursive subdivision can be described by the traversal of the binary tree shown in Figure 14.6. For any new input $\mathbf{x}$, we determine which region it falls into by starting at the top of the tree at the root node and following a path down to a speciﬁc leaf node according to the decision criteria at each node. Note that such decision trees are not probabilistic graphical models.

![Figure 14.5](../../../../../images/imageFile329.png)
**Figure 14.5** Illustration of a two-dimensional input space that has been partitioned into ﬁve regions using axis-aligned boundaries.
