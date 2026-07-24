<a id="sec-bayesian-approach-to-mixture-analysis"></a>

# Bayesian Approach to Mixture Analysis

<a id="sec-4-1"></a>

# 4.1 INTRODUCTION

We have seen that estimation for mixture models is straightforward using the EM algorithm. Estimation in a Bayesian framework is now feasible posterior simulation via recently developed Markov chain Monte Carlo (MCMC) methods. Bayes estimators for mixture models are well defined so as the prior distributions are proper. However; it has only been with the development of MCMC methods, as proposed by Tanner and Wong (1987) and Gelfand and Smith (1990), that the implementation of the Bayesian approach for mixtures has been made practical. a perspective on MCMC methods; the reader is referred to Tierney (1994) and to the books by Gilks, Richardson, and Spiegelhalter ( 1996) and Robert and Casella (1999) as well as to the references therein. using long For

Among the first papers on Bayesian estimation for mixture models via posterior simulation are those by Gilks, Oldfield, and Rutherford (1989), Diebolt and Robert (1990, 1994), Gelman and (1990), Verdinelli and Wasserman (1991) Evans, Guttman, and Olkin (1992), and Lavine and West (1992). It can be seen that it took almost 100 years from Pearson's (1894) classic mixtures paper for a truly Bayesian solution to the mixture problem to emerge. An account of approximation techniques for Bayesian mixture analysis before the use of MCMC methods may be found in Titterington et al. (1985, Chapter 6). initial papers on the Bayesian analysis of mixtures following MCMC methods include Diebolt and Robert (1990, 1994) and Escobar and West (1995). Also; the mixture problemis treated in the review ofMCMC methods by Smith and Roberts (1993). Further advances are covered in West, Müller, and Escobar (1994), Carlin and Chib (1995), Cao and West (1996), Mengersen and King Key Robert (1996), Phillips and Smith (1996), Raftery (1996), Robert (1996), Bensmail et al. (1997), Richardson and Green (1997), Roeder and Wasserman (1997), Robert and Mengersen (1999), and Yu and Tanner (1999). Additional applications of Bayesian mixture estimation via posterior simulation are given in Gelman et al. (1995,Chapter 16) and the references therein: Other recent case studies invol the Bayesian analysis of mixture distributions include those by Dellaportas (1998) and Vounatsou; Smith, and Smith (1998). Iving A further hindrance is the effect of label switching, which arises when there is no real information that allows one to discriminate between the components of Since the likelihood is modes. Hence the posterior also will have this property for a prior distribution that is symmetric in the components. A label switching occurs when some of the labels of the mixture components permute. The effect of label switching is very important when the solution is calculated iteratively and there is the possibility that the labels of the components may be switched on different iterations. This switching of component labels is not a problem in the normal course of events in the iterative computation ofthe MLE viathe EM algorithm; but it is aserious issue in the simulation of (approximate) realizations of the parameter vector $ from its posterior distribution. prior being Provided that suitable (conjugate) priors are used, the posterior density will be proper; thereby allowing the application of MCMC methods such as the Gibbs sam pler to provide an accurate approximation to the Bayes solution. Although the application of MCMC methods is now routine, there are some difficulties that have to be addressed with the Bayesian approach in the context of mixture models. One main hindrance is that improper priors yield improper posterior distributions. An alternative is to use a 'partially proper By this it is meant a that does not require subjective input for the component parameters; yet the posterior is proper (Roeder and Wasserman, 1997). Another hindrance is that when the number of components 9 is unknown, the parameter space is simultaneously ill-defined and of infinite diapproach therefore is to fit the mixture model for fixed g and then to consider the choice of g according to some so-called information criterion that typically penalizes the likelihood for the complexity of the adopted model, possibly adjusted for the sample size. Recently; Phillips and Smith (1996) and Richardson and Green (1997) presented a fully Bayesian approach with g taken to be an unknown parameter. Their MCMC methods allow jumps to be made for variable dimension parameters and thus can handle g being unspecified. prior: prior log In this chapter we shall briefly review the main approaches to Bayesian mixture analysis and discuss some of the methods that have been proposed for overcoming the aforementioned difficulties. We shall first start with the case of aproper prior distribution before considering some extensions that have been proposed for noninformative settings.

<a id="sec-4-2"></a>

# 4.2 ESTIMATION FOR PROPER PRIORS

We consider here the case of a proper density p(v) for the parameter vector $\Psi$. In the sequel, we shall use p(:) as a generic notation for a density function: We can write the posterior density of % as prior

$$
\begin{array} { r c l } p ( \Psi | y ) & = & C ^ { - 1 } L ( \Psi ) p ( \Psi ) \\ & = & C ^ { - 1 } \sum L _ { c } ( \Psi ) p ( z | \Psi ) p ( \Psi ) , \end{array}
$$

