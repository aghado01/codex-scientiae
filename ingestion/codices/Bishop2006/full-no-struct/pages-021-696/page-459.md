[Page 459]

# 3. M step . Re-estimate the parameters using the current responsibilities

$$
\mu _ { k } ^ { \text {new} } \, = \, \frac { 1 } { N _ { k } } \sum _ { n = 1 } ^ { N } \gamma ( z _ { n k } ) x _ { n } & & & \\ & & 1 \sum _ { n = 1 } ^ { N } \gamma ( z _ { n k } ) x _ { n }
$$

$$
\Sigma _ { k } ^ { \text {new} } \, = \, \frac { 1 } { N _ { k } } \sum _ { n = 1 } ^ { N } \gamma ( z _ { n k } ) \left ( x _ { n } - \mu _ { k } ^ { \text {new} } \right ) ( x _ { n } - \mu _ { k } ^ { \text {new} } ) ^ { T } \\ \pi ^ { \text {new} } \, = \, \frac { N _ { k } } { \pi ^ { k } } \, \Pi ^ { \text {new} } \, ( x _ { n } - \mu _ { k } ^ { \text {new} } ) \left ( x _ { n } - \mu _ { k } ^ { \text {new} } \right ) ^ { T } \\
$$

$$
\pi _ { k } ^ { \text {new} } \ = \ \frac { N _ { k } } { N }
$$

where

$$
N _ { k } = \sum _ { n = 1 } ^ { N } \gamma ( z _ { n k } ) .
$$

# 4. Evaluate the log likelihood

$$
4 . \, \text {Evaluate the log likelihood} \\ \ln p ( X | \mu , \Sigma , \pi ) = \sum _ { n = 1 } ^ { N } \ln \left \{ \sum _ { k = 1 } ^ { K } \pi _ { k } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) \right \} \\ \intertext { a n d c h e r s } \text {and check for convergence of either the parameters or the log likelihood. If }
$$

and check for convergence of either the parameters or the log likelihood. If the convergence criterion is not satisﬁed return to step 2.

# 9.3. An Alternative View of EM

In this section, we present a complementary view of the EM algorithm that recognizes the key role played by latent variables. We discuss this approach ﬁrst of all in an abstract setting, and then for illustration we consider once again the case of Gaussian mixtures.

The goal of the EM algorithm is to ﬁnd maximum likelihood solutions for models having latent variables. We denote the set of all observed data by X , in which the n th row represents x T n , and similarly we denote the set of all latent variables by Z , with a corresponding row z T n . The set of all model parameters is denoted by θ , and so the log likelihood function is given by

$$
\text {embed function is given by} \\ \ln p ( X | \theta ) = \ln \left \{ \sum _ { z } p ( X , Z | \theta ) \right \} . \\ \text {discussion will apply equally well to continuous latent variables simply}
$$

Note that our discussion will apply equally well to continuous latent variables simply by replacing the sum over Z with an integral.

A key observation is that the summation over the latent variables appears inside the logarithm. Even if the joint distribution p ( X , Z | θ ) belongs to the exponential
