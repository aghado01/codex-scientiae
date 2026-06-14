# Manifest: Page 034

## REPAIR_MATH
- RAW: ```
\lim _ { W \subset \mathbb { Z } ^ { d } } \sup _ { x } | \mathbf P [ X _ { V } \in A | X _ { W } \subset = x _ { W ^ { c } } ] - \mathbf P [ X _ { V } \in A ] | = 0
```
  FIX: ```
$$
\lim_{W \Subset \mathbb{Z}^d} \sup_{x} \left| \mathbb{P} [ X_V \in A \mid X_{W^c} = x_{W^c} ] - \mathbb{P} [ X_V \in A ] \right| = 0
$$
```
- RAW: ```
\lim _ { W \subset \mathbb { C } ^ { \mathbb { D } } } E | P [ X _ { V } \in A | X _ { W ^ { c } } ] - P [ X _ { V } \in A ] | = 0
```
  FIX: ```
$$
\lim_{W \Subset \mathbb{Z}^d} \mathbb{E} \left| \mathbb{P} [ X_V \in A \mid X_{W^c} ] - \mathbb{P} [ X_V \in A ] \right| = 0
$$
```
- RAW: ```
P [ Y \in d y | X ] = \prod _ { v \in \mathbb { Z } ^ { d } } \Phi _ { v } ( X _ { v } , d y _ { v } ) ;
```
  FIX: ```
$$
\mathbb{P} [ Y \in \mathrm{d}y \mid X ] = \prod_{v \in \mathbb{Z}^d} \Phi_v (X_v, \mathrm{d}y_v) ;
$$
```

## REPAIR_PROSE
- RAW: ```
Theorem 5.4. For a given speciﬁcation γ , the following hold.
```
  FIX: ```
Theorem 5.4. For a given specification \( \gamma \), the following hold.
```
- RAW: ```
1. Existence of a random ﬁeld: G ( γ ) = ∅ .

glyph[negationslash]
```
  FIX: ```
1. Existence of a random field: \( \mathcal{G}(\gamma) \neq \emptyset \).
```
- RAW: ```
2. Uniqueness ⇔ uniform mixing: | G ( γ ) | = 1 iﬀ a random ﬁeld in G ( γ ) satisﬁes 6 , 7
```
  FIX: ```
2. Uniqueness \( \Leftrightarrow \) uniform mixing: \( |\mathcal{G}(\gamma)| = 1 \) iff a random field in \( \mathcal{G}(\gamma) \) satisfies \( ^{6,7} \)
```
- RAW: ```
for every set A and V ⊂⊂ Z d .
```
  FIX: ```
for every set \( A \) and \( V \Subset \mathbb{Z}^d \).
```
- RAW: ```
3. Extremality ⇔ mixing: the random ﬁeld X is an extreme point of G ( γ ) iﬀ
```
  FIX: ```
3. Extremality \( \Leftrightarrow \) mixing: the random field \( X \) is an extreme point of \( \mathcal{G}(\gamma) \) iff
```
- RAW: ```
The mixing property in Theorem 5.4 is a direct spatial analogue of the stability property of a Markov chain introduced in section 2.1. Indeed, a Markov chain is stable if it forgets its initial condition after a long time: that is, the Markov chain has a ‘ﬁnite memory.’ Similarly, a random ﬁeld is mixing if the distribution of any ﬁnite set of sites V is insensitive to knowledge of the conﬁguration of the ﬁeld outside a larger set W when the distance between V and W c is large. This implies in particular that distant sites are nearly independent, that is, the ﬁeld has ‘ﬁnite correlation length.’ The uniform mixing property is a strictly stronger notion, where the forgetting property holds uniformly in the boundary conﬁguration x ∂W (recall that by the Markov property of the random ﬁeld, P [ X ∈ C | X W c = x W c ] depends on x ∂W only).
```
  FIX: ```
The mixing property in Theorem 5.4 is a direct spatial analogue of the stability property of a Markov chain introduced in section 2.1. Indeed, a Markov chain is stable if it forgets its initial condition after a long time: that is, the Markov chain has a ‘finite memory.’ Similarly, a random field is mixing if the distribution of any finite set of sites \( V \) is insensitive to knowledge of the configuration of the field outside a larger set \( W \) when the distance between \( V \) and \( W^c \) is large. This implies in particular that distant sites are nearly independent, that is, the field has ‘finite correlation length.’ The uniform mixing property is a strictly stronger notion, where the forgetting property holds uniformly in the boundary configuration \( x_{\partial W} \) (recall that by the Markov property of the random field, \( \mathbb{P}[X \in C \mid X_{W^c} = x_{W^c}] \) depends on \( x_{\partial W} \) only).
```
- RAW: ```
In the following, let us ﬁx a speciﬁcation γ and a Markov random ﬁeld X = ( X v ) v ∈ Z d that is speciﬁed by γ . In order to investigate the conditional distributions of random ﬁelds, we must introduce a suitable observation structure. To this end, in analogy with section 2.2, let us ﬁx for each v ∈ Z d a transition kernel Φ v from the state space E of the random ﬁeld to a measurable space F in which the observations take their values. We now construct the observations Y = ( Y v ) v ∈ Z d such that
```
  FIX: ```
In the following, let us fix a specification \( \gamma \) and a Markov random field \( X = (X_v)_{v \in \mathbb{Z}^d} \) that is specified by \( \gamma \). In order to investigate the conditional distributions of random fields, we must introduce a suitable observation structure. To this end, in analogy with section 2.2, let us fix for each \( v \in \mathbb{Z}^d \) a transition kernel \( \Phi_v \) from the state space \( E \) of the random field to a measurable space \( F \) in which the observations take their values. We now construct the observations \( Y = (Y_v)_{v \in \mathbb{Z}^d} \) such that
```
- RAW: ```
that is, each site of the underlying ﬁeld is observed independently with P [ Y v ∈ A | X v ] = Φ v ( X v ,A ). The resulting model ( X v ,Y v ) v ∈ Z d is called a hidden Markov random ﬁeld .
```
  FIX: ```
that is, each site of the underlying field is observed independently with \( \mathbb{P}[Y_v \in A \mid X_v] = \Phi_v(X_v, A) \). The resulting model \( (X_v, Y_v)_{v \in \mathbb{Z}^d} \) is called a hidden Markov random field.
```
- RAW: ```
6 Here we used the suggestive notation P [ X ∈ C | X W c = x W c ] := γ W ( x, C ) to emphasize the signiﬁcance of the mixing property. Note that P [ X ∈ C | X W c ] = γ W ( X, C ) holds a.s. by the deﬁnition of G ( γ ), but the equivalence between uniqueness and uniform mixing is false if a null set is omitted in the supremum over x . 7 d

The notation lim W a W denotes the limit of the net { a W } , where { W ⊂⊂ Z } is directed by inclusion.
```
  FIX: ```
^6 Here we used the suggestive notation \( \mathbb{P}[X \in C \mid X_{W^c} = x_{W^c}] := \gamma_W(x, C) \) to emphasize the significance of the mixing property. Note that \( \mathbb{P}[X \in C \mid X_{W^c}] = \gamma_W(X, C) \) holds a.s. by the definition of \( \mathcal{G}(\gamma) \), but the equivalence between uniqueness and uniform mixing is false if a null set is omitted in the supremum over \( x \).

^7 The notation \( \lim_{W} a_W \) denotes the limit of the net \( \{a_W\} \), where \( \{W \Subset \mathbb{Z}^d\} \) is directed by inclusion.
```
