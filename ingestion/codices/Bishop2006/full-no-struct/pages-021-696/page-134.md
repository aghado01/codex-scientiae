[Page 134]

which we can solve for µ to give µ = σ ( η ) , where

$$
\sigma ( \eta ) = \frac { 1 } { 1 + \exp ( - \eta ) } \quad ( 2 . 1 9 9 ) \\ \intertext { i a g i o d f o n t i o n } \left ( \sigma ( \eta ) = \frac { 1 } { 1 + \exp ( - \eta ) } \right ) \quad ( 2 . 1 9 9 )
$$

is called the logistic sigmoid function. Thus we can write the Bernoulli distribution using the standard representation (2.194) in the form

$$
p ( x | \eta ) & = \sigma ( - \eta ) \exp ( \eta x ) & ( 2 . 2 0 0 ) \\
$$

where we have used 1 − σ ( η ) = σ ( − η ) , which is easily proved from (2.199). Comparison with (2.194) shows that

$$
u ( x ) \ = \ x
$$

$$
h ( x ) \ = \ 1
$$

$$
g ( \eta ) \ = \ \sigma ( - \eta ) .
$$

Next consider the multinomial distribution that, for a single observation x , takes the form M M

$$
& \text {considre the multinomian distribution that, for a single observation, takes} \\ & \quad p ( x | \mu ) = \prod _ { k = 1 } ^ { M } \mu _ { k } ^ { x _ { k } } = \exp \left \{ \sum _ { k = 1 } ^ { M } x _ { k } \ln \mu _ { k } \right \} \\ & = ( x _ { 1 } , \dots , x _ { N } ) ^ { T } . \ \text { again, we can write this in the standard representation}
$$

where x = ( x 1 ,...,x N ) T . Again, we can write this in the standard representation (2.194) so that T

$$
p ( x | \eta ) = \exp ( \eta ^ { T } x ) & & ( 2 . 2 0 5 ) \\ \intertext { l o w h o v e d o f i n d e r }
$$

where η k = ln µ k , and we have deﬁned η = ( η 1 ,...,η M ) T . Again, comparing with (2.194) we have

$$
u ( x ) \ = \ x
$$

$$
h ( \mathbf x ) \ = \ 1
$$

$$
g ( \eta ) \ = \ 1 .
$$

Note that the parameters η k are not independent because the parameters µ k are subject to the constraint

$$
\sum _ { k = 1 } ^ { M } \mu _ { k } = 1 \\ \text {the parameters } \mu _ { k } , \, \text {the value of the remaining parameter}
$$

so that, given any M − 1 of the parameters µ k , the value of the remaining parameter is ﬁxed. In some circumstances, it will be convenient to remove this constraint by expressing the distribution in terms of only M − 1 parameters. This can be achieved by using the relationship (2.209) to eliminate µ M by expressing it in terms of the remaining { µ k } where k = 1 ,...,M − 1 , thereby leaving M − 1 parameters. Note that these remaining parameters are still subject to the constraints

$$
0 \leqslant \mu _ { k } \leqslant 1 , \quad \sum _ { k = 1 } ^ { M - 1 } \mu _ { k } \leqslant 1 .
$$
