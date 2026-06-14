# Manifest: Page 016

## REPAIR_MATH
- RAW: ```
\mathbf E | \mathbf E [ f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - \mathbf E [ f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | Y _ { 1 } , \dots , Y _ { k } ] | \stackrel { k \to \infty } { \longrightarrow } 0
```
  FIX: ```
$$
\mathbf E | \mathbf E [ f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - \mathbf E [ f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | Y _ { 1 } , \dots , Y _ { k } ] | \stackrel { k \to \infty } { \longrightarrow } 0
$$
```
- RAW: ```
F _ { m } = f _ { m } ( X _ { 0 } ^ { - m } , \dots , X _ { 0 } ^ { m } ) \colon = \mathbf P [ X _ { 0 } \in A | X _ { 0 } ^ { - m } , \dots , X _ { 0 } ^ { m } ] .
```
  FIX: ```
$$
F _ { m } = f _ { m } ( X _ { 0 } ^ { - m } , \dots , X _ { 0 } ^ { m } ) \colon = \mathbf P [ X _ { 0 } \in A | X _ { 0 } ^ { - m } , \dots , X _ { 0 } ^ { m } ] .
$$
```
- RAW: ```
\mathbf E | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - \mathbf P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k } ] | & \leq 2 \mathbf E | f _ { m } ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) - 1 _ { A } ( X _ { k } ) | \\ & + \mathbf E | \mathbf E _ { m } ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - \mathbf E [ f _ { m } ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | Y _ { 1 } , \dots , Y _ { k } ] | .
```
  FIX: ```
$$
\mathbf E | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - \mathbf P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k } ] | & \leq 2 \mathbf E | f _ { m } ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) - 1 _ { A } ( X _ { k } ) | \\ & + \mathbf E | \mathbf E _ { m } ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - \mathbf E [ f _ { m } ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | Y _ { 1 } , \dots , Y _ { k } ] | .
$$
```
- RAW: ```
\lim _ { k \to \infty } \sup _ { k } E | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k } ] | \leq 2 \, \text {E} | F _ { m } - 1 _ { A } ( X _ { 0 } ) | .
```
  FIX: ```
$$
\lim _ { k \to \infty } \sup _ { k } E | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k } ] | \leq 2 \, \text {E} | F _ { m } - 1 _ { A } ( X _ { 0 } ) | .
$$
```
- RAW: ```
m _ { i } ( X ) = \mu ( X ^ { i } = 1 | \{ X ^ { j } \colon j \neq i \} ) , \quad n _ { i } ( X ) = \nu ( X ^ { i } = 1 | \{ X ^ { j } \colon j \neq i \} ) .
```
  FIX: ```
$$
m _ { i } ( X ) = \mu ( X ^ { i } = 1 | \{ X ^ { j } \colon j \neq i \} ) , \quad n _ { i } ( X ) = \nu ( X ^ { i } = 1 | \{ X ^ { j } \colon j \neq i \} ) .
$$
```
- RAW: ```
b _ { i } \coloneqq \sup _ { x } | m _ { i } ( x ) - n _ { i } ( x ) | , \quad C _ { j i } \coloneqq \sup _ { x , z ; x ^ { v } = z ^ { v } \text { for } v \neq i } | m _ { j } ( x ) - m _ { j } ( z ) | ,
```
  FIX: ```
$$
b _ { i } \coloneqq \sup _ { x } | m _ { i } ( x ) - n _ { i } ( x ) | , \quad C _ { j i } \coloneqq \sup _ { x , z ; x ^ { v } = z ^ { v } \text { for } v \neq i } | m _ { j } ( x ) - m _ { j } ( z ) | ,
$$
```
- RAW: ```
\sup _ { j \in I } \sum _ { i \in I } C _ { j i } < 1 .
```
  FIX: ```
$$
\sup _ { j \in I } \sum _ { i \in I } C _ { j i } < 1 .
$$
```
- RAW: ```
| \mu ( f ) - \nu ( f ) | \leq \sum _ { j \in J } \sum _ { i \in I } D _ { j i } b _ { i }
```
  FIX: ```
$$
| \mu ( f ) - \nu ( f ) | \leq \sum _ { j \in J } \sum _ { i \in I } D _ { j i } b _ { i }
$$
```
- RAW: `function f and every m ≥ 1 .`
  FIX: `function \( f \) and every \( m \ge 1 \).`
- RAW: `subset A of {− 1 , 1 } Z and`
  FIX: `subset \( A \) of \( \{-1, 1\}^{\mathbb{Z}} \) and`
- RAW: `depend on k , and`
  FIX: `depend on \( k \), and`
- RAW: `Letting m → ∞ and`
  FIX: `Letting \( m \to \infty \) and`
- RAW: `Let µ and ν be probability measures on {− 1 , 1 } I for some countable set I , and choose measurable functions m i ,n i such that`
  FIX: `Let \( \mu \) and \( \nu \) be probability measures on \( \{-1, 1\}^{I} \) for some countable set \( I \), and choose measurable functions \( m_i, n_i \) such that`
- RAW: `Then D := ∞ n =0 C n exists`
  FIX: `Then \( D := \sum_{n=0}^{\infty} C^n \) exists`
- RAW: `whenever J is a`
  FIX: `whenever \( J \) is a`
- RAW: `set, f ( x ) depends only on { x j : j ∈ J } , and 0 ≤ f ≤ 1 .`
  FIX: `set, \( f(x) \) depends only on \( \{ x_j : j \in J \} \), and \( 0 \le f \le 1 \).`

## REPAIR_PROSE
- RAW: `glyph[negationslash]`
  FIX: ``
- RAW: `ﬁlter`
  FIX: `filter`
- RAW: `deﬁne`
  FIX: `define`
- RAW: `ﬁrst`
  FIX: `first`
- RAW: `ﬁnite`
  FIX: `finite`
