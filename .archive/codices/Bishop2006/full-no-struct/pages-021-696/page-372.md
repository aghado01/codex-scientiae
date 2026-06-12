[Page 372]

Figure 7.11 Plots of the log marginal likelihood λ ( α i ) versus ln α i showing on the left, the single maximum at a ﬁnite α i for q 2 i = 4 and s i = 1 (so that q 2 i > s i ) and on the right, the maximum at α i = ∞ for q 2 i = 1 and s i = 2 (so that q 2 i < s i ).

![The image consists of two graphs, each with a blue line and a blue dashed line. The graph on the left side is titled (-5, -5), and the graph on the right side is titled (-5, -5). Both graphs have a blue dashed line that is not drawn. The graph on the left side has a positive slope, while the graph on the right side has a negative slope. The slope of the graph on the left side is positive, while the slope of the graph on the right side is negative. The graph on the left side has a horizontal axis labeled (-5, -5), while the graph on the right side has a vertical axis labeled (-5, -5). The horizontal axis is labeled (-5, -5), while the vertical axis is labeled (-5, -5). The graph on the left side has a positive slope, while the graph on the right side has a negative slope.](../images/imageFile157.png)

2

2

0

0

−2

−2

−4

−4

−5

0

5

−5

0

5

Exercise 7.16

The stationary points of the marginal likelihood with respect to α i occur when the derivative d ( ) − 1 2 ( 2 )

$$
\frac { d \lambda ( \alpha _ { i } ) } { d \alpha _ { i } } = \frac { \alpha _ { i } ^ { - 1 } s _ { i } ^ { 2 } - ( q _ { i } ^ { 2 } - s _ { i } ) } { 2 ( \alpha _ { i } + s _ { i } ) ^ { 2 } }
$$

is equal to zero. There are two possible forms for the solution. Recalling that α i 0 , we see that if q 2 i < s i , then α i → ∞ provides a solution. Conversely, if q 2 i > s i , we can solve for α i to obtain s 2

$$
\alpha _ { i } = \frac { s _ { i } ^ { 2 } } { q _ { i } ^ { 2 } - s _ { i } } . \\ \text {Illustrated in Figure 7.11. We see that the relative size of}
$$

These two solutions are illustrated in Figure 7.11. We see that the relative size of the quality and sparsity terms determines whether a particular basis vector will be pruned from the model or not. A more complete analysis (Faul and Tipping, 2002), based on the second derivatives of the marginal likelihood, conﬁrms these solutions are indeed the unique maxima of λ ( α i ) .

Note that this approach has yielded a closed-form solution for α i , for given values of the other hyperparameters. As well as providing insight into the origin of sparsity in the RVM, this analysis also leads to a practical algorithm for optimizing the hyperparameters that has signiﬁcant speed advantages. This uses a ﬁxed set of candidate basis vectors, and then cycles through them in turn to decide whether each vector should be included in the model or not. The resulting sequential sparse Bayesian learning algorithm is described below.

# Sequential Sparse Bayesian Learning Algorithm

- 1. If solving a regression problem, initialize β .
- 2. Initialize using one basis function ϕ 1 , with hyperparameter α 1 set using (7.101), with the remaining hyperparameters α j for j = i initialized to inﬁnity, so that only ϕ 1 is included in the model.

/negationslash
