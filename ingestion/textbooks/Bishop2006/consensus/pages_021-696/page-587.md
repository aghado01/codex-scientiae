[Page 587]

![Figure 12.5](../images/imageFile124.png)

Figure 12.5 An original example from the off-line digits data set together with its PCA reconstructions obtained by retaining $M$ principal components for various values of $M$. As $M$ increases the reconstruction becomes more accurate and would be perfect when $M = D = 28 \times 28 = 784$.

where we have made use of the relation

$$
\bar{\mathbf{x}} = \sum_{i=1}^D (\bar{\mathbf{x}}^{\text{T}} \mathbf{u}_i) \mathbf{u}_i \tag{12.21}
$$

which follows from the completeness of the $\{\mathbf{u}_i\}$. This represents a compression of the data set, because for each data point we have replaced the $D$-dimensional vector $\mathbf{x}_n$ with an $M$-dimensional vector having components $(\mathbf{x}_n^{\text{T}} \mathbf{u}_i - \bar{\mathbf{x}}^{\text{T}} \mathbf{u}_i)$. The smaller the value of $M$, the greater the degree of compression. Examples of PCA reconstructions of data points for the digits data set are shown in Figure 12.5.

Another application of principal component analysis is to data pre-processing. In this case, the goal is not dimensionality reduction but rather the transformation of a data set in order to standardize certain of its properties. This can be important in allowing subsequent pattern recognition algorithms to be applied successfully to the data set. Typically, it is done when the original variables are measured in various different units or have signiﬁcantly different variability. For instance in the Old Faithful data set, the time between eruptions is typically an order of magnitude greater than the duration of an eruption. When we applied the $K$-means algorithm to this data set, we ﬁrst made a separate linear re-scaling of the individual variables such that each variable had zero mean and unit variance. This is known as standardizing the data, and the covariance matrix for the standardized data has components

$$
\rho_{ij} = \frac{1}{N} \sum_{n=1}^N \frac{(x_{ni} - \bar{x}_i)}{\sigma_i} \frac{(x_{nj} - \bar{x}_j)}{\sigma_j} \tag{12.22}
$$

where $\sigma_i^2$ is the variance of $x_i$. This is known as the correlation matrix of the original data and has the property that if two components $x_i$ and $x_j$ of the data are perfectly correlated, then $\rho_{ij} = 1$, and if they are uncorrelated, then $\rho_{ij} = 0$.

However, using PCA we can make a more substantial normalization of the data to give it zero mean and unit covariance, so that different variables become decorrelated. To do this, we ﬁrst write the eigenvector equation (12.17) in the form

$$
\mathbf{S}\mathbf{U} = \mathbf{U}\mathbf{L} \tag{12.23}
$$
