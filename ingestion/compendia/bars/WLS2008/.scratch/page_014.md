
- k ∗ , the number of interior knots
- ξ ∗ , the set of interior knots
- X D, ∗ , the design basis, and X G, ∗ , the grid basis. The design basis is based on the input bin midpoints. The grid basis is based upon a grid of evenly spaced points, the number of which is user defined.
- statistical model fitting information, including parameter estimates, error estimates, and failure to fit.
- β ∗ ∼ π ( β | k ∗ ,ξ ∗ , Data ) µ D, ∗ = exp( X D β ∗ ) µ G, ∗ = exp( X G β ∗ )
- The BIC and log likelihood for the full model with parameters ( k ∗ ,ξ ∗ ,β ∗ ).


Declare models M curr , M cand , and M temp .

Set initial knots in M curr . The initial knots may be user defined, equally spaced, or obtained via logspline.

Calculate birth and death probabilities for each possible value of k , using the userdefined prior, as follows:

if ( k > = MAXKNOTS) birth probability = 0 else birth probability = c min(1 ,π ( k + 1) /π ( k )) if ( k < = 1) death probability = 0 else death probability = c min(1 ,π ( k − 1) /π ( k ))

# comment:

probability of knot relocation is 1 − ( birth probability + death probability ).

Define µ (0) , used to start each iterative fitting process.

for i ← 0 to ( n − 1)

$$
\mu _ { i } ^ { ( 0 ) } = \max \left ( 0 . 1 , y _ { i } \right )
$$

Form the natural spline design basis for M curr → X D, curr

Fit the Poisson regression model for M curr . See function description below.

if (fit of M curr failed)
