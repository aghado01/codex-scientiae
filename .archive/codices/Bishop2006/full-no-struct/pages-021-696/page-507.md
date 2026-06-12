[Page 507]

α

![image 240](../images/imageFile240.png)

φ

n

β

w

t

n

N

posterior distribution given by the factorized expression

$$
q ( \mathbf w , \alpha ) = q ( \mathbf w ) q ( \alpha ) .
$$

We can ﬁnd re-estimation equations for the factors in this distribution by making use of the general result (10.9). Recall that for each factor, we take the log of the joint distribution over all variables and then average with respect to those variables not in that factor. Consider ﬁrst the distribution over α . Keeping only terms that have a functional dependence on α , we have

$$
\ln q ^ { * } ( \alpha ) & = \ln p ( \alpha ) + \mathbb { E } _ { w } \left [ \ln p ( w | \alpha ) \right ] + \text {const} \\ & = \quad ( a _ { 0 } - 1 ) \ln \alpha - b _ { 0 } \alpha + \frac { M } { 2 } \ln \alpha - \frac { \alpha } { 2 } \mathbb { E } [ w ^ { T } w ] + \text {const} .
$$

$$
( a _ { 0 } - 1 ) \ln \alpha - b _ { 0 } \alpha + \frac { M } { 2 } \ln \alpha - \frac { \alpha } { 2 } \mathbb { E } [ w ^ { T }
$$

We recognize this as the log of a gamma distribution, and so identifying the coefﬁcients of α and ln α we obtain

where

$$
q ^ { * } ( \alpha ) = G a m ( \alpha | a _ { N } , b _ { N } )
$$

$$
a _ { N } \ = \ a _ { 0 } + \frac { M } { 2 } \quad \ \ ( 1 0 . 9 4 )
$$

$$
b _ { N } \ = \ b _ { 0 } + \frac { 1 } { 2 } \mathbb { E } [ \mathbf w ^ { \mathrm T } \mathbf w ] .
$$

Similarly, we can ﬁnd the variational re-estimation equation for the posterior distribution over w . Again, using the general result (10.9), and keeping only those terms that have a functional dependence on w , we have

$$
\ln q ^ { * } ( \mathbf w ) \ = \ \ln p ( \mathbf t | \mathbf w ) + \mathbb { E } _ { \alpha } \left [ \ln p ( \mathbf w | \alpha ) \right ] + \text {const} \\
$$

$$
\begin{array} { r l } { \frac { \beta } { 4 } ( t ) ^ { 2 } } & { = } & { - \frac { \beta } { 2 } \sum _ { n = 1 } ^ { N } \{ w ^ { T } \phi _ { n } - t _ { n } \} ^ { 2 } - \frac { 1 } { 2 } \mathbb { E } [ \alpha ] w ^ { T } w + c o n s t } \\ & { = } & { - \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \{ w ^ { T } ( \mathbb { E } [ \alpha ] U + \beta \Phi ^ { T } \Phi ) w + \beta w ^ { T } \Phi ^ { T } t + c o n s t } \end{array}
$$

$$
n = 1 \\ = \ - \frac { 1 } { 2 } w ^ { T } \left ( \mathbb { E } [ \alpha ] I + \beta \Phi ^ { T } \Phi \right ) w + \beta w ^ { T } \Phi ^ { T } t + \text {const.} \quad ( 1 0 . 9 8 ) \\ \text {use this is a quadratic form, the distribution } q ^ { * } ( w ) \text { is Gaussian, and so we can }
$$

Because this is a quadratic form, the distribution q ( w ) is Gaussian, and so we can complete the square in the usual way to identify the mean and covariance, giving

$$
q ^ { * } ( w ) = \mathcal { N } ( w | m _ { N } , S _ { N } )
$$
