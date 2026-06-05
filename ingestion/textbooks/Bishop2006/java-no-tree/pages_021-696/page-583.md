[Page 583]

![image 120](../../../../../images/imageFile120.png)

12.1. Principal Component Analysis 563

amongst all possible directions orthogonal to those already considered. If we consider the general case of an M -dimensional projection space, the optimal linear projection for which the variance of the projected data is maximized is now defined by the M eigenvectors U 1, ... , U M of the data covariance matrix S corresponding to the M largest eigenvalues >'1, ... ,AM. This is easily shown using proofby induction.

Exercise 12.1

To summarize, principal component analysis involves evaluating the mean x and the covariance matrix S of the data set and then finding the M eigenvectors of S corresponding to the M largest eigenvalues. Algorithms for finding eigenvectors and eigenvalues, as well as additional theorems related to eigenvector decomposition, can be found in Golub and Van Loan (1996). Note that the computational cost of computing the full eigenvector decomposition for a matrix of size D x Dis O(D3). If we plan to project our data onto the first M principal components, then we only need to find the first M eigenvalues and eigenvectors. This can be done with more efficient techniques, such as the power method (Golub and Van Loan, 1996), that scale like O(MD2), or alternatively we can make use of the EM algorithm.

Section 12.2.2

###### 12.1.2 Minimum-error formulation

We now discuss an alternative formulation of peA based on projection error minimization. To do this, we introduce a complete orthonormal set ofD-dimensional basis vectors {Ui} where i = 1, ... , D that satisfy

Appendix C

(12.7)

Because this basis is complete, each data point can be represented exactly by a linear combination of the basis vectors

D

(12.8)

X n = Laniui i=l

where the coefficients ani will be different for different data points. This simply corresponds to a rotation of the coordinate system to a new system defined by the {Ui}, and the original D components {Xnl' ... , XnD} are replaced by an equivalent set {anl' ... ,anD}. Taking the inner product with Uj, and making use of the orthonormality property, we obtain anj = x;Uj, and so without loss of generality we can write

D

Xn = L (X~Ui) Ui·

- (12.9)
- (12.10)


i=l

Our goal, however, is to approximate this data point using a representation involving a restricted number M < D of variables corresponding to a projection onto a lower-dimensional subspace. The M -dimensional linear subspace can be represented, without loss of generality, by the first M of the basis vectors, and so we approximate each data point X n by

M D

xn = L ZniUi + L biUi

i=l i=M+l
