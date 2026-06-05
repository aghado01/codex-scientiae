[Page 608]

![image 145](../../../../../images/imageFile145.png)

588 12. CONTINUOUS LATENT VARIABLES

Substituting this expansion back into the eigenvector equation, we obtain

1 N N N

(12.77)

N L ¢(xn)¢(xn)T L aim¢(Xm) = Ai L ain¢(Xn), n=l m=l n=l

The key step is now to express this in terms of the kernel function k(xn ,xm ) = ¢(Xn)T¢(xm ), which we do by multiplying both sides by ¢(xZ)T to give

1 N m N

(12.78)

N Lk(XI'Xn) L aimk(Xn,xm) = Ai Laink(XI'Xn), n=l m=l n=l

This can be written in matrix notation as

(12.79)

where ai is an N-dimensional column vector with elements ani for n = 1, ... ,N. We can find solutions for ai by solving the following eigenvalue problem

(12.80)

in which we have removed a factor of K from both sides of (12.79). Note that the solutions of (12.79) and (12.80) differ only by eigenvectors of K having zero eigenvalues that do not affect the principal components projection.

Exercise 12.26

The normalization condition for the coefficients ai is obtained by requiring that the eigenvectors in feature space be normalized. Using (12.76) and (12.80), we have

N N

1= V;Vi =L L ainaim¢(xn)T¢(xm)= a;K~ = AiNa;ai' (12.81)

n=l m=l

Having solved the eigenvector problem, the resulting principal component projections can then also be cast in terms of the kernel function so that, using (12.76), the projection of a point x onto eigenvector i is given by

N N

Yi(X) = ¢(x)TVi =L ain¢(x)T¢(xn)=L aink(X,xn) (12.82)

n=l n=l

and so again is expressed in terms of the kernel function.

In the original D-dimensional x space there are D orthogonal eigenvectors and hence we can find at most D linear principal components. The dimensionality M of the feature space, however, can be much larger than D (even infinite), and thus we can find a number of nonlinear principal components that can exceed D. Note, however, that the number of nonzero eigenvalues cannot exceed the number N of data points, because (even if M > N) the covariance matrix in feature space has rank at most equal to N. This is reflected in the fact that kernel PCA involves the eigenvector expansion of the N x N matrix K.
