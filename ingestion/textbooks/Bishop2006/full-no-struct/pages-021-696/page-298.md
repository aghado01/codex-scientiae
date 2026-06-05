[Page 298]

# 5.7.1 Posterior parameter distribution

Consider the problem of predicting a single continuous target variable t from a vector x of inputs (the extension to multiple targets is straightforward). We shall suppose that the conditional distribution p ( t | x ) is Gaussian, with an x -dependent mean given by the output of a neural network model y ( x , w ) , and with precision (inverse variance) β

$$
p ( t | x , w , \beta ) = \mathcal { N } ( t | y ( x , w ) , \beta ^ { - 1 } ) .
$$

Similarly, we shall choose a prior distribution over the weights w that is Gaussian of the form 1

$$
p ( w | \alpha ) = \mathcal { N } ( w | 0 , \alpha ^ { - 1 } I ) . \\ + f N \, \text {satisfying} \, i \, w \, = \, \underset { \ } w i t h \, . \, \underset { \ } w i t h \, . \, \underset { \ } w i t h \, . \, \underset { \ } w i t h \, .
$$

For an i.i.d. data set of N observations x 1 ,..., x N , with a corresponding set of target values D = { t 1 ,...,t N } , the likelihood function is given by

$$
p ( \mathcal { D } | w , \beta ) = \prod _ { n = 1 } ^ { N } \mathcal { N } ( t _ { n } | y ( x _ { n } , w ) , \beta ^ { - 1 } ) \\ \intertext { s u l t i n g p o s t i o r $ d i s t r i o n $ }
$$

and so the resulting posterior distribution is then

$$
p ( \mathbf w | \mathcal { D } , \alpha , \beta ) \in p ( \mathbf w | \alpha ) p ( \mathcal { D } | \mathbf w , \beta ) .
$$

which, as a consequence of the nonlinear dependence of y ( x , w ) on w , will be nonGaussian.

We can ﬁnd a Gaussian approximation to the posterior distribution by using the Laplace approximation. To do this, we must ﬁrst ﬁnd a (local) maximum of the posterior, and this must be done using iterative numerical optimization. As usual, it is convenient to maximize the logarithm of the posterior, which can be written in the
