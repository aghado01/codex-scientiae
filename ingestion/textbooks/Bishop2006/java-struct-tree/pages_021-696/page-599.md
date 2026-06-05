[Page 599]

![image 136](../../../../../images/imageFile136.png)

12.2. Probabilistic peA 579

eigenvector decomposition of the sample covariance matrix, the EM approach is iterative and so might appear to be less attractive. However, each cycle of the EM algorithm can be computationally much more efficient than conventional PCA in spaces of high dimensionality. To see this, we note that the eigendecomposition of the covariance matrix requires O(D3) computation. Often we are interested only in the first M eigenvectors and their corresponding eigenvalues, in which case we can use algorithms that are 0 (MD2). However, the evaluation of the covariance matrix itself takes 0 (ND 2 ) computations, where N is the number of data points. Algorithms such as the snapshot method (Sirovich, 1987), which assume that the eigenvectors are linear combinations of the data vectors, avoid direct evaluation of the covariance matrix but are O(N3) and hence unsuited to large data sets. The EM algorithm described here also does not construct the covariance matrix explicitly. Instead, the most computationally demanding steps are those involving sums over the data set that are 0 (NDM). For large D, and M « D, this can be a significant saving compared to 0 (ND 2) and can offset the iterative nature of the EM algorithm.

Note that this EM algorithm can be implemented in an on-line form in which each D-dimensional data point is read in and processed and then discarded before the next data point is considered. To see this, note that the quantities evaluated in the E step (an M-dimensional vector and an M x M matrix) can be computed for each data point separately, and in the M step we need to accumulate sums over data points, which we can do incrementally. This approach can be advantageous if both Nand D are large.

Because we now have a fully probabilistic model for PCA, we can deal with missing data, provided that it is missing at random, by marginalizing over the distribution of the unobserved variables. Again these missing values can be treated using the EM algorithm. We give an example of the use of this approach for data visualization in Figure 12.11.

Another elegant feature ofthe EM approach is that we can take the limit a2 ----t 0, corresponding to standard PCA, and still obtain a valid EM-like algorithm (Roweis, 1998). From (12.55), we see that the only quantity we need to compute in the Estep is JE[zn]. Furthermore, the M step is simplifie~ because M = WTW. To emphasize the simplicity of the algorithm, let us define X to be a matrix of size N x D whose nth row is given by the vector Xn - x and similarly define 0 to be a matrix of size D x M whose nth row is given by the vector JE[zn]. The Estep (12.54) of the EM algorithm for PCA then becomes

o = (W~dWold)-lW~dX

(12.58)

and the M step (12.56) takes the form

W new = XTOT(OOT)-l. (12.59)

Again these can be implemented in an on-line form. These equations have a simple interpretation as follows. From our earlier discussion, we see that the E step involves an orthogonal projection of the data points onto the current estimate for the principal subspace. Correspondingly, the M step represents a re-estimation of the principal
