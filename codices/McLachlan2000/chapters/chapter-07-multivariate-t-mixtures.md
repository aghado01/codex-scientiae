<a id="sec-multivariate-t-mixtures"></a>

# Multivariate t Mixtures

<a id="sec-7-1"></a>

# 7.1 INTRODUCTION

For many applied problems, the tails of the normal distribution are often shorter than required . Also; the estimates of the component means and covariance matrices can be affected by observations that are of the components in the normal mixture model fitted. The problem of providing protection against outliers in multivariate data is a very difficult problem and increases in difficulty with the dimension of the data (Rocke and Woodruff, 1997; Kosinski, 1999). atypical being

In this chapter we consider the of mixtures of (multivariate) t distributions, as proposed in McLachlan and Pcel (1998a) and Peel and McLachlan (2000). distribution provides a longer-tailed alternative to the normal distribution: Hence it provides more robust approach to the of normal mixture models, as obser vations that are atypical of a component are given reduced weight in the calculation of its parameters. Also; the use of t components gives less extreme estimates of the posterior probabilities of component membership of the mixture model. fitting

With this t mixture model-based approach, the normal distribution foreach compo-

nent in the mixture is embedded in a widerclass of elliptically symmetric distributions with an additional parameter called the degrees of freedom v \_ As v tends to infinity; be viewed as robustness tuning parameter. It can be fixed in advance or it can be inferred from the data for each component, thereby providing an adaptive robust procedure, as explained in Lange, Little; and Taylor (1989), who considered the use of a single component t distribution in linear and nonlinear regression problems; see also Rubin (1983) and Sutradhar and Ali (1986). An early reference for the t distribution to model data in the case of a single component distribution is Jeffreys using

(1932) Of course, as noted by Lange et al. (1989), the use of the t distribution is not a panacea for all forms of robustness. Data with shorter-than-normal tails, asymmetric distributions; varying degrees of long-tailedness among the feature variables; or with extreme outliers will not be able to be modeled adequately by a mixture of t distributions.

<a id="sec-7-2"></a>

# 7.2 PREVIOUS WORK

Robust estimation in the context of mixture models has been considered in the past by Campbell (1984), McLachlan and Basford (1988, Chapter 3), and De Veaux and Kreiger (1990), among others, using M-estimates of the means and covariance matrices of the normal components of the mixture model. This line of approach is to be discussed in Section 7.6.

Recently; Markatou (1998) has provided formal approach to robust mixture estimation by applying weighted likelihood methodology in the context of mixture models. With this methodology; an estimate of the vector of unknown parameters is obtained as a solution of the equation

$$
\sum _ { j = 1 } ^ { \infty } w ( y _ { j } ) \partial \log f ( y _ { j } ; \Psi ) / \partial \Psi = 0 ,
$$

where f($y_j$; %) denotes the specified parametric form for the density of $Y_j$; The weight function w(u;) is defined in terms of the Pearson residuals; see Markatou; Basu, and Lindsay (1998) and the previous work of Green (1984). The weighted likelihoodmethodology provides robust and first-order efficient estimators in general, and Markatou (1998) has established these results in the context of univariate mixture models

Also; Tibshirani and Knight (1999) have proposed the technique of bootstrap "bumping;' which can be used for resistant fitting: They demonstrated its use in two-component univariate normal mixture model in the presence of an outlier. The target criterion to be minimized was taken to be the median of the negative of the mixture density at each of the observations %; , while the working criterion was taken to be the negative of the likelihood. Corresponding to this choice for the working criterion; the usual ML solution € was obtained via the EM algorithm for each of number B of bootstrap samples %6 (6 = 1 B) obtained by sampling with replacement from the original sample y. The fit was then taken to be that estimate criterion fitting log log

<a id="sec-7-3"></a>

# 7.3 ROBUST CLUSTERING

One useful application of normal mixture models has been in the important field of cluster analysis. Besides having a soundmathematical basis; this approach is not confined to the production of spherical clusters, such as with k-means-type algorithms that use Euclidean distance rather than the Mahalanobis distance metric, which allows for within-cluster correlations between the variables in the feature vector Yj . Moreover, unlike clustering methods defined solely in terms of the Mahalanobis distance, the normal mixture-based clustering takes into account the normalizing term $Z_j$ in the estimate of the multivariate normal density adopted for the component distribution of Y corresponding to the ith cluster. This term can make an important contribution in the case of disparate group-covariance matrices (McLachlan, 1992; Chapter 2) /-1/2

