[Page 391]

- Figure 8.14 A directed graph over three Gaussian variables, with one missing link.


###### x1 x2 x3

Thus we can ﬁnd the components of E[x] = (E[x1],...,E[xD])T by starting at the lowest numbered node and working recursively through the graph (here we again assume that the nodes are numbered such that each node has a higher number than its parents). Similarly, we can use (8.14) and (8.15) to obtain the i,j element of the covariance matrix for p(x) in the form of a recursion relation

cov[xi,xj] = E[(xi − E[xi])(xj − E[xj])]

###### ⎧ ⎨

###### ⎫ ⎬

⎡ ⎣(xi − E[xi])

###### ⎤ ⎦

wjk(xk − E[xk]) + √vj j

= E

###### ⎩

###### ⎭

k∈paj

###### =

wjkcov[xi,xk] + Iijvj (8.16)

k∈paj

and so the covariance can similarly be evaluated recursively starting from the lowest numbered node.

Let us consider two extreme cases. First of all, suppose that there are no links in the graph, which therefore comprises D isolated nodes. In this case, there are no parameters wij and so there are just D parameters bi and D parameters vi. From the recursion relations (8.15) and (8.16), we see that the mean of p(x) is given by (b1,...,bD)T and the covariance matrix is diagonal of the form diag(v1,...,vD). The joint distribution has a total of 2D parameters and represents a set of D independent univariate Gaussian distributions.

Now consider a fully connected graph in which each node has all lower num-

bered nodes as parents. The matrix wij then has i − 1 entries on the ith row and hence is a lower triangular matrix (with no entries on the leading diagonal). Then

the total number of parameters wij is obtained by taking the number D2 of elements in a D×D matrix, subtracting D to account for the absence of elements on the leading diagonal, and then dividing by 2 because the matrix has elements only below the diagonal, giving a total of D(D−1)/2. The total number of independent parameters {wij} and {vi} in the covariance matrix is therefore D(D + 1)/2 corresponding to

Section 2.3 a general symmetric covariance matrix.

Graphs having some intermediate level of complexity correspond to joint Gaussian distributions with partially constrained covariance matrices. Consider for example the graph shown in Figure 8.14, which has a link missing between variables x1 and x3. Using the recursion relations (8.15) and (8.16), we see that the mean and

Exercise 8.7 covariance of the joint distribution are given by µ = (b1,b2 + w21b1,b3 + w32b2 + w32w21b1)T (8.17) Σ =

- v1 w21v1 w32w21v1
- w21v1 v2 + w212 v1 w32(v2 + w212 v1)


. (8.18)

w32w21v1 w32(v2 + w212 v1) v3 + w322 (v2 + w212 v1)
