--- ENRICHED TEXT OUTPUT ---

[Page 1]

JSS

June 2008, Volume 26, Issue 1.

http://www.jstatsoft.org/

Garrick Wallstrom University of Pittsburgh Jeffrey Liebner Carnegie Mellon University

Robert E. Kass Carnegie Mellon University

BARS ( DiMatteo, Genovese, and Kass 2001 ) uses the powerful reversible-jump MCMC engine to perform spline-based generalized nonparametric regression. It has been shown to work well in terms of having small mean-squared error in many examples (smaller than known competitors), as well as producing visually-appealing ﬁts that are smooth (ﬁltering out high-frequency noise) while adapting to sudden changes (retaining high-frequency signal). However, BARS is computationally intensive. The original implementation in S was too slow to be practical in certain situations, and was found to handle some data sets incorrectly. We have implemented BARS in C for the normal and Poisson cases, the latter being important in neurophysiological and other point-process applications. The C implementation includes all needed subroutines for ﬁtting Poisson regression, manipulating B-splines (using code created by Bates and Venables), and ﬁnding starting values for Poisson regression (using code for density estimation created by Kooperberg). The code utilizes only freely-available external libraries ( LAPACK and BLAS ) and is otherwise self-contained. We have also provided wrappers so that BARS can be used easily within S or R .

Keywords : curve-ﬁtting, free-knot splines, nonparametric regression, peri-stimulus time histogram, Poisson process.

Figure 1 displays a normalized histogram (called a peri-stimulus time histogram, or PSTH, in the neuroscience literature) of neuronal spiking events across time. This histogram may be considered an estimate of a Poisson process intensity function. Overlaid on the histogram is a Gaussian kernel density estimate (the dotted wiggly line) with bandwidth selected by


[Page 2]

106

firing rate (spikes/s)




−200


200

400

600

800

Time (ms)

Figure 1: Histogram and ﬁts using a Gaussian kernel density estimator (dotted line), logspline (thin line), and BARS (thick line). Units are in spiking events per second, the usual units for intensity functions based on neuronal spiking events. The data come from a neuron in inferotemporal cortex recorded during 16 replications (in physiological jargon, 16 trials) of an experiment described by Baker et al. ( 2002 ).

unbiased cross-validation ( Venables and Ripley 2002 ), which smooths the histogram. From a neurophysiological point of view, it is reasonable to expect the intensity function to vary slowly throughout much of its domain, but perhaps rapidly in a relative short interval. In this situation, the kernel density estimate oversmooths the rapid jump in the intensity, while undersmoothing the portion involving slow variation. It would be preferable to use a method of estimating the intensity function that adapts to functional variation across time.

For a Poisson process, when the events are put into small time bins, as in Figure 1, the data form a sequence of Poisson-distributed counts and estimation of the Poisson process intensity function becomes a Poisson regression problem. This problem motivated development of BARS (Bayesian adaptive regression splines, DiMatteo et al. 2001 ), which uses regression splines with knot sets determined adaptively via Markov chain Monte Carlo (MCMC). A


[Page 3]

substantial literature has documented the eﬀectiveness of spline-based nonparametric regression and its generalizations, with the knots being determined empirically. See Hansen and Kooperberg ( 2002 ) and the accompanying discussion. The ﬁts by BARS (represented by the thick smooth line) and another popular free-knot spline approach (thin line), logspline ( Stone, Hansen, Kooperberg, and Truong 1997 ), are displayed in Figure 1 and represent marked improvements over the Gaussian kernel density estimate. DiMatteo et al. ( 2001 ) showed in several examples that BARS could perform dramatically better than two closelyrelated methods, which themselves were better in many examples than competitors such as wavelet-based methods.

BARS has been used in variety of applications in neurophysiology, imaging, genetics, and EEG analysis (see DiMatteo et al. 2001 ; Kass, Ventura, and Cai 2003 ; Kass and Wallstrom 2002 ; Zhang, Roeder, Wallstrom, and Devlin 2003 ; Wallstrom, Kass, Miller, Cohn, and Fox 2004 ). Furthermore, preliminary results have indicated that, with reasonable sample sizes, posterior credible regions produced by BARS have very close to the correct frequentist coverage probabilities. For example, simulating from a curve based on the ﬁring-rate function displayed in Figure 1, the coverage of the 95% posterior credible region for location of the peak was 95.9%, with two-digit accuracy (simulation SE =.005, based on 7,600 simulated data sets).

