[Page 351]

![The image depicts a geometric figure with various interconnected circles. The circles are arranged in a circular pattern, with each circle forming a distinct shape. Here is a detailed description of the image: - **Circles**: There are five distinct circles in the image. Each circle is a circle with a different shape. The circles are arranged in a circular pattern, with each circle forming a distinct shape. The circles are connected by lines, forming a continuous line that connects each circle. - **Shapes**: The circles are of different shapes. The first circle is a circle with a diameter of 2 units. The second circle is a circle with a diameter of 3 units. The third circle is a circle with a diameter of 4 units. The fourth circle is a circle with a diameter of 5 units. The fifth circle is a circle with a diameter of 6 units. - **Lines**: There are lines connecting each circle. The lines are straight and connect the](../images/imageFile147.png)

form (6.23). Although the data set is not linearly separable in the two-dimensional data space x , it is linearly separable in the nonlinear feature space deﬁned implicitly by the nonlinear kernel function. Thus the training data points are perfectly separated in the original data space.

This example also provides a geometrical insight into the origin of sparsity in the SVM. The maximum margin hyperplane is deﬁned by the location of the support vectors. Other data points can be moved around freely (so long as they remain outside the margin region) without changing the decision boundary, and so the solution will be independent of such data points.

# 7.1.1 Overlapping class distributions

So far, we have assumed that the training data points are linearly separable in the feature space φ ( x ) . The resulting support vector machine will give exact separation of the training data in the original input space x , although the corresponding decision boundary will be nonlinear. In practice, however, the class-conditional distributions may overlap, in which case exact separation of the training data can lead to poor generalization.
