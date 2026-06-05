[Page 328]

3

1.5

(1.00,4.00,0.00,0.00)

9

4.5

(9.00, 4.00,0.00, 0.00)

3

1.5

(1.00, 64.00, 0.00, 0.00)

0

−1.5

0

−4.5

0

−1.5

−3

−1 −0.5 0 0.5 1

(1.00,0.25,0.00,0.00)

3

1.5

−9

−1 −0.5 0 0.5 1

9

(1.00, 4.00,10.00, 0.00)

4.5

−3

−1 −0.5 0 0.5 1

(1.00, 4.00, 0.00, 5.00)

4

2

0

0

0

−1.5

−4.5

−2

−3

−1 −0.5 0 0.5 1

−9

−1 −0.5 0 0.5 1

−4

−1 −0.5 0 0.5 1

Figure 6.5 Samples from a Gaussian process prior deﬁned by the covariance function (6.63). The title above each plot denotes (θ0, θ1, θ2, θ3).

c = k(xN+1,xN+1)+β−1. Using the results (2.81) and (2.82), we see that the conditional distribution p(tN+1|t) is a Gaussian distribution with mean and covariance given by

m(xN+1) = kTC−1

N t (6.66) σ2(xN+1) = c − kTC−1

N k. (6.67)

These are the key results that deﬁne Gaussian process regression. Because the vector k is a function of the test point input value xN+1, we see that the predictive distribution is a Gaussian whose mean and variance both depend on xN+1. An example of Gaussian process regression is shown in Figure 6.8.

The only restriction on the kernel function is that the covariance matrix given by (6.62) must be positive deﬁnite. If λi is an eigenvalue of K, then the corresponding eigenvalue of C will be λi + β−1. It is therefore sufﬁcient that the kernel matrix k(xn,xm) be positive semideﬁnite for any pair of points xn and xm, so that λi � 0, because any eigenvalue λi that is zero will still give rise to a positive eigenvalue for C because β > 0. This is the same restriction on the kernel function discussed earlier, and so we can again exploit all of the techniques in Section 6.2 to construct
