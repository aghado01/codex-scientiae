[Page 548]

$$
y _ { 1 } \ = \ z _ { 1 } \left ( \frac { - 2 \ln z _ { 1 } } { r ^ { 2 } } \right ) ^ { 1 / 2 } & & ( 1 1 . 1 0 ) \\
$$

$$
y _ { 2 } \ = \ z _ { 2 } \left ( \frac { - 2 \ln z _ { 2 } } { r ^ { 2 } } \right ) ^ { 1 / 2 } & & ( 1 1 . 1 1 ) \\
$$

where r 2 = z 2 1 + z 2 2 . Then the joint distribution of y 1 and y 2 Exercise 11.4

is given by

$$
\text {where } r ^ { 2 } & = z _ { 1 } ^ { 2 } + z _ { 2 } ^ { 2 } . \text { Then the joint distribution of } y _ { 1 } \text { and } y _ { 2 } \text { is given by } \\ & \quad p ( y _ { 1 } , y _ { 2 } ) \ = \ p ( z _ { 1 } , z _ { 2 } ) \left | \frac { \partial ( z _ { 1 } , z _ { 2 } ) } { \partial ( y _ { 1 } , y _ { 2 } ) } \right | \\ & = \ \left [ \frac { 1 } { \sqrt { 2 \pi } } \exp ( - y _ { 1 } ^ { 2 } / 2 ) \right ] \left [ \frac { 1 } { \sqrt { 2 \pi } } \exp ( - y _ { 2 } ^ { 2 } / 2 ) \right ] \quad ( 1 1 . 1 2 ) \\ \text {and so } y _ { 1 } \text { and } y _ { 2 } \text { are independent and each has a Gaussian distribution with zero }
$$

and so y 1 and y 2 are independent and each has a Gaussian distribution with zero mean and unit variance.

If y has a Gaussian distribution with zero mean and unit variance, then σy + µ will have a Gaussian distribution with mean µ and variance σ 2 . To generate vectorvalued variables having a multivariate Gaussian distribution with mean µ and covariance Σ , we can make use of the Cholesky decomposition , which takes the form Σ = LL T (Press et al. , 1992). Then, if z is a vector valued random variable whose components are independent and Gaussian distributed with zero mean and unit variance, then y = µ + Lz will have mean µ and covariance Σ .

Exercise 11.5

Obviously, the transformation technique depends for its success on the ability to calculate and then invert the indeﬁnite integral of the required distribution. Such operations will only be feasible for a limited number of simple distributions, and so we must turn to alternative approaches in search of a more general strategy. Here we consider two techniques called rejection sampling and importance sampling . Although mainly limited to univariate distributions and thus not directly applicable to complex problems in many dimensions, they do form important components in more general strategies.

# 11.1.2 Rejection sampling

The rejection sampling framework allows us to sample from relatively complex distributions, subject to certain constraints. We begin by considering univariate distributions and discuss the extension to multiple dimensions subsequently.

Suppose we wish to sample from a distribution p ( z ) that is not one of the simple, standard distributions considered so far, and that sampling directly from p ( z ) is difﬁcult. Furthermore suppose, as is often the case, that we are easily able to evaluate p ( z ) for any given value of z , up to some normalizing constant Z , so that

$$
p ( z ) & = \frac { 1 } { Z _ { p } } \widetilde { p } ( z ) & ( 1 1 . 1 3 ) \\ \intertext { e v a l uated, $ b u t $ Z _ { p } $ is unknown. } $ \text {section sampling, $ we need some simpler distribution $ q(z)$} ,
$$
