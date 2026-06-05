[Page 599]

Note that this EM algorithm can be implemented in an on-line form in which each D-dimensional data point is read in and processed and then discarded before the next data point is considered. To see this, note that the quantities evaluated in the E step (an M-dimensional vector and an M x M matrix) can be computed for each data point separately, and in the M step we need to accumulate sums over data points, which we can do incrementally. This approach can be advantageous if both Nand D are large.

Because we now have a fully probabilistic model for PCA, we can deal with missing data, provided that it is missing at random, by marginalizing over the distribution of the unobserved variables. Again these missing values can be treated using the EM algorithm. We give an example of the use of this approach for data visualization in Figure 12.11. 2

Another elegant feature ofthe EM approach is that we can take the limit a ----t 0, corresponding to standard PCA, and still obtain a valid EM-like algorithm (Roweis, 1998). From (12.55), we see that the only quantity we need to compute in the Estep is JE[zn]. Furthermore, the M step is simplifie~ because M = WTW. To emphasize the simplicity of the algorithm, let us define X to be a matrix of size N x D whose nth row is given by the vector X n x and similarly define 0 to be a matrix of size D x M whose nth row is given by the vector JE[zn]. The Estep (12.54) of the EM algorithm for PCA then becomes

$$
\Omega = ( W _ { o l d } ^ { T } W _ { o l d } ) ^ { - 1 } W _ { o l d } ^ { T } \widetilde { X }
$$

and the M step (12.56) takes the form

$$
W _ { n e w } = \tilde { X } ^ { T } \Omega ^ { T } ( \Omega \Omega ^ { T } ) ^ { - 1 } .
$$

Again these can be implemented in an on-line form. These equations have a simple interpretation as follows. From our earlier discussion, we see that the E step involves an orthogonal projection of the data points onto the current estimate for the principal subspace. Correspondingly, the M step represents a re-estimation of the principal
