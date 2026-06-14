[Page 26]

Therefore (2) and (3) can be rewritten as

$$
y _ { 1 , 1 } ( x _ { 1 } ) _ { 1 } + y _ { 2 , 1 } ( - 1 ) ^ { a _ { 2 } - 1 } \prod _ { l = 1 } ^ { a _ { 2 } - 1 } \frac { ( x _ { 2 } ) _ { l } ^ { * } } { ( x _ { 2 } ) _ { l + 1 } } ( x _ { 2 } ) _ { a _ { 2 } } ^ { * } + y _ { 3 , 1 } ( - 1 ) ^ { a _ { 3 } - 1 } \prod _ { l = 1 } ^ { a _ { 3 } - 1 } \frac { ( x _ { 3 } ) _ { l } ^ { * } } { ( x _ { 3 } ) _ { l + 1 } } ( x _ { 3 } ) _ { a _ { 3 } } ^ { * } = 0
$$

$$
y _ { 1 , 1 } ( - 1 ) ^ { a _ { 1 } - 1 } \prod _ { l = 1 } ^ { a _ { 1 } - 1 } \frac { ( x _ { 1 } ) _ { l } ^ { * } } { ( x _ { 1 } ) _ { l + 1 } } ( x _ { 1 } ) _ { a _ { 1 } } ^ { * } + y _ { 2 , 1 } ( x _ { 2 } ) _ { 1 } + y _ { 3 , 1 } ( x _ { 3 } ) _ { 1 } = 0 \\
$$

Substituting into (2) and (3) gives a system

$$
A ^ { \prime } y ^ { \prime } = 0 , \ \ y ^ { \prime } = ( y _ { 1 , 1 } , y _ { 2 , 1 } , y _ { 3 , 1 } ) ^ { T } ,
$$

where

$$
A ^ { \prime } = \left [ \begin{array} { c c c } ( x _ { 1 } ) _ { 1 } & ( - 1 ) ^ { a _ { 2 } - 1 } \prod _ { l = 1 } ^ { a _ { 2 } - 1 } \frac { ( x _ { 2 } ) _ { l } ^ { * } } { ( x _ { 2 } ) _ { l + 1 } } ( x _ { 2 } ) _ { a _ { 2 } } ^ { * } & ( - 1 ) ^ { a _ { 3 } - 1 } \prod _ { l = 1 } ^ { a _ { 3 } - 1 } \frac { ( x _ { 3 } ) _ { l } ^ { * } } { ( x _ { 3 } ) _ { l + 1 } } ( x _ { 3 } ) _ { m } ^ { * } \end{array} \right ] \\ A ^ { \prime } = \left [ \begin{array} { c c c } ( - 1 ) ^ { a _ { 1 } - 1 } \prod _ { l = 1 } ^ { a _ { 1 } - 1 } \frac { ( x _ { 1 } ) _ { l } ^ { * } } { ( x _ { 1 } ) _ { l + 1 } } ( x _ { 1 } ) _ { a _ { 1 } } ^ { * } & ( x _ { 2 } ) _ { 1 } & ( x _ { 3 } ) _ { 1 } \end{array} \right ]
$$

Consider the \( 2 \times 2 \) minor formed by the first two columns. Its determinant is

$$
( x _ { 1 } ) _ { 1 } ( x _ { 2 } ) _ { 1 } - ( - 1 ) ^ { a _ { 1 } + a _ { 2 } } \prod _ { l = 1 } ^ { a _ { 1 } } \frac { ( x _ { 1 } ) _ { l } ^ { * } } { ( x _ { 1 } ) _ { l } } \prod _ { l = 1 } ^ { a _ { 2 } } \frac { ( x _ { 2 } ) _ { l } ^ { * } } { ( x _ { 2 } ) _ { l } } .
$$

Since \( I \) and \( J \) are non-admissible, we have

$$
( - 1 ) ^ { a _ { 1 } + a _ { 2 } } \prod _ { l = 1 } ^ { a _ { 1 } } \frac { ( x _ { 1 } ) _ { l } ^ { * } } { ( x _ { 1 } ) _ { l } } \prod _ { l = 1 } ^ { a _ { 2 } } \frac { ( x _ { 2 } ) _ { l } ^ { * } } { ( x _ { 2 } ) _ { l } } \neq 1 ,
$$


so the determinant is nonzero. Hence \( \operatorname{rank}( A ^ { \prime } ) = 2 \).

Since \( A ^ { \prime } \) is a \( 2 \times 3 \) matrix, we obtain

$$
\dim \ker ( A ^ { \prime } ) = 3 - 2 = 1 ,
$$

so there exists a nontrivial solution \( y ^ { \prime } \neq 0 \).


Now define coefficients along each path by

$$
y _ { t , r } = ( - 1 ) ^ { r - 1 } \left ( \prod _ { \ell = 1 } ^ { r - 1 } \frac { ( x _ { t } ) _ { \ell } ^ { * } } { ( x _ { t } ) _ { \ell + 1 } } \right ) y _ { t , 1 } , \ \ r = 1 , \dots , a _ { t } , \ \ t = 1 , 2 , 3 .
$$

Let \( e _ { t , r } \) denote the oriented edge in position \( r \) of the path \( P _ { t } \). Define the weighted element

$$
\omega = \sum _ { t = 1 } ^ { 3 } \sum _ { r = 1 } ^ { a _ { t } } y _ { t , r } \, e _ { t , r } .
$$

Then equation (1) ensures cancellation at all interior vertices of each path, while \( A ^ { \prime } y ^ { \prime } = 0 \) ensures cancellation at the shared vertices. Hence

$$
\partial _ { 1 } ( \omega ) = 0 .
$$

Since \( y ^ { \prime } \neq 0 \), we have \( \omega \neq 0 \). Therefore \( \omega \) is a nonzero weighted element supported on \( I \cup J \) lying in \( \ker ( \partial _ { 1 } ) \).


