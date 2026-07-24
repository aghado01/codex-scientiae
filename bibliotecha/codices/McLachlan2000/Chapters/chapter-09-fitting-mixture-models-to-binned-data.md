<a id="sec-fitting-mixture-models-to-binned-data"></a>

# Fitting Mixture Models to Binned Data

<a id="sec-9-1"></a>

# 9.1 INTRODUCTION

In this chapter we consider the fitting of finite mixture models to binned and truncated data by maximum likelihood via the EM algorithm. Binningcan occur systematically when a measurement instrument has finite resolution; for example, a digital camera with finite precision for pixel intensity: Binning may also occur intentionally when real-valued variables are quantized to simplify data collection. Truncation can also occur in data collection; whether due to fundamental limitations of the range of the measurement process or intentionally for other reasons .

McLachlan and Jones (1988) considered the of mixtures of univariate (log) normal components to binned and truncated data collected in the form of red blood cell (RBC) volume counts on cows exposed to the tick-borne parasite Anaplasma of mixtures of two skew Laplace components in the modeling of the masssize particle frequencies of soil samples in an attempt to determine their depositional environments; see also McLachlan (1992, Section 7.9) and McLachlan (1994). Further, the results of Jones and McLachlan (1991)on PTC sensitivity data as discussed in Section 3.6.2 were obtained from binned data. fitting fitting~ log

We present here a general solution to the problem of mixture density; fitting

$$
j ; \Psi ) = \sum _ { i = 1 } ^ { \infty } \pi _ { i } f _ { i } ( y _ { j } ; \theta _ { i } ) ,
$$

to binned and truncated data by maximum likelihood. The solution is then specialized to the case of bivariate normal mixtures, as considered by Cadez et al. (2000). Their work was motivated by an application in medical diagnosis (Cadez et al., 1999). For diagnostic evaluation of anemia andmonitoring the response to therapy; bloodsamples from patients are routinely analyzed to determine the volume of RBCs and the amount of hemoglobin; the oxygen-transporting protein of the red cell. Typically; each sample contains about 40,000 different RBCs. The volume and hemoglobin concentration of RBCs are measured by a cytometric blood cell counter. In addition, it produces a bivariate histogram on a 100 x 100 in volume and hemoglobin concentration (HC) space Figure 9.1 shows two-dimensional histogram of the RBC counts in V-HC space for a healthy individual (control) and for an iron-deficient patient. Each bin contains a count of the number of RBCs whose volume and hemoglobin concentration fall into that bin. It is known that the data can be truncated; that is, the range of machine measurement is less than the actual possible range of volume and hemoglobin concentration values. The results of Cadez et al. (1999) on the fitting of a bivariate normal mixture to these data are to be given in Section 9.6. We shall also illustrate how the of this normal mixture model leads to a classification procedure useful in the diagnosis of iron-deficient anemia. grid fitting

![image 27](mclachlan2000_images/imageFile27.png)

Iron Deficient #1

Control #1

Fig. 9.1 Two-dimensional V-HC histograms of the raw data RBC counts for acontrol subject and a subject with iron-deficient anemia. From Cadez et al. (1999)

<a id="sec-9-2"></a>

# 9.2 BINNED AND TRUNCATED DATA

