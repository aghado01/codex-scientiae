[Page 685]

olds) to minimize the sum-of-squares error is usually computationally infeasible due to the combinatorially large number of possible solutions. Instead, a greedy optimization is generally done by starting with a single root node, corresponding to the whole input space, and then growing the tree by adding nodes one at a time. At each step there will be some number of candidate regions in input space that can be split, corresponding to the addition of a pair of leaf nodes to the existing tree. For each of these, there is a choice of which of the D input variables to split, as well as the value of the threshold. The joint optimization of the choice of region to split, and the choice of input variable and threshold, can be done efﬁciently by exhaustive search noting that, for a given choice of split variable and threshold, the optimal choice of predictive variable is given by the local average of the data, as noted earlier. This is repeated for all possible choices of variable to be split, and the one that gives the smallest residual sum-of-squares error is retained.

Given a greedy strategy for growing the tree, there remains the issue of when to stop adding nodes. A simple approach would be to stop when the reduction in residual error falls below some threshold. However, it is found empirically that often none of the available splits produces a signiﬁcant reduction in error, and yet after several more splits a substantial error reduction is found. For this reason, it is common practice to grow a large tree, using a stopping criterion based on the number of data points associated with the leaf nodes, and then prune back the resulting tree. The pruning is based on a criterion that balances residual error against a measure of model complexity. If we denote the starting tree for pruning by T0, then we deﬁne T ⊂ T0 to be a subtree of T0 if it can be obtained by pruning nodes from T0 (in other words, by collapsing internal nodes by combining the corresponding regions). Suppose the leaf nodes are indexed by τ = 1,...,|T|, with leaf node τ representing a region Rτ of input space having Nτ data points, and |T| denoting the total number of leaf nodes. The optimal prediction for region Rτ is then given by

1 Nτ

yτ =

tn (14.29)

xn∈Rτ

and the corresponding contribution to the residual sum-of-squares is then

Qτ(T) =

xn∈Rτ

The pruning criterion is then given by

{tn − yτ}2 . (14.30)

C(T) =

|T|

Qτ(T) + λ|T| (14.31)

τ=1

The regularization parameter λ determines the trade-off between the overall residual sum-of-squares error and the complexity of the model as measured by the number |T| of leaf nodes, and its value is chosen by cross-validation.

For classiﬁcation problems, the process of growing and pruning the tree is similar, except that the sum-of-squares error is replaced by a more appropriate measure
