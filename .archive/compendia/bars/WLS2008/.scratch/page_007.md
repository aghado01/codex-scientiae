
- 2. Read data, and normalize function argument (e.g., time) to interval (0 , 1).
- 3. Find initial knot set.
- 4. Run MCMC. For g = 1 ,...,G b , where G b is the number of burn-in iterations, do steps (a) and (b) only; subsequently do all of (a)–(e):


- (a) Take knot step: addition, deletion, or relocation. This produces ξ ( g ) .
- (b) Evaluate integral in ( 2 ), exactly in normal case, approximately in Poisson case.
- (c) Generate β ( g ) .
- (d) Using β ( g ) , obtain fits and also BIC, loglikelihood, maximum, location of the maximum, and number of interior knots.
- (e) Update modal knot set (if appropriate).


- 5. Obtain mean and modal estimates of function values, both on a grid and at all observed argument values, and of the maximum and location of maximum.
- 6. Obtain confidence intervals for the maximum and location of maximum.
- 7. Write the results.


We next elaboarate on each of these steps. At the end of this section we discuss briefly the additional publicly-available subroutines that are used by BARS.

# 3.1. User-defined parameters

The user may set various parameters by specifying their values in the optional parameters file. The following parameters are allowed.

burn-in_iterations : The number of burn-in MCMC iterations. Default value = 0 .

sample_iterations : The number of sample MCMC iterations. Default value = 2000 .

Use_Logspline : true or false to indicate whether Logspline is used for the initial knots. If Logspline is not used, evenly spaced knots are used. Default value = true .

initial_number_of_knots : The number of initial interior knots used. This only has an affect if Logspline is not used. Default value = 3 .

beta_iterations : Number of iterations for the independence chain on beta for a particular set of knots. It only runs a chain if the initial beta variate is suspect. In this case, the independence chain is run starting from the mle and only the last variate is used. If no beta candidates were accepted, no beta is used although the knot set is not rejected. Default value = 3 .

beta_threshhold : Threshhold for determining whether the initial beta variate is suspect. It is suspect if the log acceptance probability is less than the threshhold. Default value = -10.0 .

prior_form : This is the prior on the number of knots k . Possible values: Uniform , Poisson , User (for user-defined). Default value = Uniform . Uniform refers to a uniform distribution on the interval ( L,U ). For User , see discussion following list of parameters.

Uniform_parameter_L : Default value = 1 . Uniform_parameter_U : Default value = MAXKNOTS = 60 .
