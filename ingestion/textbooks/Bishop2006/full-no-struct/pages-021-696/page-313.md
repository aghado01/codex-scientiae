[Page 313]

# 6.1. Dual Representations

Many linear models for regression and classiﬁcation can be reformulated in terms of a dual representation in which the kernel function arises naturally. This concept will play an important role when we consider support vector machines in the next chapter. Here we consider a linear regression model whose parameters are determined by minimizing a regularized sum-of-squares error function given by

$$
J ( w ) = \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \left \{ w ^ { T } \phi ( x _ { n } ) - t _ { n } \right \} ^ { 2 } + \frac { \lambda } { 2 } w ^ { T } w \\ \ > 0 \ \text {If we set the gradient of } J ( w ) \text { with respect to } w \text { equal to zero } \text { we see}
$$

where λ 0 . If we set the gradient of J ( w ) with respect to w equal to zero, we see that the solution for w takes the form of a linear combination of the vectors φ ( x n ) , with coefﬁcients that are functions of w , of the form

$$
w = - \frac { 1 } { \lambda } \sum _ { n = 1 } ^ { N } \left \{ w ^ { T } \phi ( x _ { n } ) - t _ { n } \right \} \phi ( x _ { n } ) = \sum _ { n = 1 } ^ { N } a _ { n } \phi ( x _ { n } ) = \Phi ^ { T } a \quad ( 6 . 3 ) \\ \intertext { w h e r $ \Phi $ is the design matrix $ w h o s e $ $ n $ }
$$

where Φ is the design matrix, whose n th row is given by φ ( x n ) T . Here the vector a = ( a 1 ,...,a N ) T , and we have deﬁned

$$
a _ { n } = - \frac { 1 } { \lambda } \left \{ w ^ { T } \phi ( x _ { n } ) - t _ { n } \right \} . \\ \intertext { g n } \text { with the parameter vector } w , \text { we can now reformulate the least- } \\ \text {in terms of the parameter vector } a _ { \ } g i v i n g \text { rise to } a _ { \ } d u l \, r e p r e s e n _ { n }
$$

Instead of working with the parameter vector w , we can now reformulate the leastsquares algorithm in terms of the parameter vector a , giving rise to a dual representation . If we substitute w = Φ T a into J ( w ) , we obtain

$$
J ( a ) = \frac { 1 } { 2 } a ^ { T } \Phi \Phi ^ { T } \Phi \Phi ^ { T } a - a ^ { T } \Phi \Phi ^ { T } t + \frac { 1 } { 2 } t ^ { T } t + \frac { \lambda } { 2 } a ^ { T } \Phi \Phi ^ { T } a \quad
$$

where t = ( t 1 ,...,t N ) T . We now deﬁne the Gram matrix K = ΦΦ T , which is an N × N symmetric matrix with elements

$$
K _ { n m } = \phi ( x _ { n } ) ^ { T } \phi ( x _ { m } ) = k ( x _ { n } , x _ { m } )
$$

where we have introduced the kernel function k ( x , x ) deﬁned by (6.1). In terms of the Gram matrix, the sum-of-squares error function can be written as

$$
J ( a ) = \frac { 1 } { 2 } a ^ { T } K K a - a ^ { T } K t + \frac { 1 } { 2 } t ^ { T } t + \frac { \lambda } { 2 } a ^ { T } K a .
$$

Setting the gradient of J ( a ) with respect to a to zero, we obtain the following solution 1

$$
a = ( K + \lambda I _ { N } ) ^ { - 1 } \mathfrak { t } .
$$
