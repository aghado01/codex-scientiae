[Page 560]

The marginal probability for a particular variable can be expressed in terms of the marginal probability for the previous variable in the chain in the form

$$
p ( z ^ { ( m + 1 ) } ) = \sum _ { z ^ { ( m ) } } p ( z ^ { ( m + 1 ) } | z ^ { ( m ) } ) p ( z ^ { ( m ) } ) . \\ \intertext { t i o n $ i s $ s i d t o $ b $ i n v i o r i o n $ t o $ s i t o n $ v $ i t h o w $ r $ o $ M o r k o v $ c h i n }
$$

A distribution is said to be invariant, or stationary, with respect to a Markov chain if each step in the chain leaves that distribution invariant. Thus, for a homogeneous Markov chain with transition probabilities T ( z , z ) , the distribution p ( z ) is invariant if

$$
p ^ { * } ( z ) & = \sum _ { z ^ { \prime } } T ( z ^ { \prime } , z ) p ^ { * } ( z ^ { \prime } ) . \\ \intertext { \text {Markov chain may have more than one invariant distribution. For} }
$$

Note that a given Markov chain may have more than one invariant distribution. For instance, if the transition probabilities are given by the identity transformation, then any distribution will be invariant.

A sufﬁcient (but not necessary) condition for ensuring that the required distribution p ( z ) is invariant is to choose the transition probabilities to satisfy the property of detailed balance , deﬁned by

$$
p ^ { * } ( z ) T ( z , z ^ { \prime } ) = p ^ { * } ( z ^ { \prime } ) T ( z ^ { \prime } , z )
$$

for the particular distribution p ( z ) . It is easily seen that a transition probability that satisﬁes detailed balance with respect to a particular distribution will leave that distribution invariant, because

$$
\text {sum} _ { z ^ { \prime } } p ^ { * } ( z ^ { \prime } ) T ( z ^ { \prime } , z ) & = \sum _ { z ^ { \prime } } p ^ { * } ( z ) T ( z , z ^ { \prime } ) = p ^ { * } ( z ) \sum _ { z ^ { \prime } } p ( z ^ { \prime } | z ) = p ^ { * } ( z ) . \quad ( 1 1 . 4 1 ) \\ \intertext { s u m } A \, \text { Markov chain that respects detailed balance is said to be reversible}
$$

A Markov chain that respects detailed balance is said to be reversible .

Our goal is to use Markov chains to sample from a given distribution. We can achieve this if we set up a Markov chain such that the desired distribution is invariant. However, we must also require that for m → ∞ , the distribution p ( z ( m ) ) converges to the required invariant distribution p ( z ) , irrespective of the choice of initial distribution p ( z (0) ) . This property is called ergodicity , and the invariant distribution is then called the equilibrium distribution. Clearly, an ergodic Markov chain can have only one equilibrium distribution. It can be shown that a homogeneous Markov chain will be ergodic, subject only to weak restrictions on the invariant distribution and the transition probabilities (Neal, 1993).

In practice we often construct the transition probabilities from a set of ‘base’ transitions B 1 ,...,B K . This can be achieved through a mixture distribution of the form K

$$
T ( z ^ { \prime } , z ) = \sum _ { k = 1 } ^ { K } \alpha _ { k } B _ { k } ( z ^ { \prime } , z )
$$
