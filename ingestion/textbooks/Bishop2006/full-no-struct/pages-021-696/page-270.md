[Page 270]

An important consideration for many applications of the Hessian is the efﬁciency with which it can be evaluated. If there are W parameters (weights and biases) in the network, then the Hessian matrix has dimensions W × W and so the computational effort needed to evaluate the Hessian will scale like O ( W 2 ) for each pattern in the data set. As we shall see, there are efﬁcient methods for evaluating the Hessian whose scaling is indeed O ( W 2 ) .

# 5.4.1 Diagonal approximation

Some of the applications for the Hessian matrix discussed above require the inverse of the Hessian, rather than the Hessian itself. For this reason, there has been some interest in using a diagonal approximation to the Hessian, in other words one that simply replaces the off-diagonal elements with zeros, because its inverse is trivial to evaluate. Again, we shall consider an error function that consists of a sum of terms, one for each pattern in the data set, so that E = n E n . The Hessian can then be obtained by considering one pattern at a time, and then summing the results over all patterns. From (5.48), the diagonal elements of the Hessian, for pattern n , can be written ∂ 2 E ∂ 2 E

$$
\frac { \partial ^ { 2 } E _ { n } } { \partial w _ { j i } ^ { 2 } } = \frac { \partial ^ { 2 } E _ { n } } { \partial a _ { j } ^ { 2 } } z _ { i } ^ { 2 } .
$$

Using (5.48) and (5.49), the second derivatives on the right-hand side of (5.79) can be found recursively using the chain rule of differential calculus to give a backpropagation equation of the form

$$
\frac { \partial ^ { 2 } E _ { n } } { \partial a _ { j } ^ { 2 } } = h ^ { \prime } ( a _ { j } ) ^ { 2 } \sum _ { k } \sum _ { k ^ { \prime } } w _ { k j } w _ { k ^ { \prime } j } \frac { \partial ^ { 2 } E _ { n } } { \partial a _ { k } \partial a _ { k ^ { \prime } } } + h ^ { \prime \prime } ( a _ { j } ) \sum _ { k } w _ { k j } \frac { \partial E ^ { n } } { \partial a _ { k } } . \\ \\ \text {If we now neglect off diagonal elements in the second derivative terms, we obtain}
$$

If we now neglect off-diagonal elements in the second-derivative terms, we obtain (Becker and Le Cun, 1989; Le Cun et al. , 1990)

$$
\frac { \partial ^ { 2 } E _ { n } } { \partial a _ { j } ^ { 2 } } = h ^ { \prime } ( a _ { j } ) ^ { 2 } \sum _ { k } w _ { k j } ^ { 2 } \frac { \partial ^ { 2 } E _ { n } } { \partial a _ { k } ^ { 2 } } + h ^ { \prime \prime } ( a _ { j } ) \sum _ { k } w _ { k j } \frac { \partial E _ { n } } { \partial a _ { k } } . \\ \\ \intertext { t o t h t h e n b o r $ o m p u t i o n $ l e p t o r s $ o r w i r o d $ t o v o l u v o t h e s o r p o r x i m o t i o n }
$$

Note that the number of computational steps required to evaluate this approximation is O ( W ) , where W is the total number of weight and bias parameters in the network, compared with O ( W 2 ) for the full Hessian.

Ricotti et al. (1988) also used the diagonal approximation to the Hessian, but they retained all terms in the evaluation of ∂ 2 E n /∂a 2 j and so obtained exact expressions for the diagonal terms. Note that this no longer has O ( W ) scaling. The major problem with diagonal approximations, however, is that in practice the Hessian is typically found to be strongly nondiagonal, and so these approximations, which are driven mainly be computational convenience, must be treated with care.
