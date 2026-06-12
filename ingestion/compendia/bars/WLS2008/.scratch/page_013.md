
# Optional Output

– Optional output if fits = T sampfits : matrix of fits for rows of the matrix corresponding the fits at each value of x .

each iteration, excluding burning iterations, with the to the individual iteration. The columns represent

– Optional output if peak = T

samplpeaks : vector of the x location of the highest point in the fitted curve for each iteration, excluding burning iterations

samphpeaks : vector of the y value (height) of the highest point in the fitted curve for each iteration, excluding burning iterations

peaklocationquantile : a credible interval for the x location of the highest peak; width of the interval is dependent upon the setting chosen for conf

the mean x location for the highest peak

peaklocationmean :

the mode x location for the highest peak

peaklocationmode :

peakheightquantile : a credible interval for the y value (height) of the highest peak; width of the interval is dependent upon the setting chosen for conf

the mean y value (height) of the highest peak

peakheightmean :

the mode y value (height) of the highest peak

peakheightmode :

# 5. Pseudo-code

# 5.1. Function: BARS for Poisson count data

Read data: For Poisson count data, the data must take the form of pairs of bin midpoints and Poisson counts. The number of replicated data sets is also required. In neuron firing examples, this is the number of trials. In many other examples, the number of replicated data sets may be set to one.

Read user parameters: These include parameters that specify the form of the prior, prior parameters, mcmc parameters, and parameters that specify output variables and the destination files.

Normalize data: The bin midpoints are normalized to lie between 0 and 1, inclusive.

MCMC: See function description below.

Write summary output of desired parameters.

return

# 5.2. Function: MCMC

In the following, a model M ∗ contains information for an individual MCMC iteration. In particular, it contains