Although even a crude estimate of the within-cluster covariance matrix $Z_j$ often be severely affected by outliers. Hence it is highly desirable for methods of cluster analysis to provide robust clustering procedures. The problem of making clustering algorithms more robust has received much attention recently as, for example, in Jolion; Meer, and Bataouche (1991), Smith, Bailey, and Munford (1993), Frigui and Krishnapuram (1996), Kharin (1996), Rousseeuw, Kaufman, and Trauwaert (1996), Zhuang et al. (1996), and Davé and Krishnapuram (1997).

<a id="sec-7-4"></a>

# 7.4 MULTIVARIATE t DISTRIBUTION

One way to broaden the normal parametric family for potential outliers or data with longer-than-normal tails is to adopt the two-component normal mixture density

$$
( 1 - \epsilon ) \phi ( y _ { j } ; \mu , \Sigma ) + \epsilon \phi ( y _ { j } ; \mu , k \Sigma ) ,
$$

where k is large and € is small, representing the small proportion of observations that have a relatively variance. Huber (1964) subsequently considered more general forms of contamination of the normal distribution in the development of his robust M-estimators of a location parameter, as to be discussed further in Section 7.6. large

The normal scale mixture model (7.2) can be written as where where



where H is the probability distribution that places mass (1 \_ €) at the point u = 1 and mass point u = 1/k. Suppose we now replace H by the distribution of chi-squared random variable on its degrees of freedom v; that is, by the random variable U distributed as

$$
U \sim \text { gamma } ( \frac { 1 } { 2 } \nu , \, \frac { 1 } { 2 } \nu ) ,
$$

where the gamma (0, ß) density function is defined by (4.16). We then obtain the t distribution with location parameter A, positive definite inner product matrix >, and degrees of freedom;

$$
f ( y _ { j } ; \mu , \Sigma , \nu ) = \frac { \Gamma ( \frac { \nu + p } { 2 } ) \left | \Sigma \right | ^ { - 1 / 2 } } { ( \pi \nu ) ^ { \frac { 1 } { 2 } p } \Gamma ( \frac { \nu } { 2 } ) \{ 1 + \delta ( y _ { j } , \mu ; \Sigma ) / \nu \} ^ { \frac { 1 } { 2 } ( \nu + p ) } } ,
$$



2)-12 is its covariance matrix . As v tends to infinity, U converges to one with probability one; and so $Y_j$ becomes marginally multivariate normal with mean u and covariance matrix >. The family of t distributions thus provides a heavy-tailed alternative to the normal family with mean u and covariance matrix that is equal to a scalar multiple of $ (if v > 2)

<a id="sec-7-5"></a>

# 7.5 ML ESTIMATION OF MIXTURE OF t DISTRIBUTIONS

<a id="sec-7-5-1"></a>

# 7.5.1 Application of EM Algorithm

brief history of the development of ML estimation of a single-component t distribution is given in Liu and Rubin (1995). An account of more recent work is given in Liu (1997). Liu and Rubin (1994, 1995) have shown that the MLEs can be found much more efficiently by an extension of the EM algorithm called the expectation-conditional maximization either (ECME) algorithm: Meng and van Dyk (1997) demonstrated that the more promising versions of the ECME algorithm for the t distributioncan be obtained alternative data augmentation schemes. called this algorithm the alternating expectation-conditional maximization (AECM) algorithm. Following and van Dyk (1997), Liu (1997) considered a class of data augmentation schemes even more general than the class of Meng and van Dyk (1997). This led to new versions of the ECME algorithm for ML estimation of the t distribution with possible missing values; corresponding to applications of the parameter-expanded EM (PX-EM) algorithm (Liu et al., 1998) using using They Meng

We consider now ML estimation for a g-component mixture of t distributions, given by

$$
f ( y _ { j } ; \Psi ) = \sum _ { i = 1 } ^ { g } \pi _ { i } f ( y _ { j } ; \mu _ { i } , \Sigma _ { i } , \nu _ { i } ) ,
$$

$$
\Psi = ( \pi _ { 1 } , \, \dots , \, \pi _ { g - 1 } , \, \xi ^ { T } , \, \nu ^ { T } ) ^ { T } ,
$$