where p(z The normalizing constant C in (4.1) is given by

$$
C = \int \sum L _ { c } ( \Psi ) p ( z \, | \, \Psi ) p ( \Psi ) \, d \Psi .
$$

Asin the previous chapters; Lc(') denotes the complete-datalog likelihood formed on vT)T and also their component-indicator vectors given by 2 = (\_ In (4.1), the sum is over all possible values of 2 defining the component membership of V; (j = 1, n)

This approach may be viewed as hierarchical with, on top, the parameters in 4 for the mixture, then the unobservable component-indicator vectors in 2, whose distribution depends on 4 and, at the bottom, the observed data y whose distribution depends on z and %.

If a conjugate is specified, then the posterior expectation of € can be written in closed form\_ However, its direct use is only feasible with small sample sizes. We general exponential family. prior

<a id="sec-4-3"></a>

# 4.3 CONJUGATE PRIORS

We assume now with little loss of generality that the component densities 0;) $f(y_j$; 0); where f;($y_j$;

$$
^ { T } _ { i } y _ { j } - b ( \theta _ { i } ) + c ( y _ { j } ) \} .
$$

This family allows a conjugate for 0;, which is taken to be distinct for each component i (that is, if the component-indicator zi3 = 1), having the form prior

$$
p ( \theta _ { i } ; \omega _ { i } , \gamma _ { i } ) \circ \exp \{ \theta _ { i } ^ { T } \omega _ { i } - \gamma _ { i } b ( \theta _ { i } ) \} ,
$$

where w; is areal-valued vectorofconstants and Y isascalarconstant (i = 1, 9) A conjugate for the vector T = (71, T,)T of mixing proportions is the Dirichlet distribution D(œ1, ag), which has density prior



For this for €, the posterior density p(" u) is proportional to prior

$$
p ( \Psi \, | \, y ) \, \alpha \sum _ { \tilde { z } } p _ { D } ( \alpha _ { 1 } + n _ { 1 } , \, \dots , \, \alpha _ { g } + n _ { g } ) \prod _ { i = 1 } ^ { g } \{ p ( \theta _ { i } ; \, \omega _ { i } + n _ { i } \bar { y } _ { i }
$$

where n; = While the posterior expectation of $ can be wriiten in closed form from (4.6), the time required to calculate (4.6) is far too high for the Bayesian approach to be applied in practice, even for moderate sample sizes.

In the special case where only the mixing proportions are unknown; sequential approximations have been provided by Smith and Makov (1978) and Bernardo and Girón (1988).

<a id="sec-4-4"></a>

# 4.4 MARKOV CHAIN MONTE CARLO

<a id="sec-4-4-1"></a>

# 4.4.1 Posterior Simulation

We can approximate posterior quantities of interest through the use of MCMC methods. Such methods allow the construction of an ergodic Markov chain with stationary distribution equal to the posterior distribution of the parameter of interest, here containing the parameters in the mixture model. Gibbs sampling achieves this by simulating directly from the conditional distribution of a subvector of € given all the other parameters in " (and the observed data v) . This conditional is called the complete conditional. We then through all the parameters iteratively; each time drawing from each parameter's complete conditional, until we N draws, from the Markov chain. After a sufficiently burn-in of, say, N) will be dependent draws approximately from the posterior distribution of %. In practice; consideration has to be given to the choice of suitable starting values for €, and choice of values for N1 and N that are sufficiently large to ensure the consequent approximation is accurate. Reviews of convergence diagnostics have been given by Cowles and Carlin (1996) Brooks ( 1998), Brooks and Roberts (1998),and Mengersen, Robert, and GuihenneucJouyaux (1999); see also Robert (1998). Among other sampling methods, there is the Metropolis-Hastings algorithm; which, in contrast to the Gibbs sampler; simulates from a convenient proposal distribution and then accepts the proposed value with some defined probability. cycle have long

In the implementation of MCMC methods for mixture models, the unobservable component-indicator vector z is introducedand €is augmented by 2 during the Gibbs sampling. Thus samples for the missing-data vector z and the parameter vector are alternately generated, producing a missing-data chain and parameter chain. The of Diebolt and Robert (1994) of the convergence of the algorithm to the true posterior distribution of the parameter $\Psi$ is based on duality principle. The finite-state structure of the missing-data chain allows many convergence results to be proof easily established for it and transferred automatically to the parameter chain. They a central limit theorem; see Robert (1996). Diebolt and Robert (1994) established theirresults in the context of univariate normalcomponent densities; and Bensmail et al. (1997)subsequently confirmed their applicability for multivariate normal component densities. The validity of the central limit theorem for MCMC algorithms is now well documented; see Meyn and Tweedie (1993) and Roberts and Rosenthal (1998)

average,

$$
E \{ a ( \Psi ) \, | \, y \} \approx \sum _ { k = N _ { 1 } + 1 } ^ { N } \frac { a ( \Psi ^ { ( k ) } ) } { ( N - N _ { 1 } ) } ,
$$

where the first N1 burn-in samples have been discarded in forming (4.7). This provides estimate of a(v): A 95% interval estimate for a(w) is obtained by ordering the sample values a(œ(\*)) for k = N1 + 1, N and finding the 0.025 and 0.975 sample quantiles. point

<a id="sec-4-4-2"></a>

# 4.4.2 Perfect Sampling

and Wilson (1996) showedthat itis possibleto use aMCMCsampler to simulate exactly from the distribution of interest by the technique of coupling from the past Hobert, Robert, and Titterington (1999) have examined this approach for two- and three-component mixture models with known components. Casella et al. (2000) have proposed a perfect sampler for mixtures of distributions; in the spirit of Mira and Roberts (1999), building on the paper of Hobert et al. (1999); see also Casella; Robert, and Wells (1999). Their results apply to an arbitrary number of continuous components where their parameters andthe mixing proportions need not be specified. Thus the authors claim that their method is the first general iid. sampling method for mixture posterior distributions. Propp=

<a id="sec-4-5"></a>

# 4.5 EXPONENTIAL FAMILY COMPONENTS

We now describe the steps to effect posterior simulation by the Gibbs sampler in the case of the conjugate priors (4.4) and (4.5) for component densities belonging to a general exponential family.

Step 1. Simulate

and



$$
n _ { i } ) \ \ ( i = 1 , \dots , g ) . \quad ( 4 . 9 )
$$

$$
Z _ { j } \sim \text {Mult} _ { g } ( 1 , \tau _ { j } ) \ \ ( j = 1 , \dots , n ) ,
$$

multinomial distribution consisting of one draw on 9 categories with probabilities

$$
\tau _ { j } = ( \tau _ { 1 } ( y _ { j } ; \Psi ) , \dots , \tau _ { g } ( y _ { j } ; \Psi ) ) ^ { T } ,
$$

$$
/ \sum _ { h = 1 } \pi _ { h } \, f
$$

The Gibbs sampler is run by simulating successively from the distributionsin (4.8) to (4.10) and replacing the conditioning parameters. Robert (1996) reported that in his posterior simulations for univariate and bivariate mixture models; 5,00O iterations were "enough' in the sense that a substantial increase in the number of iterations did not usually perturb values of ergodic averages.

<a id="sec-4-6"></a>

# 4.6 NORMAL COMPONENTS

<a id="sec-4-6-1"></a>

# 4.6.1 Conjugate Priors

Conjugate priors for normal densities have been considered by Diebolt and Robert (1994) and Bensmail et al. (1997). are given by They

$$
\pi \sim D ( \alpha _ { 1 } , \dots , \alpha _ { g } ) ,
$$

and Step 2. Simulate where Step 3. Update n; and 7; (i = 1, 9)

$$
\slash \kappa _ { i } ) \ \ ( i = 1 , \dots , g ) ,
$$

$$
, \, C _ { i } ) \ \ ( i = 1 , \dots , g ) ,
$$

$$
\frac { | \mathcal { U } | ^ { 2 ^ { ( 2 ^ { \prime } - 1 ) } \exp \{ - \frac { 1 } { 2 } \text {tr} ( \mathcal { C } ^ { - 1 } ) \} } } { 2 ^ { \frac { 1 } { 2 } r p } \pi ^ { p ( p - 1 ) / 4 } \, | \, C \, | ^ { \frac { 1 } { 2 } r } \prod _ { v = 1 } ^ { p } \Gamma ( \frac { 1 } { 2 } ( r + 1 - v ) ) } .
$$

The gamma (œ, ß) distribution has density

$$
( 4 . 1 6 )
$$

<a id="sec-4-6-2"></a>

# 4.6.2 Gibbs Sampler

The Gibbs sampler is implemented by simulating from the following conditional distributions:

<a id="sec-1"></a>

**1. Simulate Step**

where

$$
\pi \ \sim \ \mathcal { D } ( \alpha _ { 1 } + n _ { 1 } , \dots , \alpha _ { g } + n _ { g } ) , \\
$$

$$
( 4 , 1 8 )
$$

$$
^ { 1 } \ \sim \ W ( n _ { i } + r _ { i } , C _ { i } ^ { * } ) ,
$$

$$
\omega _ { i } ^ { * } = ( n _ { i } \bar { y } _ { i } + \kappa _ { i } \omega _ { i } ) / ( n _ { i } + \kappa _ { i } ) ,
$$

and

$$
C _ { i } ^ { * } = \{ C _ { i } ^ { - 1 } + n _ { i } V _ { i } + \frac { n _ { i } r _ { i } } { n _ { i } + r _ { i } } ( \overline { y } _ { i } - \omega _ { i } ) ( \overline { y } _ { i } - \omega _ { i } ) ^ { T } \} ^ { - }
$$

$$
V _ { i } = \sum _ { j = 1 } ^ { n } z _ { i j } ( y _ { j } - \bar { y } _ { i } ) ( y _ { j } - \bar { y } _ { i } ) ^ { T } / n _ { i } .
$$

Step 2 Simulate

where

$$
Z _ { j } \sim M u l t _ { g } ( 1 , \tau _ { j } ) ,
$$

$$
\tau _ { j } = ( \tau _ { 1 } ( y _ { j } ; \Psi ) , \dots , \tau _ { g } ( y _ { j } ; \Psi ) ) ^ { T } .
$$

$$
S t e p \, 3 . \ U p d a t e \, n _ { i } , \bar { y } _ { i } , \text { and } V _ { i } \left ( i = 1 , \dots , g \right ) .
$$

In the above, the component-covariance matrices are unrestricted . Bensmail et al. (1997) give the conjugate and the corresponding conditional distributions for implementing the Gibbs sampler under the reduced models in Section 3.12 for the component-covariance matrices. priors

The approach of Bensmail et al. (1997)in choosing their conjugate priors is to have them fairly flat in the region where the likelihood is substantial and not much greater elsewhere. This is to ensure that the Bayesian estimates are relatively insensitive to reasonable changes in the This was confirmed empirically by Bensmail et al. (1997) in their examples in which took prior. they

$$
= 5 , \, C _ { i } ^ { - 1 } = V _ { i } \ \ ( i = 1 , \dots , g ) .
$$

noted that the amount of information in this is similar to that contained in a typical single observation. They prior

<a id="sec-4-7"></a>

# 4.7 PRIOR ON NUMBER OF COMPONENTS

In the Bayesian work considered up to now; the approach has been to sample from consideration. With the approach of Phillips and Smith (1996) and Richardson and Green (1997), the number of components g is treated as an unknown parameter with a truncated at the origin, namely; prior

$$
p ( g ) = \lambda ^ { g } / \{ ( \exp ( \lambda ) - 1 ) g ! \} , \ \ g = 1 , 2 , \dots .
$$

Richardson and Green (1997) suggested also the use of a Poisson for g but, for convenience of presentation and interpretation, took a prior uniform distribution between and some prespecified integer gu prior

the component parameters and mixing proportions. Inference is then undcrtaken by simulating realizations from the resulting posterior distribution. The methodology developed by Grenader and Miller (1994) is 'exploited to enable discrete transitions or jumps to be made between the mixture models with different number of components 9. Phillips and Smith (1996) use an iterative jump-diffusion sampling algorithm; while Richardson and Green (1997) use a reversible-jump Metropolis-Hastings algorithm (Green, 1994 and 1995). The process to split or combine components is rather complicated and the reader is referred to their papers for the details. ing

Phillips and Smith (1996) and Richardson and Green (1997) implemented their respective methods for mixtures of univariate normal densities with means unrestricted variances 0?Within a model for fixed g, simulated approximation to the posterior distribution is carried out as in the posterior simulations described in the previous sections of this chapter. The priors of Richardson and Green (1997) for the pi, and 0? are all drawn independently with the Dirichlet prior T;,

$$
\mu _ { i } \sim N ( \omega , \kappa ^ { 2 } ) ,
$$

$$
\mu _ { i } \sim N ( \omega , \kappa ^ { 2 } ) , \\ \sigma _ { i } ^ { - 2 } \sim \text {gamma} ( \beta _ { 1 } , \beta _ { 2 } ) .
$$

distribution is taken to be flat over an interval of variation of the data, for example, by setting w to be the midpoint of this interval and setting k? equal to a small multiple of where Ris the length of the interval. R? ,

which are taken to be gamma(ß1, ß2), Richardson and Green (1997) introduced an additional hierarchical level by allowing ß2 to follow a gamma (a, b) distribution. In their hierarchical model, Richardson and Green (1997) noted there was substantial change in the posterior distributionof g as the prior mean ofthe precisiono; Hence in the standard model with fixed ß1 and ß2, the values of the latter willcrucially influence the posterior distributionof g, and so it is difficult to be weakly informative, Richardson and Green (1997) showed that with their hierarchical model with fixed P1, but random ß2 that allows weak information to be put in at a higher level, the posterior distribution of g is not so affected. presented some results to support their choice of an hierarchical model with ß1 = 2,0 = 0.2,and b = 100(/ß1)/ R? , as their default option. They In more recent work on reversible jump techniques in the case of an unknown number of components 9, Gruet, Philippe, and Robert (1999) have implemented a reversible jump MCMC technique for exponential mixture estimation. On extensions versible jump MCMC techniques can be used in the case of a normal hidden Markov chain model, which will be considered in Chapter 13.

Phillips and Smith (1996) adopted priors similar to those in Richardson and Green (1997), with the mixing proportions following a Dirichlet distribution with all parameters a; set equalto one,that is,auniform prior over the region T1+T2+ =1 also used normal-inverse gamma priors for the means #; and variances 0 as in Richardson and Green (1997), but with all the parameters in the distributions of these parameters fixed; that is, there were no unspecified hyperparameters. They prior

<a id="sec-4-8"></a>

# 4.8 NONINFORMATIVE SETTINGS

With the specification of the proper (conjugate) priors in the above; the intent is not to use strong prior information on the mixture parameters. For example, Richardson and Green (1997) use weakly informative priors, which may or may not be data-dependent, a line taken by Raftery (1996) and Noble (1994). We shall show that it is not possible to have fully noninformative priors and obtain proper posterior distributions. This is because there is always the possibility that no observations will be allocated to one or more components; and so the data are uninformative about them: Thus standard choices of improper noninformative priors cannot be used.

We shalldiscuss some attempts to circumvent this problem through partially proper distributions . prior

<a id="sec-4-8-1"></a>

# 4.8.1 Improper Priors

If an improper prior is adopted for the component parameters then the posterior distribution will be improper. To see this, consider a mixture of g = 2 univariate and 0?. Then the term in the sum of the numerator of (4.1) with $z_j$ = (1, O)T for all Hence if an improper prior is adopted, then the integral of this term in the denominator of (4.1) will diverge.

To look at this more closely; we assume further, as in Wasserman (1999), that T1 = T2 = =0, so that the only unknown parameter is

$$
L ( \Psi ) = \bigsqcup _ { \Psi }
$$

L(v) is given by is a partially proper in the sense that the marginal distribution of each p; is flat, but the conditional distribution of p;, given the other /h 's, is proper. The former property avoids having to specify subjective prior information on the location. Roeder and Wasserman (1997) construct a partially proper for the component standard deviations by introducing a common scale parameter ß. Conditional on ß, the joint prior is a product of scaled inverse chi-squared distributions with common scale parameter ß and n degrees of frecdom. The for ß is chosen to be the usual reference for a scale parameter. call this a partially proper prior; because prior prior prior prior They

$$
( 4 . 2 0 )
$$

To see the impropriety of the posterior for a flat 'p(v), we note that prior

$$
\begin{array} { r l } { d \Psi } & { = } & { \int \prod _ { j = 1 } ^ { n } \{ 0 . 5 \phi ( y _ { j } ; 0 , 1 ) + 0 . 5 \phi ( y _ { j } ; \mu _ { 2 } , 1 ) \} p ( \Psi ) d \Psi } \\ & { \geq } & { \prod _ { j = 1 } ^ { n } \{ 0 . 5 \phi ( y _ { j } ; 0 , 1 ) \} \int p ( \Psi ) \, d \Psi } \\ & { = } & { \infty . } \end{array}
$$

Wasserman (1999) also showed that the posterior distribution is improper here for the Jeffreys (1961) for which prior

$$
p ( \Psi ) \ = \ \{ \mathcal { I } ( \Psi ) \} ^ { 1 / 2 } \\ \quad & \ \{ E ( 2 ) _ { 1 } - E ( V _ { 2 } + E ( V _ { 1 } ) ) \} ^ { 2 } \\
$$

<a id="sec-4-8-2"></a>

# 4.8.2 Data-Dependent Priors

One approach to avoidingimproper posterior distributionsin mixture models as above is to adopt a subjective However, as argued by Wasserman (1999), there are good reasons to favor partially proper priors. Firstly; it provides an objective method ofchoosing noninformative priors. Secondly; this approach may be viewed as aconvenient way of valid frequentist inference. Thirdly; as established by Wasserman (1999), the only that produce intervals with second-ordcr correct coverage are data-dependent. prior: doing priors

Concerning the specification of partially proper priors, the approach used by the likelihood corresponding to the troublesome assignment that assigns all the ob-

Diebolt and Robert (1994) is to adopt conjugate priors and then to discard part of servations to one component.

Wasserman (1999) shows that the ad hoc fix used by Diebolt and Robert (1994) that directly modifies the posterior to force propriety has a formal justification as a data-dependent prior; The idea is to follow Diebolt and Robert (1994) and simply throw away the part of the likelihood corresponding to the troublesome allocations. Wasserman (1999) begins with the Jeffreys (1961) prior; whereas Diebolt and Robert (1994) begin with a conjugate prior.

<a id="sec-4-8-3"></a>

# 4.8.3 Markov Prior on Component Means

For the univariate normal mixture model, Roeder and Wasserman (1997) adopt a partially proper that imposes a Markov on the component means. This prior prior

<a id="sec-4-8-4"></a>

# 4.8.4 Reparameterization for Univariate Normal Components

A partially proper prior can be obtained through reparameterization of a global location-scale parameter. It was first proposed by Robert and Mengersen (1995) in the case of a mixture of g = 2 univariate normal densities,

$$
( 4 . 2 2 )
$$

Under their proposed reparameterization; the component means and variances; J; and

$$
\begin{array} { r l r } { \mu _ { 1 } } & = } & { \omega _ { 1 } , } \\ { \mu _ { 2 } } & = } & { \omega _ { 1 } + \kappa _ { 1 } \omega _ { 2 } , } \\ { \mu _ { 2 } } & = } & { 1 } \end{array}
$$

