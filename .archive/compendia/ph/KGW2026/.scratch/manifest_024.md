# Manifest: Page 024

## REPAIR_MATH
- RAW: ```
\frac { x _ { j } ^ { * } } { x _ { j } } = \xi \ a n d \ \frac { x _ { j } ^ { * } } { x _ { j } } = \xi ^ { - 1 } ,
```
  FIX: ```
$$
\frac { x _ { j } ^ { * } } { x _ { j } } = \xi \ a n d \ \frac { x _ { j } ^ { * } } { x _ { j } } = \xi ^ { - 1 } ,
$$
```
- RAW: ```
A _ { i , i } = x _ { i } , \quad A _ { i + 1 , i } = x _ { i } ^ { * } , \quad A _ { 1 , n } = x _ { n } ^ { * } ,
```
  FIX: ```
$$
A _ { i , i } = x _ { i } , \quad A _ { i + 1 , i } = x _ { i } ^ { * } , \quad A _ { 1 , n } = x _ { n } ^ { * } ,
$$
```
- RAW: ```
x _ { 1 } y _ { 1 } + x _ { n } ^ { * } y _ { n } = 0 , \quad x _ { i - 1 } ^ { * } y _ { i - 1 } + x _ { i } y _ { i } = 0 , \quad i = 2 , \dots , n .
```
  FIX: ```
$$
x _ { 1 } y _ { 1 } + x _ { n } ^ { * } y _ { n } = 0 , \quad x _ { i - 1 } ^ { * } y _ { i - 1 } + x _ { i } y _ { i } = 0 , \quad i = 2 , \dots , n .
$$
```
- RAW: ```
y _ { i } = - \frac { x _ { i - 1 } ^ { * } } { x _ { i } } y _ { i - 1 } , \ i = 2 , \dots , n \Rightarrow y _ { n } = ( - 1 ) ^ { n - 1 } \prod _ { i = 2 } ^ { n } \frac { x _ { i - 1 } ^ { * } } { x _ { i } } \, y _ { 1 }
```
  FIX: ```
$$
y _ { i } = - \frac { x _ { i - 1 } ^ { * } } { x _ { i } } y _ { i - 1 } , \ i = 2 , \dots , n \Rightarrow y _ { n } = ( - 1 ) ^ { n - 1 } \prod _ { i = 2 } ^ { n } \frac { x _ { i - 1 } ^ { * } } { x _ { i } } \, y _ { 1 }
$$
```
- RAW: ```
0 = x _ { 1 } y _ { 1 } + x _ { n } ^ { * } y _ { n } = x _ { 1 } y _ { 1 } + ( - 1 ) ^ { n - 1 } x _ { n } ^ { * } \prod _ { i = 2 } ^ { n } \frac { x _ { i - 1 } ^ { * } } { x _ { i } } \, y _ { 1 } ,
```
  FIX: ```
$$
0 = x _ { 1 } y _ { 1 } + x _ { n } ^ { * } y _ { n } = x _ { 1 } y _ { 1 } + ( - 1 ) ^ { n - 1 } x _ { n } ^ { * } \prod _ { i = 2 } ^ { n } \frac { x _ { i - 1 } ^ { * } } { x _ { i } } \, y _ { 1 } ,
$$
```
- RAW: ```
( - 1 ) ^ { n } \prod _ { i = 1 } ^ { n } \frac { x _ { i } ^ { * } } { x _ { i } } = 1 .
```
  FIX: ```
$$
( - 1 ) ^ { n } \prod _ { i = 1 } ^ { n } \frac { x _ { i } ^ { * } } { x _ { i } } = 1 .
$$
```
- RAW: ```
u _ { 1 } + u _ { 2 } = n , \quad \prod _ { i = 1 } ^ { n } \frac { x _ { i } ^ { * } } { x _ { i } } = \xi ^ { u _ { 1 } - u _ { 2 } } .
```
  FIX: ```
$$
u _ { 1 } + u _ { 2 } = n , \quad \prod _ { i = 1 } ^ { n } \frac { x _ { i } ^ { * } } { x _ { i } } = \xi ^ { u _ { 1 } - u _ { 2 } } .
$$
```
- RAW: ```
( - 1 ) ^ { n } \xi ^ { u _ { 1 } - u _ { 2 } } = 1
```
  FIX: ```
$$
( - 1 ) ^ { n } \xi ^ { u _ { 1 } - u _ { 2 } } = 1
$$
```
- RAW: ```
\xi ^ { u _ { 1 } - u _ { 2 } } = 1 \Rightarrow u _ { 1 } - u _ { 2 } \equiv 0 \pmod { N }
```
  FIX: ```
$$
\xi ^ { u _ { 1 } - u _ { 2 } } = 1 \Rightarrow u _ { 1 } - u _ { 2 } \equiv 0 \pmod { N }
$$
```
- RAW: ```
\xi ^ { u _ { 1 } - u _ { 2 } } = - 1 .
```
  FIX: ```
$$
\xi ^ { u _ { 1 } - u _ { 2 } } = - 1 .
$$
```
- RAW: ```
u _ { 1 } - u _ { 2 } \equiv \frac { N } { 2 } \pmod { N } .
```
  FIX: ```
$$
u _ { 1 } - u _ { 2 } \equiv \frac { N } { 2 } \pmod { N } .
$$
```
- RAW: ```
Proof. Let A be the matrix associated to the above cycle, defined by
```
  FIX: ```
Proof. Let \( A \) be the matrix associated to the above cycle, defined by
```
- RAW: ```
Substituting into the first equation and using y 1 ̸ = 0, we obtain
```
  FIX: ```
Substituting into the first equation and using \( y_1 \neq 0 \), we obtain
```
- RAW: ```
If n is even, this reduces to
```
  FIX: ```
If \( n \) is even, this reduces to
```