The original implementation of DiMatteo et al. ( 2001 ) was in S ( Insightful Corp. 2003 ). It was very slow, and also suﬀered from bugs that caused occasional very poor ﬁts. We wished to improve the implementation. In addition, in order to study frequentist coverage probabilities we had to use a parallel array of multiple processors, and therefore needed self-contained code. This article discusses a relatively fast, self-contained, and, we believe, careful BARS implementation in C with S and R wrappers. We give an overview of BARS in Section 2 and an overview of the code in Section 3.Section 4 describes the S and R wrappers and Section 5 gives pseudo-code for the C implementation.

Consider the problem of making inferences about a function f ( t ), where t lies in an interval [ A,B ], based on data y = y 1,...,y n obtained at t = t 1,...,t n, with each Y j assumed to depend probabilistically on f ( t j ) (and, following the usual convention, y j represents the observed value of the random variable Y j ). To solve this problem BARS ﬁts the spline-based generalized nonparametric regression model for data Y j depending on a variable t,

$$
\begin{array} { c c c c } & Y _ { j } & \sim & P ( y _ { j } | \theta _ { j }, \zeta ) \\ & \theta _ { j } & = & f ( t _ { j } ) \end{array}
$$

with f being a linear combination of splines having unknown sets of knot locations. Model ( 1 ) includes a vector of nuisance parameters ζ to indicate generality, though in the Poisson case there are no nuisance parameters. Writing f ( t ) in terms of basis functions b ξ,h ( t ) as f ( t ) = h b ξ,h ( t ) β ξ,h the function evaluations f ( t 1 ),...,f ( t n ) may be collected into a vector ( f ( t 1 ),...,f ( t n )) = X ξ β ξ, where X ξ is the design matrix and β ξ is the coeﬃcient vector. For a given knot set ξ = ( ξ 1,...,ξ k ) model ( 1 ) poses a relatively easy estimation problem; for exponential-family responses (such as Poisson) it becomes a generalized linear model. Selecting the interval [ A,B ] can be diﬃcult in some problems due to spline boundary conditions


[Page 4]

(see Hansen and Kooperberg 2002, and the accompanying discussion), but in many problems such as the neuronal spiking problem, it is rarely an issue because data are often available outside of the time interval of interest, [ A,B ]. The hard part of the problem is determining the knot set ξ, and using the data to do so provides the ability to ﬁt a wide range of functions (as reviewed by Hansen and Kooperberg 2002 ). BARS is an MCMC-based algorithm that samples from a suitable approximate posterior distribution on the knot set ξ.This, in turn, produces samples from the posterior on the space of splines. In practice, cubic splines and the natural spline basis have been used in most applications. BARS could be viewed as a powerful engine for searching for an “optimal” knot set, but because it generates a posterior on the space of splines it produces an improved spline estimate based on model averaging (e.g., Kass and Raftery 1995 ) and it also provides uncertainty assessments.

Key features of the MCMC implementation of BARS include (i) a reversible-jump chain on ξ after integrating the marginal density

$$
P ( y | \xi ) = \int P ( y | \beta _ { \xi }, \xi, \zeta ) \pi ( \beta _ { \xi }, \zeta | \xi ) d \beta _ { \xi } d \zeta
$$

(where y = ( y 1,...,y n )), the integration being performed exactly for normal data and approximately, by Laplace’s method, otherwise, (ii) continuous proposals for ξ, and (iii) a locality heuristic for the proposals that attempts to place potential new knots near existing knots. For notational convenience here we are supressing the dependence of the knot set ξ on the number of knots k but BARS explores the space of generalized regression models deﬁned by ξ and k and the prior on k can, in some cases, control the algorithm in important ways (see DiMatteo et al. 2001 ; Hansen and Kooperberg 2002 ; Kass and Wallstrom 2002 ).

The essential idea of using reversible-jump MCMC to select knots was suggested by Denison, Mallick, and Smith ( 1998 ), following the lead of Green ( 1995 ), who discussed the special case of change-point problems. However, aspects of BARS outlined in (i)–(iii) distinguish it from (and improve upon) the method of Denison et al. ( 1998 ) (see Kass and Wallstrom 2002 ). The ﬁrst implementation feature, item (i) above, introduces an analytical step within the MCMC partly to simplify the problem of satisfying detailed balance and partly for the sake of MCMC eﬃciency (which is generally increased when parameters are integrated; see Liu, Wong, and Kong 1994 ). In addition, BARS takes advantage of the high accuracy of Laplace’s method in this context. In doing so the “unit-information” prior discussed by Kass and Wasserman ( 1995 ) and Pauler ( 1998 ) has been used (as π in ( 2 )), and this gives the interpretation that the algorithm is essentially using BIC to deﬁne a Markov chain on the knot sets. The importance of performing the integral ( 2 ), at least approximately, has been stressed by Kass and Wallstrom ( 2002 ). Continuous proposals and the locality heuristic (items (ii) and (iii)) together allow knots to be placed close to one another, which is advantageous when there is a sudden jump in the function.

