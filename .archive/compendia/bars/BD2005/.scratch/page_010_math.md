[Page 10]

Repeat steps 1-4 for a large number of iterations, collecting samples after a burn-in to allow convergence.

A challenging aspect of the algorithm is comparing models in the RJMCMC sampler. Our prior assigns equal probability to all piecewise linear models and model proposal is based on generation of discrete random variables. Under this scenario, the probability, Q, of accepting a proposed model, M ∗, is the Bayes factor comparing it to the current model, M (Holmes and Mallick, 2003, Denison et al., 2002). The Bayes factor is the ratio of the marginal likelihoods of the data under the two models:

$$
Q = \min \left [ 1, \frac { p ( y | M ^ { * } ) } { p ( y | M ) } \right ] .
$$

The marginal likelihoods and thus the Bayes factor for this hierarchical model have no closed form. Consider instead the following marginal likelihood under model M .

$$
p ( y | M, \delta, \lambda ) = \int \int \int L ( y | \mathbf b, \tau, \lambda, M ) p ( \mathbf b, \tau, \beta | \delta, \lambda, M ) \, d \mathbf b \, d \beta \, d \tau,
$$

where p ( y | β, b, τ, δ, λ,M ) is the data likelihood under model M, and p ( b, τ, β | δ, λ,M ) is the joint prior of b, β, and τ under model M.This integral has a closed form, so that the likelihood can be written:

where

$$
p ( y | M, \delta, \lambda ) = C ( \lambda, k ) | R | ^ { - \frac { 1 } { 2 } } ( b _ { \tau } + \frac { \alpha } { 2 } ) ^ { - ( \frac { n } { 2 } + a _ { \tau } ) } \prod _ { l = 1 } ^ { k } \delta _ { l } ^ { \frac { m } { 2 } } \prod _ { i = 1 } ^ { m } | U _ { i } | ^ { \frac { 1 } { 2 } }
$$

$$
U _ { i } & = [ \Delta + \theta _ { i } ^ { \prime } \theta _ { i } ] ^ { - 1 } \\ R & = \lambda I _ { k } + m \Delta - \Delta ( \sum _ { i = 1 } ^ { m } U _ { i } ) \Delta \\ \alpha & = y ^ { \prime } y - \sum _ { i = 1 } ^ { m } y _ { i } ^ { \prime } \theta _ { i } U _ { i } \theta _ { i } ^ { \prime } y _ { i } - ( \sum _ { i = 1 } ^ { m } U _ { i } \theta _ { i } ^ { \prime } y _ { i } ) ^ { \prime } \Delta R ^ { - 1 } \Delta ( \sum _ { i = 1 } ^ { m } U _ { i } \theta _ { i } ^ { \prime } y _ { i } ) \\ &
$$