V = (v1, and € contains the elements of the u; and the distinct elements of S; (i = 1, The application of the EM algorithm for ML estimation in the case of a single component t distribution has bcen described in McLachlan and Krishnan (1997, Sections 2.6 and 5.8). The results there can be extended to cover the present case of a g-component mixture of multivariate t distributions. "g)?,

In the EM framework, the complete-data vector is given by

$$
( \dots , u _ { n } ) ^ { T } ,
$$

where y = UF)T denotes the observed-data vector; 21, Zn are the component-label vectors defining the component of origin of V1, Un' respectively; and zij = according as to whether U; belongs or does not belong to the ith component. In the light of the above characterization of the t distribution; it is convenient to view the observed data augmented by the $z_j$ as still incomplete and introduce into the complete-data vector the additional missing un , which are defined so that given =1, we obtain being Zij

$$
Y _ { j } \left | u _ { j } , z _ { i j } = 1 \ \sim N ( \mu _ { i } , \, \Sigma _ { i } / u _ { j } ) ,
$$

independently for j = 1, n, and

$$
( 7 . 1 0 )
$$

Given 21 , the U1, Un are independently distributed according to (7.10). Thecomplete-data likelihood Lc(v) can be factored intothe product of the marginal densities of the Zj, the conditional densities of the U; given the 2;, and the conditional densities of the $Y_j$ given the u; and the $z_j$. Accordingly, the complete-data likelihood can be written as Zn' log

$$
\log L _ { c } ( \Psi ) = \log L _ { 1 c } ( \pi ) + \log L _ { 2 c } ( \nu ) + \log L _ { 3 c } ( \xi ) ,
$$

where

$$
\log L _ { 1 c } ( \pi ) = \sum _ { i = 1 } ^ { y } \sum _ { j = 1 } ^ { n } z _ { i j } \, \log \pi _ { i } ,
$$

and

$$
\log L _ { 2 c } ( \nu ) \ = \ \sum _ { i = 1 } ^ { g } \sum _ { j = 1 } ^ { n } z _ { i j } \{ - \log \Gamma ( \frac { 1 } { 2 } \nu _ { i } ) + \frac { 1 } { 2 } \nu _ { i } \log ( \frac { 1 } { 2 } \nu _ { i } ) \\ + \frac { 1 } { 2 } \nu _ { i } ( \log u _ { j } - u _ { j } ) - \log u _ { j } \} ,
$$

$$
( \frac { 1 } { i = 1 } \sum _ { j = 1 } ^ { 2 } \sum _ { i = 1 } ^ { 2 } ( 2 ^ { T } \sum _ { i = 1 } ^ { T } ( y _ { i } - \mu _ { i } ) ^ { T } \sum _ { i } ^ { T } ( y _ { j } - \mu _ { i } ) ) \} . \\ - \frac { 1 } { 2 } u _ { j } ( y _ { j } - \mu _ { i } ) ^ { T } \sum _ { i } ^ { T } ( y _ { j } - \mu _ { i } ) ) \} .
$$

and & = (0, of #; and the distinct elements of $Z_j$ (i = 1, 9)

<a id="sec-7-5-2"></a>

# 7.5.2 E-Step

Now the E-step on the (k + 1)th iteration of the EM algorithm requires the calculation of Q(w; w{k)), the current conditional expectation ofthe complete-data log likelihood function, This E-step can be effected by first taking the expectation of log Lc(v) conditional on 21, y. It can be seen from (7.12) to (7.14) that in order to do this, we need to calculate log

$$
E _ { \Psi ^ { ( * ) } } ( Z _ { i j } | y _ { j } ) , \\ E _ { \Psi ^ { ( * ) } } ( U _ { j } | y _ { j } , z _ { j } ) ,
$$

and

$$
( 7 . 1 5 )
$$

It follows that

where

$$
( 7 . 1 6 )
$$

$$
( 7 . 1 7 )
$$

is the posterior probability that U; belongs to the ith component of the mixture, (i=1, g; j = 1, n) using

Since the gamma distribution is the conjugate prior distribution for Uj, it is not

$$
( 7 . 1 8 )
$$

where

mi

=

and n.

$$
m _ { 2 i } = \frac { 1 } { 2 } \{ \nu _ { i } + \delta ( y _ { j } , \mu _ { i } ; \Sigma _ { i } ) \} .
$$

From (7.18), we have that

$$
E ( U _ { j } \ | \ y _ { j } , z _ { i j } = 1 ) = \frac { \nu _ { i } + p } { \nu _ { i } + \delta ( y _ { i j } , \mu _ { i } ; \Sigma _ { i } ) } .
$$

Thus from (7.20), we obtain

where

$$
( 7 . 2 1 )
$$

$$
u _ { i j } ^ { ( k ) } = \frac { \nu _ { i } ^ { ( k ) } + p } { \nu _ { i } ^ { ( k ) } + \delta ( y _ { j } , \mu _ { i } ^ { ( k ) } ; \Sigma _ { i } ^ { ( k ) } ) } .
$$

$$
( 7 . 2 3 )
$$

where

$$
\psi ( s ) = \{ \partial \Gamma ( s ) / \partial s \} / \Gamma ( s )
$$

is the Digamma function. Applying the result (7.23) to the conditional density of U;

$$
E _ { x } ( x ) ( \log U _ { j } | y _ { j } , z _ { i j } = 1 ) & = \psi \left ( \frac { \nu _ { i } ^ { ( k ) } + p } { 2 } \right ) - \log [ \frac { 1 } { 2 } \{ \nu _ { i } ^ { ( k ) } + \delta ( y _ { j } , \mu _ { i } ^ { ( k ) } ; \Sigma _ { i } ^ { ( k ) } ) ] \} ] \\ & = \ \log u _ { i j } ^ { ( k ) } + \left \{ \psi \left ( \frac { \nu _ { i } ^ { ( k ) } + p } { 2 } \right ) - \log \left ( \frac { \nu _ { i } ^ { ( k ) } + p } { 2 } \right ) \right \} \\
$$

