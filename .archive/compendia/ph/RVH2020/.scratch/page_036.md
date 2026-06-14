[Page 36]

Next, we show that \( P [ X \in \cdot | Y ] \) is in \( \mathcal{G} ( \gamma^{Y} ) \) a.s. To this end, let us fix any regular version \( P^{Y} \) of the conditional distribution \( P [ \cdot | Y ] \). We must show that for a.e. observation record \( y \), we have \( P^{y} [ X \in A | X_{V^{c}} ] = \gamma_{V}^{y} ( X, A ) \) for all \( A \), that is, we must show that

$$
E ^ { y } [ \gamma _ { V } ^ { y } ( X , A ) 1 _ { B } ] = P ^ { y } [ \{ X \in A \} \cap B ] \ \text { for every measurable } A \text { and } B \in \sigma \{ X _ { V ^ { c } } \}
$$

holds for \( P \)-a.e. \( y \). Is easily seen by the definition of a hidden Markov random field that

$$
\gamma _ { V } ^ { Y } ( X , A ) = P [ X \in A | X _ { V ^ { c } } , Y ] .
$$

We therefore have

$$
E [ \gamma _ { V } ^ { Y } ( X , A ) 1 _ { B } 1 _ { C } ] = P [ \{ X \in A \} \cap B \cap C ]
$$

for every \( A \) and \( B \in \sigma \{ X_{V^{c}} \} \), \( C \in \sigma \{ Y \} \). It follows by disintegration that

$$
E ^ { Y } [ \gamma _ { V } ^ { Y } ( X , A ) 1 _ { B } ] = P ^ { Y } [ \{ X \in A \} \cap B ]
$$

holds \( P \)-a.s. for a fixed choice of \( A, B \in \sigma \{ X_{V^{c}} \} \), and thus simultaneously for a countable family of sets \( A \) and \( B \in \sigma \{ X_{V^{c}} \} \). By choosing the countable family to be a generating class (note that all our \( \sigma \)-fields are countably generated), the above identity holds simultaneously for every \( A \) and \( B \in \sigma \{ X_{V^{c}} \} \) by a monotone class argument. As there are only countably many \( V \subset\subset \mathbb{Z}^{d} \), we have proved that \( P [ X \in \cdot | Y ] \) is in \( \mathcal{G} ( \gamma^{Y} ) \) a.s.

Finally, we consider the conditional mixing property. As the limit in the definition of (conditional) mixing is over a decreasing net (by Jensen's inequality), it suffices to consider the limit along any fixed cofinal increasing sequence \( W_{n} \subset\subset \mathbb{Z}^{d} \). Thus by the martingale convergence theorem, the conditional mixing property holds if and only if

$$
\lim _ { n \to \infty } E [ \, | P [ X \in A | X _ { W _ { n } ^ { c } } , Y ] - P [ X \in A | Y ] | \, | Y ] = 0 \quad a . s .
$$

for every \( V \subset\subset \mathbb{Z}^{d} \) and \( A \in \sigma \{ X_{V} \} \). As we have shown that \( P [ X \in A | X_{W_{n}^{c}} , Y ] = \gamma_{W_{n}}^{Y} ( X, A ) = P^{Y} [ X \in A | X_{W_{n}^{c}} ] \), the conditional mixing property is equivalent to

$$
\lim _ { n \to \infty } E ^ { y } | P ^ { y } [ X \in A | X _ { W _ { n } ^ { c } } ] - P ^ { y } [ X \in A ] | = 0 \quad \text {for } P _ { \L } a . e . \ y
$$

for every \( V \subset\subset \mathbb{Z}^{d} \) and \( A \in \sigma \{ X_{V} \} \). But by the martingale convergence theorem

$$
\lim _ { n \to \infty } \mathbf E ^ { y } | \mathbf P ^ { y } [ X \in A | X _ { W _ { n } ^ { c } } ] - \mathbf P ^ { y } [ X \in A ] | = \mathbf E ^ { y } | \mathbf P ^ { y } [ X \in A | \bigcap _ { n } \sigma \{ X _ { W _ { n } ^ { c } } \} ] - \mathbf P ^ { y } [ X \in A ] | .
$$

Thus we can again use a monotone class argument as above to remove the dependence of the \( P \)-null set on \( V \) and \( A \). Thus \( ( X_{v}, Y_{v} )_{v \in \mathbb{Z}^{d}} \) is conditionally mixing if and only if

$$
\lim _ { W \subset \mathbb { Z } ^ { d } } E ^ { y } | P ^ { y } [ X \in A | X _ { W ^ { c } } ] - P ^ { y } [ X \in A ] | = 0 \quad \text {for every } V \subset \mathbb { Z } ^ { d } , \ A \in \sigma \{ X _ { V } \}
$$

holds for \( P \)-a.e. \( y \), which is precisely the mixing property of \( P [ X \in \cdot | Y ] \).

Proposition 5.7 shows that the conditional distribution \( P [ X \in \cdot | Y ] \) defines again a (random) Markov random field, and gives an explicit expression for its specification \( \gamma^{Y} \). The inheritance of ergodicity can now be formulated in terms of the ergodic properties of the conditional field. In particular, we can pose two natural questions:

1. If \( P [ X \in \cdot ] \) is extremal in \( \mathcal{G} ( \gamma ) \), when is \( P [ X \in \cdot | Y ] \) extremal in \( \mathcal{G} ( \gamma^{Y} ) \) a.s.?