For identifiability purposes, the global location-scale parameter corresponds to the first component and K2 < 1. Their prior does make it difficult to handle cases where the two normal components have the same variance. On the other hand, the component normals have the same means. prior

Robert and Mengersen (1995) showed how it could be extended to an arbitrary number of components for estimation purposes. Starting with the two-component normal model, the second component is replaced by a two-component mixture

$$
q _ { 2 } \phi ( y _ { j } ; \mu _ { 2 } , \sigma _ { 2 } ^ { 2 } ) + ( 1 - q _ { 2 } ) \phi ( y _ { j } ; \mu _ { 2 } + \sigma _ { 2 } \omega _ { 3 } , \sigma _ { 2 } ^ { 2 } \kappa _ { 3 } ^ { 2 } ) .
$$

This leads to the three-component mixture,

where result.

$$
j ; \Psi ) = \sum _ { i = 1 } ^ { j } \pi _ { i } \phi ( y _ { j } ; \mu _ { i } , \sigma _ { i } ^ { 2 } ) ,
$$

$$
\pi _ { 2 } \ = \ ( 1 - q _ { 1 } ) q _ { 2 } \\ \pi _ { 3 } \ = \ ( 1 - q _ { 1 } ) ( 1 - q _ { 2 } ) , \\ \mu _ { 1 } \ = \ \omega _ { 1 } \\ \mu _ { 2 } \ = \ \omega _ { 1 } + \kappa _ { 1 } \omega _ { 2 } , \\ \mu _ { 3 } \ = \ \omega _ { 1 } + \kappa _ { 1 } \omega _ { 2 } + \kappa _ { 1 } \kappa _ { 2 } \omega _ { 3 } , \\ \sigma _ { 1 } \ = \ \kappa _ { 1 } ^ { 2 } \ \iota \\ \sigma _ { 2 } \ = \ \kappa _ { 1 } ^ { 2 } \kappa _ { 2 } ^ { 2 } \\ \sigma _ { 3 } \ = \ \kappa _ { 1 } ^ { 2 } \kappa _ { 2 } \kappa _ { 3 } . \\ 
$$

