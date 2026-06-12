[Page 40]

# Exercise 1.5

Exercise 1.6

ﬁnite sum over these points

$$
\mathbb { E } [ f ] \simeq \frac { 1 } { N } \sum _ { n = 1 } ^ { N } f ( x _ { n } ) . \\ \intertext { s i v e o u s f o r $ n $ e x t h e r $ w $ e d i c u s s a p l i n g $ m e t h o d $ }
$$

We shall make extensive use of this result when we discuss sampling methods in Chapter 11. The approximation in (1.35) becomes exact in the limit N → ∞ . Sometimes we will be considering expectations of functions of several variables,

in which case we can use a subscript to indicate which variable is being averaged over, so that for instance

$$
\mathbb { E } _ { x } [ f ( x , y ) ]
$$

denotes the average of the function f ( x,y ) with respect to the distribution of x . Note that E x [ f ( x,y )] will be a function of y . We can also consider a with respect to a conditional

We can also consider a conditional expectation with respect to a conditional distribution, so that

$$
\mathbb { T } & & \mathbb { E } _ { x } [ f | y ] = \sum _ { x } p ( x | y ) f ( x ) & & ( 1 . 3 7 ) \\ \text {definition for continuous variables} & &
$$

with an analogous deﬁnition for continuous variables.

The variance of f ( x ) is deﬁned by

$$
v & [ f ] = \mathbb { E } \left [ ( f ( x ) - \mathbb { E } [ f ( x ) ] ) ^ { 2 } \right ] \\ \text {measure of how much variability there is in } f ( x ) \text { around its mean} \\ \text {Expanding out the square } & \text {we see that the variance can also be written}
$$

and provides a measure of how much variability there is in f ( x ) around its mean value E [ f ( x )] . Expanding out the square, we see that the variance can also be written in terms of the expectations of f ( x ) and f ( x ) 2

$$
v a r [ f ] = \mathbb { E } [ f ( x ) ^ { 2 } ] - \mathbb { E } [ f ( x ) ] ^ { 2 } .
$$

In particular, we can consider the variance of the variable x itself, which is given by

$$
v a r [ x ] = \mathbb { E } [ x ^ { 2 } ] - \mathbb { E } [ x ] ^ { 2 } .
$$

For two random variables x and y , the covariance is deﬁned by

$$
\begin{array} { r l r } { c o v [ x , y ] } & { = } & { \mathbb { E } _ { x , y } \left [ \{ x - \mathbb { E } [ x ] \} \{ y - \mathbb { E } [ y ] \} \right ] } \\ & { = } & { \mathbb { E } _ { x , y } [ x y ] - \mathbb { E } [ x ] \mathbb { E } [ y ] } \\ & { = } & { \mathbb { E } _ { x , y } [ x y ] - \mathbb { E } [ x ] \mathbb { E } [ y ] } \\ \end{array} \quad ( 1 . 4 1 ) \\
$$

which expresses the extent to which x and y vary together. If x and y are independent, then their covariance vanishes.

In the case of two vectors of random variables x and y , the covariance is a matrix

$$
\begin{array} { r l } { \tt n i l c a { s o r } { t i v o r s o r } { i n d a n t i v a b l e s } { x a n d y , t i l e c o v a n l a c e s } { i s a l a u x } } \\ { \c o v [ x , y ] } & { = } & { \mathbb { E } _ { x , y } \left [ \{ x - \mathbb { E } [ x ] \} \{ y ^ { T } - \mathbb { E } [ y ^ { T } ] \} \right ] } \\ & { = } & { \mathbb { E } _ { x , y } [ x y ^ { T } ] - \mathbb { E } [ x ] \mathbb { E } [ y ^ { T } ] . } \\ { \tt n i l c a { s o r } { t i v o r s o r } { i n d a n t i v a b l e s } { t h o w } } \end{array}
$$
