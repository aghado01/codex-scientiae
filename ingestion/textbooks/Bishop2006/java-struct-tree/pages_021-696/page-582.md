[Page 582]

![image 119](../../../../../images/imageFile119.png)

562 12. CONTINUOUS LATENT VARIABLES

chapter, we shall consider techniques to determine an appropriate value of IV! from the data.

To begin with, consider the projection onto a one-dimensional space (M = 1). We can define the direction of this space using a D-dimensional vector Ul, which for convenience (and without loss of generality) we shall choose to be a unit vector so that ufUl = 1 (note that we are only interested in the direction defined by Ul, not in the magnitude of Ul itself). Each data point X n is then projected onto a scalar value ufX n . The mean of the projected data is ufx where x is the sample set mean given by

(12.1)

and the variance of the projected data is given by

(12.2)

where S is the data covariance matrix defined by

1 N

S = -NLJ"(xn - x)(xn - x)T.

(12.3)

n=l

We now maximize the projected variance UfSUl with respect to Ul. Clearly, this has

to be a constrained maximization to prevent Ilulll ..... 00. The appropriate constraint

comes from the normalization condition ufUl = 1. To enforce this constraint, we introduce a Lagrange multiplier that we shall denote by AI, and then make an unconstrained maximization of

Appendix E

(12.4)

By setting the derivative with respect to Ul equal to zero, we see that this quantity will have a stationary point when

(12.5)

which says that Ul must be an eigenvector of S. If we left-multiply by uf and make use of ufUl = 1, we see that the variance is given by

(12.6)

and so the variance will be a maximum when we set Ul equal to the eigenvector having the largest eigenvalue AI. This eigenvector is known as the first principal component.

We can define additional principal components in an incremental fashion by choosing each new direction to be that which maximizes the projected variance
