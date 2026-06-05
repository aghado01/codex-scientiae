[Page 299]

$$
\ln p ( w | \mathcal { D } ) = - \frac { \alpha } { 2 } w ^ { T } w - \frac { \beta } { 2 } \sum _ { n = 1 } ^ { N } \{ y ( x _ { n } , w ) - t _ { n } \} ^ { 2 } + \text {const} \\ \\ \text {which corresponds to a generalized sum-of-squares error function} \ \text {Assuming for}
$$

which corresponds to a regularized sum-of-squares error function. Assuming for the moment that α and β are ﬁxed, we can ﬁnd a maximum of the posterior, which we denote w MAP , by standard nonlinear optimization algorithms such as conjugate gradients, using error backpropagation to evaluate the required derivatives.

Having found a mode w MAP , we can then build a local Gaussian approximation by evaluating the matrix of second derivatives of the negative log posterior distribution. From (5.165), this is given by

$$
A = - \nabla \nabla \ln p ( w | \mathcal { D } , \alpha , \beta ) = \alpha I + \beta H
$$

where H is the Hessian matrix comprising the second derivatives of the sum-ofsquares error function with respect to the components of w . Algorithms for computing and approximating the Hessian were discussed in Section 5.4. The corresponding Gaussian approximation to the posterior is then given from (4.134) by

$$
q ( \mathbf w | \mathcal { D } ) = \mathcal { N } ( \mathbf w | \mathbf w _ { \text {MAP} } , A ^ { - 1 } ) .
$$

Similarly, the predictive distribution is obtained by marginalizing with respect to this posterior distribution

$$
p ( t | x , \mathcal { D } ) = \int p ( t | x , w ) q ( w | \mathcal { D } ) \, d w . \\ \intertext { w e n t h u d o w h i t h e a n p r o x i m a t i o n t o t h e p o r t i o n t h i s int e r g a t i o n i s }
$$

However, even with the Gaussian approximation to the posterior, this integration is still analytically intractable due to the nonlinearity of the network function y ( x , w ) as a function of w . To make progress, we now assume that the posterior distribution has small variance compared with the characteristic scales of w over which y ( x , w ) is varying. This allows us to make a Taylor series expansion of the network function around w MAP and retain only the linear terms

$$
y ( x , w ) \simeq y ( x , w _ { M A P } ) + g ^ { T } ( w - w _ { M A P } )
$$

where we have deﬁned

$$
g & = \nabla _ { w } y ( x , w ) | _ { w = w _ { \text {MAP} } } \, . \\ \text {motion} \, w \, \text {new, above} \, e \, \lim e t s _ { \ } C u v e i o n \, m e d l \, w i t h \, e \, C u v e i o n
$$

With this approximation, we now have a linear-Gaussian model with a Gaussian distribution for p ( w ) and a Gaussian for p ( t | w ) whose mean is a linear function of w of the form

$$
w \, o r \, \text {the form} \\ p ( t | x , w , \beta ) \simeq \mathcal { N } \left ( t | y ( x , w _ { \text {MAP} } ) + g ^ { T } ( w - w _ { \text {MAP} } ) , \beta ^ { - 1 } \right ) . \\ \text {We can therefore make use of the general result (2.1 1 5) for the marginal p(t) to give}
$$

We can therefore make use of the general result (2.115) for the marginal p ( t ) to give Exercise 5.38

$$
\text {herealone make use of one general result (2.1.1.5) for the marginal p(t) to 6 give} \\ p ( t | x , \mathcal { D } , \alpha , \beta ) = \mathcal { N } \left ( t | y ( x , w _ { M A P } ) , \sigma ^ { 2 } ( x ) \right ) \\
$$
