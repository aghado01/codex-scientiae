[Page 121]

Section 2.2

From (2.150), we see that the effect of observing N data points is to increase the value of the coefﬁcient a by N/ 2 . Thus we can interpret the parameter a 0 in the prior in terms of 2 a 0 ‘effective’ prior observations. Similarly, from (2.151) we see that the N data points contribute Nσ 2 ML / 2 to the parameter b , where σ 2 ML is the variance, and so we can interpret the parameter b 0 in the prior as arising from the 2 a 0 ‘effective’ prior observations having variance 2 b 0 / (2 a 0 ) = b 0 /a 0 . Recall that we made an analogous interpretation for the Dirichlet prior. These distributions are examples of the exponential family, and we shall see that the interpretation of a conjugate prior in terms of effective ﬁctitious data points is a general one for the exponential family of distributions.

Instead of working with the precision, we can consider the variance itself. The conjugate prior in this case is called the inverse gamma distribution, although we shall not discuss this further because we will ﬁnd it more convenient to work with the precision.

Now suppose that both the mean and the precision are unknown. To ﬁnd a conjugate prior, we consider the dependence of the likelihood function on µ and λ

$$
\text {conjugate prior, we consider the dependence of the likelihood function on } \mu \text { and } \lambda \\ p ( X | \mu , \lambda ) = \prod _ { n = 1 } ^ { N } \left ( \frac { \lambda } { 2 \pi } \right ) ^ { 1 / 2 } \exp \left \{ - \frac { \lambda } { 2 } ( x _ { n } - \mu ) ^ { 2 } \right \} \\ \infty \ \left [ \lambda ^ { 1 / 2 } \exp \left ( - \frac { \lambda \mu ^ { 2 } } { 2 } \right ) \right ] ^ { N } \exp \left \{ \lambda \mu \sum _ { n = 1 } ^ { N } x _ { n } - \frac { \lambda } { 2 } \sum _ { n = 1 } ^ { N } x _ { n } ^ { 2 } \right \} . \quad ( 2 . 1 5 2 ) \\ \text {We now wish to identify a prior distribution } p ( \mu , \lambda ) \text { that has the same functional }
$$

We now wish to identify a prior distribution p ( µ,λ ) that has the same functional dependence on µ and λ as the likelihood function and that should therefore take the form

$$
f o r \\ p ( \mu , \lambda ) \, \in \, \left [ \lambda ^ { 1 / 2 } \exp \left ( - \frac { \lambda \mu ^ { 2 } } { 2 } \right ) \right ] ^ { \beta } & \exp \{ c \lambda \mu - d \lambda \} \\ & = \, \exp \left \{ - \frac { \beta \lambda } { 2 } ( \mu - c / \beta ) ^ { 2 } \right \} \lambda ^ { \beta / 2 } \exp \left \{ - \left ( d - \frac { c ^ { 2 } } { 2 \beta } \right ) \lambda \right \} \quad ( 2 . 1 3 ) \\ \intertext { w h e c , d , and \beta a r e constants . $ Since $ we can always write p ( \mu , \lambda ) = p ( \mu | \lambda ) p ( \lambda ) , }
$$

where c , d , and β are constants. Since we can always write p ( µ,λ ) = p ( µ | λ ) p ( λ ) , we can ﬁnd p ( µ | λ ) and p ( λ ) by inspection. In particular, we see that p ( µ | λ ) is a Gaussian whose precision is a linear function of λ and that p ( λ ) is a gamma distribution, so that the normalized prior takes the form

$$
p ( \mu , \lambda ) = \mathcal { N } ( \mu | _ { 0 } , ( \beta \lambda ) ^ { - 1 } ) G a m ( \lambda | a , b ) \\ \\
$$