For each draw ξ ( g ) from the posterior distribution of ξ, a draw β ( g ) ξ is obtained from the conditional posterior of β ξ, conditionally on ξ ( g ).The conditional posterior of β ξ often may be assumed normal, but in some cases the normal approximation is not very good. DiMatteo et al. ( 2001 ) described an importance reweighting scheme to improve upon the normal approximation. In the code discussed here, if the normal approximation seems poor, we instead use a conditional Metropolis update.


[Page 5]

From β ( g ) ξ we obtain ﬁtted values f ( g ) ( ˜ t ) = b ξ,h ( ˜ t ) β ( g ) ξ,h for selected ˜ t and these, in turn, may be used to produce a draw φ ( g ) from the posterior distribution of any characteristic φ = φ ( f ) (such as the value at which the maximum of f ( t ) occurs). Thus, the key output of BARS is the set of vectors ˜ f ( g ) = ( f ( g ) ( ˜ t 1 ),f ( g ) ( ˜ t 2 ),...,f ( g ) ( ˜ t p )) for MCMC iterates g = 1,...,G, each ˜ f ( g ) being a vector of ﬁts along a grid ˜ t 1, ˜ t 2,..., ˜ t p that suitably covers the interval [ A,B ]. The user may sample from the posterior distribution of any functional φ simply by evaluating φ ( g ) = φ ( ˜ f ( g ) ). For instance, a sample from the posterior distribution of the location of the maximum of f ( t ) is obtained by ﬁnding the location of the maximum of ˜ f ( g ) for each g.This latter computation is performed in a suitable post-processing environment such as S or R.MCMC convergence may be assessed by standard methods ( Gelman, Carlin, Stern, and Rubin 2004, Section 11.6) though this remains a topic of general research interest ( Fan, Brooks, and Gelman 2006 ).

We have implemented two versions of BARS. One implementation, barsN uses a normal model in ( 1 ). The second, barsP uses a Poisson model. Our choices were based on the general interest in ordinary curve-ﬁtting (the normal case) and our deep and continuing interest in ﬁtting neuronal data (the Poisson case).

The two implementations diﬀer not only through the change of likelihood, and the resulting Laplace approximation to ( 2 ) implemented with BIC for the Poisson case, but also in the selection of starting values for the MCMC algorithm. Starting values are very important: poor choices of initial knot sets result in extremely long burn-in periods to achieve apparent stationarity. In the Poisson case we have taken advantage of the closely-related algorithm logspline (see Hansen and Kooperberg 2002 ) and have incorporated Charles Kooperberg’s C implementation of it for density estimation.

Our ability to use Kooperberg’s implementation for density estimation rests on the duality of ﬁtting Poisson process intensity functions and ﬁtting probability densities: the inhomogeneous Poisson likelihood for an intensity function λ = λ ( t ) based on a sequence of event times t 1,t 2,...,t n in an interval (0,T ] is

$$
\begin{array} { r c l } L ( \lambda ) & = & P ( t _ { 1 }, \dots, t _ { n } ) \\ & = & e ^ { - \int _ { 0 } ^ { \top } \lambda ( u ) d u } \prod _ { j = 1 } ^ { n } \lambda ( t _ { j } ).\end{array}
$$

Here the number of events N is a Poisson random variable with expectation 0 λ ( u ) du.Conditionally on the number of events N = n the probability density becomes

$$
P ( t _ { 1 }, \dots, t _ { N } | N = n ) = \prod _ { j = 1 } ^ { n } \lambda ( t _ { j } ) .
$$

If we set

$$
f ( t ) = \frac { \lambda ( t ) } { \int _ { 0 } ^ { \top } \lambda ( u ) d u }
$$

then it becomes clear that estimation of λ ( t ) amounts to estimation of the probability density f ( t ), together with estimation of λ ( u ) du.We use N = n as an estimate of λ ( u ) du, and


