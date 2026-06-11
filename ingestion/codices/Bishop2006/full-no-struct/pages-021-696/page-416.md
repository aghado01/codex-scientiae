[Page 416]

$$
the desired marginal in the form \\ p ( x _ { n } ) = \frac { 1 } { Z } \\ \underbrace { \left [ \sum _ { x _ { n } - 1 } \psi _ { n - 1 , n } ( x _ { n - 1 } , x _ { n } ) \cdots \left [ \sum _ { x _ { 2 } } \psi _ { 2 , 3 } ( x _ { 2 } , x _ { 3 } ) \left [ \sum _ { x _ { 1 } } \psi _ { 1 , 2 } ( x _ { 1 } , x _ { 2 } ) \right ] \right ] \cdots \right ] } _ { \mu _ { B } ( x _ { n } ) } \\ \underbrace { \left [ \sum _ { x _ { n + 1 } } \psi _ { n , n + 1 } ( x _ { n } , x _ { n + 1 } ) \cdots \left [ \sum _ { x _ { n } } \psi _ { N - 1 , N } ( x _ { N - 1 } , x _ { N } ) \right ] \cdots \right ] } _ { \mu _ { B } ( x _ { n } ) } \, . \\ \\ The reader is encouraged to study this re-ordering carefully as the underlying idea
forms the basis for the later discussion of the general sum-product algorithm.  Here
the key concept that we are exploiting is that multiplication is distribute over addi-


$$

The reader is encouraged to study this re-ordering carefully as the underlying idea forms the basis for the later discussion of the general sum-product algorithm. Here the key concept that we are exploiting is that multiplication is distributive over addition, so that

$$
a b + a c = a ( b + c )
$$

in which the left-hand side involves three arithmetic operations whereas the righthand side reduces this to two operations.

Let us work out the computational cost of evaluating the required marginal using this re-ordered expression. We have to perform N − 1 summations each of which is over K states and each of which involves a function of two variables. For instance, the summation over x 1 involves only the function ψ 1 , 2 ( x 1 ,x 2 ) , which is a table of K × K numbers. We have to sum this table over x 1 for each value of x 2 and so this has O ( K 2 ) cost. The resulting vector of K numbers is multiplied by the matrix of numbers ψ 2 , 3 ( x 2 ,x 3 ) and so is again O ( K 2 ) . Because there are N − 1 summations and multiplications of this kind, the total cost of evaluating the marginal p ( x n ) is O ( NK 2 ) . This is linear in the length of the chain, in contrast to the exponential cost of a naive approach. We have therefore been able to exploit the many conditional independence properties of this simple graph in order to obtain an efﬁcient calculation. If the graph had been fully connected, there would have been no conditional independence properties, and we would have been forced to work directly with the full joint distribution.

We now give a powerful interpretation of this calculation in terms of the passing of local messages around on the graph. From (8.52) we see that the expression for the marginal p ( x n ) decomposes into the product of two factors times the normalization constant 1

$$
p ( x _ { n } ) = \frac { 1 } { Z } \mu _ { \alpha } ( x _ { n } ) \mu _ { \beta } ( x _ { n } ) .
$$

We shall interpret µ α ( x n ) as a message passed forwards along the chain from node x n − 1 to node x n . Similarly, µ β ( x n ) can be viewed as a message passed backwards
