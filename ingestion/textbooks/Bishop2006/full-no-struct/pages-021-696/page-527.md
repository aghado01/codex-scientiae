[Page 527]

# Section 10.7.1

be described by a ﬁnite set of sufﬁcient statistics. For example, if each of the f i ( θ ) is a Gaussian, then the overall approximation q ( θ ) will also be Gaussian. Ideally we would like to determine the f i ( θ ) by minimizing the Kullback-Leibler divergence between the true posterior and the approximation given by

Ideally we would like to determine the ˜ f i ( θ ) by minimizing the Kullback-Leibler divergence between the true posterior and the approximation given by

$$
d i v e n g e \, \text {between the true posterior and the approximation given by} \\ K L \left ( p | | q \right ) = K L \left ( \frac { 1 } { p \left ( \mathcal { D } \right ) } \prod _ { i } f _ { i } ( \theta ) \right | \left \| \frac { 1 } { Z } \prod _ { i } \widetilde { f } _ { i } ( \theta ) \right ) . \quad \left ( 1 0 . 1 2 \right ) \\ \intertext { Note that this is the reverse form of K L d i v e n g e \, compared with that used in varia- } \text {tial inference. In general, this minimization will be intractable because the KL di- }
$$

KL( p q ) = KL p ( D ) i f i ( θ ) Z i f i ( θ ) . (10.192) Note that this is the reverse form of KL divergence compared with that used in variational inference. In general, this minimization will be intractable because the KL divergence involves averaging with respect to the true distribution. As a rough approximation, we could instead minimize the KL divergences between the corresponding pairs f i ( θ ) and f i ( θ ) of factors. This represents a much simpler problem to solve, and has the advantage that the algorithm is noniterative. However, because each factor is individually approximated, the product of the factors could well give a poor approximation.

Expectation propagation makes a much better approximation by optimizing each factor in turn in the context of all of the remaining factors. It starts by initializing the factors f i ( θ ) , and then cycles through the factors reﬁning them one at a time. This is similar in spirit to the update of factors in the variational Bayes framework considered earlier. Suppose we wish to reﬁne factor f j ( θ ) . We ﬁrst remove this factor from the product to give i = j f i ( θ ) . Conceptually, we will now determine a revised form of the factor f j ( θ ) by ensuring that the product q new ( θ ) ∝ f j ( θ ) f i ( θ ) (10.193)

/negationslash

$$
\text {factor} \ j _ { j } ( \theta ) \text { by ensuring that the product} \\ q ^ { \text {new} } ( \theta ) \, \infty \, \widetilde { f } _ { j } ( \theta ) \prod _ { i \neq j } \widetilde { f } _ { i } ( \theta ) \\ \text {table to}
$$

/negationslash

is as close as possible to where Z j is the normalization constant given by

$$
f _ { j } ( \theta ) \prod _ { i \neq j } \widetilde { f } _ { i } ( \theta ) & & ( 1 0 . 1 9 4 ) \\ \text {all of the factors } \widetilde { f } _ { i } ( \theta ) \text { for } i \neq j . & \text { This ensures that the }
$$

/negationslash

in which we keep ﬁxed all of the factors f i ( θ ) for i = j . This ensures that the approximation is most accurate in the regions of high posterior probability as deﬁned by the remaining factors. We shall see an example of this effect when we apply EP to the ‘clutter problem’. To achieve this, we ﬁrst remove the factor f j ( θ ) from the current approximation to the posterior by deﬁning the unnormalized distribution j q ( θ )

/negationslash

$$
q ^ { \langle j } ( \theta ) = \frac { q ( \theta ) } { \widetilde { f } _ { j } ( \theta ) } .
$$

q \ ( θ ) = f j ( θ ) . (10.195) Note that we could instead ﬁnd q \ j ( θ ) from the product of factors i = j , although in practice division is usually easier. This is now combined with the factor f j ( θ ) to give a distribution 1

/negationslash

$$
\frac { 1 } { Z _ { j } } f _ { j } ( \theta ) q ^ { \vee j } ( \theta ) & & ( 1 0 . 1 9 6 )
$$
