# Manifest: Page 030

## REPAIR_MATH
- RAW: ```
\sup _ { i \geq 1 } \{ H ( \tilde { Y } _ { 0 } ^ { 0 } ( i ) | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ) - H ( \tilde { Y } _ { 0 } ^ { 0 } ( i ) | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ; \tilde { X } _ { < - n } ) \} \\ \leq H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } _ { n } ^ { 0 } , \tilde { Y } _ { n } ^ { < 0 } , \tilde { Y } _ { < n } ) - H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } ) .
```
  FIX: ```
$$
\sup _ { i \geq 1 } \{ H ( \tilde { Y } _ { 0 } ^ { 0 } ( i ) | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ) - H ( \tilde { Y } _ { 0 } ^ { 0 } ( i ) | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ; \tilde { X } _ { < - n } ) \} \\ \leq H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } _ { n } ^ { 0 } , \tilde { Y } _ { n } ^ { < 0 } , \tilde { Y } _ { < n } ) - H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } ) .
$$
```
- RAW: ```
E [ \, D ( \, P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } , \tilde { X } _ { < - n } ] \, | | \, P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ] \, ) ] \\ \leq H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } _ { n } ^ { 0 } , \tilde { Y } _ { n } ^ { < 0 } , \tilde { Y } _ { < n } ) - H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } ) .
```
  FIX: ```
$$
E [ \, D ( \, P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } , \tilde { X } _ { < - n } ] \, | | \, P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ] \, ) ] \\ \leq H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } _ { n } ^ { 0 } , \tilde { Y } _ { n } ^ { < 0 } , \tilde { Y } _ { < n } ) - H ( \tilde { X } _ { 0 } ^ { 0 } | \tilde { X } _ { 0 } ^ { < 0 } , \tilde { X } _ { < 0 } ; \tilde { Y } ) .
$$
```
- RAW: ```
E [ D ( P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } , \tilde { X } _ { < - n } ] | | \, P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ] ) ] \xrightarrow { n \to \infty } 0 .
```
  FIX: ```
$$
E [ D ( P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } , \tilde { X } _ { < - n } ] | | \, P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ] ) ] \xrightarrow { n \to \infty } 0 .
$$
```
- RAW: ```
P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ] = \rho , \quad P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } , \tilde { X } _ { < - n } ] = \rho _ { - ( n + 1 ) \delta } ,
```
  FIX: ```
$$
P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } ] = \rho , \quad P [ \tilde { Y } _ { 0 } ^ { 0 } \in \cdot | \tilde { Y } _ { 0 } ^ { < 0 } , \tilde { Y } _ { < 0 } , \tilde { X } _ { < - n } ] = \rho _ { - ( n + 1 ) \delta } ,
$$
```
- RAW: ```
| P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | X _ { - t } , \{ Y _ { s } \} _ { - t \leq s \leq 0 } ] - P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | \{ Y _ { s } \} _ { - t \leq s \leq 0 } ] \stackrel { t \to \infty } { \longrightarrow } 0 \text { in } L ^ { 1 }
```
  FIX: ```
$$
| P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | X _ { - t } , \{ Y _ { s } \} _ { - t \leq s \leq 0 } ] - P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | \{ Y _ { s } \} _ { - t \leq s \leq 0 } ] \stackrel { t \to \infty } { \longrightarrow } 0 \text { in } L ^ { 1 }
$$
```
- RAW: ```
| P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | Y _ { \leq 0 } , X _ { \leq - t } ] - P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | Y _ { \leq 0 } ] | \stackrel { t \to \infty } { \longrightarrow } 0 \text { in } L ^ { 1 } .
```
  FIX: ```
$$
| P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | Y _ { \leq 0 } , X _ { \leq - t } ] - P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | Y _ { \leq 0 } ] | \stackrel { t \to \infty } { \longrightarrow } 0 \text { in } L ^ { 1 } .
$$
```
- RAW: ```
P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | \bigcap _ { t } \sigma \{ Y _ { \leq 0 } , X _ { \leq - t } \} ] = P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | Y _ { \leq 0 } ] .
```
  FIX: ```
$$
P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | \bigcap _ { t } \sigma \{ Y _ { \leq 0 } , X _ { \leq - t } \} ] = P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | Y _ { \leq 0 } ] .
$$
```
- RAW: ```
\bigcap _ { \delta > 0 } \sigma \{ Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } , X _ { \leq - t } \} = \sigma \{ Y _ { \leq 0 } , X _ { \leq - t } \} \mod { P }
```
  FIX: ```
$$
\bigcap _ { \delta > 0 } \sigma \{ Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } , X _ { \leq - t } \} = \sigma \{ Y _ { \leq 0 } , X _ { \leq - t } \} \mod { P }
$$
```
- RAW: ```
\bigcap _ { \delta > 0 } \sigma \{ Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } \} = \sigma \{ Y _ { \leq 0 } \} \mod { P } .
```
  FIX: ```
$$
\bigcap _ { \delta > 0 } \sigma \{ Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } \} = \sigma \{ Y _ { \leq 0 } \} \mod { P } .
$$
```
- RAW: `for every i ≤ j . Letting j → ∞ and using that conditioning reduces entropy gives`
  FIX: `for every \( i \leq j \). Letting \( j \to \infty \) and using that conditioning reduces entropy gives`
- RAW: `where we have used the Markov property of ( X t ,Y t ) t ≥ 0 to obtain the latter equality. This establishes that E [ D ( ρ s || ρ )] → 0 along the subsequence s = − ( n + 1) δ , and therefore as s → −∞ as E [ D ( ρ s || ρ )] is decreasing in s (as is easily veriﬁed by Jensen’s inequality).`
  FIX: `where we have used the Markov property of \( ( X_t, Y_t )_{t \geq 0} \) to obtain the latter equality. This establishes that \( E [ D ( \rho_s || \rho ) ] \to 0 \) along the subsequence \( s = - ( n + 1) \delta \), and therefore as \( s \to -\infty \) as \( E [ D ( \rho_s || \rho ) ] \) is decreasing in \( s \) (as is easily verified by Jensen’s inequality).`
- RAW: `for every set A and m ≥ 1. But by the martingale convergence theorem, and as { X s ,Y s } s ≤− t is conditionally independent of { X s ,Y s } s ≥− t given X − t ,Y − t by the Markov property, it sufﬁces to show for every set A and m ≥ 1 that`
  FIX: `for every set \( A \) and \( m \geq 1 \). But by the martingale convergence theorem, and as \( \{ X_s, Y_s \}_{s \leq -t} \) is conditionally independent of \( \{ X_s, Y_s \}_{s \geq -t} \) given \( X_{-t}, Y_{-t} \) by the Markov property, it suffices to show for every set \( A \) and \( m \geq 1 \) that`

## REPAIR_PROSE
- RAW: `Proof of Theorem 4.12. By translation-invariance and Lemma 3.8, it suﬃces to show`
  FIX: `Proof of Theorem 4.12. By translation-invariance and Lemma 3.8, it suffices to show`
- RAW: `The key distinction between the continuousand discrete-time settings is the following.`
  FIX: `The key distinction between the continuous and discrete-time settings is the following.`
