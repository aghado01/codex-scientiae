<a id="sec-mixtures-with-nonnormal-components"></a>

# Mixtures with Nonnormal Components

<a id="sec-5-1"></a>

# 5.1 INTRODUCTION

In this chapter we consider the of mixture models with nonnormal component densities . We first consider the case of mixed feature variables, where some are continuous andsome are categorical. We shall outline the use of the location model for the component densities; as in Jorgensen and Hunt (1996), Lawrence and Krzanowski (1996), and Hunt and Jorgensen (1999) fitting"

The ML of commonly used components, such as the binomial and Poisson, can be undertaken within the framework of a mixture of generalized linear models (GLMs). This mixture model also has the capacity to handle the regression case, where the random variable $Y_j$ for the jth entity is allowed to depend on the value æj of a vector æ of covariates . If the first element of æ is taken to be one, then we can specialize this model to the nonregression situation by setting all but the first element in the vector of regression coefficients to zero. fitting mean-variance relationship. This phenomenon is called overdispersion. There are occasions in data analysis where the data are underdispersed (Faddy, 1994); that is, the sample variance is smaller than that implied by the mean-variance relationship. These phenomena are also observed with the of regression models, where the mean (say; of the Poisson or the binomial distribution) is modeled as a function of some covariates. If this dispersion is not taken into account;, then these models may lead to biased estimates of the parameters and consequently incorrect inferences about the parameters (Wang, 1994; Wang et al., 1996). In this chapter, we focus on the more common case of overdispersion. fitting using Concerning mixtures for multivariate discrete data, a common application arises in latent class analyses; in which the feature variables (or response variables in a regression context) are taken to be independent in the component distributions. This latter assumption allows mixture models in the context of a latent class analysis to be fitted within the above framework of mixtures of GLMs.

One common use of mixture models with discrete data is to handle overdispersion in count data. For example, in medical research; data are often collected in the form of counts, corresponding to the number of times that a particular event of interest occurs. Because oftheir simplicity; one-parameter distributions for which the variance is determined by the mean are often used, at least in the first instance to model such data. Familiar examples are the Poisson and binomial distributions, which are members of the one-parameter exponential family. However, there are many situations where these models are inappropriate; in the sense that the mean-variance relationship implied by the one-parameter distribution being fitted is not valid . In most of these situations; the data are observed to be overdispersed; that is, the observed sample variance is larger than that predicted by inserting the sample mean into the

In work outside this chapter on mixtures of nonnormal components; we consider in Chapter 10 mixture models for inference from nonnormal univariate data arising in the context of survival or reliability analysis. In Chapter 7 we present some recent results on the of mixtures of multivariate t components; while in Chapter 11 we shall give a case study using mixtures of Kent distributions for the modeling of multivariate directional data; fitting

<a id="sec-5-2"></a>

# 5.2 MIXED CONTINUOUS AND CATEGORICAL VARIABLES

We consider now the problem of mixture model fitting

$$
\cdot ; \Psi ) = \sum _ { i = 1 } ^ { g } \pi _ { i } \, f _ { i } ( y _ { j } ; \theta _ { i } )
$$

to some data, y = where some of the feature variables are categorical. The simplest to model the component densities of these mixed feature variables is to proceed on the basis that the categorical variables are independent of each other and of the continuous feature variables, which are taken to have, say; a multivariate normal distribution. Although this seems a crude way in which to proceed, it often does well in practice as a way of clustering mixed feature data. In the case where there are data of known origin available, this procedure is known as the naive Bayes classifier. way

We can refine this approach by adopting the location model, introduced by Olkin and Tate (1961) and used in discriminant analysis initially by Chang and Afifi (1974) and Krzanowski (1975). This model has come into prominence more recently because ofits appearance in the graphical modeling of mixed variables; where it isknown as the conditional Gaussian distribution model (Whittaker, 1990; Cox and Wermuth, 1992). The location model has since been used by Jorgensen and Hunt (1996), Lawrence and Krzanowski (1996), and Hunt and Jorgensen (1999) for the of mixture models to mixed categorical and continuous variables. The identifiability of this model for mixtures has been investigated by Willse and Boik (1999). fitting =

Previously; Everitt (1988b) proposed, and Everitt and Merette (1990) studied, a model in which the categorical variables were assumed to have arisen through thresholding of unobservable continuous variables. The thresholds that define the categories are treated as extra parameters. As the likelihoodcontains multivariate normal integrals over as many variables as are thresholded with limits of integration depending on these thresholds; the procedure is only a practical proposition if the number of categorical variables is relatively small (Lawrence and Krzanowski, 1996). log

<a id="sec-5-2-1"></a>

# 5.2.1 Location Model-Based Approach

Suppose that p1 of the p feature variables in $Y_j$ are categorical, where the categorical variable takes on ma distinct values (9 = 1, p1) Then there are m = II9=1 mq distinct patterns of these p1 categorical variables. With the location model, the p1 categorical variables are replaced by a single multinomial random vari able = 1 if the realizations of the p1 categorical variables in $Y_j$ correspond to the sth pattern. associations between the original categorical variables are converted intorelationships among the resulting multinomial cell probabilities:. The location model assumes further that conditionalon = 1 and membership of the ith component of the mixture model, the distribution of the $Z_j$, which is the same for all cells s (that is, for all possible combinations of the realizations of the p1 categorical variables). This assumption of conditional normality means that ML estimation is straightforward to implement viathe EM algorithm. The expressions for the updated estimates on the M-step of the multinomial cell probabil ities and of the component means and component-covariance matrices can be given in closed form as follows. qth Any

