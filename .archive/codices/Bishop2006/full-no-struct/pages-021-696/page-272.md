[Page 272]

# Exercise 5.21

We can use the outer-product approximation to develop a computationally efﬁcient procedure for approximating the inverse of the Hessian (Hassibi and Stork, 1993). First we write the outer-product approximation in matrix notation as

$$
H _ { N } = \sum _ { n = 1 } ^ { N } b _ { n } b _ { n } ^ { T } \\ \intertext { h e c t r i b u t i o n t } \intertext { the c o n t r i b u t i o n } \intertext { h e c t r i b u t i o n t a c t i v a t i o n }
$$

where b n ≡ ∇ w a n is the contribution to the gradient of the output unit activation arising from data point n . We now derive a sequential procedure for building up the Hessian by including data points one at a time. Suppose we have already obtained the inverse Hessian using the ﬁrst L data points. By separating off the contribution from data point L + 1 , we obtain

$$
H _ { L + 1 } = H _ { L } + b _ { L + 1 } b _ { L + 1 } ^ { T } .
$$

In order to evaluate the inverse of the Hessian, we now consider the matrix identity

$$
r \, \text {to evaluate the inverse of the Hessian, we now consider the matrix identity} \\ ( M + v \mathbf v ^ { \top } ) ^ { - 1 } = M ^ { - 1 } - \frac { ( M ^ { - 1 } v ) \left ( v ^ { \top } M ^ { - 1 } \right ) } { 1 + v ^ { \top } M ^ { - 1 } v } \\ I \, \text {is the unit matrix, which is simply a special case of the Woodbury identity} \\ \text {If we now identify H, with M and b, with $v$ we obtain}
$$

where I is the unit matrix, which is simply a special case of the Woodbury identity (C.7). If we now identify H L with M and b L +1 with v , we obtain

$$
H _ { L + 1 } ^ { - 1 } = H _ { L } ^ { - 1 } - \frac { H _ { L } ^ { - 1 } b _ { L + 1 } b _ { L + 1 } ^ { T } H _ { L } ^ { - 1 } } { 1 + b _ { L + 1 } ^ { T } H _ { L } ^ { - 1 } b _ { L + 1 } } .
$$

In this way, data points are sequentially absorbed until L +1 = N and the whole data set has been processed. This result therefore represents a procedure for evaluating the inverse of the Hessian using a single pass through the data set. The initial matrix H 0 is chosen to be α I , where α is a small quantity, so that the algorithm actually ﬁnds the inverse of H + α I . The results are not particularly sensitive to the precise value of α . Extension of this algorithm to networks having more than one output is straightforward.

We note here that the Hessian matrix can sometimes be calculated indirectly as part of the network training algorithm. In particular, quasi-Newton nonlinear optimization algorithms gradually build up an approximation to the inverse of the Hessian during training. Such algorithms are discussed in detail in Bishop and Nabney (2008).

# 5.4.4 Finite differences

As in the case of the ﬁrst derivatives of the error function, we can ﬁnd the second derivatives by using ﬁnite differences, with accuracy limited by numerical precision. If we perturb each possible pair of weights in turn, we obtain

$$
\frac { \partial ^ { 2 } E } { \partial w _ { j i } \partial w _ { l k } } & = \frac { 1 } { 4 \epsilon ^ { 2 } } \left \{ E ( w _ { j i } + \epsilon , w _ { l k } + \epsilon ) - E ( w _ { j i } + \epsilon , w _ { l k } - \epsilon ) \\ & - E ( w _ { j i } - \epsilon , w _ { l k } + \epsilon ) + E ( w _ { j i } - \epsilon , w _ { l k } - \epsilon ) \right \} + O ( \epsilon ^ { 2 } ) .
$$
