[Page 5]

$$
f ( t ) = & \frac { \lambda ( t ) } { \int _ { 0 } ^ { T } \lambda ( u ) \, d u }
$$

then it becomes clear that estimation of \( \lambda(t) \) amounts to estimation of the probability density \( f(t) \), together with estimation of FILL_ME_IN. We use \( N = n \) as an estimate of FILL_ME_IN, and apply logspline to estimate \( f(t) \). logspline returns a set of knots for a cubic spline, and these are used as initial values for BARS in the Poisson case.

logspline is a carefully-implemented version of forward knot addition followed by backward elimination of knots. In the normal case we have simply begun with a large set of knots (defaulted to equally-spaced in the current version) and then performed backward elimination using BIC, until BIC fails to increase as knots are eliminated. Because logspline is itself an effective algorithm, we believe the Poisson version of our code is likely to be more efficient than the normal version in the sense that short MCMC run lengths can be used with Poisson. We have set the defaults for Poisson at 500 burn-in iterations and 2,000 run iterations, while for the normal these have been set to 5,000 and 20,000.

We describe below the code and wrappers for the Poisson versions. The normal versions omit statements involving logspline , and they also omit the regression step used to approximate the integral in (2). In describing the Poisson regressions we take the Poisson parameter to be \( \mu \). Thus, at time points \( t_1, \dots, t_n \) we have corresponding mean values \( \mu_1, \dots, \mu_n \). (In the neuronal setting with \( m \) repeated trials, for the histogram bin centered at \( t_j \), the expected number of spiking events is \( \mu_j = m w \lambda(t_j) \) where \( w \) is the bin width in seconds and \( \lambda(t) \) is in units of spiking events per second.)

## 3. Overview of code

Our normal and Poisson BARS implementations proceed through the following general steps (see Figure 3):

- 1. Read user-defined parameters.
- 2. Read data, and normalize function argument (e.g., time) to interval (0, 1).
- 3. Find initial knot set.
- 4. Run MCMC. For \( g = 1, \dots, G_b \), where \( G_b \) is the number of burn-in iterations, do steps (a) and (b) only; subsequently do all of (a)-(e):


- a. Take knot step: addition, deletion, or relocation. This produces \( \xi^{(g)} \).
- b. Evaluate integral in (2), exactly in normal case, approximately in Poisson case.
- c. Generate \( \beta^{(g)} \).
- d. Using \( \beta^{(g)} \), obtain fits and also BIC, loglikelihood, maximum, location of the maximum, and number of interior knots.
- e. Update modal knot set (if appropriate).


- 5. Obtain mean and modal estimates of function values, both on a grid and at all observed argument values, and of the maximum and location of maximum.
- 6. Obtain confidence intervals for the maximum and location of maximum.
- 7. Write the results.
