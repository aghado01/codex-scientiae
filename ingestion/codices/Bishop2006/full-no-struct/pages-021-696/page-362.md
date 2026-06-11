[Page 362]

$$
\widetilde { L } ( a , \widehat { a } ) \ = \ - \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \sum _ { m = 1 } ^ { N } ( a _ { n } - \widehat { a } _ { n } ) ( a _ { m } - \widehat { a } _ { m } ) k ( x _ { n } , x _ { m } ) \\ - \epsilon \sum _ { n = 1 } ^ { N } ( a _ { n } + \widehat { a } _ { n } ) + \sum _ { n = 1 } ^ { N } ( a _ { n } - \widehat { a } _ { n } ) t _ { n } \\ \intertext { w i t h e s e c t o w } \phi ( x ) ^ { T } \phi ( x ^ { \prime } ) . \text { Again, this is a constrained maximization, and to find the constraints }
$$

with respect to { a n } and { a n } , where we have introduced the kernel k ( x , x ) = φ ( x ) T φ ( x ) . Again, this is a constrained maximization, and to ﬁnd the constraints we note that a n 0 and a n 0 are both required because these are Lagrange multipliers. Also µ n 0 and µ n 0 together with (7.59) and (7.60), require a n C and a n C , and so again we have the box constraints 0 a n C (7.62) 0 a n C (7.63)

$$
0 \leqslant a _ { n } \leqslant C \\ 0 \leqslant \widehat { a } _ { n } \leqslant C \\ \intertext { o n } ( 7 . 5 8 ) . \intertext { t o n } \intertext { o n } ( 7 . 1 ) , \, w e s e t h a t d i p e r i d i c t s \, f o r \, w e n \, i n p u s \, c a n \, b e \, m a d e
$$

together with the condition (7.58).

Substituting (7.57) into (7.1), we see that predictions for new inputs can be made using

$$
y ( x ) = \sum _ { n = 1 } ^ { N } ( a _ { n } - \widehat { a } _ { n } ) k ( x , x _ { n } ) + b \\ \intertext { f o r s e p a g r e s d i m e n t i o n s } \text {responding Karush-Kuhn-Tucker (KKT) conditions, which state that at }
$$

which is again expressed in terms of the kernel function.

The corresponding Karush-Kuhn-Tucker (KKT) conditions, which state that at the solution the product of the dual variables and the constraints must vanish, are given by

$$
a _ { n } ( \epsilon + \xi _ { n } + y _ { n } - t _ { n } ) \ & = \ 0 \\ \widehat { \widehat { s } } _ { ( \widehat { \epsilon } , \, + \, \widehat { \zeta } ) } & \, + \, \widehat { \zeta } _ { ( \, + \, \widehat { \zeta } ) } \\
$$

$$
\begin{array} { c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c
$$

( C − a n ) ξ n = 0 . (7.68) From these we can obtain several useful results. First of all, we note that a coefﬁcient a n can only be nonzero if + ξ n + y n − t n = 0 , which implies that the data point either lies on the upper boundary of the -tube ( ξ n = 0 ) or lies above the upper boundary ( ξ n > 0 ). Similarly, a nonzero value for a n implies + ξ n − y n + t n = 0 , and such points must lie either on or below the lower boundary of the -tube. Furthermore, the two constraints + ξ n + y n − t n = 0 and + ξ n − y n + t n = 0 are incompatible, as is easily seen by adding them together and noting that ξ and

Furthermore, the two constraints /epsilon1 + ξ n + y n -t n = 0 and /epsilon1 + ̂ ξ n -y n + t n = 0 are incompatible, as is easily seen by adding them together and noting that ξ n and ̂ ξ n are nonnegative while /epsilon1 is strictly positive, and so for every data point x n , either a n or a n (or both) must be zero.

̂ The support vectors are those data points that contribute to predictions given by (7.64), in other words those for which either a n = 0 or ̂ a n = 0 . These are points that lie on the boundary of the /epsilon1 -tube or outside the tube. All points within the tube have Appendix A

/negationslash

/negationslash
