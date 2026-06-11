[Page 590]

![image 127](../../../../../images/imageFile127.png)

###### 570 12. CONTINUOUS LATENT VARIABLES

dimensional centred data matrix, whose nth row is given by (xn - X)T. The covariance matrix (12.3) can then be written as S = N-1XTX, and the corresponding eigenvector equation becomes

-XN1 TXUi = AiUi. Now pre-multiply both sides by X to give

- (12.26)
- (12.27)
- (12.28)


NXX1 T (XUi) = Ai(XUi)' Ifwe now define Vi = XUi, we obtain

-XX1 T Vi = AiVi

N

which is an eigenvector equation for the N x N matrix N-1XXT . We see that this has the same N -1 eigenvalues as the original covariance matrix (which itself has an additional D - N +1eigenvalues ofvalue zero). Thus we can solve the eigenvector problem in spaces of lower dimensionality with computational cost O(N3) instead of O(D3). In order to determine the eigenvectors, we multiply both sides of (12.28) by X T to give

NX1 T)X (XTVi) = Ai(XTVi) (12.29)

(

from which we see that (XTVi) is an eigenvector of S with eigenvalue Ai. Note, however, that these eigenvectors need not be normalized. To determine the appropriate normalization, we re-scale Ui ex: XTVi by a constant such that IluiII = 1, which, assuming Vi has been normalized to unit length, gives

1 T

Ui = (NAi)1/2 X Vi·

(12.30)

In summary, to apply this approach we first evaluate XXT and then find its eigenvectors and eigenvalues and then compute the eigenvectors in the original data space using (12.30).

###### 12.2. Probabilistic peA

The formulation of PCA discussed in the previous section was based on a linear projection of the data onto a subspace of lower dimensionality than the original data space. We now show that PCA can also be expressed as the maximum likelihood solution of a probabilistic latent variable model. This reformulation of PCA, known as probabilistic peA, brings several advantages compared with conventional PCA:

• Probabilistic PCA represents a constrained form of the Gaussian distribution in which the number of free parameters can be restricted while still allowing the model to capture the dominant correlations in a data set.
