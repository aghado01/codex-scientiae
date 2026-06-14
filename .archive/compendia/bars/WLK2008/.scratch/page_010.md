[Page 10]

initial: logspline, or even or equal for evenly spaced initial knots. Default value = logspline.

iknots: the initial number of knots for the spline if using evenly spaced knots. Default value = 3.

Settings on prior for knots

prior: the type of prior being used for the knots. The only acceptable answers are Poisson, uniform, and user. Default value = uniform.

priorparam: the parameter for the prior

- * if using Poisson, the choice for lambda = mean
- * if using uniform, a vector of length 2 which includes the minimum number of knots followed by the maximum number of knots. Default value = c(1,60).
- * if using user, a matrix with 2 columns. The first column should be the number of knots and the second column should be the probability of obtaining this number of knots.


MCMC settings

burnin: the desired length of the burn-in for the MCMC chain. Default value = 200.

sims: the number of simulations desired for the MCMC chain. Default value = 2000.

tau: parameter τ that controls the spread for the knot proposal distribution. Default value = 50.0.

c: parameter that controls the probability of birth and death candidates. Default value = 0.4.

Output settings

fits: if T, the program will return the fitted values for each x-value for each run of the simulation. Default value = T. Please note that if the number of data points and/or simulations is large, there may be a lengthy delay as the necessary data is read.

peak: if T, the program will return the location and height of the highest point on the fitted curve. Default value = F.

conf: for use with peak. Sets the probability for the credible intervals for the location and height of the peak. Default value = 0.95 for 95% credible intervals.

Other settings

trials: the number of trials that are concatenated in the data. Default value = 1.

bins: the number of bins the x -axis is divided into used to handle unbinned data and calculate posterior modes. Default value = 150.

## • Output

postmeans: vector of the posterior means evaluated at the x values postmodes: vector of the posterior modes evaluated at the x values
