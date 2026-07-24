<a id="sec-ml-fitting-of-mixture-models"></a>

# ML Fitting of Mixture Models

<a id="sec-2-1"></a>

# 2.1 INTRODUCTION

been by far the most commonly used approach to the of mixture distributions. Hence the focus in this chapter is on the ML of finite mixture models via the EM algorithm. We consider the general case of arbitrary component distributions. These results will be specialized in later chapters for particular components such as the normal and t distributions . fitting fitting

Before proceeding to consider ML estimation for finite mixture models, we first briefly define ML estimation in general and introduce some associated notation.

<a id="sec-2-2"></a>

# 2.2 ML ESTIMATION

With the ML approach to the estimation of a $d$-dimensional parameter vector in a postulated density $f(y_j; \Psi)$ for the random vector $Y_j$ associated with the jth recording on the phenomenon under study; an estimate $\hat{\Psi}$ is provided in regular situations by an appropriate solution of the likelihood equation,

$$
\partial L ( \Psi ) / \partial \Psi = 0 ,
$$

Or, equivalently;



$$
L ( \Psi ) = \prod f ( y _ { j } ; \Psi )
$$

denotes the likelihood function for 4 formed under the assumption of independent data %1 ,

Briefly; the aim of ML estimation (Lehmann, 1980, 1983) is to determine an estimate for each n (# in the present context) so that it defines a sequence of roots of the likelihood equation that is consistent and asymptotically efficient. Such a sequence is known to exist under suitable regularity conditions (Cramér, 1946) With probability tending to one, these roots correspond to local maxima in the interior of the parameter space. This consistent sequence of roots is essentially unique. The reader is referred to Huzurbazar (1948) and Perlman (1983) for a precise statement of the uniqueness of a consistent sequence of roots of the likelihood equation. For estimation models in general, the likelihood usually has a global maximum in the interior of the parameter space. Then typically a sequence of roots of the likelihood equation with the desired asymptotic properties is provided by taking " for each n to be the root that globally maximizes the likelihood function L(v) . That is, V is the global maximizer of the likelihood and is called the maximum likelihood estimator (MLE).

We shall henceforth refer to as the MLE even in situations where it may not globally maximize the likelihood . Indeed, in some of the examples on mixture models to be presented, the likelihood is unbounded. However, for these models there may still exist, under the usual regularity conditions; a sequence of roots of the likelihood equation corresponding to local maxima with the properties of consistency; efficiency; and asymptotic normality; see Section 2.5. The reader is referred to Cheng and Traylor (1995) for an account of nonregular maximum likelihood problems for estimation in general.

Given that a statistical model is at best an approximation to reality; it is worth considering the behavior of the MLE if the structure of the postulated model (2.2) is not valid. It follows under mild regularity conditions that the MLE under the invalid model (2.2) is still a meaningful estimator, in that it is a consistent estimator of 4o, the value of < that minimizes the Kullback-Leibler distance between the actual density of $Y_j$ and the postulated parametric family;

$$
\{ f ( y _ { j } ; \Psi ) \colon \ \Psi \in \Omega \} ;
$$

see, for example, Hjort (1986).

<a id="sec-2-3"></a>

# 2.3 INFORMATION MATRICES

The Fisher expected information matrix about the parameter vector $\Psi$ is defined as



$$
\epsilon \partial \log L
$$

is the gradient vector of the log likelihood function (the score statistic) and y = be expressed as



where

is the negative of the Hessian of the

$$
= - \partial ^ { 2 } \log L ( \Psi ) / \partial \Psi \partial \Psi ^ { T }
$$

<a id="sec-2-4"></a>

# 2.4 ASYMPTOTIC COVARIANCE MATRIX OF MLE

The asymptotic covariance matrix of the MLE €is equal to the inverse of the expected error of $r = (#)r is given by

$$
^ { / 2 } _ { r } \quad ( r = 1 , \dots , d ) ,
$$

column of a matrix A

It is common in practice to estimate the inverse of the covariance matrix of the MLE by the observed information matrix I(û; y), rather than the expected information

$$
( r = 1 , \dots , d ) .
$$

Efron and Hinkley (1978) have provided a frequentist justification of (2.8) over (2.7) in the case of one-parameter (d = 1) families. Also, the observed information matrix is usually more convenient to use than the expected information matrix, as it does not require an expectation to be taken.

The provision of standard errors of MLEs in the context of mixture models is to be discussed in Section 2.16. It should be noted that the sample size n has to be very large before the asymptotic theory applies to mixture models.

<a id="sec-2-5"></a>

# 2.5 PROPERTIES OF MLEs FOR MIXTURE MODELS

Ifthe MLEof%exists as aglobal maximizer of the likelihood foramixture distribution with compact parameter space, then the conditions of Wald (1949) ensure that it is strongly consistent; see Redner (1981). It has been seen in Section 1.14 that, although class of mixture densities may be

identifiable; " may not. subset of the parameter space for which

$$
f ( y _ { j } ; \Psi ) = f ( y _ { j } ; \Psi _ { t } )
$$

for almost all V; in RP This set will contain more than the single Y in the case of component densities belonging t0 the same parametric family For then, as discussed in Section 1.14, a permutation of the component labels in $ does not alter the value of This particular identifiability problem can be avoided by the point f($y_j$;

Redner's (1981) work, however, was specifically aimed at families of distributions which are not identifiable. His results imply for mixture families with compact parameter space that, under the conditions of Wald (1949) except for the identifiability of €, L(æ) is almost surely maximized in a neighborhood of nt . More precisely; Redner (1981) referred to itas convergence of the MLE in the topology of the quotient space obtained by collapsing 9t into a single point; see Ghosh and Sen (1985), Li and Sedransk (1988), and Redner and Walker (1984) for further discussion.

More recently; and McCulloch (1996) obtained the parallel result in Euclidean space. Their result is also valid when the true value %t ofvlies on the bound ary of the parameter space /2 and is in a nonidentifiable subset 9t . showed that More precisely; showed that there converges to zero with probability one. The regularity conditions assumed by Feng and McCulloch (1996) are essentially those of Cramér (1946) but modified to allow for the fact that Vt lies in a nonidentifiable subset of the parameter space and may also be on the boundary. In other work, Self and Liang (1987) proved the consistency of the MLE when the parameter vector is identifiable but on the boundary of the parameter space. In the identifiable case, and McCulloch (1992) proposed an unrestricted MLE which is consistent and is asymptotically normally distributed. Thus the result of and McCulloch (1996) is an extension of those of Redner (1981), Self and Liang (1987), and and McCulloch (1992). The work of Feng and McCulloch (1996) is to be discussed further in Section 6.4.2 on the null distribution of the likelihood ratio test statistic for the number of components in a mixture model. Feng They they Feng Feng Feng

In the sequel, unless explicitly stated otherwise; it is implicitly assumed that nt terminology of Ghosh and Sen (1985), the class of mixture densities is strongly identifiable.

(1.20) is unbounded, and so then the MLE of $ does not exist; at least as a global maximizer of the likelihoodfunction. However, it may stillexist as a local maximizer. Peters and Walker (1978) and Redner and Walker (1984) have given, for the class of identifiable mixtures, the regularity conditions that must be satisfied in order for 0, with the properties of consistency, efficiency and asymptotic normality: The form of the conditions; which are essentially multivariate generalizations of Cramér's (1946) results for the corresponding properties in a general context; suggests that they should hold for many parametric families. Available results for the normal parametric family are to be reviewed in Section 3.8.

<a id="sec-2-6"></a>

# 2.6 CHOICE OF ROOT

With many applications of mixture models, the likelihoodequation will have multiple roots corresponding to local maxima, and so there is the problem of identifying the Since the global maximizer of the likelihood function is typically a root of the likelihood equation; the problem of identifying is solved in principle for those mixture models that satisfy Wald's (1949) conditions for the consistency of the global maximizer. For then if all the roots of the likelihood equation have been located, one can take to be the root that gives the largest local maximum However, in practice, the problem is not really solved since search for all roots corresponding to local maximizers of the likelihood function may take considerable time and there will generally be no guarantee that all local maximizers mixture models may be unbounded and so then the MLE will correspond to a local maximizer (assuming regularity conditions) .

If there is available some consistent estimator of %, then the estimator defined by the root of the likelihood equation closest to it is also consistent; and hence efficient (Lehmann, 1983, pp. 421) providing regularity conditions hold for the existence of a sequence of consistent and asymptotically efficient solutions of the likelihood equation. Where computationally feasible, the method of moments provides a way of constructing a Vn-consistent estimator of €. The usefulness of a Vn-consistent estimator of %, say @, is that under the same regularity conditions referred to above, consistent and asymptotically efficient estimator of 4 is obtained by a one-step approximation to the solution of the likelihood equation according t0 a Newton iterative scheme started from %. This approach does not require the determination of the closest root of the likelihood equation to ?, but its implementation does require the inversion of a symmetric matrix whose dimension is equal to the total of unknown parameters. Hence it may not be as convenient computationally as the EM algorithm applied from @.

In the above; itis not suggested that inference or aclustering should be based solely on a single root of the likelihood equation For example; in a clustering application, the clusters implied by the various local maximizers may have a number of points in common, which may be useful collectively in confirming that some or all of them are distant from the main body of points.

<a id="sec-2-7"></a>

# 2.7 TEST FOR A CONSISTENT ROOT

<a id="sec-2-7-1"></a>

# 2.7.1 Basis of Test

Recently; Gan and (1999) investigated a test of the null hypothesis that a given Jiang given root is consistent and asymptotically efficient. Itis based on the result (2.5) that under regularity conditions the expected information matrix is to the negative equal



<a id="sec-2-7-2"></a>

# 2.7.2 Example 2.1: Likelihood Function with Two Maximizers

To illustrate this point, Gan and (1999) generated a random sample of size 5000 from a mixture of two univariate normal components in proportions $\pi_1$ 0.4 and 72 =0.6 with means p1 =-3 and p2 = 6, and variances 0? = 1 and 0? chose this model where $ p1 is the single unknown parameter, as the likelihood equation usually has two roots that correspond to a global maxiFor the generated sample, calculated SE1 (v) = are displayed in Table 21. Jiang 16 . They they

It is clear from Table 2.1 that the SE1(") and SE2(v) are virtually the same at

Table 2.1 Local Maximizers of Normal Mixture Likelihood

|     | Global Maximizer (i =1) | Local Maximizer (i =2) |
| --- | ----------------------- | ---------------------- |
|     | ~3.0                    | 6.0                    |
|     | ~2.9931                 | 6.4778                 |
| log | ~9901                   |                        |
|     | 0.0234                  | 0.0492                 |
|     | 0.0237                  | 0.2807                 |

Source: Adapted from Gan and Jiang (1999).

<a id="sec-2-7-3"></a>

# 2.15.3 Calculation of Score Statistic

To form an unbiased estimator of the difference

$$
( 2 . 1 0 )
$$

we note that the expected information matrix I(v) is estimated unbiasedly by

where

$$
\hat { \mathcal { I } } ( \Psi ) = \sum _ { j = 1 } ^ { \infty } s ( y _ { j } ; \Psi ) s ^ { T } ( y _ { j } ; \Psi ) ,
$$

$$
( 2 . 1 2 )
$$

Thus

is an unbiased estimator of the difference (2.10).

If $ is a consistent estimator of 4, then it follows that

$$
( 2 . 1 3 )
$$

Gan and (1999) proposed Jiang using

$$
( 2 . 1 4 )
$$

$$
( 2 . 1 5 )
$$

as the basis of a large sample test of the null hypothesis that # is a consistent root of the likelihoodequation; that is, vis the MLE of €. investigated the case where scalar) . In this simplified case, asymptotically standard normal under the null hypothesis. Their simulations suggest that the test performs quite well when the sample size is large, but may suffer the problem of over-rejection with relatively small samples. They they

For convenience; Gan and (1999) suggested Jiang

$$
( 2 . 1 6 )
$$

as an alternative test statistic, where the variance in the denominator of (2.16) is approximated by Monte Carlo methods, for example; the bootstrap. The asymptotic

The test of Gan and (1999) is based on the work of White (1982), who the (normalized) statistic (2.15) to test the null hypothesis that the model was not misspecified. The latter is assumed to hold in the test of Gan and Jiang (1999) Thus if their test rejects the null hypothesis; then one can conclude that there is either problem of misspecification or a problem of € an inconsistent root of the likelihood equation. One cannot distinguish between the two, but there are other ways of assessing the validity of a model (Section 3.5). Jiang used being

Given the questionable small sample performance of this test and its present limi tation to the case of a single unknown parameter, in practice we will usually have to rely on other ways of deciding which root to choose as the MLE of €. This is to be pursued further in Section 3.10 in the context of normal components, where we shall see that there are reasons to choose the root of the likelihood equation corresponding to the largest of the local maxima located, after eliminating any so-called spurious local maximizers. This is in the absence of any other information on the parameters and their estimates, and it also assumes that we are reasonably confident about the suitability of the parametric forms adopted for the component densities. good

We now discuss how roots of the likelihood equation corresponding to local max ima can be obtained for mixture models by application of the EM algorithm.

<a id="sec-2-8"></a>

# 2.8 APPLICATION OF EM ALGORITHM FOR MIXTURE MODELS

<a id="sec-2-8-1"></a>

# 2.8.1 Direct Approach

We describe here the application of the EM algorithm for the ML of the parametric mixture model, fitting

$$
\, ; \, \Psi ) = \sum _ { i = 1 } ^ { b } \pi _ { i } \, f _ { i } ( y _ { j } ; \theta _ { i } ) ,
$$

to an observed random sample; v = (u{ ,

$$
( 2 . 1 8 )
$$

is the vector containing all the unknown parameters in this mixture model and € is the vector containing all the parameters in 01, 0g known a priori

The log likelihood for $\Psi$ that can be formed from the observed data is given by

$$
\log L ( \Psi ) & = \sum _ { j = 1 } ^ { n } \log f ( y _ { j } ; \Psi ) \\ & = \sum _ { j = 1 } ^ { n } \log \{ \sum _ { i = 1 } ^ { g } \pi _ { i } f _ { i } ( y _ { j } ; \theta _ { i } ) \} .
$$

Computation of the MLE of $ by direct consideration of this likelihood function requires solving the likelihood equation, log

$$
\partial \log L ( \Psi ) / \partial \Psi = 0 .
$$

$$
\hat { \pi } _ { i } = \sum _ { j = 1 } ^ { \infty } \tau _ { i } ( y _ { j } ; \hat { \Psi } ) / n \quad ( i = 1 , \dots , g )
$$

and

where

$$
\sum _ { i = 1 } ^ { j } \sum _ { j = 1 } ^ { j } \tau _ { i } ( y _ { j } ; \hat { \Psi } ) \partial \log f _ { i } ( y _ { j } ; \hat { \theta } _ { i } ) / \partial \xi = 0 ,
$$

$$
\tau _ { i } ( y _ { j } ; \Psi ) = \pi _ { i } \, f _ { i } ( y _ { j } ; \theta _ { i } ) / \sum _ { h = 1 } ^ { y } \pi _ { h } \, f _ { h } ( y _ { j } ; \theta _ { h } )
$$

$$
\overline { h = 1 }
$$

is the posterior probability that %j belongs to the ith component of the mixture; see McLachlan and Krishnan (1997, Section 1.4) for further details.

These manipulations were carried out by various researchers in the past in their efforts to solve the likelihood equation for mixture models with specific component densities as, for example; by Hasselblad (1966, 1969), Wolfe (1965, 1967, 1970), and (1969). observed in their special cases that the equations (2.21) (2.22) in the right-hand side of these equations, a new estimate can be computed for $\Psi$, which in turn can be substituted into the right-hand side of these equations to produce a new of the likelihood equation can be identified with the direct application of the EM algorithm of Dempster et al. (1977) for finding solutions of the likelihood equation. The application of the EM algorithm to the mixture problem automatically reveals the iterative scheme to be followed for the computation of the MLE. Furthermore; it ensures that the likelihood values increase monotonically . Prior to the appearance of the paper by Dempster et al. (1977), various researchers did note the monotone convergence of the likelihoodsequences produced in their particular applications, but were only able to speculate on this monotonicity holding in general. and Day They

<a id="sec-2-8-2"></a>

# 2.8.2 Formulation as an Incomplete-Data Problem

As already discussed in Section 1.9, within the formulation of the mixture problem in the EM framework, the observed-data vector

$$
y =
$$

is viewed as incomplete; as the associatedcomponent-label vectors, 21, are not available. arisen from one of the components of the mixture model (2.17) being fitted, $z_j$ is a 9-dimensional vector with = 1 or 0, not arise from the ith component of the mixture (i = 1, g; j = 1, n) The complete-data vector is therefore declared to be being Zij

$$
y _ { c } = ( y ^ { T } , z ^ { T } ) ^ { T } ,
$$

where The addition of the unobservable data to the problem (here the $z_j$) is handled by the E-step, which takes the conditional expectation of the complete-data log likelihood, value specified initially for ". Then on the first iteration of the EM algorithm, the E-step requires the computation of the conditional expectation of Lc(v) given y, log log

$$
z = ( z _ { 1 } ^ { T } , \dots , z _ { n } ^ { T } ) ^ { T }
$$

The component-label vectors 21, Zn are taken to be the realized values of the random vectors Z1, Zn, where, for independent feature data, it is appropriate to assume that are distributed unconditionally according to the multinomial distribution (1.18). This assumption means that the distribution of the complete-data vector Yc implies the appropriate distribution for the incomplete-data vector Y. The complete-data likelihood for $\Psi$, they log log

$$
\log L _ { c } ( \Psi ) = \sum _ { i = 1 } ^ { g } \sum _ { j = 1 } ^ { n } z _ { i j } \{ \log \pi _ { i } + \log f _ { i } ( y _ { j } ; \theta _ { i } ) \} .
$$

<a id="sec-2-8-3"></a>

# 2.8.3 E-Step

The EM algorithm is applied to this problem by treating the zij as missing data. It proceeds iteratively in two steps, E (for expectation) and M (for maximization)

$$
= E _ { \Psi ^ { ( 0 ) } } \{ \log L _ { c } ( \Psi ) \ | \ y \} .
$$

The expectation operator E has the subscript to explicitly convey that this expectation is the kth EM iteration. As the complete-data likelihood, Lc(v), is linear in the unobservable data the E-step (on the (k + 1)th iteration) simply requires the calculation of the current conditional expectation of Zij given the observed data y, where Zij is the random variable corresponding to Now being log log Zij'

where; corresponding to (2.23),

$$
\ = \ \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) ,
$$

$$
\tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) \ = \ \pi _ { i } ^ { ( k ) } f _ { i } ( y _ { j } ; \theta _ { i } ^ { ( k ) } ) / f ( y _ { j } ; \Psi ^ { ( k ) } )
$$

for i 9; j = 1, The quantity $\tau_i(y_j; \Psi)$ bility that the jth member of the sample with observed value %; belongs to the ith component of the mixture. (2.28), we have on taking the conditional expectation of (2.26) given y that proba Using

$$
= \sum _ { i = 1 } ^ { j } \sum _ { j = 1 } \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) \{ \log \pi _ { i } + \log f _ { i } ( y _ { j } ; \theta _ { i } ) \} .
$$

$$
\overline { i = 1 } \, \overline { j = 1 }
$$

<a id="sec-2-8-4"></a>

# 2.8.4 M-Step

The M-step on the (k + 1)th iteration requires the global maximization of Q(%; the finite mixture model; the updated estimates 7(\*+1) of the mixing proportions $\tau_i$ are calculated independently of the updated estimate &(k+1) of the parameter vector € containing the unknown parameters in the component densities.

If the zij were observable, then the complete-data MLE of $\tau_i$ would be given simply by

$$
\hat { \pi } _ { i } = \sum _ { j = 1 } ^ { n } z _ { i j } / n \quad ( i = 1 , \dots , g ) .
$$

As the E-step simply involves replacing each zi3 with its current conditional expecgiven by replacing each in (2.31) by $\tau_i$($y_j$; Zij

$$
\pi _ { i } ^ { ( k + 1 ) } = \sum _ { j = 1 } ^ { n } \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) / n \quad ( i = 1 , \dots , g ) .
$$

Thus in forming the estimate of $\tau_i$ on the (k + 1)th iteration; there is a contribution from each observation V; equal to its (currently assessed) posterior probability of membership of the ith component of the mixture model. This EM solution therefore has an intuitively appealing interpretation.

Concerning the of € on the M-step of the (k + 1)th iteration; it can be seen from (2.30) that is obtained as an appropriate root of

$$
\sum _ { i = 1 } ^ { y } \sum _ { j = 1 } ^ { k } \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) \partial \log f _ { i } ( y _ { j } ; \theta _ { i } ) / \partial \xi = 0 .
$$

One nice feature of the EM algorithm is that the solution of (2.33) often exists in closed form, as is to be demonstrated for the normal mixture model in Section 3.2

The E- and M-steps are alternated repcatedly until the difference

$$
L ( \Psi ^ { ( k + 1 ) } ) -
$$

changes by an arbitrarily amount in the case of convergence of the sequence of likelihood values {L(ø(\*)) }. Dempster et al. (1977) showed that the (incompletedata) likelihood function L(v) is not decreased after an EM iteration; that is, small

$$
( 2 . 3 4 )
$$

for k = 0, 1,2, Hence convergence must be obtained with a sequence of likelihood values that are bounded above. Dempster et al. (1977) also showed that if saddle point. A detailed account of the convergence properties of the EM algorithm in general setting has been given by Wu (1983), who addressed, in particular; the problem that the convergence of convergence of to a Further details may be found in the monograph of McLachlan and Krishnan (1997) on the EM algorithm. point

Titterington (1984a) developed a recursive algorithm for data that are available sequentially . More recently for the same situation, Jorgensen ( 1999) has considered a recursive algorithm for the estimation of the proportions when the component densities are specified. mixing

<a id="sec-2-8-5"></a>

# 2.8.5 Assessing the Implied Error Rates

Ganesalingam and McLachlan (19806) and Basford McLachlan (1985a) considered a measure of strength of the clustering implied by the MLE < in terms of the and fitted posterior probabilities of component membership $\tau_i(y_j; \Psi)$. For example; ifthe maximum of that the clusters are well separated. proposed estimates of the error rates of the outrightclustering obtained by assigning the observed data point U; tothe component to which it has the greatest (estimated) posterior probability of belonging. As noted in Section 1.14 on the identifiability of mixture models, there are g! permutations of the component labels for a mixture of g component densities belonging to the same parametric family. Therefore in speaking about the error rates of the clustering of the mixture model-based approach, it is implicitly assumed that the clusters correspond appropriately to the 9 external groups assumed to exist for the purpose of defining the error rates The overall error rate can be assessed by the average of the maximum of the component-posterior probabilities over the data; and the bootstrap can be used to correct for bias; see McLachlan and Basford (1988, Chapter 5) for details. $\tau_i$($y_j$; They

<a id="sec-2-9"></a>

# 2.9 FITTING MIXTURES OF MIXTURES

In the past, discriminant analysis was frequently carried out for continuous data by taking the group-conditional densities to be normal. However, these days the flexibility of normal mixture models is increasingly exploited by modeling the group-conditional densities by normal mixture densities (McLachlan and Gordon; 1989) More recently, Hastie and Tibshirani (1996) have exploited the flexibility of normal mixtures by proposing a discriminant rule where the group-conditional densi ties are modeled as finite mixtures of normal homoscedastic components. Also; Streit and Luginbuhl (1994) have considered normal mixtures for the group-conditionaldistributions in the training of probabilistic neural networks by maximum likelihood; see also Yiu; Mak, and Li (1999) being

In a typical application of discriminant analysis, there are classified data from each group (so-called training data) from which t0 estimate the group-conditional densities. If the latter are modeled as mixtures; then the estimation of a given groupconditional density can be undertaken by fitting a mixture model to the data from that group, the EM algorithm as described above. using

However, in some applications; thecomponent densities for a group may have some parameters in common with the component parameters for another group. As mentioned above; in the approach of Hastie and Tibshirani(1996),the normal component densities for the groups all have the same covariance matrix. In some applications; the component densities may have more than common scale parameters. For example; in the case study of Belbin and Rubin (1995), the density for the reaction time $Y_j$ for a schizophrenic subject is modeled by the normal mixture, log

$$
f ( y _ { j } ; \Psi _ { 1 } ) = \pi _ { 1 1 } \, \phi ( y _ { j } ; \, \mu _ { 1 1 } , \sigma ^ { 2 } ) + \pi _ { 1 2 } \, \phi ( y _ { j } ; \, \mu _ { 1 2 } , \sigma ^ { 2 } ) ,
$$

reaction time for a nonschizophrenic subject (assumed to have a normal distribution with variance 02) . log

In such situations, we can implement the E-step (on the (k 1)th iteration) by still carrying out separately the E-step for the of a mixture model to the data fitting from each group to give the Q-function specific t0 each group, Q;(Wi; % where now %; denotes the vector of parameters in the ith mixture model for the ith group (i =1, M), and M denotes the number of groups.

To perform the M-step, we consider the maximization of a combined Q-function given by

$$
\sum _ { i = 1 } ^ { M }
$$

where $ is the vector VM known a to be distinct. priori

<a id="sec-2-10"></a>

# 2.10 MAXIMUM A POSTERIORI ESTIMATION

The EM algorithm is easily modified to produce the maximum a posteriori (MAP) estimate in a Bayesian framework for some density p(") for $\Psi$. The E-step is effectively the same as for the computation of the MLE of % in a frequentist frameThe M-step differs augmented by the density; 'p(v) prior log prior

TheMAP estimate of Vcan be used as an initial value for Vin posterior simulations for $\Psi$ (Gelman and Rubin, 1996) Also, Rubin and Wu (1997) have argued that the use of the EM algorithmor its variants is a wise first step for solidcomputing involving the simulation of posterior distributions. Firstly, it gives a rough picture of the posterior distribution at a lower cost than the Gibbs sampler. Secondly; the monotone iterates of the (incomplete-data) likelihood are effective detectors for seemingly inevitable programming errors, and thus help to ensure clean code for the EM algorithm; which can then be translated into the code for the Gibbs sampler in astraightforward manner. Thirdly, the results from the EM algorithm and the Gibbs sampler can be checked with each other to assess the normality of the posterior distribution and also to detect possible programming errors.

The relationship between the EM algorithm and the Gibbs sampler has been examined recently in Sahu and Roberts (1999).

<a id="sec-2-11"></a>

# 2.11 AN AITKEN ACCELERATION-BASED STOPPING CRITERION

The stopping criterion usually adopted with the EM algorithm is in terms of either the size of the relative change in the parameter estimates or the likelihood, Lindstrom and Bates (1988) emphasize; this is a measure of lack of progress but not of actual convergence. Böhning et al. (1994) have exploited Aitken's acceleration procedure in its application to the sequence of log likelihood values to provide a useful estimate of the limiting value. It is applicable in the case where the sequence of likelihood values {4(_) } is linearly convergent to some value /_ where here for log log As log brevity of notation Under this assumption;

$$
l ^ { ( k ) } = \log L
$$

$$
( 2 . 3 5 )
$$

for all k and some a (0 < a < 1): Equation (2.35) can be rearranged to give

$$
l ^ { ( k + 1 ) } - l ^ { ( k ) } \approx ( 1 - a ) ( l ^ { * } - l ^ { ( k ) } )
$$

for all k. It can be seen from (2.36) that, if a is very close to one, a small increment in the likelihood, /(k+1) to /\* log

From (2.36), we have that

$$
l ^ { ( k ) } - l ^ { ( k - 1 ) } )
$$

for all k\_ Just as Aitken's acceleration procedure can be applied to accelerate the be applied to obtain the corresponding result for the limit /\* of the sequence of log

$$
l ^ { * } = l ^ { ( k ) } + \frac { 1 } { ( 1 - a ) } ( l ^ { ( k + 1 ) } - l ^ { ( k ) } ) .
$$

Since a is unknown; it has to be estimated in (2.38) for example, by the ratio of successive increments ,

$$
a ^ { ( k ) } = ( l ^ { ( k + 1 ) } - l ^ { ( k }
$$

This leads to the Aitken accelerated estimate of /\*\_

$$
l _ { A } ^ { ( k + 1 ) } = l ^ { ( k ) } + \frac { 1 } { ( 1 - a ^ { ( k ) } ) } ( l ^ { ( k + 1 ) } - l ^ { ( k ) } ) .
$$

In applications where the primary interest is on the sequence of likelihood values rather than the sequence of parameter estimates, Böhning et al. (1994) suggest the EM algorithm can be stopped if log

$$
| \, l _ { A } ^ { ( k + 1 ) } - l _ { \, } ^ { ( 0 ) }
$$

where tol is the desired tolerance. An example concerns the resampling approach (McLachlan, 1987) to the problem of assessing the null distribution of the likelihood ratio test statistic for the number of components in a mixture model. The criterion (2.39) is applicable for any likelihood sequence that is linearly convergent. log

<a id="sec-2-12"></a>

# 2.12 STARTING VALUES FOR EM ALGORITHM

<a id="sec-2-12-1"></a>

# 2.12.1 Specification of an Initial Parameter Value

As explained in Section 2.8, the EM algorithm is started from some initial value of 4, Hence in practice we have to specify Recently, Seidel, Mosler, and Alker (2000a) have demonstrated different starting strategies and stopping rules can lcad to quite different estimates in the context of mixtures of exponential components via the EM algorithm; see also Seidel, Mosler, and Alker (2000b). how fitting

As convergence with the EM algorithm is slow; the situation will be exacerbated by a poor choice of Indeed, in some cases where the likelihood is unbounded on the edge of the parameter space, the sequence of estimates the EM algorithm may diverge if vo) is chosen too close to the boundary. This matter is to be discussed further in Section 3.8 in the case of normal mixture models. Another problem with mixture models is that the likelihood equation will usually have multiple roots corresponding to local maxima, and so the EM algorithm should be applied from a wide choice of starting values in any search for all local maxima

In the absence of the observed value of any known consistent estimator ofv or any other information; an obvious choice for the root of the likelihoodequation is the one corresponding to the largest of the local maxima located (excluding so-called spurious local maximizers) , although it does not necessarily follow that this choice defines the sequence of roots of the likelihood equation that is consistent and asymptotically efficient (Lehmann, 1980, p. 234). This point and the identification of spurious local maximizers is tobe considered further in Section 3.IOinthe context of normal mixture models with unrestricted covariance matrices

For independent data in the case of mixture models, the effect of the E-step is to the posterior probabilities of component membership. Hence an alternative approach is to perform the first E-step by specifying a value 70) for 4) for each j (j = 1, n) where update

$$
, \tau _ { g } ( y _ { j } ; \Psi
$$

is the vector containing the 9 posterior probabilities of component membership for Uj. The latter is usually undertaken by setting = n, where

$$
z ^ { ( 0 ) } = (
$$

defines an initial partition of the data into 9 groups. For example; an ad hoc way of initially partitioning the datain the case of, say; amixtureof g = 2normalcomponents with the same covariance matrices would be to plot the data for selections of two of the p variables, and then draw a line that divides the bivariate data into two groups that have a scatter that appears normal.

For higher-dimensional data, an initial value z(0) for z might be obtained through the use of some clustering algorithm, such as k-means or, say; an hierarchical procedure if n is not too large.

<a id="sec-2-12-2"></a>

# 2.12.2 Random Starting Values

Another way of specifying an initial partition z(0) of the data is to randomly divide the data into g groups corresponding to the g components of the mixture model. That is, for each observation %j, we randomly generate an integer between 1 and g, both inclusive. If this random integer is equal to one for i = h and equal to zero for i # h (i = 1, equal

Usually; the EM algorithm would be applied from a number of random starts With random starts, the effect of the central limit theorem tends to have the component parameters initially being similar at least in large samples. One way to reduce this effect is to first select asmall random subsample from the data; which is then randomly assigned to the 9 components. The first M-step is then performed on the basis of the subsample. The subsample has to be sufficiently large to ensure that the first M-step is able to produce a nondegenerate estimate of the parameter vector $\Psi$. For example; in the of a mixture of p-dimensional normal components with unrestricted covariance matrices; there needs to be at least (p + 1) observations assigned to each component to ensure nonsingular estimates of the component-covariance matrices on the first M-step. fitting

An alternative method of specifying random start, at least in the context of

where y is the sample mean and

$$
, \mu _ { g } ^ { ( 0 ) } \stackrel { i . i . d . } { \sim } N ( \bar { y } , V ) ,
$$

$$
Y = \sum _ { j = 1 } ^ { n } ( y _ { j } - \overline { y } ) ( y _ { j } - \overline { y } ) ^ { T } / n
$$

is the sample covariance matrix of the observed data. With this method, there is with a random partition of the data into 9 groups, and it is also computationally less demanding.

The component-covariance matrices $Z_j$ and the mixing proportions F; can be specified as

$$
\Sigma _ { i } ^ { ( 0 ) } = V \text { and } \pi _ { i } ^ { ( 0 ) } = 1 / g \quad ( i = 1 , \dots , g ) .
$$

As illustrated in McLachlan and Basford ( 1988, Section 3.2 ) a key factor in the of a mixture model is the accuracy of the estimate of the vector of the mixing proportions. For univariate mixtures Fowlkes (1979) suggested the determination of the point of inflection in quantile-quantile (Q-Q) plots to estimate first the mixing proportions of the underlying populations. The remaining parameters can then be estimated from the sample partitioned into groups in accordance with the estimates of the mixing proportions. fitting

![image 6](mclachlan2000_images/imageFile6.png)

<a id="sec-2-12-3"></a>

# 2.12.3 Example 2.2: Synthetic Data Set 1

To illustrate the use of random starting values, we consider the of six normal components with unrestricted covariance matrices to an artificial data set (Synthetic Data Set 1), as described in McLachlan ad Peel (1996). It consists of 204 bivariate observations. In Figure 2.1 we have plotted the (asymptotic) 95% ellipsoids fitting

$$
T _ { \Sigma _ { i } ^ { ( 1 ) ^ { - 1 } } ( \mathfrak { y } ) }
$$

for each component i after the first M-step, corresponding to a random assignment of all the data to the 9 components. Here X?;.95 denotes the 95th percentile of the chi-squared distribution with p degrees of freedom. It can be seen that there is a high degree of overlap between these first iterates of the estimated component densities.

100

100

2.1 Plot of the (asymptotic) 959 ellipsoids for each component after the first M-step; corresponding to a random assignment of all the data. Fig.

In Figure 2.2 we give the corresponding plot, but where now the estimates of the component densities on the first M-step are based on a random assignment of a subsample of size n, 60 of the full data set of n = 204 observations.

100

2.2 Plot of the (asymptotic) 95% ellipsoids for each component after the first M-step; corresponding to a random assignment of a subsample of the data set. Fig.

![image 7](mclachlan2000_images/imageFile7.png)

(a)

<a id="sec-2-12-4"></a>

# 2.12.4 Deterministic Annealing EM Algorithm

Recently; Ueda and Nakano (1998) considered adeterministic annealing EM (DAEM) choice of starting value. proposed using the principle of maximum entropy and They the statistical mechanics analogy whereby parameter () is introduced with 1/8 corresponding to the 'temperature in an annealing sense; see also Yuille, Stolorz; and Utans (1994). With their DAEM algorithm; the E-step is effected by averaging the complete-data likelihood over the distribution taken to be proportional to that of the current estimate of the conditional density of the complete data (given the observed data) raised to the power ß. In the present context of the fitting of finite mixtures to independent data, it means that the current estimate of the posteriorof the ith component of the mixture for the jth observation Uj , T (uj; is replaced by log

$$
\{ \tau _ { i } ( y _ { j } ; \varPsi ^ { ( k ) } ) ^ { \beta } / \sum _ { h = 1 } ^ { g } \{ \tau _ { h } ( y _ { j } ; \varPsi ^ { ( k ) } ) \} ^ { \beta } \quad ( i = 1 , \dots , g ) .
$$

suggest starting with a value of ß close to zero (0 < ß < 1) and then increasing it after each EM iteration in the manner They

$$
\beta ^ { ( k + 1 ) } = c \, \beta ^ { ( k ) } ,
$$

where c is in the range 1 to 1.5, until ß(k+1) = 1. For ß near zero, the effect of each %j is almost uniform; so that the initial estimates of the posterior probabilities of component membership of the mixture are close to 1/g, producing estimates of the component densities that overlap considerably. As ß is increased toward one, In this way; Ueda and Nakano (1998) argue that the DAEM algorithm is able to recover from achoice of starting value that may be far from the true value of the parameter vector. Thus the DAEM algorithm guards against poor choice of starting value essentially by letting the estimates of the component densities on the first few iterations overlap considerably. But asimilar effect can be achieved through the use of random starting values, as described in the previous section.

To illustrate this now; we consider the simulated example in Ueda and Nakano (1998). 3 bivariate normal components with parameters as given in Table 2.2 and (asymptotic) component ellipsoids as shown in Figure 2.4. They considered a poor choice of starting value (see Table 2.2) from which the EM algorithm was unable to recover, converging t0 an inferior local maximizer; as can be seen in Figure 2.5. On the other hand, the DAEM algorithm converged to a local maximizer close to the true value of %. However, we found that if we applied the EM algorithm from only a few random starts t0 our simulated sample (we did not have access to the actual data set of Ueda and Nakano (1998)), it converged like the DAEM algorithm to a local maximizer that was close to the true value of %, as can be seen from Table 2.2 and Figure 2.6. In more recent work on this problem, Ueda et al. (2000) have proposed a split and merge version of the EM algorithm. They

Table 2.2 Initial Values and Estimates for EM and DAEM Algorithms

|          | True Values                   | Initial Values    | Estimates by DAEM                            | Estimates by EM\* (Random)                   |
| -------- | ----------------------------- | ----------------- | -------------------------------------------- | -------------------------------------------- |
| T1 T2 T3 | 0.333 0.333 0.333 0.333 0.333 | 0.344 0.342 0.333 | 0.341                                        | 0.294 0.337 0.370                            |
|          | (0 =2) (0 0) (0 2)            | (0 0) (1 0)       | (~0.050 \_1.984) (0.057 0.032) (0.050 1.994) | (~0.154 -1.961) (0.360 0.115) (~0.004 2.027) |
|          | (: 2)                         | (' %)             | 2.192 ~0.078 ~0.078 0.214                    | 1.961 ~0.016 ~0.016 0.218                    |
|          | 22)                           |                   | 1.984 ~0.088 ~0.088 0.162                    | 2.346 ~0.553 ~0.553 0.150                    |
|          | ( 2                           |                   | 1.987 ~0.042 0.215                           | 2.339 0.042 0.042 0.206                      |

Fig. 2.4 Plot of the (asymptotic) 959 ellipsoids for each component based on the true parameters specified in Ueda and Nakano (1998)

k=1

k=1o

k=20

k=30

k=4o

k=50

k=60

k=70

k=B0

k=9o

k=10o

Fig. 2.5 Plot of the (asymptotic) 95% ellipsoids for eachcomponent basedon the parameters produced by the kth M-step for various k for the EM algorithm started from parameter values specifiedin Ueda and Nakano (1998)

k=i

k=1o

k=20

k=30

k=60

k=40

k=70

k=50

k=88

Fig. 2.6 Plot of the (asymptotic) 95% ellipsoids for eachcomponent basedon the parameters produced by the kth M-step for various k for the EM algorithm using random starts.

<a id="sec-2-13"></a>

# 2.13 STOCHASTIC EM ALGORITHM

and Celeux, Chauveau; and Diebolt (1996) considered a modified version of the EM algorithm inthe context of computing the MLE for finite mixture models. called it the Stochastic EM algorithm. It is the same as the Monte Carlo EM algorithm with single replication; see McLachlan and Krishnan (1997, Section 6.3) They

With the Stochastic EM algorithm; the current posterior probabilities are used in Stochastic E-step; wherein a single draw is made from the current conditional dis tributionof z given the observed data y. Because of the assumption of independence of the complete-data observations, this is effected by conducting a draw for each j (j = 1, n). That is, a draw 2ßk) is made from the multinomial distribution with g categories having probabilities specified by

$$
\tau ( y _ { j } ; \Psi ^ { ( k ) } ) = ( \tau _ { 1 } ( y _ { j } ; \Psi ^ { ( k ) } ) , \dots , \tau _ { g } ( y _ { j } ; \Psi ^ { ( k ) } ) ) ^ { T } . \\
$$

This effectively assigns each observation %; outright to one of the g components of the mixture rather than weighting it fractionally with respect to the 9 components using the current posterior probabilities of component membership given by (2.43)

The Stochastic EM algorithm thus gives the iterative process a chance of escaping from a current of convergence to a local maximizer to other paths. This is desirable if the algorithm has been started from a poor value of the parameter vector. On the other hand, it would not be desirable if the process is near to convergence to suitable local maximizer: Thus it has been suggested that consideration be given to the ordinary version of the EM algorithm in the latter stages of the iterative process. Also; we have found that the Stochastic EM algorithm has the tendency to find unwanted spurious local maximizers; see Section 3.10. path using

<a id="sec-2-14"></a>

# 2.14 RATE OF CONVERGENCE OF THE EM ALGORITHM

We now discuss briefly some properties of the EM algorithm that are used in attempts to speed up its convergence, to provide estimates of standard errors, and to assess the number of components in the mixture model. For a detailed account of these properties; the reader is referred to McLachlan and Krishnan (1997).

<a id="sec-2-14-1"></a>

# 2.14.1 Rate Matrix for Linear Convergence

The EM algorithm implicitly defines a mapping % + M(v), from the parameter

$$
( k = 0 , 1 , 2 , \dots ) .
$$

converges to some of the algorithm; that is,$\* must satisfy point

$$
\Psi ^ { * } = M ( \Psi ^ { * } ) .
$$

a Taylor series expansion of =y we have in a neighborhood of $\* that [k+1) By point

$$
\Psi ^ { ( k + 1 ) } - \Psi ^ { * } \approx J ( \Psi ^ { * } ) ( \Psi ^ { ( k ) } - \Psi ^ { * } ) ,
$$

where J(v) is the d x d Jacobian matrix for M(v) = having (r, s)th element Jr,(w) equal to

$$
J _ { r s } ( \Psi ) = \partial M _ { r } ( \Psi ) / \partial \Psi _ { s } ,
$$

Chapter 3).

Thus; in a neighborhood of $ the EM algorithm is essentially a linear iteration with rate matrix J(w*) , since J(w* ) is typically nonzero. often referred to as the matrix rate of convergence, or simply the rate of convergence.

For vector $\Psi$, a measure of the actual observed convergence rate is the global rate of convergence, which is defined as

$$
r = \lim _ { k \geq \infty } \| \Psi ^ { ( k + 1 ) } - \Psi ^ { ( k + 1 ) } \|
$$

where |l|l is any norm on d-dimensional Euclidean space Rd . It is well known that under certain regularity conditions,

r = the largest eigenvalue of J(v) . Amax

In practice, r is typically assessed as

$$
r = \lim _ { k \to \infty } \| \Psi ^ { ( k + 1 ) } - \Psi ^ { ( k ) } \| / \| \Psi ^ { ( k ) } - \Psi ^ { ( k - 1 ) } \| .
$$

<a id="sec-2-14-2"></a>

# 2.14.2 Rate Matrix in Terms of Information Matrices

$$
( 2 . 4 7 )
$$

= which will be the case with standard complete-data then @(k+1) point

$$
( 2 . 4 8 )
$$

where Ic($Y_j$ u) is the conditional expected complete-data matrix defined by (1.49) and where

$$
- E _ { \Psi } \{ \partial ^ { 2 } \log k ( Y _ { c } \, | \, $y_j$ \Psi ) / \partial \Psi \partial \Psi ^ { T } \, | \, y \}
$$

is the expected information matrix for $\Psi$ based on yc (or equivalently, the unobservable data) when conditioned on y, and k(yc $y_j$ %) is the conditional density of Yc given y. This result was obtained also by Sundberg (1974).

Thus the rate of convergence ofthe EM algorithmis given by the largest eigenvalue u) , which measures the propor tion of information about V that is missing by not also observing the "missing' data (the component-label vectors 21, 2n in the present context of mixture models), in addition to y. The greater the proportion of missing information, the slower the rate of convergence.

The rate of convergence of the EM algorithm can be expressed equivalently in terms of the smallest cigenvalue of

$$
\mathcal { I } _ { c } ^ { - 1 } ( \Psi ^ { * } ; y ) I ( \Psi ^ { * } ; y ) .
$$

This is because we can express J(v\* ) also in the form

$$
( 2 . 5 0 )
$$

where Id denotes the d x d identity matrix.

As to be discussed in Section 6.8.5, Windham and Cutler (1992) based a test for the number of components in mixture model on the smallest eigenvalue of Their motivation is that, heuristically; a large value of this small est eigenvalue is suggestive of a good clustering of the data, whereas a small value is not.

<a id="sec-2-15"></a>

# 2.15 INFORMATION MATRIX FOR MIXTURE MODELS

One initial criticism of the EM algorithm was that it does not automatically provide an estimate of the covariance matrix of the MLE, as do some other procedures, such as Newton-type methods. A number of methods have since been proposed for via the EM algorithm. Most of these methods are based on the observed information matrix I(#; y), which is defined by (1.48) For independent data, I(#; u) can be approximated without additional work beyond the calculations used to compute the MLE in the first instance.

<a id="sec-2-15-1"></a>

# 2.15.1 Direct Evaluation of Observed Information Matrix

As explained in Section 2.4, it is common in practice to estimate the inverse of the Hence we shall consider in the following subsections a number of ways for calculating or approximating I("; y) the computation of the MLE ~. However, analytical evaluation of the second-order derivatives of the log likelihood, most mixture models, in particular for multivariate data. Indeed, often itis for reasons of this nature that the EM algorithm is used to compute the MLE in the first instance. log

<a id="sec-2-15-2"></a>

# 2.15.2 Extraction of Observed Information Matrix in Terms of the Complete-Data Likelihood Log

Louis (1982) showed that I(%; u) the negative of the Hessian of the incomplete-data log likelihood, can be expressed in the form

$$
\begin{array} { r l r } { I ( \Psi ; y ) } & { = } & { \mathcal { I } _ { c } ( \Psi ; y ) - c o v _ { \Psi } \{ S _ { c } ( Y _ { c } ; \Psi ) \, | \, y \} \\ & { = } & { \mathcal { I } _ { c } ( \Psi ; y ) } \\ & { \quad } & { F \left ( S _ { c } ( Y _ { c } , \Psi ) S _ { c } ^ { T } ( Y _ { c } , \Psi ) \, | \, y \right ) } \end{array}
$$

$$
+ S ( $y_j$ \Psi ) S ^ { T } ( $y_j$ \Psi ) .
$$

In (2.52), S($y_j$ ") and Sc(Yc; %) denote the incomplete-data and complete-data score

statistics; as defined by (1.46) and (1.47), respectively. It can be shown that

From (2.53), the observed information matrix I(#) can be computed as

$$
( 2 . 5 3 )
$$

$$
( 2 . 5 4 )
$$

since the last term on the right-hand side of (2.52) is zero as satisfies

$$
S ( $y_j$ \Psi ) = 0 .
$$

Hence the observed information matrix for the original (incomplete-data) problem can be computed in terms of the conditional moments of the gradient and curvature of the complete-data likelihood function introduced within the EM framework . log

The calculation of Ic(#; y) is readily facilitated by standard complete-data com putations if the complete-data density belongs to the regular exponential family; since then

$$
( 2 . 5 5 )
$$

<a id="sec-2-15-3"></a>

# 2.15.3 Calculation of Score Statistic

It can be seen from expression (2.54) for the observed information matrix I(û; v) that it requires, in addition to the code for the E- and M-steps; the calculation of the conditional (on the observed data y) expectation of the complete-data informatranspose. An illustration of the use of the result (2.54) to calculate the observed information matrix is given in McLachlan and Krishnan (1997, Section 4.25) for a mixture of two univariate normal densities with known common variance. But for more complicated mixture models, thecalculation of the observed information matrix via (2.54) would be algebraically tedious. Hence we now consider some practical methods for approximating the observed information matrix.

In the present case of ii.d. data, an approximation to the observed information matrix is readily available without any additional analyses having to be performed.

The likelihood, log log

$$
\log L ( \Psi ) = \sum _ { j = 1 } ^ { n } \log L _ { j } (
$$

where

$$
L _ { j } ( \Psi ) = f ( y _ { j } ; \Psi )
$$

isthe likelihood function for vformed from the singleobservation $y_j$ (j = 1, n) We can now write the score vector S($y_j$ ") as

$$
S ( $y_j$ \Psi ) = \sum _ { j = 1 } ^ { n } s ( \frac { \theta ( \cdot ) } { \theta ( 1 - 1 ) } )
$$

where

$$
\epsilon \partial \log H
$$

The expected information matrix I(w) can be written as

where

$$
( 2 . 5 6 )
$$

$$
i ( \Psi ) \ & = \ E _ { \Psi } \{ s ( $Y_j$ \Psi ) s ^ { T } ( $Y_j$ \Psi ) \} \\ & = \ c o v _ { \Psi } \{ s ( $Y_j$ \Psi ) \}
$$

is the information contained in a single observation. Corresponding to (2.57), the empirical information matrix (in a single observation) can be defined to be

$$
\iota ( \Psi ) & \ = \ n ^ { - 1 } \sum _ { j = 1 } ^ { n } s ( y _ { j } ; \Psi ) a ^ { T } ( y _ { j } ; \Psi ) - \delta s ^ { 2 } \\ & = \ n ^ { - 1 } \sum _ { j = 1 } ^ { n } s ( y _ { j } ; \Psi ) s ^ { T } ( y _ { j } ; \Psi ) \\ & - n ^ { - 2 } S ( $y_j$ \Psi ) S ^ { T } ( $y_j$ \Psi ) ,
$$

where

$$
\overline { 8 } = n ^ { - 1 } \sum _ { j = 1 } \beta ( 8 ( 1 - 1 ) )
$$

Corresponding to this empirical form (2.58) for i("), I(v) is estimated by

$$
\begin{array} { r l r } { \varphi ( n ; g ) \colon } & { = } & { \bar { n } ( \varphi ) } \\ & { = } & { \sum _ { j = 1 } ^ { n } s ( y _ { j } ; \varphi ) s ^ { T } ( y _ { j } ; \varphi ) } \\ & { \quad - n ^ { - 1 } S ( $y_j$ \varphi ) S ^ { T } ( $y_j$ \varphi ) . } \end{array}
$$

On evaluation at

$$
( 2 . 6 0 )
$$

used commonly in practice to approximate the observed information matrix I(#; v) . Further justification of the use of the empirical information matrix may be found in McLachlan and Krishnan (1997, Section 4.3). It follows from the result (2.53) that

$$
\{ \partial \log L _ { c j } ( \Psi ) / \partial \Psi | y \} ,
$$

where ;(V) is the complete-data likelihood formed from the single observation Uj (j = 1, n) Thus the approximation Ie(#; y) to the observed information matrix I(#; v) can be expressed in terms of the conditional expectation ofthe gradient vector of the complete-data likelihood function evaluated at the MLE $\hat{\Psi}$. It thus avoids the computation of second-order partial derivatives of the complete-data likelihood. log log

For finite mixture models,

$$
\log L _ { c j } = \sum _ { i = 1 } ^ { y } z _ { i j } \{ \log \pi _ { i } + \log f _ { i } ( y _ { j } ; \theta _ { i } ) \} \quad ( j = 1 , \dots , n ) ,
$$

that

$$
s ( y _ { j } ; \Psi ) = \sum _ { i = 1 } ^ { j } \tau _ { i } ( y _ { j } ; \Psi ) \partial \{ \log \pi _ { i } + \log f _ { i } ( y _ { j } ; \theta _ { i } ) \} / \partial \Psi \ \ ( j = 1 , \dots , n ) .
$$

Thus with the use of the empirical information matrix for the of mixture models, the observed information matrix is approximated solely in terms of the gradient of the complete-data likelihood, where the unobservable component-label variables $z_j$ are replaced by their fitted conditional expectations, that is, by the posterior probabilities of component membership of the mixture evaluated at the MLE for €. If only the mixing proportions are unknown; then the observed information matrix is exactly equal to the empirical information matrix . fitting log

<a id="sec-2-15-4"></a>

# 2.15.4 Supplemented EM Algorithm

The methods presented in the previous section are applicable only to iid. data: For the general case, and Rubin (1989, 1991) define a procedure that obtains a numerically stable estimate of the asymptotic covariance matrix of the EM-computed estimate, only the code for computing the complete-data covariance matrix, the code for the EM algorithm itself, and the code for standard matrix operations. Meng using In particular; neither likelihoods; nor partial derivatives of log likelihoods need to be evaluated.

The basic idea is to use the fact that the rate of convergence is governed by the fraction of the missing information to find the increased variability due to missing information to add to the assessed complete-data covariance matrix . Meng and Rubin (1991) refer to the EM algorithm with their modification for the provision of the asymptotic covariance matrix as the Supplemented EM algorithm; see McLachlan and Krishnan (1997, Section 4.5) for further details.

<a id="sec-2-15-5"></a>

# 2.15.5 Conditional Bootstrap Approach

We shall shortly describe the full bootstrap approach to the approximation of the covariance matrix of the MLE &, but we first mention the conditional bootstrap approach of Diebolt and Ip (1996) for approximating the observed information matrix As warn, Efron (1994) has pointed out that the supplemented EM method of Meng and Rubin (1991) and the empirical information-based method of Meilijson (1989) are basically delta methods; and so will often underestimate the standard errors. Their method may also be subject to the same kind of warning. they

From (1.49) and (2.54), the observed information matrix I(#; v) can be expressed as

$$
( 2 . 6 3 )
$$

which requires computing the conditional expectations of two quantities over the conditional distribution of the component-indicator vectors 21, zn, given the observed data y =

Diebolt and Ip (1996) proposed approximating the conditional expectations of these two quantities by averaging them over B independent bootstrap samples;

$$
( z _ { 1 b } ^ { * } , \dots , z _ { n b } ^ { * } ) ^ { T } \ \ ( b = 1 , \dots , B )
$$

where 2;6 is distributed according to a multinomial distribution consisting of one draw with g categorics having probabilities

$$
( j = 1 , \dots
$$

In their empirical studies involving the EM algorithm and its stochastic version, found that their method (with B = 100 bootstrap replications) gave similar results matrix . they

<a id="sec-2-16"></a>

# 2.16 PROVISION OF STANDARD ERRORS

<a id="sec-2-16-1"></a>

# 2.16.1 Information-Based Methods

One way of obtaining standard errors of the estimates of the parameters in a mixture model is to approximate the covariance matrix of $ by the inverse of the observed information matrix, which can be computed as discussed in the previous section. Another information-type method is to adopt the approach of Dietz and Böhning (1996), which is based on the result that in samples from models for which the log likelihoodis quadratic in the parameters, the likelihoodratio and Wald's tests for the significance of an individual paramcter are equivalent; so that the deviance change (that is, twice the change in the likelihood) on omitting that variable is equal to the square of the t-statistic (that is, is equal to the square of the ratio of the parameter estimate to its standard error) . Thus the standard error can be calculated as the absolute value of the parameter estimate divided by the square root of the deviance change. This requires the of a set of reduced models in which each variable is omitted from the final version of the model. large regular log fitting

Liu (1998) recently considered arelated approximation tothe observed information and hence to the asymptotic variance of the MLE of a parameter; He extended his result to the multiparameter case using the fact that the covariance matrix of a normal distributioncan be obtained from its one-dimensional conditional distributions whose sample spaces span the sample space of the joint distribution.

It is important to emphasize that estimates of the covariance matrix of the MLE based on the expected or observed information matrices are guaranteed to be valid inferentially only asymptotically. In particular for mixture models; it is well known that the sample size n has to be very large before the asymptotic theory of maximum likelihood Hence weshall now consider a resampling approach; the bootstrap, to this problem. Basford et al. (1997a) and Peel (1998) compared the bootstrap and information-based approaches for some normal mixture models. found that unless the sample size was very the standard errors found by an informationbased approach were too unstableto be recommended. In such situations the bootstrap approach is recommended. applies. They large,

<a id="sec-2-16-2"></a>

# 2.16.2 Bootstrap Approach to Standard Error Approximation

The bootstrap was introduced by Efron (1979), who has investigated it further in a series of articles; see Efron (1982), Efron and Tibshirani (1993), Davison and Hinkley (1997), Chernick (1999), and the references therein. Over the past twenty years, the bootstrap has become one of the most developments in statistics. Hence there now exists an extensive literature on it. popular

The bootstrap is a powerful technique that permits the variability in a random quantity to be assessed using just the data at hand. distribution is formed from the observed datay: Conditional on the latter; the sampling distribution of the random quantity of interest with F replaced by F defines its socalled bootstrap distribution; which provides an approximationto its true distribution:

It is assumed that F has been so formed that the stochastic structure of the model has form; andit must be approximated by Monte Carlo methods whereby pseudo-random samples (bootstrap samples) are drawn from Ê . In recent times there have been a number of papers written on improving the efficiency of the bootstrap computations withthe latter approach. Ifaparametric form is adopted for the distribution function of Y, where V denotes the vector of unknown parameters, then the parametric bootstrap uses an estimate formed from y in place of y. That is, if we write F as signify its dependence on %, then the bootstrap data are generated from F = Fv

Standard error estimation of # may be implemented according to the bootstrap as

Step 1. A cording to Â, an estimate of the distribution function of Y formed from the original observed data y. That is, in the case where y contains the observed values of arandom sample of size n, y\* consists of the observed values of the random sample

$$
Y _ { 1 } ^ { * } , \dots , Y _ { n } ^ { * } \stackrel { i . i . d . } { \sim } \hat { F } ,
$$

where the estimate F (now denoting the distribution function of a single observation $Y_j$) is held fixed at its observed value.

Step 2 The EM algorithm is applied to the bootstrap observed data y to compute the MLE for this data set,

The bootstrap covariance matrix of $ is given by Step

$$
c o v ^ { * } ( \hat { \Psi } ^ { * } ) = E ^ { * } [ \{ \hat { \Psi } - E ^ { * } ( \hat { \Psi } ) \} \{ \hat { \Psi } ^ { * } - E ^ { * } ( \hat { \Psi } ^ { * } ) \} ^ { T } ] ,
$$

where E denotes expectation over the bootstrapdistribution specified by

The bootstrap covariance matrix can be approximated by Monte Carlo methods. Steps (1) and (2) are repeated independently a number of times (say, B) to give B indepen dent realizations of $ denoted by 1, B Then (2.65) can be approximated by the sample covariance matrix of these B bootstrap replications to give

$$
\text {cov} ^ { * } ( \hat { \Psi } ^ { * } ) \approx \sum _ { b = 1 } ^ { B } ( \hat { \Psi } _ { b } ^ { * } - \overline { \hat { \Psi } } ^ { * } ) ( \hat { \Psi } _ { b } ^ { * } - \overline { \hat { \Psi } } ^ { * } ) ^ { 2 } / ( B - 1 ) ,
$$

where

$$
\overline { \hat { \Psi } } ^ { * } = \sum _ { b = 1 } ^ { B } \hat { \Psi } ^ { * } / B .
$$

The standard error of the ith element of € can be estimated by the positive square root of the ith diagonal element of (2.66). It has been shown that 50 to 100 bootstrap replications are generally sufficient for standard error estimation (Efron and Tibshi rani, 1993). The above results on the number of replications to be used are based on the unconditional coefficient of variation of the Monte Carlo approximation. Recently, Booth and Sarkar (1998) argued that the conditional coefficient of variation should be used, which indicates that approximately 800 replications are required for this purpose. They have given a simple formula for determining a lower bound on the number of bootstrap replications required to approximate ad-dimensional covariance matrix .

In 1 of the above algorithm; the nonparametric version of the bootstrap would take F to be the empirical distribution function formed from the observed data y Given that we are concerned here with ML estimation in the context of a parametric model for the mixture distribution of Yj, we would tend to use the parametric version of the bootstrap instead of the nonparametric version\_ Situations where we may still wish to use the latter include problems where the observed data are censored or are missing in the conventional sense. In these cases the use of the nonparametric bootstrap avoids having to postulate a suitable model for the underlying mechanism that controls the censorship or the absence of the data. Step

The EMMIX software (McLachlan et al., 1999) has the provision for the bootstrap to be implemented parametrically or nonparametrically. Also; the weighted bootstrap (Newton and Raftery, 1994) can be used. It is a gencralization of the nonparametric

$$
w _ { 1 } y _ { 1 } , \dots , w _ { n } y _ { n } ,
$$

where the weights wj are nonnegative and sum to n. For sampling with replacement with the nonparametric bootstrap; the w; are nonnegative integers that sum to n, as wj is a count of the number of times that the original point V; occurs in the bootstrap sample. That is, w1, wn have a multinomial distribution consisting of n draws on n categories with equal probabilities 1/n.

Asdiscussed in Section 1.14 onthe identifiability of amixture model,if the component densities of the mixture belong to the same parametric family; then the likelihood does not change under a permutation of the component labels in the parameter $\Psi$ and hence its MLE $\hat{\Psi}$. This raises the question of whether the so-called label switchproblem occurs in the generation of the bootstrap replications of the MLE, as in Monte Carlo Markov chain computations involving mixture models. However; in OUr experience it has not arisen; as we always take the MLE % calculated from the original data to be the initial value of the parameter in applying the EM algorithm to each bootstrap sample. In the parametric application of the bootstrap; ? corresponds to the true value of the parameter, and so it should be a reasonable starting value. ing

<a id="sec-2-17"></a>

# 2.17 SPEEDING UP CONVERGENCE

<a id="sec-2-17-1"></a>

# 2.17.1 Introduction

The other common criticism that has been leveled at the EM algorithm is that its convergence can be quite slow. We shall therefore consider some methods that have been proposed for accelerating the EM algorithm in the context of mixture models. However; methods to accelerate the EM algorithm do tend to sacrifice the simplicity it usually enjoys.

As remarked by Lange (1995b),it is likely that no acceleration method can match the stability and simplicity of the unadorned EM algorithm. This has essentially been the case in gencral up to now. However, recently there have been some promising developments on modifications to the EM algorithm that up its performance without sacrificing the simplicity and stability that it enjoys. These new versions of the EM algorithm are called the Incremental EM (IEM), the Sparse EM (SPEM), and the Lazy EM. We shall consider these algorithms in Chapter 12, where we also present the approach of Moore (1999), using multiresolution kd-trees to up the conventional EM algorithm; and the work of Bradley, Fayyad, and Reina (1999) on scaling the EM algorithm to large databases. speed speed

The methods discussed below are applicable for a given specification of the complete data. There are also methods that approach the problem of speeding up conver gence in terms of the choice of the missing data in the specification of the completedata problem in the EM framework. These methods include the expectation-conditional maximization either (ECME) algorithm of Liu and Rubin (1994), the alternating ECM (AECM) algorithm of Meng and van Dyk (1997), and the parameter-expanded use of the ECME and AECM algorithms in the of mixtures of t components and mixtures of factor analyzers. We shall delay our discussion of them until where are first used\_ fitting they

<a id="sec-2-17-2"></a>

# 2.17.2 Louis' Method

The most commonly used method for EM acceleration is the multivariate version 4 as k 4 0. Then as demonstrated in McLachlan and Krishnan (1997, Section 4.7), we can express % as

$$
\varPsi & \quad \approx \quad \varPsi ^ { ( k ) } + \sum _ { h = 0 } ^ { \infty } \{ J ( \varPsi ^ { * } ) \} ^ { h } ( \varPsi ^ { ( k + 1 ) } - \varPsi ^ { ( k ) } ) \\ & = \quad \varPsi ^ { ( k ) } + \{ I _ { d } - J ( \varPsi ^ { * } ) \} ^ { - 1 } ( \varPsi ^ { ( k + 1 ) } - \varPsi ^ { ( k ) } ) ,
$$

as the power series

$$
\sum _ { \hbar { = } 0 } ^ { \infty } \{
$$

has all its eigenvalues between 0 and 1.

The multivariate version of Aitken's acceleration method suggests trying the sequence of iterates A where v(+1) is defined by

$$
- 1 ( \Psi _ { E M A } ^ { ( k + 1 ) } - \Psi _ { A } ^ { ( k ) } ) , & & ( 2 . 7 0 )
$$

where Hence this method proceeds on the (k + 1)th iteration by first producing EMA using an EM iteration with as the current fit for $\Psi$. One then uses the EM iterate EMX in Aitken's acceleration procedure (2.70) to yield the final iterate +1) on the (k + 1)th iteration. This is the method proposed by Louis (1982) for speeding up the convergence of the EM algorithm:

Louis (1982) suggests making use of the relationship (2.50) to estimate

$$
\Psi _ { A } ^ { ( k + 1 ) } = \Psi _ { A } ^ { ( k ) } + \Gamma ^ { - 1 } ( \Psi _ { A } ^ { ( k ) } ; \, y ) \mathcal { I } _ { c } ( \Psi _ { A } ^ { ( k ) } ; \, y ) ( \Psi _ { E M A } ^ { ( k + 1 ) } - \Psi _ { A } ^ { ( k ) } ) .
$$

As cautioned by Louis (1982), the relationship (2.71) is an approximation useful only local to the MLE, and so it should not be used until some EM iterations have been performed. As noted by Meilijson (1989), the use of (2.71) is approximately equivalent to the Newton-Raphson algorithm to find a zero of the (incompletedata) score statistic Sly; 4) using

<a id="sec-2-17-3"></a>

# 2.17.3 Quasi-Newton Methods

Meilijson (1989) and Jamshidian and Jennrich (1993) note that the accelerated sequence (2.70) as proposed by Louis (1982) is precisely the same as that obtained by applying the Newton-Raphson method to find a zero of the difference

$$
\delta ( \Psi ) = M ( \Psi ) - \Psi ,
$$

where M is the map defined by the EM sequence; see McLachlan and Krishnan On further ways to approximate {Id J(v4))} for use in (2.70), Meilijson (1989) suggests using symmetric quasi-Newton updates. However; as cautioned by Jamshidian and Jennrich (1993),these will not work, as {Ia - J(v)} is in general not symmetric.

Lange (1995b) used the EM gradient algorithm that he proposed in Lange (1995a) to form the basis of a quasi-Newton approach to accelerate convergence of the EM algorithm. Recently, Jamshidian and Jennrich (1997) proposed two new methods for accelerating the EM algorithm, both based on quasi-Newton methods. demonstrated their methods in some examples that included the ML fitting of Poisson and normal mixtureslistedthe necessary derivatives needed to implement their method for these two mixture models, although the formulas for the normal mixture model are for the special caseof g = 2 normal components with acommon covariance matrix. They They

<a id="sec-2-17-4"></a>

# 2.17.4 Hybrid Methods

Various authors, including Redner and Walker (1984), propose a hybrid approach to the computation of the MLE that switches from the EM algorithm after a few iterations to the Newton-Raphson or some quasi-Newton method. The idea is to use the EM algorithm initially to take advantage of its good global convergence properties and to then exploit the rapid local convergence of Newton-type methods by switching to such a method. It can be seen that the method of Louis (1982) is a hybrid algorithmof this nature, for in effect after a few initial EM iterations, it uses the Newton-Raphson method to accelerate convergence after performing each subsequent EM iteration. Of monotonically. Hybrid algorithms have been considered also by Atkinson(1992) Heckman and Singer (1984), Atwood et al. (1996), Jones and McLachlan (1992a), and Aitkin and Aitkin (1996).

Aitkin and Aitkin (1996) have considered hybrid method that combines the EM algorithm with a modified Newton-Raphson method whereby the information matrix is replaced by the empirical information matrix; In the context of finite normal mixture models, constructed a hybrid algorithm that starts with five EM iterations before switching to the modified Newton-Raphson method until convergence or until the likelihood decreases. In the case of the latter; Aitkin and Aitkin (1996) proposed hal the size up to five times. As further steplikelihood decreases after five step-halves, the algorithm of Aitkin and Aitkin (1996) returns to the previous EM iterate and runs the EM algorithm for a further five iterations, before switching back again to the modified Newton-Raphson method. Their choice of performing five EM iterations initially is based on the work of Redner and Walker (1984), who report that, in their experience; 95 percent of the change in the likelihood from its initial value to its maximum generally occurs in five iterations. Obviously; the choice of the starting point can have a major influence on such guidelines. For example, if the EM algorithm is started from a random starting for which the component means are close together; then the EM algorithm may require a few iterations to recover from such a start before making being able to make progress. fitting they log [ving step log log point good

Aitkin and Aitkin (1996) replicated part of the study by Everitt ( 1988a)on the fitting of a mixture of two normal densities with means #1 and p2 and variances 0? and 0? in proportions $\pi_1$ and T2. Their stopping criterion was a difference in successive values of the log likelihoodof 10-5 . They found that their hybrid algorithm required 70 percent of the time required for the EM algorithm to converge, consistently over all starting values of %. They noted that the EM algorithm was impressively stable Their hybrid algorithm almost always decreased the log likelihood when the switch to the modified Newton-Raphson was first applied, and sometimes required a large number of EM controlling steps (after full step-halving) before finally increasing the log likelihood, and then usually converging rapidly to the same maximizer as with the EM algorithm: As is well known, mixture likelihoods for small sample sizes are badly behaved with multiple maxima. Aitkin and Aitkin (1996) liken the maximization of the normal mixture likelihood in their simulation studies as to the progress of a "traveler following the narrow EM up a hazardous mountain with chasms on all sides. When in sight of the summit, the modified Newton-Raphson method path leapt to the top; but when followed earlier; it caused repeated falls into the chasms, from which the traveler had to be pulled back onto the EM track:" log path

<a id="sec-2-18"></a>

# 2.18 OUTLIER DETECTION FROM A MIXTURE

<a id="sec-2-18-1"></a>

# 2.18.1 Introduction

We consider here the problem of testing whether a new observation %n+1 is an outlier of a multivariate mixture density

$$
f ( y _ { j } ; \Psi ) = \sum _ { i = 1 } ^ { j } \pi _ { i } \, f _ { i } ( y _ { j } ; \theta _ { i } ) \ \ ( j = 1 , \dots , n ) .
$$

This problem was considered recently by Wang et al. (1997) and Sain et al. (1999) in the context of determining whether an observed seismic event may be a nuclear explosion or earthquake; or some other seismic disturbance. It arose from multinational efforts to monitor the Comprehensive Test Ban which was approved by the United Nations (with India dissenting) in 1996 and which mandates worldwide ban on nuclear testing. As explained by et al. (1997), the distinguishing characteristics of small nuclear explosions are regional in nature, and so the features that characterize such events are not transportable from region to region around the world. As a consequence; no historical data on nuclear explosions are available in most locations around the world. Were such historical nuclear data available, the problem would fall in the field of discriminant analysis; see, for example, McLachlan (1992, Chapter 6). Treaty, Wang

One way to approach this problem in the absence of classified data would be to compare the new observation to each of the fitted components of the mixture in turn, forming an atypicality measure (such as the Mahalanobis squared distance) with respect to each component mean. If this measure is sufficiently large for all the components, then can be declared an outlier. This approach is described in McLachlan and Basford (1988, Section 2.7). As et al. (1997) note, with this approach there is poor control over the overall significance level, except through conservative techniques such as use of Bonferroni bounds. Un+l Un+1 Wang

<a id="sec-2-18-2"></a>

# 2.18.2 Modified Likelihood Ratio Test

Wang et al. (1997) considered the likelihood ratio test for this problem; which we shall now describe, assuming there are no classified data available. considered the calculation of the likelihood ratio statistic X for testing the null hypothesis Ho that is from the postulated mixture model for the first n observations versus the alternative hypothesis H1 that it is not\_ Lct p) denote the density of under H1. Unless ß is functionally related to %, there is only the one observation from which to estimate ß, even if the parametric form h is specified. Accordingly; Wang et (1997) took P) to be constant over its practical (finite) support. This allowed them to the constant form for the density of from the likelihood under H1, thereby giving a modified version of X given by They Yn+1 h(Un+l; Yn+l al. Yn+1 drop

$$
( 2 . 7 3 )
$$

where denotes the MLE of $ formed from the mixture likelihood for the n obser vations in y = denotes the MLE of v using y and Not surprisingly, showed asymptotically that the use of is equivalent to the test Yn+l they

In order to assess the null distribution of their modified test statistic ñ, et al. (1997) suggested using the bootstrap with either parametric or nonparametric resampling: They also suggested a computationally less burdensome method, which called the bootstrap-one method. With this approximation; only the (n + 1)th observation is resampled each time, and so the bootstrap replications of Ä are formed the same (original) values for the first n observations. Their empirical studies demonstrated that the effect of this conditioning was minimal, provided that the sample size was sufficiently Wang they using large.

<a id="sec-2-19"></a>

# 2.19 PARTIAL CLASSIFICATION

We now consider the situation where the observed data contain some observations whose component of origin is known Un , contain some data that are classified with respect to the components of the mixture model. We suppose that the data have been labeled so that V; (j = 1, m) denote the m (m < n) classified observations; that is, for these the associated componentdiscussed various models under which the classified data may have been obtained.

A situation where this may arise in practice is where the components correspond to externally existing groups; and some ofthe observed datahave been classified (without error) with respect to these groups. This covers the updating problem in discriminant analysis where a discriminant rule has been formed from the classified data and the intent is to use the subsequent unclassified data to improve the performance of the rule by forming it on the basis of the combined classified and unclassified data; see McLachlan (1992, Section 2.7).

Another example concerns improving the accuracy of learned text classifiers by augmenting a small number of classified documents with a large of unclassified documents (Nigam et al., 2000). This is significant because in many important text classification problems, obtaining the true classification of documents is expensive; whereas quantities of unclassified documents are readily available. pool large

Whatever the reason for wishing to carry out the estimation on the basis of both classified and unclassified data, it can be undertaken in a straightforward manner by maximum likelihood via the EM algorithm:. The equation (2.33) for the update in the presence of some classified data, except that we use the known value of the component-indicator variable zij instead of its currently assessed expectation $\tau_i$ 1, 9) And we make the same modification in the equation (2.32) for the update of the ith mixing proportion Ti, assuming that the classified data have been obtained by sampling from the mixture. If the classified data do not applies provide any information on the "; as, for example, where the classified data have been obtained by sampling separately from each of the groups corresponding to the components of the mixture model fitted, then the updated estimate of $\tau_i$ is given by being

$$
\pi _ { i } ^ { ( k + 1 ) } = \sum _ { j = m + 1 } ^ { n } \pi _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) / ( n - m ) .
$$

Maximum likelihood estimation is facilitated by the presence of data of known origin with respect to each component of the mixture. For example, there may be singularities in the likelihood on the edge of the parameter space in the case of component densities that are multivariate normal with unequal covariance matrices. However, no singularities will occur if there are more than p classified observations available from each component. Also, there can be difficulties with the choice of suitable starting values for the EM algorithm. But in the presence of classified data; an obvious choice of a starting is the MLE of $ based solely on the classified data; assuming there are enough classified entities from each group for this purpose. point

Recently, Cooley and MacEachern (1999) have considered the behavior of the Bayes rule as the number of unclassified observations grows without bound; see McLachlan (1975), O'Neill (1978), Lavine and West (1992), and Castelli and Cover (1996) for some previous work this problem. on

<a id="sec-2-20"></a>

# 2.20 PARTIAL NONRANDOM CLASSIFICATION

<a id="sec-2-20-1"></a>

# 2.20.1 Introduction

In some situations in practice with a partially classified training set, the classified data may not represent an observed random sample from the sample space of the feature vector. For example; in medical screening, patients are often initially diagnosed on the basis of some simple rule, for instance whether one feature variable is above or below certain threshold, corresponding to positive or negative test. Patients with a positive test are investigated further; from which their true condition may be ascertained. However, patients with a negative test may be regarded as apparently healthy and so may not be investigated further. This would be the case if a true diagnosis can be made, say; only by an invasive technique whose application would not be ethical in apparently healthy patients. In these circumstances ifonly the data of known origin were used in the estimation of the unknown parameters, then it would generally bias the results, unless appropriate steps were taken; such as truncated densities or using logistic regression (McLachlan; 1992, Chapter 8) fitting

Another approach that avoids this bias problem is to perform the estimation on the basis of all the data collected, including the data of unknown origin; by mixture model. This approach was adopted by McLachlan and Gordon (1989) in their stenosis (RAS), which is potentially curable by surgery. Another example involves the modeling of consumer credit \_ where the only information available on whether fitting loan was satisfactorily serviced or not is for a client who achieved an acceptable rating in the first instance. That is, there is no information on the subsequent loan patterns for those applicants who failed to get a loan:

<a id="sec-2-20-2"></a>

# 2.20.2 A Nonrandom Model

We now define the 'partial nonrandomclassification model as considered in McLachlan and Gordon (1989) It is supposed that a random sample is drawn from a mixture of has feature vector falling in the region R, then its true classification is determined. Thus if the feature vector falls in the region RC , the complement of Rin the feature space, it remains unclassified. We let V1 Um denote the feature vectors that are = m + 1, n) the n m unclassified feature vectors that fall in RC .

McLachlan and Gordon (1989) showed for this nonrandom partial classification model that the MLE of " is obtained by consideration of the likelihood function for Y that is applicable if the classified data had been obtained by sampling randomly from a mixture of the groups. This likelihood function Lpc(%) is given by

$$
\varPhi ) \ = \ \sum _ { i = 1 } ^ { g } \sum _ { j = 1 } ^ { m } z _ { i j } \log \{ \pi _ { i } f _ { i } ( y _ { j } ; \theta _ { i } ) \} \\ + \ \sum _ { j = m + 1 } ^ { n } \log \sum _ { i = 1 } ^ { g } \pi _ { i } f _ { i } ( y _ { j } ; \Psi ) , \quad ( 2 . 7 5 ) \\
$$

$$
\log L _ { p c } ( \Psi ) \ = \ \sum _ { i = 1 } ^ { g } \sum _ { j = 1 } ^ { m } z _ { i j } \log \{ \\ + \sum _ { j = m + 1 } ^ { n } \log \sum _ { i = m + 1 } ^ { n }
$$

where the component-indicator vectors 21, corresponding to the m classified feature observations are known

This result can also be established on noting that the missing-data mechanism is ignorable in the terminology introduced by Little and Rubin (1987). Here the missing-data mcchanism is ignorable if the "missing" component-indicator $z_j$ for an unclassified feature tive of whether $y_j$ is classified or unclassified. Obviously; this is true for the partial classification model considered here. point being

<a id="sec-2-20-3"></a>

# 2.20.3 Asymptotic Relative Efficiencies

We let 'pc denote the MLE obtained by consideration of the likelihood Lpc(4), and and be the MLEs in the totally unclassified case (m = 0) and the totally classified case (m = n), respectively. Also; we let B(yo; be the Bayes rule for the allocation of a new observation yo inthe case of two groups with univariate normal distributions having a common variance. That is, this rule will be based on the linear discriminant function.

In this univariate case, we let the region R = (K, %) be the interval in which a feature variable must fall for it to be subsequently classified in the partial nonrandom classification model introduced in the previous section. Under this model, McLach- lan and Scot (1995) derived the asymptotic relative efficiencies ARE(#pc; "c and on a partially classified sample relative to rB(yo; "c) based on a totally classified sample and the latter is the ARE of the sample rule rB(yo; ") based on totally unclassified sample relative to rB(yo; "pc) based on partially classified sample. The asymptotic relative efficiency in each case was defined in terms of the ratio of the increases in the overall error rate over the Bayes error The results are presented here in Tables 2.3 and 2.4 for various levels of the Mahalanobis distance and the threshold K in the case of equally likely groups (T1 = T2 = 0.5).

The entries for\_ efficiency of the rule formed from a completely unclassified training set. They agree with the results reported for this case in Ganesalingam and McLachlan (1978) and O'Neill (1978). as K tends to 0 The value of is, not surprisingly; quite low for A =l, representing the case of two groups with small Mahalanobis distance between them:.

Table 2.3 for Various Levels of A and K

|     | K     |       |       |       |       |       |       |
| --- | ----- | ----- | ----- | ----- | ----- | ----- | ----- |
|     | 0.5   | 1.0   | 1.5   | 2.0   | 25    | 3.0   |       |
| 10  | 20.83 | 8.39  | 5.00  |       | 1.57  | 0.80  | 0.51  |
| 1.5 | 38.18 | 18.47 | 11.55 | 7.50  | 4.79  | 3.63  | 3.24  |
| 2.0 | 64.91 | 37.37 | 23.85 | 16.37 | 12.20 | 10.59 | 10.08 |
| 2.5 | 70.44 | 62.57 | 41.81 | 30.14 | 24.21 | 22.06 | 21.40 |
| 3.0 | 95.64 | 83.84 | 63.20 | 47.43 | 39.53 | 36.74 | 35.89 |

Source: Adapted from McLachlan and Scot (1995).

Table 2.4 Asymptotic (Percentage) Efficiency of Rule rB(yo; Relative to rB(yo; Vpc) for Various Levels of A and K

|     | K     |       |       |       |       |       |       |
| --- | ----- | ----- | ----- | ----- | ----- | ----- | ----- |
|     |       | 0.5   | 1.0   | 1.5   | 2.0   | 2.5   | 3.0   |
| 1.0 | 0.51  | 2.43  | 6.04  | 10.14 | 16.37 | 32.28 | 63.63 |
| 1.5 | 3.24  | 8.48  | 17.54 | 28.06 | 43.20 | 67.59 | 89.25 |
| 2.0 | 10.08 | 15.53 | 26.97 | 42.27 | 61.59 | 82.61 | 95.16 |
| 2.5 | 21.40 | 30.38 | 34.20 | 51.18 | 71.01 | 88.38 | 96.99 |
| 3.0 | 35.89 | 37.53 | 42.81 | 56.79 | 75.68 | 90.80 | 97.69 |

Source: Adapted from McLachlan and Scot (1995).

In the case of groups that are moderately separated (A = 2), it can be seen from Table 2.3 that That is, suppose that G2 (which has mean p2 = 0) corresponds to a healthy group of patients and that G1 (with p1 = 1) corresponds to an unhealthy group. Then if a definitive diagnosis is made when the feature observation yo is more than one-halfof a relative efficiency of the rule formed under this partial (nonrandom) classification of the training feature data is moderately high. But it drops to approximately 169 if a definitive classification is made only when the feature observation is more than two standard deviations greater than the mean of the healthy group. two

Concerning the asymptotic efficiency of the rule rB(yo; #) formed from a totally unclassified sample relative to the rule rB(yo; ûpc) formed under partial nonrandom a given A, tending t0 one as K 4 At K = asymptotic efficiency ofrB(yo; relative to rB(yo; ûc), as represented in Table 2.3 by ARE(Wpc; #c) at K = 0

It can be seen from Table 2.4 that in the case of two groups not widely separated, partial nonrandom classification of the training set can considerably improve the performance of the sample linear discriminant rule over its version formed in the absence of any classification:

<a id="sec-2-21"></a>

# 2.21 CLASSIFICATION ML APPROACH

Another likelihood-based approach to clustering besides the mixture likelihood approach is what is sometimes called the classification likelihood approach. With this approach, € and the unknown component-indicator vectors 21, zn of the observed feature data 91, Un are chosen to maximize Lc(w), the likelihood for 4 formed on the basis of the so-called complete-data as introduced within the EM framework for the ML of the mixture likelihood. That is, the unknown vector 2 = (z zT)T containing the component-indicators is (reated as a parameter to be estimated of zero-one values of the elements of the unknown $z_j$, corresponding to all possible assignments of the n entities to the g components; as well as over all values of $ . In principle; the maximization process for the classification likelihood approach can be carried out for arbitrary n, since it is just a matter of computing the maximum value of situations; for example with multivariate normal component densities with unequal covariance matrices, the restriction that at least p+1 observations belong to each component is needed to avoid the degenerate case of infinite likelihood. Unless n is small, n) denotes the optimal partition of the n observations, then âij = 1 or 0, according to whether fitting along

$$
\hat { \pi } _ { i } f _ { i } ( y _ { j } ; \hat { \theta } _ { i } ) \geq \hat { \pi } _ { h } f _ { h } ( y _ { j } ; \hat { \theta } _ { h } ) \ \ ( h = 1 , \dots , g ; \, h \neq i )
$$

holds or not, where @; and î; are the MLEs of @; and Ti, respectively; for the n observations partitioned according to 21, Hence, as noted by McLachlan (1982a), a solution corresponding to a local maximum can be computed iteratively by alternating a modified version of the E-step with the same M-step; as described in Section 2.8 for the application of the EM algorithm in the mixture model (2.17). In the E-step on the (k + 1)th iteration; zij is replaced not by the current estimate of the posterior probability that the jth entity belongs to the ith component, but by one Or zero according to whether fitting

$$
\pi _ { i } ^ { ( k ) } \, f _ { i } ( y _ { j } ; \theta _ { i } ^ { ( k ) } ) \geq \pi _ { h } ^ { ( k ) } \, f _ { h } ( y _ { j } ; \theta _ { h } ^ { ( k ) } ) \ \ ( h = 1 , \dots , g ; \, h \neq i )
$$

g; j =1, n); see also McLachlan (1975) for a related approach with a partially classified sample.

A more detailed account of this approach may be foundin McLachlan and Basford (1988, Section 1.12); see also Ganesalingam and McLachlan (1980a) More recent references on the classification approach include Celeux and Govaert (1991, 1993, 1995), Banfield and Raftery (1993), and Govaert and Nadif (1996). Although the classification ML approach may provide a slightly better clustering in some situations (small samples in comparable proportions from normal groups) , this apparent superiority is more than offset by its poor performance for groups that are not widely separated or are in disparate proportions. Further, from an estimation point of view, it yields inconsistent estimates of the parameters; see Bryant and Williamson (1978, 1986), Bryant (1991) and Titterington (19846).

The classification ML approach can be shown to be equivalent t0 some commonly used clustering criteria under the assumption of normal groups with various constraints on their covariance matrices; as noted originally by Scott and Symons (1971) For example, if the mixing proportions are taken to be equal or, equivalently; separate sampling scheme is assumed for the data, then the classification ML approach with the constraint of equal covariance matrices leads to the W criterion, as originally suggested by Friedman and Rubin (1967). If the covariance matrices are further assumed to be diagonal, then it yields the trace W criterion or, equivalently, the k-means procedure. More recently; Celeux and Govaert (1995) have considered the equivalence of the classification ML approach t0 other clustering criteria under varying assumptions on the group densities.

3

