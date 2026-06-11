[Page 372]

Figure 7.11 Plots of the log marginal likelihood λ(αi) versus ln αi showing on the left, the single maximum at a ﬁnite αi for qi2 = 4 and si = 1 (so that qi2 > si) and on the right, the maximum at αi = ∞ for qi2 = 1 and si = 2 (so that qi2 < si).

2

0

−2

−4

−5 0 5

2

0

−2

−4

−5 0 5

is more likely to be pruned from the model. The ‘sparsity’ measures the extent to which basis function ϕi overlaps with the other basis vectors in the model, and the ‘quality’ represents a measure of the alignment of the basis vector ϕn with the error between the training set values t = (t1,...,tN)T and the vector y−i of predictions that would result from the model with the vector ϕi excluded (Tipping and Faul, 2003).

The stationary points of the marginal likelihood with respect to αi occur when the derivative

αi−1s2i − (qi2 − si) 2(αi + si)2

dλ(αi) dαi

=

(7.100)

is equal to zero. There are two possible forms for the solution. Recalling that αi � 0, we see that if qi2 < si, then αi → ∞ provides a solution. Conversely, if qi2 > si, we can solve for αi to obtain

s2i qi2 − si

αi =

. (7.101)

These two solutions are illustrated in Figure 7.11. We see that the relative size of the quality and sparsity terms determines whether a particular basis vector will be pruned from the model or not. A more complete analysis (Faul and Tipping, 2002), based on the second derivatives of the marginal likelihood, conﬁrms these solutions

Exercise 7.16 are indeed the unique maxima of λ(αi).

Note that this approach has yielded a closed-form solution for αi, for given values of the other hyperparameters. As well as providing insight into the origin of sparsity in the RVM, this analysis also leads to a practical algorithm for optimizing the hyperparameters that has signiﬁcant speed advantages. This uses a ﬁxed set of candidate basis vectors, and then cycles through them in turn to decide whether each vector should be included in the model or not. The resulting sequential sparse Bayesian learning algorithm is described below.

Sequential Sparse Bayesian Learning Algorithm

1. If solving a regression problem, initialize β.

2. Initialize using one basis function ϕ1, with hyperparameter α1 set using (7.101), with the remaining hyperparameters αj for j �= i initialized to inﬁnity, so that only ϕ1 is included in the model.
