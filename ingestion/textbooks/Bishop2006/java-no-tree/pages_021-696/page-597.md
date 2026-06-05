[Page 597]

![image 134](../../../../../images/imageFile134.png)

###### 12.2. Probabilistic peA 577

dimensionality. If we restrict the covariance matrix to be diagonal, then it has only D independent parameters, and so the number of parameters now grows linearly with dimensionality. However, it now treats the variables as if they were independent and hence can no longer express any correlations between them. Probabilistic PeA provides an elegant compromise in which the M most significant correlations can be captured while still ensuring that the total number of parameters grows only linearly with D. We can see this by evaluating the number of degrees of freedom in the PPCA model as follows. The covariance matrix C depends on the parameters W, which has size D x M, and a2, giving a total parametercountofDM+1. However, we have seen that there is some redundancy in this parameterization associated with rotations of the coordinate system in the latent space. The orthogonal matrix R that expresses these rotations has size M x M. In the first column ofthis matrix there are M - 1 independent parameters, because the column vector must be normalized to unit length. In the second column there are M - 2 independent parameters, because the column must be normalized and also must be orthogonal to the previous column, and so on. Summing this arithmetic series, we see that R has a total of M(M -1)/2 independent parameters. Thus the number of degrees of freedom in the covariance matrix C is given by

###### DM +1- M(M - 1)/2. (12.51)

The number of independent parameters in this model therefore only grows linearly with D, for fixed M. If we take M = D - 1, then we recover the standard result for a full covariance Gaussian. In this case, the variance along D - 1 linearly independent directions is controlled by the columns of W, and the variance along the remaining direction is given by a2. IfM = 0, the model is equivalent to the isotropic covariance case.

- Exercise 12.14


###### 12.2.2 EM algorithm for peA

As we have seen, the probabilistic PCA model can be expressed in terms of a marginalization over a continuous latent space z in which for each data point X n , there is a corresponding latent variable Zn. We can therefore make use of the EM algorithm to find maximum likelihood estimates of the model parameters. This may seem rather pointless because we have already obtained an exact closed-form solution for the maximum likelihood parameter values. However, in spaces of high dimensionality, there may be computational advantages in using an iterative EM procedure rather than working directly with the sample covariance matrix. This EM procedure can also be extended to the factor analysis model, for which there is no closed-form solution. Finally, it allows missing data to be handled in a principled way.

Section 12.2.4

We can derive the EM algorithm for probabilistic PCA by following the general framework for EM. Thus we write down the complete-data log likelihood and take its expectation with respect to the posterior distribution of the latent distribution evaluated using 'old' parameter values. Maximization of this expected completedata log likelihood then yields the 'new' parameter values. Because the data points

Section 9.4
