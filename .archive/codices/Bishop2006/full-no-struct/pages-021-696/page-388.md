[Page 388]

Figure 8.10 This chain of M discrete nodes, each having K states, requires the speciﬁcation of K − 1 + ( M − 1) K ( K − 1) parameters, which grows linearly with the length M of the chain. In contrast, a fully connected graph of M nodes would have K M − 1 parameters, which grows exponentially with M .

![image 169](../images/imageFile169.png)

M

1

2

x

x

x

More generally, if we have M discrete variables x 1 ,..., x M , we can model the joint distribution using a directed graph with one variable corresponding to each node. The conditional distribution at each node is given by a set of nonnegative parameters subject to the usual normalization constraint. If the graph is fully connected then we have a completely general distribution having K M − 1 parameters, whereas if there are no links in the graph the joint distribution factorizes into the product of the marginals, and the total number of parameters is M ( K − 1) . Graphs having intermediate levels of connectivity allow for more general distributions than the fully factorized one while requiring fewer parameters than the general joint distribution. As an illustration, consider the chain of nodes shown in Figure 8.10. The marginal distribution p ( x 1 ) requires K − 1 parameters, whereas each of the M − 1 conditional distributions p ( x i | x i − 1 ) , for i = 2 ,...,M , requires K ( K − 1) parameters. This gives a total parameter count of K − 1+( M − 1) K ( K − 1) , which is quadratic in K and which grows linearly (rather than exponentially) with the length M of the chain.

An alternative way to reduce the number of independent parameters in a model is by sharing parameters (also known as tying of parameters). For instance, in the chain example of Figure 8.10, we can arrange that all of the conditional distributions p ( x i | x i − 1 ) , for i = 2 ,...,M , are governed by the same set of K ( K − 1) parameters. Together with the K − 1 parameters governing the distribution of x 1 , this gives a total of K 2 − 1 parameters that must be speciﬁed in order to deﬁne the joint distribution. We can turn a graph over discrete variables into a Bayesian model by introduc-

ing Dirichlet priors for the parameters. From a graphical point of view, each node then acquires an additional parent representing the Dirichlet distribution over the parameters associated with the corresponding discrete node. This is illustrated for the chain model in Figure 8.11. The corresponding model in which we tie the parameters governing the conditional distributions p ( x i | x i − 1 ) , for i = 2 ,...,M , is shown in Figure 8.12.

Another way of controlling the exponential growth in the number of parameters in models of discrete variables is to use parameterized models for the conditional distributions instead of complete tables of conditional probability values. To illustrate this idea, consider the graph in Figure 8.13 in which all of the nodes represent binary variables. Each of the parent variables x i is governed by a single parame-