[Page 6]

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

Figure 2: Diagram of our normal and Poisson BARS implementations. User-deﬁned parameters and data are input and used to create the initial knot set. In the Poisson case, logspline may be used to create the initial knot set. The MCMC runs starting from the initial knot set and outputs sampled parameter values, function estimates and conﬁdence intervals.

logspline is a carefully-implemented version of forward knot addition followed by backward elimination of knots. In the normal case we have simply begun with a large set of knots (defaulted to equally-spaced in the current version) and then performed backward elimination using BIC, until BIC fails to increase as knots are eliminated. Because logspline is itself an eﬀective algorithm, we believe the Poisson version of our code is likely to be more eﬃcient than the normal version in the sense that short MCMC run lengths can be used with Poisson. We have set the defaults for Poisson at 500 burn-in iterations and 2,000 run iterations, while for the normal these have been set to 5,000 and 20,000.

We describe below the code and wrappers for the Poisson versions. The normal versions omit statements involving logspline, and they also omit the regression step used to approximate the integral in ( 2 ). In describing the Poisson regressions we take the Poisson parameter to be µ.Thus, at time points t 1,...,t n we have corresponding mean values µ 1,...,µ n.(In the neuronal setting with m repeated trials, for the histogram bin centered at t j, the expected number of spiking events is µ j = mwλ ( t j ) where w is the bin width in seconds and λ ( t ) is in units of spiking events per second.)

Our normal and Poisson BARS implementations proceed through the following general steps (see Figure 3 ):

1. Read user-deﬁned parameters.


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


[Page 8]

Poisson_parameter_lambda : Default value = 6.0 .

For k ∼ Uniform( L,...,U )

SET prior_form = Uniform

SET Uniform_parameter_L = L

SET Uniform_parameter_U = U

For k ∼ Poisson( M )

SET prior_form = Poisson

SET Poisson_parameter_lambda = M

proposal_parameter_tau : Parameter τ that controls the spread for the knot proposal distribution. A candidate knot is generated by ﬁrst selecting a current knot t, 0 < t < 1, and then selecting candidate knot ∼ beta( tτ, (1 − t ) τ ). Default value = 50 .

reversible_jump_constant_c : Parameter that controls the probability of birth and death candidates. It may be at most 0.5. Larger values increase the probability for birth death candidates. Smaller values increase the probability for knot relocation. Default value = 0.40.confidence_level : The conﬁdence level for parameter intervals. Default value = 0.95 .

number_of_grid_points : The number of evenly spaced points for the grid along which ﬁtted values will be obtained. Default value = 500 .

verbose : true or false to indicate verbose output. Default value = false .

The prior on the number of knots k is defaulted to a uniform distribution. However, as discussed by DiMatteo et al. ( 2001 ), Hansen and Kooperberg ( 2002 ), Kass and Wallstrom ( 2002 ), this prior can serve usefully to control ﬁtting. A user may specify the prior by specifying its pdf values on a set of positive integers. This is done in a ﬁle. For example, the ﬁle

2 0.05 3 0.15 4 0.30 5 0.30 6 0.10

7 0.10

indicates that P ( k = 2) = 0.05,..., P ( k = 7) = 0.10. All zero probabilities that appear between the smallest k having non-zero probability and the largest k having non-zero probability are changed to an ε > 0. The probabilities are then scaled to sum to one. Note that very low prior probabilites may make it diﬃcult for the chain to explore some posterior regions that have high posterior probability. For example, consider P ( k = 2) = P ( k = 4) = 0.499999, P ( k = 3) = 0.000002. The resulting chain would generally get stuck in either the k = 2 region of the posterior, or the k = 4 region of the posterior.


[Page 9]

The data take the form of ( x,y ) pairs where x = t in the notation of Section 2 .

By default, as discussed in Section 2, in the Poisson case the initial knot set is found using logspline.In the normal case evenly-spaced knots are placed and then backward elimination is used. Currently, an option to use evenly-spaced knots is also included for the Poisson case. (A planned improvement is to use every k -th value of t j in the data for both cases.)


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


[Page 11]

BARS also calls linear algebra subroutines from LAPACK and BLAS.These are available at http://www.netlib.org/lapack/ and http://www.netlib.org/blas/, respectively. They must be installed prior to compiling BARS. Information about these packages may be found in Anderson, Bai, Bischof, Blackford, Demmel, Dongarra, Du Croz, Greenbaum, Hammarling, McKenney, and Sorensen ( 1999 ); Dongarra, Croz, Hammarling, and Duﬀ ( 1990b, a ).

