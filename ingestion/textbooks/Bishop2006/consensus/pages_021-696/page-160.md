[Page 160]

1

- 0.75
- 1


1

| |
|---|


| |
|---|


| |
|---|


0.5

0.75

0

0.5

0.5

−0.5

0.25

0.25

−1

0

0

−1 0 1

−1

0 1

−1

0 1

Figure 3.1 Examples of basis functions, showing polynomials on the left, Gaussians of the form (3.4) in the centre, and sigmoidal of the form (3.5) on the right.

on a regular lattice, such as the successive time points in a temporal sequence, or the pixels in an image. Useful texts on wavelets include Ogden (1997), Mallat (1999), and Vidakovic (1999).

Most of the discussion in this chapter, however, is independent of the particular choice of basis function set, and so for most of our discussion we shall not specify the particular form of the basis functions, except for the purposes of numerical illustration. Indeed, much of our discussion will be equally applicable to the situation in which the vector φ(x) of basis functions is simply the identity φ(x) = x. Furthermore, in order to keep the notation simple, we shall focus on the case of a single target variable t. However, in Section 3.1.5, we consider brieﬂy the modiﬁcations needed to deal with multiple target variables.

###### 3.1.1 Maximum likelihood and least squares

In Chapter 1, we ﬁtted polynomial functions to data sets by minimizing a sumof-squares error function. We also showed that this error function could be motivated as the maximum likelihood solution under an assumed Gaussian noise model. Let us return to this discussion and consider the least squares approach, and its relation to maximum likelihood, in more detail.

As before, we assume that the target variable t is given by a deterministic function y(x,w) with additive Gaussian noise so that

###### t = y(x,w) + (3.7)

where is a zero mean Gaussian random variable with precision (inverse variance) β. Thus we can write

p(t|x,w,β) = N(t|y(x,w),β−1). (3.8)

Recall that, if we assume a squared loss function, then the optimal prediction, for a Section 1.5.5 new value of x, will be given by the conditional mean of the target variable. In the

case of a Gaussian conditional distribution of the form (3.8), the conditional mean
