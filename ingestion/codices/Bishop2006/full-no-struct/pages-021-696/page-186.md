[Page 186]

Exercise 3.16

Exercise 3.17

From Bayes’ theorem, the posterior distribution for α and β is given by

$$
p ( \alpha , \beta | \mathbf t ) \circ p ( \mathbf t | \alpha , \beta ) p ( \alpha , \beta ) .
$$

If the prior is relatively ﬂat, then in the evidence framework the values of α and β are obtained by maximizing the marginal likelihood function p ( t | α,β ) . We shall proceed by evaluating the marginal likelihood for the linear basis function model and then ﬁnding its maxima. This will allow us to determine values for these hyperparameters from the training data alone, without recourse to cross-validation. Recall that the ratio α/β is analogous to a regularization parameter.

As an aside it is worth noting that, if we deﬁne conjugate (Gamma) prior distributions over α and β , then the marginalization over these hyperparameters in (3.74) can be performed analytically to give a Student’s t-distribution over w (see Section 2.3.7). Although the resulting integral over w is no longer analytically tractable, it might be thought that approximating this integral, for example using the Laplace approximation discussed (Section 4.4) which is based on a local Gaussian approximation centred on the mode of the posterior distribution, might provide a practical alternative to the evidence framework (Buntine and Weigend, 1991). However, the integrand as a function of w typically has a strongly skewed mode so that the Laplace approximation fails to capture the bulk of the probability mass, leading to poorer results than those obtained by maximizing the evidence (MacKay, 1999).

Returning to the evidence framework, we note that there are two approaches that we can take to the maximization of the log evidence. We can evaluate the evidence function analytically and then set its derivative equal to zero to obtain re-estimation equations for α and β , which we shall do in Section 3.5.2. Alternatively we use a technique called the expectation maximization (EM) algorithm, which will be discussed in Section 9.3.4 where we shall also show that these two approaches converge to the same solution.

# 3.5.1 Evaluation of the evidence function

The marginal likelihood function p ( t | α,β ) is obtained by integrating over the weight parameters w , so that

$$
p ( \mathbf t | \alpha , \beta ) & = \int p ( \mathbf t | w , \beta ) p ( w | \alpha ) \, d w . \\ \intertext { e v a l u t e $ h i n g r a l $ i s t r a g n o w $ e q n o c $ a n g a i n $ o f the r e s u l t $ ( 2 . 1 5 ) }
$$

One way to evaluate this integral is to make use once again of the result (2.115) for the conditional distribution in a linear-Gaussian model. Here we shall evaluate the integral instead by completing the square in the exponent and making use of the standard form for the normalization coefﬁcient of a Gaussian.

From (3.11), (3.12), and (3.52), we can write the evidence function in the form

$$
p ( \mathbf t | \alpha , \beta ) = \left ( \frac { \beta } { 2 \pi } \right ) ^ { N / 2 } \left ( \frac { \alpha } { 2 \pi } \right ) ^ { M / 2 } \int \exp \left \{ - E ( w ) \right \} \, d w
$$
