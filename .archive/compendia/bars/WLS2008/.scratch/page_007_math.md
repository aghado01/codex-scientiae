[Page 7]

We next elaboarate on each of these steps. At the end of this section we discuss brieﬂy the additional publicly-available subroutines that are used by BARS.

The user may set various parameters by specifying their values in the optional parameters ﬁle. The following parameters are allowed.

burn-in_iterations : The number of burn-in MCMC iterations. Default value = 0 .

sample_iterations : The number of sample MCMC iterations. Default value = 2000 .

Use_Logspline : true or false to indicate whether Logspline is used for the initial knots. If Logspline is not used, evenly spaced knots are used. Default value = true .

initial_number_of_knots : The number of initial interior knots used. This only has an aﬀect if Logspline is not used. Default value = 3 .

beta_iterations : Number of iterations for the independence chain on beta for a particular set of knots. It only runs a chain if the initial beta variate is suspect. In this case, the independence chain is run starting from the mle and only the last variate is used. If no beta candidates were accepted, no beta is used although the knot set is not rejected. Default value = 3 .

beta_threshhold : Threshhold for determining whether the initial beta variate is suspect. It is suspect if the log acceptance probability is less than the threshhold. Default value = -10.0 .

prior_form : This is the prior on the number of knots k.Possible values: Uniform, Poisson, User (for user-deﬁned). Default value = Uniform.Uniform refers to a uniform distribution on the interval ( L,U ). For User, see discussion following list of parameters.

Uniform_parameter_L : Default value = 1.Uniform_parameter_U : Default value = MAXKNOTS = 60 .
