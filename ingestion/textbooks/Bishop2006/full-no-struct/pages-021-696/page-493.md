[Page 493]

q µ ( µ ) in the form

$$
\mathbb { E } [ \mu ] = \overline { x } , \quad \mathbb { E } [ \mu ^ { 2 } ] = \overline { x } ^ { 2 } + \frac { 1 } { N \mathbb { E } [ \tau ] } .
$$

We can now substitute these moments into (10.31) and then solve for E [ τ ] Exercise 10.9

to give

# Section 1.2.4

$$
\frac { 1 } { \mathbb { E } [ \tau ] } \ & = \ \frac { 1 } { N - 1 } ( \overline { x ^ { 2 } } - \overline { x } ^ { 2 } ) \\ & = \ \frac { 1 } { N - 1 } \sum _ { n = 1 } ^ { N } ( x _ { n } - \overline { x } ) ^ { 2 } . \\ \intertext { c h e r g h i t h a n d s e } \ The right-hand side a s the f a m i l i a r u n b i a s e d e s t i m a t o r f e t h e v a r i a n c e
$$

We recognize the right-hand side as the familiar unbiased estimator for the variance of a univariate Gaussian distribution, and so we see that the use of a Bayesian approach has avoided the bias of the maximum likelihood solution.

Exercise 10.10

Exercise 10.11

# 10.1.4 Model comparison

As well as performing inference over the hidden variables Z , we may also wish to compare a set of candidate models, labelled by the index m , and having prior probabilities p ( m ) . Our goal is then to approximate the posterior probabilities p ( m | X ) , where X is the observed data. This is a slightly more complex situation than that considered so far because different models may have different structure and indeed different dimensionality for the hidden variables Z . We cannot therefore simply consider a factorized approximation q ( Z ) q ( m ) , but must instead recognize that the posterior over Z must be conditioned on m , and so we must consider q ( Z ,m ) = q ( Z | m ) q ( m ) . We can readily verify the following decomposition based on this variational distribution

$$
o n \text { this variational distribution} \\ \ln p ( X ) = \mathcal { C } _ { m } - \sum _ { m } \sum _ { Z } q ( Z | m ) q ( m ) \ln \left \{ \frac { p ( Z , m | X ) } { q ( Z | m ) q ( m ) } \right \} \\ \\ \text {where the } \mathcal { C } _ { m } \text { is a lower bound on } \ln p ( X ) \text { and is given by }
$$

where the L m is a lower bound on ln p ( X ) and is given by

$$
\L _ { m } = \sum _ { m } \sum _ { z } q ( Z | m ) q ( m ) \ln \left \{ \frac { p ( Z , X , m ) } { q ( Z | m ) q ( m ) } \right \} . \quad ( 1 0 . 3 5 ) \\ \text {we are assuming discrete} \, Z \text {, but the same analysis applies to continuous latent}
$$

Here we are assuming discrete Z , but the same analysis applies to continuous latent variables provided the summations are replaced with integrations. We can maximize L m with respect to the distribution q ( m ) using a Lagrange multiplier, with the result

$$
q ( m ) \, \infty \, p ( m ) \exp \{ \mathcal { L } _ { m } \} .
$$

However, if we maximize L m with respect to the q ( Z | m ) , we ﬁnd that the solutions for different m are coupled, as we expect because they are conditioned on m . We proceed instead by ﬁrst optimizing each of the q ( Z | m ) individually by optimization
