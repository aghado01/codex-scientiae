[Page 665]

Chapter 11

# 13.3.4 Particle ﬁlters

For dynamical systems which do not have a linear-Gaussian, for example, if they use a non-Gaussian emission density, we can turn to sampling methods in order to ﬁnd a tractable inference algorithm. In particular, we can apply the samplingimportance-resampling formalism of Section 11.1.5 to obtain a sequential Monte Carlo algorithm known as the particle ﬁlter.

Consider the class of distributions represented by the graphical model in Figure 13.5, and suppose we are given the observed values X n = ( x 1 ,..., x n ) and we wish to draw L samples from the posterior distribution p ( z n | X n ) . Using Bayes’ theorem, we have

$$
\text {wish to draw } L \text { samples from the posterior distribution } p ( z _ { n } | X _ { n } ) . \text { Using Bayes} \\ \text {ere, we have} \\ \mathbb { E } [ f ( z _ { n } ) ] \ = \ \int f ( z _ { n } ) p ( z _ { n } | X _ { n } ) \, d z _ { n } \\ \ = \ \int f ( z _ { n } ) p ( z _ { n } | x _ { n } , X _ { n - 1 } ) \, d z _ { n } \\ \ = \ \frac { \int f ( z _ { n } ) p ( x _ { n } | z _ { n } ) p ( z _ { n } | X _ { n - 1 } ) \, d z _ { n } } { \int p ( x _ { n } | z _ { n } ) p ( z _ { n } | X _ { n - 1 } ) \, d z _ { n } } \\ \simeq \ \sum _ { l = 1 } ^ { L } w _ { n } ^ { ( l ) } f ( z _ { n } ^ { ( l ) } ) \\ \text {are } \{ z _ { n } ^ { ( l ) } \} \text { is a set of samples drawn from } p ( z _ { n } | X _ { n - 1 } ) \text { and we have made use of } \\ \text {conditional independence property } p ( x _ { n } | z _ { n } , X _ { n - 1 } ) = p ( x _ { n } | z _ { n } ) , \text { which follows}
$$

where { z ( l ) n } is a set of samples drawn from p ( z n | X n − 1 ) and we have made use of the conditional independence property p ( x n | z n , X n − 1 ) = p ( x n | z n ) , which follows from the graph in Figure 13.5. The sampling weights { w ( l ) n } are deﬁned by

$$
w _ { n } ^ { ( l ) } = \frac { p ( x _ { n } | z _ { n } ^ { ( l ) } ) } { \sum _ { m = 1 } ^ { L } p ( x _ { n } | z _ { n } ^ { ( m ) } ) } \\ \text {implies are used in the numerator as in the denominator.  Thus the } \\ \text {on } p ( z _ { n } \ | x _ { n } ) \text { is represented by the set of samples } \{ z ^ { ( l ) } \} \text { together}
$$

where the same samples are used in the numerator as in the denominator. Thus the posterior distribution p ( z n | x n ) is represented by the set of samples { z ( l ) n } together with the corresponding weights { w ( l ) n } . Note that these weights satisfy 0 w ( l ) n 1 and l w ( l ) n = 1 . Because we wish to ﬁnd a sequential sampling scheme, we shall suppose that

a set of samples and weights have been obtained at time step n , and that we have subsequently observed the value of x n +1 , and we wish to ﬁnd the weights and samples at time step n + 1 . We ﬁrst sample from the distribution p ( z n +1 | X n ) . This is
