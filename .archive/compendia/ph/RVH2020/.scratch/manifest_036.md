# Manifest: Page 036

## REPAIR_MATH
- RAW: ```
E ^ { y } [ \gamma _ { V } ^ { y } ( X , A ) 1 _ { B } ] = P ^ { y } [ \{ X \in A \} \cap B ] \ \text { for every measurable } A \text { and } B \in \sigma \{ X _ { V ^ { c } } \}
```
  FIX: ```
$$
E ^ { y } [ \gamma _ { V } ^ { y } ( X , A ) 1 _ { B } ] = P ^ { y } [ \{ X \in A \} \cap B ] \ \text { for every measurable } A \text { and } B \in \sigma \{ X _ { V ^ { c } } \}
$$
```
- RAW: ```
\gamma _ { V } ^ { Y } ( X , A ) = P [ X \in A | X _ { V ^ { c } } , Y ] .
```
  FIX: ```
$$
\gamma _ { V } ^ { Y } ( X , A ) = P [ X \in A | X _ { V ^ { c } } , Y ] .
$$
```
- RAW: ```
E [ \gamma _ { V } ^ { Y } ( X , A ) 1 _ { B } 1 _ { C } ] = P [ \{ X \in A \} \cap B \cap C ]
```
  FIX: ```
$$
E [ \gamma _ { V } ^ { Y } ( X , A ) 1 _ { B } 1 _ { C } ] = P [ \{ X \in A \} \cap B \cap C ]
$$
```
- RAW: ```
E ^ { Y } [ \gamma _ { V } ^ { Y } ( X , A ) 1 _ { B } ] = P ^ { Y } [ \{ X \in A \} \cap B ]
```
  FIX: ```
$$
E ^ { Y } [ \gamma _ { V } ^ { Y } ( X , A ) 1 _ { B } ] = P ^ { Y } [ \{ X \in A \} \cap B ]
$$
```
- RAW: ```
\lim _ { n \to \infty } E [ \, | P [ X \in A | X _ { W _ { n } ^ { c } } , Y ] - P [ X \in A | Y ] | \, | Y ] = 0 \quad a . s .
```
  FIX: ```
$$
\lim _ { n \to \infty } E [ \, | P [ X \in A | X _ { W _ { n } ^ { c } } , Y ] - P [ X \in A | Y ] | \, | Y ] = 0 \quad a . s .
$$
```
- RAW: ```
\lim _ { n \to \infty } E ^ { y } | P ^ { y } [ X \in A | X _ { W _ { n } ^ { c } } ] - P ^ { y } [ X \in A ] | = 0 \quad \text {for } P _ { \L } a . e . \ y
```
  FIX: ```
$$
\lim _ { n \to \infty } E ^ { y } | P ^ { y } [ X \in A | X _ { W _ { n } ^ { c } } ] - P ^ { y } [ X \in A ] | = 0 \quad \text {for } P _ { \L } a . e . \ y
$$
```
- RAW: ```
\lim _ { n \to \infty } \mathbf E ^ { y } | \mathbf P ^ { y } [ X \in A | X _ { W _ { n } ^ { c } } ] - \mathbf P ^ { y } [ X \in A ] | = \mathbf E ^ { y } | \mathbf P ^ { y } [ X \in A | \bigcap _ { n } \sigma \{ X _ { W _ { n } ^ { c } } \} ] - \mathbf P ^ { y } [ X \in A ] | .
```
  FIX: ```
$$
\lim _ { n \to \infty } \mathbf E ^ { y } | \mathbf P ^ { y } [ X \in A | X _ { W _ { n } ^ { c } } ] - \mathbf P ^ { y } [ X \in A ] | = \mathbf E ^ { y } | \mathbf P ^ { y } [ X \in A | \bigcap _ { n } \sigma \{ X _ { W _ { n } ^ { c } } \} ] - \mathbf P ^ { y } [ X \in A ] | .
$$
```
- RAW: ```
\lim _ { W \subset \mathbb { Z } ^ { d } } E ^ { y } | P ^ { y } [ X \in A | X _ { W ^ { c } } ] - P ^ { y } [ X \in A ] | = 0 \quad \text {for every } V \subset \mathbb { Z } ^ { d } , \ A \in \sigma \{ X _ { V } \}
```
  FIX: ```
$$
\lim _ { W \subset \mathbb { Z } ^ { d } } E ^ { y } | P ^ { y } [ X \in A | X _ { W ^ { c } } ] - P ^ { y } [ X \in A ] | = 0 \quad \text {for every } V \subset \mathbb { Z } ^ { d } , \ A \in \sigma \{ X _ { V } \}
$$
```