This reparameterization can be extended in an obvious way from (4.24) to the case of a g-component normal mixture model for arbitrary g

As shown in Robert and Mengersen (1995), the link between the different components created by the reparameterization dispenses with a proper prior for the #; and the 0? and allows for the following E distribution: using prior

$$
, g ) ,
$$

Robert and Mengersen (1999) claimed that a direct Gibbs sampling implementation is not possible for the estimates; because of the presence of the scale factors Kl, K2, Kg-1 in the means of the components. Robert and Mengersen (1999) consequently used a hybrid algorithm with the Gibbs sampler in conjunction with a more general setting of a hidden Markov model, implemented a full Gibbs algorithm for the simulation of the posterior distribution. noted that the Jacobian of the transformation from the w; and the K; (i = 1, 9) to the L; and the 0; is They

$$
\prod _ { i = 1 } ^ { g - 1 } \sigma _ { i } ^ { - 2 } .
$$

can be expressed as

$$
( \mu _ { i } - \mu _ { i - 1 } ) ^ { 2 } / ( \zeta ^ { 2 } \sigma _ { i - 1 } ^ { 2 } ) \}
$$

where

$$
p ( \xi ) \, \prod ^ { n _ { i } } \pi _ { i } ^ { n _ { i } } \sigma _ { i } ^ { - n _ { i } } \prod ^ { n _ { i } } \exp \{ - \frac { 1 } { 2 } [ n _ { i } ( \bar { y } _ { i } - \mu _ { i } ) ^ { 2 } + n _ { i } v _ { i } ^ { 2 } ] / \sigma _ { i } ^ { 2 } \} ,
$$

