[Page 648]

Exercise 13.15

From the product rule, we then have

$$
p ( x _ { 1 } , \dots , x _ { n } ) = \prod _ { m = 1 } ^ { n } c _ { m }
$$

and so

$$
and \text { so } & & \alpha ( z _ { n } ) = p ( z _ { n } | x _ { 1 } , \dots , x _ { n } ) p ( x _ { 1 } , \dots , x _ { n } ) = \left ( \prod _ { m = 1 } ^ { n } c _ { m } \right ) \hat { \alpha } ( z _ { n } ) . \\ & \text { We can then turn the recursion equation (13.36) for $\alpha$ into one for $\hat{ \alpha}$ given by }
$$

$$
\text { then turn the recursion equation (13.36) for $\alpha$ into one for $\hat{ \alpha}$ given by} \\ c _ { n } \widehat { \alpha } ( z _ { n } ) = p ( x _ { n } | z _ { n } ) \sum _ { z _ { n - 1 } } \widehat { \alpha } ( z _ { n - 1 } ) p ( z _ { n } | z _ { n - 1 } ) . \\ \text { that at each stage of the forward message passing phase, used to evaluate $\widehat{ \alpha} ( z _ { n } )$,} \\ \text { to evaluate and store $\widehat{ c}$, which is easily done because it is the coefficient}
$$

Note that at each stage of the forward message passing phase, used to evaluate α ( z n ) , we have to evaluate and store c n , which is easily done because it is the coefﬁcient that normalizes the right-hand side of (13.59) to give α ( z n ) . We can similarly deﬁne re-scaled variables β ( z n ) using N

$$
\text {the right-hand side of } ( 1 3 . 5 9 ) \text { to give } \widehat { \alpha } ( z _ { n } ) . \\ \text {largely define re-scaled variables } \widehat { \beta } ( z _ { n } ) \text { using} \\ \beta ( z _ { n } ) = \left ( \prod _ { m = n + 1 } ^ { N } c _ { m } \right ) \widehat { \beta } ( z _ { n } ) & & ( 1 3 . 6 0 ) \\ \intertext { a l r e \text {the $-scaled variables $\widehat{ }beta$} ( z _ { n } ) \text { using} } \text { remain within machine precision because, from } ( 1 3 . 3 5 ) , \text { the quan-} \\ \text { simply the ratio of two conditional probabilities}
$$

which will again remain within machine precision because, from (13.35), the quantities β ( z n ) are simply the ratio of two conditional probabilities β ( z n ) = p ( x n +1 ,..., x N | z n ) p ( x n +1 ,..., x N x 1 ,..., x n ) . (13.61)

$$
\widehat { \beta } ( z _ { n } ) = \frac { p ( x _ { n + 1 } , \dots , x _ { N } | z _ { n } ) } { p ( x _ { n + 1 } , \dots , x _ { N } | x _ { 1 } , \dots , x _ { n } ) } . \\ \text {option result (13.38) for } \beta \text { then gives the following recursion for the re-scaled}
$$

The recursion result (13.38) for β then gives the following recursion for the re-scaled variables

$$
\text {recursion result} \, ( 1 . 3 ) \, \text {for} \, \text {then} \, \text {gives the following recursion for the scaled} \\ \text {variables} & & c _ { n + 1 } \widehat { \beta } ( z _ { n } ) = \sum _ { z _ { n + 1 } } \widehat { \beta } ( z _ { n + 1 } ) p ( x _ { n + 1 } | z _ { n + 1 } ) p ( z _ { n + 1 } | z _ { n } ) . \\ \intertext { a p l y } \text {applying this recursion relation, we make use of the scaling factors } c _ { n } \text { that were} \\ \text {widely computed in the } \text {o phase}
$$

In applying this recursion relation, we make use of the scaling factors c n that were previously computed in the α phase.

From (13.57), we see that the likelihood function can be found using

$$
p ( X ) = \prod _ { n = 1 } ^ { N } c _ { n } . & & ( 1 3 . 6 3 ) \\ \intertext { a n d ( 1 3 4 ) } \intertext { o t h e r w i t h ( 1 3 6 ) }
$$

Similarly, using (13.33) and (13.43), together with (13.63), we see that the required marginals are given by

$$
\gamma ( z _ { n } ) \ & = \ \widehat { \alpha } ( z _ { n } ) \widehat { \beta } ( z _ { n } ) \\ \xi ( z _ { n - 1 } , z _ { n } ) \ & = \ c _ { n } \widehat { \alpha } ( z _ { n - 1 } ) p ( x _ { n } | z _ { n } ) p ( z _ { n } | z _ { - 1 } ) \widehat { \beta } ( z _ { n } ) .
$$
