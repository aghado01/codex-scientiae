# Manifest: Page 021

## REPAIR_MATH
- RAW: ```
| E [ f ( X _ { k } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] - E [ f ( X _ { k } ) | Y _ { 1 } , \dots , Y _ { k - 1 } ] | \stackrel { k \to \infty } { \longrightarrow } 0 \ \text { in } L ^ { 1 } ,
```
  FIX: ```
\[
| E [ f ( X _ { k } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] - E [ f ( X _ { k } ) | Y _ { 1 } , \dots , Y _ { k - 1 } ] | \stackrel { k \to \infty } { \longrightarrow } 0 \ \text { in } L ^ { 1 } ,
\]
```

## REPAIR_PROSE
- RAW: ```
prediction ﬁlter ˜ π k rather than to the ﬁlter π k .
```
  FIX: ```
prediction ﬁlter \( \tilde{\pi}_k \) rather than to the ﬁlter \( \pi_k \).
```

- RAW: ```
initial measures µ,ν that give rise to absolutely continuous
```
  FIX: ```
initial measures \( \mu, \nu \) that give rise to absolutely continuous
```

- RAW: ```
state space of X k is countable, this is not a restriction: then δ x λ whenever λ ( { x } ) > 0, so choosing µ = δ X 0 and ν = λ in Theorem 4.2 yields
```
  FIX: ```
state space of \( X_k \) is countable, this is not a restriction: then \( \delta_x \ll \lambda \) whenever \( \lambda ( \{ x \} ) > 0 \), so choosing \( \mu = \delta_{X_0} \) and \( \nu = \lambda \) in Theorem 4.2 yields
```

- RAW: ```
observation laws P µ [( Y k ) k ≥ 0 ∈ · ] P ν [( Y k ) k ≥ 0 ∈ · ] even when µ and ν are mutually singular.
```
  FIX: ```
observation laws \( P^\mu [( Y_k )_{k \ge 0} \in \cdot ] \ll P^\nu [( Y_k )_{k \ge 0} \in \cdot ] \) even when \( \mu \) and \( \nu \) are mutually singular.
```

- RAW: ```
if µ   ν are absolutely continuous probability measures on an inﬁnite product space E Z , then the density dµ dν can be approximated arbitrarily well in L 1 ( ν ) by densities
```
  FIX: ```
if \( \mu \ll \nu \) are absolutely continuous probability measures on an inﬁnite product space \( E^\mathbb{Z} \), then the density \( \frac{d\mu}{d\nu} \) can be approximated arbitrarily well in \( L^1(\nu) \) by densities
```

- RAW: ```
(indeed, if dµ dν is a function of { x v } v ∈ I for a ﬁnite set I ⊂ Z , then µ ( { x v } v  ∈ I ∈ ·|{ x v } v ∈ I ) = ν ( { x v } v  ∈ I ∈ ·|{ x v } v ∈ I ) by the Bayes formula, and thus the diﬀerence between µ and ν is entirely determined by the marginal on I ).
```
  FIX: ```
(indeed, if \( \frac{d\mu}{d\nu} \) is a function of \( \{x_v\}_{v \in I} \) for a ﬁnite set \( I \subset \mathbb{Z} \), then \( \mu( \{x_v\}_{v \notin I} \in \cdot | \{x_v\}_{v \in I} ) = \nu( \{x_v\}_{v \notin I} \in \cdot | \{x_v\}_{v \in I} ) \) by the Bayes formula, and thus the diﬀerence between \( \mu \) and \( \nu \) is entirely determined by the marginal on \( I \)).
```
