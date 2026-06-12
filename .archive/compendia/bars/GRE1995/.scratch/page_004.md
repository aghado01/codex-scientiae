[Page 4]

onto subsets of a single parameter space. Each of these approaches has its merits and its disadvantages. In jump-diffusion; there is a conflict between minimising the distortion caused by using a positive time increment; and improving Monte Carlo efficiency . Further, although the jump-diffusion principle is really rather general, the range of jump transitions discussed by Grenander & Miller; and used by Phillips & Smith, is somewhat limited, amounting to conditional versions of Gibbs kernels; and Hastings kernels based on proposals   generated from While these moves   seem adequate for Grenander & Miller's applications; they are perhaps too restricted for general Bayesian computation: The product space approach of Carlin & Chib requires that irrelevant parameters; the 0() for k different from the current k, need to be continually updated, which apparently limits the approach to a small set of models % . In recent unpublished work, A. OHagan and the author have pointed out that there is no need to update the irrelevant parameters to ensure the proper limiting distribution of the chain; but performance of the modified method is not very encouraging The embedding method seems cumbersome and inexplicit in use.

## 3. Markov Chain Monte Carlo Using Reversible Jumps

### 3.1. Introduction

a target distribution of interest. In Bayesian inference, this is the posterior distribution for the parameters given the data, and in the present context of model determination; 'parameters' include the indicator k for the model itself, as well as tation; we construct a Markov transition kernel P(x,dx' ) that is aperiodic and irreducible; and satisfies detailed balance:

$$
= \int _ { B } \int _ { A } \pi ( d x ^ { \prime } ) P ( x ^ { \prime } , d x ) ,
$$

for all appropriate A, B, and then simulate this chain to obtain a dependent; approximate; the correct limiting distribution, in practical design of samplers it is a convenient restriction to impose.

In straightforward cases; r(dx) is either a discrete probability distribution; or has a joint density with respect to some simple measure, usually Lebesgue; then methods for constructing suitable transition kernels are familiar: The two most popular methods are the Gibbs (Geman & Geman;   1984) and the Metropolis-Hastings method (Metropolis et al, 1953; Hastings, 1970). A full description and some comparisons are given by Tierney (1994), Besag et al. (1995), elsewhere. Briefly, each method proceeds by sweeping around all the variables x = (X1 X2, xn) visiting subsets of the indices in turn; either randomly or systematically. When a subset T of {1,2, n} is visited, the variables Xr:= {xi:ie T} are updated. In the Gibbs sampler, the new values are drawn method, proposed new values xr for these variables are drawn from an essentially arbitrary distribution qr(xr; x) Then; with probability sampler and

$$
\min \left \{ 1 , \frac { \pi ( x _ { T } | x _ { - T } ) q _ { T } ( x _ { T } , x ) } { \pi ( x _ { T } | x _ { - T } ) q _ { T } ( x _ { T } ^ { \prime } ; x ) } \right \}
$$

the proposed values are accepted; otherwise; the existing values are retained.
