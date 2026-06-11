[Page 354]

$$
t _ { n } y ( x _ { n } ) = 1 - \xi _ { n } .
$$

If a n < C , then (7.31) implies that µ n > 0 , which from (7.28) requires ξ n = 0 and hence such points lie on the margin. Points with a n = C can lie inside the margin and can either be correctly classiﬁed if ξ n 1 or misclassiﬁed if ξ n > 1 . To determine the parameter b in (7.1), we note that those support vectors for

which 0 < a n < C have ξ n = 0 so that t n y ( x n ) = 1 and hence will satisfy

$$
t _ { n } \left ( \sum _ { m \in \mathcal { S } } a _ { m } t _ { m } k ( x _ { n } , x _ { m } ) + b \right ) = 1 . \\ \text {matically stable solution is obtained by averaging to give}
$$

Again, a numerically stable solution is obtained by averaging to give

$$
a \text { numerically stable solution is obtained by averaging along to give} \\ b = \frac { 1 } { N _ { \mathcal { M } } } \sum _ { n \in \mathcal { M } } \left ( t _ { n } - \sum _ { m \in \mathcal { S } } a _ { m } t _ { m } k ( x _ { n } , x _ { m } ) \right ) \\ M \text { denotes the set of indices of data points having } 0 < a \ < C
$$

where M denotes the set of indices of data points having 0 < a n < C . An alternative, equivalent formulation of the support vector machine,

known as the ν -SVM , has been proposed by Sch¨ olkopf et al. (2000). This involves maximizing

$$
\widetilde { L } ( a ) = - \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \sum _ { m = 1 } ^ { N } a _ { n } a _ { m } t _ { n } t _ { m } k ( x _ { n } , x _ { m } ) \\ \intertext { o t h e c r a n t i n s }
$$

subject to the constraints

$$
0 \leqslant a _ { n } \leqslant 1 / N
$$

$$
\sum _ { n = 1 } ^ { N } a _ { n } t _ { n } & = 0 & ( 7 . 4 0 ) \\
$$

$$
\sum _ { n = 1 } ^ { N } a _ { n } \geqslant \nu . \\
$$

This approach has the advantage that the parameter ν , which replaces C , can be interpreted as both an upper bound on the fraction of margin errors (points for which ξ n > 0 and hence which lie on the wrong side of the margin boundary and which may or may not be misclassiﬁed) and a lower bound on the fraction of support vectors. An example of the ν -SVM applied to a synthetic data set is shown in Figure 7.4. Here Gaussian kernels of the form exp( − γ x − x 2 ) have been used, with γ = 0 . 45 . Although predictions for new inputs are made using only the support vectors,

Although predictions for new inputs are made using only the support vectors, the training phase (i.e., the determination of the parameters a and b ) makes use of the whole data set, and so it is important to have efficient algorithms for solving the quadratic programming problem. We first note that the objective function ˜ L ( a ) given by (7.10) or (7.32) is quadratic and so any local optimum will also be a global optimum provided the constraints define a convex region (which they do as a consequence of being linear). Direct solution of the quadratic programming problem using traditional techniques is often infeasible due to the demanding computation and memory requirements, and so more practical approaches need to be found. The technique of chunking (Vapnik, 1982) exploits the fact that the value of the Lagrangian is unchanged if we remove the rows and columns of the kernel matrix corresponding to Lagrange multipliers that have value zero. This allows the full quadratic programming problem to be broken down into a series of smaller ones, whose goal is eventually to identify all of the nonzero Lagrange multipliers and discard the others. Chunking can be implemented using protected conjugate gradients (Burges, 1998). Although chunking reduces the size of the matrix in the quadratic function from the number of data points squared to approximately the number of nonzero Lagrange multipliers squared, even this may be too big to fit in memory for large-scale applications. Decomposition methods (Osuna et al. , 1996) also solve a series of smaller quadratic programming problems but are designed so that each of these is of a fixed size, and so the technique can be applied to arbitrarily large data sets. However, it still involves numerical solution of quadratic programming subproblems and these can be problematic and expensive. One of the most popular approaches to training support vector machines is called sequential minimal optimization , or SMO (Platt, 1999). It takes the concept of chunking to the extreme limit and considers just two Lagrange multipliers at a time. In this case, the subproblem can be solved analytically, thereby avoiding numerical quadratic programming altogether. Heuristics are given for choosing the pair of Lagrange multipliers to be considered at each step. In practice, SMO is found to have a scaling with the number of data points that is somewhere between linear and quadratic depending on the particular application.
