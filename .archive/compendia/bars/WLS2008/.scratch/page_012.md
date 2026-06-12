
if using user , a matrix with 2 columns. The first column should be the number of knots and the second column should be the probability of obtaining this number of knots.

– MCMC settings

burnin : the desired length of the burn-in for the MCMC chain. Default value = 200 .

sims : the number of simulations desired for the MCMC chain. Default value = 2000 .

tau : parameter τ that controls the spread for the knot proposal distribution. Default value = 50.0 .

c : parameter that controls the probability of birth and death candidates. Default value = 0.4 .

– Output settings

fits : if T , the program will return the fitted values for each x -value for each run of the simulation. Default value = T . Please note that if the number of data points and/or simulations is large, there may be a lengthy delay as the necessary data is read.

peak : if T , the program will return the location and height of the highest point on the fitted curve. Default value = F .

conf : for use with peak. Sets the probability for the credible intervals for the location and height of the peak. Default value = 0.95 for 95% credible intervals.

– Other settings

trials : the number of trials that are concatenated in the data. Default value = 1 .

bins : the number of bins the x -axis is divided into used to handle unbinned data and calculate posterior modes. Default value = 150 .

Output

postmeans : vector of the posterior means evaluated at the x values

postmodes : vector of the posterior modes evaluated at the x values

sims : vector of each simulation number, beginning at burnin + 1 and ending at burnin + sims

no.knots : vector of the number of knots used at each iteration, excluding burning iterations

sampknots : matrix containing the position of the knots at each iteration. Length of the matrix is equal to the number of iterations, excluding burnin iterations, with the width of the matrix equal to the maximum number of knots at any iteration. NAs are used to fill in the matrix at iteration numbers that have less than the maximum number of knots.

sampBICs : vector of the calculated BIC at each iteration, excluding burning iterations

sampllikes : vector of the calculated loglikelihood at each iteration, excluding burning iterations
