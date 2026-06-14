[Page 11]

sims: vector of each simulation number, beginning at burnin + 1 and ending at burnin + sims

no.knots: vector of the number of knots used at each iteration, excluding burning iterations

sampknots: matrix containing the position of the knots at each iteration. Length of the matrix is equal to the number of iterations, excluding burnin iterations, with the width of the matrix equal to the maximum number of knots at any iteration. NAs are used to fill in the matrix at iteration numbers that have less than the maximum number of knots.

sampBICs: vector of the calculated BIC at each iteration, excluding burning iterations

sampllikes: vector of the calculated loglikelihood at each iteration, excluding burning iterations

## • Optional Output

Optional output if fits = T

sampfits: matrix of fits for each iteration, excluding burning iterations, with the rows of the matrix corresponding to the individual iteration. The columns represent the fits at each value of x.

Optional output if peak = T

samplpeaks: vector of the x location of the highest point in the fitted curve for each iteration, excluding burning iterations

samphpeaks: vector of the y value (height) of the highest point in the fitted curve for each iteration, excluding burning iterations

peaklocationquantile: a credible interval for the x location of the highest peak; width of the interval is dependent upon the setting chosen for conf

peaklocationmean: the mean x location for the highest peak

peaklocationmode: the mode x location for the highest peak

peakheightquantile: a credible interval for the y value (height) of the highest peak; width of the interval is dependent upon the setting chosen for conf

peakheightmean: the mean y value (height) of the highest peak

peakheightmode: the mode y value (height) of the highest peak

## 5. Pseudo-code

## 5.1. Function: BARS for Poisson count data

- Read data: For Poisson count data, the data must take the form of pairs of bin midpoints and Poisson counts. The number of replicated data sets is also required. In neuron firing examples, this is the number of trials. In many other examples, the number of replicated data sets may be set to one.
- Read user parameters: These include parameters that specify the form of the prior, prior parameters, mcmc parameters, and parameters that specify output variables and the destination files.
- Normalize data: The bin midpoints are normalized to lie between 0 and 1, inclusive.
