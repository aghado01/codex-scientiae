[Page 586]

![Figure 12.3](../images/imageFile123.png)

Figure 12.3 The mean vector $\bar{\mathbf{x}}$ along with the ﬁrst four PCA eigenvectors $\mathbf{u}_1, \dots, \mathbf{u}_4$ for the off-line digits data set, together with the corresponding eigenvalues.

in the original $D$-dimensional space, we can represent the eigenvectors as images of the same size as the data points. The ﬁrst ﬁve eigenvectors, along with the corresponding eigenvalues, are shown in Figure 12.3. A plot of the complete spectrum of eigenvalues, sorted into decreasing order, is shown in Figure 12.4(a). The distortion measure $J$ associated with choosing a particular value of $M$ is given by the sum of the eigenvalues from $M + 1$ up to $D$ and is plotted for different values of $M$ in Figure 12.4(b).

If we substitute (12.12) and (12.13) into (12.10), we can write the PCA approximation to a data vector $\mathbf{x}_n$ in the form

$$
\begin{aligned}
\tilde{\mathbf{x}}_n &= \sum_{i=1}^M (\mathbf{x}_n^{\text{T}} \mathbf{u}_i) \mathbf{u}_i + \sum_{i=M+1}^D (\bar{\mathbf{x}}^{\text{T}} \mathbf{u}_i) \mathbf{u}_i \tag{12.19} \\
&= \bar{\mathbf{x}} + \sum_{i=1}^M (\mathbf{x}_n^{\text{T}} \mathbf{u}_i - \bar{\mathbf{x}}^{\text{T}} \mathbf{u}_i) \mathbf{u}_i \tag{12.20}
\end{aligned}
$$

![Figure 12.4](../images/imageFile125.png)

Figure 12.4 (a) Plot of the eigenvalue spectrum for the off-line digits data set. (b) Plot of the sum of the discarded eigenvalues, which represents the sum-of-squares distortion $J$ introduced by projecting the data onto a principal component subspace of dimensionality $M$.
