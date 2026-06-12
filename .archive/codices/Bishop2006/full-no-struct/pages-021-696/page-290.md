[Page 290]

Section 2.3.9

Exercise 5.29

Recall that the simple weight decay regularizer, given in (5.112), can be viewed as the negative log of a Gaussian prior distribution over the weights. We can encourage the weight values to form several groups, rather than just one group, by considering instead a probability distribution that is a mixture of Gaussians. The centres and variances of the Gaussian components, as well as the mixing coefﬁcients, will be considered as adjustable parameters to be determined as part of the learning process. Thus, we have a probability density of the form

$$
p ( w ) = \prod _ { i } p ( w _ { i } )
$$

where

$$
p ( w _ { i } ) = \sum _ { j = 1 } ^ { M } \pi _ { j } \mathcal { N } ( w _ { i } | \mu _ { j } , \sigma _ { j } ^ { 2 } ) & & ( 5 . 1 3 ) \\ \intertext { i n x i n g e f f i c i v e s , \ } \text {taking the negative logarithm then leads to a }
$$

and π j are the mixing coefﬁcients. Taking the negative logarithm then leads to a regularization function of the form

$$
\Omega ( w ) = - \sum _ { i } \ln \left ( \sum _ { j = 1 } ^ { M } \pi _ { j } \mathcal { N } ( w _ { i } | \mu _ { j } , \sigma _ { j } ^ { 2 } ) \right ) . \\ \intertext { l a r $ f o n t i o n $ } \Omega ( w ) = - \sum _ { i } \ln \left ( \sum _ { j = 1 } ^ { M } \pi _ { j } \mathcal { N } ( w _ { i } | \mu _ { j } , \sigma _ { j } ^ { 2 } ) \right ) .
$$

The total error function is then given by

E ( w ) = E ( w ) + λ Ω( w ) (5.139) where λ is the regularization coefﬁcient. This error is minimized both with respect to the weights w i and with respect to the parameters { π j ,µ j ,σ j } of the mixture model. If the weights were constant, then the parameters of the mixture model could be determined by using the EM algorithm discussed in Chapter 9. However, the distribution of weights is itself evolving during the learning process, and so to avoid numerical instability, a joint optimization is performed simultaneously over the weights and the mixture-model parameters. This can be done using a standard optimization algorithm such as conjugate gradients or quasi-Newton methods.

In order to minimize the total error function, it is necessary to be able to evaluate its derivatives with respect to the various adjustable parameters. To do this it is convenient to regard the { π j } as prior probabilities and to introduce the corresponding posterior probabilities which, following (2.192), are given by Bayes’ theorem in the form π ( w µ ,σ 2 )

$$
\gamma _ { j } ( w ) = \frac { \pi _ { j } \mathcal { N } ( w | \mu _ { j } , \sigma _ { j } ^ { 2 } ) } { \sum _ { k } \pi _ { k } \mathcal { N } ( w | \mu _ { k } , \sigma _ { k } ^ { 2 } ) } \cdot \\ \text {of the total error function with respect to the weights are then given}
$$

The derivatives of the total error function with respect to the weights are then given by

$$
\frac { \partial \widetilde { E } } { \partial w _ { i } } = \frac { \partial E } { \partial w _ { i } } + \lambda \sum _ { j } \gamma _ { j } ( w _ { i } ) \frac { ( w _ { i } - \mu _ { j } ) } { \sigma _ { j } ^ { 2 } } .
$$
