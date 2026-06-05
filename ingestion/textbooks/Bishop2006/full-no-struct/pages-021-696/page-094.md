[Page 94]

# Exercise 2.7

# Exercise 2.8

large data set. For a ﬁnite data set, the posterior mean for µ always lies between the prior mean and the maximum likelihood estimate for µ corresponding to the relative frequencies of events given by (2.7).

From Figure 2.2, we see that as the number of observations increases, so the posterior distribution becomes more sharply peaked. This can also be seen from the result (2.16) for the variance of the beta distribution, in which we see that the variance goes to zero for a → ∞ or b → ∞ . In fact, we might wonder whether it is a general property of Bayesian learning that, as we observe more and more data, the uncertainty represented by the posterior distribution will steadily decrease.

To address this, we can take a frequentist view of Bayesian learning and show that, on average, such a property does indeed hold. Consider a general Bayesian inference problem for a parameter θ for which we have observed a data set D , described by the joint distribution p ( θ , D ) . The following result

$$
\mathbb { E } _ { \theta } [ \theta ] = \mathbb { E } _ { \mathcal { D } } \left [ \mathbb { E } _ { \theta } [ \theta | \mathcal { D } ] \right ]
$$

where

$$
\mathbb { E } _ { \theta } [ \theta ] \ \equiv \ \int p ( \theta ) \theta \, d \theta \\ \\ \mathbb { F } \ [ \mathbb { F } \ [ \partial \mathcal { D } ] ] \ = \ \int \left \{ \int \rho _ { \theta } ( \partial | \mathcal { D } ) \, d \theta \right \} \, \mathbb { m } { ( } \mathcal { D } ) \, d \mathcal { T } \\
$$

$$
\mathbb { E } _ { \mathcal { D } } [ \mathbb { E } _ { \theta } [ \theta | \mathcal { D } ] ] \ & \equiv \ \int \left \{ \int \theta p ( \theta | \mathcal { D } ) \, d \theta \right \} p ( \mathcal { D } ) \, d \mathcal { D } \\ \intertext { t h e r } \mathbb { E } _ { \mathcal { D } } [ \mathbb { E } _ { \theta } [ \theta | \mathcal { D } ] ] \ & \equiv \ \int \left \{ \int \theta p ( \theta | \mathcal { D } ) \, d \theta \right \} p ( \mathcal { D } ) \, d \mathcal { D } \\ \intertext { t h e r } \intertext { t h e r } \mathbb { E } ( 2 . 2 ) \, \intertext { t h e r }
$$

says that the posterior mean of θ , averaged over the distribution generating the data, is equal to the prior mean of θ . Similarly, we can show that

$$
v a r _ { \theta } [ \theta ] = \mathbb { E } _ { \mathcal { D } } \left [ v a r _ { \theta } [ \theta | \mathcal { D } ] \right ] + v a r _ { \mathcal { D } } \left [ \mathbb { E } _ { \theta } [ \theta | \mathcal { D } ] \right ] .
$$

The term on the left-hand side of (2.24) is the prior variance of θ . On the righthand side, the ﬁrst term is the average posterior variance of θ , and the second term measures the variance in the posterior mean of θ . Because this variance is a positive quantity, this result shows that, on average, the posterior variance of θ is smaller than the prior variance. The reduction in variance is greater if the variance in the posterior mean is greater. Note, however, that this result only holds on average, and that for a particular observed data set it is possible for the posterior variance to be larger than the prior variance.

# 2.2. Multinomial Variables

Binary variables can be used to describe quantities that can take one of two possible values. Often, however, we encounter discrete variables that can take on one of K possible mutually exclusive states. Although there are various alternative ways to express such variables, we shall see shortly that a particularly convenient representation is the 1 -ofK scheme in which the variable is represented by a K -dimensional vector x in which one of the elements x k equals 1 , and all remaining elements equal
