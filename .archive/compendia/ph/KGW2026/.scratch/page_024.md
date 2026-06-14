[Page 24]

respectively.

$$
\frac { x _ { j } ^ { * } } { x _ { j } } = \xi \ a n d \ \frac { x _ { j } ^ { * } } { x _ { j } } = \xi ^ { - 1 } ,
$$

Proof. Let \( A \) be the matrix associated to the above cycle, defined by

$$
A _ { i , i } = x _ { i } , \quad A _ { i + 1 , i } = x _ { i } ^ { * } , \quad A _ { 1 , n } = x _ { n } ^ { * } ,
$$

with indices modulo \( n \), where \( x_i \in \{1, \xi\} \), \( x_i x_i^* = \xi \), and all other entries of \( A \) are zero. Suppose there exists a nonzero vector \( y = (y_1, \dots, y_n)^T \in \mathbb{C}^n \) such that \( Ay = 0 \). Then

$$
x _ { 1 } y _ { 1 } + x _ { n } ^ { * } y _ { n } = 0 , \quad x _ { i - 1 } ^ { * } y _ { i - 1 } + x _ { i } y _ { i } = 0 , \quad i = 2 , \dots , n .
$$

From the latter equations we obtain the recursion

$$
y _ { i } = - \frac { x _ { i - 1 } ^ { * } } { x _ { i } } y _ { i - 1 } , \ i = 2 , \dots , n \Rightarrow y _ { n } = ( - 1 ) ^ { n - 1 } \prod _ { i = 2 } ^ { n } \frac { x _ { i - 1 } ^ { * } } { x _ { i } } \, y _ { 1 }
$$

Substituting into the first equation and using \( y_1 \neq 0 \), we obtain


$$
0 = x _ { 1 } y _ { 1 } + x _ { n } ^ { * } y _ { n } = x _ { 1 } y _ { 1 } + ( - 1 ) ^ { n - 1 } x _ { n } ^ { * } \prod _ { i = 2 } ^ { n } \frac { x _ { i - 1 } ^ { * } } { x _ { i } } \, y _ { 1 } ,
$$

which simplifies to

$$
( - 1 ) ^ { n } \prod _ { i = 1 } ^ { n } \frac { x _ { i } ^ { * } } { x _ { i } } = 1 .
$$

Observe that for each \( i \), \( \frac{x_i^*}{x_i} \in \{\xi, \xi^{-1}\} \). Let \( u_1 \) denote the number of indices \( i \) for which \( \frac{x_i^*}{x_i} = \xi \), and let \( u_2 \) denote the number of indices \( i \) for which \( \frac{x_i^*}{x_i} = \xi^{-1} \). Then

$$
u _ { 1 } + u _ { 2 } = n , \quad \prod _ { i = 1 } ^ { n } \frac { x _ { i } ^ { * } } { x _ { i } } = \xi ^ { u _ { 1 } - u _ { 2 } } .
$$

Hence the kernel condition becomes

$$
( - 1 ) ^ { n } \xi ^ { u _ { 1 } - u _ { 2 } } = 1
$$

If \( n \) is even, this reduces to

$$
\xi ^ { u _ { 1 } - u _ { 2 } } = 1 \Rightarrow u _ { 1 } - u _ { 2 } \equiv 0 \pmod { N }
$$

If \( n \) is odd, we obtain

$$
\xi ^ { u _ { 1 } - u _ { 2 } } = - 1 .
$$

This is possible only when \( N \) is even, in which case

$$
u _ { 1 } - u _ { 2 } \equiv \frac { N } { 2 } \pmod { N } .
$$

Conversely, if these conditions hold, the recursion defines a nonzero vector \( y \) satisfying \( Ay = 0 \), and hence
