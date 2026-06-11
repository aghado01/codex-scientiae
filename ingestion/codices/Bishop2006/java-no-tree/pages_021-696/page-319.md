[Page 319]

This is the covariance matrix of the Fisher scores, and so the Fisher kernel corre-

Section 12.1.3 sponds to a whitening of these scores. More simply, we can just omit the Fisher information matrix altogether and use the noninvariant kernel

k(x,x ) = g(θ,x)Tg(θ,x ). (6.36) An application of Fisher kernels to document retrieval is given by Hofmann (2000).

A ﬁnal example of a kernel function is the sigmoidal kernel given by

###### k(x,x ) = tanh axTx + b (6.37)

whose Gram matrix in general is not positive semideﬁnite. This form of kernel has, however, been used in practice (Vapnik, 1995), possibly because it gives kernel expansions such as the support vector machine a superﬁcial resemblance to neural network models. As we shall see, in the limit of an inﬁnite number of basis functions, a Bayesian neural network with an appropriate prior reduces to a Gaussian process,

Section 6.4.7 thereby providing a deeper link between neural networks and kernel methods.

###### 6.3. Radial Basis Function Networks

In Chapter 3, we discussed regression models based on linear combinations of ﬁxed basis functions, although we did not discuss in detail what form those basis functions might take. One choice that has been widely used is that of radial basis functions, which have the property that each basis function depends only on the radial distance (typically Euclidean) from a centre µj, so that φj(x) = h( x − µj ).

Historically, radial basis functions were introduced for the purpose of exact function interpolation (Powell, 1987). Given a set of input vectors {x1,...,xN} along with corresponding target values {t1,...,tN}, the goal is to ﬁnd a smooth function f(x) that ﬁts every target value exactly, so that f(xn) = tn for n = 1,...,N. This is achieved by expressing f(x) as a linear combination of radial basis functions, one centred on every data point

f(x) =

N

wnh( x − xn ). (6.38)

n=1

The values of the coefﬁcients {wn} are found by least squares, and because there are the same number of coefﬁcients as there are constraints, the result is a function that ﬁts every target value exactly. In pattern recognition applications, however, the target values are generally noisy, and exact interpolation is undesirable because this corresponds to an over-ﬁtted solution.

Expansions in radial basis functions also arise from regularization theory (Poggio and Girosi, 1990; Bishop, 1995a). For a sum-of-squares error function with a regularizer deﬁned in terms of a differential operator, the optimal solution is given by an expansion in the Green’s functions of the operator (which are analogous to the eigenvectors of a discrete matrix), again with one basis function centred on each data
