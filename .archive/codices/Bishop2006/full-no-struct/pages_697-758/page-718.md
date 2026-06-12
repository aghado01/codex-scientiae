[Page 718]

Similarly

$$
\frac { \partial } { \partial x } \left ( A B \right ) = \frac { \partial A } { \partial x } B + A \frac { \partial B } { \partial x } .
$$

The derivative of the inverse of a matrix can be expressed as

$$
\frac { \partial } { \partial x } \left ( A ^ { - 1 } \right ) = - A ^ { - 1 } \frac { \partial A } { \partial x } A ^ { - 1 } & & ( C . 2 1 ) \\ \intertext { b y d i f f e r e n t i a g t i n g t h e q u a t i o n A ^ { - 1 } A = I \, u s i g ( C . 2 0 ) \, a n d \, t h e r }
$$

as can be shown by differentiating the equation A − 1 A = I using (C.20) and then right multiplying by A − 1 . Also

$$
\frac { \partial } { \partial x } \ln | A | = \text {Tr} \left ( A ^ { - 1 } \frac { \partial A } { \partial x } \right ) \\ \intertext { w h e r e } \intertext { s u n t h e f w h e r e }
$$

which we shall prove later. If we choose x to be one of the elements of A , we have

$$
\frac { \partial } { \partial A _ { i j } } \text {Tr} \left ( A B \right ) = B _ { j i }
$$

as can be seen by writing out the matrices using index notation. We can write this result more compactly in the form

$$
\frac { \partial } { \partial A } T r \left ( A B \right ) = B ^ { T } .
$$

With this notation, we have the following properties

$$
\frac { \partial } { \partial A } \text {Tr} \left ( A ^ { \top } B \right ) \ = \ B & & ( C . 2 5 ) \\ \frac { \partial } { \partial A } \text {Tr} ( A ) \ = \ I & & ( C . 2 6 )
$$

$$
\int _ { 0 } ^ { \infty } \frac { \partial } { \partial A } T r ( A ) \ = \ I
$$

$$
\frac { \partial } { \partial A } T r ( A B A ^ { T } ) \ = \ A ( B + B ^ { T } )
$$

which can again be proven by writing out the matrix indices. We also have

$$
\frac { \partial } { \partial A } \ln | A | = \left ( A ^ { - 1 } \right ) ^ { T } \\ C . 2 2 ) \text { and } ( C . 2 6 ) .
$$

which follows from (C.22) and (C.26).

# Eigenvector Equation

For a square matrix A of size M × M , the eigenvector equation is deﬁned by

$$
A u _ { i } = \lambda _ { i } u _ { i }
$$
