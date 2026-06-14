# Manifest: Page 050

## REPAIR_MATH
- RAW: ```
= s + r a n k \begin{bmatrix} L ( g _ { 1 } ^ { \prime } ) & 0 \\ L ( g _ { 3 } ^ { \prime } ) & L ( g _ { 2 } ^ { \prime } ) \end{bmatrix} - r a n k \begin{bmatrix} L ( g _ { 1 } ^ { \prime } ) & 0 \\ 0 & L ( g _ { 2 } ^ { \prime } ) \end{bmatrix} \geq s .
```
  FIX: ```
$$
= s + \operatorname{rank} \begin{bmatrix} L(g_1^\prime) & 0 \\ L(g_3^\prime) & L(g_2^\prime) \end{bmatrix} - \operatorname{rank} \begin{bmatrix} L(g_1^\prime) & 0 \\ 0 & L(g_2^\prime) \end{bmatrix} \geq s.
$$
```
- RAW: ```
P ( y ) \xrightarrow { P ( \alpha ) } P ( x ) \xrightarrow { \varepsilon } M \to 0
```
  FIX: ```
$$
P(y) \xrightarrow{P(\alpha)} P(x) \xrightarrow{\varepsilon} M \to 0
$$
```
- RAW: ```
0 \to \tau V _ { I } \xrightarrow { \mu _ { I } } E _ { I } \xrightarrow { \varepsilon _ { I } } V _ { I } \to 0
```
  FIX: ```
$$
0 \to \tau V_I \xrightarrow{\mu_I} E_I \xrightarrow{\varepsilon_I} V_I \to 0
$$
```
- RAW: ```
d _ { M } ( V _ { I } ) = \text {rank} \, E _ { I } ( \alpha ) - \text {rank} \, V _ { I } ( \alpha ) - \text {rank} \, ( \tau V _ { I } ) ( \alpha ) .
```
  FIX: ```
$$
d_M(V_I) = \operatorname{rank} E_I(\alpha) - \operatorname{rank} V_I(\alpha) - \operatorname{rank} (\tau V_I)(\alpha).
$$
```
- RAW: ```
d _ { M } ( V _ { I } ) = \text {rank} [ \delta _ { ( a < x _ { i } , y _ { j } ) } a _ { j i } ] _ { ( j , i ) \in [ n ] \times [ m ] } - \text {rank} [ \delta _ { ( a \leq x _ { i } , y _ { j } ) } a _ { j i } ] _ { ( j , i ) \in [ n ] \times [ m ] } + n _ { M , I } . \\ \\ \intertext { d _ { M } ( V _ { I } ) = \text {rank} [ \delta _ { ( a < x _ { i } , y _ { j } ) } a _ { j i } ] _ { ( j , i ) \in [ n ] \times [ m ] } - \text {rank} [ \delta _ { ( a \leq x _ { i } , y _ { j } ) } a _ { j i } ] _ { ( j , i ) \in [ n ] \times [ m ] } + n _ { M , I } . \\
```
  FIX: ```
$$
d_M(V_I) = \operatorname{rank} [\delta_{(a < x_i, y_j)} a_{ji}]_{(j,i) \in [n] \times [m]} - \operatorname{rank} [\delta_{(a \leq x_i, y_j)} a_{ji}]_{(j,i) \in [n] \times [m]} + n_{M,I}.
$$
```

## REPAIR_PROSE
- RAW: ```
Hence we have r = s , and the proof is completed.
```
  FIX: ```
Hence we have \( r = s \), and the proof is completed.
```
- RAW: ```
For each M ∈ mod A and an each interval I of P , we compute, in this section, the multiplicity d M ( V I ) in terms of a projective presentation of M rather than the structure linear maps of M .
```
  FIX: ```
For each \( M \in \operatorname{mod} A \) and an each interval \( I \) of \( P \), we compute, in this section, the multiplicity \( d_M(V_I) \) in terms of a projective presentation of \( M \) rather than the structure linear maps of \( M \).
```
- RAW: ```
In what follows, for each event E such as ( x ≤ y ) for x,y ∈ P , we denote by δ E the k -valued indicator function of E : it takes value 1 ∈ k if E is true and 0 ∈ k otherwise. To shorten the notation, we write x ≤ y,z for x ≤ y and x ≤ z .
```
  FIX: ```
In what follows, for each event \( E \) such as \( (x \leq y) \) for \( x, y \in P \), we denote by \( \delta_E \) the \( k \)-valued indicator function of \( E \): it takes value \( 1 \in k \) if \( E \) is true and \( 0 \in k \) otherwise. To shorten the notation, we write \( x \leq y, z \) for \( x \leq y \) and \( x \leq z \).
```
- RAW: ```
Theorem 5.1. Let M ∈ mod A and I an interval of P . Then there exists a projective presentation
```
  FIX: ```
Theorem 5.1. Let \( M \in \operatorname{mod} A \) and \( I \) an interval of \( P \). Then there exists a projective presentation
```
- RAW: ```
of M for some morphism α : x → y in A , where we set x : = ( x i ) i ∈ [ m ] , y : = ( y j ) j ∈ [ n ] . Case 1: V I is non-projective. In this case, let
```
  FIX: ```
of \( M \) for some morphism \( \alpha : x \to y \) in \( A \), where we set \( x := (x_i)_{i \in [m]} \), \( y := (y_j)_{j \in [n]} \). Case 1: \( V_I \) is non-projective. In this case, let
```
- RAW: ```
be an almost split sequence ending in V I . Then we have the following formula:
```
  FIX: ```
be an almost split sequence ending in \( V_I \). Then we have the following formula:
```
- RAW: ```
Case 2: V I is projective. In this case, I = ↑ a with a = min I . We may set α = [ α ji ] ( j,i ) ∈ [ n ] × [ m ] , where α ji = a ji p y j ,x i for some a ji ∈ k and α ji = a ji = 0 unless x i ≤ y j for all ( j,i ) ∈ [ n ] × [ m ] . We set n M,I : = # { i ∈ [ m ] | x i = a } . Then we have the following formula:
```
  FIX: ```
Case 2: \( V_I \) is projective. In this case, \( I = \uparrow a \) with \( a = \min I \). We may set \( \alpha = [\alpha_{ji}]_{(j,i) \in [n] \times [m]} \), where \( \alpha_{ji} = a_{ji} p_{y_j, x_i} \) for some \( a_{ji} \in k \) and \( \alpha_{ji} = a_{ji} = 0 \) unless \( x_i \leq y_j \) for all \( (j,i) \in [n] \times [m] \). We set \( n_{M,I} := \# \{ i \in [m] \mid x_i = a \} \). Then we have the following formula:
```
- RAW: ```
Note that the right hand side is directly computed by information of α .
```
  FIX: ```
Note that the right hand side is directly computed by information of \( \alpha \).
```
- RAW: ```
Proof By Lemma 2.10 we can compute d M ( V I ) as follows:
```
  FIX: ```
Proof By Lemma 2.10 we can compute \( d_M(V_I) \) as follows:
```