for j = 1, The last term on the right-hand side of (7.24)

$$
\left ( \frac { \nu _ { i } ^ { ( k ) } + p } { 2 } \right ) - \log \left ( \frac { \nu _ { i } ^ { ( k ) } + p } { 2 } \right ) ,
$$

can be interpreted as the correction for just imputing the conditional mean value for uj in Uj. log

On using the results (7.16), (7.21), and (7.24) to calculate the conditional expecgiven by

$$
( 7 . 2 5 )
$$

where

$$
\Psi ^ { ( k ) } ) = \sum _ { i = 1 } ^ { g } \sum _ { j = 1 } ^ { n } \hat { \tau } _ { i j } ^ { ( k ) } \log \pi _ { i } ,
$$

and

$$
Q _ { 2 } ( \nu ; \Psi ^ { ( k ) } ) = \sum \sum _ { \substack { \hat { \tau } _ { i j } ^ { ( k ) } Q _ { 2 j } ( \nu _ { i } ; \Psi ^ { ( k ) } ) , \\
$$

$$
\overline { i = 1 } \, \overline { j = 1 }
$$

$$
\Psi ^ { ( k ) } ) = \sum _ { i = 1 } ^ { j } \sum _ { j = 1 } ^ { n } \hat { \tau } _ { i j } ^ { ( k ) } Q _ { 3 j } ( \theta _ { i } ; \Psi ^ { ( k ) } ) ,
$$

and where, on ignoring terms not involving the vi,

and

$$
+ \frac { 1 } { 2 } \nu _ { i } \left \{ \sum _ { j = 1 } ^ { n } ( \log u _ { i j } ^ { ( k ) } - u _ { i j } ^ { ( k ) } ) + \psi \left ( \frac { \nu _ { i } ^ { ( k ) } + p } { 2 } \right ) - \log \left ( \frac { \nu _ { i } ^ { ( k ) } + p } { 2 } \right ) \right \}
$$

$$
u _ { i j } ( y _ { j } - \mu _ { i } ) ^ { T } \Sigma _ { i } ^ { - 1 } ( y _ { j } - \mu _ { i } ) \} . \quad ( 7 . 3 0 )
$$

<a id="sec-7-5-3"></a>

# 7.5.3 M-Step

On the M-step at the (k + 1)th iteration of the EM algorithm; it follows from (7.25) and v(k+1) can be computed independently of each other, by separate consideration of (7.26) (7.27), and (7.28), respectively; The solutions for freedom v; need to be computed iteratively given by the average of the posterior probabilities of component membership of the mixture. That is, being

$$
\pi _ { i } ^ { ( k + 1 ) } = \sum _ { j = 1 } ^ { n } \tau _ { i j } ^ { ( k ) } / n \quad ( i = 1 , \dots , g ) . \quad \L a r { \cdot }
$$

To update the estimates of #; and $Z_j$ (i = 1, 9), we need to consider

$$
Q _ { 3 j } ( \theta _ { i } ; \Psi ^ { ( k ) } ) .
$$

This is easily undertaken on noting that it corresponds to the likelihood function formed from n independent observations V1 Yn with common mean #; and covariance matrices It is thus equivalent to computing the weighted sample mean and sample covariance matrix of %1 with weights u{_) u4_) . Hence log

and It can be seen that if the degrees of freedom v; is fixed in advance for each component, then the M-step exists in closed form. In this case where v; is fixed beforehand, the estimation of the component parameters is a form of M-estimation; see Lange to model the component distributions is that the degrees of robustness as controlled we have to compute also on the M-step the updated estimate v{k+l) of v;. On calculating the left-hand side of the equation