## REPAIR_PROSE
- RAW: ```
with indices modulo n , where x i ∈ { 1 ,ξ } , x i x ∗ i = ξ , and all other entries of A are zero. Suppose there exists a nonzero vector y = ( y 1 ,...,y n ) T ∈ C n such that Ay = 0. Then

= 0. Then
```
  FIX: ```
with indices modulo \( n \), where \( x_i \in \{1, \xi\} \), \( x_i x_i^* = \xi \), and all other entries of \( A \) are zero. Suppose there exists a nonzero vector \( y = (y_1, \dots, y_n)^T \in \mathbb{C}^n \) such that \( Ay = 0 \). Then
```
- RAW: ```
Observe that for each i , x ∗ i x i ∈ { ξ,ξ − 1 } . Let u 1 denote the number of indices i for which x ∗ i x i = ξ , and let u 2 denote the number of indices i for which x ∗ i x i = ξ − 1 . Then

Then
```
  FIX: ```
Observe that for each \( i \), \( \frac{x_i^*}{x_i} \in \{\xi, \xi^{-1}\} \). Let \( u_1 \) denote the number of indices \( i \) for which \( \frac{x_i^*}{x_i} = \xi \), and let \( u_2 \) denote the number of indices \( i \) for which \( \frac{x_i^*}{x_i} = \xi^{-1} \). Then
```
- RAW: ```
If n is odd, we obtain Conversely, if these conditions hold, the recursion defines a nonzero vector y satisfying Ay = 0, and hence

$$
\xi ^ { u _ { 1 } - u _ { 2 } } = - 1 .
$$

This is possible only when N is even, in which case

$$
u _ { 1 } - u _ { 2 } \equiv \frac { N } { 2 } \pmod { N } .
$$
```
  FIX: ```
If \( n \) is odd, we obtain

$$
\xi ^ { u _ { 1 } - u _ { 2 } } = - 1 .
$$

This is possible only when \( N \) is even, in which case

$$
u _ { 1 } - u _ { 2 } \equiv \frac { N } { 2 } \pmod { N } .
$$

Conversely, if these conditions hold, the recursion defines a nonzero vector \( y \) satisfying \( Ay = 0 \), and hence
```