Let pis be the conditional probability that (x") = 1 given its membership of the ith component of the mixture (s 1, m; i = 1, 9). one Or zero, according to whether one or zero, and let the continuous feature variables in U;: Then on the (k + 1)th iteration of the EM algorithm; the updated estimates are given by

$$
\pi _ { i } ^ { ( k + 1 ) } = \sum _ { \iota = 1 } ^ { m } \sum _ { j = 1 } ^ { n } \delta _ { j } \tau _ { i j } ^ { ( k ) } / n ,
$$

$$
p _ { i s } ^ { ( k + 1 ) } = \sum _ { j = 1 } ^ { n } \delta _ { j s } \tau _ { i j s } ^ { ( k ) } / \sum _ { \ell = 1 } ^ { m } \sum _ { j = 1 } ^ { n } \delta _ { j s } \tau _ { i j \ell } ^ { ( k ) } ,
$$

$$
\mu _ { i \sigma } ^ { ( k + 1 ) } = \sum _ { j = 1 } ^ { n } \delta _ { j \sigma } \tau _ { j \sigma } ^ { ( k ) } \, y _ { j } ^ { ( 2 ) } / \sum _ { j = 1 } ^ { n } \delta _ { j \sigma } \tau _ { i j \sigma } ^ { ( k ) } ,
$$

and where

$$
\overline { s = 1 } \overline { j = 1 }
$$

$$
\pi _ { i } ^ { ( k ) } p
$$

for 8 = 1, m; i = 1, 9

$$
\frac { \pi _ { i } ^ { g } \, ^ { p _ { i s } ^ { ( k ) } \, \phi ( y _ { j } ^ { ( 2 ) } ; \mu _ { i s } ^ { ( k ) } , \, 2 _ { i } ^ { ( k ) } ) } { \sum _ { h = 1 } ^ { g } \pi _ { h } ^ { ( k ) } \, p _ { h \sigma } ^ { ( k ) } \, \phi ( y _ { j } ^ { ( 2 ) } ; \mu _ { h \sigma } ^ { ( k ) } , \, \Sigma _ { h } ^ { ( k ) } ) }
$$

<a id="sec-5-2-2"></a>

# 5.2.2 Implementation of Location Model

In practice; the number of parameters with the location model approach can be if the multinomial distribution replacing the categorical variables has many cells and there are several continuous feature variables . We now outline the implementation MULTMIX program. large

taking on without loss of generality the values one or zero. Let yvj = (ys) ( 1, p). Suppose also that is independent of all the other feature variables, but that Y2; is not independent of the remaining (p 2) continuous variables. Then we partition the feature vector $\Psi$j as



(2) where u; is the subvector containing the (p 2) continuous variables. Then the ith component density of $Y_j$ is modeled as

$$
f _ { i } ( y _ { j } ) = \{ \prod _ { v = 1 } ^ { \infty } f _ { B } ( y _ { v j } ; \theta _ { v i } ) \} \phi ( y _ { j } ^ { ( 2 ) } ; \mu _ { i , \sigma } , \Sigma _ { i } ) ,
$$

where

$$
f _ { B } ( w ) = \theta ^ { w } \left ( 1 - \theta \right ) ^ { 1 - w }
$$

denotes the binomial frequency function for a zero-one variable W taking the values one and zero with denotes the mean of x{?) corresponding tothe two distinct values of the binary variable

If the preliminary fit suggests that it is unreasonable to take the two binary to be independent; then are replaced by single multinomial variable 4 cells) as in the general case described above. The conditional distribution of the subvector of continuous variables is then assumed to be normal with covariance matrix $Z_j$ and mean corresponding to (s = 1, 4) vari they

In a general situation involving categorical and continuous variables, the intent in MULTIMIX is to divide the feature vector into as many subvectors as possible that can be taken to be independently distributed. The extreme form would be to take all p feature variables to be independent and to include correlation structure where

necessary . The question of whether the correlation structure of an existing model should be expanded to include additional local associations between the variables; categorical or continuous or both, is considered formally in terms of the change in the likelihood, but informal considerations include the inspection of scatter plots and two-way tables. In contrast tothe use of the likelihoodratio test statistic, ~2 the number of components; its asymptotic null distribution with degrees of freedom equal to the difference between the two models should not give misleading results in this role where the models are nested; see Hunt and Jorgensen (1999). log log =

<a id="sec-5-3"></a>

# 5.3 EXAMPLE 5.1: PROSTATE CANCER DATA

To further illustrate the approach adopted in MULTIMIX, we report in some detail a case study of Hunt and Jorgensen (1999).

<a id="sec-5-3-1"></a>

# 5.3.1 Description of Data Set

Hunt and Jorgensen (1999) considered the clustering of patients on the basis of pretrial covariates alone for the prostate cancer clinical trial data of Byar and Green (1980), which is reproduced in Andrews and Herzberg (1985,p. 261-274) This data set was obtained from a randomized clinical trial comparing four treatments for n 506 patients with prostatic cancer grouped on clinical criteria into Stages 3 and 4 of the disease. As reported by Byar and Green (1980) 3 represents local extension of the disease without evidence of distant metastasis, while 4 represents distant metastasis as evidenced by elevated acid phosphatase; X-ray evidence, or both. Stage Stage

Hunt and Jorgensen (1999) assessed the clusters obtained by MULTIMIX in comparison with the clinicalstages; and also considered the trial outcomes for patients in different clusters. The treatments consisted of estrogen therapy at differing rates. Daily pills containing 0.0 (placebo), 0.2, 1.0, and 5.0 mg of diethylstilbestrol were administered in the four treatments. As Byar and Green (1980) noted little difference between the effects of the first two treatments and also between the effects of the last two treatments, Hunt and Jorgensen (1999) called patients in either of the first two treatments 'Untreated" and in either of the last two treatments <Treated: Twelve pre-trial covariates (see Table 5.1) were measured on each patient; seven may be taken to be continuous and four to be discrete. The one variable (SG), which could be considered either discrete or continuous, was taken to be continuous. The skewed variables, SZ (the size of the primary tumor) and AP (serum prostatic acid phatase) were transformed by using a square root and a logarithm transformation, respectively. Observations that had missing values in any of the twelve pretreatment covariates were omitted from further analysis; leaving 475 out of the original 506 observations available. they phos -

Table 5.1 Pretreatment Covariates

| Covariate                                                          | Abbreviation | Number of Levels (if Categorical) |
| ------------------------------------------------------------------ | ------------ | --------------------------------- |
| Age Weight index Performance Cardiovascular disease history rating | Age WtI PF   |                                   |
|                                                                    |              | 2                                 |
|                                                                    | HX           |                                   |
| Systolic blood pressure                                            | SBP          |                                   |
| Diastolic blood pressure                                           | DBP          |                                   |
| Electrocardiogram code                                             | EKG          |                                   |
| Serum hemoglobin                                                   | HG           |                                   |
| Size of primary tumor                                              | SZ           |                                   |
| Index of tumor stage and histolic grade                            | SG           |                                   |
| Serum prostatic acid phosphatase                                   | AP           |                                   |
| Bone metastases                                                    | BM           | 2                                 |

Source: From Hunt and Jorgensen (1999)

<a id="sec-5-3-2"></a>

# 5.3.2 Fitting Strategy under MULTIMIX

Hunt and Jorgensen (1999) fitted a two-component mixture model, using a fitting strategy that was a form of forward selcction of covariances, beginning with Model [ind], in which the p = 12 variables were taken to all be independent. Progressively local associations were added to the model by taking coarser and coarser partitions of the set of the p = 12 variables. The modifications to the current model were determined by examining correlations, scatter plots; and two-way tables within each of the two clusters formed by allocating each observation according to the current model. Table 5.2 summarizes the results of this process fitting

Table 5.2 Models and Fits

| Model  | Variable Groups           | No. of Parameters d | Likelihood +11386.265 Log |
| ------ | ------------------------- | ------------------- | ------------------------- |
| [ind]  |                           | 55                  | 0.000                     |
| [2]    | {SBP,DBP}                 | 57                  | 117.542                   |
| [3, 2] | {BM,WtL,HG} {SBP,DBP}     | 63                  | 149.419                   |
| [5]    | {BM,WtI,HG,SBP,DBP}       | 75                  | 169.163                   |
| [9]    | Complement of {PF,HX,EKG} | 127                 | 237.092                   |

Source: From Hunt and Jorgensen (1999).

When the data had been grouped into two classes following the of Model [ind], correlations between SBP and DBP of about 0.62 were observed within both of the classes . As appeared to be the strongest associations; were put fitting they they together in bivariate subvector that was taken to have a two-component bivariate normal distribution with an arbitrary covariance matrix (that is, with three parameters for each of the two components in the mixture model) . The remaining variables were taken as singleton subvectors. Thus this model labeled here as [2] has two more parameters in it.

The next group of variables chosen was the triple, BM,WtI, HG , giving a location model factor to the mixture densities, because BM is dichotomous while WtI and HG are continuous. The resultant model is denoted here by [3,2], referring to the size of the two subvectors that have more than one variable in them. Six extra parameters are introduced in this change: There are four new mean parameters, because the fitted means of WtI and HG are now specific to each level of BM within each subpopulation; and two new covariance parameters. In Model [5], these two variable groups are combined into one subvector at a cost of introducing 12 new parameters. Finally, in Model [9], all variables; apart from PF, HX, and EKG (which are still taken to be singeltons), are combined into a nine-dimensional subvector, The results are given in Table 5.2, which gives the number of parameters d and the log likelihood for each of the models.

Hunt and Jorgensen (1999) reported that the likelihoods were obtained from several initial configurations including random groupings of the observations. However, Model [9] proved to be sensitive to the choice of 'starting configuration and the greatest likelihood over four runs is shown for this model. Convergence was usually obtained after 60to 70 iterations although one run for Model [9] reached 200 iterations without converging. They noted that there was little difference between the group allocations determined by [ind], [2], [3,2], and [5], with the allocation of only four patients out of 475 changing between these models. Model [9] allocations were found to be sensitive to the initial classification and did not agree so closely with each other nor with the classifications of the more parsimonious models. A comparison of the clustering under Model [2] with the clinical grouping into Stages 3 and 4 of the disease shows one cluster with 252 3 and 21 4 patients and the other cluster with 21 Stage 3 and 181 Stage 4 patients. log Stage Stage

Hunt and Jorgensen (1999) compared the posttrial survival status of patients with their pretrial status (Stage 3 or 4) and with their two-cluster allocation implied by the two-component mixture model fitted. This information is reproduced here in Table5.3 for Model [2]. It can be seen that cluster-one membership and clinical Stage 3 status are associated with a better chance of survival. The patterns of outcomes for the 42 patients whose model and clinical classifications conflict suggest that the mixture model-based classifications are better indicators of prognosis than the clinicalcriteria used. This is especially noticeable among the "Treated" patients.

Table 5.3 Clusters and Outcomes for Treated and Untreated Patients

|                    |         | Outcome |                |              |             |
| ------------------ | ------- | ------- | -------------- | ------------ | ----------- |
| Patient Group      |         | Alive   | Prostate Death | Cardio Death | Other Death |
| Untreated Patients |         |         |                |              |             |
| Cluster            | Stage 3 | 39      | 18             | 37           | 33          |
|                    | Stage 4 | 3       |                | 3            | 3           |
| Cluster 2          | Stage 3 |         |                | 2            | 3           |
|                    | Stage 4 | 14      |                | 18           | 6           |
| Treated Patients   |         |         |                |              |             |
| Cluster            | Stage 3 | 50      | 3              | 52           | 20          |
|                    | Stage 4 | 4       | 6              | 3            | 3           |
| Cluster 2          | Stage 3 | 1       |                |              | 1           |
|                    | Stage 4 | 25      | 37             | 22           | 10          |

Source: From Hunt and Jorgensen (1999)

<a id="sec-5-4"></a>

# 5.4 GENERALIZED LINEAR MODEL

<a id="sec-5-4-1"></a>

# 5.4.1 Definition

With the generalized linear model (GLM) approach originally proposed by Nelder and Wedderburn (1972), the density of the (univariate) variable $Y_j$ has the form log

$$
\log f ( y _ { j } ; \theta _ { j } , \kappa ) = m _ { j } \kappa ^ { - 1 } \{ \theta _ { j } y _ { j } - b ( \theta _ { j } ) \} \, + \, c ( y _ { j } ; \kappa ) ,
$$

is the prior weight. As only a single random variable is considered here, the subscript j on $y_j$ for a single observation may seem superfluous, but it is used to avoid any confusion with y, which is used throughout to denote the observed sample of n observations . being being

The mean and variance of Yj are given by

$$
E ( Y _ { j } ) = \mu _ { j } = b ^ { \prime } ( \theta _ { j } )
$$

and is a member of the (regular) exponential family with natural or canonical parameter 0jThe distribution may or may not be a member of the two-parameter exponential family if k is unknown. We are using the notation h(-) for the link function instead of of components in the mixture model.

$$
v a r ( Y _ { j } ) = \kappa
$$

respectively; where the prime denotes differentiation with respect to 0;. In a GLM, it is assumed that

$$
\begin{array} { r l r } { \eta _ { j } } & = } & { h ( \mu _ { j } ) } \\ & = } & { x _ { j } ^ { T } \beta , } \end{array}
$$

a vector of covariates or explanatory variables on the jth response $y_j$, p is a vector of unknown parameters, and h(-) is a monotonic function known as

The variance of Yj is the product of two terms, the dispersion parameter K and the variance function b' (0;) , which is usually written in the form

$$
V ( \mu _ { j } ) = \partial \mu _ { j } / \partial \theta _ { j } .
$$

So-called natural or canonical links occur when n; = 0j, which are respectively the and logit functions for the Poisson and binomial distributions; see Table 2.1 in McCullagh and Nelder (1989, Chapter 2) for the canonical links, dispersion parameters, and variance functions for some commonly used univariate distributions in the exponential family; including the binomial, Poisson, gamma; inverse gamma, and normal log

In the standard form of a GLM, #j is modeled as a function ofthe unknown param eter vector ß;, assuming k fixed and with V(u;) containing no unknown parameters. Of distributions of the form (5.9), the Poisson and binomial have K = 1 (that is, fixed priori at 1) The negative binomial distribution, whose variance function can be written in the form

$$
V ( \mu _ { j } ) = \mu _ { j } + \mu _ { j } ^ { 2 } / k ,
$$

is an example of a variance function containing an unknown parameter that is not a dispersion parameter

<a id="sec-5-4-2"></a>

# 5.4.2 ML Estimation for a Single GLM Component

Suppose y1, Yn denote n independent observations; where $Y_j$ has weight n). Then the likelihood for ß is given by prior log

$$
\log L ( \beta ) = \sum _ { j = 1 } ^ { n } [ m _ { j } \kappa ^ { - 1 } \{ \theta _ { j } y _ { j } - b ( \theta _ { j } ) \} + c ( y _ { j } ; \kappa ) ] .
$$

On differentiationin (5.10) with respect to ß using the chain rule (McCullagh and Nelder; 1989, Section 2.5) the likelihood equation for ß can be expressed as

$$
\sum _ { j = 1 } m _ { j } \, w ( \mu _ { j } ) ( y _ { j } - \mu _ { j } ) \eta ^ { \prime } ( \mu _ { j } ) \, x _ { j } = 0 ,
$$

Idpj and w(u;) is the weight function defined by dnj/

$$
w ( \mu _ { j } ) = 1
$$

It can be seen that for fixed K, the likelihood equation for ß is independent of K.

The likelihood equation (5.11) can be solved iteratively using Fisher's method of scoring, which for a GLM is equivalent to using iteratively reweighted least squares (IRLS); see Nelder and Wedderburn (1972). On the (k + 1)th iteration, we form the adjusted response variable ñ; as

$$
\tilde { y } _ { j } ^ { ( k ) } = \eta ( \mu _ { j } ^ { ( k ) } ) + ( y _ { j } - \mu _ { j } ^ { ( k ) } ) \eta ^ { \prime } ( \mu _ { j } ^ { ( k ) } ) .
$$

These n adjusted responses are then regressed on the covariates using weights m1w(u{\* )) , (k+1) P, and hence updated estimates p; for the #j, for use in the right-hand side of (5.12) to update the adjusted responses, and so on This process is repeated until changes in the estimates are sufficiently small. 21, mn

<a id="sec-5-4-3"></a>

# 5.4.3 Quasi-Likelihood Approach

For all GLMs, we have the relation

$$
\partial \log f ( y _ { j } ; \theta _ { j } , \kappa ) / \partial \mu _ { j } = m _ { j } \left ( y _ { j } - \mu _ { j } \right ) / \{ \kappa V ( \mu _ { j } ) \} ,
$$

so that this first derivative depends only on the first two moments of Y. This led Wedderburn (1974) to define a quasi-likelihood approach by the relation

