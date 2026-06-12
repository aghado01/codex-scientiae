[Page 584]

where the $\{z_{ni}\}$ depend on the particular data point, whereas the $\{b_i\}$ are constants that are the same for all data points. We are free to choose the $\{\mathbf{u}_i\}$, the $\{z_{ni}\}$, and the $\{b_i\}$ so as to minimize the distortion introduced by the reduction in dimensionality. As our distortion measure, we shall use the squared distance between the original data point $\mathbf{x}_n$ and its approximation $\tilde{\mathbf{x}}_n$, averaged over the data set, so that our goal is to minimize

$$
J = \frac{1}{N} \sum_{n=1}^N \|\mathbf{x}_n - \tilde{\mathbf{x}}_n\|^2. \tag{12.11}
$$

Consider ﬁrst of all the minimization with respect to the quantities $\{z_{ni}\}$. Substituting for $\tilde{\mathbf{x}}_n$, setting the derivative with respect to $z_{nj}$ to zero, and making use of the orthonormality conditions, we obtain

$$
z_{nj} = \mathbf{x}_n^{\text{T}} \mathbf{u}_j \tag{12.12}
$$

where $j = 1, \dots, M$. Similarly, setting the derivative of $J$ with respect to $b_i$ to zero, and again making use of the orthonormality relations, gives

$$
b_j = \bar{\mathbf{x}}^{\text{T}} \mathbf{u}_j \tag{12.13}
$$

where $j = M + 1, \dots, D$. If we substitute for $z_{ni}$ and $b_i$, and make use of the general expansion (12.9), we obtain

$$
\mathbf{x}_n - \tilde{\mathbf{x}}_n = \sum_{i=M+1}^D \{(\mathbf{x}_n - \bar{\mathbf{x}})^{\text{T}} \mathbf{u}_i\} \mathbf{u}_i \tag{12.14}
$$

from which we see that the displacement vector from $\mathbf{x}_n$ to $\tilde{\mathbf{x}}_n$ lies in the space orthogonal to the principal subspace, because it is a linear combination of $\{\mathbf{u}_i\}$ for $i = M + 1, \dots, D$, as illustrated in Figure 12.2. This is to be expected because the projected points $\tilde{\mathbf{x}}_n$ must lie within the principal subspace, but we can move them freely within that subspace, and so the minimum error is given by the orthogonal projection.

We therefore obtain an expression for the distortion measure $J$ as a function purely of the $\{\mathbf{u}_i\}$ in the form

$$
J = \frac{1}{N} \sum_{n=1}^N \sum_{i=M+1}^D (\mathbf{x}_n^{\text{T}} \mathbf{u}_i - \bar{\mathbf{x}}^{\text{T}} \mathbf{u}_i)^2 = \sum_{i=M+1}^D \mathbf{u}_i^{\text{T}} \mathbf{S} \mathbf{u}_i. \tag{12.15}
$$

There remains the task of minimizing $J$ with respect to the $\{\mathbf{u}_i\}$, which must be a constrained minimization otherwise we will obtain the vacuous result $\mathbf{u}_i = \mathbf{0}$. The constraints arise from the orthonormality conditions and, as we shall see, the solution will be expressed in terms of the eigenvector expansion of the covariance matrix. Before considering a formal solution, let us try to obtain some intuition about the result by considering the case of a two-dimensional data space $D = 2$ and a onedimensional principal subspace $M = 1$. We have to choose a direction $\mathbf{u}_2$ so as to