$$
\mu _ { i } ^ { ( k + 1 ) } = \sum _ { j = 1 } ^ { n } \tau _ { i j } ^ { ( k ) } u _ { i j } ^ { ( k ) } y _ { j } / \sum _ { j = 1 } ^ { n } \tau _ { i j } ^ { ( k ) } u _ { i j } ^ { ( k ) }
$$

$$
\Sigma _ { i } ^ { ( k + 1 ) } = \frac { \sum _ { j = 1 } ^ { n } \tau _ { i j } ^ { ( k ) } u _ { i j } ^ { ( k ) } ( y _ { j } - \mu _ { i } ^ { ( k + 1 ) } ) ( y _ { j } - \mu _ { i } ^ { ( k + 1 ) } ) ^ { T } } { \sum ^ { n } \tau ^ { ( k ) } } .
$$

It can be seen that the EM process effectively chooses The E-step updates the weights u while the M-step chooses #{k+1) and by weighted least-squares estimation. From the form of the equation (7.32) derived for the MLE of p;, we have that;, as v(k) decreases; the degree of downweighting of an outlier increases. For finite v{k) as |l $y_j$ Il-+ %, the effect on the ith component location parameter estimate goes to zero, whereas the effect on the ith component scale estimate remains bounded but does not vanish.

Following the proposal of Kent; Tyler, and Vardi (1994) in the case of a single-

$$
\overline { j = 1 }
$$

This modified algorithm, however; converges faster than the conventional EM algorithm, as reported by Kent et al. (1994) and Meng and van Dyk (1997) in the case of a single-component t distribution (g = 1). In the latter situation; and van Dyk (1997) showed that this modified EM algorithm is optimal among EM algorithms generated from class of data augmentation schemes. More recently; in the case of 9 1, Liu (1997) and Liu et al. (1998) have derived this modified EM algorithm using the PX-EM algorithm. Meng

$$
\sum _ { j = 1 } ^ { n } \partial Q _ { 2 j } ( \nu _ { i } ; \Psi ^ { ( k ) } ) / \partial \nu _ { i } = 0 ,
$$

it follows that v(k+1) is a solution of the equation

$$
& \left \{ - \psi ( \frac { 1 } { 2 } \nu _ { i } ) + \log ( \frac { 1 } { 2 } \nu _ { i } ) + 1 + \frac { 1 } { n _ { i } ^ { ( k ) } } \sum _ { j = 1 } ^ { n } \tau _ { i j } ^ { ( k ) } ( \log u _ { i j } ^ { ( k ) } - u _ { j } ^ { ( k ) } ) \\ & + \psi \left ( \frac { \nu _ { i } ^ { ( k ) } + p } { 2 } \right ) - \log \left ( \frac { \nu _ { i } ^ { ( k ) } + p } { 2 } \right ) \right \} = 0 ,
$$

where = () (i = 1, 9).

<a id="sec-7-5-4"></a>

# 7.5.4 Application of ECM Algorithm

For ML estimation of a single t component, Liu and Rubin (1995) noted that the convergence of the EM algorithm is slow for unknown v and the one-dimensional search for the computation of v(k+l) is time-consuming. Consequently; ered extensions of the EM algorithm in the form of the ECM and ECME algorithms; see McLachlan and Krishnan (1997, Section 5.8) and Liu (1997). they

