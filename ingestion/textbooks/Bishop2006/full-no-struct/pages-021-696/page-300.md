[Page 300]

Exercise 5.39

$$
\sigma ^ { 2 } ( x ) = \beta ^ { - 1 } + g ^ { T } A ^ { - 1 } g .
$$

We see that the predictive distribution p ( t | x , D ) is a Gaussian whose mean is given by the network function y ( x , w MAP ) with the parameter set to their MAP value. The variance has two terms, the ﬁrst of which arises from the intrinsic noise on the target variable, whereas the second is an x -dependent term that expresses the uncertainty in the interpolant due to the uncertainty in the model parameters w . This should be compared with the corresponding predictive distribution for the linear regression model, given by (3.58) and (3.59).

# 5.7.2 Hyperparameter optimization

So far, we have assumed that the hyperparameters α and β are ﬁxed and known. We can make use of the evidence framework, discussed in Section 3.5, together with the Gaussian approximation to the posterior obtained using the Laplace approximation, to obtain a practical procedure for choosing the values of such hyperparameters.

The marginal likelihood, or evidence, for the hyperparameters is obtained by integrating over the network weights

$$
\ p ( \mathcal { D } | \alpha , \beta ) & = \int p ( \mathcal { D } | w , \beta ) p ( w | \alpha ) \, d w . \\ \intertext { l a n t u l d e v a l u g } \text { by making use of the I a l p a c e a p r o x i m a t i o n } \text { result } ( 4 . 1 3 5 )
$$

This is easily evaluated by making use of the Laplace approximation result (4.135). Taking logarithms then gives

$$
\ln p ( \mathcal { D } | \alpha , \beta ) \simeq - E ( w _ { M A P } ) - \frac { 1 } { 2 } \ln | A | + \frac { W } { 2 } \ln \alpha + \frac { N } { 2 } \ln \beta - \frac { N } { 2 } \ln ( 2 \pi ) \ ( 5 . 1 7 5 )
$$

where W is the total number of parameters in w , and the regularized error function is deﬁned by

$$
E ( w _ { \text {MAP} } ) = \frac { \beta } { 2 } \sum _ { n = 1 } ^ { N } \{ y ( x _ { n } , w _ { \text {MAP} } ) - t _ { n } \} ^ { 2 } + \frac { \alpha } { 2 } w _ { \text {MAP} } ^ { T } w _ { \text {MAP} } . \\ \\ \text {We see that this takes the same form as the corresponding result (3 6) for the linear}
$$

We see that this takes the same form as the corresponding result (3.86) for the linear regression model.

In the evidence framework, we make point estimates for α and β by maximizing ln p ( D| α,β ) . Consider ﬁrst the maximization with respect to α , which can be done by analogy with the linear regression case discussed in Section 3.5.2. We ﬁrst deﬁne the eigenvalue equation

$$
\beta H u _ { i } = \lambda _ { i } u _ { i }
$$

where H is the Hessian matrix comprising the second derivatives of the sum-ofsquares error function, evaluated at w = w MAP . By analogy with (3.92), we obtain

$$
\alpha = \frac { \gamma } { w _ { M A P } ^ { T } w _ { M A P } }
$$
