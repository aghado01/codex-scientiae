[Page 337]

# Exercise 6.25

Exercise 6.26

maximum. The posterior distribution is not Gaussian, however, because the Hessian is a function of a N . Using the Newton-Raphson formula (4.92), the iterative update equation for a

Using the Newton-Raphson formula (4.92), the iterative update equation for a N is given by

$$
a _ { N } ^ { n e w } = C _ { N } ( I + W _ { N } C _ { N } ) ^ { - 1 } \{ \mathfrak { t } _ { N } - \sigma _ { N } + W _ { N } a _ { N } \} .
$$

These equations are iterated until they converge to the mode which we denote by a N . At the mode, the gradient ∇ Ψ( a N ) will vanish, and hence a N will satisfy

$$
a _ { N } ^ { * } = C _ { N } ( \mathfrak { t } _ { N } - \sigma _ { N } ) .
$$

Once we have found the mode a N of the posterior, we can evaluate the Hessian matrix given by 1

$$
H = - \nabla \nabla \Psi ( a _ { N } ) = W _ { N } + C _ { N } ^ { - 1 } \\ \intertext { w h e t w } \intertext { a n d } \intertext { s u p } \intertext { e f w }
$$

where the elements of W N are evaluated using a N . This deﬁnes our Gaussian approximation to the posterior distribution p ( a N | t N ) given by

$$
q ( a _ { N } ) = \mathcal { N } ( a _ { N } | a _ { N } ^ { * } , H ^ { - 1 } ) .
$$

We can now combine this with (6.78) and hence evaluate the integral (6.77). Because this corresponds to a linear-Gaussian model, we can use the general result (2.115) to give

$$
\mathbb { E } [ a _ { N + 1 } | \mathfrak { t } _ { N } ] \ & = \ k ^ { T } ( \mathfrak { t } _ { N } - \sigma _ { N } ) \\ \text {var} [ a _ { N + 1 } | \mathfrak { t } _ { N } ] & \ = \ \mathcal { C } - k ^ { T } ( W _ { N } ^ { - 1 } + C _ { N } ) ^ { - 1 } k
$$

$$
\ v a r [ a _ { N + 1 } | t _ { N } ] \ = \ c - k ^ { T } ( W _ { N } ^ { - 1 } + C _ { N } ) ^ { - 1 } k .
$$

Now that we have a Gaussian distribution for p ( a N +1 | t N ) , we can approximate the integral (6.76) using the result (4.153). As with the Bayesian logistic regression model of Section 4.5, if we are only interested in the decision boundary corresponding to p ( t N +1 | t N ) = 0 . 5 , then we need only consider the mean and we can ignore the effect of the variance.

We also need to determine the parameters θ of the covariance function. One approach is to maximize the likelihood function given by p ( t N | θ ) for which we need expressions for the log likelihood and its gradient. If desired, suitable regularization terms can also be added, leading to a penalized maximum likelihood solution. The likelihood function is deﬁned by

$$
\int p ( t _ { N } | \theta ) = \int p ( t _ { N } | a _ { N } ) p ( a _ { N } | \theta ) \, d a _ { N } . \\ \intertext { i s o n l y t i c h l o w t h e t h e a n d s a l l }
$$

This integral is analytically intractable, so again we make use of the Laplace approximation. Using the result (4.135), we obtain the following approximation for the log of the likelihood function

$$
\ln p ( \mathfrak { t } _ { N } | \theta ) = \Psi ( a _ { N } ^ { * } ) - \frac { 1 } { 2 } \ln | W _ { N } + C _ { N } ^ { - 1 } | + \frac { N } { 2 } \ln ( 2 \pi )
$$
