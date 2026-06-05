[Page 488]

Figure 10.2 Comparison of the two alternative forms for the Kullback-Leibler divergence. The green contours corresponding to 1, 2, and 3 standard deviations for a correlated Gaussian distribution p ( z ) over two variables z 1 and z 2 , and the red contours represent the corresponding levels for an approximating distribution q ( z ) over the same variables given by the product of two independent univariate Gaussian distributions whose parameters are obtained by minimization of (a) the KullbackLeibler divergence KL( q p ) , and (b) the reverse Kullback-Leibler divergence KL( p q ) .

![image 233](../images/imageFile233.png)

1

z

2

0.5

0

z

0

0.5

1

1

(a)

![image 234](../images/imageFile234.png)

1

z

2

0.5

0

0

0.5

1

z

1

(b)

Exercise 10.3

is used in an alternative approximate inference framework called expectation propagation . We therefore consider the general problem of minimizing KL( p q ) when q ( Z ) is a factorized approximation of the form (10.5). The KL divergence can then be written in the form

$$
\text {written in the form} \\ K L ( p | | q ) = - \int p ( Z ) \left [ \sum _ { i = 1 } ^ { M } \ln q _ { i } ( Z _ { i } ) \right ] \, d Z + \text {const} \quad ( 1 0 . 1 6 ) \\ \intertext { r e \, t h e \, \text {constant term is simply the entropy of } p ( Z ) \, \text { and so does not depend on}
$$

where the constant term is simply the entropy of p ( Z ) and so does not depend on q ( Z ) . We can now optimize with respect to each of the factors q j ( Z j ) , which is easily done using a Lagrange multiplier to give

$$
\text {using a Lagrange multiplier to give} & \text {gc} \\ q _ { j } ^ { * } ( Z _ { j } ) = \int p ( Z ) \prod _ { i \neq j } \, d Z _ { i } = p ( Z _ { j } ) . & ( 1 0 . 1 7 ) \\
$$

/negationslash

In this case, we ﬁnd that the optimal solution for q j ( Z j ) is just given by the corresponding marginal distribution of p ( Z ) . Note that this is a closed-form solution and so does not require iteration.

To apply this result to the illustrative example of a Gaussian distribution p ( z ) over a vector z we can use (2.98), which gives the result shown in Figure 10.2(b). We see that once again the mean of the approximation is correct, but that it places signiﬁcant probability mass in regions of variable space that have very low probability.

The difference between these two results can be understood by noting that there is a large positive contribution to the Kullback-Leibler divergence

$$
K L ( q \| p ) = - \int q ( Z ) \ln \left \{ \frac { p ( Z ) } { q ( Z ) } \right \} \, d Z \quad ( 1 0 . 1 8 )
$$
