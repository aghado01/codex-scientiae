[Page 30]

for every i ≤ j . Letting j → ∞ and using that conditioning reduces entropy gives

$$
\sup _ { i \geq 1 } \{ H ( \tilde { Y } _ { 0 } ^ { 0 } ( i ) | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ) - H ( \tilde { Y } _ { 0 } ^ { 0 } ( i ) | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ; \tilde { X } _ { < - n } ) \} \\ \leq H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } _ { n } ^ { 0 } , \tilde { Y } _ { n } ^ { < 0 } , \tilde { Y } _ { < n } ) - H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } ) .
$$

To proceed, we write the left hand side as an expected relative entropy as in the proof of Proposition 4.4. Using the continuity of the relative entropy in information (e.g., [14, Lemma 4.4.15]) and monotone convergence, this yields

$$
E [ \, D ( \, P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } , \tilde { X } _ { < - n } ] \, | | \, P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ] \, ) ] \\ \leq H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } _ { n } ^ { 0 } , \tilde { Y } _ { n } ^ { < 0 } , \tilde { Y } _ { < n } ) - H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } ) .
$$

It therefore follows immediately that

$$
E [ D ( P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } , \tilde { X } _ { < - n } ] | | \, P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ] ) ] \xrightarrow { n \to \infty } 0 .
$$

It remains to note that

$$
P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ] = \rho , \quad P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } , \tilde { X } _ { < - n } ] = \rho _ { - ( n + 1 ) \delta } ,
$$

where we have used the Markov property of ( X t ,Y t ) t ≥ 0 to obtain the latter equality. This establishes that E [ D ( ρ s || ρ )] → 0 along the subsequence s = − ( n + 1) δ , and therefore as s → −∞ as E [ D ( ρ s || ρ )] is decreasing in s (as is easily veriﬁed by Jensen’s inequality).

We can now complete the proof of Theorem 4.12.

Proof of Theorem 4.12. By translation-invariance and Lemma 3.8, it suﬃces to show

$$
| P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | X _ { - t } , \{ Y _ { s } \} _ { - t \leq s \leq 0 } ] - P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | \{ Y _ { s } \} _ { - t \leq s \leq 0 } ] \stackrel { t \to \infty } { \longrightarrow } 0 \text { in } L ^ { 1 }
$$

for every set A and m ≥ 1. But by the martingale convergence theorem, and as { X s ,Y s } s ≤− t is conditionally independent of { X s ,Y s } s ≥− t given X − t ,Y − t by the Markov property, it sufﬁces to show for every set A and m ≥ 1 that

$$
| P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | Y _ { \leq 0 } , X _ { \leq - t } ] - P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | Y _ { \leq 0 } ] | \stackrel { t \to \infty } { \longrightarrow } 0 \text { in } L ^ { 1 } .
$$

By the martingale convergence theorem, this can be formulated equivalently as

$$
P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | \bigcap _ { t } \sigma \{ Y _ { \leq 0 } , X _ { \leq - t } \} ] = P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | Y _ { \leq 0 } ] .
$$

The key distinction between the continuousand discrete-time settings is the following.

## Lemma 4.15. We have

$$
\bigcap _ { \delta > 0 } \sigma \{ Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } , X _ { \leq - t } \} = \sigma \{ Y _ { \leq 0 } , X _ { \leq - t } \} \mod { P }
$$

and

$$
\bigcap _ { \delta > 0 } \sigma \{ Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } \} = \sigma \{ Y _ { \leq 0 } \} \mod { P } .
$$
