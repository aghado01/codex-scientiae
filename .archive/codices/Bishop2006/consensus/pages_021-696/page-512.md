[Page 512]

described by the directed graph shown in Figure 10.5. Here we consider more generally the use of variational methods for models described by directed graphs and derive a number of widely applicable results.

The joint distribution corresponding to a directed graph can be written using the decomposition

$$
p(\mathbf{x}) = \prod_i p(\mathbf{x}_i|\text{pa}_i) \tag{10.122}
$$

where $\mathbf{x}_i$ denotes the variable(s) associated with node $i$, and $\text{pa}_i$ denotes the parent set corresponding to node $i$. Note that $\mathbf{x}_i$ may be a latent variable or it may belong to the set of observed variables. Now consider a variational approximation in which the distribution $q(\mathbf{x})$ is assumed to factorize with respect to the $\mathbf{x}_i$ so that

$$
q(\mathbf{x}) = \prod_i q_i(\mathbf{x}_i). \tag{10.123}
$$

Note that for observed nodes, there is no factor $q_i(\mathbf{x}_i)$ in the variational distribution. We now substitute (10.122) into our general result (10.9) to give

$$
\ln q_j^\star(\mathbf{x}_j) = \mathbb{E}_{i \neq j} \left[ \sum_i \ln p(\mathbf{x}_i|\text{pa}_i) \right] + \text{const}. \tag{10.124}
$$

Any terms on the right-hand side that do not depend on $\mathbf{x}_j$ can be absorbed into the additive constant. In fact, the only terms that do depend on $\mathbf{x}_j$ are the conditional distribution for $\mathbf{x}_j$ given by $p(\mathbf{x}_j|\text{pa}_j)$ together with any other conditional distributions that have $\mathbf{x}_j$ in the conditioning set. By deﬁnition, these conditional distributions correspond to the children of node $j$, and they therefore also depend on the co-parents of the child nodes, i.e., the other parents of the child nodes besides node $\mathbf{x}_j$ itself. We see that the set of all nodes on which $q^\star(\mathbf{x}_j)$ depends corresponds to the Markov blanket of node $\mathbf{x}_j$, as illustrated in Figure 8.26. Thus the update of the factors in the variational posterior distribution represents a local calculation on the graph. This makes possible the construction of general purpose software for variational inference in which the form of the model does not need to be speciﬁed in advance (Bishop et al., 2003).

If we now specialize to the case of a model in which all of the conditional distributions have a conjugate-exponential structure, then the variational update procedure can be cast in terms of a local message passing algorithm (Winn and Bishop, 2005). In particular, the distribution associated with a particular node can be updated once that node has received messages from all of its parents and all of its children. This in turn requires that the children have already received messages from their coparents. The evaluation of the lower bound can also be simpliﬁed because many of the required quantities are already evaluated as part of the message passing scheme. This distributed message passing formulation has good scaling properties and is well suited to large networks.
