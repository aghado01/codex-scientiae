[Page 335]

Section 10.1

Section 10.7

Section 4.4

predictive distribution is given by

$$
\text {predictive distribution is given by} \\ p ( t _ { N + 1 } = 1 | \mathfrak { t } _ { N } ) = \int p ( t _ { N + 1 } = 1 | a _ { N + 1 } ) p ( a _ { N + 1 } | \mathfrak { t } _ { N } ) \, d a _ { N + 1 } \\ \\ \text {where } p ( t _ { N + 1 } = 1 | a _ { N + 1 } ) = \sigma ( a _ { N + 1 } ) ,
$$

where p ( t N +1 = 1 | a N +1 ) = σ ( a N +1 ) . This integral is analytically intractable,

and so may be approximated using sampling methods (Neal, 1997). Alternatively, we can consider techniques based on an analytical approximation. In Section 4.5.2, we derived the approximate formula (4.153) for the convolution of a logistic sigmoid with a Gaussian distribution. We can use this result to evaluate the integral in (6.76) provided we have a Gaussian approximation to the posterior distribution p ( a N +1 | t N ) . The usual justiﬁcation for a Gaussian approximation to a posterior distribution is that the true posterior will tend to a Gaussian as the number of data points increases as a consequence of the central limit theorem. In the case of Gaussian processes, the number of variables grows with the number of data points, and so this argument does not apply directly. However, if we consider increasing the number of data points falling in a ﬁxed region of x space, then the corresponding uncertainty in the function a ( x ) will decrease, again leading asymptotically to a Gaussian (Williams and Barber, 1998).

Three different approaches to obtaining a Gaussian approximation have been considered. One technique is based on variational inference (Gibbs and MacKay, 2000) and makes use of the local variational bound (10.144) on the logistic sigmoid. This allows the product of sigmoid functions to be approximated by a product of Gaussians thereby allowing the marginalization over a N to be performed analytically. The approach also yields a lower bound on the likelihood function p ( t N | θ ) . The variational framework for Gaussian process classiﬁcation can also be extended to multiclass ( K > 2 ) problems by using a Gaussian approximation to the softmax function (Gibbs, 1997).

A second approach uses expectation propagation (Opper and Winther, 2000b; Minka, 2001b; Seeger, 2003). Because the true posterior distribution is unimodal, as we shall see shortly, the expectation propagation approach can give good results.

# 6.4.6 Laplace approximation

The third approach to Gaussian process classiﬁcation is based on the Laplace approximation, which we now consider in detail. In order to evaluate the predictive distribution (6.76), we seek a Gaussian approximation to the posterior distribution over a N +1 , which, using Bayes’ theorem, is given by

$$
d i t b u n & \, ( 6 . 7 6 ) , \, w e e k \, a \, Gaussian \, a p r o x i m a t i o n \, t o \, the p o s t e r i o n \, d i t b u n \\ \, o v e \, a _ { N + 1 } , \, \text { which, using Bayes' theorem, is given by} \\ & \quad p ( a _ { N + 1 } | \mathfrak { t } _ { N } ) \ = \ \int p ( a _ { N + 1 } , a _ { N } | \mathfrak { t } _ { N } ) \, d a _ { N } \\ & \quad = \ \frac { 1 } { p ( \mathfrak { t } _ { N } ) } \int p ( a _ { N + 1 } , a _ { N } ) p ( \mathfrak { t } _ { N } | a _ { N + 1 } , a _ { N } ) \, d a _ { N } \\ & \quad = \ \frac { 1 } { p ( \mathfrak { t } _ { N } ) } \int p ( a _ { N + 1 } | a _ { N } ) p ( a _ { N } ) p ( \mathfrak { t } _ { N } | a _ { N } ) \, d a _ { N } \\ & \quad = \ \int p ( a _ { N + 1 } | a _ { N } ) p ( a _ { N } | \mathfrak { t } _ { N } ) \, d a _ { N }
$$
