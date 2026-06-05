[Page 496]

Exercise 10.12

We now consider a variational distribution which factorizes between the latent variables and the parameters so that

$$
q ( Z , \pi , \mu , \Lambda ) = q ( Z ) q ( \pi , \mu , \Lambda ) .
$$

It is remarkable that this is the only assumption that we need to make in order to obtain a tractable practical solution to our Bayesian mixture model. In particular, the functional form of the factors q ( Z ) and q ( π , µ , Λ ) will be determined automatically by optimization of the variational distribution. Note that we are omitting the subscripts on the q distributions, much as we do with the p distributions in (10.41), and are relying on the arguments to distinguish the different distributions.

The corresponding sequential update equations for these factors can be easily derived by making use of the general result (10.9). Let us consider the derivation of the update equation for the factor q ( Z ) . The log of the optimized factor is given by

$$
\ln q ^ { * } ( Z ) = \mathbb { E } _ { \pi , \mu , \Lambda } [ \ln p ( X , Z , \pi , \mu , \Lambda ) ] + \text {const} .
$$

We now make use of the decomposition (10.41). Note that we are only interested in the functional dependence of the right-hand side on the variable Z . Thus any terms that do not depend on Z can be absorbed into the additive normalization constant, giving

$$
\ln q ^ { * } ( Z ) = \mathbb { E } _ { \pi } [ \ln p ( Z | \pi ) ] + \mathbb { E } _ { \mu , \Lambda } [ \ln p ( X | Z , \mu , \Lambda ) ] + \text {const.} \\
$$

Substituting for the two conditional distributions on the right-hand side, and again absorbing any terms that are independent of Z into the additive constant, we have

$$
\ln q ^ { * } ( Z ) = \sum _ { n = 1 } ^ { N } \sum _ { k = 1 } ^ { K } z _ { n k } \ln \rho _ { n k } + \text {const} \quad ( 1 0 . 4 5 )
$$

where we have deﬁned

$$
\ln \rho _ { n k } \ = \ & \mathbb { E } [ \ln \pi _ { k } ] + \frac { 1 } { 2 } \mathbb { E } \left [ \ln | \Lambda _ { k } | \right ] - \frac { D } { 2 } \ln ( 2 \pi ) \\ & - \frac { 1 } { 2 } \mathbb { E } _ { \mu _ { k } , \Lambda _ { k } } \left [ ( x _ { n } - \mu _ { k } ) ^ { T } \Lambda _ { k } ( x _ { n } - \mu _ { k } ) \right ] \\ \intertext { s e r $ D $ i s the dimensionality of the data variable x . $ T a k i n g t h e x p o n e n t i o n $ f o r $ both }
$$

where D is the dimensionality of the data variable x . Taking the exponential of both sides of (10.45) we obtain

$$
q ^ { * } ( Z ) \infty \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \rho _ { n k } ^ { z _ { n k } } .
$$

Requiring that this distribution be normalized, and noting that for each value of n the quantities z nk are binary and sum to 1 over all values of k , we obtain

$$
q ^ { * } ( Z ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } r _ { n k } ^ { z _ { n k } }
$$
