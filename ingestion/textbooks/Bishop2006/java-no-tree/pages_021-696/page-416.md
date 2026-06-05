[Page 416]

the desired marginal in the form

1 ⎡ Z

p(xn) =

###### ⎤ ⎦

⎣ xn−1

ψn−1,n(xn−1,xn)···

ψ2,3(x2,x3)

ψ1,2(x1,x2) ···

x2

x1

µα(xn)

###### ⎡

###### ⎤ ⎦

⎣ xn+1

ψn,n+1(xn,xn+1)···

ψN−1,N(xN−1,xN) ···

. (8.52)

xN

µβ(xn)

The reader is encouraged to study this re-ordering carefully as the underlying idea forms the basis for the later discussion of the general sum-product algorithm. Here the key concept that we are exploiting is that multiplication is distributive over addition, so that

###### ab + ac = a(b + c) (8.53)

in which the left-hand side involves three arithmetic operations whereas the righthand side reduces this to two operations.

Let us work out the computational cost of evaluating the required marginal using this re-ordered expression. We have to perform N − 1 summations each of which is over K states and each of which involves a function of two variables. For instance, the summation over x1 involves only the function ψ1,2(x1,x2), which is a table of K × K numbers. We have to sum this table over x1 for each value of x2 and so this has O(K2) cost. The resulting vector of K numbers is multiplied by the matrix of numbers ψ2,3(x2,x3) and so is again O(K2). Because there are N − 1 summations and multiplications of this kind, the total cost of evaluating the marginal p(xn) is O(NK2). This is linear in the length of the chain, in contrast to the exponential cost of a naive approach. We have therefore been able to exploit the many conditional independence properties of this simple graph in order to obtain an efﬁcient calculation. If the graph had been fully connected, there would have been no conditional independence properties, and we would have been forced to work directly with the full joint distribution.

We now give a powerful interpretation of this calculation in terms of the passing of local messages around on the graph. From (8.52) we see that the expression for the marginal p(xn) decomposes into the product of two factors times the normalization constant

1 Z

p(xn) =

µα(xn)µβ(xn). (8.54)

We shall interpret µα(xn) as a message passed forwards along the chain from node xn−1 to node xn. Similarly, µβ(xn) can be viewed as a message passed backwards
