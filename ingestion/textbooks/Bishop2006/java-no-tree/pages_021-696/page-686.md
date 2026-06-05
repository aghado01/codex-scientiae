[Page 686]

of performance. If we deﬁne pτk to be the proportion of data points in region Rτ assigned to class k, where k = 1,...,K, then two commonly used choices are the cross-entropy

K

Qτ(T) =

pτk lnpτk (14.32)

k=1

and the Gini index

K

Qτ(T) =

pτk (1 − pτk). (14.33)

k=1

These both vanish for pτk = 0 and pτk = 1 and have a maximum at pτk = 0.5. They encourage the formation of regions in which a high proportion of the data points are assigned to one class. The cross entropy and the Gini index are better measures than the misclassiﬁcation rate for growing the tree because they are more sensitive to the

- Exercise 14.11 node probabilities. Also, unlike misclassiﬁcation rate, they are differentiable and hence better suited to gradient based optimization methods. For subsequent pruning of the tree, the misclassiﬁcation rate is generally used.


The human interpretability of a tree model such as CART is often seen as its major strength. However, in practice it is found that the particular tree structure that is learned is very sensitive to the details of the data set, so that a small change to the training data can result in a very different set of splits (Hastie et al., 2001).

There are other problems with tree-based methods of the kind considered in this section. One is that the splits are aligned with the axes of the feature space, which may be very suboptimal. For instance, to separate two classes whose optimal decision boundary runs at 45 degrees to the axes would need a large number of axis-parallel splits of the input space as compared to a single non-axis-aligned split. Furthermore, the splits in a decision tree are hard, so that each region of input space is associated with one, and only one, leaf node model. The last issue is particularly problematic in regression where we are typically aiming to model smooth functions, and yet the tree model produces piecewise-constant predictions with discontinuities at the split boundaries.

###### 14.5. Conditional Mixture Models

We have seen that standard decision trees are restricted by hard, axis-aligned splits of the input space. These constraints can be relaxed, at the expense of interpretability, by allowing soft, probabilistic splits that can be functions of all of the input variables, not just one of them at a time. If we also give the leaf models a probabilistic interpretation, we arrive at a fully probabilistic tree-based model called the hierarchical mixture of experts, which we consider in Section 14.5.3.

An alternative way to motivate the hierarchical mixture of experts model is to start with a standard probabilistic mixtures of unconditional density models such as

Chapter 9 Gaussians and replace the component densities with conditional distributions. Here we consider mixtures of linear regression models (Section 14.5.1) and mixtures of
