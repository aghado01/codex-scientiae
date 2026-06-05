[Page 212]

$$
s _ { W } = \sum _ { k = 1 } ^ { K } \sum _ { n \in \mathcal { C } _ { k } } ( y _ { n } - \mu _ { k } ) ( y _ { n } - \mu _ { k } ) ^ { \top }
$$

and

$$
s _ { B } = \sum _ { k = 1 } ^ { K } N _ { k } ( \mu _ { k } - \mu ) ( \mu _ { k } - \mu ) ^ { \top }
$$

where

$$
\mu _ { k } = \frac { 1 } { N _ { k } } \sum _ { n \in \mathcal { C } _ { k } } y _ { n } , \quad \mu = \frac { 1 } { N } \sum _ { k = 1 } ^ { K } N _ { k } \mu _ { k } . \\ \text {we wish to construct a scalar that is large when the between-class covariance}
$$

Again we wish to construct a scalar that is large when the between-class covariance is large and when the within-class covariance is small. There are now many possible choices of criterion (Fukunaga, 1990). One example is given by

$$
J ( W ) = & \text {Tr} \left \{ s _ { W } ^ { - 1 } s _ { B } \right \} . \\ \intertext { e n b e r w i tten as an expliciit function of the projection matrix }
$$

This criterion can then be rewritten as an explicit function of the projection matrix W in the form J ( w ) = Tr ( WS W W T ) − 1 ( WS B W T ) . (4.51) Maximization of such criteria is straightforward, though somewhat involved, and is discussed at length in Fukunaga (1990). The weight values are determined by those eigenvectors of S − 1 W S B that correspond to the D largest eigenvalues.

There is one important result that is common to all such criteria, which is worth emphasizing. We ﬁrst note from (4.46) that S B is composed of the sum of K matrices, each of which is an outer product of two vectors and therefore of rank 1. In addition, only ( K − 1) of these matrices are independent as a result of the constraint (4.44). Thus, S B has rank at most equal to ( K − 1) and so there are at most ( K − 1) nonzero eigenvalues. This shows that the projection onto the ( K − 1) -dimensional subspace spanned by the eigenvectors of S B does not alter the value of J ( w ) , and so we are therefore unable to ﬁnd more than ( K − 1) linear ‘features’ by this means (Fukunaga, 1990).

# 4.1.7 The perceptron algorithm

Another example of a linear discriminant model is the perceptron of Rosenblatt (1962), which occupies an important place in the history of pattern recognition algorithms. It corresponds to a two-class model in which the input vector x is ﬁrst transformed using a ﬁxed nonlinear transformation to give a feature vector φ ( x ) , and this is then used to construct a generalized linear model of the form

$$
y ( x ) = f \left ( w ^ { T } \phi ( x ) \right )
$$
