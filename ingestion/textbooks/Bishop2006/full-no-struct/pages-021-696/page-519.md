[Page 519]

$$
\sigma ( z ) \geqslant \sigma ( \xi ) \exp \left \{ ( z - \xi ) / 2 - \lambda ( \xi ) ( z ^ { 2 } - \xi ^ { 2 } ) \right \} \\
$$

$$
\lambda ( \xi ) = \frac { 1 } { 2 \xi } \left [ \sigma ( \xi ) - \frac { 1 } { 2 } \right ] .
$$

We can therefore write

$$
W \text { can refer to } & w \text {c} \\ p ( t | w ) = e ^ { a t } \sigma ( - a ) \geq e ^ { a t } \sigma ( \xi ) \exp \left \{ - ( a + \xi ) / 2 - \lambda ( \xi ) ( a ^ { 2 } - \xi ^ { 2 } ) \right \} . \quad ( 1 0 . 1 1 ) \\ & \text {Note that because this bound is applied to each of the terms in the likelihood function } \\ \text {constexprly, there is } & o \text {variational parameter} \, \xi \text {, corresponding to } \text {a} \text {, training set} \, \text { and }
$$

Note that because this bound is applied to each of the terms in the likelihood function separately, there is a variational parameter ξ n corresponding to each training set observation ( φ n ,t n ) . Using a = w T φ , and multiplying by the prior distribution, we obtain the following bound on the joint distribution of t and w

$$
p ( \mathbf t , \mathbf w ) = p ( \mathbf t | \mathbf w ) p ( \mathbf w ) \geqslant h ( \mathbf w , \xi ) p ( \mathbf w )
$$

where ξ denotes the set { ξ n } of variational parameters, and

$$
h ( w , \xi ) \ = \ \prod _ { n = 1 } ^ { N } \sigma ( \xi _ { n } ) \exp \left \{ w ^ { T } \phi _ { n } t _ { n } - ( w ^ { T } \phi _ { n } + \xi _ { n } ) / 2 \\ - \ \lambda ( \xi _ { n } ) ( [ w ^ { T } \phi _ { n } ] ^ { 2 } - \xi _ { n } ^ { 2 } ) \right \} . \\ \text {Evaluation of the exact posterior distribution would require normalization of the left-
hand side of this inequality.  Because this is instrucatable, we work instead with the
$$

Evaluation of the exact posterior distribution would require normalization of the lefthand side of this inequality. Because this is intractable, we work instead with the right-hand side. Note that the function on the right-hand side cannot be interpreted as a probability density because it is not normalized. Once it is normalized to give a variational posterior distribution q ( w ) , however, it no longer represents a bound.

Because the logarithm function is monotonically increasing, the inequality A B implies ln A ln B . This gives a lower bound on the log of the joint distribution of t and w of the form

$$
\ln \{ p ( t | w ) p ( w ) \} & \geqslant \ln p ( w ) + \sum _ { n = 1 } ^ { N } \left \{ \ln \sigma ( \xi _ { n } ) + w ^ { T } \phi _ { n } t _ { n } \\ & - ( w ^ { T } \phi _ { n } + \xi _ { n } ) / 2 - \lambda ( \xi _ { n } ) ( [ w ^ { T } \phi _ { n } ] ^ { 2 } - \xi _ { n } ^ { 2 } ) \right \} . \quad ( 1 0 . 1 5 4 ) \\ \intertext { t i t i t u g for the prior p ( w ) , the right-hand side of this inequacy he c o m e s , as a } \text {section of } w
$$

Substituting for the prior p ( w ) , the right-hand side of this inequality becomes, as a function of w

$$
f _ { \ } m a t h s c r { O } & = \frac { 1 } { - 2 } ( w - m _ { 0 } ) ^ { T } S _ { 0 } ^ { - 1 } ( w - m _ { 0 } ) \\ & + \sum _ { n = 1 } ^ { N } \{ w ^ { T } \phi _ { n } ( t _ { n } - 1 / 2 ) - \lambda ( \xi _ { n } ) w ^ { T } ( \phi _ { n } \phi _ { n } ^ { T } ) w \} + \text {const.} \quad ( 1 0 . 1 5 5 )
$$