$$
i = 1 \quad i = 1
$$

$$
v _ { i } ^ { 2 } = \sum _ { j = 1 } ^ { n } z _ { i j } ( y _ { j } - \bar { y } _ { i } ) ^ { 2 } / n _ { i } \ \ ( i = 1 , \dots , g ) .
$$

Robert and Titterington (1998) give the full conditional distributions that can be obtained from (4.25) for implementing the Gibbs sampler.

<a id="sec-4-9"></a>

# 4.9 LABEL SWITCHING

As mentioned in Section the so-called label-switchingproblemis an issue that has to be addressed in posterior simulations for mixtures with components belonging to the same parametric family. If the distribution is symmetric in the components of the mixture, then the posterior distribution will be invariant under a permutation of the component labels. This lack of identifiability of € due to the interchanging of component labels is generally handled by a constraint on the mixing proportions of the form 4.1, prior

$$
( 4 . 2 6 )
$$

or in the case of univariate component densities; say, normal, by the constraint

$$
\mu _ { 1 } \leq \mu _ { 2 } \leq \dots \leq \mu _ { g }
$$

on the component means, or a similar one on the component variances.

However, as recently stressed by Celeux, Hurn, and Robert (2000), this does not always work. Indeed, go so far to say that, "Although somewhat presumptuOuS , we consider that almost the entirety of Markov chain Monte Carlo samplers implemented for mixture models has failed to converge!" they

