# Manifest: Page 017

## REPAIR_MATH
- RAW: ```
\mu _ { X , Y } \coloneqq \mathbf P [ X _ { 0 } , \dots , X _ { k } \in \cdot | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] , \quad \nu _ { Y } \coloneqq \mathbf P [ X _ { 0 } , \dots , X _ { k } \in \cdot | Y _ { 1 } , \dots , Y _ { k } ] .
```
  FIX: ```
$$
\mu _ { X , Y } \coloneqq \mathbf P [ X _ { 0 } , \dots , X _ { k } \in \cdot | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] , \quad \nu _ { Y } \coloneqq \mathbf P [ X _ { 0 } , \dots , X _ { k } \in \cdot | Y _ { 1 } , \dots , Y _ { k } ] .
$$
```
- RAW: ```
\mu _ { x , y } ( X _ { \ell } ^ { v } = 1 | \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( \ell , v ) \} ) = \nu _ { y } ( X _ { \ell } ^ { v } = 1 | \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( \ell , v ) \} ) = \\ e ^ { \beta \{ \tilde { y } _ { \ell } X _ { \ell - 1 } ^ { v } + \tilde { y } _ { \ell } ^ { v } X _ { \ell } ^ { v + 1 } + \tilde { y } _ { \ell + 1 } ^ { v } X _ { \ell + 1 } ^ { v } + \tilde { y } _ { \ell } ^ { v - 1 } X _ { \ell } ^ { v - 1 } \} } \\ \frac { e ^ { \beta \{ \tilde { y } _ { \ell } X _ { \ell - 1 } ^ { v } + \tilde { y } _ { \ell } ^ { v } X _ { \ell } ^ { v + 1 } + \tilde { y } _ { \ell + 1 } ^ { v } X _ { \ell + 1 } ^ { v } + \tilde { y } _ { \ell } ^ { v - 1 } X _ { \ell } ^ { v - 1 } \} } { e ^ { \beta \{ \tilde { y } _ { \ell } ^ { v } X _ { \ell - 1 } ^ { v } + \tilde { y } _ { \ell } ^ { v } X _ { \ell } ^ { v + 1 } + \tilde { y } _ { \ell + 1 } ^ { v } X _ { \ell } ^ { v } + \tilde { y } _ { \ell + 1 } ^ { v - 1 } X _ { \ell + 1 } ^ { v - 1 } + \tilde { y } _ { \ell } ^ { v - 1 } X _ { \ell } ^ { v - 1 } \} }
```
  FIX: ```
$$
\mu _ { x , y } ( X _ { \ell } ^ { v } = 1 | \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( \ell , v ) \} ) = \nu _ { y } ( X _ { \ell } ^ { v } = 1 | \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( \ell , v ) \} ) = \\ e ^ { \beta \{ \tilde { y } _ { \ell } X _ { \ell - 1 } ^ { v } + \tilde { y } _ { \ell } ^ { v } X _ { \ell } ^ { v + 1 } + \tilde { y } _ { \ell + 1 } ^ { v } X _ { \ell + 1 } ^ { v } + \tilde { y } _ { \ell } ^ { v - 1 } X _ { \ell } ^ { v - 1 } \} } \\ \frac { e ^ { \beta \{ \tilde { y } _ { \ell } X _ { \ell - 1 } ^ { v } + \tilde { y } _ { \ell } ^ { v } X _ { \ell } ^ { v + 1 } + \tilde { y } _ { \ell + 1 } ^ { v } X _ { \ell + 1 } ^ { v } + \tilde { y } _ { \ell } ^ { v - 1 } X _ { \ell } ^ { v - 1 } \} } { e ^ { \beta \{ \tilde { y } _ { \ell } ^ { v } X _ { \ell - 1 } ^ { v } + \tilde { y } _ { \ell } ^ { v } X _ { \ell } ^ { v + 1 } + \tilde { y } _ { \ell + 1 } ^ { v } X _ { \ell } ^ { v } + \tilde { y } _ { \ell + 1 } ^ { v - 1 } X _ { \ell + 1 } ^ { v - 1 } + \tilde { y } _ { \ell } ^ { v - 1 } X _ { \ell } ^ { v - 1 } \} }
$$
```
- RAW: ```
\mu _ { x , y } ( X _ { k } ^ { v } = 1 | \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( k , v ) \} ) = \nu _ { y } ( X _ { k } ^ { v } = 1 | \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( k , v ) \} ) = \\ \frac { e ^ { \beta \{ \bar { y } _ { k } ^ { v } X _ { k - 1 } ^ { v } + \bar { y } _ { k } ^ { v } X _ { k } ^ { v + 1 } + \bar { y } _ { k } ^ { v } X _ { k } ^ { v - 1 } \} } { e ^ { \beta \{ \bar { y } _ { k } ^ { v } X _ { k - 1 } ^ { v } + \bar { y } _ { k } ^ { v } X _ { k } ^ { v + 1 } + \bar { y } _ { k } ^ { v } X _ { k } ^ { v - 1 } \} } + e ^ { - \beta \{ \bar { y } _ { k } ^ { v } X _ { k - 1 } ^ { v } + \bar { y } _ { k } ^ { v } X _ { k } ^ { v + 1 } + \bar { y } _ { k } ^ { v - 1 } X _ { k } ^ { v - 1 } \} }
```
  FIX: ```
$$
\mu _ { x , y } ( X _ { k } ^ { v } = 1 | \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( k , v ) \} ) = \nu _ { y } ( X _ { k } ^ { v } = 1 | \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( k , v ) \} ) = \\ \frac { e ^ { \beta \{ \bar { y } _ { k } ^ { v } X _ { k - 1 } ^ { v } + \bar { y } _ { k } ^ { v } X _ { k } ^ { v + 1 } + \bar { y } _ { k } ^ { v } X _ { k } ^ { v - 1 } \} } { e ^ { \beta \{ \bar { y } _ { k } ^ { v } X _ { k - 1 } ^ { v } + \bar { y } _ { k } ^ { v } X _ { k } ^ { v + 1 } + \bar { y } _ { k } ^ { v } X _ { k } ^ { v - 1 } \} } + e ^ { - \beta \{ \bar { y } _ { k } ^ { v } X _ { k - 1 } ^ { v } + \bar { y } _ { k } ^ { v } X _ { k } ^ { v + 1 } + \bar { y } _ { k } ^ { v - 1 } X _ { k } ^ { v - 1 } \} }
$$
```
- RAW: ```
\mu _ { X , Y } ( X _ { \ell } ^ { v } = 1 | \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( \ell , v ) \} ) & = \mathbf P [ X _ { \ell } ^ { v } = 1 | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( \ell , v ) \} ] , \\ \nu _ { Y } ( X _ { \ell } ^ { v } = 1 | \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( \ell , v ) \} ) & = \mathbf P [ X _ { \ell } ^ { v } = 1 | Y _ { 1 } , \dots , Y _ { k } , \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( \ell , v ) \} ] ,
```
  FIX: ```
$$
\mu _ { X , Y } ( X _ { \ell } ^ { v } = 1 | \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( \ell , v ) \} ) & = \mathbf P [ X _ { \ell } ^ { v } = 1 | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( \ell , v ) \} ] , \\ \nu _ { Y } ( X _ { \ell } ^ { v } = 1 | \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( \ell , v ) \} ) & = \mathbf P [ X _ { \ell } ^ { v } = 1 | Y _ { 1 } , \dots , Y _ { k } , \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( \ell , v ) \} ] ,
$$
```
- RAW: ```
| \mathbf E [ f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - \mathbf E [ f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | Y _ { 1 } , \dots , Y _ { k } ] | \leq ( 8 m + 4 ) \| f \| _ { \infty } e ^ { - k }
```
  FIX: ```
$$
| \mathbf E [ f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - \mathbf E [ f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | Y _ { 1 } , \dots , Y _ { k } ] | \leq ( 8 m + 4 ) \| f \| _ { \infty } e ^ { - k }
$$
```
- RAW: ```
| \mu _ { x , y } ( f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) ) - \nu _ { y } ( f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) ) | \leq 2 \| f \| _ { \infty } \sum _ { w = - m } ^ { m } \sum _ { v \in \mathbb { Z } } D _ { ( k , w ) ( 0 , v ) }
```
  FIX: ```
$$
| \mu _ { x , y } ( f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) ) - \nu _ { y } ( f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) ) | \leq 2 \| f \| _ { \infty } \sum _ { w = - m } ^ { m } \sum _ { v \in \mathbb { Z } } D _ { ( k , w ) ( 0 , v ) }
$$
```
- RAW: ```
C _ { ( \ell ^ { \prime } , v ^ { \prime } ) ( \ell , v ) } = 0 \ \text { if } \ \ell ^ { \prime } = 0 \ \text { or } \ | \ell ^ { \prime } - \ell | + | v ^ { \prime } - v | > 1 \ \text { or } \ \ell = \ell ^ { \prime } , \ v = v ^ { \prime } .
```
  FIX: ```
$$
C _ { ( \ell ^ { \prime } , v ^ { \prime } ) ( \ell , v ) } = 0 \ \text { if } \ \ell ^ { \prime } = 0 \ \text { or } \ | \ell ^ { \prime } - \ell | + | v ^ { \prime } - v | > 1 \ \text { or } \ \ell = \ell ^ { \prime } , \ v = v ^ { \prime } .
$$
```
- RAW: ```
\frac { e ^ { - 4 \beta } } { e ^ { 4 \beta } + e ^ { - 4 \beta } } \leq \mu _ { x , y } ( X _ { \ell } ^ { v } = 1 | \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( \ell , v ) \} ) \leq \frac { e ^ { 4 \beta } } { e ^ { 4 \beta } + e ^ { - 4 \beta } } ,
```
  FIX: ```
$$
\frac { e ^ { - 4 \beta } } { e ^ { 4 \beta } + e ^ { - 4 \beta } } \leq \mu _ { x , y } ( X _ { \ell } ^ { v } = 1 | \{ X _ { r } ^ { w } \colon ( r , w ) \neq ( \ell , v ) \} ) \leq \frac { e ^ { 4 \beta } } { e ^ { 4 \beta } + e ^ { - 4 \beta } } ,
$$
```

