[Page 238]

$$
p ( w | \mathbf t ) \subset p ( w ) p ( \mathbf t | w ) \\ ) ^ { T } \ T o l i n g { \ t h o l a o f b o t h i s d o s } \, \text {and} \, \text {substituting for the prior}
$$

where t = ( t 1 ,...,t N ) T . Taking the log of both sides, and substituting for the prior distribution using (4.140), and for the likelihood function using (4.89), we obtain

$$
\intertext { h a n d r o w s } \ln p ( w | t ) & \ = \ - \frac { 1 } { 2 } ( w - m _ { 0 } ) ^ { T } S _ { 0 } ^ { - 1 } ( w - m _ { 0 } ) \\ & + \sum _ { n = 1 } ^ { N } \{ t _ { n } \ln y _ { n } + ( 1 - t _ { n } ) \ln ( 1 - y _ { n } ) \} + c o n s t \quad ( 4 . 1 2 ) \\ \intertext { w h e r } \intertext { y _ { n } = \sigma ( w ^ { T } \phi _ { n } ) . \ \ } \intertext { T o b t a i n a G a u s i m a p r o x i m a t o t h e p o s t i o r } \intertext { p e r s e d i s }
$$

where y n = σ ( w T φ n ) . To obtain a Gaussian approximation to the posterior distribution, we ﬁrst maximize the posterior distribution to give the MAP (maximum posterior) solution w MAP , which deﬁnes the mean of the Gaussian. The covariance is then given by the inverse of the matrix of second derivatives of the negative log likelihood, which takes the form

$$
S _ { N } = - \nabla \nabla \ln p ( w | \mathfrak { t } ) = S _ { 0 } ^ { - 1 } + \sum _ { n = 1 } ^ { N } y _ { n } ( 1 - y _ { n } ) \phi _ { n } \phi _ { n } ^ { T } . \\ \intertext { The Gaussian approximation to the posterior distribution therefore takes the form }
$$

The Gaussian approximation to the posterior distribution therefore takes the form

$$
q ( \mathbf w ) = \mathcal { N } ( \mathbf w | \mathbf w _ { \mathbf M A P } , S _ { N } ) . \\
$$

Having obtained a Gaussian approximation to the posterior distribution, there remains the task of marginalizing with respect to this distribution in order to make predictions.

# 4.5.2 Predictive distribution

The predictive distribution for class C 1 , given a new feature vector φ ( x ) , is obtained by marginalizing with respect to the posterior distribution p ( w | t ) , which is itself approximated by a Gaussian distribution q ( w ) so that

$$
\text {insert applied by a Gaussian distribution} \, q ( w ) \, \text {so that} \\ p ( \mathcal { C } _ { 1 } | \phi , \mathfrak { t } ) = \int p ( \mathcal { C } _ { 1 } | \phi , w ) p ( w | \mathfrak { t } ) \, d w \simeq \int \sigma ( w ^ { T } \phi ) q ( w ) \, d w \\ \\ \text {with the corresponding probability for class } \mathcal { C } _ { 0 } \text { given by } p ( \mathcal { C } _ { 1 } | \phi ) \, \mathfrak { t } = 1 - p ( \mathcal { C } _ { 1 } | \phi \mathfrak { t } )
$$

with the corresponding probability for class C 2 given by p ( C 2 | φ , t ) = 1 − p ( C 1 | φ , t ) . To evaluate the predictive distribution, we ﬁrst note that the function σ ( w T φ ) depends on w only through its projection onto φ . Denoting a = w T φ , we have

$$
\text {only through its projection onto $\phi$} . \text { Denoting } a = w ^ { - } \phi , \text { we have} \\ \sigma ( w ^ { T } \phi ) = \int \delta ( a - w ^ { T } \phi ) \sigma ( a ) \, d a \\ \intertext { the Dirac delta function. From this we obtain }
$$

where δ ( · ) is the Dirac delta function. From this we obtain

$$
\text {is the Dirac delta function. From this we obtain} \\ \int \sigma ( w ^ { T } \phi ) q ( w ) \, d w = \int \sigma ( a ) p ( a ) \, d a
$$
