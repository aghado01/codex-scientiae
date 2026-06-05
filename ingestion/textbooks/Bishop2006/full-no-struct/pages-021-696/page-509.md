[Page 509]

Exercise 10.27

$$
\sigma ^ { 2 } ( x ) = \frac { 1 } { \beta } + \phi ( x ) ^ { T } S _ { N } \phi ( x ) .
$$

Note that this takes the same form as the result (3.59) obtained with ﬁxed α except that now the expected value E [ α ] appears in the deﬁnition of S N .

# 10.3.3 Lower bound

Another quantity of importance is the lower bound L deﬁned by

$$
\mathcal { L } ( q ) \ & = \ \mathbb { E } [ \ln p ( w , \alpha , t ) ] - \mathbb { E } [ \ln q ( w , \alpha ) ] \\ & = \ \mathbb { E } _ { w } [ \ln p ( t | w ) ] + \mathbb { E } _ { w , \alpha } [ \ln p ( w | \alpha ) ] + \mathbb { E } _ { \alpha } [ \ln p ( \alpha ) ] \\ & - \mathbb { E } _ { \alpha } [ \ln q ( w ) ] _ { w } - \mathbb { E } [ \ln q ( \alpha ) ] . \\ \intertext { E } \text {Evaluation of the various terms is straightforward, making use of results obtained in }
$$

Evaluation of the various terms is straightforward, making use of results obtained in previous chapters, and gives

$$
\begin{array} { r l } & { E } { \Delta } \left [ \ln p ( t | w ) | _ { w } \right ] & { = } & { \frac { N } { 2 } \ln \left ( \frac { \beta } { 2 \pi } \right ) - \frac { \beta } { 2 } t ^ { T } t + \beta m _ { N } ^ { T } \Phi ^ { T } t } \\ & { - \frac { \beta } { 2 } \left [ \Phi ^ { T } \Phi ( m _ { N } m _ { N } ^ { T } + S _ { N } ) \right ] } & { ( 1 0 . 1 0 ) } \\ & { \mathbb { E } [ \ln p ( w | \alpha ) ] _ { w , \alpha } \, = \, - \frac { M } { 2 } \ln ( 2 \pi ) + \frac { M } { 2 } ( \psi ( a _ { N } ) - \ln b _ { N } ) } \\ & { - \frac { a _ { N } } { 2 b _ { N } } \left [ m _ { N } ^ { T } m _ { N } + T r ( S _ { N } ) \right ] } & { ( 1 0 . 1 0 ) } \\ & { \mathbb { E } [ \ln p ( \alpha ) ] _ { \alpha } \, = \, a _ { 0 } \ln b _ { 0 } + ( a _ { 0 } - 1 ) \left [ \psi ( a _ { N } ) - \ln b _ { N } \right ] } \\ & { - b _ { 0 } \frac { a _ { N } } { b _ { N } } - \ln \Gamma ( a _ { N } ) } & { ( 1 0 . 1 0 ) } \\ & { - \mathbb { E } [ \ln q ( w ) ] _ { w } \, = \, \frac { 1 } { 2 } \ln | S _ { N } | + \frac { M } { 2 } \left [ 1 + \ln ( 2 \pi ) \right ] } \\ & { - \mathbb { E } [ \ln q ( \alpha ) ] _ { \alpha } \, = \, \ln \Gamma ( a _ { N } ) - ( a _ { N } - 1 ) \psi ( a _ { N } ) - \ln b _ { N } + a _ { N } . \, ( 1 0 . 1 2 ) } \\ & { \text {Figure 10.9 shows a plot of the lower bound } \mathcal { L } ( q ) \text { versus the degree of a polynomial } } \end{array}
$$

$$
- \mathbb { E } [ \ln q ( w ) ] _ { w } & = \ \frac { 1 } { 2 } \ln | S _ { N } | + \frac { M } { 2 } \left [ 1 + \ln ( 2 \pi ) \right ] \\ - \mathbb { E } [ \ln q ( \alpha ) ] _ { \alpha } & = \ \ln \Gamma ( a _ { N } ) - ( a _ { N } - 1 ) \psi ( a _ { N } ) - \ln b _ { N } + a _ { N } . \ \ ( 1 . 1 1 2 ) \\ \intertext { i g u r o . 1 0 a s h o w s a l o t o f t h e l o w b o u n d c l e }
$$

Figure 10.9 shows a plot of the lower bound L ( q ) versus the degree of a polynomial model for a synthetic data set generated from a degree three polynomial. Here the prior parameters have been set to a 0 = b 0 = 0 , corresponding to the noninformative prior p ( α ) ∝ 1 /α , which is uniform over ln α as discussed in Section 2.3.6. As we saw in Section 10.1, the quantity L represents lower bound on the log marginal likelihood p ( t | M ) for the model. If we assign equal prior probabilities p ( M ) to the different values of M , then we can interpret L as an approximation to the posterior model probability p ( M | t ) . Thus the variational framework assigns the highest probability to the model with M = 3 . This should be contrasted with the maximum likelihood result, which assigns ever smaller residual error to models of increasing complexity until the residual error is driven to zero, causing maximum likelihood to favour severely over-ﬁtted models.
