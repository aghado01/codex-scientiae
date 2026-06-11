[Page 116]

$$
\mathbb { E } \left [ ( z - f ) ^ { 2 } \left | \theta \right ] < \infty \\ \text {without loss of generality, consider the case where } f ( \theta ) > 0 \text { for } \\ \text {for } \theta < \theta ^ { * } , \text { as is the case in Figure 2.10. The Robbins-Monro}
$$

$$
\theta ^ { ( N ) } = \theta ^ { ( N - 1 ) } + a _ { N - 1 } z ( \theta ^ { ( N - 1 ) } )
$$

where z ( θ ( N ) ) is an observed value of z when θ takes the value θ ( N ) . The coefﬁcients { a N } represent a sequence of positive numbers that satisfy the conditions

$$
\lim _ { N \to \infty } a _ { N } \ = \ 0 \\ \infty
$$

$$
\sum _ { N = 1 } ^ { \infty } a _ { N } \ = \ \infty \\ \sum _ { N = 1 } ^ { \infty } a _ { N } \ = \ \infty
$$

$$
\sum _ { N = 1 } ^ { \infty } a _ { N } ^ { 2 } \ \ < \ \infty . \\ \intertext { b b i n s a n d M o r o r }
$$

It can then be shown (Robbins and Monro, 1951; Fukunaga, 1990) that the sequence of estimates given by (2.129) does indeed converge to the root with probability one. Note that the ﬁrst condition (2.130) ensures that the successive corrections decrease in magnitude so that the process can converge to a limiting value. The second condition (2.131) is required to ensure that the algorithm does not converge short of the root, and the third condition (2.132) is needed to ensure that the accumulated noise has ﬁnite variance and hence does not spoil convergence.

Now let us consider how a general maximum likelihood problem can be solved sequentially using the Robbins-Monro algorithm. By deﬁnition, the maximum likelihood solution θ ML is a stationary point of the log likelihood function and hence satisﬁes N

$$
\text {on } \theta _ { M L } \text { is a stationary point of the log likelihood function and hence} \\ \frac { \partial } { \partial \theta } \left \{ \frac { 1 } { N } \sum _ { n = 1 } ^ { N } \ln p ( x _ { n } | \theta ) \right \} & | _ { \theta _ { M L } } = 0 . \\ \text {the derivative and the summation, and taking the limit } N \to \infty \, \text {we have} \\ 1 & N \quad \text {a} \quad [ \, \ a \, ]
$$

Exchanging the derivative and the summation, and taking the limit N → ∞ we have

$$
\lim _ { N \to \infty } \frac { 1 } { N } \sum _ { n = 1 } ^ { N } \frac { \partial } { \partial \theta } \ln p ( x _ { n } | \theta ) = \mathbb { E } _ { x } \left [ \frac { \partial } { \partial \theta } \ln p ( x | \theta ) \right ] \quad ( 2 . 1 3 ) \\ \intertext { s o w e s e t h a r d i n f i n g u m i m u p l i k l i b o d o n s u l p o r s o n p d s }
$$

and so we see that ﬁnding the maximum likelihood solution corresponds to ﬁnding the root of a regression function. We can therefore apply the Robbins-Monro procedure, which now takes the form

$$
\theta ^ { ( N ) } = \theta ^ { ( N - 1 ) } + a _ { N - 1 } \frac { \partial } { \partial \theta ^ { ( N - 1 ) } } \ln p ( x _ { N } | \theta ^ { ( N - 1 ) } ) . \quad ( 2 . 1 3 5 )
$$