Prior to using this wrapper, one must build a chapter using the ﬁle barsP.c.The shared library must be made available with the dyn.open("S.so") command. Also, the barsP.c program must be properly compiled, with the compiled program saved as barsP.out .

Note that due to the large amount of output generated by the program, it is desirable to save the results of the program into a variable, for example:

out_barsP.fun(x, y, .....)

The wrapper performs the operation by writing the data and settings into the ﬁles bars_points and bars_params, respectively.

Following is the complete function call, including a description of its input and output.

barsP.fun(x, y, initial, iknots, prior, priorparam, burnin, sims, tau, c, fits, peak, conf, trials, bins)

Required Input

– Variables

Optional Input

– Initial knots settings

initial : logspline, or even or equal for evenly spaced initial knots. Default value = logspline .

iknots : the initial number of knots for the spline if using evenly spaced knots. Default value = 3 .

-

Settings on prior for knots prior : the type of prior being used for the knots. The only acceptable answers are Poisson, uniform, and user.Default value = uniform.priorparam : the parameter for the prior

if using Poisson, the choice for lambda = mean

if using uniform, a vector of length 2 which includes the minimum number of knots followed by the maximum number of knots. Default value = c(1,60) .


[Page 12]

if using user, a matrix with 2 columns. The ﬁrst column should be the number of knots and the second column should be the probability of obtaining this number of knots.

– MCMC settings

burnin : the desired length of the burn-in for the MCMC chain. Default value = 200 .

sims : the number of simulations desired for the MCMC chain. Default value = 2000 .

tau : parameter τ that controls the spread for the knot proposal distribution. Default value = 50.0 .

c : parameter that controls the probability of birth and death candidates. Default value = 0.4 .

– Output settings

fits : if T, the program will return the ﬁtted values for each x -value for each run of the simulation. Default value = T.Please note that if the number of data points and/or simulations is large, there may be a lengthy delay as the necessary data is read.

peak : if T, the program will return the location and height of the highest point on the ﬁtted curve. Default value = F .

conf : for use with peak. Sets the probability for the credible intervals for the location and height of the peak. Default value = 0.95 for 95% credible intervals.

– Other settings

trials : the number of trials that are concatenated in the data. Default value = 1 .

bins : the number of bins the x -axis is divided into used to handle unbinned data and calculate posterior modes. Default value = 150 .

Output

postmeans : vector of the posterior means evaluated at the x values

postmodes : vector of the posterior modes evaluated at the x values

sims : vector of each simulation number, beginning at burnin + 1 and ending at burnin + sims

no.knots : vector of the number of knots used at each iteration, excluding burning iterations

sampknots : matrix containing the position of the knots at each iteration. Length of the matrix is equal to the number of iterations, excluding burnin iterations, with the width of the matrix equal to the maximum number of knots at any iteration. NAs are used to ﬁll in the matrix at iteration numbers that have less than the maximum number of knots.

sampBICs : vector of the calculated BIC at each iteration, excluding burning iterations

sampllikes : vector of the calculated loglikelihood at each iteration, excluding burning iterations


[Page 13]

– Optional output if ﬁts = T sampfits : matrix of ﬁts for rows of the matrix corresponding the ﬁts at each value of x .

each iteration, excluding burning iterations, with the to the individual iteration. The columns represent

– Optional output if peak = T

samplpeaks : vector of the x location of the highest point in the ﬁtted curve for each iteration, excluding burning iterations

samphpeaks : vector of the y value (height) of the highest point in the ﬁtted curve for each iteration, excluding burning iterations

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

Read data: For Poisson count data, the data must take the form of pairs of bin midpoints and Poisson counts. The number of replicated data sets is also required. In neuron ﬁring examples, this is the number of trials. In many other examples, the number of replicated data sets may be set to one.

Read user parameters: These include parameters that specify the form of the prior, prior parameters, mcmc parameters, and parameters that specify output variables and the destination ﬁles.

Normalize data: The bin midpoints are normalized to lie between 0 and 1, inclusive.

MCMC: See function description below.

Write summary output of desired parameters.

return

In the following, a model M ∗ contains information for an individual MCMC iteration. In particular, it contains


[Page 14]

Declare models M curr, M cand, and M temp .

Set initial knots in M curr.The initial knots may be user deﬁned, equally spaced, or obtained via logspline.

