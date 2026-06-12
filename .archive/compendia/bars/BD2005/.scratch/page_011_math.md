[Page 11]

$$
C ( \lambda, k ) = \frac { b _ { \tau } ^ { a _ { \tau } } \lambda ^ { \frac { k } { 2 } } \Gamma ( \frac { n } { 2 } + a _ { \tau } ) } { \Gamma ( a _ { \tau } ) ( 2 \pi ) ^ { \frac { n } { 2 } } }
$$

In a similar fashion, we can write the marginal likelihood for a proposed model M ∗ of dimension k ∗ .

$$
p ( y | M ^ { * }, \delta ^ { * }, \lambda ^ { * } ) = C ( \lambda ^ { * }, k ^ { * } ) | R ^ { * } | ^ { - \frac { 1 } { 2 } } ( b _ { \tau } + \frac { \alpha ^ { * } } { 2 } ) ^ { - ( \frac { n } { 2 } + a _ { \tau } ) } \prod _ { l = 1 } ^ { k ^ { * } } \delta _ { l } ^ { \frac { m } { 2 } } \prod _ { i = 1 } ^ { m } | U ^ { * } _ { i } | ^ { \frac { 1 } { 2 } } \quad ( 6 )
$$

Suppose we propose a move from model M of dimension k to model M ∗ of dimension k ∗.If we let the acceptance probability be the ratio of the two marginal likelihoods, then it depends on λ and δ.It also depends on λ ∗ and δ ∗, for which we do not have estimates. Since we wish to accept or reject a model based only on its set of basis functions, we want to minimize the eﬀects of these variance components on the acceptance probability. Speciﬁcally, we assume λ = λ ∗ at the current sampled value. Since δ ∗ and δ may be of diﬀerent dimensions, we cannot assume that they are equal. Instead, we assume that they are equal in the elements corresponding to bases common to both models and condition only on those elements.

Consider a proposal to add a basis to the current model. The current model is nested in the proposed model, and the proposed model has exactly one more basis than the current model. The acceptance probability is:

$$
Q = m i n \left [ 1, \frac { p ( y | M ^ { * }, \lambda, \delta ) } { p ( y | M, \lambda, \delta ) } \right ]
$$

The denominator has closed form, as we’ve shown above, and the numerator can be derived as follows, where δ ∗ = ( δ, δ k ∗ ).

$$
\text {derived as follows, where $\delta^{\sigma}=\sigma$}.\\ p ( y | M ^ { * }, \lambda, \delta ) & = \int p ( y, \delta _ { k ^ { * } } | M ^ { * }, \delta, \lambda ) d \delta _ { k ^ { * } } = \int p ( y | M ^ { * }, \delta ^ { * }, \lambda ) \pi ( \delta _ { k ^ { * } } ) d \delta _ { k ^ { * } } \\ & = \frac { C ( \lambda, k ^ { * } ) } { \Gamma ( a _ { \delta } ) } \prod _ { l = 1 } ^ { k } \delta _ { l } \int _ { 0 } ^ { \infty } | R ^ { * } | ^ { - \frac { 1 } { 2 } } ( b _ { r } + \frac { \alpha ^ { * } } { 2 } ) ^ { - ( \frac { n } { 2 } + a _ { r } ) } \delta _ { k ^ { * } } e x p ( - b _ { \delta } \delta _ { k ^ { * } } ) b _ { s } \delta _ { l } ^ { a _ { s } } \prod _ { i = 1 } ^ { m } | U ^ { * } _ { i } | ^ { \frac { 1 } { 2 } } d \delta _ { k ^ { * } } .
$$