Suppose we are a mixture of g =2 components with both mixing proportions close to 0.5. Then if we simulate under the ordering restriction (4.27) on the mixing proportions (with a weak on the mixing proportions), we will get a biased sample of values for T1 and 72, since are "pushed apart" under this ordering restriction: Similarly; if their means are close together; and we carry out posterior simulation under the restriction p1 < H2 (under a weakly informative prior), we will get a biased sample for these means, as get "pushed apart" under the orderrestriction on them. With biased samples, ergodic averages will give misleading estimates . fitting prior they they ing

To further demonstrate this label switching we consider the illustration given by Richardson and Green (1997). They simulated a data set of n 250 from a mixture of g = 2univariate normal densities in equal proportions F1 = T2 = 0.5 with mcans #1 =0.0 and p2 = 1.0 and variances 0? =2.25 and Figures 4.1 and 4.2their results for the posteriordistribution ofthe mixture parameters obtained by simulation for 9 =2 components. Figure 4.1 gives the results obtained under an ordering of their means, while Figure 4.2 gives the corresponding results for an ordering of their variances. With the latter restriction, the simulated densities so obtained for the component means are bimodal, indicating that label switching took place on about half the runs. The estimated posterior densities under the ordering of the component means are much clearer, as are unimodal for all the parameters, although there is still some evidence of label switching. If there is no obvious choice of labeling in practice; Richardson and Green (1997) suggest post-processing of the posterior simulation runs according to different choices of labels to obtain the clearest picture of the component parameters. points they

