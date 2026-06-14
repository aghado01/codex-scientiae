[Page 34]

Theorem 5.4. For a given specification \( \gamma \), the following hold.

1. Existence of a random field: \( \mathcal{G}(\gamma) \neq \emptyset \).

2. Uniqueness \( \Leftrightarrow \) uniform mixing: \( |\mathcal{G}(\gamma)| = 1 \) iff a random field in \( \mathcal{G}(\gamma) \) satisfies \( ^{6,7} \)

$$
\lim_{W \Subset \mathbb{Z}^d} \sup_{x} \left| \mathbb{P} [ X_V \in A \mid X_{W^c} = x_{W^c} ] - \mathbb{P} [ X_V \in A ] \right| = 0
$$

for every set \( A \) and \( V \Subset \mathbb{Z}^d \).

3. Extremality \( \Leftrightarrow \) mixing: the random field \( X \) is an extreme point of \( \mathcal{G}(\gamma) \) iff

$$
\lim_{W \Subset \mathbb{Z}^d} \mathbb{E} \left| \mathbb{P} [ X_V \in A \mid X_{W^c} ] - \mathbb{P} [ X_V \in A ] \right| = 0
$$

for every set A and V ⊂⊂ Z d .

The mixing property in Theorem 5.4 is a direct spatial analogue of the stability property of a Markov chain introduced in section 2.1. Indeed, a Markov chain is stable if it forgets its initial condition after a long time: that is, the Markov chain has a ‘finite memory.’ Similarly, a random field is mixing if the distribution of any finite set of sites \( V \) is insensitive to knowledge of the configuration of the field outside a larger set \( W \) when the distance between \( V \) and \( W^c \) is large. This implies in particular that distant sites are nearly independent, that is, the field has ‘finite correlation length.’ The uniform mixing property is a strictly stronger notion, where the forgetting property holds uniformly in the boundary configuration \( x_{\partial W} \) (recall that by the Markov property of the random field, \( \mathbb{P}[X \in C \mid X_{W^c} = x_{W^c}] \) depends on \( x_{\partial W} \) only).

## 5.2 Conditional random ﬁelds and conditional mixing

In the following, let us fix a specification \( \gamma \) and a Markov random field \( X = (X_v)_{v \in \mathbb{Z}^d} \) that is specified by \( \gamma \). In order to investigate the conditional distributions of random fields, we must introduce a suitable observation structure. To this end, in analogy with section 2.2, let us fix for each \( v \in \mathbb{Z}^d \) a transition kernel \( \Phi_v \) from the state space \( E \) of the random field to a measurable space \( F \) in which the observations take their values. We now construct the observations \( Y = (Y_v)_{v \in \mathbb{Z}^d} \) such that

$$
\mathbb{P} [ Y \in \mathrm{d}y \mid X ] = \prod_{v \in \mathbb{Z}^d} \Phi_v (X_v, \mathrm{d}y_v) ;
$$

that is, each site of the underlying field is observed independently with \( \mathbb{P}[Y_v \in A \mid X_v] = \Phi_v(X_v, A) \). The resulting model \( (X_v, Y_v)_{v \in \mathbb{Z}^d} \) is called a hidden Markov random field.

^6 Here we used the suggestive notation \( \mathbb{P}[X \in C \mid X_{W^c} = x_{W^c}] := \gamma_W(x, C) \) to emphasize the significance of the mixing property. Note that \( \mathbb{P}[X \in C \mid X_{W^c}] = \gamma_W(X, C) \) holds a.s. by the definition of \( \mathcal{G}(\gamma) \), but the equivalence between uniqueness and uniform mixing is false if a null set is omitted in the supremum over \( x \).

^7 The notation \( \lim_{W} a_W \) denotes the limit of the net \( \{a_W\} \), where \( \{W \Subset \mathbb{Z}^d\} \) is directed by inclusion.
