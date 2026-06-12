[Page 502]

Exercise 10.18

$$
\mathbb { F } \max & \inf [ N _ { k } \text { } ( m _ { k } - m _ { 0 } ) ^ { T } W _ { k } ( m _ { k } - m _ { 0 } ) \Big \} + K \ln B ( W _ { 0 } , \nu _ { 0 } ) \\ & + \frac { ( \nu _ { 0 } - D - 1 ) } { 2 } \sum _ { k = 1 } ^ { K } \ln \widetilde { \Lambda } _ { k } - \frac { 1 } { 2 } \sum _ { k = 1 } ^ { K } \nu _ { k } \text {Tr} ( W _ { 0 } ^ { - 1 } W _ { k } ) \\ & \mathbb { F } [ \ln \alpha ( Z ) ] - \sum _ { k = 1 } ^ { N } \sum _ { k = 1 } ^ { K } m _ { k } - m _ { 0 }
$$

$$
\mathbb { E } [ \ln q ( Z ) ] & = \sum _ { n = 1 } ^ { N } \sum _ { k = 1 } ^ { K } r _ { n k } \ln r _ { n k }
$$

$$
& \mathbb { N } ^ { 1 } \kappa = 1 \\ & \mathbb { E } [ \ln q ( \pi ) ] = \sum _ { k = 1 } ^ { K } ( \alpha _ { k } - 1 ) \ln \widetilde { \pi } _ { k } + \ln C ( \alpha ) \\ \\ \mathbb { E } [ \ln q ( \mu , \Lambda ) ] & = \sum _ { k = 1 } ^ { K } \left \{ \frac { 1 } { 2 } \ln \widetilde { \Lambda } _ { k } + \frac { D } { 2 } \ln \left ( \frac { \beta _ { k } } { 2 \pi } \right ) - \frac { D } { 2 } - H \left [ q ( \Lambda _ { k } ) \right ] \right \} \\
$$

$$
\mathbb { E } [ \ln q ( \mu , \Lambda ) ] \, = \, \sum _ { k = 1 } ^ { K } \left \{ \frac { 1 } { 2 } \ln \widetilde { \Lambda } _ { k } + \frac { D } { 2 } \ln \left ( \frac { \beta _ { k } } { 2 \pi } \right ) - \frac { D } { 2 } - H \left [ q ( \Lambda _ { k } ) \right ] \right \} \, ( 1 0 . 7 7 ) \\ \intertext { w h e r D i s t h e d i m e n s i o n a l i t y o f x , H [ q ( \Lambda _ { k } ) ] i s t h e t r o p y o f t h e W i s h art d i r b u - }
$$

where D is the dimensionality of x , H[ q ( Λ k )] is the entropy of the Wishart distribution given by (B.82), and the coefﬁcients C ( α ) and B ( W ,ν ) are deﬁned by (B.23) and (B.79), respectively. Note that the terms involving expectations of the logs of the q distributions simply represent the negative entropies of those distributions. Some simpliﬁcations and combination of terms can be performed when these expressions are summed to give the lower bound. However, we have kept the expressions separate for ease of understanding.

Finally, it is worth noting that the lower bound provides an alternative approach for deriving the variational re-estimation equations obtained in Section 10.2.1. To do this we use the fact that, since the model has conjugate priors, the functional form of the factors in the variational posterior distribution is known, namely discrete for Z , Dirichlet for π , and Gaussian-Wishart for ( µ k , Λ k ) . By taking general parametric forms for these distributions we can derive the form of the lower bound as a function of the parameters of the distributions. Maximizing the bound with respect to these parameters then gives the required re-estimation equations.

# 10.2.3 Predictive density

In applications of the Bayesian mixture of Gaussians model we will often be interested in the predictive density for a new value x of the observed variable. Associated with this observation will be a corresponding latent variable z , and the predictive density is then given by ( x X ) = ( x z Λ ) ( z ) ( Λ X )d d d Λ (10.78)

$$
\text {directive density is then given by} \\ p ( \widehat { x } | X ) = \sum _ { \widehat { z } } \iint p ( \widehat { x } | \widehat { z } , \mu , \Lambda ) p ( \widehat { z } | \pi ) p ( \pi , \mu , \Lambda | X ) \, d \pi \, d \mu \, d \Lambda \\
$$
