[Page 106]

$$
- \frac { 1 } { 2 } ( x - \mu ) ^ { T } \Sigma ^ { - 1 } ( x - \mu ) & = \\ - \frac { 1 } { 2 } ( x _ { a } - \mu _ { a } ) ^ { T } \Lambda _ { a a } ( x _ { a } - \mu _ { a } ) - \frac { 1 } { 2 } ( x _ { a } - \mu _ { a } ) ^ { T } \Lambda _ { a b } ( x _ { b } - \mu _ { b } ) \\ - \frac { 1 } { 2 } ( x _ { b } - \mu _ { b } ) ^ { T } \Lambda _ { b a } ( x _ { a } - \mu _ { a } ) - \frac { 1 } { 2 } ( x _ { b } - \mu _ { b } ) ^ { T } \Lambda _ { b b } ( x _ { b } - \mu _ { b } ) . \\ \text {We see that as a function of } x _ { \infty } \text { this is again a quadratic form, and hence the cor-}
$$

We see that as a function of x a , this is again a quadratic form, and hence the corresponding conditional distribution p ( x a | x b ) will be Gaussian. Because this distribution is completely characterized by its mean and its covariance, our goal will be to identify expressions for the mean and covariance of p ( x a | x b ) by inspection of (2.70).

This is an example of a rather common operation associated with Gaussian distributions, sometimes called ‘completing the square’, in which we are given a quadratic form deﬁning the exponent terms in a Gaussian distribution, and we need to determine the corresponding mean and covariance. Such problems can be solved straightforwardly by noting that the exponent in a general Gaussian distribution N ( x | µ , Σ ) can be written

$$
- \frac { 1 } { 2 } ( x - \mu ) ^ { T } \Sigma ^ { - 1 } ( x - \mu ) = - \frac { 1 } { 2 } x ^ { T } \Sigma ^ { - 1 } x + x ^ { T } \Sigma ^ { - 1 } \mu + \text {const} \quad ( 2 . 7 1 )
$$

where ‘const’ denotes terms which are independent of x , and we have made use of the symmetry of Σ . Thus if we take our general quadratic form and express it in the form given by the right-hand side of (2.71), then we can immediately equate the matrix of coefﬁcients entering the second order term in x to the inverse covariance matrix Σ − 1 and the coefﬁcient of the linear term in x to Σ − 1 µ , from which we can obtain µ .

Now let us apply this procedure to the conditional Gaussian distribution p ( x a | x b ) for which the quadratic form in the exponent is given by (2.70). We will denote the mean and covariance of this distribution by µ a | b and Σ a | b , respectively. Consider the functional dependence of (2.70) on x a in which x b is regarded as a constant. If we pick out all terms that are second order in x a , we have

$$
- \frac { 1 } { 2 } x _ { a } ^ { \mathrm T } \Lambda _ { a a } x _ { a }
$$

from which we can immediately conclude that the covariance (inverse precision) of p ( x a | x b ) is given by Σ a | b = Λ − 1 aa . (2.73)

$$
\Sigma _ { a | b } = \Lambda _ { a a } ^ { - 1 } .
$$
