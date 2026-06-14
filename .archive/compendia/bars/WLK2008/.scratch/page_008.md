[Page 8]

- b. Approximation of the integral in (2), in the Poisson case, is accomplished via BIC. This is obtained from the Poisson regression based on the proposed set of knots. This regression also produces the MLE and observed information matrix, needed in (c).
- c. In the normal case, is produced by a draw from the relevant multivariate normal distribution of the posterior of β ξ conditionally on ξ = ξ ( g ) , obtained analytically. In the Poisson case, for sufficiently large samples, the normal approximation to the posterior based on the MLE and observed information may be used. The algorithm always attempts to draw from this approximating normal distribution. However, if the acceptance ratio is extremely small, a short MCMC run is used instead. We have found this to be quite important because in many of our applications a Poisson mean at some time t may be very small and thus may produce a highly skewed posterior distribution.
- d. After is drawn from the conditional posterior, fits may be obtained. In our applications we are often interested in maxima and their locations. Therefore, by default, we compute these.
- e. If BIC for the newly-obtained, current ξ ( g ) is larger than BIC for all preceding knot sets then the current ξ ( g ) is retained as the current modal knot set. The MLE (in the normal case, the least-squares estimate) is also retained so that modal fits can be produced for the final modal knot set.


## 3.5. Obtain estimates

Ater MCMC terminates, the iterations are used to find posterior mean and modal fits. The fits are obtained both at all t j values and on a user-specified grid. In addition, the mean and modal values of the function maximum and its location are computed.

## 3.6. Obtain posterior intervals

Based on the set of draws from the posteriors that are used to form estimates, quantiles are computed via partial sorting. By default the .025 and .975 quantiles form the 95% posterior (“credible”) intervals. Currently, confidence intervals are only obtained for the function maximum and location of the maximum. Other intervals may be obtained easily from the draws from the posterior in the output.

## 3.7. Write results

## Results are written into a series of files

sampled_knots_file: The name of the output file for the sampled knot locations. Format is [iteration number] [number of interior knots] [knots . . .] Note that the number of entries per line will vary. Use none to indicate no file. Default value = none.

sampled_mu_file: The name of the output file for sampled fitted values ( μ ) at the observed argument points t 1 , . . . , t n . Use none to indicate no file. Default value = samp_mu.

sampled_mu-grid_file: The name of the output file for sampled fitted values ( μ ) on the evenly spaced grid points. Use none to indicate no file. Default value = none.

sampled_params_file: The name of the output file for sampled values of various parameters. The parameters given are iteration number, BIC, log likelihood, location of peak, height at peak, number of interior knots. Use none to indicate no file. Default value = samp_params.