Celeux (1999) recommends performing the simulations without any constraints on the parameters and then; at the end of the simulations, applying a clustering-like

![image 14](mclachlan2000_images/imageFile14.png)

- 2
- 3

Fig. 4.1 Posterior densities of parameter estimates labeled according to ordering of component means. From Richardson and Green (1997).

method to change where appropriate the component labels of the simulated values for $\Psi$. Stephens (1999) proposes a similar of handling the problem. way

West (1999) also recommends simulating without restrictions on the parameters, noting that in his experience, imposing an identifying ordering on parameters hinders convergence of the resulting MCMC on the constrained parameter space. He out that an additional gain by operatingtheMCMCon the unrestricted parameter space is an aid in assessing convergence of the simulation. As the posterior distribution of the parameters is symmetric in the component labels under a symmetric prior, points symmetry should be evident in the marginal distributions of the parameters. Thus the MCMC simulations on the unrestricted parameter space should exhibit switching effects, as parameter draws jump between the models representing the identification issue. However;, as warned by West (1999), convergence will be slow. One reason is that the sampler may be unable to leave the vicinity of one mode (or a subset of modes) to move to another mode (or subset of modes) of equal importance; because of its inability to step over of low probability. valleys

![image 15](mclachlan2000_images/imageFile15.png)

- 2
- 3

<a id="sec-4-10"></a>

# 4.10 PRIOR FEEDBACK APPROACH TO ML ESTIMATION

As discussed in Robert and Titterington (1998), several approaches have exploited Gibbs sampling to come up with new approximation techniques for ML estimation, thus circumventing the EM algorithm approach; see, for example; Geyer and Thompson (1992). The method considered by Robert and Titterington (1998) is based on a remark, recurrent in the literature (Pincus, 1968; Rubinstein, 1981; Aitkin; 1991), that the effect of the prior density fades away when the likelihood function is taken to a high enough power. As argue; when Bayesian posterior expectation is straightforward, it is reasonable to consider this alternative approach to the computation of the MLE (Robert, 1993; Robert and Soubiran, 1993). they

The feedback method is implemented by running the Gibbs sampler with an increasing number of replications of the original sample v until the Bayesian posterior expectations stabilize. More precisely; let y(r) denote the rth copy (replication) of y (r m) The Gibbs sampler is run on each copy; firstly gencrating the vector 2 of component-indicator variables and then proceeding conditionally on z(r) and generating the subvectors of €. prior

The theoretical justification of the feedback method is that the posterior density of € associated with m replications of the sample, prior

$$
( 4 . 2 8 )
$$

converges to a Dirac mass at the global maximizer of L(v), as m to infinity. The index size m can be interpreted as the temperature factor in simulated annealing. goes

As noted by Robert and Titterington (1998) for mixtures of normal components with unequal covariance matrices, the likelihood is unbounded. They therefore recommend choosing the prior so that the posterior density Pm(") is bounded. In this case, the posterior expectation should converge to the global maximizer of the likeli hood function within some truncated version of the support. However; note that due to multiple local maxima in the likelihood function, coupled with the difficulty of the Gibbs sampler in leaving the neighborhood of a strongly attractive mode, that the feedback estimate can converge to a local maximizer of the likelihood function. They demonstrate this for a hidden Markov chain: In Chapter 13 we report an example of Robert and Titterington (1998) in which the prior feedback method is applied to some data simulated from a hidden Markov chain. they prior

<a id="sec-4-11"></a>

# 4.11 VARIATIONAL APPROACH TO BAYESIAN ESTIMATION

Recently; Attias (1999a) described the variational framework for providing an approximation to the Bayesian solution. This approach approximates the full posterior distribution for the unknown parameter vector $\Psi$ and any hidden (latent) variables such as z in the case of the of mixture distributions. It draws together vari ational ideas from intractable hidden variables models (Saul, Jaakkola; and Jordan, 1996; Ghahramani and Jordan, 1997; Ghahramani and Beal, 2000) and from Bayesian fitting inference (Jaakkola and Jordan, 2000), which; in turn, draw on the work of Neal and Hinton (1998).

The variational approach considers lower bound on the integrated density; log ply), of the form log