We consider now the ECM algorithm for the present problem of more than one t 1g-1, = (v1, On the (k + 1)th iteration of the ECM algorithm; the E-step is the same as given above for the EM algorithm, but the M-step

and with 42 equal to v of the latter is replaced by two CM-steps; as follows:

$$
C M \text {-Step 1.} \, \text {Calculate $\Psi_{1}^{(k+1)}$ by max} \\ \Psi _ { 2 } ^ { ( k ) } ; \text { that is, } \nu \text { fixed at } \nu ^ { ( k ) } .
$$

$$
C M \text {-Step 2} \, \ C a l c u l l a t e \, \Psi _ { 2 } ^ { ( k - 1 ) }
$$

But as seen above, and arecalculated independently ofeach other on the M-step; and so these two CM-steps of the ECM algorithm are equivalent to the Mstep of the EM algorithm. Hence there is nodifference between this ECM and the EM

algorithms here. However, Liu and Rubin (1995) used the ECM algorithmto give two modifications that are different from the EM algorithm. These two modifications are multicycle version of the ECM algorithm and an ECME extension:. The multicycle version of the ECM algorithm has an additional E-step between the two CM-steps. That is, after the first CM-step; the E-step is taken with

$$
\Psi = ( \Psi _ { 1 } ^ { ( k + 1 ) ^ { T } } , \Psi _ { 2 } ^ { ( k ) ^ { T } } ) ^ { T } ,
$$

instead of with y = as on the commencement of the (k + 1)th iteration of the ECM algorithm. The EMMIX algorithm of McLachlan et al. (1999) has an for the fitting of mixtures of multivariate t components either with or without the specification of the component degrees of freedom: option

For asingle-componentt distribution; Liu and Rubin (1994, 1995), Kowalski et al. (1997), Liu (1997), Meng and van Dyk (1997), and Liu et al. (1998) have considered further extensions of the ECM algorithm corresponding to various versions of the ECME algorithm. However; the implementation of the ECME algorithm for mixtures of t distributions is not as straightforward, and so it is not applied here.

<a id="sec-7-6"></a>

# 7.6 PREVIOUS WORK ON M-ESTIMATION OF MIXTURE COMPONENTS

A common way in which robust of normal mixture models has been undertaken in the past has been to use M-estimates to update the component estimates on the Mstep of the EM algorithm; as in Campbell (1984) and McLachlan and Basford (1988) With M-estimation, the updated component means are given by (7.32), but where now the weights are defined as fitting U;j

and where mal density was used, while in the related univariate work in De Veaux and Kreiger (1990), the t density with three degrees of freedom was used, with the location and scale component parameters estimated by the (weighted) median and mean absolute deviations; respectively.

$$
u _ { i j } ^ { ( k ) } = \psi ( d _ { i j } ^ { ( k ) } ) / d _ { i j } ^ { ( k ) }
$$

$$
d _ { i j } ^ { ( k ) } = \{ ( y _ { j } - \mu _ { i } ^ { ( k ) } ) ^ { T } \Sigma _ { i } ^ { ( k ) ^ { - 1 } } ( y _ { j } - \mu _ { i } ^ { ( k ) } ) \} ^ { 1 / 2 }
$$

$$
\begin{array} { r l r } { s } & { = } & { s , } & { | \ s \ | \leq a , } \\ & { = } & { s i g n ( s ) a , } & { | \ s \ | > a , } \end{array} \quad ( 7 . 3 6 )
$$

for an appropriate choice of the tuning constant @ The ith component-covariance An alternative to Huber's +-function is pels (1973) piecewise linear function. However; there can be problems in forming the posterior probabilities of component membership, as there is the question as to which parametric family to use for the component densities (McLachlan and Basford, 1988; Section 2.8). One possibility is to use the form of the density corresponding to

It can be therefore seen that the use of mixtures of t distributions provides a sound statistical basis for formalizing and implementing the somewhat ad hoc approaches that have been proposed in the past. It also provides a framework for assessing the degree of robustness tobe incorporated into the ofthemixture model through the specification or estimation of the degrees of freedom v; in the t component densities. fitting

As noted in the introduction, the use of t components in place of the normal components will generally give less extreme estimates of the posterior probabilities of component membership of the mixture model. The use of the t distribution in place of the normal distribution leading to less extreme posterior probabilities of group membership was noted in a discriminant analysis context, where the groupconditional densities correspond to the component densities of the mixture model (Aitchison and Dunsmore; 1975, Chapter 2). If a Bayesian approach is adopted and the conventional improper or vague specified for the mean and the inverse of the covariance matrix in the normal distribution for each group-conditional density it leads to the so-called predictive density estimate, which has the form of the t distribution; see McLachlan (1992, Section 3.5). prior

<a id="sec-example-7-1-simulated-noisy-data-set"></a>

**EXAMPLE 7.1: SIMULATED NOISY DATA SET**

One way in which the presence of atypical observations or background noise in the data has been handled when mixtures of normal components has been to include an additional component a uniform distribution. The support of the latter component is generally specified by the upper and lower extremities of each dimension defining the rectangular region that contains all the data points. Typically, the mixing proportion for this uniform component is left unspecified to be estimated from the data, as in Example 3.11 on the minefield data set as analyzed by Dasgupta and Raftery (1998). Another example may be found in Schroeter et al. (1998), who fitted a mixture of three normal components and a uniform distribution t0 segment magnetic resonance images of the human brain into three regions (gray matter, white matter; and cerebrospinal fluid) in the presence of background noise arising from instrument irregularities and tissue abnormalities. fitting having

Here we consider a sample consisting initially of 100 simulated points from three-component bivariate normal mixture model, to which 50 noise points were added from a uniform distribution over the range ~10 to 10 on each variate. The parameters of the mixture model were

$$
\mu _ { 1 } = ( \ 0 \ \ 3 \ ) ^ { T } \, , \, \mu _ { 2 } = ( \ 3 \ \ 0 \ ) ^ { T } \, , \, \mu _ { 3 } = ( \ - 3 \ \ 0 \ ) ^ { T } \, ,
$$

![image 25](mclachlan2000_images/imageFile25.png)

$$
\Sigma _ { 1 } = \left ( \begin{array} { c c } 2 & 0 . 5 \\ 0 . 5 & . 5 \end{array} \right ) , \, \Sigma _ { 2 } = \left ( \begin{array} { c c } 1 & 0 \\ 0 & . 1 \end{array} \right ) , \, \Sigma _ { 3 } = \left ( \begin{array} { c c } 2 & - 0 . 5 \\ - 0 . 5 & . 5 \end{array} \right ) ,
$$

with mixing proportions $\pi_1$ = T2 = T3 = The true grouping is shown in ure 7.1 . We now consider the clustering obtained by amixture ofthree t components with unequal scale matrices but equal degrees of freedom (v1 = v2 = v3 = v) The values of the weights u(;) at convergence; were examined. The noise points (points 101-150) gencrally produced much lower û;j values. In this application; an observation U; is treated as an outlier (background noise) if ciently small; equivalently; fitting OI,

$$
\sum _ { i = 1 } ^ { \sum _ { \hat { z } _ { i j } \delta ( y _ { j } , \hat { \mu } _ { i } ; \hat { \Sigma } _ { i } ) } }
$$

is sufficiently large, where

$$
\hat { z } _ { i j } = \arg \max _ { h } \hat { \tau } _ { h j } \ \ ( i = 1 , \dots , g ; \, j = 1 , \dots , n ) ,
$$

and î;j denotes the estimated posterior probability that U; belongs to the ith component of the mixture.

Fig. 7.1 Plot of the true grouping of the simulated noisy data set. From Peel and McLachlan (2000)

To decide on how the statistic (7.37) must be in order for U; to be classified as noise, we compared it to the 95th percentile of the chi-squared distribution with p degrees of freedom, where the latter is used to approximate the distribution of large

The clustering so obtained is displayed in Figure 7.2. It compares well with the true grouping in Figure 7.1 and the clustering in Figure 7.3 obtained by fitting a mixture of three normal components and an additional uniform component. In this particular example the model of three normal components with an additional uniform component to model the noise works well since it is the same model used to generate the data in the first instance. However; this model, unlike the t mixture model, cannot be expected to work as well in situations when the noise is not uniform or is unable to be modeled adequately by the uniform distribution.

- Fig. 7.2 Plot of the result of a mixture of t distributions (with classification of noise at a significance level of 59) to the simulated noisy data. From Peel and McLachlan (2000). fitting
- Fig. 7.3 Plot of the result of three-component normal mixture plus a uniform component model to the simulated noisy data. From Peel and McLachlan (2000). fitting

It is of interest to note that if the number of groups is treated as unknown and a normal mixture is fitted, then the number of groups selected via AIC, BIC, and the bootstrap LRT is four for each of these criteria. The result of a mixture of four normal components is displayed in Figure 7.4. Obviously; the additional fourth component is attempting to model the background noise. However; it can be seen from Figure 7.4 that this normal mixture-based clustering is still affected by the noise. fitting

7.4 Plot of the result of fitting a four-component normal mixture modelto the simulated noisy data. From Peel and McLachlan (2000). Fig.

<a id="sec-7-8"></a>

# 7.8 EXAMPLE 7.2: CRAB DATA SET

To further illustrate the t mixture model-based approach to clustering, we return to the crab data set of Campbell and Mahon (1974) on the genus Leptograpsus, as introduced in Section 3.7.I; see Figure 3.2. As explained there, it consists of n = 100 five-dimensional observations on n1 = 50 males and n2 = 50 females, which we shall refer to as groups G1 and G2, respectively. It was noted these data that Hawkins' (1981) simultaneous test for multivariate normality and equal covariance matrices (homoscedasticity) suggests that it is reasonable to assume that the group-conditional distributions are normal with a common covariance matrix . Consistent with this,~ a mixture of two t components (with equal scale matrices and equal degrees of freedom) gives only a slightly improved outright clustering over that obtained a mixture of two normal homoscedastic components. The t mixture model-based clustering results in onecluster containing 32 observations from G1 and another containing all 50 observations from G2, along with the remaining 18 observations from G1; the normal mixture model leads to one additional member of G1 assigned to the cluster corresponding to G2. It was seen in Section 3.7.1 that although the groups are homoscedastic, amuch improved clustering was obtained with a normal mixture model without restrictions on the component matrices. This same pattern of behavior is observed here with the t mixture model, with the latter giving 7 fewer misallocations when the scale matrices are unrestricted. for fitting using being

In this example, where the normal model for the components appears to be a reasonable assumption; the estimated degrees of freedom for the t components should be large; which are. The estimate of their common value v in the case of equal of v1 and v2 in the case of unequal scale matrices and unequal degrees of freedom they The likelihood function can be fairly flat near the MLEs of the degrees of freedom of the t components. To illustrate this, we have plotted in Figure 7.5 the profile likelihood function in the case of equal scale matrices and equal degrees of freedom (v1 = v2 = v), while in Figure 7.6 we have plotted the profile likelihood function in the case of unequal scale matrices and unequal degrees of freedom.

Nu

Fig. 7.5 Plot of the profile likelihood for various values of v for the crab data set with equal scale matrices andequal degrees of freedom (v1 =v2 v). From Peel and McLachlan (2000) log

2.5

1

p

0.5

20

100

150

200

Nuz

Fig. 7.6 Plot of the profile likelihood for v1 and v2 for the crab data set with unequal scale matrices and unequal degrees of freedom v1 and v2. From Peel and McLachlan (2000).

Finally; we now compare the t and normal mixture-based clusterings after some outliers are introduced into the original data set. This was done by adding various values to the second variate of the 25th point. In Table 7.1 we report the overall misallocation rate of the normal and t mixture-based clusterings for each perturbed version of the original data set. It can be seen that the t mixture-based clustering is robust to these perturbations; unlike the normal mixture-based clustering- In the cases where the constant equals ~15, ~10 and 20, it should be noted that a normal mixture model results in an outright classification of the outlier into one cluster. The remaining points are allocated to the second cluster, giving an error rate of 49. In practice the user should identify this situation when interpreting the results and hence remove the outlier; giving an error rate of 209. However, when the is part of an automatic procedure this would not be possible. fitting fitting

Table 7.1 Summary of Comparison of Error Rates When Fitting Normal and t Distributions with the Modification of a Single Point

| Constant | Normal Eror Rate | Component Error Rate |       | û1 ,25 | û2,25  |
| -------- | ---------------- | -------------------- | ----- | ------ | ------ |
|          | 49               | 19                   | 5.76  | 0.0154 | 0.0118 |
|          | 49               | 19                   | 6.65  | 0.0395 | 0.0265 |
|          | 21               | 20                   | 13.11 | 0.1721 | 0.3640 |
| 0        | 19               | 18                   | 23.05 | 0.8298 | 1.1394 |
| 5        | 21               | 20                   | 13.11 | 0.1721 | 0.3640 |
| 10       | 50               | 20                   | 7.04  | 0.0734 | 0.0512 |
| 15       | 47               | 20                   | 5.95  | 0.0138 | 0.0183 |
| 20       | 49               | 20                   | 5.45  | 0.0092 | 0.0074 |

<a id="sec-7-9"></a>

# 7.9 EXAMPLE 7.3: OLD FAITHFUL GEYSER DATA SET

As another demonstration of the use of the t mixture approach to the handling of outliers; we now consider the Old Faithful geyser data set consisting of 272 univariate measurements of eruptionlengths of the Old Faithful geyser. The data set is originally from Silverman (1986) However; in this example we consider a bivariate version analyzed in García-Escudero and Gordaliza ( 1999), where the data have been lagged.

- Figure 7.7 shows the clustering obtained by fitting a mixture of three t components with unequal scale matrices, but equal degrees of freedom (v1 = v2 =v3 = v). The values of the weights u were examined in a manner similar to that in Section 7.7 to classify points as outliers. The outliers determined at the 1% level are indicated by dots.
- Figure 7.8 gives thecorresponding results when the restriction ofequal componentscale matrices is These last results are in general agreement with those obtained by García-Escudero and Gordaliza ( 1999), who provided a robust clustering of these data trimmed k-means procedure. The latter assumes also that the component-covariance matrices are spherical. However, this would appear to be a reasonable assumption for this data set. The solutions differ on the conclusion of whether two of the observations (labeled A and B in Figure 7.8) are atypical; the latter are considered atypical on the basis of the t mixture model. applied. using equal

Enpbon Longh

Fig. 7.7 Result of fitting a three-component t mixture model with equal v; andunequal scale matrices to the Geyser data set; dots denote those observations assessed as at the 1 % level. atypical \_

1

Fig. 7.8 Result of three component t mixture model with equal v; and equal scale matrices to the Geyser data set; dots denote those observations assessed as atypical at the 1% level. fitting



