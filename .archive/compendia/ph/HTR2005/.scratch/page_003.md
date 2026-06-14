[Page 3]

Advantages of Bayesian regression. A full Bayesian approach (when computationally feasible) has various advantages over others: A generic advantage is that it is more principled and hence involves fewer heuristic design choices. This is particularly important for estimating the number of segments. Another generic advantage is that it can be easily embedded in a larger framework. For instance, one can decide among competing models solely based on the (Bayesian) evidence. Finally, Bayes often works well in practice, and provably so if the model assumptions are valid.^1 We can also extract other information (nearly for free), like probability estimates and variances for the various quantities of interest. Particularly interesting is the expected level (and variance) of each data point. This leads to a regression curve, which is very flat, i.e. smoothes the data, in long and clear segments, wiggles in less clear segments, follows trends, and jumps at the segment boundaries. It thus behaves somewhat between local smoothing (which wiggles more and blurs jumps) and rigid PC-segmentation.

## 2 The General Model

Setup. We are given a sequence \( y = (y_1, \dots, y_n) \), e.g. times-series data or measurements of some function at locations \( 1 \dots n \), where each \( y_i \in \mathbb{R} \) resulted from a noisy "measurement", i.e. we assume that the \( y_i \) are independently (e.g. Gaussian) distributed with means \( \mu^\prime_i \) and variances \( \sigma^{\prime 2}_i \).^2 The data likelihood is therefore^3

$$
\text{likelihood} \colon \quad P ( y | \mu ^ { \prime } , \sigma ^ { \prime } ) \, \colon = \, \prod _ { i = 1 } ^ { n } P ( y _ { i } | \mu ^ { \prime } _ { i } , \sigma ^ { \prime } _ { i } )
$$

^1 Note that we are not claiming here that BPCR works better than the other mentioned approaches. In a certain sense Bayes is optimal if the prior is ‘true’. Practical superiority likely depends on the type of application. A comparison for micro-array data is in progress [KH06]. The major aim of this paper is to derive an efficient algorithm, and demonstrate the gains of BPCR beyond bare PC-regression, e.g. the (predictive) regression curve (which is better than local smoothing which wiggles more and blurs jumps).

^2 More generally, \( \mu^\prime_i \) and \( \sigma^\prime_i \) are location and scale parameters of a symmetric distribution.

^3 For notational and verbal simplicity we will not distinguish between probabilities of discrete variables and densities of continuous variables.
