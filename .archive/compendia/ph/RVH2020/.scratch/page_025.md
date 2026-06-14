[Page 25]

This result, which could be employed directly in Proposition 4.4 instead of the simpler argument given there, arises in the proof of the Rokhlin-Sinai characterization of Kolmogorov automorphisms in ergodic theory, cf. [24, Chapter 18].

The key to the proof of Proposition 4.7 is that the above ideas admit a multidimensional extension. Let \( ( Z _ { q } ) _ { q \in \mathbb { Z } ^ { 2 } } \) be a translation-invariant random ﬁeld such that \( Z _ { q } \) takes values in a ﬁnite set. In this setting, the entropy rate (or ‘speciﬁc entropy’) \( h ( Z ) \) can be expressed in terms of the lexicographic order \( \prec \) on \( \mathbb { Z } ^ { 2 } \) [18, 10]:

$$
h ( Z ) \colon = \lim _ { n \to \infty } \frac { H ( Z ^ { B _ { n } } ) } { | B _ { n } | } = H ( Z ^ { q } | Z ^ { \prec q } ) ,
$$

where \( B _ { n } \) is the centered box in \( \mathbb { Z } ^ { 2 } \) with radius \( n \) and \( Z ^ { B _ { n } } = \{ Z _ { q } : q \in B _ { n } \} \), \( Z ^ { \prec q } = \{ Z _ { u } : u \prec q \} \). The random ﬁeld analogue to the above entropy identity was obtained by Conze [10, eq. (20)]: if \( Z _ { q } = ( X _ { k } ^ { v } , Y _ { k } ^ { v } ) \) for \( q = ( k , v ) \in \mathbb { Z } ^ { 2 } \) take values in a ﬁnite set, then

$$
\lim _ { n \to \infty } H ( Y _ { 1 } ^ { v } | Y _ { 1 } ^ { < v } , Y _ { 0 } , Y _ { - 1 } , \dots ; X _ { - n } ^ { < v } , X _ { - n - 1 } , X _ { - n - 2 } , \dots ) = H ( Y _ { 1 } ^ { v } | Y _ { 1 } ^ { < v } , Y _ { 0 } , Y _ { - 1 } , \dots )
$$

for any \( v \in \mathbb { Z } \). The proof of Proposition 4.7 follows from this identity.

Remark 4.9. By arguing as in the previous remark, the result of Proposition 4.7 can be rewritten in terms of conditional entropy rates. If we deﬁne

$$
h ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) & \colon = \lim _ { n \to \infty } \frac { H ( Y _ { k } ^ { 1 } , \dots , Y _ { k } ^ { n } | Y _ { 1 } , \dots , Y _ { k - 1 } ) } { n } , \\ h ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) & \colon = \lim _ { n \to \infty } \frac { H ( Y _ { k } ^ { 1 } , \dots , Y _ { k } ^ { n } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) } { n } ,
$$

then the conclusion of Proposition 4.7 can be expressed as follows:

$$
h ( Y _ { k } | Y _ { 1 } , \dots , Y _ { k - 1 } ) - h ( Y _ { k } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ) \stackrel { k \to \infty } { \longrightarrow } 0 .
$$

This could be interpreted as a direct extension of the key step in the proof of Proposition 4.4 to translation-invariant systems in inﬁnite dimension; the ﬁnite-dimensional notion of entropy is simply replaced by its inﬁnite-dimensional counterpart, the entropy rate.

Proof of Proposition 4.7. By stationarity, it suﬃces to show that

$$
H ( Y _ { 0 } ^ { v } | Y _ { - k + 1 } , \dots , Y _ { - 1 } , Y _ { 0 } ^ { < v } ) - H ( Y _ { 0 } ^ { v } | X _ { - k } , Y _ { - k + 1 } , \dots , Y _ { - 1 } , Y _ { 0 } ^ { < v } ) \stackrel { k \to \infty } { \longrightarrow } 0 .
$$

First, we note that

$$
\lim _ { k \to \infty } H ( Y _ { 0 } ^ { v } | Y _ { - k + 1 } , \dots , Y _ { - 1 } , Y _ { 0 } ^ { < v } ) & = H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , Y _ { - 2 } , \dots ) \\ & = \lim _ { k \to \infty } H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } ^ { < v } , X _ { - k - 1 } , \dots ) ,
$$

where we have used the identity of Conze [10, eq. (20)] (cf. Remark 4.8 above). As

$$
H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k + 1 } ^ { < v } , X _ { - k } , \dots ) & \leq H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } , X _ { - k - 1 } , \dots ) \\ & \leq H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } ^ { < v } , X _ { - k - 1 } , \dots ) ,
$$
