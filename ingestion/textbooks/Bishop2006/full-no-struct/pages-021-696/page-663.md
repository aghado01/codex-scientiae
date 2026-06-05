[Page 663]

$$
\mu _ { 0 } ^ { n e w } \ = \ \mathbb { E } [ z _ { 1 } ]
$$

$$
V _ { 0 } ^ { n e w } \ = \ \mathbb { E } [ z _ { 1 } z _ { 1 } ^ { T } ] - \mathbb { E } [ z _ { 1 } ] \mathbb { E } [ z _ { 1 } ^ { T } ] .
$$

Similarly, to optimize A and Γ , we substitute for p ( z n | z n − 1 , A , Γ ) in (13.108) using (13.75) giving

$$
Q ( \theta , \theta ^ { o l d } ) & = - \frac { N - 1 } { 2 } \ln | \Gamma | \\ - \mathbb { E } _ { Z | \theta ^ { o l d } } \left [ \frac { 1 } { 2 } \sum _ { n = 2 } ^ { N } ( z _ { n } - A z _ { n - 1 } ) ^ { T } \Gamma ^ { - 1 } ( z _ { n } - A z _ { n - 1 } ) \right ] + \text {const} \quad ( 1 3 . 1 2 ) \\ \intertext { i n \text { which the constant comprises terms that are independent of A and \Gamma . 1 } \maximizing }
$$

in which the constant comprises terms that are independent of A and Γ . Maximizing with respect to these parameters then gives

$$
\| \mathbf A ^ { n } \| ^ { \ e } & = \left ( \sum _ { n = 2 } ^ { N } \mathbb { E } \left [ z _ { n } z _ { n - 1 } ^ { T } \right ] \right ) \left ( \sum _ { n = 2 } ^ { N } \mathbb { E } \left [ z _ { n - 1 } z _ { n - 1 } ^ { T } \right ] \right ) ^ { - 1 } \\ & = \left ( \sum _ { n = 2 } ^ { N } \| \mathbb { E } \| ^ { 2 } \left [ \mathbb { T } \left [ \mathbb { T } \right ] \right ] \sum _ { n = 2 } ^ { N } \| \mathbb { E } \| ^ { 2 } \left [ \mathbb { T } \left [ \mathbb { T } \right ] \right ]
$$

$$
\Gamma ^ { \text {new} } \ = \ \frac { 1 } { N - 1 } \sum _ { n = 2 } ^ { N } \{ \mathbb { E } \left [ z _ { n } z _ { n } ^ { T } \right ] - A ^ { \text {new} } \mathbb { E } \left [ z _ { n - 1 } z _ { n } ^ { T } \right ] \\ - \mathbb { E } \left [ z _ { n } z _ { n - 1 } ^ { T } \right ] A ^ { \text {new} } + A ^ { \text {new} } \mathbb { E } \left [ z _ { n - 1 } z _ { n - 1 } ^ { T } \right ] ( A ^ { \text {new} } ) ^ { T } \right \} . \quad ( 1 3 . 1 4 ) \\ \intertext { Note that A ^ { \text {new} } must be evaluated first, and the result can then be used to determine } \Gamma ^ { \text {new} }
$$

Note that A new must be evaluated ﬁrst, and the result can then be used to determine Γ new .

Finally, in order to determine the new values of C and Σ , we substitute for p ( x n | z n , C , Σ ) in (13.108) using (13.76) giving

$$
Q ( \theta , \theta ^ { \text {old} } ) & = - \frac { N } { 2 } \ln | \Sigma | \\ & - \mathbb { E } _ { \mathbb { Z } | \theta ^ { \text {old} } } \left [ \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } ( x _ { n } - C z _ { n } ) ^ { T } \Sigma ^ { - 1 } ( x _ { n } - C z _ { n } ) \right ] + \text {const} . \\ \text {Maximizing with respect to } C \text { and } \Sigma \text { then gives }
$$

Maximizing with respect to C and Σ then gives Exercise 13.34

$$
C ^ { \text {new} } \ = \ \left ( \sum _ { n = 1 } ^ { N } x _ { n } \mathbb { E } \left [ z _ { n } ^ { \text {T} } \right ] \right ) \left ( \sum _ { n = 1 } ^ { N } \mathbb { E } \left [ z _ { n } z _ { n } ^ { \text {T} } \right ] \right ) ^ { - 1 } \\ \sum _ { n = 1 } ^ { N } \sum _ { \substack { 1 \ \sum _ { n } ^ { N } \subset \mathbb { T } \\ \text {T} } } C ^ { \text {new} \mathbb { T } } \subsetneq C ^ { \text {new} \mathbb { T } } \subset \mathbb { T }
$$

$$
\sum _ { n = 1 } ^ { \left ( n = 1 \right ) } & = \ \frac { 1 } { N } \sum _ { n = 1 } ^ { N } \{ x _ { n } x _ { n } ^ { T } - C ^ { \text {new} } \mathbb { E } \left [ z _ { n } \right ] x _ { n } ^ { T } \\ & - x _ { n } \mathbb { E } \left [ z _ { n } ^ { T } \right ] C ^ { \text {new} } + C ^ { \text {new} } \mathbb { E } \left [ z _ { n } z _ { n } ^ { T } \right ] C ^ { \text {new} } \} .
$$
