[Page 589]

![Figure 12.7](../images/imageFile126.png)

Figure 12.7 A comparison of principal component analysis with Fisher’s linear discriminant for linear dimensionality reduction. Here two data in two dimensions, belonging to two classes shown in red and blue, is to be projected onto a single dimension. PCA chooses the direction of maximum variance, shown by the magenta curve, which leads to strong class overlap, whereas the Fisher linear discriminant takes account of the class labels and leads to a projection onto the green curve giving much better class separation.

![Figure 12.8](../images/imageFile131.png)

Figure 12.8 Visualization of the oil ﬂow data set obtained by projecting the data onto the ﬁrst two principal components. The red, blue, and green points correspond to the ‘laminar’, ‘homogeneous’, and ‘annular’ ﬂow conﬁgurations respectively.

### 12.1.4 PCA for high-dimensional data

In some applications of principal component analysis, the number of data points is smaller than the dimensionality of the data space. For example, we might want to apply PCA to a data set of a few hundred images, each of which corresponds to a vector in a space of potentially several million dimensions (corresponding to three colour values for each of the pixels in the image). Note that in a $D$-dimensional space a set of $N$ points, where $N < D$, deﬁnes a linear subspace whose dimensionality is at most $N - 1$, and so there is little point in applying PCA for values of $M$ that are greater than $N - 1$. Indeed, if we perform PCA we will ﬁnd that at least $D - N + 1$ of the eigenvalues are zero, corresponding to eigenvectors along whose directions the data set has zero variance. Furthermore, typical algorithms for ﬁnding the eigenvectors of a $D \times D$ matrix have a computational cost that scales like $O(D^3)$, and so for applications such as the image example, a direct application of PCA will be computationally infeasible.

We can resolve this problem as follows. First, let us deﬁne $\mathbf{X}$ to be the $N \times D$
