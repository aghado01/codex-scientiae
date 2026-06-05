[Page 662]

# 13.3.2 Learning in LDS

So far, we have considered the inference problem for linear dynamical systems, assuming that the model parameters θ = { A , Γ , C , Σ , µ 0 , V 0 } are known. Next, we consider the determination of these parameters using maximum likelihood (Ghahramani and Hinton, 1996b). Because the model has latent variables, this can be addressed using the EM algorithm, which was discussed in general terms in Chapter 9.

We can derive the EM algorithm for the linear dynamical system as follows. Let us denote the estimated parameter values at some particular cycle of the algorithm by θ old . For these parameter values, we can run the inference algorithm to determine the posterior distribution of the latent variables p ( Z | X , θ old ) , or more precisely those local posterior marginals that are required in the M step. In particular, we shall require the following expectations

$$
\mathbb { E } \left [ z _ { n } \right ] \ & = \ \widehat { \mu } _ { n } \quad \\ \mathbb { E } \left [ z _ { n } z _ { n - 1 } ^ { T } \right ] \ & = \ \mathbb { J } _ { n - 1 } \widehat { V } _ { n } + \widehat { \mu } _ { n } \widehat { \mu } _ { n - 1 } ^ { T } \\ \mathbb { E } \left [ z _ { n } z _ { n } ^ { T } \right ] \ & = \ \widehat { V } _ { n } + \widehat { \mu } _ { n } \widehat { \mu } _ { n } ^ { T }
$$

$$
\mathbb { E } \left [ z _ { n } \right ] & = \mu _ { n } \quad \mathbb { m } { I } _ { n } \quad \mathbb { m } { T } _ { n - 1 } \widehat { V } _ { n } + \widehat { \mu } _ { n } \widehat { \mu } _ { n - 1 } ^ { T } \\ \mathbb { E } \left [ z _ { n } z _ { n - 1 } ^ { T } \right ] & = \widehat { J } _ { n - 1 } \widehat { V } _ { n } + \widehat { \mu } _ { n } \widehat { \mu } _ { n } ^ { T } \\ \intertext { e u s d e } \text {consider the complete-data log likelihood function, which is obtained } \\ \text {algorithm of (13 6) and is therefore given by }
$$

where we have used (13.104).

Now we consider the complete-data log likelihood function, which is obtained by taking the logarithm of (13.6) and is therefore given by

$$
\ln p ( X , Z | \theta ) \ = \ \ln p ( z _ { 1 } | \mu _ { 0 } , V _ { 0 } ) + \sum _ { n = 2 } ^ { N } \ln p ( z _ { n } | z _ { n - 1 } , A , \Gamma ) \\ + \sum _ { n = 1 } ^ { N } \ln p ( x _ { n } | z _ { n } , C , \Sigma ) \\ \intertext { i n w h i c h w e h a d e the d e p e n d e n c o n t h e p a r m e t i s e p l i c i t . W e n w t a k e t h e } \intertext { i n w h i c h w e h a d e the d e p e n d e n c o n t h e p a r m e t i s e p l i c i t . W e n w t a k e t h e }
$$

in which we have made the dependence on the parameters explicit. We now take the expectation of the complete-data log likelihood with respect to the posterior distribution p ( Z | X , θ old ) which deﬁnes the function

$$
Q ( \theta , \theta ^ { \text {old} } ) = \mathbb { E } _ { Z | \theta ^ { \text {old} } } \left [ \ln p ( X , Z | \theta ) \right ] .
$$

In the M step, this function is maximized with respect to the components of θ .

Consider ﬁrst the parameters µ 0 and V 0 . If we substitute for p ( z 1 | µ 0 , V 0 ) in (13.108) using (13.77), and then take the expectation with respect to Z , we obtain

$$
( 1 . 5 . 1 0 ) \, \text {using} \, ( 1 . 5 . 1 ) , \, \text {and} \, \text {the take} \, \text {except} \, \text {to} \, 2 , \, \text {we obtain} \\ Q ( \theta , \theta ^ { \text {old} } ) = - \frac { 1 } { 2 } \ln | V _ { 0 } | - \mathbb { E } _ { Z | \theta ^ { \text {old} } } \left [ \frac { 1 } { 2 } ( z _ { 1 } - \mu _ { 0 } ) ^ { T } V _ { 0 } ^ { - 1 } ( z _ { 1 } - \mu _ { 0 } ) \right ] + \text {const} \\
$$

where all terms not dependent on µ 0 or V 0 have been absorbed into the additive constant. Maximization with respect to µ 0 and V 0 is easily performed by making use of the maximum likelihood solution for a Gaussian distribution discussed in Section 2.3.4, giving
