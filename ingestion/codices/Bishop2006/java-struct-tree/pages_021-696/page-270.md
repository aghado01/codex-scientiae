[Page 270]

An important consideration for many applications of the Hessian is the efﬁciency with which it can be evaluated. If there are W parameters (weights and biases) in the network, then the Hessian matrix has dimensions W × W and so the computational effort needed to evaluate the Hessian will scale like O(W2) for each pattern in the data set. As we shall see, there are efﬁcient methods for evaluating the Hessian whose scaling is indeed O(W2).

5.4.1 Diagonal approximation

Some of the applications for the Hessian matrix discussed above require the inverse of the Hessian, rather than the Hessian itself. For this reason, there has been some interest in using a diagonal approximation to the Hessian, in other words one that simply replaces the off-diagonal elements with zeros, because its inverse is trivial to evaluate. Again, we shall consider an error function that consists of a sum of terms, one for each pattern in the data set, so that E =

�

n En. The Hessian can then be obtained by considering one pattern at a time, and then summing the results over all patterns. From (5.48), the diagonal elements of the Hessian, for pattern n, can be written

∂2En ∂wji2

∂2En ∂a2j

=

zi2. (5.79)

Using (5.48) and (5.49), the second derivatives on the right-hand side of (5.79) can be found recursively using the chain rule of differential calculus to give a backpropagation equation of the form

�

�

�

∂En ∂ak

∂2En ∂a2j

∂2En ∂ak∂ak�

= h�(aj)2

+ h��(aj)

. (5.80)

wkjwk�j

wkj

k�

k

k

If we now neglect off-diagonal elements in the second-derivative terms, we obtain (Becker and Le Cun, 1989; Le Cun et al., 1990)

�

�

∂2En ∂a2j

∂2En ∂a2k

∂En ∂ak

= h�(aj)2

+ h��(aj)

wkj2

. (5.81)

wkj

k

k

Note that the number of computational steps required to evaluate this approximation is O(W), where W is the total number of weight and bias parameters in the network, compared with O(W2) for the full Hessian.

Ricotti et al. (1988) also used the diagonal approximation to the Hessian, but they retained all terms in the evaluation of ∂2En/∂a2j and so obtained exact expressions for the diagonal terms. Note that this no longer has O(W) scaling. The major problem with diagonal approximations, however, is that in practice the Hessian is typically found to be strongly nondiagonal, and so these approximations, which are driven mainly be computational convenience, must be treated with care.
