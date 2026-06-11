[Page 469]

Exercise 9.20

Exercise 9.21

where the likelihood p ( t | w ,β ) and the prior p ( w | α ) are given by (3.10) and (3.52), respectively, and y ( x , w ) is given by (3.3). Taking the expectation with respect to the posterior distribution of w then gives

$$
t h e p o s t i o r \, d i r t i o n \, o f \, w \, t h e n \, giv e s \\ \mathbb { E } \left [ \ln p ( t , w | \alpha , \beta ) \right ] \ = \ \frac { M } { 2 } \ln \left ( \frac { \alpha } { 2 \pi } \right ) - \frac { \alpha } { 2 } \mathbb { E } \left [ w ^ { T } w \right ] + \frac { N } { 2 } \ln \left ( \frac { \beta } { 2 \pi } \right ) \\ - \frac { \beta } { 2 } \sum _ { n = 1 } ^ { N } \mathbb { E } \left [ ( t _ { n } - w ^ { T } \phi _ { n } ) ^ { 2 } \right ] . \\ \\ \text {Setting the derivatives with respect to } \alpha \, t o \, z e r o , \, w \, o b t a i n \, t h e \, M \, t e p \, r e \, \text {estimation}
$$

Setting the derivatives with respect to α to zero, we obtain the M step re-estimation equation

$$
\alpha = \frac { M } { \mathbb { E } \left [ w ^ { T } w \right ] } = \frac { M } { m _ { N } ^ { T } m _ { N } + T r ( S _ { N } ) } .
$$

An analogous result holds for β .

Note that this re-estimation equation takes a slightly different form from the corresponding result (3.92) derived by direct evaluation of the evidence function. However, they each involve computation and inversion (or eigen decomposition) of an M × M matrix and hence will have comparable computational cost per iteration. These two approaches to determining α should of course converge to the same

result (assuming they ﬁnd the same local maximum of the evidence function). This can be veriﬁed by ﬁrst noting that the quantity γ is deﬁned by

$$
\gamma = M - \alpha \sum _ { i = 1 } ^ { M } \frac { 1 } { \lambda _ { i } + \alpha } = M - \alpha T r ( S _ { N } ) .
$$

At a stationary point of the evidence function, the re-estimation equation (3.92) will be self-consistently satisﬁed, and hence we can substitute for γ to give

$$
\alpha m _ { N } ^ { T } m _ { N } = \gamma = M - \alpha \text {Tr} ( S _ { N } )
$$

and solving for α we obtain (9.63), which is precisely the EM re-estimation equation.

As a ﬁnal example, we consider a closely related model, namely the relevance vector machine for regression discussed in Section 7.2.1. There we used direct maximization of the marginal likelihood to derive re-estimation equations for the hyperparameters α and β . Here we consider an alternative approach in which we view the weight vector w as a latent variable and apply the EM algorithm. The E step involves ﬁnding the posterior distribution over the weights, and this is given by (7.81). In the M step we maximize the expected complete-data log likelihood, which is deﬁned by

$$
\mathbb { E } _ { w } \left [ \ln p ( \mathbf t | X , w , \beta ) p ( w | \alpha ) \right ]
$$

where the expectation is taken with respect to the posterior distribution computed using the ‘old’ parameter values. To compute the new parameter values we maximize with respect to α and β to give
