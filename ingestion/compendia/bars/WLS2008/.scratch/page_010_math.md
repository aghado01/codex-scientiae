[Page 10]

the normal case, the least-squares estimate) is also retained so that modal ﬁts can be produced for the ﬁnal modal knot set.

Ater MCMC terminates, the iterations are used to ﬁnd posterior mean and modal ﬁts. The ﬁts are obtained both at all t j values and on a user-speciﬁed grid. In addition, the mean and modal values of the function maximum and its location are computed.

Based on the set of draws from the posteriors that are used to form estimates, quantiles are computed via partial sorting. By default the .025 and .975 quantiles form the 95% posterior (“credible”) intervals. Currently, conﬁdence intervals are only obtained for the function maximum and location of the maximum. Other intervals may be obtained easily from the draws from the posterior in the output.

Results are written into a series of ﬁles:

sampled_knots_file : The name of the output ﬁle for the sampled knot locations. Format is [iteration number] [number of interior knots] [knots ... ] Note that the number of entries per line will vary. Use none to indicate no ﬁle. Default value = none .

sampled_mu_file : The name of the output ﬁle for sampled ﬁtted values ( µ ) at the observed argument points t 1,...,t n.Use none to indicate no ﬁle. Default value = samp_mu .

sampled_mu-grid_file : The name of the output ﬁle for sampled ﬁtted values ( µ ) on the evenly spaced grid points. Use none to indicate no ﬁle. Default value = none .

sampled_params_file : The name of the output ﬁle for sampled values of various parameters. The parameters given are iteration number, BIC, log likelihood, location of peak, height at peak, number of interior knots. Use none to indicate no ﬁle. Default value = samp_params .

summary_mu_file : The name of the output ﬁle for summary ﬁtted values ( µ ) at the observed argument points t 1,...,t n.Three rows are given with the t values, posterior mean, and posterior mode, respectively. Use none to indicate no ﬁle. Default value = summ_mu .

summary_mu-grid_file : The name of the output ﬁle for summary ﬁtted values ( µ ) on the evenly spaced grid points. Three rows are given with the t values, posterior mean, and posterior mode, respectively. Use none to indicate no ﬁle. Default value = none .

summary_params_file : The name of the output ﬁle for summary values of certain parameters. The ﬁrst row is for the location of the peak, and the second is for the height, and the third is for the number of interior knots. The ﬁrst two columns are quantiles giving a conﬁdence interval for the speciﬁed conﬁdence level (see parameter confidence_level ). The third column is the posterior mean, and the fourth is the posterior mode. Use none to indicate no ﬁle. Default value = summ_params .

In addition to incorporating the logspline code, we have used routines for manipulating B- splines written by Bates and Venables (included in the release of R, see R Development Core Team 2006) and for random number generation obtained from Ranlib (Brown and Lovato 1996). These are part of the BARS code.
