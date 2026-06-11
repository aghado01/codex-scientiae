[Page 212]

These covariance matrices have been deﬁned in the original x-space. We can now deﬁne similar matrices in the projected D�-dimensional y-space

�K

�

sW =

(yn − µk)(yn − µk)T (4.47)

n∈Ck

k=1

and

�K

sB =

Nk(µk − µ)(µk − µ)T (4.48)

k=1

where

�K

Nk � n∈Ck

1

1 N

µk =

yn, µ =

Nkµk. (4.49)

k=1

Again we wish to construct a scalar that is large when the between-class covariance is large and when the within-class covariance is small. There are now many possible choices of criterion (Fukunaga, 1990). One example is given by

�

�

s−1

J(W) = Tr

W sB

. (4.50)

This criterion can then be rewritten as an explicit function of the projection matrix W in the form

�

�

(WSWWT)−1(WSBWT)

J(w) = Tr

. (4.51)

Maximization of such criteria is straightforward, though somewhat involved, and is discussed at length in Fukunaga (1990). The weight values are determined by those eigenvectors of S−1

W SB that correspond to the D� largest eigenvalues.

There is one important result that is common to all such criteria, which is worth emphasizing. We ﬁrst note from (4.46) that SB is composed of the sum of K matrices, each of which is an outer product of two vectors and therefore of rank 1. In addition, only (K −1) of these matrices are independent as a result of the constraint (4.44). Thus, SB has rank at most equal to (K −1) and so there are at most (K − 1) nonzero eigenvalues. This shows that the projection onto the (K − 1)-dimensional subspace spanned by the eigenvectors of SB does not alter the value of J(w), and so we are therefore unable to ﬁnd more than (K − 1) linear ‘features’ by this means (Fukunaga, 1990).

4.1.7 The perceptron algorithm

Another example of a linear discriminant model is the perceptron of Rosenblatt (1962), which occupies an important place in the history of pattern recognition algorithms. It corresponds to a two-class model in which the input vector x is ﬁrst transformed using a ﬁxed nonlinear transformation to give a feature vector φ(x), and this is then used to construct a generalized linear model of the form

�

�

wTφ(x)

y(x) = f

(4.52)
