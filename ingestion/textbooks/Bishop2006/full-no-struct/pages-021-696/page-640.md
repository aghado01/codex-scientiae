[Page 640]

$$
\gamma ( z _ { n } ) = p ( z _ { n } | X ) = \frac { p ( X | z _ { n } ) p ( z _ { n } ) } { p ( X ) } .
$$

Note that the denominator p ( X ) is implicitly conditioned on the parameters θ old of the HMM and hence represents the likelihood function. Using the conditional independence property (13.24), together with the product rule of probability, we obtain

$$
\gamma ( z _ { n } ) = \frac { p ( x _ { 1 } , \dots , x _ { n } , z _ { n } ) p ( x _ { n + 1 } , \dots , x _ { N } | z _ { n } ) } { p ( X ) } = \frac { \alpha ( z _ { n } ) \beta ( z _ { n } ) } { p ( X ) } \quad ( 1 3 . 3 3 )
$$

where we have deﬁned

$$
\alpha ( z _ { n } ) & \ \equiv \ p ( x _ { 1 } , \dots , x _ { n } , z _ { n } ) & & ( 1 3 . 3 4 ) \\ \beta ( z _ { n } ) & \ \equiv \ p ( x _ { n } + \quad x _ { n } | z _ { n } ) & & ( 1 3 . 3 5 )
$$

$$
\beta ( z _ { n } ) \ \equiv \ p ( x _ { n + 1 } , \dots , x _ { N } | z _ { n } ) . \\ ( - \, _ { n } ) \ \underset { \ } { \underset { \ } { \ } } \ n \, \underset { \ } { \ } \ t h \colon \, i \sin t \, \underset { \ } { \ } \ t h \colon \, i \sin t \, \underset { \ } { \ } \ t h \cdot \, _ { n } \, \underset { \ } { \ } \ t h \cdot \, _ { n + 1 } \, \underset { \ } { \ } \ t h
$$

The quantity α ( z n ) represents the joint probability of observing all of the given data up to time n and the value of z n , whereas β ( z n ) represents the conditional probability of all future data from time n + 1 up to N given the value of z n . Again, α ( z n ) and β ( z n ) each represent set of K numbers, one for each of the possible settings of the 1-ofK coded binary vector z n . We shall use the notation α ( z nk ) to denote the value of α ( z n ) when z nk = 1 , with an analogous interpretation of β ( z nk ) . ( z ) ( z )

We now derive recursion relations that allow α n and β n to be evaluated efﬁciently. Again, we shall make use of conditional independence properties, in particular (13.25) and (13.26), together with the sum and product rules, allowing us to express α ( z n ) in terms of α ( z n − 1 ) as follows

$$
particular ( 1 3 . 2 5 ) \text { and ( 1 3 . 2 6), together with the sum and product rules, allowing us} \\ to express \alpha ( z _ { n } ) \text { in terms of } \alpha ( z _ { n - 1 } ) \text { as follows} \\ \alpha ( z _ { n } ) \quad = \quad p ( x _ { 1 } , \dots , x _ { n } , z _ { n } ) \\ \quad = \quad p ( x _ { 1 } , \dots , x _ { n } | z _ { n } ) p ( z _ { n } ) \\ \quad = \quad p ( x _ { n } | z _ { n } ) p ( x _ { 1 } , \dots , x _ { n - 1 } | z _ { n } ) p ( z _ { n } ) \\ \quad = \quad p ( x _ { n } | z _ { n } ) \sum _ { z _ { n - 1 } } p ( x _ { 1 } , \dots , x _ { n - 1 } , z _ { n - 1 } , z _ { n } ) \\ \quad = \quad p ( x _ { n } | z _ { n } ) \sum _ { z _ { n - 1 } } p ( x _ { 1 } , \dots , x _ { n - 1 } , z _ { n } | z _ { n - 1 } ) p ( z _ { n - 1 } ) \\ \quad = \quad p ( x _ { n } | z _ { n } ) \sum _ { z _ { n - 1 } } p ( x _ { 1 } , \dots , x _ { n - 1 } | z _ { n - 1 } ) p ( z _ { n - 1 } ) p ( z _ { n - 1 } ) \\ \quad = \quad p ( x _ { n } | z _ { n } ) \sum _ { z _ { n - 1 } } p ( x _ { 1 } , \dots , x _ { n - 1 } , z _ { n - 1 } ) p ( z _ { n } | z _ { n - 1 } ) \\ \quad = \quad p ( x _ { n } | z _ { n } ) \sum _ { z _ { n - 1 } } p ( x _ { 1 } , \dots , x _ { n - 1 } , z _ { n - 1 } ) p ( z _ { n } | z _ { n - 1 } ) \\ \quad \text {Making use of the definition (13.34) for } \alpha ( z _ { n } ) , \text { we then obtain } \\ \alpha ( z _ { n } ) = p ( x _ { n } | z _ { n } ) \sum _ { \alpha ( z _ { n - 1 } ) } \alpha ( z _ { n - 1 } ) p ( z _ { n } | z _ { n - 1 } ) .
$$

Making use of the deﬁnition (13.34) for α ( z n ) , we then obtain

$$
\text {use of the definition (13.54) for $\alpha(z_{n}), \text {we then obtain} } \\ \alpha ( z _ { n } ) = p ( x _ { n } | z _ { n } ) \sum _ { z _ { n - 1 } } \alpha ( z _ { n - 1 } ) p ( z _ { n } | z _ { n - 1 } ) .
$$
