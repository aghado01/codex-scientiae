[Page 528]

1

40

0.8

0.6

0.4

0.2

30

20

10

0

−2 −1 0 1 2 3 4

0

−2 −1 0 1 2 3 4

Figure 10.14 Illustration of the expectation propagation approximation using a Gaussian distribution for the example considered earlier in Figures 4.14 and 10.1. The left-hand plot shows the original distribution (yellow) along with the Laplace (red), global variational (green), and EP (blue) approximations, and the right-hand plot shows the corresponding negative logarithms of the distributions. Note that the EP distribution is broader than that variational inference, as a consequence of the different form of KL divergence.

where Zj is the normalization constant given by

Zj = � fj(θ)q\j(θ)dθ. (10.197)

We now determine a revised factor f�j(θ) by minimizing the Kullback-Leibler divergence

� � � �qnew(θ)�. (10.198)

KL�

fj(θ)q\j(θ) Zj

This is easily solved because the approximating distribution qnew(θ) is from the exponential family, and so we can appeal to the result (10.187), which tells us that the parameters of qnew(θ) are obtained by matching its expected sufﬁcient statistics to the corresponding moments of (10.196). We shall assume that this is a tractable operation. For example, if we choose q(θ) to be a Gaussian distribution N(θ|µ,Σ), then µ is set equal to the mean of the (unnormalized) distribution fj(θ)q\j(θ), and Σ is set to its covariance. More generally, it is straightforward to obtain the required expectations for any member of the exponential family, provided it can be normalized, because the expected statistics can be related to the derivatives of the normalization coefﬁcient, as given by (2.226). The EP approximation is illustrated in Figure 10.14.

From (10.193), we see that the revised factor f�j(θ) can be found by taking qnew(θ) and dividing out the remaining factors so that

qnew(θ) q\j(θ)

f�j(θ) = K

(10.199)

where we have used (10.195). The coefﬁcient K is determined by multiplying both
