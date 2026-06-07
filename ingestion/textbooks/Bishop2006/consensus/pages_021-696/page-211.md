[Page 211]

### 4.1.6 Fisher’s discriminant for multiple classes

We now consider the generalization of the Fisher discriminant to $K > 2$ classes, and we shall assume that the dimensionality $D$ of the input space is greater than the number $K$ of classes. Next, we introduce $D' > 1$ linear ‘features’ $y_k = \mathbf{w}_k^\text{T}\mathbf{x}$, where $k = 1,\ldots,D'$. These feature values can conveniently be grouped together to form a vector $\mathbf{y}$. Similarly, the weight vectors $\{\mathbf{w}_k\}$ can be considered to be the columns of a matrix $\mathbf{W}$, so that

$$
\mathbf{y} = \mathbf{W}^{\text{T}}\mathbf{x}. \tag{4.39}
$$

Note that again we are not including any bias parameters in the definition of $\mathbf{y}$. The generalization of the within-class covariance matrix to the case of $K$ classes follows from (4.28) to give

$$
\mathbf{S}_W = \sum_{k=1}^K \mathbf{S}_k \tag{4.40}
$$

where

$$
\mathbf{S}_k = \sum_{n \in \mathcal{C}_k} (\mathbf{x}_n - \mathbf{m}_k)(\mathbf{x}_n - \mathbf{m}_k)^{\text{T}} \tag{4.41}
$$

$$
\mathbf{m}_k = \frac{1}{N_k} \sum_{n \in \mathcal{C}_k} \mathbf{x}_n \tag{4.42}
$$

and $N_k$ is the number of patterns in class $\mathcal{C}_k$. In order to find a generalization of the between-class covariance matrix, we follow Duda and Hart (1973) and consider first the total covariance matrix

$$
\mathbf{S}_T = \sum_{n=1}^N (\mathbf{x}_n - \mathbf{m})(\mathbf{x}_n - \mathbf{m})^{\text{T}} \tag{4.43}
$$

where $\mathbf{m}$ is the mean of the total data set

$$
\mathbf{m} = \frac{1}{N} \sum_{n=1}^N \mathbf{x}_n = \frac{1}{N} \sum_{k=1}^K N_k \mathbf{m}_k \tag{4.44}
$$

and $N = \sum_{k=1}^K N_k$ is the total number of data points. The total covariance matrix can be decomposed into the sum of the within-class covariance matrix, given by (4.40) and (4.41), plus an additional matrix $\mathbf{S}_B$, which we identify as a measure of the between-class covariance

$$
\mathbf{S}_T = \mathbf{S}_W + \mathbf{S}_B \tag{4.45}
$$

where

$$
\mathbf{S}_B = \sum_{k=1}^K N_k(\mathbf{m}_k - \mathbf{m})(\mathbf{m}_k - \mathbf{m})^{\text{T}}. \tag{4.46}
$$

These covariance matrices have been defined in the original $\mathbf{x}$-space. We can now define similar matrices in the projected $D'$-dimensional $\mathbf{y}$-space
