<a id="sec-appendix-mixture-software"></a>

# Appendix Mixture Software

<a id="sec-a-1-emmix"></a>

# A.1 EMMIX

We very briefly describe some available software for the of mixture models, commencing with the EMMIX program (previously known as MIXFIT (McLachlan and Peel (1998b)) that has been developed jointly by the authors (McLachlan et al., 1999). Since its publication; the EMMIX program has been developed further and is extended to handle mixed continuous and categorical data. The current version is available from the World Wide Web address given below. fitting being

Authors: McLachlan, Peel, Adams, and Basford (1999)

Language/Platform: FORTRAN 77 and PC executable

Availability:

http= WWW maths uq - edu au/ 'gjm/emmix/emmix.html

<a id="sec-description"></a>

# Description

The program EMMIX was developed as a general tool to fit mixtures of normal or t components by maximum likelihood via the EM algorithm to continuous multivariate data. If the user does not supply a starting value for the vector of unknown param eters or an initial grouping of the data for the application of the EM algorithm; it

automatically provides starting values by considering a selection obtained from three sources:

random starts;

hierarchical clustering-based starts;

k-means clustering-based starts.

- Concerning (1), there is an additional whereby the user can first subsample the data before a random start based on the subsample each time. This is to limit the effect of the central limit theorem; which would have the randomly selected starts similar for each component in samples; option using being large
- Concerning (2), the user has the option of in either standardized or unstan dardized form, the results from seven hierarchical methods (nearest neighbor, farthest Ward's method). There are several algorithm parameters that the user can optionally specify; alternatively, default values are used. All these computations are automatically carried out by the program. The user only has to provide the data set and the form of the component-covariance matrices (equal, unequal, or diagonal), and to specify the starting procedures and the number of components that are to be fitted. Summary information is automatically given as output for the final fit. The default final fit is taken to be the one corresponding t0 the largest of the local maxima located. However, the summary information can be recovered for any distinct fit. Indeed, it is not suggested that the mixture analysis of a data set should always be based solely on a single solution of the likelihood equation. It may be informative to consider the various solutions collcctively; particularly with clustering applications: Also; with the of a mixture of normal components with unrestricted component-covariance matrices, there is a need to monitor the relative sizes of the component variances (and generalized variances for multivariate data) of a solution as an aid in the detection of spurious local maximizers, as discussed in Section 3.10. To this end, the EMMIX program outputs the generalized component variances for each solution. using, fitting

As well as the options pertaining t0 the automatic provision of starting values covered above, several other options are available, including:

the provision of standard errors for the fitted parameters in the mixture model via various methods (Section 2.16);

the bootstrapping of the likelihood ratio statistic X for testing g 9 = g0 + 1 components in the mixture model, where the value go is specified by the user (Section 6.6);

the of mixture models to partially classified data. fitting~

More precise information on the EMMIX program, including its implementation; are given in the "User's Guide to EMMIX; which is supplied with the program.

<a id="sec-a-2-some-other-mixture-software"></a>

# A.2 SOME OTHER MIXTURE SOFTWARE

We list below summary information on some other available mixture software. A review of some of these programs may be found in Haughton (1997). It should be noted that the list below is not intended to be comprehensive, as there are other programs available for mixtures; especially in specialized cases; for example, mixtures of Weibulls in reliability applications. fitting

<a id="sec-autoclass"></a>

# AUTOCLASS

Authors: Cheeseman and Stutz (1996)

Language/Platform:

Availability:

http://ic-www arc nasa.gov/iclprojects/ bayes-group / people/ cheeseman /

Description: AUTOCLASS adopts a Bayesian approach to fit mixtures of normal or uniform distributions to continuous multivariate variables, and mixtures of Bernoulli distributions to discrete data. The program is also able to handle missing data and the case of an unspecified number of components.

<a id="sec-binomix"></a>

# BINOMIX

Erdfelder (1993)

Author:

Language/Platform; BASIC

Availability: http: comp binomix.htm

/www . psychologie\_ uni-bonn de/ ~erdfel_el

Description: BINOMIX fits a mixture of binomial or beta-binomial distributions the EM algorithm: using

<a id="sec-c-aman"></a>

# C.AMAN

Böhning, Schlattmann, and Lindsay (1992, 1998)

Authors:

Language/Platform: FORTRAN 77 and PC executable

Availability: http://ftp.ukbf fu-berlin.de/sozmed/ caman

html

C.AMAN stands for Computer-Assisted Mixture Analysis.

Description:

CAMAN will fit mixtures of normal (with equal or unequal variances), Poisson, geometric, binomial, exponential; or Laplace univariate distributions, usone of four methods, including the EM algorithm. It also has a semiparametric method to estimate an appropriate number of components. The maximum number of data that the PC version can analyze is 500. Haughton (1997) refers to a personal correspondence from Professor Böhning, in which he out that in practice it is feasible to group the data into 500 bins of histogram like frequencies to allow analysis; see also Section 5.8.5. ing fitting points points

<a id="sec-mclustiemclust"></a>

# MCLUSTIEMCLUST

Authors: Fraley and Raftery (1999)

Language/Platform: FORTRAN with interfaces to the S-PLUS software package and the R language.

<a id="sec-availability"></a>

# Availability:

http:/ /www \_ stat.washington edu/ fraley/ software html

Description: MCLUST is a software package for hierarchical clustering on the ba-

sis of mixtures of normal components under various parameterizations of the component-covariance matrices. The EM algorithm is used in the process; and BIC is used for the determination of the number of components. It has the option to include an additional component in the model for background (Poisson) noise. fitting

<a id="sec-mgt"></a>

# MGT

Authors: Jones and McLachlan (1990b)

Language/Platform: FORTRAN 77

Availability: AS 254 StatLib http:/ /www stat cmu edu/apstat/

Description: MGTis a subroutine for a mixture of univariate normal distribu - tions to binned and truncated data. The subroutine also provides the standard fitting

errors of the estimates .

<a id="sec-mix"></a>

# MIX

Authors: Macdonald and Pitcher (1979)

Language/Platform: Macintosh, DOS, and Windows executables

Availability: MIX is commercially available with a demo obtainable from

http://icarus math mcmaster Ipeter/mix/mix.html ca

Description: MIX works with univariate binned data, with a maximum of 80 bins and 15 components. The program will fit mixtures of normal, normal, gamma; exponential, or Weibull components and provides standard errors of the estimated parameters . log

<a id="sec-mixbin"></a>

# MIXBIN

J. Uebersax

Authors:

Language/Platform: QuickBASIC and PC executable

Availability:

http:/ /members xoom com/jsuebersax /papers html

Description: MIXBIN fits mixtures of binomial distributions via an EM-type algorithm and also gives the asymptotic standard errors by inverting the observed information matrix . The likelihood ratio test statistic, AIC, and BIC are also computed. The program restricts the minimum trial size to 3 outcomes and the maximum trial size to 12 outcomes.

<a id="sec-program-for-gompertz-mixtures"></a>

# Program for Gompertz Mixtures

Authors:

McLachlan et al. (1997)

Language/Platform: FORTRAN 77

Availability: Journal of Statistical Software

http: www stat.ucla edu/journalsljss/v02.i07

Description: McLachlan et al. (1997) have provided an algorithm for mixtures fitting

of two Gompertz distributions to censored survival data.

<a id="sec-mplus"></a>

# MPLUS

Author:

B. Muthén and L. Muthén

Language/Platform: Windows 95

Availability: MPLUS is commercially available with a demo obtainable from

http:

Iwww statmodel com/

Description: Mplus is a statistical modeling program that includes tools to fit latent class models. The criteria AIC and BIC are used for model selection, and standard errors of the estimates are supplied.

<a id="sec-multimix"></a>

# MULTIMIX

Authors: Jorgensen and Hunt (1996)

Language/Platform: FORTRAN 77

Availability:

ftp:l/ftp\_ math.waikato ac nz Ipub /maj /

Description: MULTIMIX adopts the location model (Section5.2.1) to fit mixtures to mixed continuous and categorical variables. There is also a version of MULTIMIX that implements the approach of Little and Rubin (1987) to missing data. An introduction to the program is given by Jorgensen and Hunt (1996) and Hunt and Jorgensen (1999); see also Section 5.2.2.

<a id="sec-normix"></a>

# NORMIX

Wolfe (1965, 1967, 1970)

Author:

Language/Platform: FORTRAN 77 and PC executable

Availability:

http:l/alumnus caltech.edu / wolfel

Description: NORMIX fits mixtures of normals or Bernoullidistributions from specified initial values of the parameters or frominitial partitions obtained by various

hierarchical clustering methods .

<a id="sec-snob"></a>

# SNOB

Authors: Wallace and Dowe (1994)

Language/Platform: FORTRAN 77

Availability: http:/ /www

cs monash.edu au/ dld/ Snob.html

Description: SNOB is based on the Minimum Message Length (MML) approach

of Wallace and Boulton (1968) and Wallace and Freeman (1987). It allows the of mixtures of discrete distributions (multistate Bernoulli or categorical), normal (with diagonal covariance matrices) Poisson; and von Mises distributions . The input data can contain missing values and the number of components can be estimated. fitting

Software for Flexible Bayesian Modeling and Markov Chain Sampling

Language/Platform: C

Availability:

http:/ /www Cs toronto.edu / radford/ fbm. software html Description: This software allows the of mixtures via a Bayesian approach. fitting