We let Yí, density (9.1). Suppose that the sample space ) of Yj is partitioned into v mutually exclusive p-dimensional Yr (r 1, v) . We consider the case where (r = 1, v) is recorded, where < That is, individual observations are not recorded but only the regions ) in which they fall are recorded; further, even such observations are made only if the value of $Y_j$ falls in one of the regions Yr (r = 1, ") regions For given the observed data vector and where and

$$
n = \sum _ { r = 1 } ^ { v _ { o } } n _ { r } ,
$$

$$
= ( n _ { 1 } , \dots , n _ { r } ) ^ { T }
$$

has a multinomial distribution; consisting of n draws on v categories with probabilities Pr(")/P(v),r = 1,

$$
P _ { r } ( \Psi ) = \int _ { \mathcal { V } } \ f ( y _ { j } ; \Psi ) \, d y _ { j }
$$

$$
P ( \Psi ) = \sum _ { i } ^ { v _ { o } } F _ { i }
$$

Thus the likelihood for $\Psi$ that can be formed on the basis of a is given by log

$$
\log L ( \Psi ) = \sum _ { r = 1 } ^ { n _ { r } } n _ { r } \log \{ P _ { r } ( \Psi ) / P ( \Psi ) \} + C _ { 1 } ,
$$

$$
C _ { 1 } = \log \{ n ! / \prod _ { r = 1 } ^ { v _ { o } } n _ { r } ! \} .
$$

<a id="sec-9-3"></a>

# 9.3 APPLICATION OF EM ALGORITHM

<a id="sec-9-3-1"></a>

# 9.3.1 Missing Data

We can solve this problem within the EM framework by introducing the vectors

$$
u = ( n _ { v _ { o } + 1 } , \dots , n _ { v } ) ^ { T }
$$

$$
y _ { r + } = ( y _ { r 1 } ^ { T } , \dots , y _ { r , n _ { r } } ^ { T } ) ^ { T } \ \ ( r = 1 , \dots , v )
$$

as the missing data. The vector u contains the unobservable frequencies in the case of truncation (v < v), while contains the nr unobservable individual observations in the rth region Yr (r = 1, The conditional distribution of u given a is specified to be Ur+

$$
\Psi ) \} ^ { n } \prod _ { r = v _ { e } + 1 } ^ { v } \{ P _ { r } ( \Psi ) \} ^ { n _ { r } } ,
$$

where C2 is the normalizing constant

$$
C _ { 2 } = ( \sum _ { r = v _ { o } + 1 } ^ { v } n _ { r } + n - 1 ) ! / \{ ( n - 1 ) ! \prod _ { r = v _ { o } + 1 } ^ { v } n _ { r } ! \} .
$$

Conditional on @ and u, Urs (s = 1, nr), denote nr independent observations with r =1, u.

The EM machinery is then invoked by declaring

$$
( a ^ { T } ,
$$

as the complete-data vector The likelihood for this complete-data specification is, ignoring an additive combinatorial term not involving ", equal to log

$$
\log L _ { c } ( \Psi ) = \sum _ { r = 1 } ^ { v } \sum _ { s = 1 } ^ { n _ { r } } \log f ( y _ { r s } ; \Psi ) ,
$$

and it implies the (incomplete-data) log likelihood log

However; if we work with the complete-data vector specified by (9.7), then the M-step of the EM algorithm will still require an iterative procedure, since is a mixture density Consequently; for a mixture density; a further extension of the complete-data vector is needed to include the zero-one component-indicator variables in f($y_j$;

$$
z _ { r s } = ( z _ { 1 r s } , \dots , z _ { g r s } ) ^ { T } \ \ ( r = 1 , \dots , v ; \, s = 1 , \dots , n _ { r } ) ,
$$

where land with



for i = 1, 9. Note that $\tau_i(y_{rs} ; \Psi)$ is the conditional probability that the random variable Yr, with realization Ur, belongs to the ith component of the mixture given Ur ' This posterior probability is of course the same as if Yrs had been obtained by sampling from the entire sample space ) and not just the subspace Yr

With the inclusion of these component-indicator vectors in the complete-data specification; the complete-data likelihood becomes

$$
\log L _ { c } ( \Psi ) = \sum \sum \sum \sum z _ { i r } , \log \{ \pi _ { i } \, f _ { i } ( y _ { r _ { i } } ; \theta _ { i } ) \} .
$$

<a id="sec-9-3-2"></a>

# 9.3.2 E-Step

On the (k + 1)th iteration of the EM algorithm; the E-step the calcula likelihood, Lc("), given the observed data vector a of frequencies, using the current value requires log log

and finally u, it follows that Uu+

where

$$
n _ { r } ^ { ( k ) } \, = \, n _ { r }
$$

$$
( 9 . 1 1 )
$$

With the conditional distribution of u given @ specified by (9.6), it can be shown that

$$
\dots , v ) ; \quad ( 9 . 1 2 )
$$

see Dempster et al. (1977), McLachlan and Jones (1988), and McLachlan and Krishnan (1997, Section 2.8)

<a id="sec-9-3-3"></a>

# 9.3.3 M-Step

with respect to the mixing proportions that their updates are given by

$$
\pi _ { i } ^ { ( k + 1 ) } = \frac { \sum _ { r = 1 } ^ { v } n _ { r } ^ { ( k ) } \ E _ { Y _ { r } ( \{ \tau _ { i } ( Y _ { j } ; \Psi ^ { ( k ) } ) \ | \ Y _ { j } \in \mathcal { Y } _ { r } \} } } { \sum _ { r = 1 } ^ { v } n _ { r } ^ { ( k ) } }
$$

for i = 1, 9

If we let € denote the distinct elements of 01, to be distinct, then it follows that &(k+1) is root of the equation 'priori

$$
( 9 . 1 4 )
$$

that is, a root of

$$
\sum _ { i = 1 } ^ { j } \sum _ { r = 1 } ^ { n _ { r } ^ { ( k ) } } E _ { \varphi ^ { ( k ) } } \{ \tau _ { i } ( Y _ { j } ; \varPsi ^ { ( k ) } ) \, \partial \log f _ { i } ( Y _ { j } ; \theta _ { i } ) / \partial \xi \, | \, Y _ { j } \in y _ { r } \} = 0 ,
$$

on interchanging the operations of differentiation and expectation.

<a id="sec-9-3-4"></a>

# 9.3.4 M-Step for Normal Components

We now specialize the implementation of the M-step to the case of fitting a normal

$$
j ; \Psi ) = \sum _ { i = 1 } ^ { j } \pi _ { i } \phi ( y _ { j } ; \mu _ { i } , \Sigma _ { i } ) ,
$$

to binned and truncated data. This has been done in McLachlan and Jones (1988) for a univariate normal mixture; see also McLachlan and Krishnan (1997, Section 2.8) Using the multivariate analogue of their univariate results, it follows that on the (k + 1)th iteration of the EM algorithm; the estimates of the component means #; and the component-covariance matrices $Z_j$ are given by

and distribution of the complete-data vector given the observed data. However, because of the slow convergence of this Monte Carlo procedure for this problem; Cadez et al. (2000) concentrated on numerical multidimensional techniques using Romberg integration; see, for example, Thisted (1988) for details. note that an important aspect of Romberg integration is selection of the order of integration. Low-order schemes use relatively few function evaluations in the initialization phase, but may but converge faster Thus, order selection can substantially affect the computation time of numerical integration. They

$$
\mu _ { i } ^ { ( k + 1 ) } = \sum _ { r = 1 } n _ { r } ^ { ( k ) } E _ { \varphi ^ { ( k ) } } \{ \tau _ { i } ( Y _ { j } ; \varphi ^ { ( k ) } ) \, Y _ { j } \, | \, Y _ { j } \in y _ { r } \} / C _ { i } ( \varPsi ^ { ( k ) } )
$$

$$
= \frac { \sum _ { r = 1 } ^ { v } n _ { j } ^ { ( k ) } E _ { \Psi ^ { ( k ) } } \{ \tau _ { i } ( Y _ { j } ; \Psi ^ { ( k ) } ) \left ( Y _ { j } - \mu _ { i } ^ { ( k + 1 ) } \right ) ( Y _ { j } - \mu _ { i } ^ { ( k + 1 ) } ) ^ { T } \, | \, Y _ { j } \in y _ { r } \} } { C _ { i } ( \Psi ^ { ( k ) } ) } ,
$$

$$
( 9 . 1 8 )
$$

where

$$
( \Psi ^ { ( k ) } ) = \sum _ { r = 1 } n _ { r } ^ { ( k ) } \, E _ { \Psi ^ { ( k ) } } \{ \tau _ { i } ( Y _ { j } ; \Psi ^ { ( k ) } ) \ | \ Y _ { j } \in \mathcal { Y } _ { r } \} .
$$

In the univariate case (p = 1), McLachlan and Jones (1988) expressed the condi tional expectations in (9.17) and (9.18) in terms of the standard normal distribution and density. Jones and McLachlan (1990a) subsequently gave an algorithm (MGT) for implementing the EM algorithm in the univariate case.

As noted by Cadez et al. (2000), although the multivariate theory is a straightfor ward extension of the univariate case, the practical implementation of this theory is considerably more complex due to the fact that the calculation of the multidimensional integrals in the conditional expectations in (9.13), (9.17), and (9.18) are more complex than their univariate analogues.

<a id="sec-9-4"></a>

# 9.4 PRACTICAL IMPLEMENTATION OF EM ALGORITHM

<a id="sec-9-4-1"></a>

# 9.4.1 Computational Issues

From the previous section, it can be seen that each EM iteration requires the calculation of integrals that have to be performed numerically at least in the multivariate case. Naive implementation of the procedure can lead to computationally inefficient results. Cadez et al. (2000) have summarized some ofthedifficulties involvedin implementing the EM algorithm for multivariate mixtures. g0 on to propose a number of straightforward numerical techniques. They

<a id="sec-9-4-2"></a>

# 9.4.2 Numerical Integration at Each EM Iteration

One way to effect the E-step is to use a Monte Carlo E-step whereby the calculation of the Q-function is approximated by sampling from the (current) conditional

<a id="sec-9-4-3"></a>

# 9.4.3 Integration over Truncated Regions

For a mixture density that is defined on the whole space we must define bins to cover regions extending from boundaries to infinity In the one-dimensional case it suffices to define two additional bins: one extending from the upper endpoint of the last bin to 0, and the other extending from -% to the lower end of the first bin. As pointed out by Cadez et al. (2000), in the multivariate case it is more natural to define a single bin grid point

$$
, _ { , v } = y \wedge \sum _ { r = 1 } ^ { v _ { o } } y _ { r }
$$

that covers everything but the data than to explicitly describe the out-of-grid regions. The reason is that all expected values over the subspace\_ can be calculated without actually doing any integration. For example, the following integrals over the truncated regions can be calculated as grid

$$
\int _ { \mathcal { Y } _ { \sigma , v } } \phi ( w ; \mu _ { i } , \Sigma _ { i } ) \, d w = 1 - \sum _ { r = 1 } ^ { v _ { \sigma } } \int _ { \mathcal { Y } _ { r } } \phi ( w ; \mu _ { i } , \Sigma _ { i } ) \, d w ,
$$

$$
= \mu _ { i } - \sum _ { r = 1 } ^ { v _ { o } } \int _ { y _ { r } } w \, \phi ( w ; \mu _ { i } , \Sigma _ { i } ) \, d w ,
$$

$$
\int _ { y _ { \sigma , \nu } } ( w - \mu _ { i } ) ( w - \mu _ { i } ) ^ { 1 } \ \phi ( w ; \mu _ { i } , \ \Sigma _ { i } ) \, d w \\ = \ \Sigma _ { i } - \sum _ { r = 1 } ^ { v _ { \sigma } } \int _ { y _ { r } } ( w - \mu _ { i } ) ( w - \mu _ { i } ) ^ { T } \ \phi ( w ; \mu _ { i } , \ \Sigma _ { i } ) \, d w .
$$

No extra work is required to obtain the integrals on the right-handside of equations (9.20) to (9.22), since these integrals are effectively required in the calculation of the conditional expectation terms in the EM equations (9.13) and (9.17) to (9.19).

For efficiency, Cadez et al. (2000) take advantage of the sparseness of the bin counts optimize the time spent on integrating over the (numerous) empty bins that do not significantly contribute to the integral or the accuracy of the integration. They With this in mind, use the standard (computationally cheap) EM algorithm on a random sample of the data to provide a starting for the more computationally complex binned/truncated version of EM. They take a subset of points within bin, randomize their coordinates around the bin centers (they use the uniform distribution within each bin), and treat the newly obtained data as nonbinned and nontruncated. The standard EM algorithm is relatively fast, as a closed form solution exists for each EM step (without any integration). Once the standard algorithm converges to a solution in the parameter space; use these parameters as initial starting points for the full algorithm (for binned, truncated data) which then refines these guesses to a final solution; typically taking just a few iterations. Note that this initialization scheme cannot affect the accuracy of the results; as the full algorithm is used as the final criterion for convergence. they good point each they

<a id="sec-9-4-4"></a>

# 9.4.4 EM Algorithm for Binned Multivariate Data

The algorithm developed by Cadez et al. (2000) for mixture models to multi variate binned, truncated data consists of the following stages: fitting

Draw a small number of data points from the multivariate histogram; adding some counts to all the bins to prevent occurrences of empty bins.

Fit the mixture model using the standard EM algorithm (that is,fit the mixture model to the nonbinned, nontruncated data).

Use the parameter estimates from the standard mixture analysis to refine them with the EM algorithm applied to the binned and truncated data. This consists of iteratively applying the EM equations (9.13) and (9.17) to (9.19) untilconvergence as measured by thechange in the likelihood defined by (9.3). log

<a id="sec-9-5"></a>

# 9.5 SIMULATIONS

Cadez et al. (2000) performed some simulation experiments to observe the effect of the number of bins v and the sample size n on the estimate $\hat{\Psi}$\hat{\Psi}$ of the parameter vector $ in a two-component bivariate normal mixture. The component-covariance matrices were set equal to the identity matrix, and the means were specified to be The range of the extended from (~5, ~5) to (5,5) so that truncation was relatively rare. The sample size was varied in steps of 10 from n = 10to n = 1,000, while the number of bins per dimension was varied in steps of 5 from b=5 tob = 100so that the original unbinned samples were quantized into v = 62 bins. Ten random samples were generated for each combination of v and n. grid

To measure the quality of the solution, Cadez et al. (2000)calculated the Kullback \_ Leibler (KL) distance between each estimated density and the true known density They calculated the average KL distance over the 10samples foreach value of n and b, for both the binned and the standard EM algorithms. In total, each of the standard and binned algorithms were run 20,000 different times to generate the reported results.

![image 28](mclachlan2000_images/imageFile28.png)

Fig. 9.2 Average KL distance scale) between the estimated densities and the true density as a function of the number of bins for different sample sizes n compared to the standard EM on the unbinned data. From Cadez et al. (2000) (log

<a id="sec-9-6"></a>

# 9.6 EXAMPLE 9.1: RED BLOOD CELL DATA

tivated by areal-world application in medical diagnosis based on two-dimensional his tograms characterizing RBC and hemoglobin measurements (Figure 9.1) McLaren

(1996) has summarized work on this problem; see also McLaren et al. (2000) Mixture models are particularly useful in this context as a model since it is plausible that different components in the model correspond to blood cells in different states. Cadez et al. (1999) generalized theearlier work of McLaren et al. (1991)and McLaren (1996) on one-dimensional volume data to the analysis of two-dimensional volume hemoglobin histograms. Mixture densities were fitted to histograms from 97 control subjects and 83 subjects with iron deficient anemia, using the binned/truncated EM procedure described in Section 9.3. prior

Figure 9.3 shows contour probability plots of fitted two-component bivariate mix ture densities for three control and three iron-deficient subjects, where only the lower 109 of the density is displayed (since the differences between the two populations are more obvious in the tails). One can clearly see systematic variability within the number of bins is relatively large (6 = 100 in each dimension), as is the number of data points (n = 40, 000),the simulation results from the previous section would tend to suggest that these density estimates are likely to be relatively accurate (compared to running the EM algorithm on unbinned data)

![image 29](mclachlan2000_images/imageFile29.png)

Contour plots from estimated density estimates for three typical Control patients and three typical iron-deficient anemia patients . The lowest 109 of the probability contours are plotted to emphasize the systematic difference between the two groups. From Cadez et al. (1999)

Cadez et al. (1999) investigated how the fitted densities for each of the control and iron-deficient subjects could be used to form a discriminant rule for the diagnosis of a new subject. One approach is to take the fitted parameter vector û, or elements of it, as the feature vector for the formation of a discriminant rule. In the case where 4 contains the parameters of a two-component bivariate normal mixture, the feature vector would consist of eleven elements; corresponding to Â1, the two elements in considered a number of models for the group-conditional distribution of this eleven dimensional feature vector, including a two-component normal mixture model. The cross-validated error rate of this rule was found to be 1.59. This compares with a rate of about 49 on the same subjects algorithms such as CART (Breiman et al. , 1984) or C4.5 (Quinlan; 1993) directly on features from the histogram, such as univariate means and standard deviations (that is, no mixture modeling) Thus; the ability to fit mixture densities to binned and truncated data can play a significant role in improved classification performance for this particular problem. using using



