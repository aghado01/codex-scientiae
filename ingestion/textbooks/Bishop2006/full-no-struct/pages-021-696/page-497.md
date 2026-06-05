[Page 497]

where

$$
r _ { n k } = \frac { \rho _ { n k } } { K } . & & ( 1 0 . 4 9 ) \\ \sum _ { j = 1 } ^ { K } \rho _ { n j } & & \\ \sum _ { j = 1 } ^ { 2 }
$$

We see that the optimal solution for the factor q ( Z ) takes the same functional form as the prior p ( Z | π ) . Note that because ρ nk is given by the exponential of a real quantity, the quantities r nk will be nonnegative and will sum to one, as required. For the discrete distribution ( Z ) we have the standard result

For the discrete distribution q /star ( Z ) we have the standard result

$$
\mathbb { E } [ z _ { n k } ] = r _ { n k }
$$

from which we see that the quantities r nk are playing the role of responsibilities. Note that the optimal solution for q ( Z ) depends on moments evaluated with respect to the distributions of other variables, and so again the variational update equations are coupled and must be solved iteratively.

At this point, we shall ﬁnd it convenient to deﬁne three statistics of the observed data set evaluated with respect to the responsibilities, given by

$$
N _ { k } \ = \ \sum _ { n = 1 } ^ { N } r _ { n k } & & ( 1 0 . 5 1 )
$$

$$
\bar { x } _ { k } \ = \ \frac { 1 } { N _ { k } } \sum _ { n = 1 } ^ { N } r _ { n k } x _ { n } & & ( 1 0 . 5 2 ) \\
$$

$$
S _ { k } \ = \ \frac { 1 } { N _ { k } } \sum _ { n = 1 } ^ { N } r _ { n k } ( x _ { n } - \bar { x } _ { k } ) ( x _ { n } - \bar { x } _ { k } ) ^ { T } . \\ \intertext { t h e s e a n a l o g o u s t o q u n t i o n s e v a l u d e i n t i o n the maximum l i k e l h i o o d E M }
$$

Note that these are analogous to quantities evaluated in the maximum likelihood EM algorithm for the Gaussian mixture model.

Now let us consider the factor q ( π , µ , Λ ) in the variational posterior distribution. Again using the general result (10.9) we have

$$
\text {.} \text { Again using the general result (10.9) we have} \\ \ln q ^ { * } ( \pi , \mu , \Lambda ) = \ln p ( \pi ) + \sum _ { k = 1 } ^ { K } \ln p ( \mu _ { k } , \Lambda _ { k } ) + \mathbb { E } _ { Z } \left [ \ln p ( Z | \pi ) \right ] \\ + \sum _ { k = 1 } ^ { K } \sum _ { n = 1 } ^ { N } \mathbb { E } [ z _ { n k } ] \ln \mathcal { N } \left ( x _ { n } | \mu _ { k } , \Lambda _ { k } ^ { - 1 } \right ) + \text {const.} \quad ( 1 0 . 5 4 ) \\ \text {observe that the right-hand side of this expression decomposes into a sum of} \\ \text {ns involying only } \pi \text { together with terms only involying } \mu \text { and } \Lambda \text { which implies}
$$

We observe that the right-hand side of this expression decomposes into a sum of terms involving only π together with terms only involving µ and Λ , which implies that the variational posterior q ( π , µ , Λ ) factorizes to give q ( π ) q ( µ , Λ ) . Furthermore, the terms involving µ and Λ themselves comprise a sum over k of terms involving µ k and Λ k leading to the further factorization

$$
q ( \pi , \mu , \Lambda ) = q ( \pi ) \prod _ { k = 1 } ^ { K } q ( \mu _ { k } , \Lambda _ { k } ) .
$$