$$
\log p ( y ) \geq \int \sum _ { \substack { q ( \Psi , \, z | \, y ) \log \frac { p ( y , \, z , \, \Psi ) } { q ( \Psi , \, z | \, y ) } d \Psi } } d \Psi
$$

for a given model, where q(4, z y) is any arbitrary density. It proceeds to optimize this lower bound over a restricted class of functions 9, noting that the solution in the unrestricted case is the posterior density; for which equality is achieved in (4.29) This approach restricts the class of allowed functions 9 to densities that imply " and z are conditionally independent given the observed data y and the model. The optimization of the variational posterior is carried out over the parameter space via an iterative EM-like algorithm whose convergence is guaranteed. Attias (1999a) demonstrated the variational approach to the fitting of mixture models to some toy and real data sets.

<a id="sec-4-12"></a>

# 4.12 MINIMUM MESSAGE LENGTH

The mixture modeling program, Snob, uses the Minimum Message Length (MML) principle to fit a mixture model. More details on this program are given in the Appendix on mixture software. For a review of MML inductive inference, the reader is referred to Wallace and Boulton (1968), Wallace and Freeman (1987), and Wallace and Dowe (2000)

Wallace and Freeman (1987)argue that statistical estimation can be performed as a coding process. They stated the basic philosophy of the minimum encoding methods as follows (Wallace and Freeman, 1987; Rissanen, 1986):

We may first estimate the parameters and then the data under the assumption that these are the true values . The encoded string must now, however; con tain a specification of the estimated values. model is, therefore; only worth considering ifthe shortening of the encoded data achieved by adopting it more than compensates for the lengthening caused by having We thus naturally arrive at very simple trade-off between the complexity of a model and its goodness of fit: Any string

As explained in Oliver, Baxter, and Wallace (1996) and Baxter and Oliver (2000) in the context of mixture models, the message consists of two parts. The first part states g, followed by the parameters for each component. The second part of the message states the observed data y under the assumption that the estimates of the parameters are the true values.

As reported in Baxter and Oliver (2000), Wallace and Freeman (1987) estimate the expected message length as

$$
- \log L ( \Psi ) - \log p ( \Psi ) + \frac { 1 } { 2 } \log | \, \mathcal { I } ( \Psi ) \, | + \frac { 1 } { 2 } d + \frac { 1 } { 2 } d \log \kappa _ { d } ,
$$

where p(v) is the density for ", d is the number of unknown parameters, and Kd is the d-dimensional optimal quantizing lattice constant. For example, K1 1/12 and K2 = 5/(36v3); see Table 2.3 in Conway and Sloane (1988) prior

Thus (4.30) for a given number of components g, the MML estimate of "is the value of € that maximizes the log posterior density penalized by the term using log

The approximated expected message length (4.30) is very similar to approximations to the negative of the log integrated likelihood, log p(v) , obtained by Laplace's method; see (6.47) and (6.48). The integrated likelihood p(u) is given by

$$
( 4 . 3 1 )
$$

For example, from (6.48), we have

$$
- \log p ( y ) \approx - \log L ( \hat { \Psi } ) - \log p ( \hat { \Psi } ) + \frac { 1 } { 2 } \log | \, I ( \hat { \Psi } ; y ) \, | - \frac { 1 } { 2 } d \log ( 2 \pi ) ,
$$

where I(#; y) is the obscrved information matrix.

The expression (4.30) is unable to be used directly in practice for; as noted in Chapter 2, the expected information matrix I(v) is very difficult to calculate for mixture models. Even its commonly used approximation, the observed information ofthe MML approach, the expected information matrix is usually approximated by the complete-data expected information matrix, Ic(v) (Baxter and Oliver; 2000) We note that the determinants of the complete-data expected information matrix Ic(v) and (the incomplete-data) expected information matrix I(v) can be quite different. To see this, we have from (2.50), for the EM algorithm applied to compute the MLE 4, that the rate of convergence depends on the smallest eigenvalue of

$$
\mathcal { I } _ { c } ^ { - 1 } ( \hat { \Psi } ; y ) I ( \hat { \Psi } ; y ) .
$$

The EM algorithmcan converge very slowly, in particular when the components of the mixture are not well separated, which indicates that these two matrices;\_ Ic(û; y) and I(û; y), can be quite different. Now the observed information matrix I(#) should be similar to the estimated expected information matrix I(#); and for component

Baxter and Oliver (2000) considered an improved estimate of the expected information matrix I(v) for use in the MML criterion (4.30) by adopting I(v; y) as approximated by the empirical information matrix (2.60). They also considered computationally less demanding approximation that forms the determinant of the empirical information matrix by ignoring its off-diagonal elements.

