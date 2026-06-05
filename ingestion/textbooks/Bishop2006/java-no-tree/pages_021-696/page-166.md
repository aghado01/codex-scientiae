[Page 166]

- Figure 3.4 Plot of the contours of the unregularized error function (blue) along with the constraint region (3.30) for the quadratic regularizer q = 2 on the left and the lasso regularizer q = 1 on the right, in which the optimum value for the parameter vector w is denoted by w . The lasso gives a sparse solution in which w 1 = 0.


###### w

|2|w|
|---|---|
| |w|


1

w

|2|w|
|---|---|
| |w|


1

For the remainder of this chapter we shall focus on the quadratic regularizer (3.27) both for its practical importance and its analytical tractability.

###### 3.1.5 Multiple outputs

So far, we have considered the case of a single target variable t. In some applications, we may wish to predict K > 1 target variables, which we denote collectively by the target vector t. This could be done by introducing a different set of basis functions for each component of t, leading to multiple, independent regression problems. However, a more interesting, and more common, approach is to use the same set of basis functions to model all of the components of the target vector so that

###### y(x,w) = WTφ(x) (3.31)

where y is a K-dimensional column vector, W is an M × K matrix of parameters, and φ(x) is an M-dimensional column vector with elements φj(x), with φ0(x) = 1 as before. Suppose we take the conditional distribution of the target vector to be an isotropic Gaussian of the form

p(t|x,W,β) = N(t|WTφ(x),β−1I). (3.32)

If we have a set of observations t1,...,tN, we can combine these into a matrix T of size N × K such that the nth row is given by tTn. Similarly, we can combine the input vectors x1,...,xN into a matrix X. The log likelihood function is then given by

lnp(T|X,W,β) =

=

N

lnN(tn|WTφ(xn),β−1I)

n=1

N

NK 2

β 2

β 2π −

tn − WTφ(xn) 2 . (3.33)

ln

n=1
