[Page 335]

predictive distribution is given by

p(tN+1 = 1|tN) = � p(tN+1 = 1|aN+1)p(aN+1|tN)daN+1 (6.76) where p(tN+1 = 1|aN+1) = σ(aN+1).

This integral is analytically intractable, and so may be approximated using sampling methods (Neal, 1997). Alternatively, we can consider techniques based on an analytical approximation. In Section 4.5.2, we derived the approximate formula (4.153) for the convolution of a logistic sigmoid with a Gaussian distribution. We can use this result to evaluate the integral in (6.76) provided we have a Gaussian approximation to the posterior distribution p(aN+1|tN). The usual justiﬁcation for a Gaussian approximation to a posterior distribution is that the true posterior will tend to a Gaussian as the number of data points increases as a consequence of the central

Section 2.3 limit theorem. In the case of Gaussian processes, the number of variables grows with the number of data points, and so this argument does not apply directly. However, if we consider increasing the number of data points falling in a ﬁxed region of x space, then the corresponding uncertainty in the function a(x) will decrease, again leading asymptotically to a Gaussian (Williams and Barber, 1998).

Three different approaches to obtaining a Gaussian approximation have been

Section 10.1 considered. One technique is based on variational inference (Gibbs and MacKay, 2000) and makes use of the local variational bound (10.144) on the logistic sigmoid. This allows the product of sigmoid functions to be approximated by a product of Gaussians thereby allowing the marginalization over aN to be performed analytically. The approach also yields a lower bound on the likelihood function p(tN|θ). The variational framework for Gaussian process classiﬁcation can also be extended to multiclass (K > 2) problems by using a Gaussian approximation to the softmax function (Gibbs, 1997).

Section 10.7 A second approach uses expectation propagation (Opper and Winther, 2000b; Minka, 2001b; Seeger, 2003). Because the true posterior distribution is unimodal, as we shall see shortly, the expectation propagation approach can give good results.

6.4.6 Laplace approximation

The third approach to Gaussian process classiﬁcation is based on the Laplace

Section 4.4 approximation, which we now consider in detail. In order to evaluate the predictive distribution (6.76), we seek a Gaussian approximation to the posterior distribution over aN+1, which, using Bayes’ theorem, is given by

p(aN+1|tN) = � p(aN+1,aN|tN)daN

� p(aN+1,aN)p(tN|aN+1,aN)daN

1 p(tN)

=

� p(aN+1|aN)p(aN)p(tN|aN)daN

1 p(tN)

=

= � p(aN+1|aN)p(aN|tN)daN (6.77)
