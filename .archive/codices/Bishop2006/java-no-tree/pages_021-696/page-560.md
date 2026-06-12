[Page 560]

conditional probabilities for subsequent variables in the form of transition probabilities Tm(z(m),z(m+1)) ≡ p(z(m+1)|z(m)). A Markov chain is called homogeneous if the transition probabilities are the same for all m.

The marginal probability for a particular variable can be expressed in terms of the marginal probability for the previous variable in the chain in the form

p(z(m+1)) =

p(z(m+1)|z(m))p(z(m)). (11.38)

z(m)

A distribution is said to be invariant, or stationary, with respect to a Markov chain if each step in the chain leaves that distribution invariant. Thus, for a homogeneous Markov chain with transition probabilities T(z ,z), the distribution p (z) is invariant if

p (z) =

T(z ,z)p (z ). (11.39)

z

Note that a given Markov chain may have more than one invariant distribution. For instance, if the transition probabilities are given by the identity transformation, then any distribution will be invariant.

A sufﬁcient (but not necessary) condition for ensuring that the required distribution p(z) is invariant is to choose the transition probabilities to satisfy the property of detailed balance, deﬁned by

###### p (z)T(z,z ) = p (z )T(z ,z) (11.40)

for the particular distribution p (z). It is easily seen that a transition probability that satisﬁes detailed balance with respect to a particular distribution will leave that distribution invariant, because

z

p (z )T(z ,z) =

z

p (z)T(z,z ) = p (z)

z

p(z |z) = p (z). (11.41)

A Markov chain that respects detailed balance is said to be reversible.

Our goal is to use Markov chains to sample from a given distribution. We can achieve this if we set up a Markov chain such that the desired distribution is invariant. However, we must also require that for m → ∞, the distribution p(z(m)) converges to the required invariant distribution p (z), irrespective of the choice of initial distribution p(z(0)). This property is called ergodicity, and the invariant distribution is then called the equilibrium distribution. Clearly, an ergodic Markov chain can have only one equilibrium distribution. It can be shown that a homogeneous Markov chain will be ergodic, subject only to weak restrictions on the invariant distribution and the transition probabilities (Neal, 1993).

In practice we often construct the transition probabilities from a set of ‘base’

transitions B1,...,BK. This can be achieved through a mixture distribution of the form

K

T(z ,z) =

αkBk(z ,z) (11.42)

k=1
