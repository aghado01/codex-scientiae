[Page 12]

## 5.2. Function: MCMC

In the following, a model \( M^* \) contains information for an individual MCMC iteration. In particular, it contains

- \( k^* \), the number of interior knots
- \( \xi^* \), the set of interior knots
- \( X_{D,*} \), the design basis, and \( X_{G,*} \), the grid basis. The design basis is based on the input bin midpoints. The grid basis is based upon a grid of evenly spaced points, the number of which is user defined.
- statistical model fitting information, including parameter estimates, error estimates, and failure to fit.
- \( \beta^* \sim \pi(\beta | k^*, \xi^*, \text{Data}) \)
- \( \mu_{D,*} = \exp(X_D \beta^*) \)
- \( \mu_{G,*} = \exp(X_G \beta^*) \)
- The BIC and log likelihood for the full model with parameters \( (k^*, \xi^*, \beta^*) \).


- Declare models \( M_{\text{curr}} \), \( M_{\text{cand}} \), and \( M_{\text{temp}} \).
- Set initial knots in \( M_{\text{curr}} \). The initial knots may be user defined, equally spaced, or obtained via logspline.
- Calculate birth and death probabilities for each possible value of \( k \), using the user-defined prior, as follows:


$$
\text {if } ( k > = \max \text {KNOTS} )
$$

birth probability = 0

else

birth probability = \( c \min(1, \pi(k + 1)/\pi(k)) \)

$$
{ \mathbf i } ( k < = 1 )
$$

death probability = 0

else

death probability = \( c \min(1, \pi(k - 1)/\pi(k)) \)

comment:

probability of knot relocation is \( 1 - (\text{birth probability} + \text{death probability}) \).

- Define \( \mu^{(0)} \), used to start each iterative fitting process.
- for \( i \leftarrow 0 \) to \( (n - 1) \)



$$
\mu _ { i } ^ { ( 0 ) } = \max \left ( 0 . 1 , y _ { i } \right )
$$
