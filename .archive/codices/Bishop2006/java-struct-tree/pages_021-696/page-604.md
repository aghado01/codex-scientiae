[Page 604]

![image 141](../../../../../images/imageFile141.png)

584 12. CONTINUOUS LATENT VARIABLES

••• •• • •

•

••• • •• •• •• ••

•• •• •

•••••••••• • •••••••• ••

• •• •• •• ••

Figure 12.14 'Hinloo' diagrams of the matrix W in which each element 01 the matrix is depicted as a square (white lor positive and black lor negative values) whose area is proportional to the magnitude of that element. The synthetic data sel comprises 300 data points in D = 10 dimensions sampled from a Gaussian distribution having standard deviation 1.0 in 3 directions and standard deviation 0.5 in the remaining 7 directions for a data set in D = 10 dimensions having AT = 3 directions with larger variance than the remaining 7 directions. The left-hand plol shows the result Irom maximum likelihood probabilistic PCA, and the left·hand plot shows the corresponding resuft from Bayesian peA. We see how the Bayesian model is able to discover the appropriate dimensionality by suppressing the 6 surplus degrees of freedom.

taken to have a diagonal rather than an isotropic covariance so that

p(xlz) = N(xlWz +1'. \II) (12.64)

where ill is a D x D diagonal matrix. Note that the factor analysis model, in common with probabilistic PCA. assumes that the observed variables Xl, ... ,Xo are independent. given the latent variable z. In essence. the factor analysis model is explaining the observed covariance structure of the data by representing the independent variance associated with each coordinate in the matrix 1J.' and capturing the covariance between variables in the matrix W. In the factor analysis literature. the columns of W. which capture the correlations between observed variables. are calledfaclOr loadings. and the diagonal elements of 1J.'. which represent the independent noise variances for each of the variables, are called llniqllenesses.

The origins of factor analysis are as old as those of PCA. and discussions of factor analysis can be found in the books by Everitt (1984). Bartholomew (1987), and Basilevsky (1994). Links between factor analysis and PCA were investigated by Lilwley (1953) and Anderson (1963) who showed that at stationary points of the likelihood function. for a faclOr analysis model with 1J.' = (121, the columns of W are scaled eigenvectors of the sample covariance matrix. and (12 is the average of the discarded eigenvalues. Later. Tipping and Bishop (1999b) showed that the maximum of the log likelihood function occurs when the eigenvectors comprising Ware chosen to be the principal eigenvectors.

Making use of (2.115). we see that the marginal distribution for the observed
