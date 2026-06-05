[Page 512]

The joint distribution corresponding to a directed graph can be written using the decomposition

$$
p ( x ) = \prod _ { i } p ( x _ { i } | \bar { p } _ { i } ) & & ( 1 0 . 1 2 ) \\ \text {variable} ( s ) \, \text {associated with node } i , \, a n d \, \bar { p } _ { i } \, \text { denotes the parent}
$$

where x i denotes the variable(s) associated with node i , and pa i denotes the parent set corresponding to node i . Note that x i may be a latent variable or it may belong to the set of observed variables. Now consider a variational approximation in which the distribution q ( x ) is assumed to factorize with respect to the x i so that

$$
q ( x ) = \prod _ { i } q _ { i } ( x _ { i } ) . \quad ( 1 0 . 1 2 3 ) \\ \intertext { s o n d o s , t h o r i s n o f o t e r $ q ( x ) $ i n t h o w $ v e r i o n $ d i s t r i o n $ }
$$

Note that for observed nodes, there is no factor q ( x i ) in the variational distribution. We now substitute (10.122) into our general result (10.9) to give

$$
\ w \text { substitute } ( 1 . 1 2 2 ) \text { into our general result } ( 1 0 . 9 ) \text { to give } \\ \ln q _ { j } ^ { * } ( x _ { j } ) = \mathbb { E } _ { i \neq j } \left [ \sum _ { i } \ln p ( x _ { i } | \text {pa} _ { i } ) \right ] + \text {const.} \quad ( 1 0 . 1 2 4 ) \\ \text {terms on the right-hand side that do not depend on } x _ { i } \text { can be obtained into }
$$

/negationslash

Any terms on the right-hand side that do not depend on x j can be absorbed into the additive constant. In fact, the only terms that do depend on x j are the conditional distribution for x j given by p ( x j | pa j ) together with any other conditional distributions that have x j in the conditioning set. By deﬁnition, these conditional distributions correspond to the children of node j , and they therefore also depend on the co-parents of the child nodes, i.e., the other parents of the child nodes besides node x j itself. We see that the set of all nodes on which q ( x j ) depends corresponds to the Markov blanket of node x j , as illustrated in Figure 8.26. Thus the update of the factors in the variational posterior distribution represents a local calculation on the graph. This makes possible the construction of general purpose software for variational inference in which the form of the model does not need to be speciﬁed in advance (Bishop et al. , 2003).

If we now specialize to the case of a model in which all of the conditional distributions have a conjugate-exponential structure, then the variational update procedure can be cast in terms of a local message passing algorithm (Winn and Bishop, 2005). In particular, the distribution associated with a particular node can be updated once that node has received messages from all of its parents and all of its children. This in turn requires that the children have already received messages from their coparents. The evaluation of the lower bound can also be simpliﬁed because many of the required quantities are already evaluated as part of the message passing scheme. This distributed message passing formulation has good scaling properties and is well suited to large networks.