## REPAIR_PROSE
- RAW: ```
glyph[negationslash]
```
  FIX: ```
```

## REPAIR_MATH
- RAW: ```
Then there is a set A with P [( X,Y ) ∈ A ] = 1 such that for every ( x,y ) ∈ A
```
  FIX: ```
Then there is a set \( A \) with \( \mathbf{P}[(X,Y) \in A] = 1 \) such that for every \( (x,y) \in A \)
```
- RAW: ```
for 1 ≤ < k and v ∈ Z ,
```
  FIX: ```
for \( 1 \leq \ell < k \) and \( v \in \mathbb{Z} \),
```
- RAW: ```
for v ∈ Z , and µ x,y ( X v 0 = 1) = 1 x v 0 =1 for v ∈ Z , where β := log (1 − p ) /p .
```
  FIX: ```
for \( v \in \mathbb{Z} \), and \( \mu_{x,y}(X_0^v = 1) = \mathbf{1}_{x_0^v=1} \) for \( v \in \mathbb{Z} \), where \( \beta := \log(1-p)/p \).
```
- RAW: ```
see [53, p. 95–96] or [46, Lemma 3.4]. That each statement in the Lemma holds for P -a.e. ( x,y ) can therefore be read oﬀ from Lemma 3.4. As there are countably many statements, they can be assumed to hold simultaneously on a set A of unit measure.
```
  FIX: ```
see [53, p. 95–96] or [46, Lemma 3.4]. That each statement in the Lemma holds for \( \mathbf{P} \)-a.e. \( (x,y) \) can therefore be read oﬀ from Lemma 3.4. As there are countably many statements, they can be assumed to hold simultaneously on a set \( A \) of unit measure.
```
- RAW: ```
We can now complete the proof of ﬁlter stability for p > p .
```
  FIX: ```
We can now complete the proof of ﬁlter stability for \( p > p_0 \).
```
- RAW: ```
Proposition 3.11. There exists an absolute constant 0 < p < 1 / 2 such that
```
  FIX: ```
Proposition 3.11. There exists an absolute constant \( 0 < p_0 < 1/2 \) such that
```
- RAW: ```
a.s. for every k,m ≥ 1 and function f whenever p < p ≤ 1 / 2 .
```
  FIX: ```
a.s. for every \( k, m \geq 1 \) and function \( f \) whenever \( p < p_0 \leq 1/2 \).
```
- RAW: ```
Proof. We apply Theorem 3.9 with I = { 0 ,...,k } × Z and µ = µ x,y , ν = ν y as deﬁned in Lemma 3.10. Evidently b (0 ,v ) ≤ 1 and b (  ,v ) = 0 for 1 ≤ ≤ k and v ∈ Z , so we have
```
  FIX: ```
Proof. We apply Theorem 3.9 with \( I = \{0, \dots, k\} \times \mathbb{Z} \) and \( \mu = \mu_{x,y} \), \( \nu = \nu_y \) as deﬁned in Lemma 3.10. Evidently \( b(0,v) \leq 1 \) and \( b(\ell,v) = 0 \) for \( 1 \leq \ell \leq k \) and \( v \in \mathbb{Z} \), so we have
```
- RAW: ```
by Theorem 3.9 provided that the condition on the matrix C is satisﬁed.
```
  FIX: ```
by Theorem 3.9 provided that the condition on the matrix \( C \) is satisﬁed.
```
- RAW: ```
We proceed to estimate the matrix C using Lemma 3.10. Evidently
```
  FIX: ```
We proceed to estimate the matrix \( C \) using Lemma 3.10. Evidently
```