$$
j = m _ { j } ( y _ { j } -
$$

The use of 9 as a criterion for allows the class of GLMs to be extended to models defined only by the properties of the first two moments. The function 9 will correspond t0 a true log density if there is a distribution of the GLM type for which fitting

$$
v a r ( Y _ { j } ) = \kappa V ( \mu _ { j } ) .
$$

For a fixed value of the dispersion parameter k, the quasi-likelihood approach estimates ( by the value of ( that minimizes the sum of weighted squares

$$
\sum _ { j = 1 } ^ n m _ { j } ( y _ { j } - \mu _ { j } ) ^ { 2 } / \{ \kappa V ( \mu _ { j } ) \} .
$$

A simple moment estimate of k is obtained by the value of k that makes the mean deviance equal to one or the expected value of the Pearson statisticequal to its degrees

$$
\sum _ { j = 1 } ^ { n } m _ { j } ( y _ { j } - \mu _ { j } ) ^ { 2 } / \{ \kappa V ( \mu _ { j } ) \} = ( n - d ) ,
$$

where d is the number of parameters in the model.

In the context of allowing for extra-Poisson variation; Breslow (1984) suggested first fitting the ordinary Poisson model with k = 1 to obtain an initial estimate of Kj for use in the left-hand side of (5.15). The value of K obtained from (5.15) is then substituted into the left-hand side of (5.15) to produce a new estimate of k, and so on This process can be continued until convergence. A detailed review of the quasi likelihood approach may be found in the book of McCullagh and Nelder (1989) It is well known that this approach leads to a consistent and efficient estimate of ß; see

<a id="sec-5-5"></a>

# 5.5 MIXTURES OF GLMs

<a id="sec-5-5-1"></a>

# 5.5.1 Specification of Mixture Model

For a mixture of g component distributions of GLMs in proportions $\pi_1$, Tg, we have that the density of the jth response variable $Y_j$ is given by

$$
f ( y _ { j } ; \varPsi ) = \sum _ { i = 1 } ^ { j } \pi _ { i } f ( y _ { j } ; \theta _ { i j } , \kappa _ { i } ) ,
$$

where for a fixed dispersion parameter Ki , obtain we

$$
\log f ( y _ { j } ; \theta _ { i j } , \kappa _ { i } ) = m _ { j } \kappa _ { i } ^ { - 1 } \{ \theta _ { i j } y _ { j } - b _ { i } ( \theta _ { i j } ) \} + c _ { i } ( y _ { j } ; \kappa _ { i } )
$$

for i = 1, 9)

The of mixtures of GLMs has been considered by Jansen (1993), Wedel and DeSarbo (1995), Aitkin (1996, 1999a), Oskrochi and Davies (1997), and Scallan (1999), among others. These models have been used also in the machine learning literature, where are referred to as mixtures-of-experts (ME) models; see Jacobs et al. (1991). In Section 5.13 we shall consider an extension of them, called hierarchical mixtures-of-experts (HME). Strictly speaking, the component densities in ME and HME models need not be GLMs, but in practice generally are. fitting they they

Typically; in practice; the components of the mixture will be from the same GLM, so that the density for the ith component can be written as log

$$
\log f ( y _ { j } ; \theta _ { i j } , \kappa _ { i } ) = \kappa _ { i } ^ { - 1 } \{ \theta _ { i j } y _ { j } - b ( \theta _ { i j } ) \} + c ( y _ { j } ; \kappa _ { i } )
$$

for i = 1, 9

In some applications, the mixing proportions may be modeled as functions of some vector of covariates associated with the response. This vector of covariates may or may not have some elements in common with the vector of covariates 2 on which the component means of the mixture depend . Without loss of generality; we shall denote both of these vectors of covariates by æ (as irrelevant covariates in the regression forms for the canonical means and mixing proportions can have their coefficients set equal to zero).

A common model for expressing the ith mixing proportion $\pi_i$ as a function of æ is the logistic. Under this model, have corresponding t0 the jth observation $y_j$ with covariate vector æ; we

$$
\pi _ { i j } & \ = \ \pi _ { i } ( \mathfrak { a } _ { j } ; \alpha ) \\ & = \ \exp ( \omega _ { i } ^ { T } \alpha _ { j } ) / \{ 1 + \sum _ { h = 1 } ^ { g - 1 } \exp ( \omega _ { h } ^ { T } \alpha _ { j } ) \} \quad ( i = 1 , \dots , g ) ,
$$

and

$$
= ( \omega _ { 1 } ^ { T } ,
$$

contains the logistic regression coefficients. The first element of æ; is usually taken of unknown parameters, given by

$$
\Psi = 1
$$

where ß contains the elements of p1 to be distinct. priori

As the mixing proportions are modeled to depend on some or all of the covariates on which the canonical means depend, it means that there may be identifiability problems with some of the parameters in œ and ß, in particular with the intercept terms ofthe a and the elements of ß; sce Wang (1994). Thequestion of identifiability is to be examined more closely later in the specific cases of Poisson and binomial components.

<a id="sec-5-5-2"></a>

# 5.5.2 ML Estimation via the EM Algorithm

The likelihood for $\Psi$ that can be formed from these data under the mixture model (5.16) is given by log

$$
\log L ( \Psi ) = \sum _ { j = 1 } ^ { n } \log \sum _ { i = 1 } ^ { y } \pi _ { i j } f ( y _ { j } ; \theta _ { i j } , \kappa _ { i } ) ,
$$

where

$$
\pi _ { i j } = \pi _ { i } ( x _ { j } ; \alpha ) \ \ ( i = 1 , \dots , g ; j = 1 , \dots , n )
$$

and all weights are unity prior

The EM algorithm of Dempster et al. (1977) can be applied to obtain the MLE of 4 as in the case of a finite mixture of arbitrary distributions described in Chapter 2 The complete-data log likelihood is given by

$$
\log L _ { c } ( \Psi ) = \sum _ { i = 1 } ^ { y } \sum _ { j = 1 } ^ { n } z _ { i j } \{ \log \pi _ { i j } + \log f _ { i } ( y _ { j } ; \theta _ { i j } , \kappa _ { i } ) \} ,
$$

$$
\overline { i = 1 } \overline { j = 1 }
$$

where the zij denote the component-indicator variables as defined in Section 2.8.2.

As the E-step is essentially the same as given in Section 2.8.3 for arbitrary component densities; we move straight to the M-step.

<a id="sec-5-5-3"></a>

# 5.5.3 M-Step

The M-step on the (k + 1)th iteration involves solving the two systems of equations

and

where

$$
\sum _ { i = 1 } ^ { j } \sum _ { j = 1 } ^ { n } \tau _ { i j } ( y _ { j } ; \Psi ^ { ( k ) } ) \partial \log \pi _ { i j } / \partial \alpha = 0
$$

$$
i = 1 \, j = 1
$$

$$
( 5 . 2 3 )
$$

$$
( 5 . 2 4 )
$$

$$
j ; \Psi ^ { ( k ) } ) = \frac { \pi _ { i j } ^ { ( k ) } f _ { i } ( y _ { j } ; \theta _ { i j } ^ { ( k ) } , \kappa _ { i } ) } { \sum _ { h = 1 } ^ { g } \pi _ { h j } ^ { ( k ) } f _ { h } ( y _ { j } ; \theta _ { h j } ^ { ( k ) } , \kappa _ { h } ) } . \\
$$

It is assumed that œ and ( have no elements known a to be in common. This willoften be the case in practice. An application where this is not the case concerns the zero-inflated Poisson regression model of Lambert (1992) which is to be discussed later. priori

Equation (5.23) can be solved a standard algorithm for logistic regression to produce the updated estimate œ (k+1) for the logistic regression coefficients. For 9 = 2, 2(+1) can be computed using the GLIM macro for a binomial error structure with the canonical logit transformation as the link. using

Concerning the computation of p(k+1) , it follows from the previous section on the ML fitting of a single GLM that (5.24) can be written as

$$
\overline { i = 1 } \, \overline { j = 1 }
$$

$$
( 5 . 2 6 )
$$

If the P1, Pg have no elements in common a priori, then

$$
\begin{array} { r l } { \mathfrak { h } } & = \mathfrak { x } _ { j } , \quad i f h = i . } \\ { \mathfrak { h } } & = 0 , \quad o t h e r w i s e . } \end{array}
$$

In this case, (5.26) reduces to solving

$$
( 5 . 2 7 )
$$

separately for each (; to produce 9) . p(\*+1)

On contrasting (5.27) with (5.11), it can be seen that it has the same form as for single GLM fitted to the with prior weights m1 = mn = (yn; and fixed dispersion parameter Ki. Tin

In the general case where ß1, pg may have some elements in common, we can still solve (5.27) the iteratively reweighted least-squares approach for a sin gle GLM. The double summation over i and j in (5.26) can be handled by expanding using the response vector to have dimension 9 X n by replicating each original observation ($y_j$, æf)T g times; with prior Kg'

Although there are more efficient methods of solving (5.27), this approach has the advantage that it is easily done in a GLM program, such as GLIM (see, for instance, Aitkin et al. (1989)), the glm( function in S-PLUS (see Becker, Chambers, and Wilks (1988)),or the GLM subroutinein SAS (1993). Dietz (1992) has provided GLIM-macro for the computation of ß. Previously, Hinde (1982) provided the GLIMcode for a Poisson model and the modifications needed for the binomialmodel; see also Anderson (1988) and Aitkin (1996, 1999a, 1999b). Wang et al. (1996) have available FORTRANcodes for algorithms that fit finite mixtures of Poisson regression models . fitting

The response for each entity has been taken to be univariate in the above. The results generalize in a straightforward manner to the case of multivariate responses $Y_j$ (Y1j, if it is assumed that Ypj are independently distributed when conditioned on their component membership of the mixture model; scc Wedel and DeSarbo (1995). The case of component multivariate GLMs where Yij, Ypj are not necessarily independent has been considered by Dietz (1992) Ypi)T ,

<a id="sec-5-5-4"></a>

# 5.5.4 Multicycle ECM Algorithm

We have scen above in the computation of the updated estimate of

$$
\Psi = ( \Psi _ { 1 } ^ { T } , \Psi _ { 2 } ^ { T } ) ^ { T } ,
$$

where V1 =0 and 42 = ß, that œ(\*+1) and p(k+1) are computed independently of each other on the M-step of the EM algorithm. Therefore, the latter is the same as the expcctation-conditional maximization (ECM) algorithm with two CM-steps; where K) on the first CM-step, is calculated with %2 fixed at y and where on the

In order to improve convergence, a multicycle version of the ECM algorithm can be used, where an E-step is performed after the computationof œ (\*+1) and before the computation of p(k+1) ; see Meng and Rubin (1993) and McLachlan and Krishnan (1997) for further details of the ECM algorithm. The multicycle E-step is effected here by updating œ(k) with œ(k+1) in in the right-hand side of the expression

<a id="sec-5-5-5"></a>

# 5.5.5 Choice of the Number of Components

Up to now; we have considered the of a finite mixture of GLMs for a given value of the number of components g in the mixture model. Typically; in practice where the mixture model is used to handle overdispersion; the value of g has to be inferred from the data. A to the final choice of g can be obtained from monitoring the increase in the likelihood asgisincreased from asinglecomponent. Unfortunately; it is difficult to carry out formal tests at any stage of this sequential fitting being guide log process for the need of an additionalcomponent since; as to be explained in Chapter 6, regularity conditions fail to hold for the likelihood ratio test statistic, ~2log X, to have its usual asymptotic null distribution. There is the resampling approach of McLachlan (1987), which was used by Schlattmann and Böhning (1993) to decide on g in their application of Poisson mixtures to disease mapping- Also; Pauler et al. (1996) used this method to decide on the number of Poisson components in the finite mixture modeling of anticipatory saccade counts from schizophrenic patients and controls. In the context of the of mixtures of Poisson regression components to overdispersed count data; Wang et al. (1996) have reported encouraging results for the selection of g based on Akaike's information criterion (AIC) and the Bayesian information criterion (BIC); see also and Puterman (1999). Concerning the significance of the covariates in the mixture of GLMs, Wang et al. (1996) considered thedeletion ofcovariates from the model only after thechoiceofg had been essentially finalized . fitting Wang

<a id="sec-5-6"></a>

# 5.6 A GENERAL ML ANALYSIS OF OVERDISPERSION IN A GLM

In an extension to a GLM for overdispersion, a random effect Uj can be introduced additively into a GLM on the same scale as the linear predictor, as proposed by Aitkin (1996). This extension in a two-level variance component GLM has been considered reccntly by Aitkin (1999a) For an unobservable random effect uj forthe jth response on the same scale as the linear predictor; we have that

$$
\eta _ { j } = \beta ^ { T } x _ { j } + \sigma u _ { j } ,
$$

where $u_j$ is realization of a random variable U; distributed N(0, 1) independently of the jth response $Y_j$(j = 1, n).

The (marginal) likelihood is thus log

$$
\log L ( \Psi ) = \sum _ { j = 1 } ^ { n } \log \int _ { - \infty } ^ { \infty } f ( y _ { j } ; \beta , \sigma , u ) \phi ( u ) \, d u .
$$

The integral (5.28) does not exist in closed form except for a normally distributed Following the development in Anderson and Hinde (1988) Aitkin (1996, 1999a) suggested that it be approximated by Gaussian quadrature, whereby the integral over the normal distribution of U is replaced by a finite sum of g Gaussian quadrature mass-points u; with masses Ti; the u; and #; are given in standard references, for example, Abramowitz and Stegun (1964).

The log likelihood so approximated thus has the form for that of a g-component mixture model,

$$
\sum _ { j = 1 } ^ { n } \log \sum _ { i = 1 } ^ { y } \pi
$$

where the masses Tg correspond to the (known) mixing proportions; and the corresponding mass U1, correspond to the (known) parameter values. T1, points The linear predictor for the jth response in the ith component of the mixture is

$$
\eta _ { i j } = \beta ^ { T } x _ { j } + \sigma u _ { i } \ \ ( i = 1 , \dots , s )
$$

Hence in this formulation, u; is an intercept term.

The influential paper by Heckman and Singer (1982) showed substantial changes in parameter estimates with quite small changes in the mixing distribution. As noted by Aitkin (1996)a particular disadvantage of the modeling approach described above is the possible sensitivity of conclusions to the choice of a particular distributional form for the random effect U;; there is a lack of information in the data about this distribution. Another disadvantage is the possible inaccuracy of Gaussian quadrature, where even 20-point integration may not give high accuracy for the logisticlnormal model (Crouch and Spiegelman, 1990)

As aconsequence; Aitkin (1996, 1999a) suggested treating the masses T1, Tg as g unknown mixing proportions and treating the mass points as g unknown values of a parameter. This g-component mixture model is then fitted using the EM algorithm; as described in Section 5.5.2. The value of g is increased sequentially until the increase in the likelihood is assessed to be nonsignificant. If ß were known; then this approach would correspond to finding the nonparametric MLE of the distribution of U (the mixing distribution). The advantage of this approach is that it avoids having to specify the mixing distribution. Ul,

In this framework since now u; is also unknown; we can drop the scale parameter and define the linear predictor for the jth response in the ith component of the mixture as

$$
\eta _ { i j } = \rho
$$

Thus u; acts as an intercept parameter for the ith component. One of the u; parameters will be aliased with the intercept term ßo; alternatively; the intercept can be removed from the model.

We shall give an example of this approach with a Poisson mixture model applied to handle overdispersion in some count data in Section 5.8.3. But firstly; we take a brief look at the problem of overdispersion with the use of Poisson regression models.

<a id="sec-5-7"></a>

# 5.7 POISSON REGRESSION MODEL

<a id="sec-5-7-1"></a>

# 5.7.1 Some Standard Modifications for Overdispersed Data

We consider now the Poisson regression model. We shall briefly review some fications that can be made to it within a single-GLM framework for the modeling of overdispersed count data before proceeding to consider some methodology that can be implemented a finite mixture of GLMs modi using

The Poisson regression model is an example of a GLM in which the distribution

$$
( 5 . 2 9 )
$$

which has mean E($Y_j$) = Lj, and the natural link is the log function

$$
h ( \mu _ { j } ) \ = \ \log \mu _ { j }
$$

In (5.29), A = {0, 1, 2, . . .} is the set of nonnegative integers.

In many situations in practice, the varies for each subject so that the mean of $Y_j$ is given by ajlj, where aj denotes the known population size or time of exposure, and #; now denotes the mean rate per unit size or time. This can be dealt with in the theory and software for GLMs by either declaring a; as an offset in the specification of the linear predictor or by redefining the response to be the observed rate $y_j$ /aj, with aj specified as the weight. Hence in the sequel we shall assume without loss of generality that aj = 1 for all subjects. prior

A consequence of using the Poisson regression model is that the variance equals the mean; that is,

$$
\text {var} ( Y _ { j } ) \ = \ E ( Y _ { j } )
$$

In practice, however, we often have overdispersed data; that is,

$$
\text {var} ( Y _ { j } ) > \mu _ { j } .
$$

When Poisson regression model fits the count data poorly; overdispersion is often a cause of the problem.

There are several ways to modify the Poisson regression model. the GLM formulation; we can modify it by choosing either an alternative link function or an alternative frequency distribution; or both. Since the log link has properties such as multiplicative effects of covariates on the Poisson mean, researchers have suggested use of alternative link functions: On the other hand, there are a lot of studies of alter native frequency distributions for the Poisson distribution; see, for example; Breslow (1984), Efron (1986, 1992), and Lawless (1987). More recently; Lee and Nelder ofthe likelihood formed on the basis of the jointdistributionofthe observed responses and the unobservable random effects. Their approach thus avoids the integration in (5.28) that is neccssary with the use of the marginal likelihood. Using

<a id="sec-5-7-2"></a>

# 5.7.2 Gamma-Poisson Mixture Model

A classical approach is to use a continuous Poisson mixture model to adjust for extraPoisson variation. In this framework in the nonregression case; the Poisson mean #j is taken to be a latent variable from a distribution, H ((u;) so that the density of $Y_j$ is modeled as

$$
f ( y _ { j } ) = \int _ { 0 } ^ { \infty } \{ e ^ { - \mu } \mu _ { j } ^ { y } / y _ { j } ! \} I _ { A } ( y _ { j } ) \, d H ( \mu ) .
$$

A common choice for H(u) in (5.3O) is the gamma (œ, ß) distribution; which has density function defined by (4.16). This leads to the density of $Y_j$ modeled as being

$$
= \left ( \begin{array} { c } y _ { j } + \alpha - 1 \\ y _ { j } \end{array} \right ) \left ( \frac { \beta } { \beta + 1 } \right ) ^ { \alpha } \left ( \frac { 1 } { \beta + 1 } \right ) ^ { y _ { j } } I _ { A } ( y _ { j } ) ,
$$

which is the negative binomial distribution NB(a, BI(ß + 1)). This distribution is the model for the number of tails 9; , in independent flips of a coin with probability of heads equal to ß/(ß + 1), until one observes œ heads. On letting # now denote the mean of this distribution; we have that

$$
\mu = \alpha / \beta ,
$$

while its variance is and variance function

$$
\begin{array} { r c l } \var { u } ( Y _ { j } ) & = & ( \alpha / \beta ) \{ ( \beta + 1 ) / \beta \} \\ & = & \mu _ { j } + k \mu _ { j } ^ { 2 } , \end{array}
$$

where k = a function of the covariate vector "j. variance to be greater than the mean; with the variance equal to the mean inflated multiplicatively by the factor (1 + kuj) As k tends to zero in (5.32), we obtain the Poisson model. We can rewrite (5.31) as

$$
f ( y _ { j } ; \mu _ { j } , k ) & = \left ( \begin{array} { c c } y _ { j } + k ^ { - 1 } - 1 \\ y _ { j } \\ \mu _ { j } + k ^ { - 1 } \end{array} \right ) \left ( \frac { k ^ { - 1 } } { \mu _ { j } } \right ) ^ { k ^ { - 1 } } \left ( \frac { \mu _ { j } } { \mu _ { j } + k ^ { - 1 } } \right ) ^ { y _ { j } } I _ { A } ( y _ { j } ) . \\ 
$$

This is the standard negative binomial model for extra-Poisson variation; and it can be seen that it arises by assuming that œ is fixed as /j varies. If, however; we assume that #j varies with œ and that ß remains constant, we obtain a negative binomial distribution with

$$
v a r ( Y _ { j } ) = \mu _ { j } ( 1 + k ) ,
$$

where k = This distribution does not have the form of a standard GLM; see Nelder and Lee (1992).

For the negative binomial distribution (5.33) the MLE of $ = (g' , k)T can be obtained as described in Lawless (1987) for the linear model log

$$
\log \rho
$$

It was noted there that the results for other regression specifications are qualitatively similar.

Within the GLM framework, 4 can be estimated as described in McCullagh and Nelder (1989, Section 11.2) For fixed k, the negative binomial distribution (5.33) has the form of a GLM with canonical link

$$
\eta ( \mu _ { j } ) = \log \{ \mu _ { j } / ( \mu _ { j } + k ^ { - 1 } ) \} ,
$$

$$
V ( \mu _ { j } ) = \mu _ { j } + k \mu _ { j } ^ { 2 } .
$$

Ordinarily; k is unknown. the method of moments, it can be computed as a solution of Using

$$
\sum _ { j = 1 } ^ { n } \frac { ( y _ { j } - \hat { \mu } _ { j } ) ^ { 2 } } { \hat { \mu } _ { j } ( 1 + k \hat { \mu } _ { j } ) } = n - d ,
$$

Hence ß can be estimated by a combined quasi-likelihood and method of moments approach.

Alternatively within the GLM framework, P can be estimated by using the Poisson error function with the link function and defining the weights mj as prior log

$$
m _ { j } = ( 1 + k \dot { p }
$$

The value of k is obtained iteratively from (5.35). The initial fit is made with unit prior weights = mj

<a id="sec-5-7-3"></a>

# 5.7.3 Multiplicative Random Effects Model

Another way of viewing the gamma-Poisson mixture model (5.30) is to write the Poisson parameter as

$$
\mu _ { j } = u _ { j } \mu _ { 0 j } ,
$$

where poj is an unknown parameter and u; is a value of the random effect U; taken to have some distribution H which without loss of generality; can be assumed to have mean one. This is the multiplicative random-effects model; see Brillinger (1986) and Manton, Woodbury, and Stallard (1981)

If we take the random effect Uj to have the gamma (œ, ß) distribution with œ = we obtain the binomial distribution as given by (5.31). The mean-variance relationship (5.32) will hold for any mixing distribution H for U that has mean [ and variance k Other choices of the distribution of U include the inverse (1989), and the normal (Hinde, 1982) k-1 negative log

<a id="sec-5-7-4"></a>

# 5.7.4 Additive Random Effects Model

As seen in Section 5.6 for an arbitrary GLM, one way to handle overdispersion is to introduce a random effect U; additively on the same scale as the linear predictor. If for the link function; the distribution of exp(U;) is taken to be gamma, then it corresponds to the multiplicative random effects model given in the previous section for overdispersed Poisson data; if it has a normal distribution; then it corresponds to the normal model considered in Hinde (1982) log log

This additive random effects model leads to a finite mixture model as demonstrated in Section 5.6 for an arbitrary GLM. We shall give an example on its use in Section 5.8.3.

<a id="sec-5-8"></a>

# 5.8 FINITE MIXTURE OF POISSON REGRESSION MODELS

<a id="sec-5-8-1"></a>

# 5.8.1 Mean and Variance

We consider now the finite mixture model (5.16)of arbitrary component GLMs in the case where the component GLMs are Poisson regression models with means specified by a linear model. That is, log

$$
( 5 . 3 6 )
$$

where @;j = = and logpij nij,

$$
\eta _ { i j } & \ = \ \beta _ { i } ^ { T } \mathbf x _ { j } \\ & = \ ( \beta _ { 0 i } , \beta _ { 1 i } ^ { T } ) ^ { T } ( 1 , x _ { 2 j } , \dots , x _ { p j } ) ^ { T } \quad ( i = 1 , \dots , g ) .
$$

If we set 9 1, then we obtain the Poisson regression model; which reduces to the Poisson model if ß11 is specified as the null vector.

If we specify (1i as the null vector; we obtain the g-component Poisson mixture model .

If we set g =2 and p1j = 0 for all j, then we obtain a Poisson regression model with an extra mass at Yj =0.

For the g-component mixture (5.36) of Poisson regression models, the mean and variance of $Y_j$ are equal to

and

$$
E ( Y _ { j } ) = \sum _ { i = 1 } ^ { J } \pi _ { i }
$$

$$
\begin{array} { r l r } { v a r ( Y _ { j } ) } & { = } & { E \{ v a r ( Y _ { j } | Z _ { j } \} + v a r \{ E ( Y _ { j } | Z _ { j } \} } } \\ & { = } & { E ( Y _ { j } ) + v _ { i j } , } \end{array}
$$

respectively; where

$$
v _ { i j } = \sum _ { i = 1 } \pi _ { i } \mu _ { i j } ^ { 2 } - \left ( \sum _ { i = 1 } \pi _ { i } \mu
$$

Here

$$
= \exp ( \beta _ { i } ^ { T } x _ { j } ) \\
$$

is the mean of the jth response conditional on its membership of the ith component of the mixture, and Zj is the component-indicator vector of zeros and ones, where (Zj)i is one or zero, according to whether U; is viewed as having come from the ith component or not (i = 1, 9; j = 1, n) Zij

Obviously; vij = 0 if and only if

$$
\mu _ { 1 j } = \mu _ { 2 j } = \cdots = \mu _ { g }
$$

Hence the mixture model is able to cope better than the one-component (homogeneous) model with excess variation among Yn .

<a id="sec-5-8-2"></a>

# 5.8.2 Identifiability

In order to be able to estimate %, we require the mixture to be identifiable; that is, two sets of parameters which do not agree after permutation cannot yield the same mixtures of Poisson distributions is identifiable. As noted by Wang et al. (1996), a sufficient condition for the class of Poisson regression mixtures to be identifiable is that the matrix (21, "n) be of full rank. Wang et al. (1996) also considered the residual analysis and goodness-of-fit statistics for this class of mixture regression models.

Applications of mixtures of Poisson regression models to biological data sets are given in et al. (1996), who used this methodology to analyze epileptic seizure frequency and Ames salmonella \_ data; see Wedel et al. (1993) for an application in marketing. Wang assay

<a id="sec-5-8-3"></a>

# 5.8.3 Example 5.2: Fabric Faults Data Set

We report the analysis by Aitkin (1996), who fitted a Poisson mixture regression model to the data set on fabric faults, as discussed previously by Hinde (1982) and Nelder (1985). The response variable is the number of faults %; in a bolt of fabric of The data from Hinde (1982) are reproduced in Table 5.4.

Table 5.4 Fabric Data

| Length of Roll | Number of Faults | Length of Roll | Number of Faults |
| -------------- | ---------------- | -------------- | ---------------- |
| 551            | 6                | 543            | 8                |
| 651            |                  | 842            | 9                |
| 832            |                  | 905            | 23               |
| 375            |                  | 542            | 9                |
| 715            |                  | 522            | 6                |
| 868            |                  | 122            | 1                |
| 271            | 5                | 657            | 9                |
| 630            | 7                | 170            |                  |
| 491            |                  | 738            | 9                |
| 372            |                  | 371            | 14               |
| 645            |                  | 735            |                  |
| 441            | 8                | 749            | 10               |
| 895            |                  | 495            | 7                |
| 458            |                  | 716            | 3                |
| 642            |                  | 952            | 9                |
| 492            |                  | 417            | 2                |

Source: From Aitkin (1996).

Initially; Aitkin (1996) fitted the Poisson model = gave a deviance of 64.54 with 30 degrees of frcedom; and parameter estimates (stan -= 4.173 (1.135), ß1 = 0.997 (0.176) Thus proportionality log

(ß1 = 1) is obviously well supported, but the residual deviance shows substantial overdispersion. The deviance for the negative binomial model was 54.09. the approach discussed in Section 5.6 for handling overdispersion in a GLM, Aitkin (1996) subsequently fitted the g-component Poisson mixture model (5.36) for g = 2 to 6, where Using

$$
( i = 1 , \, .
$$

where the component GLMs (here Poisson components) differ in their intercepts with the introduction of the u;. Since either the regression intercept ßo or one of the intercepts u; is redundant, Aitkin (1996) effectively fitted the model without ßo and then took

$$
i = 1
$$

so that the estimated intercepts û; are centered to allow direct comparison with the simple Poisson and Poisson/normal models.

The results of these fits for 9 = 2 and 3 are given in Table 5.5. The standard computed using the method described in Section 2.16.1. It can be seen from Table 5.5 that clearly only 9 = 2 components are needed in the Poisson mixture model.

Table 5.5 Results of Fitting Mixtures of Poisson Regression Models

| 9   | ßo     | (SE)    | 01      |          |         | Deviance |
| --- | ------ | ------- | ------- | -------- | ------- | -------- |
| 2   | ~2.979 | 0.800   | 0.609   | ~0.156   |         | 49.364   |
|     |        | (0.201) | (0.203) | (0.797)  |         |          |
| 3   | ~2.972 | 0.799   | 0.611   | ~0.154   | ~0.165  | 49.364   |
|     |        | (0.201) | (0.202) | (0.711 ) | (0.087) |          |

Source: Adapted from Aitkin (1996).

The posterior probabilities of membership of the first component of the mixture are shown with the standardized residuals from the ordinary Poisson fit in Table 5.6.

The posterior probability increases almost monotonically with the residual, with only five observations having a posterior probability of more than 0.5 of being in component I; these observations have standardized residuals 1 255, 2.530, 3.541, 1.773 and 3.946. Thus component one contains the observations with large positive residuals; these are "downweighted" in their effect on the fitted model by the intercept term û1 = 0.609 compared with û2 = ~0.156 for the second component with small positive; or negative; residuals.

Table 5.6 Posterior Probabilities of First Component Membership from the Poisson Mixture Model, and Pearson Residuals from the Poisson Model

| Probability | Residual | Probability | Residual |
| ----------- | -------- | ----------- | -------- |
| 0.0102      | 0.806    | 0.0496      | ~0.071   |
| 0.0007      | 1.880    | 0.0044      | ~1.039   |
| 0.6887      | 1.255    | 0.9903      | 2.530    |
| 0.4476      | 1.397    | 0.1019      | 0.283    |
| 0.4349      | 0.976    | 0.0142      | ~0.672   |
| 0.0016      | ~1.408   | 0.0506      | ~0.626   |
| 0.1237      | 0.443    | 0.0305      | ~0.292   |
| 0.0091      | ~0.815   | 0.2065      | 0.886    |
| 0.0423      | ~0.155   | 0.0129      | ~0.641   |
| 0.1540      | 0.579    | 0.9750      | 3.541    |
| 0.0036      | ~1.198   | 0.8604      | 1.773    |
| 0.1456      | 0.516    | 0.0244      | ~0.388   |
| 0.9998      | 3.946    | 0.0404      | ~0.176   |
| 0.0065      |          | 0.0002      | ~2.375   |
| 0.0739      | 0.098    | 0.0014      |          |
| 0.0044      | ~1.260   | 0.0023      | ~1.715   |

Source: From Aitkin (1996)

<a id="sec-5-8-4"></a>

# 5.8.4 Components and Mixing Proportions Without Covariates

Böhning, Schlattmann; and Lindsay (1992, 1998) have provided an excellent account of the use of Poisson mixture models where the mixing proportions and the components do not depend on any covariates. also gave several examples of applications of the Poisson mixture model in medical problems; see also Lindsay (1995). Albert (1991), Le, Leroux, and Puterman (1992), and Leroux and Puterman (1992) have presented examples in the context of modeling epileptic seizure counts and fetal movements by Poisson mixtures where the assumption of independence of the data has been relaxed, as in hidden Markov chain models to be discussed in Chapter 13. They

In the absence of covariates, we can write the Poisson mixture model as

where In the work up to now; we have effectively considered the estimation of the mixing by considering the so-called nonparametric MLE (NPMLE) of H, Â, which is the probability measure that maximizes

$$
\begin{array} { r l } { \Psi ) } & { = } & { \sum _ { i = 1 } ^ { g } \pi _ { i } f ( y _ { j } ; \mu _ { i } ) } \\ & { = } & { \int f ( y _ { j } ; \theta ) \, d H ( \theta ) , } \end{array}
$$

$$
f ( y _ { j } ; \theta ) = \{ e ^ { - \theta } \theta ^ { y _ { j } } / y _ { j } ! \} I _ { A } ( y _ { j } )
$$

$$
\iota ( H ) = \sum _ { j = 1 } ^ { n } \log \int f ( y _ { j } ; \theta ) \, d H ( \theta ) ,
$$

where H(0) is now allowed to be any mixing distribution. As discussed in Section 1.12, Lindsay (1983) showed that HI is a discrete measure with at most a finite number of support points; see also Lindsay (1995) and Lindsay and Roeder (1992a), who have considered residual diagnostics for mixture models.

<a id="sec-5-8-5"></a>

# 5.8.5 Algorithms for NPMLE of a Mixing Distribution

Böhning et al. (1992, 1998) have provided the computer package CAMAN (Com puter-Assisted Mixture Analysis) for computing Â . It includes an algorithmic menu with choices of the EM algorithm; the vertex exchange algorithm; a combination of both, as well as the vertex direction method. The package C.AMAN has the option to work with fixed support size; that is, when the number of components is known priori. In the latter case, the EM algorithm is used. The C.A.MAN program can handle also component distributions that include the normal and exponential. In the former case; the variance has to be specified in the flexible support case; see Böhning et al. (1992, 1998) for further discussion of this. More recently; Böhning (1995) has reviewed reliable algorithms for the ML of mixture models; see also Böhning (1999) fitting ~

<a id="sec-5-8-6"></a>

# 5.8.6 Disease Mapping

Poisson mixtures have played a very useful role in disease mapping. The analysis of the geographic variation ofdisease and its representation onamapis an important topic in epidemiological research. Identification ofhigh-risk groups provides valuable hints for possible experience and targets for subsequent analytical studies; see Schlattmann and Böhning (1993), Schlattmann; Dietz; and Böhning (1996), and Böhning (1999). A measure often used is the standardized mortality rate (SMR). For a given area, SMR; is defined as

$$
\begin{array} { r c l } \text {SMR} _ { j } & = & y _ { j } / e _ { j } \\ & = & y _ { j } / \sum _ { h } A _ { h j } \omega _ { h } , \end{array}
$$

number based on an external reference, is the person years in the hth age stratum; and w is the age-specific mortality rate, which is assumed to be known. Anj A common approach to map construction in the literature is based on the assump-= Here X denotes the relative risk of disease due to within the study area. living Schlattmann and Böhning (1993) modeled the distribution of $Y_j$ by the Poisson mixture distribution The assumption (5.38) implies that all geographical areas have the same relative risk X This homogeneous model of a single Poisson distribution is often too simple with overdispersion frequently occurring: One approach for more flexibility has been to be adopt random effects model, where X is gamma or normal; see Clayton and Kaldor (1987), Mollie and Richardson (1991), and Breslow and Clayton (1993). log

$$
f ( y _ { j } ) = \sum _ { i = 1 } ^ { s } \pi _ { i }
$$

= 1, 9) . More recently, Schlattmann et al. (1996) proposed the Poisson mixture regression model

$$
\sum \pi _ { i } f ( y _ { j } ; \mu _ { i j } )
$$

for the distribution of Yj, where

$$
\mu _ { i j } = \lambda _ { i } e _ { j } \exp ( \beta _ { i } ^ { T } x _ { j } )
$$

and æj is a vector of covariates associated with the jth region, and the parameters A; and p; are specific to the ith component of the mixture (; = 1,

<a id="sec-5-9"></a>

# 5.9 COUNT DATA WITH EXCESS ZEROS

Two-component mixture models are frequently used to model data that appear to have an excess of zeros. For example, when a reliable manufacturing process is in control, the number of defects on an should be Poisson distributed. If the Poisson mean is X, the expected number of items without defects is ne -X In practice, however, there than expected. One possible explanation is that slight; unobserved changes in the environment cause the process to swerve randomly back and forth between a perfect state in which defects are impossible or at least extremely rare and an imperfect state in which defects are possible but not inevitable; see Lambert (1992). The transient perfect state increases the number of zeros in the data. item

In a medical context, a 'possible explanation for the excess of zeros might be due to the fact that the patient is cured after the treatment andso no realization ofthe symptom monitored will occur. This phenomenon can be handled by a two-component mixture where one of the components is taken to be a degenerate distribution; having mass at $y_j$ = 0. The other component is a Poisson (or binomial) regression model, depending on the situation. Amixture model of this type with adegenerate component being is sometimes referred to as a nonstandard mixture model. A detailed account of the use of nonstandard mixture models in auditing may be found in the report by the Panel on Nonstandard Mixtures of Distributions (1989).

<a id="sec-5-9-1"></a>

# 5.9.1 History of Problem

The fascinating history of attempts to analyze count data with excess zeros by a Poisson distribution has been given recently by Meng (1997). He noted the link of the paper by McKendrick (1926), which was the earliest cited reference in Dempster et al. (1977),to the use of the EM algorithm through an improvement of McKendrick's method suggested in Irwin (1963). The data set was on an epidemic of cholera in an Indian village. The iterative solution proposed by Irwin (1963) was shown by (1997) to converge t0 the MLE obtained by a zero-truncated Poisson model via the EM algorithm. Meng fitting

As discussed in Meng (1997), an alternative model, perhaps more direct for many modern statisticians, is to fit the nonstandard mixture model,

$$
( 5 . 3 9 )
$$

where the first component is the degenerate distribution with mass one at $y_j$ and the second component is the Poisson with mean p,

$$
f _ { 2 } ( y _ { j } ; \mu ) = \{ e ^ { - \mu } \mu ^ { y _ { j } } / y _ { j } ! \} I _ { A } ( y _ { j } ) .
$$

Asdemonstrated by Meng (1997), the iterative process for the MLEof | as obtained under this nonstandard mixture model via the EM algorithm converges to the MLE as obtained (via the EM algorithm) under the zero-truncated Poisson model. However; the number of iterations of the EM algorithm is essentially tripled, a reason that in this second application of the EM algorithm; there is more data augmentation than in the first application. being key

<a id="sec-5-9-2"></a>

# 5.9.2 Zero-Inflated Poisson Regression

The model (5.39) with p depending on some covariates forms the basis of the zeroinflated Poisson (ZIP) regression technique proposed by Lambert (1992) for the han dling of zero-inflated count data with covariates; see also Yip (1988, 1991) and and Yip (1993,1995). Fong

<a id="sec-5-10"></a>

# 5.10 LOGISTIC REGRESSION MODEL

We shall briefly review some modifications that can be made to logistic regression for the modeling of overdispersed count data before proceeding to consider (finite) mixtures of this model.

For the (single-component) binomial model, the frequency function for the jth response Yj is given by

$$
f ( y _ { j } ; \theta _ { j } ) = \binom { N _ { j } } { y _ { j } } \theta _ { j } ^ { y }
$$

$$
I _ { j } - y _ { j } I _ { A _ { j } } ( y _ { j } ) ,
$$

where Aj = {0, 1, That is, the response $y_j$ denotes the number of successes in a series of N; independent Bernoulli trials on which the probability of success on each Bernoulli trial is 0; . In our notation here, we are suppressing the

In the case of logistic regression, 0; is postulated to depend on the vector æj of covariates through the logit function,

$$
^ { T } x _ { j } \ = 1 , \dots , n ) ,
$$

equivalently;

$$
\theta _ { j } = \exp ( \beta ^ { T } x _ { j }
$$

It is given within the GLM framework by taking the response variable to be $y_j$ /N;, specifying the error function to be the binomial, and using the canonical logit link.

Logistic regression is a common method for analyzing the effect of a vector of covariates on the number of successes in a series of Nj independent Bernoulli trials. Overdispersion relative to the binomial distribution may occur if the N; trials in a set are positively correlated, an important covariate is omitted, Or æj is measured with

Other link functions include the probit, which gives similar results to the logit, and the complementary log-log function; which is limited to situations where it is appropriate to deal with the probability parameter 0 in an asymmetric manner; see McCullagh and Nelder (1989) for a comparison of these link functions.

A classical approach in the case of no covariates is to use a continuous binomial mixture model ,

$$
\int _ { 0 } ^ { 1 } \binom { N _ { j } } { y _ { j } } \theta ^ { y _ { j } } ( 1 - \theta ) ^ { N _ { j } - \gamma _ { j } } I _ { A _ { j } } ( y _ { j } ) d H ( \theta ) , \\
$$

where H(0) is taken to be the beta (œ1, œ2) distribution, which has density

$$
\{ u ^ { \alpha _ { 1 } - 1 } ( 1 - u ) ^ { \alpha _ { 2 } - 1 } / B ( \alpha _ { 1 } , \alpha _ { 2 } ) \} I _ { ( 0 , 1 ) } ( u ) ,
$$

and and with either Or where

$$
B ( \alpha _ { 1 } , \alpha _ { 2 } ) = \Gamma ( \alpha _ { 1 } ) \Gamma ( \alpha _ { 2 } ) / \Gamma ( \alpha _ { 1 } + \alpha _ { 2 } ) .
$$

This leads to the bcta-binomial distribution

$$
\alpha _ { 1 } , \alpha _ { 2 } ) = \binom { N _ { j } } { y _ { j } } \{ B ( \alpha _ { 1 } + y _ { j } , \alpha _ { 2 } + N _ { j } - y _ { j } ) / B ( \alpha _ { 1 } , \alpha _ { 2 } ) \} I _ { A _ { j } } ( y _ { j } ) ; \ ( 5 . 4 3 )
$$

see Williams (1975).

If we now let 0 = a1/œ2, we have that

$$
E ( Y _ { j } ) = N _ { j } \theta
$$

$$
\text {var} ( Y _ { j } ) = N _ { j } \theta ( 1 - \theta ) \{ 1 + ( N _ { j } - 1 ) \kappa \} ,
$$

where k = (œ1 + œ2 + 1)-1

A beta-binomial regression model can be defined by postulating parametric forms for 0 and k. Applications of this type of regression model appear to have been limited mainly to the special cases of one- and two-way ANOVA designs; see McLachlan (1997).

As in the case of the Poisson distribution, a quasi-likelihood approach can be used to deal with overdispersion through the use of the binomial regression model (Williams, 1982). With this approach, only the first two moments of the distribution of $Y_j$ have to be specified . Two such specifications have

$$
E ( Y _ { j } ) = \theta _ { j }
$$

$$
( 5 . 4 5 )
$$

$$
( 5 . 4 6 )
$$

$$
\log \{ \theta _ { j } / ( 1 - \theta _ { j } ) \} = \beta ^ { T } x _ { j } \ \ ( j = 1 , \dots , n ) .
$$

As Anderson (1988) noted, it is interesting that the assumptions (5.45) and (5.46) for the first two moments of $Y_j$ are satisfied by the beta-binomial distribution (5.43) if œ1 = (1

<a id="sec-5-11"></a>

# 5.11 FINITE MIXTURES OF LOGISTIC REGRESSIONS

<a id="sec-5-11-1"></a>

# 5.11.1 Mean and Variance

We consider now the mixture of GLMs model (5.16) in the case where the component GLMs belong to the binomial family. That is, the ith component frequency function f($y_j$; @j) for the jth response $Y_j$ is given by

$$
\theta _ { i j } ) = \binom { N _ { j } } { y _ { j } } \theta _ { i j } ^ { y _ { j } } ( 1 - \theta _ { i j } ) ^ { N _ { j } - y _ { j } } I _ { A _ { j } } ( y _ { j } ) ,
$$

where Aj = {0, 1, to depend on the covariates so that

$$
\dots , n ) . \quad ( 5 . 4 8 )
$$

We consider now the mean and variance of the logistic regression mixture model

$$
\sum _ { i = 1 } ^ g \pi _ { i j } f ( y _ { j } ; \theta _ { i j } ) . } }
$$

The mean of (5.49) is

and its variance is

$$
E ( Y _ { j } ) = \sum _ { i = 1 } ^ { \ } \pi _ { i j } \theta _ { i j }
$$

$$
\begin{array} { r l } { \var { r } ( Y _ { j } ) } & { = } & { E \{ \mathbf v a r ( Y _ { j } \, | \, Z _ { j } ) \} + \mathbf v a r \{ E ( Y _ { j } \, | \, Z _ { j } ) \} } \\ & { = } & { N _ { j } ( \sum _ { i = 1 } ^ { g } \pi _ { i } \theta _ { i j } ) ( 1 - \sum _ { i = 1 } ^ { g } \pi _ { i j } \theta _ { i j } ) } \\ & { + } & { \{ ( N _ { j } - 1 ) / N _ { j } \} \mathbf v a r \{ E ( Y _ { j } \, | \, Z _ { j } ) \} , } \end{array}
$$

where

$$
\ v a r \{ E ( Y _ { j } \ | \ Z _ { j } ) \} = N _ { j } ^ { 2 } \{ \sum _ { i = 1 } ^ { j } \pi _ { i j } \theta _ { i j } ^ { 2 } - ( \sum _ { i = 1 } ^ { j } \pi _ { i j } \theta _ { i j } )
$$

For N; 1, var { E($Y_j$ $Z_j$)} =0 holdsif and only vif E($Y_j$ $Z_j$) is constant. Hence for each j (j = 1, n),

$$
\ v a r ( Y _ { j } ) = N _ { j } \left ( \sum _ { i j } \theta _ { i j } \right ) \left ( \begin{array} { c } \vdots \\ \end{array} \right )
$$

if and only if

$$
\theta _ { 1 j } = \theta _ { 2 j } = \cdots = \theta _ { g 1 }
$$

for 1 < j < n. This implies that the proposed mixture model is able to cope better than the one-component model with extra-binomial variation among Y1, Yn due to heterogeneity in the population.

<a id="sec-5-11-2"></a>

# 5.11.2 Mixing at the Binary Level

For binary data (Nj = 1), we can rewrite (5.49) as

$$
y _ { j }
$$

bution with probability parameter In the parlance of GLMs; mixing at the binary level changes the link but not the frequency function or dispersion; whereas mixing at the binomial level (N; 1) changes both the link and the frequency function and introduces overdispersion. Caution has to be exercised in using (5.49) with Nj = 1, as the model may not be identifiable without imposing some unrealistic restrictions on the covariates; see Brooks et al. (1998) have considered a mixture of a beta-binomial and a binomial in handling outlying litters in the analysis of data sets recording fetal control mortality in mouse litters.

$$
\theta _ { . j } = \sum _ { i = 1 } ^ { s } \pi _ { i j } \theta _ { i j } .
$$

This model is given within the GLM framework by still specifying the binomial as the error function; but now specifying the link function according to

$$
j \ ( j = 1 , \dots , n ) .
$$

<a id="sec-5-11-3"></a>

# 5.11.3 Identifiability

given necessary and sufficient conditions for the identifiability of the finite binomial mixture

$$
N - y _ { j } I _ { A _ { N } } ( y _ { j } ) , & & ( 5 . 5 1 )
$$

where AN = {0,1, The g-component binomial mixture model (5.51) with 0 < 0; < 1 (i = 1, 9) is identifiable if and only if

$$
g \leq \frac { 1 } { 2 } ( N + 1 ) .
$$

(1994) has considered the identifiability of the collection of logistic regression models Wang

$$
f ( y _ { j } ; \Psi ) = \sum _ { i = 1 } ^ { g } \pi _ { i j } \binom { N _ { j } } { y _ { j } } \theta _ { i j } ^ { y _ { j } } ( 1 - \theta _ { i j } ) ^ { N _ { j } - y _ { j } } I _ { A _ { j } } ( y _ { j } ) \ \ ( j = 1 , \dots , n ) ,
$$

where the Tij and the @;j are specified as functions of the covariates by (5.21) and (5.48), respectively. equal (N; N for all j) sufficient conditions for the identifiability of (5.52) are æn) is of full rank. In the case of unequal Nj, the restriction on g in these sufficient conditions is specified in terms of the minimum number of trials for all proper subsets of the observations.

Previously, Follmann and Lambert (1989, 1991) considered sufficient conditions for the identifiabilityof (5.52) in the special case where the mixing proportions are not functions of any covariates and ß1, Pg have no common elements apart from the first; that is, the logistic components differ only in their intercepts. showed that for a binary response the number of components g in the mixture must be bounded by function of the number of covariate vectors that agree except for one element; and for a binomial response, 9 must satisfy the same bound or be bounded by a function of the largest number of trials per response. They Mosiman (1962), Paul, Liang, and Self (1989), Kim and Margolin (1992), Morel and Nagaraj (1993), and Banjeree and Paul (1999), among others.

Examples on the of mixtures of logistic regressions to biological data may be found in Follmann and Lambert ( 1989,1991)and (1994), while Farewell and Sprott (1988) gave an example on the fitting of a mixture of binomial distributions. Overdispersion in the case of the multinomial distribution has been considered by fitting Wang

<a id="sec-5-11-4"></a>

# 5.11.4 Example 5.3: Beta-Blockers Data Set

We now present an example on the use of mixtures of logistic regressions from Aitkin (1999). It concerns a problem in meta-analysis; which is widely documented in an increasing number of papers; see, for example; Olkin (1995) for a recent review.

The example is the 22-center clinical trial of beta-blockers for reducing mortality after myocardial infarction; described by Yusuf et al. (1985) and analyzed in detail in Gelman et al. (1995). The data are given in Table 5.7, adapted from Gelman et al. level and patients at the lower level. There is only one explanatory variable; the treatment assignment at the lower level.

Table 5.7 Results of 22 Clinical Trials of Beta-Blockers

| Center | Control |       | Treated |       |
| ------ | ------- | ----- | ------- | ----- |
|        | Deaths  | Total | Deaths  | Total |
| 1      | 3       | 39    | 3       | 38    |
| 2      |         | 116   | 7       | 114   |
| 3      |         | 93    | 5       | 69    |
| 4      | 2       | 1520  | 102     | 1533  |
| 5      | 27      | 365   | 28      | 355   |
| 6      | 6       | 52    | 4       | 59    |
| 7      | 152     | 939   | 98      | 945   |
| 8      | 48      | 471   | 60      | 632   |
| 9      | 37      | 282   | 25      | 278   |
| 10     | 188     | 1921  | 138     | 1916  |
| 11     | 52      | 583   | 64      | 873   |
| 12     | 47      | 266   | 45      | 263   |
| 13     | 16      | 293   |         | 291   |
| 14     | 45      | 883   | 59      | 858   |
| 15     | 31      | 147   | 25      | 154   |
| 16     | 38      | 213   | 33      | 207   |
| 17     | 12      | 122   | 28      | 251   |
| 18     | 6       | 154   | 8       | 151   |
| 19     | 3       | 134   | 6       | 174   |
| 20     | 40      | 218   | 32      | 209   |
| 21     | 43      | 364   | 27      | 391   |
| 22     | 39      | 674   | 22      | 680   |

Source: From Aitkin (1999b)

Aitkin (1999b) fitted a logistic regression model with treatment as a fixed effect, ignoring the center classification. This gave a deviance of 305.76 with 42 degrees of freedom, indicating large variations in intercept (response under the standard treat- ment) among the centers. Fitting the fixed treatment model with a random intercept term and successively more components 9 gives deviances of 145.23 (g = 2),101.29 = 3), and 101.29 (g = 4) For the three-component mixture model, the fixed treatment effect estimate is 0.258 with standard error 0.050. The estimates of the random effects nearly form a symmetric three-F distribution located at the 1.61, 2.25, and 2.83, with respective masses 0.249,0.512, and 0.239. The standard deviation of the mixing distribution is 0.43, representing substantial variation on the logit scale. This distribution is quite close to a discretized normal; the mass points are located similarly to those in the three-point Gaussian quadrature analysis (which are at 0 and #vBo relative to the intercept), but the probability masses are somewhat different, 2/3 , 1/6, and 1/6 for the Gaussian model . The deviance for the three Gaussian quadrature analysis is 114.35, and the MLE of the standard deviation for the Gaussian random effect model is 0.40. point points being point Aitkin (1999) also fitted the model with the treatment effect in the random part of the model; that is, a full random slope and intercept model. This gave a deviance of 99.12, which is a reduction of only 2.17 for the two additional parameters relative to the fixed treatment model. The three-component solution has component (intercept; slope) at (~1.58, ~0.32), (~2.25, ~0.28), and (~2.92, ~0.08) with respective mixing proportions 0.249,0.511, and 0.240. There is very little evidence of any variation in the treatment effect over centers, fitting Similar results were given by Gelman et al. (1995), who gave posterior median for the treatment effect of ~0.25 with an approximate posterior standard deviation of about 0.07, though the posterior median of the standard deviation for their Gaussian random effect model was substantially smaller; 0.13, than the standard deviation 0.43 for the estimated random effect distribution. This may be a consequence of the additional information in the prior; or of the use of a normal approximation for the likelihood contributions of the individual centers .

<a id="sec-5-12"></a>

# 5.12 LATENT CLASS MODELS

Latent class models constitute another class of models that can be easily fitted when formulated as a mixture of GLMs. Suppose that the feature vector Yj = (y1j, Then a common approach to the mixture analysis of such data is to assume that these variables are conditionally independent given their membership of a component in the mixture model. That is, the density (frequency function) of an observation $Y_j$ can be expressed as

$$
f ( y _ { j } ) = \sum _ { i = 1 } ^ { g } \pi _ { i } \, f ( y _ { j } ; \theta _ { i } ) ,
$$

where the ith component density is given by

$$
f ( y _ { j } ; \theta _ { i } ) = \prod _ { v = 1 } ^ { p } \theta _ { v i } ^ { \mathcal { V } _ { v } j } ( 1 - \theta _ { v i } )
$$

and where 0; = 1 (" = 1, p) given its membership of the ith component of the mixture.

This is the basic model of latent class analysis with its fundamental assumption of local independence, which goes back to Lazarsfeld (1950) and Lazarsfeld and Henry (1968). Since then, it has attracted considerable interest and has been widely used in the social sciences and in biostatistics; see Formann and Kohlmann (1996) for arecent review. For an interesting example of latent class analysis; the reader is referred to McLachlan and Basford (1988), who reported the use of this model by Aitkin et al. (1981)in their analysis of an extensive body of educational research data on teaching. Celeux and Govaert (1991) have considered clustering criteria for discrete data and latent class models. With latent class models; the component-indicator variables are notactually missing in the sense that the components in the mixture model correspond to physically existing groups. The components do represent underlying "classes" without precise physical definition, but which often turn out to have meaningful physical interpretation.

The basic latent class model can be easily fitted as a mixture of GLMs the general formulation via the EM algorithm; as described in Section 5.5; see also Everitt (1984). Early attempts using conventional iterative schemes date from the 1950s (McHugh, 1956; Lazarsfeld and 1968). The rigorous solution to the problem of parameter estimation was found by Goodman (1974a, 1974b) about 20 years later. In his seminal papers, he proposed the use of the iterative proportional algorithm. This algorithm was implemented by (1977) in his computer program MLLSA; see (1995) and Formann and Kohlmann (1996). It subsequently became apparent that the proportional algorithm is a variant of the EM algorithm. using Henry, fitting Clogg Clogg fitting special

Over the years, there have been many variants and extensions of the basic latent class model; see, for example, McCutcheon (1987), Lindsay, and Grego (1991), Uebersax and Grove (1993), Wedel and DeSarbo (1993), Formann (1994), and Muthén and Shedden (1999), along with the aforementioned references in this section . Clogg, =

<a id="sec-5-13"></a>

# 5.13 HIERARCHICAL MIXTURES-OF-EXPERTS MODEL

<a id="sec-5-13-1"></a>

# 5.13.1 Mixtures-of-Experts Model

Suppose that we observe Un with associated covariates, \*1, 2n , respectively. Then under the ME model as proposed by Jacobs et al. (1991) the density of $Y_j$ given covariate æj is modeled by

$$
f ( y _ { j } \ | \ x _ { j } , \Psi ) = \sum _ { i = 1 } ^ { s } \pi _ { i } ( x _ { j } ; \alpha ) f _ { i } ( y _ { j } \ | \ x _ { j } , \theta _ { i } ) ,
$$

gT)T and where € contains the elements of 01, 8g known a to be distinct. priori Figure 5.1 presents a graphical representation of a ME model (g = 2) where; for economy of notation; f(u; as and to as expert networks. These networks approximate the distribution of the response Theexpert network maps its input, thecovariate vector æj,toan output, the= experts are appropriate in different regions of the covariate space. Consequently; the model requires module, referred to as a gating network, that identifies for any covariate vector #j, the expert or blend of experts whose output is most likely to The gating network outputs are a set of scalar coefficients T;(æj; %) that weight the contributions of the various experts. T;j'

![image 16](mclachlan2000_images/imageFile16.png)

<a id="sec-5-13-2"></a>

# 5.13.2 Hierarchical Mixtures-of-Experts

With the ME model, there is only one level of experts; that is, there is only one gating network. For the modeling of complicated random phenomena; we can improve the flexibility of the ME model by increasing the level of experts. Jordan and Jacobs (1994) have empirically found that models with a nested structure often outperform single-level models with an equivalent number of free parameters. For a two-level network of experts, we have the hierarchical mixtures-of-experts (HME) model proposed in Jordan and Jacobs (1992). It has the form

$$
f ( y _ { j } \, | \, x _ { j } , \Psi ) = \sum _ { i = 1 } ^ { g } \pi _ { i } ( x _ { j } ; \alpha ) \sum _ { h = 1 } ^ { g _ { i } } \pi _ { h i } ( x _ { j } ; \alpha _ { i } ) f _ { h i } ( y _ { j } \, | \, x _ { j } , \theta _ { h i } ) ,
$$

where T;(æj; a) is the probability that the observation $Y_j$ (withcovariate æj) belongs to the ith component at the first level, and Thi(æj; a;is the conditional probability that $Y_j$ (with covariate æ;) belongs to the hth component of the first-level ith component (that is, the (;, h)th component) given that it belongs to the ith component at the first level .

The mixing proportions $\pi_i$ and the $\tau_{hi}$ are usually modeled as functions of the covariate æj by the logistic function. Thus,

$$
\omega _ { i } ^ { T } \, x _ { j } ) / \sum _ { s = 1 } ^ { s } \exp ( \omega _ { s } ^ { T } \, x _ { j } ) \ \ ( i = 1 , \dots , g ) ,
$$

where Wg 0 and where it is implicitly assumed that the first element of æ; is one Here œ contains the elements in the w; (i = 1, 9 1). Similarly;

$$
\pi _ { h i } ( x _ { j } ; \alpha _ { i } ) = \exp ( \omega _ { h i } ^ { T } x _ { j } ) / \sum _ { \i = 1 } ^ { g _ { i } } \exp ( \omega _ { s i } ^ { T } x _ { j } ) \quad ( h = 1 , \dots , g _ { i } ) ,
$$

where Wgi,i The vector of unknown parameters is given by

$$
\Psi = ( \alpha ^ { T } , \, \alpha _ { 1 } ^ { T } , \, \dots , \, \alpha _ { g } ^ { T } , \, \xi ^ { T } ) ^ { T } ,
$$

where € contains the elements of the @hi knowna priori to be distinct. The extension to trees of arbitrary depth and width is straightforward.

The HME architecture can be described also in terms of a tree, where each terminal node is an expert network, and each nonterminal node is a root of a subtree that itself corresponds to an HME architecture. At every nonterminal node in the tree, there is a gating network that is responsible for the topmost split of the HME architecture rooted at that node. Thus these gating networks implement the recursive splitting of the covariate space. Allof the expert and gating networks in the architecture have the same input æj. Figure 5.2 presents a graphical representation of a two-level (i = 2) HME model with g; = 2

Gating

Network

f j

f2j

Gating

Network

Xj

Expert

[f21j

Expert

f12j

Expert

f 22j

112j

Expert

Gating

Network

Xj

Xj

X

Fig. 5.2 A two-layer hierarchical mixtures-of-experts model.

Xj

The probabilisticinterpretationof the HME model can be given in terms of a nested sequence of decisions; each based on the covariate æjIn the two-level tree above, component label distribution

$$
M u l t _ { g } ( 1 , \pi _ { j } ) ,
$$

consisting of one draw on 9 categories with probabilities

$$
\pi _ { j } = ( \pi _ { 1 } ( x _ { j } ; \alpha ) , \dots , \pi _ { g } ( x _ { j } ; \alpha ) ) ^ { T } .
$$

Next a subcomponent label h is chosen with probability Thi(æj; a;) from the multi nomial distribution

$$
M u l t _ { g _ { i } } ( 1 , \pi _ { i j } ) ,
$$

consisting of one draw on g; categories with probabilities

$$
\pi _ { i j } = ( \pi _ { 1 i } ( x _ { j } ; \alpha _ { i } ) , \dots , \pi _ { g _ { i } , i } ( x _ { j } ; \alpha _ { i } ) ) ^ { T } .
$$

Itcan be seen that HME models provide a "divide and conquer" strategy: Complex tasks are decomposed into simpler subtasks which are, in turn, decomposed into even simpler sub-subtasks. Because HME models have a tree-structured approach to piecewise approximation; have similarities to classification and regression tree they models that have previously been proposed in the statistics literature; such as CART in Breiman et al. (1984) and MARS (Friedman, 1991). As explained in Jacobs, Tanner, and Peng (1996), differ in the way divide the covariate space into regions. With the HME architecture; aprobabilistic (soft) subdivision is employed. In contrast, CART and MARS use hard boundaries with each data lying in exactly one of the regions. In addition, MARS is restricted to forming region boundaries that are perpendicular to one of the covariate space axes. Thus MARS is coordinatedependent. HMEis aparametric model (CARTand MARS are both nonparametric techniques), probability-based methods including posterior simulation can be used in the of the model and in assessing the uncertainty in its predictions (Jacobs et al. 1991). Comparisons between CART, MARS, and an HME on a robot dynamics task were performed by Jordan and Jacobs (1994), and the HME (using the EM algorithm to estimate the parameters) yielded a modest improvement. they they point As fitting

<a id="sec-5-13-3"></a>

# 5.13.3 Application of EM Algorithm to HME Model

To apply the EM algorithm t0 this model, we introduce the component-indicator variables where zhij is one or zero according to whether %; belongs or does not belongto the (i, h)thcomponent ofthe HME model. Welet z be the vector containing all these component indicators. The probability that is one, given the covariate Zhij Zhij

$$
\pi _ { h i j } & \ = \ \ p _ { \Psi } \{ Z _ { h i j } = 1 \, | \, \mathfrak { x } _ { j } \} \\ & \ = \ \pi _ { i } ( \mathfrak { x } _ { j } ; \alpha ) \, \pi _ { h i } ( \mathfrak { x } _ { j } ; \alpha _ { i } ) \ \ ( h = 1 , \dots , g _ { i } ; \, i = 1 , \dots , g ) .
$$

The conditionalexpectation of given the response $y_j$ withcovariate æj, is given by Zhij ,

$$
\tau _ { h i j } \ & = \ \Pr _ { \substack { ( x _ { j } , \alpha ) \, \pi _ { h i } ( x _ { j } ; \alpha _ { i } ) \, f _ { h i } ( y _ { j } \, | \, \alpha _ { j } , \theta _ { h i } ) \\ f ( y _ { j } \, | \, \alpha _ { j } , \Psi ) & = 1 , \dots , g _ { i } ; \, i = 1 , \dots , g ) .
$$

As with the of a mixture of GLMs, if z containing all the componentindicators were known; then the computation of the MLE would separate out into regression problems for each expert network and a multiway classification problem for the multinomials; which can be solved independently of each other. To see this; the complete-data likelihood is given by fitting log

$$
\log L _ { c } ( \Psi ) \, = \, \sum _ { h = 1 } ^ { g _ { i } } \sum _ { i = 1 } ^ { g } \sum _ { j = 1 } ^ { n } z _ { h i j } \{ \log \pi _ { i } ( x _ { j } ; \alpha ) + \log \pi _ { h i } ( x _ { j } ; \alpha _ { i } ) \\ + \log f _ { h i } ( y _ { j } \ | \ x _ { j } , \theta _ { h i } ) \} .
$$

The EM algorithm on the (k + 1)th iteration reduces to the following:

E-step. Replace zhij in (5.63) by its current conditional expectation obtained by using <k) for $ in (5.62) Thij

M-step. The M-step consists of three separate maximization problems. The updated estimate of œ(k+l) is obtained by solving

$$
\sum _ { i = 1 } ^ { g } \sum _ { h = 1 } ^ { g _ { i } } \sum _ { j = 1 } ^ { n } \tau _ { h i j } ^ { ( k ) } \partial \log \pi _ { h i } ( x _ { j } ; \alpha ) / \partial \alpha = 0 .
$$

The updated estimate of a{k+1) is obtained by solving

$$
\sum _ { h = 1 } ^ g \sum _ { j = 1 } ^ n \tau _ { h i j } ^ { ( t ) } \partial \log \pi _ { h i } ( x _ { j } , \alpha _ { i } ) / \partial \alpha _ { i } = 0 } \left ( i = 1 , \dots , g \right ) .
$$

the updated estimate of e(+1) is obtained by solving

$$
\sum _ { j = 1 } ^ { n } \tau _ { h i j } ^ { ( k ) } \partial \log f _ { h }
$$

$$
( 5 . 6 6 )
$$

g; h = 1, .,

All these equations require iterative methods; (5.64) and (5.65) can be solved by IRLS for a GLM. So too can (5.66) if fh;= family.

Jacobs et al. (1991) and Jordan and Jacobs (1992) showed empirically for the ME and HME models, respectively; that the EM algorithm yields significantly faster convergence than gradient ascent. Jordan and Xu (1995) subsequently provided a architectures, while and Tanner (1999a, 1999b) have considered the approximation rate of HME for GLMs. and Tanner (1999c) have obtained conditions for the identifiability of the ME model, which showed held for Poisson, gamma, normal, and binomial experts. Chen, Xu; and Chi (1999) have investigated the use of the IRLS algorithm on the M-stepin the EM-fitting of ME models where the response variable V; is multivariate, corresponding to multiclass classification problems. Jiang Jiang they

<a id="sec-5-13-4"></a>

# 5.13.4 Example 5.4: Speech Recognition Problem

We illustrate the use of the HME model in its application to a speech recognition task as reported in Peng, Jacobs, and Tanner (1996) The values of the covariate vector æ; are the first and second formant values extracted from ten classes of spoken vowels. The response variable %j is the class indicator of the spoken vowel with one Or zero, according t0 whether it belongs or does not belong to the vth class (v = 1, 10). The covariates 2j are plotted in Figure 5.3, and the value of being

![image 17](mclachlan2000_images/imageFile17.png)

utterances of 10 words, each of which began with an 'h' contained a vowel in the middle, and ended with a "d" In all, there were n = 75 speakers (32 male adults, 28 female adults, and 15 children) . The training consisted of 149 items randomly selected from the available data, leaving 1,345 items for a test set. set

4 n

2

2

3

2

g

222

3

3

9

44

86 866

6

6

6

Fomant

Flg. 5.3 The horizontal and vertical axes give the first and second formants, respectively. Each data is labeled with a digit (0-9) that indicates the vowel class to which the data point belongs. From Peng et al. (1996). point

et al. (1996) fitted a two-level HME with 10 experts in the second level arranged in two modules of five each. Thus in the definition (5.55) of the HME model, 9 = 2 and g; = 5. The (i,h)th component density was taken to be the multinomial consisting of one draw on p = 10 categories, Peng

$$
( 5 . 6 7 )
$$

where

$$
, \theta _ { p h i } ) ^ { T }
$$

and is the conditional probability that Yvj = 1, given æj and its membership of the (i, h)th component in the HME model (v = 1, p). Thus the probability that the spoken vowel for the jth speaker belongs to the class denoted by %; is modeled as

$$
f ( y _ { j } \ | \ x _ { j } , \varPsi ) = \sum _ { i = 1 } ^ { 2 } \sum _ { h = 1 } ^ { 5 } \prod _ { \nu = 1 } ^ { 1 0 } \theta _ { v h i } ^ { y _ { \nu j } } ( 1 - \theta _ { v h i } ) ^ { 1 - y _ { \nu j } } .
$$

Peng et al. (1996) adopted a Bayesian approach to the of this model , MCMC methods that included Gibbs sampling. The EM algorithm was used to normal priors for all the unknown parameters; see et al. (1996) for details on the implementation of their MCMC methods. The performance of the classification rule so obtained for their HME model is given in Table 5.8. fitting using used Peng

Table 5.8 Classification Performances of Four Systems on the Data in the Prediction Set

| Total Category | Gibbs Correct | EM Correct | CART I #Correct | CART II #Correct |
| -------------- | ------------- | ---------- | --------------- | ---------------- |
| 127            | 123.3         | 123.3      | 114             | 124              |
| 132            | 96.3          | 97.9       | 94              | 112              |
| 139            | 95.9          | 92.0       | 30              | 60               |
| 137            | 84.1          | 79.2       |                 | 109              |
| 133            | 104.6         | 100.9      | 73              | 117              |
| 136            | 109.1         | 106.3      | 102             | 109              |
| 128            | 88.5          | 84.4       | 90              | 96               |
| 132            | 74.5          | 78.0       | 72              | 71               |
| 140            | 80.7          | 77.1       | 49              | 38               |
| 141            | 58.0          | 50.2       | 87              | 60               |
| 1345           | 915.0         | 889.3      | 801             | 896              |

et al. (1996) Peng

Source: From

<a id="sec-5-13-5"></a>

# 5.13.5 Pruning HME Tree Structures

Jacobs, Peng, and Tanner (1997) have considered ways of assessing whether a given HME architecture is over- or under-specified for a given data set. suggest that a to the value of an expert (i, h) is given by They guide

and the value of the ith branch by

$$
\sum _ { j = 1 } ^ { n } z _ { h i j } / n ,
$$

$$
\sum _ { h = 1 } ^ { n } \sum _ { j = 1 } ^ { n } z _ { h i j } / n ,
$$

where in the Bayesian framework adopted by Jacobs et al. (1997), the unknown in (5.69) and (5.70) can be estimated by the average of its generated values on a specified number of simulations. In a frequentist framework, it can be replaced by its estimated conditional expectation, which is the limiting value of Jacobs et al. (1997) suggest some guidelines as to the value of (5.69) 'Yor an expert to be deleted. applied their pruning methods to the spccch recognition problem As their indicators suggested that four experts would be useful for this problems, tried a 2-2 architecture and then finally a 1-1 architecture . Thij They they



