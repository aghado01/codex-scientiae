[Page 6]

$$
y _ { i j } & = \sum _ { l = 1 } ^ { k } b _ { i l } ( x _ { i j } ^ { \prime } \mu _ { l } ) _ { + } + \epsilon _ { i j }, \\
$$

where ￿ ij iid ∼ N (0, τ − 1 ). The value of the j th response of subject i is approximated by a linear combination of the positive portion (denoted by the + subscript) of the inner products of the basis functions with the covariate vector, x ij.We require that each model contain an intercept basis, so we deﬁne ( x ￿ ij µ 1 ) + ≡ 1 for all i,j.We extend previous methods by allowing the spline coeﬃcients, b i to be subject-speciﬁc, assuming that observations within subject i are conditionally independent given b i .

Each piecewise linear model is linear in the basis function transformations of the covariate vectors:

$$
y _ { i } = \theta _ { i } b _ { i } + \epsilon _ { i },
$$

where y i and ￿ i are the n i × 1 vectors of responses and random errors and b i is the k × 1 vector of subject speciﬁc basis coeﬃcients for subject i.The n i × k design matrix, θ i, contains the basis function transformations of the covariate vectors for subject i :

$$
\begin{array} { r } { b a s i s f u n c t i o n t r a m s t i m a t i o n s o f t h e c o v a r i a t e v e c t o r s } \\ { \theta _ { i } = \left ( \begin{array} { c c c c } 1 & ( x _ { i 1 } ^ { \prime } \mu _ { 2 } ) _ { + } & \dots & ( x _ { i 1 } ^ { \prime } \mu _ { k } ) _ { + } \\ 1 & ( x _ { i 2 } ^ { \prime } \mu _ { 2 } ) _ { + } & \dots & ( x _ { i 2 } ^ { \prime } \mu _ { k } ) _ { + } \\ \vdots & \vdots & \vdots & \vdots \\ 1 & ( x _ { i n _ { i } } ^ { \prime } \mu _ { 2 } ) _ { + } & \dots & ( x _ { i n _ { i } } ^ { \prime } \mu _ { k } ) _ { + } \end{array} \right ) } \\ { o n l y t h e p o s i t i v e p o r t i o n o f e a c h l e a r s p l i n e, i t i s } \end{array}
$$

Since we use only the positive portion of each linear spline, it is possible that a basis function does not contribute to the model for a given subject (i.e. θ i contains a column of zeros, which is non-informative about the corresponding element of b i ). To address this problem, we standardize each column of the population design matrix, Θ = ( θ ￿ 1,..., θ ￿ m ) ￿, to have mean 0 and variance 1. Assuming independent subjects, this model speciﬁcation yields the likelihood:

$$
L ( y | b, \tau, M ) \, \in \prod _ { i = 1 } ^ { m } \tau ^ { \frac { n _ { i } } { 2 } } \, e x p [ - \, \frac { \tau } { 2 } ( y _ { i } - \theta _ { i } b _ { i } ) ^ { \prime } ( y _ { i } - \theta _ { i } b _ { i } ) ] \quad \\
$$