## REPAIR_PROSE
- RAW: ```
Next, we show that P [ X ∈ ·| Y ] is in G ( γ Y ) a.s. To this end, let us ﬁx any regular version P Y of the conditional distribution P [ ·| Y ]. We must show that for a.e. observation record y , we have P y [ X ∈ A | X V c ] = γ y V ( X,A ) for all A , that is, we must show that
```
  FIX: ```
Next, we show that \( P [ X \in \cdot | Y ] \) is in \( \mathcal{G} ( \gamma^{Y} ) \) a.s. To this end, let us fix any regular version \( P^{Y} \) of the conditional distribution \( P [ \cdot | Y ] \). We must show that for a.e. observation record \( y \), we have \( P^{y} [ X \in A | X_{V^{c}} ] = \gamma_{V}^{y} ( X, A ) \) for all \( A \), that is, we must show that
```
- RAW: ```
holds for P -a.e. y . Is easily seen by the deﬁnition of a hidden Markov random ﬁeld that
```
  FIX: ```
holds for \( P \)-a.e. \( y \). Is easily seen by the definition of a hidden Markov random field that
```
- RAW: ```
for every A and B ∈ σ { X V c } , C ∈ σ { Y } . It follows by disintegration that
```
  FIX: ```
for every \( A \) and \( B \in \sigma \{ X_{V^{c}} \} \), \( C \in \sigma \{ Y \} \). It follows by disintegration that
```
- RAW: ```
holds P -a.s. for a ﬁxed choice of A , B ∈ σ { X V c } , and thus simultaneously for a countable family of sets A and B ∈ σ { X V c } . By choosing the countable family to be a generating class (note that all our σ -ﬁelds are countably generated), the above identity holds simultaneously for every A and B ∈ σ { X V c } by a monotone class argument. As there are only countably many V ⊂⊂ Z d , we have proved that P [ X ∈ ·| Y ] is in G ( γ Y ) a.s.
```
  FIX: ```
holds \( P \)-a.s. for a fixed choice of \( A, B \in \sigma \{ X_{V^{c}} \} \), and thus simultaneously for a countable family of sets \( A \) and \( B \in \sigma \{ X_{V^{c}} \} \). By choosing the countable family to be a generating class (note that all our \( \sigma \)-fields are countably generated), the above identity holds simultaneously for every \( A \) and \( B \in \sigma \{ X_{V^{c}} \} \) by a monotone class argument. As there are only countably many \( V \subset\subset \mathbb{Z}^{d} \), we have proved that \( P [ X \in \cdot | Y ] \) is in \( \mathcal{G} ( \gamma^{Y} ) \) a.s.
```
- RAW: ```
Finally, we consider the conditional mixing property. As the limit in the deﬁnition of (conditional) mixing is over a decreasing net (by Jensen’s inequality), it suﬃces to consider the limit along any ﬁxed coﬁnal increasing sequence W n ⊂⊂ Z d . Thus by the martingale convergence theorem, the conditional mixing property holds if and only if
```
  FIX: ```
Finally, we consider the conditional mixing property. As the limit in the definition of (conditional) mixing is over a decreasing net (by Jensen's inequality), it suffices to consider the limit along any fixed cofinal increasing sequence \( W_{n} \subset\subset \mathbb{Z}^{d} \). Thus by the martingale convergence theorem, the conditional mixing property holds if and only if
```
- RAW: ```
for every V ⊂⊂ Z d and A ∈ σ { X V } . As we have shown that P [ X ∈ A | X W c n ,Y ] = γ Y W n ( X,A ) = P Y [ X ∈ A | X W c n ], the conditional mixing property is equivalent to
```
  FIX: ```
for every \( V \subset\subset \mathbb{Z}^{d} \) and \( A \in \sigma \{ X_{V} \} \). As we have shown that \( P [ X \in A | X_{W_{n}^{c}} , Y ] = \gamma_{W_{n}}^{Y} ( X, A ) = P^{Y} [ X \in A | X_{W_{n}^{c}} ] \), the conditional mixing property is equivalent to
```
- RAW: ```
for every V ⊂⊂ Z d and A ∈ σ { X V } . But by the martingale convergence theorem
```
  FIX: ```
for every \( V \subset\subset \mathbb{Z}^{d} \) and \( A \in \sigma \{ X_{V} \} \). But by the martingale convergence theorem
```
- RAW: ```
Thus we can again use a monotone class argument as above to remove the dependence of the P -null set on V and A . Thus ( X v ,Y v ) v ∈ Z d is conditionally mixing if and only if
```
  FIX: ```
Thus we can again use a monotone class argument as above to remove the dependence of the \( P \)-null set on \( V \) and \( A \). Thus \( ( X_{v}, Y_{v} )_{v \in \mathbb{Z}^{d}} \) is conditionally mixing if and only if
```
- RAW: ```
holds for P -a.e. y , which is precisely the mixing property of P [ X ∈ ·| Y ].
```
  FIX: ```
holds for \( P \)-a.e. \( y \), which is precisely the mixing property of \( P [ X \in \cdot | Y ] \).
```
- RAW: ```
Proposition 5.7 shows that the conditional distribution P [ X ∈ ·| Y ] deﬁnes again a (random) Markov random ﬁeld, and gives an explicit expression for its speciﬁcation γ Y . The inheritance of ergodicity can now be formulated in terms of the ergodic properties of the conditional ﬁeld. In particular, we can pose two natural questions:
```
  FIX: ```
Proposition 5.7 shows that the conditional distribution \( P [ X \in \cdot | Y ] \) defines again a (random) Markov random field, and gives an explicit expression for its specification \( \gamma^{Y} \). The inheritance of ergodicity can now be formulated in terms of the ergodic properties of the conditional field. In particular, we can pose two natural questions:
```
- RAW: ```
1. If P [ X ∈ · ] is extremal in G ( γ ), when is P [ X ∈ ·| Y ] extremal in G ( γ Y ) a.s.?
```
  FIX: ```
1. If \( P [ X \in \cdot ] \) is extremal in \( \mathcal{G} ( \gamma ) \), when is \( P [ X \in \cdot | Y ] \) extremal in \( \mathcal{G} ( \gamma^{Y} ) \) a.s.?
```
