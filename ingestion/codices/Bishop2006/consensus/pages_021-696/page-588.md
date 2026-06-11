[Page 588]

![Figure 12.6](../images/imageFile125.png)

Figure 12.6 Illustration of the effects of linear pre-processing applied to the Old Faithful data set. The plot on the left shows the original data. The centre plot shows the result of standardizing the individual variables to zero mean and unit variance. Also shown are the principal axes of this normalized data set, plotted over the range $\pm \lambda_i^{1/2}$. The plot on the right shows the result of whitening of the data to give it zero mean and unit covariance.

where $\mathbf{L}$ is a $D \times D$ diagonal matrix with elements $\lambda_i$, and $\mathbf{U}$ is a $D \times D$ orthogonal matrix with columns given by $\mathbf{u}_i$. Then we deﬁne, for each data point $\mathbf{x}_n$, a transformed value given by

$$
\mathbf{y}_n = \mathbf{L}^{-1/2} \mathbf{U}^{\text{T}} (\mathbf{x}_n - \bar{\mathbf{x}}) \tag{12.24}
$$

where $\bar{\mathbf{x}}$ is the sample mean deﬁned by (12.1). Clearly, the set $\{\mathbf{y}_n\}$ has zero mean, and its covariance is given by the identity matrix because

$$
\begin{aligned}
\frac{1}{N} \sum_{n=1}^N \mathbf{y}_n \mathbf{y}_n^{\text{T}} &= \frac{1}{N} \sum_{n=1}^N \mathbf{L}^{-1/2} \mathbf{U}^{\text{T}} (\mathbf{x}_n - \bar{\mathbf{x}})(\mathbf{x}_n - \bar{\mathbf{x}})^{\text{T}} \mathbf{U} \mathbf{L}^{-1/2} \\
&= \mathbf{L}^{-1/2} \mathbf{U}^{\text{T}} \mathbf{S} \mathbf{U} \mathbf{L}^{-1/2} = \mathbf{L}^{-1/2} \mathbf{L} \mathbf{L}^{-1/2} = \mathbf{I}. \tag{12.25}
\end{aligned}
$$

This operation is known as whitening or sphereing the data and is illustrated for the Old Faithful data set in Figure 12.6.

It is interesting to compare PCA with the Fisher linear discriminant which was discussed in Section 4.1.4. Both methods can be viewed as techniques for linear dimensionality reduction. However, PCA is unsupervised and depends only on the values $\mathbf{x}_n$ whereas Fisher linear discriminant also uses class-label information. This difference is highlighted by the example in Figure 12.7.

Another common application of principal component analysis is to data visualization. Here each data point is projected onto a two-dimensional ($M = 2$) principal subspace, so that a data point $\mathbf{x}_n$ is plotted at Cartesian coordinates given by $\mathbf{x}_n^{\text{T}} \mathbf{u}_1$ and $\mathbf{x}_n^{\text{T}} \mathbf{u}_2$, where $\mathbf{u}_1$ and $\mathbf{u}_2$ are the eigenvectors corresponding to the largest and second largest eigenvalues. An example of such a plot, for the oil ﬂow data set, is shown in Figure 12.8.