Calculate birth and death probabilities for each possible value of k, using the userdeﬁned prior, as follows:

if ( k > = MAXKNOTS) birth probability = 0 else birth probability = c min(1,π ( k + 1) /π ( k )) if ( k < = 1) death probability = 0 else death probability = c min(1,π ( k − 1) /π ( k ))

probability of knot relocation is 1 − ( birth probability + death probability ).

Deﬁne µ (0), used to start each iterative ﬁtting process.

for i ← 0 to ( n − 1)

$$
\mu _ { i } ^ { ( 0 ) } = \max \left ( 0.1, y _ { i } \right )
$$

Form the natural spline design basis for M curr → X D, curr

Fit the Poisson regression model for M curr.See function description below.

if (ﬁt of M curr failed)


[Page 15]

Remove knots through backwards elimination until a subset is found such that 1) the model ﬁt does not fail, 2) the model has the greatest likelihood among the models with the same number of knots in which the ﬁt does not fail, and 3) the knot subset has positive prior probability. If all models with a given number of knots fail to be ﬁt, the model in which X D WX D has the smallest condition number is selected, and the procedure continues by trying to remove an additional knot.

If backwards elimination fails to ﬁnd a valid subset, the procedure tries to ﬁt a model with the minimum number of knots that have positive prior probability, with the knots equally spaced. If the model fails to be ﬁt, exit .

Set M curr to the resulting model.

maxBIC



total iterations ← burnin iterations + sampling iterations for i ← 0 to total iterations − 1 u ∼ U (0, 1) if ( u < birth probability ) s ∼ Discrete Uniform( ξ curr ) t ∼ beta ( α = sτ,β = (1 − s ) τ ) ξ cand ← ξ curr ∪ { t } k cand ← k curr + 1 Form the natural spline design basis for M cand → X D, cand Fit the Poisson regression model for M cand.if (ﬁt of M cand failed) accept probability = 0 else dens ← q ( M cand | M curr ) k curr =   r ∈ ξ curr f beta ( t | α = rτ,β = (1 − r ) τ ) accept probability = exp(   cand −   curr + log( k curr ) − log( dens ) − 0.5log( n )) comment:   ∗ in the above equation is the proﬁle likelihood,   ∗ = sup β   ( ξ ∗,k ∗,β ) else if (1 − u < death probability ) t ∼ Discrete Uniform( ξ curr ) ξ cand ← ξ curr \ { t } k cand ← k curr − 1 Form the natural spline design basis for M cand → X D, cand Fit the Poisson regression model for M cand.See function description below. if (ﬁt of M cand failed) accept probability = 0 else dens ← q ( M curr | M cand ) k cand =   r ∈ ξ cand f beta ( t | α = rτ,β = (1 − r ) τ ) accept probability = exp(   cand −   curr − log( k cand )+log( dens )+0.5log( n )) else s ∼ Discrete Uniform( ξ curr )


[Page 16]

t ∼ beta ( α = sτ,β = (1 − s ) τ ) ξ cand ← ( ξ curr ∪ { t } ) \ { s } k cand ← k curr Form the natural spline design basis for M cand → X D, cand Fit the Poisson regression model for M cand if (ﬁt of M cand failed) accept probability = 0 else dens 1 ← q ( M cand | M curr ) k curr = f beta ( t | α = sτ,β = (1 − s ) τ ) dens 2 ← q ( M curr | M cand ) k cand = f beta ( s | α = tτ,β = (1 − t ) τ ) accept probability = exp(   cand −   curr + log( dens 1 ) − log( dens 2 )) u ∼ U (0, 1) if ( u < accept probability ) comment: Candidate model accepted. Swap M curr and M cand.M temp ← M curr M curr ← M cand M cand ← M temp if ( i > = burnin iterations ) comment: Beyond the burn-in period. Generate Random Coeﬃcient Vector for M curr.See function description below. Calculate BIC curr and   curr for the full model using parameter values ( k curr,ξ curr,β curr ). µ D, curr ← exp( X D, curr β curr ) Form the natural spline grid basis for M curr → X G, curr µ G, curr ← exp( X G, curr β curr ) comment: Find mode and the mean function evaluated at the mode. In neuron ﬁring examples, it produces the location of the peak ﬁring rate, and the peak ﬁring rate. Use µ G, curr to form an interpolating spline. Locate mode of interpolating spline → ( x mode,µ curr ( x mode )) Write desired parameters to a ﬁle. Store desired parameters for later use. comment: update posterior modal values, if appropriate if (( BIC curr > maxBIC ) or ( i == burnin iterations )) maxBIC ← BIC curr parameter modes ← current parameter values

