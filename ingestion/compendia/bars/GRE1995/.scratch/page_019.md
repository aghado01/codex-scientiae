[Page 19]

approximately,  where ie S;(g). This approximation could have been used explicitly in an approximate Gibbs sampler; but we choose to use it as a proposal distribution for a Hastings step.

Turning now to the step updating the partition g to g, say, we note that with the prior p(g) specified above all partitions have positive probability, and process that jumps between partitions making only the modest changes of splitting a group; a birth', and combining two groups; a 'death, will be irreducible. It would have been quite natural to have included a move that changed the partition by reallocation of items while fixing the number of groups, but that was not implemented here. We have found the following mechanisms for the partition moves effective in practice; applied to partitions of up to a few dozen objects.

first choose a group to uniformly among those with at least two items. This group is then split at random 'binomially, ie. each item is assigned to one of the two daughter subgroups independently, with probability one-half for each, but conditional on neither subgroup being empty: For a death; attempted with probability dg, we simply choose two groups at random to be combined into one. split;

Jumping to a new partition necessitates a change also to the vector a, since its length has to increase or decrease by 1. Our proposal for the additional component is Gaussian on a logit scale; and takes account of the numbers of binary responses influenced by each of the relevant %j. Specifically, suppose that a proposed birth Sj into subgroups Sj1 and $j2 Let aj be the current value, and aj1, %j2 the new values for the two subgroups. Then we set splits

$$
\alpha _ { j 1 } = \frac { \alpha _ { j } e ^ { \sigma z / W _ { 1 } } } { 1 - \alpha _ { j } + \alpha _ { j } e ^ { \sigma z / W _ { 1 } } } , \quad \alpha _ { j 2 } = \frac { \alpha _ { j } e ^ { - \sigma z / W _ { 2 } } } { 1 - \alpha _ { j } + \alpha _ { j } e ^ { - \sigma z / W _ { 2 } } } ,
$$

where $W_r = \sum_{i \in S_{jr}} w_i$ ($r = 1,2$), $z$ is an independent standard Gaussian random variable, and $\sigma$ is a spread parameter to be chosen later. For the corresponding death move;

This   completes the specification of the jump proposal; its acceptance probability is necessarily somewhat complicated in form, but is calculated as usual from (8). For the birth and death, the probabilities are respectively min(1, R) and min(1, R-1) , where

The birth and death acceptance probabilities are respectively $\min(1, R)$ and $\min(1, R^{-1})$, where

$$
R = \frac{B\{q\alpha_j,\, q(1-\alpha_j)\}^{\#S_j}}
         {B\{q\alpha_{j1},\, q(1-\alpha_{j1})\}^{\#S_{j1}}\, B\{q\alpha_{j2},\, q(1-\alpha_{j2})\}^{\#S_{j2}}}
\times \prod_{i \in S_{j1}}\!\left(\frac{\theta_i}{1-\theta_i}\right)^{q(\alpha_{j1}-\alpha_j)}
  \prod_{i \in S_{j2}}\!\left(\frac{\theta_i}{1-\theta_i}\right)^{q(\alpha_{j2}-\alpha_j)}
\times \frac{p(g')}{p(g)}
\times \frac{d_{g'}}{b_g}\,\#\{j : |S_j(g)| \geqslant 2\}\,\frac{2}{d(g)\{d(g)+1\}}\!\left(2^{\#S_j - 1} - 1\right)
\times \frac{\alpha_{j1}(1-\alpha_{j1})\,\alpha_{j2}(1-\alpha_{j2})}{\alpha_j(1-\alpha_j)}\,
       \sigma(W_1^{-1} + W_2^{-1})\,(2\pi)^{-1/2}\exp\!\left(-\tfrac{1}{2}z^2\right)
$$

### 6.3. Application to Pine Seedling Mortality Data

We apply the methodology described above to a small data set, one of those analysed by Consonni & Veronese (1955). This concerns 4 binomial responses $y = (59, 89, 88, 95)$, each based on $w_i = 100$ trials. The data arise from a 2 x 2 factorial experiment; comparing two treatments (H, planting too high; D, planting too deep) on two varieties of pine seedling (L, longleaf; S, slash) The responses are indexed in the order (LH, LD, SH, SD). Consonni & Veronese   compare various statistical methods a Bayesian method based on their model described above, which has an 'adaptive multiple shrinkage'   property; see   also George (1986) The data determine a partition of the group S; borrow strength by shrinking towards a common value %j- Alternative estimators considered include the maximum likelihood estimators for both a saturated model and for an additive logistic regression; a parametric empirical Bayes estimator which shrinks all   0; together, and a nonparametric empirical Bayes estimator, which has   the multiple shrinkage property. again Our analysis has been confined to repeating that of Consonni & Veronese, but obtained reversible jump Markov chain Monte Carlo instead of their analytic approximations. We extend their results very slightly by allowing 9 to be random; as well as fixed at each of the values they use (100, 200 and 300). This adaptation made use of a p(q) under which 9 is uniform on the interval [log 100, 300]; the proposal for updating q described in the previous section was interpreted as wrapped periodically onto this interval. There were no other unspecified hyperparameters in the model defined above. using prior log log We refer the reader to Consonni & Veronese for further background, including discussion of some of the philosophical issues that arise in the modelling:
