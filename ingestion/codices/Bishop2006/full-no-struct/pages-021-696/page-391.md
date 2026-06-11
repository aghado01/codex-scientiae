[Page 391]

Figure 8.14 A directed graph over three Gaussian variables, with one missing link.

x

x

x

![image 173](../images/imageFile173.png)

1

2

3

Section 2.3

Exercise 8.7

Thus we can ﬁnd the components of E [ x ] = ( E [ x 1 ] ,..., E [ x D ]) T by starting at the lowest numbered node and working recursively through the graph (here we again assume that the nodes are numbered such that each node has a higher number than its parents). Similarly, we can use (8.14) and (8.15) to obtain the i,j element of the covariance matrix for p ( x ) in the form of a recursion relation

$$
\text {covariance matrix for } p ( x ) \text { in the form of } & a \text { recursion relation} \\ & \text {cov} [ x _ { i } , x _ { j } ] \ = \ \mathbb { E } \left [ ( x _ { i } - \mathbb { E } [ x _ { i } ] ) ( x _ { j } - \mathbb { E } [ x _ { j } ] ) \right ] \\ & = \ \mathbb { E } \left [ ( x _ { i } - \mathbb { E } [ x _ { i } ] ) \left \{ \sum _ { k \in \rho _ { j } } \ w _ { j k } ( x _ { k } - \mathbb { E } [ x _ { k } ] ) + \sqrt { v _ { j } } \epsilon _ { j } \right \} \right ] \\ & = \ \sum _ { k \in \rho _ { j } } \ w _ { j k } c o v [ x _ { i } , x _ { k } ] + I _ { i j } v _ { j } \\ & \text { and so the covariance can similarly be evaluated recursively starting from the lowest}
$$

and so the covariance can similarly be evaluated recursively starting from the lowest numbered node.

Let us consider two extreme cases. First of all, suppose that there are no links in the graph, which therefore comprises D isolated nodes. In this case, there are no parameters w ij and so there are just D parameters b i and D parameters v i . From the recursion relations (8.15) and (8.16), we see that the mean of p ( x ) is given by ( b 1 ,...,b D ) T and the covariance matrix is diagonal of the form diag( v 1 ,...,v D ) . The joint distribution has a total of 2 D parameters and represents a set of D independent univariate Gaussian distributions.

Now consider a fully connected graph in which each node has all lower numbered nodes as parents. The matrix w ij then has i − 1 entries on the i th row and hence is a lower triangular matrix (with no entries on the leading diagonal). Then the total number of parameters w ij is obtained by taking the number D 2 of elements in a D × D matrix, subtracting D to account for the absence of elements on the leading diagonal, and then dividing by 2 because the matrix has elements only below the diagonal, giving a total of D ( D − 1) / 2 . The total number of independent parameters { w ij } and { v i } in the covariance matrix is therefore D ( D + 1) / 2 corresponding to a general symmetric covariance matrix.

Graphs having some intermediate level of complexity correspond to joint Gaussian distributions with partially constrained covariance matrices. Consider for example the graph shown in Figure 8.14, which has a link missing between variables x 1 and x 3 . Using the recursion relations (8.15) and (8.16), we see that the mean and covariance of the joint distribution are given by

$$
\mu \ = \ ( b _ { 1 } , b _ { 2 } + w _ { 2 1 } b _ { 1 } , b _ { 3 } + w _ { 3 2 } b _ { 2 } + w _ { 3 2 } w _ { 2 1 } b _ { 1 } ) ^ { T }
$$

$$
\mu \ = \ ( b _ { 1 } , b _ { 2 } + w _ { 2 1 } b _ { 1 } , b _ { 3 } + w _ { 3 2 } b _ { 2 } + w _ { 3 2 } w _ { 2 1 } b _ { 1 } ) ^ { 1 } \\ \Sigma \ = \ \left ( \begin{array} { c c } v _ { 1 } & w _ { 2 1 } v _ { 1 } & w _ { 3 2 } w _ { 2 1 } v _ { 1 } \\ w _ { 2 1 } v _ { 1 } & v _ { 2 } + w _ { 2 1 } ^ { 2 } v _ { 1 } & w _ { 3 2 } ( v _ { 2 } + w _ { 2 1 } ^ { 2 } v _ { 1 } ) \\ w _ { 3 2 } w _ { 2 1 } v _ { 1 } & w _ { 3 2 } ( v _ { 2 } + w _ { 2 1 } ^ { 2 } v _ { 1 } ) & v _ { 3 } + w _ { 3 2 } ^ { 2 } ( v _ { 2 } + w _ { 2 1 } ^ { 2 } v _ { 1 } ) \end{array} \right ) .
$$