Use partial sorting to form conﬁdence intervals of desired stored parameters.

Calculate means of desired stored parameters.

return


[Page 17]

X, an n × p design matrix y, a vector of observed counts

µ (0), a vector of starting values

β, estimated coeﬃcients

U, a p × p upper triangular matrix that contains information on the estimated covariance matrix of β .

error, a boolean indicator of ﬁt failure.

µ ← µ (0)

j ← 0

❼ glyph[lscript] 0 ← 0

error ← false

repeat

$$
j & \leftarrow j + 1 \\ z & \leftarrow \log \mu + ( y - \mu ) / \mu.\\ W & \leftarrow D i a g \left ( \mu \right )
$$

H ← WX.comment: Use known diagonal structure of W

$$
J \leftarrow H ^ { \top } X
$$

U ← Upper triangular matrix from the Cholesky decomposition of J = U U if Cholesky decomposition fails

$$
\ e r r o r & \leftarrow \text {true} \\ \ e x i t & \leftarrow \text {true}
$$

else

β ← Solution to Jβ = H z.comment: Use Cholesky decomposition of J if unable to solve equation

true

error


true

exit


else

$$
\eta \leftarrow X \widehat { \beta }
$$

$$
\eta & \leftarrow X \widehat { \beta } \\ \mu & \leftarrow \exp \left ( \eta \right ) \\ \ell _ { j } & \leftarrow \sum _ { i } \left ( y _ { i } \eta _ { i } - \mu _ { i } \right ) \\ e x i t & \leftarrow ( ( | \ell _ { j } - \ell _ { j - 1 } | < \varepsilon ) \text { and } ( j > 1 ) ) \text { or } ( j > 2 0 ) )
$$


[Page 18]

Generates β from the posterior distribution π ( β | k,ξ, Data ) or from the N     β,   X   WX   − 1   approximation, as follows. One β is generated from the normal approximation. If the β appears to not be an outlier under the posterior distribution, the β variate is accepted and returned. If the β does appear to be an outlier, the routine takes a user-deﬁned number of Metropolis-Hastings steps and returns the last sampled β.The β is identiﬁed as an outlier if its log Metropolis-Hastings acceptance probability is below a user-deﬁned threshhold.

Let π ∗ denote the density for the normal approximation. Note that the Cholesky decomposition of X WX is already available from the last ﬁtting iteration.

$$
\stackrel { \beta, \, the \, M L E \, o f \, \beta.} { \beta }
$$

U, a p × p upper triangular matrix that contains information on the estimated covariance matrix of β .

MHI, the number of Metropolis-Hastings iterations. This is a user-deﬁned parameter.

MHT, the threshhold used to determine whether (a) the initial β variate from the normal approximation should be kept as the resulting variate, or (b) MHI Metropolis-Hastings iterations are used. MHT is compared to the log of the acceptance probability. MHT is a user-deﬁned parameter.

error, a boolean indicator of failure

β, the random variate. Only deﬁned if not error .

β curr ← β

for i ← 0 to MHI − 1

iter ← 0, error ← false, exit ← false

iter ← iter + 1 z ∼ N (0,I ) A ← Solution to U A = z.error ← (unable to solve equation) exit ← (( not error ) or ( iter ≥ 20))


[Page 19]

until ( exit ) if ( error ) exit else β cand ←   β + A r ← log   L ( k,ξ,β cand ) L ( k,ξ,β curr ) π ( β cand | k,ξ ) π ( β curr | k,ξ ) π ∗ ( β curr | k,ξ, Data ) π ∗ ( β cand | k,ξ, Data )   if (( i = 0) and ( r > MHT )) comment : Accept the initial variate. No additional Metropolis-Hastings steps. i ← MHI u ← r − 1.0 else u ← U (0, 1) u ← log( u ) if ( u < r ) comment : Accept the candidate β.β curr ← β cand

beta ← β curr .

return

Support for the current work was provided by NIMH Program Project MH56193. The authors are grateful for helpful comments from the referees.

Anderson E, Bai Z, Bischof C, Blackford S, Demmel J, Dongarra J, Du Croz J, Greenbaum A, Hammarling S, McKenney A, Sorensen D (1999). LAPACK Users’ Guide.3rd edition. Society for Industrial and Applied Mathematics, Philadelphia, PA.

