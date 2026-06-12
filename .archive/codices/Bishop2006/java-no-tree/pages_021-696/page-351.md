[Page 351]

Figure 7.2 Example of synthetic data from two classes in two dimensions showing contours of constant y(x) obtained from a support vector machine having a Gaussian kernel function. Also shown are the decision boundary, the margin boundaries, and the support vectors.

form (6.23). Although the data set is not linearly separable in the two-dimensional data space x, it is linearly separable in the nonlinear feature space deﬁned implicitly by the nonlinear kernel function. Thus the training data points are perfectly separated in the original data space.

This example also provides a geometrical insight into the origin of sparsity in the SVM. The maximum margin hyperplane is deﬁned by the location of the support vectors. Other data points can be moved around freely (so long as they remain outside the margin region) without changing the decision boundary, and so the solution will be independent of such data points.

###### 7.1.1 Overlapping class distributions

So far, we have assumed that the training data points are linearly separable in the feature space φ(x). The resulting support vector machine will give exact separation of the training data in the original input space x, although the corresponding decision boundary will be nonlinear. In practice, however, the class-conditional distributions may overlap, in which case exact separation of the training data can lead to poor generalization.

We therefore need a way to modify the support vector machine so as to allow some of the training points to be misclassiﬁed. From (7.19) we see that in the case of separable classes, we implicitly used an error function that gave inﬁnite error if a data point was misclassiﬁed and zero error if it was classiﬁed correctly, and then optimized the model parameters to maximize the margin. We now modify this approach so that data points are allowed to be on the ‘wrong side’ of the margin boundary, but with a penalty that increases with the distance from that boundary. For the subsequent optimization problem, it is convenient to make this penalty a linear function of this distance. To do this, we introduce slack variables, ξn 0 where n = 1,...,N, with one slack variable for each training data point (Bennett, 1992; Cortes and Vapnik, 1995). These are deﬁned by ξn = 0 for data points that are on or inside the correct margin boundary and ξn = |tn − y(xn)| for other points. Thus a data point that is on the decision boundary y(xn) = 0 will have ξn = 1, and points
