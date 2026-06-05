[Page 523]

Speciﬁcally, we consider once again a simple isotropic Gaussian prior distribution of the form 1

$$
p ( w | \alpha ) = \mathcal { N } ( w | 0 , \alpha ^ { - 1 } \mathbf I ) . \\ \text {dilly extended to more general Gaussian priors for instance if} \, w \,
$$

Our analysis is readily extended to more general Gaussian priors, for instance if we wish to associate a different hyperparameter with different subsets of the parameters w j . As usual, we consider a conjugate hyperprior over α given by a gamma distribution

$$
p ( \alpha ) & = \text {Gam} ( \alpha | a _ { 0 } , b _ { 0 } ) \\ \text {tonts} \, a _ { 0 } \, \text { and } b _ { 0 } &
$$

governed by the constants a 0 and b 0 .

The marginal likelihood for this model now takes the form

$$
\ p ( \mathbf t ) = \iint p ( w , \alpha , \mathbf t ) \, d w \, d \alpha \\ \intertext { t h i n k e m o d for this m o d t h e r $ w $ t a r $ t $ } \ p ( \mathbf t ) = \iint p ( w , \alpha , \mathbf t ) \, d w \, d \alpha \\ \intertext { t h i n t u p i o n s } \intertext { s u r b i t i o n $ w $ t a r $ w $ t $ }
$$

where the joint distribution is given by

$$
p ( w , \alpha , t ) = p ( t | w ) p ( w | \alpha ) p ( \alpha ) . \\
$$

We are now faced with an analytically intractable integration over w and α , which we shall tackle by using both the local and global variational approaches in the same model

To begin with, we introduce a variational distribution q ( w ,α ) , and then apply the decomposition (10.2), which in this instance takes the form

$$
\ln p ( \mathbf t ) = \mathcal { L } ( q ) + K L ( q | | p ) \\ \\ \intertext { l n p ( \mathbf t ) = \mathcal { L } ( q ) + K L ( q | | p ) } \\
$$

where the lower bound L ( q ) and the Kullback-Leibler divergence KL( q p ) are deﬁned by

$$
\mathcal { L } ( q ) \ = \ \iint q ( w , \alpha ) \ln \left \{ \frac { p ( w , \alpha , \mathfrak { t } ) } { q ( w , \alpha ) } \right \} \, d w \, d \alpha \\ \intertext { l a c k e r } \mathcal { L } ( q ) \ = \ \iint q ( w , \alpha ) \ln \left \{ \frac { p ( w , \alpha , \mathfrak { t } ) } { q ( w , \alpha ) } \right \} \, d w \, d \alpha \\ \intertext { r e f t r a c l } \mathcal { L } ( w , \alpha ) \ = \ \iint q ( w , \alpha ) \, \frac { \int p ( w , \alpha | \mathfrak { t } ) } { q ( w , \alpha ) } \right ) \ ,
$$

$$
\int \int ^ { q ( q ) } \int \int ^ { q ( w , \alpha ) } \int \int ^ { q ( w , \alpha ) } \int \\ K L ( q | | p ) \, = \, - \iint q ( w , \alpha ) \ln \left \{ \frac { p ( w , \alpha | t ) } { q ( w , \alpha ) } \right \} \, d w \, d \alpha . \quad ( 1 0 . 1 7 1 ) \\ \intertext { A t h i s p o i n t h e l o w e b o u n d \, \mathcal { C } ( q ) \, \text { is still intractable due to the form of the } }
$$

At this point, the lower bound L ( q ) is still intractable due to the form of the likelihood factor p ( t | w ) . We therefore apply the local variational bound to each of the logistic sigmoid factors as before. This allows us to use the inequality (10.152) and place a lower bound on L ( q ) , which will therefore also be a lower bound on the log marginal likelihood

$$
\ln p ( t ) & \ \geq \ \mathcal { L } ( q ) \geq \widetilde { \mathcal { L } } ( q , \xi ) \\ & = \ \iint q ( w , \alpha ) \ln \left \{ \frac { h ( w , \xi ) p ( w | \alpha ) p ( \alpha ) } { q ( w , \alpha ) } \right \} \, d w \, d \alpha . \ \ ( 1 0 . 1 2 ) \\ \text {Next we assume that the variational distribution factorizes between parameters and}
$$

Next we assume that the variational distribution factorizes between parameters and hyperparameters so that

$$
q ( \mathbf w , \alpha ) = q ( \mathbf w ) q ( \alpha ) .
$$
