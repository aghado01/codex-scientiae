[Page 683]

Comparison of the squared error (green) with the absolute error (red) showing how the latter places much less emphasis on large errors and hence is more robust to outliers and mislabelled data points.

![The image consists of a graph with two lines. The graph is labeled as E(z) = 0 and has a vertical line at the point where the two lines intersect. The graph is drawn with a red line and a green line. The x-axis is labeled as z and the y-axis is labeled as E(z). The graph is labeled as E(z) = 0 and has a vertical line at the point where the two lines intersect.](../images/imageFile328.png)

E

(

z

)

z

-

1

0

1

can be addressed by basing the boosting algorithm on the absolute deviation | y − t | instead. These two error functions are compared in Figure 14.4.

# 14.4. Tree-based Models

There are various simple, but widely used, models that work by partitioning the input space into cuboid regions, whose edges are aligned with the axes, and then assigning a simple model (for example, a constant) to each region. They can be viewed as a model combination method in which only one model is responsible for making predictions at any given point in input space. The process of selecting a speciﬁc model, given a new input x , can be described by a sequential decision making process corresponding to the traversal of a binary tree (one that splits into two branches at each node). Here we focus on a particular tree-based framework called classiﬁcation and regression trees , or CART (Breiman et al. , 1984), although there are many other variants going by such names as ID3 and C4.5 (Quinlan, 1986; Quinlan, 1993).

Figure 14.5 shows an illustration of a recursive binary partitioning of the input space, along with the corresponding tree structure. In this example, the first step divides the whole of the input space into two regions according to whether x 1 /lessorequalslant θ 1 or x 1 > θ 1 where θ 1 is a parameter of the model. This creates two subregions, each of which can then be subdivided independently. For instance, the region x 1 /lessorequalslant θ 1 is further subdivided according to whether x 2 /lessorequalslant θ 2 or x 2 > θ 2 , giving rise to the regions denoted A and B. The recursive subdivision can be described by the traversal of the binary tree shown in Figure 14.6. For any new input x , we determine which region it falls into by starting at the top of the tree at the root node and following a path down to a specific leaf node according to the decision criteria at each node. Note that such decision trees are not probabilistic graphical models.

Figure 14.5 Illustration of a two-dimensional input space that has been partitioned into ﬁve regions using axis-aligned boundaries.

x

![The image depicts a diagram with two parallel lines labeled as ( A ) and ( B ). The line ( A ) is a straight line, while the line ( B ) is a curved line. Both lines are parallel to each other. ### Objects in the Image: 1. **Line ( A )**: - **Label**: The line ( A ) is a straight line. - **Length**: The length of the line ( A ) is 0.2 meters. - **Position**: The line ( A ) is located at the top of the image. 2. **Line ( B )**: - **Label**: The line ( B ) is a curved line. - **Length**: The length of the line ( B ) is 0.1 meters. - **Position**: The line ( B ) is located at the](../images/imageFile329.png)

2

E

θ

3

B

C

D

θ

2

A

x

θ

θ

1

1

4
