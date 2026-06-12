[Page 239]

Exercise 4.24

Exercise 4.25

Exercise 4.26

$$
p ( a ) = \int \delta ( a - w ^ { T } \phi ) q ( w ) d w . \\ \intertext { t a p ( a ) by noting that the delta function imposes a linear constraint }
$$

where

We can evaluate p ( a ) by noting that the delta function imposes a linear constraint on w and so forms a marginal distribution from the joint distribution q ( w ) by integrating out all directions orthogonal to φ . Because q ( w ) is Gaussian, we know from Section 2.3.2 that the marginal distribution will also be Gaussian. We can evaluate the mean and covariance of this distribution by taking moments, and interchanging the order of integration over a and w , so that

$$
\text {the order of integer} \, a \text { and } w , \text { so that} \\ \mu _ { a } = \mathbb { E } [ a ] = \int p ( a ) a \, d a = \int q ( w ) w ^ { T } \phi \, d w = w _ { \text {MAP} } ^ { T } \phi \\ \\ \text {where} \, w \text { have used} \, \text {the} \, \text {result} \, ( 4 . 1 4 ) \text { for the} \, \text {i} \, \text {tion} \, \text {, non-ordering} \, \text {distribution} \, \text {,} \, ( m )
$$

where we have used the result (4.144) for the variational posterior distribution q ( w ) . Similarly

$$
\text {Similarly} \\ \sigma _ { a } ^ { 2 } & \ = \ \ v a r [ a ] = \int p ( a ) \left \{ a ^ { 2 } - \mathbb { E } [ a ] ^ { 2 } \right \} \, d a \\ & \ = \ \int q ( w ) \left \{ ( w ^ { T } \phi ) ^ { 2 } - ( m _ { N } ^ { T } \phi ) ^ { 2 } \right \} \, d w = \phi ^ { T } S _ { N } \phi . \\ \text {Note that the distribution of a takes the same form as the predictive distribution} \\ ( 3 5 ) \text { for the linear regression model with the noise variance set to zero } \text { Thus our}
$$

Note that the distribution of a takes the same form as the predictive distribution (3.58) for the linear regression model, with the noise variance set to zero. Thus our variational approximation to the predictive distribution becomes

$$
\text {at} a \text { app} \alpha \text {mutation} \text { to the precise unknown occurrences} \\ p ( \mathcal { C } _ { 1 } | \mathfrak { t } ) = \int \sigma ( a ) p ( a ) \, d a = \int \sigma ( a ) \mathcal { N } ( a | \mu _ { a } , \sigma _ { a } ^ { 2 } ) \, d a . \\ \text {is result can also be derived directly by making use of the results for the marginal}
$$

This result can also be derived directly by making use of the results for the marginal of a Gaussian distribution given in Section 2.3.2.

The integral over a represents the convolution of a Gaussian with a logistic sigmoid, and cannot be evaluated analytically. We can, however, obtain a good approximation (Spiegelhalter and Lauritzen, 1990; MacKay, 1992b; Barber and Bishop, 1998a) by making use of the close similarity between the logistic sigmoid function σ ( a ) deﬁned by (4.59) and the probit function Φ( a ) deﬁned by (4.114). In order to obtain the best approximation to the logistic function we need to re-scale the horizontal axis, so that we approximate σ ( a ) by Φ( λa ) . We can ﬁnd a suitable value of λ by requiring that the two functions have the same slope at the origin, which gives λ 2 = π/ 8 . The similarity of the logistic sigmoid and the probit function, for this choice of λ , is illustrated in Figure 4.9.

The advantage of using a probit function is that its convolution with a Gaussian can be expressed analytically in terms of another probit function. Speciﬁcally we can show that

$$
\int \Phi ( \lambda a ) \mathcal { N } ( a | \mu , \sigma ^ { 2 } ) \, d a = \Phi \left ( \frac { \mu } { ( \lambda ^ { - 2 } + \sigma ^ { 2 } ) ^ { 1 / 2 } } \right ) .
$$
