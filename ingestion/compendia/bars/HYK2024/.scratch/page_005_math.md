[Page 5]

In this section we use RJMCMC to obtain samples of k,ξ from the posterior distribution (6) or (8). Due to the tensor product structure, the sampling procedure can be performed in the component individually. Suppose x i is the current update component. When modifying x i, other components are invariant. We design three transition strategies to traverse the state space: (1) Birth: add a knot with the probability b k i = c min(1, { ( n i − k i ) / ( k i + 1) } 1 − γ ) ; (2) Death: delete a knot with the probability d k i = c min(1, { k i / ( n i − k i + 1) } 1 − γ ) ; (3) Relocation: change the position of one knot with the probability r k i = 1 − b k i − d k i.The hyper-parameter c is of the interval (0, 0.5).Notably, π ( k i ) b k i = π ( k i + 1) d k i +1, satisfying the detailed balance equation for the prior of the knot number. Suppose the jumping probability is q ( k ′ i,ξ ′ i | k i,ξ i ).Let ξ i,k i ⊂ η i be the locations of k i knots in the i -th component. The concrete proposal distributions are specified in the following manner:

Assume that ( k,ξ ) is the current status and ( k ′,ξ ′ ) is the candidate status. To sample from the target posterior distribution, the Metropolis-Hastings algorithm implies that,

$$
p ( k, \xi | y ) q ( k ^ { \prime }, \xi ^ { \prime } | k, \xi ) \alpha ( k ^ { \prime }, \xi ^ { \prime } | k, \xi ) = p ( k ^ { \prime }, \xi ^ { \prime } | y ) q ( k, \xi | k ^ { \prime }, \xi ^ { \prime } ) \alpha ( k, \xi | k ^ { \prime }, \xi ^ { \prime } ),
$$

where α ( k ′,ξ ′ | k,ξ ),α ( k,ξ | k ′,ξ ′ ) are the acceptance probabilities.

Lemma 3. With the specified proposal distribution and the posterior density of (9), the acceptance probability and its EBIC approximation in RJMCMC are

$$
\alpha ( k ^ { \prime }, \xi ^ { \prime } | k, \xi ) & = \min \{ 1, \ ( m + 1 ) ^ { ( \nu - \nu ^ { \prime } ) / 2 } ( a _ { k, \xi } / a _ { k ^ { \prime }, \xi ^ { \prime } } ) ^ { m / 2 } \}, \\ \hat { \alpha } ( k ^ { \prime }, \xi ^ { \prime } | k, \xi ) & = \min \{ 1, \ m ^ { ( \nu - \nu ^ { \prime } ) / 2 } ( \hat { \sigma } ^ { 2 } / ( \hat { \sigma } ^ { \prime } ) ^ { 2 } ) ^ { m / 2 } \},
$$

where ν,ν ′ are the dimensions of the spline space.

Lemma 3 implies that √ m + 1, √ m are the dimensional penalty factors for the likelihood. Comparing α ( k ′,ξ ′ | k,ξ ) and ˆ α ( k ′,ξ ′ | k,ξ ) in (10), α ≈ ˆ α when the sample size is sufficiently large. The overall extended Bayesian adaptive regression spline approach is listed as Algorithm 1.

Input: Labeled observations { ( x i,y i ) } m i =1, hyper-parameters 0 ≤ γ ≤ 1 and 0 < c < 0.5, jumping steps I, the number of candidate knots n.(0) (0)

Output: The posterior samples { k ( i ),ξ ( i ) } I i =1 .

We conduct EBARS in the knot inference and manifold denoising. For the knot inference, the performance is compared with the segmented method of Muggeo [2003] and the modified maximum likelihood (MML) method of Guangyu Yang and Zhang [2023]. For the manifold denoising, the performance is compared with manifold fitting under unbounded noise (MFUN) of Yao and Xia [2023], putative manifold fitting (PMF) of Fefferman et al. [2018], principal manifold estimation (PME) of Meng and Eloyan [2021] and principal curves (PC) of Hastie and Stuetzle [1989]. Numerical experiments show that the proposed method performs well in finite samples of all scenarios.
