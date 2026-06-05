[Page 524]

With this factorization we can appeal to the general result (10.9) to ﬁnd expressions for the optimal factors. Consider ﬁrst the distribution q ( w ) . Discarding terms that are independent of w , we have

$$
\begin{array} { r l } { \ln q ( w ) } & = } & { \mathbb { E } _ { \alpha } \left [ \ln \{ h ( w , \xi ) p ( w | \alpha ) p ( \alpha ) \} \right ] + c o n s t } \\ & = } & { \ln h ( w , \xi ) + \mathbb { E } _ { \alpha } \left [ \ln p ( w | \alpha ) \right ] + c o n s t . } \end{array}
$$

We now substitute for ln h ( w , ξ ) using (10.153), and for ln p ( w | α ) using (10.165), giving

$$
\ln q ( w ) & = - \frac { \mathbb { E } [ \alpha ] } { 2 } w ^ { T } w + \sum _ { n = 1 } ^ { N } \left \{ ( t _ { n } - 1 / 2 ) w ^ { T } \phi _ { n } - \lambda ( \xi _ { n } ) w ^ { T } \phi _ { n } \phi _ { n } ^ { T } w \right \} + \text {const.} \\ \intertext { W e s e t h a r i s a d u r a t i c function of w and so the solution for a ( w ) will be }
$$

We see that this is a quadratic function of w and so the solution for q ( w ) will be Gaussian. Completing the square in the usual way, we obtain

where we have deﬁned

$$
q ( \mathbf w ) = \mathcal { N } ( \mathbf w | \mu _ { N } , \Sigma _ { N } )
$$

$$
\Sigma _ { N } ^ { - 1 } \mu _ { N } \, = \, \sum _ { n = 1 } ^ { N } ( t _ { n } - 1 / 2 ) \phi _ { n } & & ( 1 0 . 1 7 5 ) \\
$$

$$
\Sigma _ { N } ^ { - 1 } \ = \ \mathbb { E } [ \alpha ] I + 2 \sum _ { n = 1 } ^ { N } \lambda ( \xi _ { n } ) \phi _ { n } \phi _ { n } ^ { T } . \quad ( 1 0 . 1 7 6 ) \\ \intertext { t h e n t i m l s o n t i o n for t h e f o r $ t $ a c h o w $ ( o v ) $ i $ s o n t i o n d f o r $ }
$$

Similarly, the optimal solution for the factor q ( α ) is obtained from

$$
\ln q ( \alpha ) = \mathbb { E } _ { w } \left [ \ln p ( w | \alpha ) \right ] + \ln p ( \alpha ) + \text {const} .
$$

Substituting for ln p ( w | α ) using (10.165), and for ln p ( α ) using (10.166), we obtain

$$
\ln q ( \alpha ) & = \frac { M } { 2 } \ln \alpha - \frac { \alpha } { 2 } \mathbb { E } \left [ w ^ { \top } w \right ] + ( a _ { 0 } - 1 ) \ln \alpha - b _ { 0 } \alpha + \text {const.} \\ \text {We recognize this as the log of a gamma distribution, and so we obtain}
$$

We recognize this as the log of a gamma distribution, and so we obtain

$$
q ( \alpha ) = G a m ( \alpha | a _ { N } , b _ { N } ) = \frac { 1 } { \Gamma ( a _ { 0 } ) } a _ { 0 } ^ { b _ { 0 } } \alpha ^ { a _ { 0 } - 1 } e ^ { - b _ { 0 } \alpha } \quad ( 1 0 . 1 7 7 )
$$

where Appendix B

$$
a _ { N } \ = \ a _ { 0 } + \frac { M } { 2 }
$$

$$
b _ { N } \ = \ b _ { 0 } + \frac { 1 } { 2 } \mathbb { E } _ { w } \left [ w ^ { \top } w \right ] .
$$
