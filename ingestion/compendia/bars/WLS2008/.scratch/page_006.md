
![At the bottom of the image, we can see a diagram with some text. There are two main components in the image. One is called User-defined Parameters and the other is called MCMC. Both of them are connected with some data points.](<images/WLS2008/imageFile2.png>)

Sampled

User-defined

Parameter

Parameters

Values

Initial Knot Set

MCMC

Function Estimates

Data

Logspline

Confidence

Poisson only)

Intervals

Figure 2: Diagram of our normal and Poisson BARS implementations. User-defined parameters and data are input and used to create the initial knot set. In the Poisson case, logspline may be used to create the initial knot set. The MCMC runs starting from the initial knot set and outputs sampled parameter values, function estimates and confidence intervals.

logspline is a carefully-implemented version of forward knot addition followed by backward elimination of knots. In the normal case we have simply begun with a large set of knots (defaulted to equally-spaced in the current version) and then performed backward elimination using BIC, until BIC fails to increase as knots are eliminated. Because logspline is itself an effective algorithm, we believe the Poisson version of our code is likely to be more efficient than the normal version in the sense that short MCMC run lengths can be used with Poisson. We have set the defaults for Poisson at 500 burn-in iterations and 2,000 run iterations, while for the normal these have been set to 5,000 and 20,000.

We describe below the code and wrappers for the Poisson versions. The normal versions omit statements involving logspline , and they also omit the regression step used to approximate the integral in ( 2 ). In describing the Poisson regressions we take the Poisson parameter to be µ . Thus, at time points t 1 ,...,t n we have corresponding mean values µ 1 ,...,µ n . (In the neuronal setting with m repeated trials, for the histogram bin centered at t j , the expected number of spiking events is µ j = mwλ ( t j ) where w is the bin width in seconds and λ ( t ) is in units of spiking events per second.)

# 3. Overview of code

Our normal and Poisson BARS implementations proceed through the following general steps (see Figure 3 ):

1. Read user-defined parameters.