Baker CI, Behrmann M, Olson CR (2002). “Impact of Learning on Representation of Parts and Wholes in Monkey Inferotemporal Cortex.” Nature Neuroscience, 5 (11), 1210–1216.

Brown BW, Lovato J (1996). “Library of C Routines for Random Number Generation.” URL http://www.stat.umn.edu/HELP/ranlib-docs/ranlib.c.chs .

Denison DGT, Mallick BK, Smith AFM (1998). “Bayesian MARS.” Statistics and Comping, 8, 337–346.

DiMatteo I, Genovese CR, Kass RE (2001). “Bayesian Curve Fitting with Free-Knot Splines.” Biometrika, 88, 1055–1073.


[Page 20]

Dongarra JJ, Croz JD, Hammarling S, Duﬀ I (1990a). “Algorithm 679: A Set of Level 3 Basic Linear Algebra Subprograms: Model Implementation and Test Programs.” ACM Transactions on Mathematical Software, 16 (1), 18–28.

Dongarra JJ, Croz JD, Hammarling S, Duﬀ I (1990b). “A Set of Level 3 Basic Linear Algebra Subprograms.” ACM Transactions on Mathematical Software, 16 (1), 1–17.

Fan Y, Brooks P, Gelman A (2006). “Output Assessment for Monte Carlo Simulations via the Score Statistic.” Journal of Computational and Graphical Statistics, 15, 178–206.

Gelman A, Carlin J, Stern H, Rubin D (2004). Bayesian Data Analysis.2nd edition. Chapman & Hall/CRC, Boca Raton.

Green PJ (1995). “Reversible Jump Markov Chain Monte Carlo Computation and Bayesian Model Determination.” Biometrika, 82, 711–732.

Hansen MH, Kooperberg C (2002).“Spline Adaptation in Extended Linear Models.” Statistical Science, 17, 2–51.

Insightful Corp (2003). S-PLUS Version 6.2.Seattle, WA. URL http://www.insightful. com/ .

Kass RE, Raftery AE (1995).“Bayes Factors.” Journal of the American Statistical Association, 90, 773–795.

Kass RE, Ventura V, Cai C (2003). “Statistical Smoothing of Neuronal Data.” Network: Computation in Neural Systems, 14, 5–15.

Kass RE, Wallstrom G (2002). “Invited Comment on “Spline Adaptation in Extended Linear Models” by Mark H. Hansen and Charles Kooperberg.” Statistical Science, 17, 24–29.

Kass RE, Wasserman LA (1995). “A Reference Bayesian Test for Nested Hypotheses and its Relationship to the Schwarz Criterion.” Journal of the American Statistical Association, 90, 928–934.

Liu JS, Wong WH, Kong A (1994). “Covariance Structure of the Gibbs Sampler with Applications to the Comparisons of Estimators and Augmentation Schemes.” Biometrika, 81, 27–40.

Pauler DK (1998). “The Schwarz Criterion and Related Methods for Normal Linear Models.” Biometrika, 85, 13–27.

R Development Core Team (2006). R : A Language and Environment for Statistical Computing.R Foundation for Statistical Computing, Vienna, Austria. ISBN 3-900051-07-0, URL http: //www.R-project.org/ .

Stone CJ, Hansen M, Kooperberg C, Truong YK (1997). “The Use of Polynomial Splines and their Tensor Products in Extended Linear Modeling.” The Annals of Statistics, 25, 1371–1470.

Venables WN, Ripley BD (2002). Modern Applied Statistics with S.4th edition. SpringerVerlag, New York.


[Page 21]

Wallstrom GL, Kass RE, Miller A, Cohn JF, Fox NA (2004). “Automatic Correction of Ocular Artifact in the EEG: A Comparison of Regression-Based and Component-Based Methods.” International Journal of Psychophysiology, 53, 105–119.

Zhang X, Roeder K, Wallstrom G, Devlin B (2003). “Integration of Association Statistics over Genomic Regions Using Bayesian Adaptive Regression Splines.” Human Genomics, 1, 20–29.

Garrick Wallstrom Department of Biomedical Informatics University of Pittsburgh Suite M-183 Parkvale Building Pittsburgh, PA, 15213-3305, United States of America E-mail: garrick@cbmi.pitt.edu

published by the American Statistical Association

Volume 26, Issue 1

http://www.amstat.org/

Accepted:
