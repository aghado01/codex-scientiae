[Page 669]

using modiﬁed forms of (13.18 ) and (13.19) given by

$$
\pi _ { k } \ = \ \frac { \sum _ { r = 1 } ^ { R } \gamma ( z _ { 1 k } ^ { ( r ) } ) } { \sum _ { r = 1 } ^ { R } \sum _ { j = 1 } ^ { K } \gamma ( z _ { 1 j } ^ { ( r ) } ) }
$$

$$
\frac { \sum _ { r = 1 } ^ { r = 1 } \gamma ( z _ { 1 k } ^ { ( r ) } ) } { \sum _ { r = 1 } ^ { R } \sum _ { j = 1 } ^ { N } \gamma ( z _ { 1 j } ^ { ( r ) } ) } \\ \frac { r } { R } \frac { N } { K } \sum _ { r = 1 } ^ { N } \xi ( z _ { r } ^ { ( r ) } ) \\ \sum _ { r = 1 } ^ { R } \sum _ { l = 1 } ^ { N } \xi ( z _ { r } ^ { ( r ) } )
$$

$$
r = & 1 \ j = 1 \\ \sum _ { r = 1 } ^ { R } \sum _ { n = 2 } ^ { N } \xi ( z _ { n - 1 , j } ^ { ( r ) } , z _ { n , k } ^ { ( r ) } ) \\ A _ { j k } \ = \ \frac { r = 1 } { R } \ K \ \frac { N } { N } \\ \sum _ { r = 1 } ^ { R } \sum _ { l = 1 } ^ { N } \sum _ { n = 2 } ^ { \xi ( z _ { n - 1 , j } ^ { ( r ) } , z _ { n , l } ^ { ( r ) } ) } \\
$$

where, for notational convenience, we have assumed that the sequences are of the same length (the generalization to sequences of different lengths is straightforward). Similarly, show that the M-step equation for re-estimation of the means of Gaussian emission models is given by

$$
\sum _ { k } \sum _ { R } \sum _ { N } ^ { R } \gamma ( z _ { n k } ^ { ( r ) } ) x _ { n } ^ { ( r ) } \\ \mu _ { k } = \frac { r = 1 } { R } \sum _ { N } ^ { R } \sum _ { N } ^ { N } \gamma ( z _ { n k } ^ { ( r ) } ) \\ \sum _ { r = 1 } ^ { R } \sum _ { n = 1 } ^ { N } \gamma ( z _ { n k } ^ { ( r ) } ) \\ \ e p \text {equations for other emission model parameters and distributions}
$$

Note that the M-step equations for other emission model parameters and distributions take an analogous form.

13.13 ( ) www Use the deﬁnition (8.64) of the messages passed from a factor node to a variable node in a factor graph, together with the expression (13.6) for the joint distribution in a hidden Markov model, to show that the deﬁnition (13.50) of the alpha message is the same as the deﬁnition (13.34).

13.14 ( ) Use the deﬁnition (8.67) of the messages passed from a factor node to a variable node in a factor graph, together with the expression (13.6) for the joint distribution in a hidden Markov model, to show that the deﬁnition (13.52) of the beta message is the same as the deﬁnition (13.35).

13.15 ( ) Use the expressions (13.33) and (13.43) for the marginals in a hidden Markov model to derive the corresponding results (13.64) and (13.65) expressed in terms of re-scaled variables.

13.16 ( ) In this exercise, we derive the forward message passing equation for the Viterbi algorithm directly from the expression (13.6) for the joint distribution. This involves maximizing over all of the hidden variables z 1 ,..., z N . By taking the logarithm and then exchanging maximizations and summations, derive the recursion
