[Page 315]

![The image is a graph with a title at the top that reads 1. There are three different sections of the graph, each labeled with a number from 0 to 1. The graph has a grid with a scale from 0 to 1 on the x-axis, labeled 0. The y-axis is labeled 1, and the graph has a scale from 0 to 1 on the x-axis, labeled 0. The graph has a few different lines and curves, but they are not clearly defined.](../images/imageFile131.png)

Figure 6.1 Illustration of the construction of kernel functions starting from a corresponding set of basis functions. In each column the lower plot shows the kernel function $k(x,x')$ deﬁned by (6.10) plotted as a function of $x$ for $x' = 0$, while the upper plot shows the corresponding basis functions given by polynomials (left column), ‘Gaussians’ (centre column), and logistic sigmoids (right column).

If we take the particular case of a two-dimensional input space $\mathbf{x} = (x_1,x_2)$ we can expand out the terms and thereby identify the corresponding nonlinear feature mapping

$$
\begin{aligned} k(\mathbf{x},\mathbf{z}) &= (\mathbf{x}^T\mathbf{z})^2 = (x_1z_1 + x_2z_2)^2 \\ &= x_1^2z_1^2 + 2x_1z_1x_2z_2 + x_2^2z_2^2 \\ &= (x_1^2, \sqrt{2}x_1x_2, x_2^2) (z_1^2, \sqrt{2}z_1z_2, z_2^2)^T \\ &= \boldsymbol{\phi}(\mathbf{x})^T \boldsymbol{\phi}(\mathbf{z}). \end{aligned} \tag{6.12}
$$

We see that the feature mapping takes the form $\boldsymbol{\phi}(\mathbf{x}) = (x_1^2, \sqrt{2}x_1x_2, x_2^2)^T$ and therefore comprises all possible second order terms, with a speciﬁc weighting between them.

More generally, however, we need a simple way to test whether a function constitutes a valid kernel without having to construct the function $\boldsymbol{\phi}(\mathbf{x})$ explicitly. A necessary and sufﬁcient condition for a function $k(\mathbf{x},\mathbf{x}')$ to be a valid kernel (Shawe-Taylor and Cristianini, 2004) is that the Gram matrix $\mathbf{K}$, whose elements are given by $k(\mathbf{x}_n,\mathbf{x}_m)$, should be positive semideﬁnite for all possible choices of the set $\{\mathbf{x}_n\}$. Note that a positive semideﬁnite matrix is not the same thing as a matrix whose elements are nonnegative.

One powerful technique for constructing new kernels is to build them out of simpler kernels as building blocks. This can be done using the following properties:
