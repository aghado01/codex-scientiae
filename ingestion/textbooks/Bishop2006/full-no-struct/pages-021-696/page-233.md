[Page 233]

Thus y and η must related, and we denote this relation through η = ψ ( y ) .

Following Nelder and Wedderburn (1972), we deﬁne a generalized linear model to be one for which y is a nonlinear function of a linear combination of the input (or feature) variables so that T

$$
y = f ( w ^ { T } \phi )
$$

where f ( · ) is known as the activation function in the machine learning literature, and f − 1 ( · ) is known as the link function in statistics. Now consider the log likelihood function for this model, which, as a function of

Now consider the log likelihood function for this model, which, as a function of η , is given by

$$
\ln p ( \mathfrak { t } | \eta , s ) = \sum _ { n = 1 } ^ { N } \ln p ( t _ { n } | \eta , s ) = \sum _ { n = 1 } ^ { N } \left \{ \ln g ( \eta _ { n } ) + \frac { \eta _ { n } t _ { n } } { s } \right \} + \text {const} \quad ( 4 . 1 2 1 ) \\ \intertext { w h e r e a s u m i n g t a l l a b s y } \intertext { w h e r e a s u m i n g t a l l a b s y }
$$

where we are assuming that all observations share a common scale parameter (which corresponds to the noise variance for a Gaussian distribution for instance) and so s is independent of n . The derivative of the log likelihood with respect to the model parameters w is then given by

$$
parameters & w \text { is then given by} \\ & \nabla _ { w } \ln p ( \mathfrak { t } | \eta , s ) \ = \ \sum _ { n = 1 } ^ { N } \left \{ \frac { d } { d \eta _ { n } } \ln g ( \eta _ { n } ) + \frac { t _ { n } } { s } \right \} \frac { d \eta _ { n } } { d y _ { n } } \frac { d y _ { n } } { d a _ { n } } \nabla a _ { n } \\ & = \ \sum _ { n = 1 } ^ { N } \frac { 1 } { s } \left \{ t _ { n } - y _ { n } \right \} \psi ^ { \prime } ( y _ { n } ) f ^ { \prime } ( a _ { n } ) \phi _ { n } \quad ( 4 . 1 2 2 ) \\ \intertext { w h e a _ { n } = w ^ { T } \phi _ { n } , a n d w h e a d y _ { n } = f ( a _ { n } ) t o t e r w h e t h e r s u l t ( 4 . 1 1 9 ) }
$$

where a n = w T φ n , and we have used y n = f ( a n ) together with the result (4.119) for E [ t | η ] . We now see that there is a considerable simpliﬁcation if we choose a particular form for the link function f − 1 ( y ) given by

$$
f ^ { - 1 } ( y ) = \psi ( y )
$$

which gives f ( ψ ( y )) = y and hence f ( ψ ) ψ ( y ) = 1 . Also, because a = f − 1 ( y ) , we have a = ψ and hence f ( a ) ψ ( y ) = 1 . In this case, the gradient of the error function reduces to N

$$
\text {es to} \\ \nabla \ln E ( w ) = \frac { 1 } { s } \sum _ { n = 1 } ^ { N } \{ y _ { n } - t _ { n } \} \phi _ { n } . \\ \text {ian } s = \beta ^ { - 1 } , \text {where for the logistic model } s = 1 .
$$

For the Gaussian s = β − 1 , whereas for the logistic model s = 1 .

# 4.4. The Laplace Approximation

In Section 4.5 we shall discuss the Bayesian treatment of logistic regression. As we shall see, this is more complex than the Bayesian treatment of linear regression models, discussed in Sections 3.3 and 3.5. In particular, we cannot integrate exactly
