[Page 525]

$$
& \text {ing over $\alpha$, we have} \\ & \quad \widetilde { \mathcal { L } } ( q , \xi ) = \int q ( w ) \ln h ( w , \xi ) \, d w + \text {const} . \\ & \text {this has precisely the same form as (10.159), and so we can again appear} \\ & \text {lier result (10.163), which can be obtained by direct optimization of the}
$$

Note that this has precisely the same form as (10.159), and so we can again appeal to our earlier result (10.163), which can be obtained by direct optimization of the marginal likelihood function, leading to re-estimation equations of the form

$$
\intertext { h i n o d u n c t i o n , l e a d i m a t i o n } ( \xi _ { n } ^ { \text {new} } ) ^ { 2 } = \phi _ { n } ^ { \text {T} } \left ( \Sigma _ { N } + \mu _ { N } \mu _ { N } ^ { \text {T} } \right ) \phi _ { n } . \\ \intertext { o b t a i n e d r e - e s t i m a t i o n } \text {after making suitable initializations, we can cycle through these quan-}
$$

We have obtained re-estimation equations for the three quantities q ( w ) , q ( α ) , and ξ , and so after making suitable initializations, we can cycle through these quantities, updating each in turn. The required moments are given by

$$
\mathbb { E } \left [ \alpha \right ] \ = \ \frac { a _ { N } } { b _ { N } } & & ( 1 0 . 1 8 2 ) \\ = \left [ \begin{array} { c c } \mathbb { E } \left [ \alpha \right ] & = & \frac { a _ { N } } { b _ { N } } & & & & ( 1 0 . 1 8 2 ) \\ \end{array} \right ]
$$

$$
\mathbb { E } \left [ w ^ { T } w \right ] \ = \ \Sigma _ { N } + \mu _ { N } ^ { T } \mu _ { N } .
$$

# 10.7. Expectation Propagation

We conclude this chapter by discussing an alternative form of deterministic approximate inference, known as expectation propagation or EP (Minka, 2001a; Minka, 2001b). As with the variational Bayes methods discussed so far, this too is based on the minimization of a Kullback-Leibler divergence but now of the reverse form, which gives the approximation rather different properties.

Consider for a moment the problem of minimizing KL( p q ) with respect to q ( z ) when p ( z ) is a ﬁxed distribution and q ( z ) is a member of the exponential family and so, from (2.194), can be written in the form

$$
4 ) , \, \text {can be written in the form} \\ q ( z ) = h ( z ) g ( \eta ) \exp \left \{ \eta ^ { \top } u ( z ) \right \} . \\ \text {of } \eta , \, \text {the Kullback-Leibler divergence then becomes}
$$

As a function of η , the Kullback-Leibler divergence then becomes

$$
K L ( p | | q ) = - \ln g ( \eta ) - \eta ^ { \top } \mathbb { E } _ { p ( z ) } [ u ( z ) ] + \text {const} \quad ( 1 0 . 1 8 5 ) \\
$$

where the constant terms are independent of the natural parameters η . We can minimize KL( p q ) within this family of distributions by setting the gradient with respect to η to zero, giving

$$
- \nabla \ln g ( \eta ) = \mathbb { E } _ { p ( z ) } [ \mathbf u ( z ) ] . \\ \intertext { b l o r o d y a n o s p n }
$$

However, we have already seen in (2.226) that the negative gradient of ln g ( η ) is given by the expectation of u ( z ) under the distribution q ( z ) . Equating these two results, we obtain

$$
\mathbb { E } _ { q ( z ) } [ \mathbf u ( z ) ] = \mathbb { E } _ { p ( z ) } [ \mathbf u ( z ) ] .
$$
