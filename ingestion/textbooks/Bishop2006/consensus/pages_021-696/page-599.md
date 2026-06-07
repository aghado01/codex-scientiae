[Page 599]

eigenvector decomposition of the sample covariance matrix, the EM approach is iterative and so might appear to be less attractive. However, each cycle of the EM algorithm can be computationally much more efﬁcient than conventional PCA in spaces of high dimensionality. To see this, we note that the eigendecomposition of the covariance matrix requires $O(D^3)$ computation. Often we are interested only in the ﬁrst $M$ eigenvectors and their corresponding eigenvalues, in which case we can use algorithms that are $O(MD^2)$. However, the evaluation of the covariance matrix itself takes $O(ND^2)$ computations, where $N$ is the number of data points. Algorithms such as the snapshot method (Sirovich, 1987), which assume that the eigenvectors are linear combinations of the data vectors, avoid direct evaluation of the covariance matrix but are $O(N^3)$ and hence unsuited to large data sets. The EM algorithm described here also does not construct the covariance matrix explicitly. Instead, the most computationally demanding steps are those involving sums over the data set that are $O(NDM)$. For large $D$, and $M \ll D$, this can be a signiﬁcant saving compared to $O(ND^2)$ and can offset the iterative nature of the EM algorithm.

Note that this EM algorithm can be implemented in an on-line form in which each $D$-dimensional data point is read in and processed and then discarded before the next data point is considered. To see this, note that the quantities evaluated in the E step (an $M$-dimensional vector and an $M \times M$ matrix) can be computed for each data point separately, and in the M step we need to accumulate sums over data points, which we can do incrementally. This approach can be advantageous if both $N$ and $D$ are large.

Because we now have a fully probabilistic model for PCA, we can deal with missing data, provided that it is missing at random, by marginalizing over the distribution of the unobserved variables. Again these missing values can be treated using the EM algorithm. We give an example of the use of this approach for data visualization in Figure 12.11.

Another elegant feature of the EM approach is that we can take the limit $\sigma^2 \to 0$, corresponding to standard PCA, and still obtain a valid EM-like algorithm (Roweis, 1998). From (12.55), we see that the only quantity we need to compute in the E step is $\mathbb{E}[\mathbf{z}_n]$. Furthermore, the M step is simpliﬁed because $\mathbf{M} = \mathbf{W}^{\text{T}}\mathbf{W}$. To emphasize the simplicity of the algorithm, let us deﬁne $\widetilde{\mathbf{X}}$ to be a matrix of size $N \times D$ whose $n^{\text{th}}$ row is given by the vector $(\mathbf{x}_n - \bar{\mathbf{x}})^{\text{T}}$ and similarly deﬁne $\mathbf{\Omega}$ to be a matrix of size $M \times N$ whose $n^{\text{th}}$ column is given by the vector $\mathbb{E}[\mathbf{z}_n]$. The E step (12.54) of the EM algorithm for PCA then becomes

$$
\mathbf{\Omega} = (\mathbf{W}_{\text{old}}^{\text{T}}\mathbf{W}_{\text{old}})^{-1}\mathbf{W}_{\text{old}}^{\text{T}}\widetilde{\mathbf{X}}^{\text{T}} \tag{12.58}
$$

and the M step (12.56) takes the form

$$
\mathbf{W}_{\text{new}} = \widetilde{\mathbf{X}}^{\text{T}}\mathbf{\Omega}^{\text{T}}(\mathbf{\Omega}\mathbf{\Omega}^{\text{T}})^{-1}. \tag{12.59}
$$

Again these can be implemented in an on-line form. These equations have a simple interpretation as follows. From our earlier discussion, we see that the E step involves an orthogonal projection of the data points onto the current estimate for the principal subspace. Correspondingly, the M step represents a re-estimation of the principal
