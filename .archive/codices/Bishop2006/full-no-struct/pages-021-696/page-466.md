[Page 466]

variable z associated with each instance of x . As in the case of the Gaussian mixture, z = ( z 1 ,...,z K ) T is a binary K -dimensional variable having a single component equal to 1 , with all other components equal to 0 . We can then write the conditional distribution of x , given the latent variable, as

$$
p ( x | z , \mu ) = \prod _ { k = 1 } ^ { K } p ( x | \mu _ { k } ) ^ { z _ { k } } \\ \intertext { t i r b u t i o n for the l a t e n t v a r i b l a s i s t h e a s for the m i t u r e of }
$$

while the prior distribution for the latent variables is the same as for the mixture of Gaussians model, so that K

$$
p ( z | \pi ) = \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { k } } . \\ \intertext { f o r } p ( x | z , \mu ) \text { and } p ( z | \pi ) \text { and then marginalize over } z , \text { then we }
$$

If we form the product of p ( x | z , µ ) and p ( z | π ) and then marginalize over z , then we recover (9.47).

In order to derive the EM algorithm, we ﬁrst write down the complete-data log likelihood function, which is given by

$$
\text {hood function, which is given by} \\ \ln p ( X , Z | \mu , \pi ) = \sum _ { n = 1 } ^ { N } \sum _ { k = 1 } ^ { K } z _ { n k } \left \{ \ln \pi _ { k } \\ \\ + \sum _ { i = 1 } ^ { D } \left [ x _ { n i } \ln \mu _ { k i } + ( 1 - x _ { n i } ) \ln ( 1 - \mu _ { k i } ) \right ] \right \} \\ \text {e} X = \{ x _ { n } \} \text { and } Z = \{ z _ { n } \} . \text { Next we take the expectation of the complete-data}
$$

where X = { x n } and Z = { z n } . Next we take the expectation of the complete-data log likelihood with respect to the posterior distribution of the latent variables to give

$$
\ k e l h o o d \text { with respect to the posterior distribution of the latent variables to give } \\ \mathbb { E } _ { z } [ \ln p ( X , Z | \mu , \pi ) ] = \sum _ { n = 1 } ^ { N } \sum _ { k = 1 } ^ { K } \gamma ( z _ { n k } ) \left \{ \ln \pi _ { k } \\ D \\ + \sum _ { i = 1 } ^ { D } \left [ x _ { n i } \ln \mu _ { k i } + ( 1 - x _ { n i } ) \ln ( 1 - \mu _ { k i } ) \right ] \right \} \\ \tau \gamma ( z _ { n k } ) = \mathbb { E } [ z _ { n k } ] \text { is the posterior probability, or responsibility, of component } \\ \intertext { e q ( z _ { n k } ) = \mathbb { E } [ z _ { n k } ] \text { is the posterior probability, or responsibility, of component } } \intertext { a n d. note: point $n$ in the $E$ t h e $e r $ the $z$-norm's eigenvalues are evaluated using $R$ v e $}
$$

where γ ( z nk ) = E [ z nk ] is the posterior probability, or responsibility, of component k given data point x n . In the E step, these responsibilities are evaluated using Bayes’ theorem, which takes the form

$$
\text {en data point } x _ { n } . \text { In the E step, these responsiblities are evaluated using Bayes} \\ \text {em, which takes the form} & & \sum _ { \substack { z _ { n k } \\ z _ { n k } } } z _ { n k } \left [ \pi _ { k } p ( x _ { n } | \mu _ { k } ) \right ] ^ { z _ { n k } } \\ & & \gamma ( z _ { n k } ) = \mathbb { E } [ z _ { n k } ] \quad = \quad \frac { z _ { n k } } { \sum _ { \substack { \left [ \pi _ { j } p ( x _ { n } | \mu _ { j } ) \right ] ^ { z _ { n j } } } } \\ & & = \quad \frac { \pi _ { k } p ( x _ { n } | \mu _ { k } ) } { K } . \\ & & \sum _ { j = 1 } ^ { K } \pi _ { j } p ( x _ { n } | \mu _ { j } )
$$
