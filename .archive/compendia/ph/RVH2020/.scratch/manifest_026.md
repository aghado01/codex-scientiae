# Manifest: Page 026

## REPAIR_MATH
- RAW: ```
\lim _ { k \to \infty } H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } ^ { < v } , X _ { - k - 1 } , \dots ) = \lim _ { k \to \infty } H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } , X _ { - k - 1 } , \dots ) .
```
  FIX: ```
$$
\lim _ { k \to \infty } H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } ^ { < v } , X _ { - k - 1 } , \dots ) = \lim _ { k \to \infty } H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } , X _ { - k - 1 } , \dots ) .
$$
```
- RAW: ```
H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } , X _ { - k - 1 } , \dots ) = H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots , Y _ { - k + 1 } , X _ { - k } ) ,
```
  FIX: ```
$$
H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } , X _ { - k - 1 } , \dots ) = H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots , Y _ { - k + 1 } , X _ { - k } ) ,
$$
```
- RAW: ```
\mathbf P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) \in B | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - \mathbf P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) \in B | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] \to 0
```
  FIX: ```
$$
\mathbf P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) \in B | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - \mathbf P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) \in B | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] \to 0
$$
```
- RAW: ```
H ( Y _ { k } ^ { v } , \dots , Y _ { k } ^ { m } | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ) - H ( Y _ { k } ^ { v } , \dots , Y _ { k } ^ { m } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ) & = \\ & \sum _ { \ell = v } ^ { m } \{ H ( Y _ { k } ^ { \ell } | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < \ell } ) - H ( Y _ { k } ^ { \ell } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < \ell } ) \} \stackrel { k \to \infty } { \longrightarrow } 0 .
```
  FIX: ```
$$
H ( Y _ { k } ^ { v } , \dots , Y _ { k } ^ { m } | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ) - H ( Y _ { k } ^ { v } , \dots , Y _ { k } ^ { m } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ) & = \\ & \sum _ { \ell = v } ^ { m } \{ H ( Y _ { k } ^ { \ell } | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < \ell } ) - H ( Y _ { k } ^ { \ell } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < \ell } ) \} \stackrel { k \to \infty } { \longrightarrow } 0 .
$$
```
- RAW: ```
\mathbf P ( ( X _ { k } ^ { v } , \dots , X _ { k } ^ { m } ) \in C | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - \mathbf P ( ( X _ { k } ^ { v } , \dots , X _ { k } ^ { m } ) \in C | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] \to 0
```
  FIX: ```
$$
\mathbf P ( ( X _ { k } ^ { v } , \dots , X _ { k } ^ { m } ) \in C | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - \mathbf P ( ( X _ { k } ^ { v } , \dots , X _ { k } ^ { m } ) \in C | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] \to 0
$$
```
- RAW: ```
P [ ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] & = \\ & \frac { P [ ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < 1 } ] \prod _ { i = 1 } ^ { v } g ( x ^ { i } , Y _ { k } ^ { i } ) } { \sum _ { z \in \{ - 1 , 1 \} ^ { m } } P [ ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = z | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < 1 } ] \prod _ { i = 1 } ^ { v } g ( z ^ { i } , Y _ { k } ^ { i } ) }
```
  FIX: ```
$$
P [ ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] & = \\ & \frac { P [ ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < 1 } ] \prod _ { i = 1 } ^ { v } g ( x ^ { i } , Y _ { k } ^ { i } ) } { \sum _ { z \in \{ - 1 , 1 \} ^ { m } } P [ ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = z | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < 1 } ] \prod _ { i = 1 } ^ { v } g ( z ^ { i } , Y _ { k } ^ { i } ) }
$$
```
- RAW: ```
\mathbf P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < 1 } ] - \mathbf P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < 1 } ] \to 0
```
  FIX: ```
$$
\mathbf P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < 1 } ] - \mathbf P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < 1 } ] \to 0
$$
```
- RAW: ```
P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] \to 0
```
  FIX: ```
$$
P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] \to 0
$$
```

## REPAIR_PROSE
- RAW: `But by the hidden Markov model structure, { Y − k ,Y − k − 1 ,... ; X − k − 1 ,X − k − 2 ,... } and { Y 0 ,Y − 1 ,...,Y − k +1 } are conditionally independent given X − k . Thus`
  FIX: `But by the hidden Markov model structure, \( \{ Y _ { - k } , Y _ { - k - 1 } , \dots ; X _ { - k - 1 } , X _ { - k - 2 } , \dots \} \) and \( \{ Y _ { 0 } , Y _ { - 1 } , \dots , Y _ { - k + 1 } \} \) are conditionally independent given \( X _ { - k } \). Thus`
- RAW: `Proposition 4.7 concerns the stability of prediction of the next observation. As in the proof of Proposition 4.4, we will transform such properties into stability properties of the ﬁlter by using the informative nature of the observations.`
  FIX: `Proposition 4.7 concerns the stability of prediction of the next observation. As in the proof of Proposition 4.4, we will transform such properties into stability properties of the filter by using the informative nature of the observations.`
- RAW: `Proof of Theorem 4.5. By translation-invariance and Lemma 3.8, it suﬃces to show that`
  FIX: `Proof of Theorem 4.5. By translation-invariance and Lemma 3.8, it suffices to show that`
- RAW: `in L 1 as k → ∞ for every set B , m ≥ 1 and v ∈ Z .`
  FIX: `in \( L ^ 1 \) as \( k \to \infty \) for every set \( B \), \( m \geq 1 \) and \( v \in \mathbb{Z} \).`
- RAW: `Suppose ﬁrst that v ≤ 1. By the chain rule for entropy and Proposition 4.7, we have`
  FIX: `Suppose first that \( v \leq 1 \). By the chain rule for entropy and Proposition 4.7, we have`
- RAW: `in L 1 as k → ∞ for every set C , and thus the result follows.`
  FIX: `in \( L ^ 1 \) as \( k \to \infty \) for every set \( C \), and thus the result follows.`
- RAW: `Now suppose that v > 1. We can assume without loss of generality that v ≤ m (otherwise the conclusion follows from the result for m = v ). We may also assume that 0 < p < 1 (otherwise the conclusion is trivial). By the Bayes formula,`
  FIX: `Now suppose that \( v > 1 \). We can assume without loss of generality that \( v \leq m \) (otherwise the conclusion follows from the result for \( m = v \)). We may also assume that \( 0 < p < 1 \) (otherwise the conclusion is trivial). By the Bayes formula,`
- RAW: `where g ( u,y ) = P [ Y i k = y | X i k = u ], and P [( X 1 k ,...,X m k ) = x | X 0 ,Y 1 ,...,Y k − 1 ,Y <v k ] satisﬁes the analogous expression. As 0 < inf g ≤ sup g < ∞ , it follows readily that`
  FIX: `where \( g ( u , y ) = P [ Y _ { k } ^ { i } = y | X _ { k } ^ { i } = u ] \), and \( P [ ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] \) satisfies the analogous expression. As \( 0 < \inf g \leq \sup g < \infty \), it follows readily that`
- RAW: `for all x implies`
  FIX: `for all \( x \) implies`
- RAW: `for all x , and thus the proof is complete.`
  FIX: `for all \( x \), and thus the proof is complete.`
