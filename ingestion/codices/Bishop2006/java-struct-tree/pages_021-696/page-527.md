[Page 527]

be described by a ﬁnite set of sufﬁcient statistics. For example, if each of the f�i(θ) is a Gaussian, then the overall approximation q(θ) will also be Gaussian.

Ideally we would like to determine the f�i(θ) by minimizing the Kullback-Leibler divergence between the true posterior and the approximation given by

fi(θ)�

KL(p�q) = KL� 1 p(D) �

f�i(θ)�. (10.192)

� � � �

1 Z �

i

i

Note that this is the reverse form of KL divergence compared with that used in variational inference. In general, this minimization will be intractable because the KL divergence involves averaging with respect to the true distribution. As a rough approximation, we could instead minimize the KL divergences between the corresponding pairs fi(θ) and f�i(θ) of factors. This represents a much simpler problem to solve, and has the advantage that the algorithm is noniterative. However, because each factor is individually approximated, the product of the factors could well give a poor approximation.

Expectation propagation makes a much better approximation by optimizing each factor in turn in the context of all of the remaining factors. It starts by initializing the factors f�i(θ), and then cycles through the factors reﬁning them one at a time. This is similar in spirit to the update of factors in the variational Bayes framework considered earlier. Suppose we wish to reﬁne factor f�j(θ). We ﬁrst remove this factor from the product to give

�

f�i(θ). Conceptually, we will now determine a revised form of the factor f�j(θ) by ensuring that the product

i�=j

�

qnew(θ) ∝ f�j(θ)

f�i(θ) (10.193)

i�=j

is as close as possible to

�

f�i(θ) (10.194)

fj(θ)

i�=j

in which we keep ﬁxed all of the factors f�i(θ) for i �= j. This ensures that the approximation is most accurate in the regions of high posterior probability as deﬁned by the remaining factors. We shall see an example of this effect when we apply EP

Section 10.7.1 to the ‘clutter problem’. To achieve this, we ﬁrst remove the factor f�j(θ) from the

current approximation to the posterior by deﬁning the unnormalized distribution

q(θ) f�j(θ)

q\j(θ) =

. (10.195)

Note that we could instead ﬁnd q\j(θ) from the product of factors i �= j, although in practice division is usually easier. This is now combined with the factor fj(θ) to give a distribution

1 Zj

fj(θ)q\j(θ) (10.196)
