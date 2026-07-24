<a id="sec-multivariate-normal-mixtures"></a>

# Multivariate Normal Mixtures

<a id="sec-3-1"></a>

# 3.1 INTRODUCTION

In this chapter we focus on mixture models with normal components. A common assumption in practice is to take the component densities to be (multivariate) normal. For example, in clustering context, it is to proceed on the basis that any nonnormal features in the data are due to some underlying group structure. Further; often clusters in the data are essentially elliptical, so that it is reasonable to consider mixtures of elliptically symmetric component densities. Within this class of component densities, the multivariate normal density is a convenient choice given its computational tractability. In Chapter 7 we consider a robust extension of the normal mixture model through the use of t component distributions. The family of t distributions provides a heavy-tailed alternative to the normal typical fitting family-

<a id="sec-3-2"></a>

# 3.2 HETEROSCEDASTIC COMPONENTS

In Section 2.8 we have described the application of the EM algorithm for the ML of a mixture of arbitrary component distributions to an observed random sample, We now specialize these results t0 the case of a mixture of normal components; fitting

$$
f ( y _ { j } ; \Psi ) = \sum _ { i = 1 } ^ { g } \pi _ { i } \phi ( y _ { j } ; \mu _ { i } , \Sigma _ { i } ) .
$$

Here % = (T1, T9-1, €T)" , where € contains the elements of the component means #; and the distinct elements of the component-covariance matrices $Z_j$ (i = 1, 9)

We first consider the unrestricted (heteroscedastic) case where the componentcovariance matrices $Z_j$ are unequal; that is, there are no restrictions placed on them: Concerning the E-step on the (k + 1)th iteration; we have seen in Section 2.8.3 that it effectively replaces the unknown zero-one component-label variables zij by their current conditional expectations given by the posterior probabilities of component membership of the observed data Uj , 9()) , where now

$$
, \Sigma _ { i } ) / \sum _ { h = 1 } ^ { h } \pi _ { h } \phi ( y _ { j } ; \mu _ { h } , \Sigma _ { h } )
$$

for i = 1, 9; j =1, n.

The M-step for normal components exists in closed form. The updates of the component means #; and component-covariance matrices $Z_j$ are given simply by

$$
^ { ( k + 1 ) } _ { i } = \sum _ { j = 1 } \tau _ { i j } ^ { ( k ) } y _ { j } / \sum _ { j = 1 } \tau _ { i j } ^ { ( k ) }
$$

and

$$
\Sigma _ { i } ^ { ( k + 1 ) } = \sum _ { j = 1 } ^ { n } \tau _ { i j } ^ { ( k ) } ( y _ { j } - \mu _ { i } ^ { ( k + 1 ) } ) ( y _ { j } - \mu _ { i } ^ { ( k + 1 ) } ) ^ { T } / \sum _ { j = 1 } ^ { n } \tau _ { i j } ^ { ( k ) }
$$

for i = 1, 9, where

$$
( i = 1 , \dots , g ; \, j = 1 , \dots ,
$$

The updated estimate of the ith mixing proportion $\pi_i$ is as given by (2.32).

Computationalwise; it is advantageous to express the update (3.4) of $Z_j$ directly in terms of the current conditional expectations of the sufficient statistics complete-data framework, given by I;, I;2,

$$
T _ { i 1 } ^ { ( k ) } = \sum \tau _ { i j } ^ { ( k ) } ,
$$

and

We have then that

$$
T _ { i 2 } ^ { ( k ) } = \sum _ { j = 1 } ^ { \infty } \tau _ { i j } ^ { ( k ) } y _ { j } ,
$$

$$
T _ { i 3 } ^ { ( k ) } = \sum _ { j = 1 } \tau _ { i j } ^ { ( k ) } \, y _ { j } \, y _ { j } ^ { T } .
$$

$$
\Sigma _ { i } ^ { ( k + 1 ) } = \{ T _ { i 3 } ^ { ( k ) } - T _ { i 1 } ^ { ( k ) ^ { - 1 } } T _ { i 2 } ^ { ( k ) } T _ { i 2 } ^ { ( k ) ^ { T } } \} / T _ { i 1 } ^ { ( k ) } \ \ ( i = 1 , \dots , g ) .
$$

(3.8) instead of (3.4) to update the estimate of the ith component-covariance matrix gives a reduction in CPU time of around 509 . Using

Liu and Sun (1997) have considered the use of the ECME algorithm to up convergence ofthe M-step. With their approach, the component means andcovariance matrices are updated as above. However; the mixing proportions are updated by a conditional maximization of the incomplete-data likelihood, log L(v) with +1) the component means and covariance matrices fixed at 1, 9) The updates 1(\*+1) do not exist in closed form and have to be obtained iteratively; for example, by Newton-Raphson. Liu and Sun (1997) report that typically only one Newton-Raphson iteration is required. speed log

<a id="sec-3-3"></a>

# 3.3 HOMOSCEDASTIC COMPONENTS

Often in practice, the component-covariance matrices S; are restricted to the same, being

$$
( \dots , g ) ,
$$

where > is unspecified. In this case of homoscedastic normal components, the updated estimate of the common component-covariance matrix >is given by

$$
\Sigma ^ { ( k + 1 ) } = \sum ^ { g } T _ { i 1 } ^ { ( k ) } \Sigma _ { i } ^ { ( k + 1 ) } / n ,
$$

heteroscedastic case.

In the isotropic case, the component-covariance matrices are further restricted by taking the common component-covariance matrix > to be diagonal with equal diagonal elements 0?2; that is,

$$
( 3 . 1 1 )
$$

<a id="sec-3-4"></a>

# 3.4 STANDARD ERRORS

The provision of standard errors for the parameters in a general finite mixture model has been discussed in Chapter 2, including the use of the bootstrap. With the information-based approach that uses the observed information matrix I(û; y), we need to calculate the Hessian matrix for the log likelihood. This has been done in Roberts et al. (1998) for the normal mixture model, initially in the simplified case of diagonal component-covariance matrices. then performed a transformation to convert their results to the general case of unrestricted component-covariance matri ces. However; this part of their calculations would appear to be incorrect. They

We have seen in Section 2.15.3 that the observed information matrix can be approximated by the empirical matrix Ie (#; u), which only requires the gradient of the

likelihood function to be evaluated . Moreover, it can be expressed in terms of the gradient of the complete-data likelihood function: We have from (2.60) that log log

$$
I _ { e } ( \hat { \Psi } ; y ) = \sum _ { j = 1 } ^ { n } s ( y _ { j } ; \hat { \Psi } ) s ^ { T } ( y _ { j } ; \hat { \Psi } )
$$

where, from (2.62) for finite mixture models,

$$
y _ { j } ; \Psi ) = \sum _ { i = 1 } ^ { j } \tau _ { i } ( y _ { j } ; \Psi ) \partial \{ \log \pi _ { i } + \log f _ { i } ( y _ { j } ; \theta _ { i } ) \} / \partial \Psi \ \ ( j = 1 , \dots , n ) .
$$

We now give expressions for the elements of $B(y_j; \Psi)$ in the case of normal components with no restrictions on the component-covariance matrices $Z_j$ .

Let 7g-1 2 and Jet w; contain the Up(p + 1) elements of $Z_j$ (i = 1, 9). Then on partitioning the vector $\Psi$ of unknown parameters as Tg-1)T

$$
= ( \pi _ { g - 1 } ^ { T } , \mu _ { 1 } ^ { T } , \dots
$$

we let

$$
( d _ { \pi _ { g - 1 , j } } ^ { T } , d _ { \mu _ { 1 j } } ^ { T } , \dots , d _ { \mu _ { g j } } ^ { T } , d _ { \omega _ { 1 j } } ^ { T } , \dots , d _ { \omega _ { j } } ^ { T } ) ^ { T }
$$

We have from McLachlan and Basford (1988) that for j = 1, n,

$$
\iota / \pi _ { g } \ \ ( i = 1 , \dots , g - 1 ) , \quad \quad ( 3 . 1 4 )
$$

and by McLachlan and Basford (1988), it is self-serving t0 cluster the data under the assumption of normality when one is subsequently to test for it, but it is brought about by the limitations on such matters as hypothesis testing in the absence of classified data. The reader is referred to McLachlan and Basford (1988, Section 3.2) and McLachlan (1992, Chapter 6) on the application of Hawkins' (1981) test in the case of a partially or totally unclassified sample.

$$
\hat { \mu } _ { i } ) \ \ ( i = 1 , \dots , g ) ,
$$

$$
( 3 . 1 6 )
$$

where the hth element of corresponds to the (r, s)th element of $Z_j$ and where (i =1, 9)

<a id="sec-3-5"></a>

# 3.5 ASSESSMENT OF MODEL FIT

The problem of assessing model fit is not straightforward for mixture models at least for multivariate data. For univariate data, we can compare the fitted mixture density with the data in histogram form; see, for example, Figure 1.. Alternatively; in the univariate case, we can compare the fitted mixture distribution function with the empirical distribution function; as advocated by Aitkin (1997), among others.

In the case of normal components, one way to proceed with the assessment of normality and homoscedasticity is to follow the approach of Hawkins et al. (1982) and apply the test of Hawkins' (1981) to the clusters implied by the MLE. As cautioned

<a id="sec-3-6"></a>

# 3.6 EXAMPLES OF UNIVARIATE NORMAL MIXTURES

Here we briefly describe the important role of univariate normal mixtures in the field of genetics where provide the basic model. Also; as mentioned in Section 1.1.1, mixture models have proven to be very useful in assessing the error rates (sensitivity and specificity) of diagnostic and screening procedures in the absence of a standard (Qu, and Kutner, 1996). We illustrate this in two examples. The first is on screening for hemochromatosis; the second is on a diagnostic test for diabetes. they gold Tan,

<a id="sec-3-6-1"></a>

# 3.6.1 Basic Model in Genetics

One area in which mixture modeling has played a very important role is genetics; following Karl Pearson's pioneering work in the area in the late 180Os. An example of mixture modeling in genetics may be foundin Shoukri and McLachlan (1994), who fitted a mixture distribution to nuclear family data. The reader is referred to Schork et al. (1996) for a comprehensive review of the theory and application of mixture models in human genetics.

A basic mixture model can be used to assess the impact of possible underlying genotypes associated with a particular locus on phenotypes that display continuous or quantitative variation in the population (for example, blood pressure, height, weight). Consider a locus with two alleles, denoted types an individual can possess at this locus: AA, Aa (equivalent to aA), and aa Suppose the phenotype or trait values associated with individuals possessing the AA genotypes; the heterozygote genotypes Aa, and the homozygote genotypes aa are these genotypes in the population at large are denoted by PAA, PAa, and paa.

If $y_j$ denotes the phenotype of interest, then it has the normal mixture distribution given by

$$
f ( y _ { j } ) = \sum _ { i } ^ { \infty } \pi _ { i } \, \phi ( y _ { j } ; \mu _ { i } , \sigma _ { i } ^ { 2 } ) ,
$$

where T1 =PAA, 72 PAa, and T3 T3, are frequently written in terms of the allele frequencies pA and pa, using the Hardy_Weinberg equilibrium (HWE) structure;

$$
\pi _ { 1 } = p _ { A } ^ { 2 } , \pi _ { 2 } = 2 p _ { A } p _ { a } , \pi _ { 3 } = p _ { a } ^ { 2 } .
$$

Under the additive model, we have #3

An alternative genetics model to the model above is the simple dominance model in which genotypes AA and Aa have the same phenotype with frequency T1 = p2 +2pAPa This leads to a two-component normal mixture model with components corresponding to the phenotypes AA and Aa and to aa in proportions $\pi_1$ = 2pAPa and T2 = p2, respectively.

A recent focus of mixture models in genetics is the construction of gene marker maps for percentage testing, disease resistance diagnosis, and quantitative trait loci (QTL) detection; see, for example, Doerge, and Weir (1997), Kao and (1997), and the references therein. Zeng Zeng,

<a id="sec-3-6-2"></a>

# 3.6.2 Example 3.1: PTC Sensitivity Data

We report in Table 3.1 the results of Jones and McLachlan (1991), who fitted a mixture of three normal components to data on phenylthiocarbamide (PTC) sensitivity for three groups of people. These data sets had been considered by Kalmus and Maynard Smith (1965). are in interval (binned) form, as PTC sensitivity was recorded as falling between the second highest and highest detectable dilutions, equally spaced on the scale. Jones and McLachlan (1991) fitted normal mixture models to these data, the methodology of McLachlan and Jones (1988) for binned data as to be discussed in Chapter 9 . They using

Of interest is the likelihoodratio test of the Hardy_Weinberg equilibrium (HWE) structure (3.18) versus unconstrained mixing proportions (apart from requiring that sum to one) It can be seen from Table 3.1 that it is unlikely that the HWE X for this test is practically zero. Jones and McLachlan (1991) suggested bootstrapping this statistic if a P-value were required. they log-

Table 3.1 Fit of Mixture Model to Three Data Sets (Standard Errors in Parentheses)

| Parameter           | Data Set [   | Data Set 2   | Data Set 3   |
| ------------------- | ------------ | ------------ | ------------ |
| PA                  | 0.572 (.027) | 0.626 ( 025) | 0.520 (.026) |
|                     | 2.49 (.15)   |              |              |
|                     | 9.09 (.18)   | 8.09 (.15)   | 7.47 (.47)   |
|                     | 10.37 (.28)  | 8.63 ( .50)  | 9.08 (.08)   |
|                     | 1.34 ( 29)   | 1.,44 (.28)  | 0.34 (.09)   |
|                     | 2.07 (.39)   | 1.19 (.22)   | 6.23 (2.06)  |
| 3                   | 0.57 (.33)   | 0.10 (.18)   | 0.48 (.10)   |
| Test statistic: log | 3.60         | 6.87         | 58.36        |
| ~2log X (HWE)       | 0.00         | 3,76         | 1.06         |

Source: Adapted from Jones McLachlan (1991). and Another test of interest was a? = 03, as assumed by Kalmus and Maynard Smith (1965) in their analysis. Jones and McLachlan (1991) noted from their estimates of these two variances relative to their standard errors (based on the inverse of the empirical information matrix) that this assumption did not appear to be justified. Furthermore, the value of ~2log X for 0? 03 versus 02 # 03 is extremely large for the third data set (given that its asymptotic null distribution is chi-squared with one degree of freedom).

<a id="sec-3-6-3"></a>

# 3.6.3 Example 3.2: Screening for Hemochromatosis

We consider the case study of McLaren et al. (1998) on the screening for hemochromatosis . There is incontrovertible evidence that early diagnosis of hereditary hemochromatosis prevents virtually all manifestations of the disease and results in normal life expectancy. In contrast, when unrecognized and untreated, the disease leads tocirrhosis, hepatocellular carcinoma; and other lethalcomplications (McLaren et al , 1998) The identification of heterozygotes for hereditary hemochromatosis is important too as, if undetected, may go on to develop an iron load sufficient to cause overt organ damage. Also; the identification of a heterozygote provides the opportunity to conduct studies of family members in order to identify individuals who are homozygous for the disease. Thus early identification of heterozygotes and homozygotes for hemochromatosis is an important clinical challenge. An elevated level of transferrin saturation remains the most useful noninvasive screening test for affected individuals, but there is some debate as to the appropriate screening level. they

Studies have suggested that mean transferrin saturation values for heterozygotes are higher than among unaffected subjects, but lower than homozygotes. Since the distribution of transferrin saturation is known to be well approximated by a single normal distribution in unaffected subjects, the physiologic models used in the study of McLaren et al. (1998) were single normal component and mixturc of two normal components. this approach, confirmed that hemochromatosis het erozygotes form a distinct subpopulation with respect to transferrin saturation; with mean transferrin saturation greater than that for unaffected individuals. This can be seen from Figure 3.1, which gives the plots of the densities of the mixture of two (univariate) normal heteroscedastic components fitted to some transferrin values on asymptomatic Australians (stratified by sex), which were known to be cither unaffected or heterozygotes with respect to hereditary hemochromatosis. The estimated component means are given in Table 3.2, where one component corresponds to fected individuals and the other to heterozygotes. This table also contains the means from a classified sample on 485 subjects known to be homozygous or heterozygous for hemochromatosis . With a fasting transferrin saturation of 2 459, virtually all affected homozygous subjects would be identified in the second sample. From the fitted mixture distributions; it was found for this threshold that none of the postulated unaffected individuals would undergo further testing unnecessarily and 19.19 of the heterozygotes would be identified. Using they unaf-

![image 8](mclachlan2000_images/imageFile8.png)

Fig. 3.1 Plots of the densities of the mixture of two (univariate) normal heteroscedastic components fitted to some transferrin values on asymptomatic Australians (stratificd by sex; (A) 796 men and (B) 669 women) which were known to be either unaffected or heterozygotes with respect to hereditary hemochromatosis. From McLaren et al. (1998).

Table 3.2 Transferrin Saturation Results Expressed as Mean Percentage + SD

|        | Asymptomatic Individuals |                          | Individuals Identified by Pedigree Analysis |                   |
| ------ | ------------------------ | ------------------------ | ------------------------------------------- | ----------------- |
| Sex    | Postulated Unaffected    | Postulated Heterozygotes | Known Heterozygotes                         | Known Homozygotes |
| Male   |                          | 7.7                      | 37.14 17.0                                  | 82.7 + 14.4       |
| Female | 22.5 + 6.4               | 37.6 4 10.4              |                                             |                   |

Source: McLaren et al. (1998)

<a id="sec-3-6-4"></a>

# 3.6.4 Example 3.3: Diagnostic Criteria for Diabetes

In this example, a normal mixture model is used to estimate the prevalence of diabetes and to assess the sensitivity andspecificity of adiagnostic test for diabetes as afunction where there is direct inclusion of covariates in the mixture model by allowing the component densities and also the mixing proportions to depend on some available covariates. In Chapter 5 we shall consider the problem of mixtures of GLMs in proportions that may also depend on covariates. fitting

The data analyzed by Thompson; Smith, and Boyle (1998) consisted of n = 919 observations on each of p = 6 variables. plasma glucose measurement after an oral glucose load. The vector æ; of associated covariates contained five variables; age (36-65 years), sex, residence (urban or rural) , physical activity (active or sedentary), and obesity (noor yes). These data were from a population-based survey conducted in Cairo and surrounding rural villages between 1991 and 1994. Thompson et al. (1998) fitted a two-component normal mixture model to the logarithm of $y_j$ initially with all five covariates in both component densities and in the logistic model for the mixing proportions Ti. Consideration was given to two-way interactions and squared terms in age, the BIC criterion in a forwardselection fitting strategy The fitfor their final model is displayed in Table 3.3, where the variable age has been coded to be (age 50)/10. Table 3.3 also contains standard errors based on 2000 bootstrap replications. In this final fit, no covariates were includedin the second component density The logistic regression model for the mixing proportion T1 included three covariates, age, and urban. The covariates included in the first component were urban; obese, and two variables (corresponding to active females and active males) for an effect of sex nested within physical activity: using age? ,

Table 3.3 Generalized Linear Finite Mixture Model

| Distribution | Parameter     | Estimate | SE     | Z-Value | P-Value |
| ------------ | ------------- | -------- | ------ | ------- | ------- |
| Mixing       | Intercept     | 1.142    | 0.1939 | 5.89    |         |
|              | Age           | ~0.511   | 0.0993 | ~5.15   | <0.001  |
|              | (Age)?        | 0.370    | 0.1215 | 3.04    | 0.002   |
|              | Urban         | ~1.368   | 0.1914 | ~7.15   | <0.001  |
| First        | Intercept     | 2.024    | 0.0109 | 185.16  |         |
| component    | Urban         | ~0.052   | 0.0122 | ~4.24   | <0.001  |
|              | Obese         | 0.071    | 0.0123 | 5.80    | <0.001  |
|              | Active female | 0.054    | 0.0149 | 3.66    |         |
|              | Active male   | ~0.050   | 0.0211 | ~2.35   | 0.019   |
|              | 01            | 0.117    | 0.0048 | 24.59   |         |
| Second       | Intercept     | 2.510    | 0.0085 | 296.34  |         |
| component    | 02            | 0.132    | 0.0074 | 17.67   |         |

Source: Adapted from Thompson et al. (1998).

As there is no definitive standard for diagnosing diabetes, the current World Health for the diagnosis of diabetes is 200 mg Thompson et al. (1998) used the fitted mixture model to investigate the choice of a cutoff = C above which an individual is diagnosed as having diabetes. It was taken tobe the point that minimizes the overall misclassification rate as determined from the fitted mixture model. In Table 3.4 we report the results so obtained by Thompson et al. (1998) for the cutoff point as a function of age and place of residence with the other covariates replaced by their mean values. point

Table 3.4 Cutoff Points, Sensitivities; Specificities, and Misclassification Rates by Residence and Age

| Cutoff Point Criteria | Residence | Age (years) | Cutoff Point dl-1 ) (mg | Sensitivity (%) | Specificity | Error Rate |
| --------------------- | --------- | ----------- | ----------------------- | --------------- | ----------- | ---------- |
| Min Error             | Rural     | 40          | 223                     | 89.1 (2.63)     | 99.2 (0.80) | 2.0 (0.62) |
|                       |           | 60          | 206                     | 93.3            | 98.3        | 3.1        |
|                       |           |             |                         | (2.05)          | (0.66)      | (0.58)     |
|                       | Urban     | 40          | 192                     | 95.9            | 98.4        | 2.5        |
|                       |           |             |                         | (1.55)          | (0.66)      | (0.48)     |
|                       |           | 60          | 178                     | 97.6            | 96.8        | 2.7        |
|                       |           |             |                         | (1.08)          | (1.06)      | (0.53)     |
| WHO                   | Rural     | 40          | 200                     | 94.4            | 97.8        | 2.6        |
|                       |           |             |                         | (1.83)          | (0.80)      | (0.62)     |
|                       |           | 60          | 200                     | 94.4            | 97.8        | 3.1        |
|                       |           |             |                         | (1.83)          | (0.80)      | (0.56)     |
|                       | Urban     | 40          | 200                     | 94.4            | 98.9        | 2.6        |
|                       |           |             |                         | (1.83)          | (0.50)      | (0.59)     |
|                       |           | 60          | 200                     | 94.4            | 98.9        | 3.7        |
|                       |           |             |                         | (1.83)          | (0.50)      | (1.07)     |

Source: Thompson et al. (1998)

<a id="sec-3-7"></a>

# 3.7 EXAMPLES OF MULTIVARIATE NORMAL MIXTURES

<a id="sec-3-7-1"></a>

# 3.7.1 Example 3.4: Crab Data

data, we consider in this example the clustering of the crab data set of Campbell and Mahon (1974) on the genus Leptograpsus, which has been analyzed further in Ripley (1996) and McLachlan and Peel (1998a) Attention is focused on the sample of n = 100 blue crabs, there being n1 =50 males and n2 = 50 females corresponding to groups G1 and G2 respectively. Each specimen has measurements (in mm) on the width of the frontal lip FL, the rear width RW , the length along the midline CL and the maximum width CW of the carapace; and the body depth BD. In Figure 3.2 we give the scatter plot of the second and third variates with their group of origin noted. Hawkins' (1981) simultaneous test for multivariate normality and equal covariance matrices (homoscedasticity) suggests that it is reasonable to assume that the groupconditional distributions are normal with a common covariance matrix. Consistent with this, it was found that the sample linear discriminant function (formed the known classification of the data) misallocates only two more observations than the quadratic version formed without the restriction of equal group-covariance matrices. There are 6 misallocations overall with the latter from G1 and 2 from G2) using We now cluster these data; ignoring the known classification ofthe data, by fittinga mixture of two normal components with and without restrictions on the componentcovariance matrices\_ Rather surprisingly; it is found that the assumption of equal component-covariance matrices has a marked impact on the implied clustering of the data. For without any restrictions on the component-covariance matrices; the normal mixture model-based clustering results in one cluster 'containing 39 observations from G1 and another containing all 50 observations from G2, with the remaining 11 observations from G1. Identifying the larger-sized cluster with G2 (and the smaller sized cluster with G1), the overall misallocation rate is 11. However; if we impose the restriction ofequalcomponent-covariance matrices, then a further 8 observations from G1 are misallocated, as these 8 observations are moved from the smaller-sized cluster to the larger-sized cluster. This is an interesting example as it is a situation where; although it is reasonable to assume that the true group-structure is homoscedastic, the assumption of homoscedasticity in the normal mixture model leads to a much inferior clustering of the data. This is brought about by there several observations from G1 (male crabs) that are near the boundary of the feature space on which the group-conditional densities weighted by their probabilities are apparently equal, and when knowledge of their true classification is not used, these along fitting being prior points have an adverse effect on the group-density estimates (and the consequent clustering) produced under the assumption of homoscedasticity;

![image 9](mclachlan2000_images/imageFile9.png)

Fig. 3.2 Plot of third versus second variate for n1 50 male and n2 50 female blue crabs (0 denotes male and x female). From Peel and McLachlan (2000).

8

18

Fig. 3.3 Contours of the fitted component densities on the second and third variates in the region of points 17 and 18 for the n1 = 50 male and n2 = 50 female blue crabs (0 denotes male and x female). From Peel and McLachlan (2000).

To illustrate just how sensitive the process is to the location of some of these observations; we considered the implied clustering of the 17th and 18th observations from G1,

$$
y _ { 1 7 } = ( 1 3 . 1 , 1 0 . 6 , 2 8 . 2 , 3 2 . 3 , 1 1 . 0 ) ^ { T }
$$

and

$$
y _ { 1 8 } = ( 1 3 . 1 , 1 0 . 9 , 2 8 , 3 , 3 2 . 4 , 1 1 . 2 ) ^ { T } .
$$

Although these two points are very close in terms of Euclidean and also Mahalanobis distance; their estimated posterior probabilities of belonging to G1 are quite differ ent under the normal mixture model with equal covariance matrices, being equal to 0.564 and 0.170, respectively. To see why there should be this somewhat unexpected ure 3.3 the contours of the estimated component densities for the 2nd and 3rd feature variables . It can be seen that the 18th observation lies in the feature space where the contours of 4) are very steep, so that even slight changes in the values of the feature variables can result in relatively large changes in the values of the component densities. Without the restriction of equality on the component-covariance matrices, the estimates of these two posterior probabilities are very similar, 1.000 and 0.996, and now observation 18 is correctly allocated to G1. f2($y_j$; being

<a id="sec-3-7-2"></a>

# 3.7.2 Example 3.5: Hemophilia Data

We consider here the hemophilia data set, as analyzed by Basford and McLachlan (1985d), McLachlan and Basford (1988) and, more recently; Celeux et al. (1996). It consists of only two bivariate components; and its analysis illustrates the caution that needs to be exercised in practice with the fitting of mixture models. The data set was originally taken from Habbema, Hermans, and van den Broek (1974), where, in the context of genetic counseling, the question of discriminating between normal women and hemophilia A carriers was considered on the basis of two feature variates; (u;)1 = log1o(AHF activity) and (u;)2 = logo(AHF-like antigen) Both variates are scaled up by 100 here to simplify the presentation of the results. We let G1 and G2 be the groups in the population corresponding to the noncarriers and the carriers, respectively. The classification of the n = 75 data points U; are known, with there being n1 =30 and n2 = 45 observations from G1 and G2, respectively. 30) denote the n1 = 30 observations from G1 and V; (j 31, 75) denote the n2 = 45 observations from G2. These points are plotted in Figure 3.4.

![image 10](mclachlan2000_images/imageFile10.png)

McLachlan and Basford ( 1988) appliedthe test of Hawkins' 1981 ) for homoscedas ticity and normality to this data set in classified form They concluded that it was reasonable to assume that the distribution of the feature vector in each was bivariate The test indicated some presence of heteroscedasticity, which an inspection of the fitted covariance matrices revealed was limited to the second variate of the

We first cluster these data; ignoring their known classification, by a twocomponent normal mixture model with equal component-covariance matrices. Four local maxima were located, and the corresponding estimates of the parameter vector € are displayed in Table 3.5. Thelinearallocation boundary; T; is plotted in Figure 3.4 for the various local maximizers, along with the boundary corresponding to Qc, which is the MLE of % obtained by maximizing the complete data likelihood; that is, %c was obtained using the known values of the componentlabel vectors of the data points. fitting As %1 corresponds to the largest of the local maxima located, it is apparently the global maximizer and hence the MLE under homoscedasticity. It can be seen from Table 3.5 that V1 gives a poor assessment of the proportions in which G1 and G2 are represented in the sample and, as a consequence, it gives a worse allocation of the sample than 42, with a total of 25 members, all from G2, misallocated . This compares with 3 and 13 members from G1 and G2, respectively, being misallocated It is not difficult to understand why the local maximizer %2 is not the MLE under the condition of homoscedasticity. This is because this root of the likelihoodequation gives a probabilisticclustering in which the variation of ($Y_j$ )2 is substantially smaller in the cluster associated with G1 than in the other associated with G2, which is not consistent with homoscedasticity. In particular, this root provides estimates of m1 and T2 much closer to the actual proportions in which G1 and G2 occur in the sample than the MLE under the homoscedastic model; hence the apparent reason why this root leads to a better allocation of the sample than the MLE. This root gives almost the same clustering as obtained the MLE under the heteroscedastic model without restrictions on the component-covariance matrices. The latter misallocates one less observation from G2. using

Table 3.5 Local Maximizers of L(4) under Homoscedasticity

|      |      |       | Va    |       |       |
| ---- | ---- | ----- | ----- | ----- | ----- |
| 71   | 0.72 | 0.53  | 0.68  | 0.89  | 0.4   |
|      | 20.6 | ~12.1 | ~15.2 | ~21.2 | ~13.5 |
|      | ~8.0 | ~19   | 1.2   |       |       |
|      | 32.1 | ~37.0 | ~42.0 | ~45.4 | ~30.8 |
| )2   | 7.9  | ~5.2  | ~13.5 |       | ~0.6  |
|      | 265  | 137   | 138   | 235   | 226   |
| 2)22 | 171  | 220   | 175   | 167   | 216   |

<a id="sec-3-8"></a>

# 3.8 PROPERTIES OF MLE FOR NORMAL COMPONENTS

<a id="sec-3-8-1"></a>

# 3.8.1 Heteroscedastic Components

As noted in Section 2.5, the likelihood for a mixture of normal distributions with unequal covariance matrices is unbounded, and so the global maximizer does not exist. Each observation Uj gives rise to a singularity on the edge of the parameter 0 in a mixture of two univariate willtend to infinity. This was first noticed by Kiefer and Wolfowitz (1956). However, as remarked in Section 2.2, the nonexistence of a global maximizer of the likelihood log function estimate does not place a caveat on proceedings, as the essential aim of likelihood estimation is to find a sequence of roots of the likelihood equation that is consistent, and hence efficient if the usual regularity conditions hold. However, with mixture models the likelihoodequation will generally have multiple roots. Thus, even if it were known that there exists a sequence of roots of the likelihood equation with the desired asymptotic properties, there is the problem of identifying this sequence, as discussed in Section 2.2 for ML estimation in general.

For mixtures of normal distributions, at least in the univariate case, there is a sequence of roots correspondingto local maxima that is consistent and asymptotically normal and efficient. The last two results that the asymptotic distribution of this sequence is normal with covariance matrix equal to the inverse of the expected Fisher information matrix I(v) require the additional conditions that

$$
\pi _ { i } \neq 0 \quad ( i = 1 , \dots , g )
$$

and with singularities do not exist, and those associated with spurious local maximizers are at least lessened. The only problem in practice is to choose a value of C for which the true value of V satisfies (3.21)

$$
r _ { i } ^ { 2 } ) \quad ( h \neq i = 1 , \dots , g ) , \quad ( 3 . 2 0 )
$$

on writing E; as 0? in the univariate case. In the subsequent discussion of these two results, these conditions are implicitly assumed to hold.

In the case where (3.19) and (3.20) or their multivariate analogues do not both space /2 for which f($y_j$; ") = f(uj; v) for almost all v; in R? , and it may also lie on the boundary. In this case, and McCulloch (1996) showed that the MLE explained in Section 2.5. Feng

Kiefer (1978) verified for a mixture of univariate normal distributions in the more general case of the switching regression model that there is a sequence of roots of the likelihood equation which is consistent and asymptotically efficient and normally distributed. With probability tending t0 one, these roots correspond to local maxima in the interior of the parameter space; see also Peters and Walker (1978). Kiefer's (1978) verification was for 9 2 2 components; but his result will hold for 9 2, as noted in Hathaway (1985) who reported some univariate results on the maximization of L(v) over the constrained parameter space

$$
\Omega _ { C } = \{ \Psi \in \Omega \, \colon \, \sigma _ { h } ^ { 2 } / \sigma _ { i } ^ { 2 } \geq C > 0 , \quad 1 \leq h \neq i \leq g \} ,
$$

where $2 denotes the unconstrained parameter space. For any C € (0, 1], Hathaway that the sample contains at least g + 1 distinct points) and that, provided that the true value of y (3.21) is imposed to avoid the singularities in L(v) that occur when the mean of one

As pointed out by Hathaway (1985), the global constrained maximizer shares all the asymptotic properties of the consistent local maximizer of the likelihood function L(") . Thus theconstrained formulation is statistically wellposed. Problems good

For mixtures of univariate normal distributions, Hathaway (1983, 1986b) and Bezdek; Hathaway, and Huggins (1985) have investigated a constrained version of the EM algorithm which incorporates the constraint (3.21). Concerning mixtures of multivariate normal distributions, Redner and Walker (1984) have given the necessary regularity conditions for there to exist a consistent solution of the likelihood equation (see Section 2.5) but to the authors' knowledge; these conditions have not been verified, although should hold as are fairly weak. Also, Hathaway (1985) has indicated how a constrained (global) maximum likelihood formulation can be given in the multivariate case by constraining all the eigenvalues of S62; (1 < h # i < g) to be greater than or equal to some minimum value C > 0 (satisfied by the true value of %) they they

As noted by Hathaway (1985), several questions remain concerning solutions of the likelihood for normal components with unrestricted component-covariance matrices. For example, is it possible to let C decrease to zero as the sample size n increases to infinity while maintaining consistency? If the answer is yes, then at what rate can be decreased to zero? For fixed C, do all the spurious maximizers of L(w) in nc disappear as n tends to infinity? According to Hathaway (1985), empirical studies indicate that the answer to the last question could be yes.

<a id="sec-3-8-2"></a>

# 3.8.2 Homoscedastic Components

For normal components with covariance matrices >; restricted to equal to >, being

$$
0 , \, \pi _ { i } \quad ( i = 1 , \dots , g ) , \quad ( 3 . 2 2 )
$$

T9-1, QT)T exists as the global maximizer and is strongly consistent; € denotes now the elements of the u; and the distinct elements of thecommon component-covariance matrix >. As remarked in Section 2.5, Redner (1981) noted that under the conditions of Wald (1949),the MLE is strongly consistent for fi nite mixture models where attention is restricted to a compact subset of the parameter space. But the strong consistency of the MLE under (3.22), even for the unrestricted (noncompact) parameter space, follows from the device of Kiefer and Wolfowitz (1956). Their conditions require that the mixture density converges, though not to zero, as % tends to the boundary of the parameter space. To overcome the unboundedness of the density here, it is necessary to apply the device in Section 6 of Kiefer and Wolfowitz (1956), as discussed in Perlman (1972). Using this device; one works with the joint density of 9 + p observations instead of the density corresponding to a single observation. This device was employed by Hathaway (1985) in his of the strong consistency of his constrained MLE for univariate normal mixtures. proof

The choice of root of the likelihood equation is therefore straightforward under homoscedasticity; in the sense that the MLE exists as the global maximizer; which is known to be consistent. For normal component distributions that are widely sep- arated or for small values of p; there should be little difficulty in locating the global maximizer; but as p increases, the problem becomes more difficult.

<a id="sec-3-9"></a>

# 3.9 OPTIONS

<a id="sec-3-9-1"></a>

# 3.9.1 Choice of Local Maximizer

As noted in the previous section, the choice of root of the likelihood equation in the case of homoscedastic components is straightforward in the sense that the MLE exists as the global maximizer of the likelihood function. The situation is less straightforward in the case of heteroscedastic components as the likelihood function is unbounded. But assuming the univariate result of Hathaway (1985) extends to the case of multivariate normal components; then the constrained global maximizer is consistent constrained so that the component generalized variances are not too disparate; for example;

$$
( 3 . 2 3 )
$$

If we wish to proceed in the heteroscedastic case by the prior imposition of a constraint of the form (3.23), then there is the problem of how small the lower bound must be to ensure that the constrained parameter space contains the true value of We shall see shortly that with this approach there is the possibility that some legitimate solutions or solutions worthy of consideration from, say; a data-analytic aspect, may be missed.

Therefore to avoid having to specify a value for C beforehand, we where possible to fit the normal mixture without any constraints on the component covari ances >;. It thus means we have to be careful to check that the EM algorithm has actually converged and is not on way to a singularity which exists since the likelihood is unbounded for unequal component-covariance matrices. Even if we can be sure that the EM algorithm has converged to a local maximizer; we have to be sure that it is not a spurious solution that deserves to be discarded. After these checks; we can take the MLE of % to be the root of the likelihood equation corresponding to the largest of the remaining local maxima located. prefer its

We shall look at this issue of spurious solutions more closely in Section 3.10. Broadly speaking; we tend to be suspicious of any solution for which the component covariance matrices are dissimilar. For example, if the components of the mixture model are supposed to be representing some externally existing groups, then it is not unreasonable to expect that the feature variables would not have greatly differing component-covariance matrices.

<a id="sec-3-9-2"></a>

# 3.9.2 Choice of Model for Component-Covariance Matrices

A normal mixture model without restrictions on the component-covariance matri ces may be viewed as too general for many situations in practice. At the same time; though, we are reluctant to impose the homoscedastic condition (3.22), as we have noted in our analyses that the imposition of the constraint of equal component- covariance matrices can have a marked effect on the resulting estimates and the implied clustering- This was illustrated in Examples 3.4 and 3.5 in Section 3.7.

In adiscriminant analysis, the observed data (the training data) are of known origin It has been found that the normal homoscedastic solution-based classifier (equivalent to Fisher's linear discriminant function) is fairly robust against mild departures from homoscedasticity (McLachlan; 1992, Chapter 5). However, it appears that the normal mixture-based solution formed without the knowledge of the component labels can have its performance reduced with the imposition of homoscedasticity even though it may be a reasonable restriction. A possible explanation is that with the of homoscedastic components; the estimates of the component means and, in particular; the mixing proportions; suffer at the expense of the need for the estimates of the component-covariance matrices to be approximately equal. Hence the flexibility afforded by a general model for the component-covariance matrices is preferable; provided that it does not take the solution too far away from what we wouldexpect to be a realistic situation for the comparability of the component-covariance matrices. fitting

Another way of proceeding is to adopt some model for the component-covariance matrices that is intermediate between homoscedasticity and the general model, as in the approach of Banfield and Raftery (1993) to be introduced in Section 3.12. A further approach, particularly when the data are of very high dimension relative to the sample size n, is to adopt a mixture of factor analyzers model. This model is to be covered in Chapter 8. And there is also the Bayesian approach to be considered in the next chapter.

Another factor in the consideration of restrictions on the component-covariance matrices is the purpose for which the mixture model is fitted. In the above; it has been implicitly assumed that the mixture model is used detect or represent the group structure, if any, in the data. But another purpose may be to provide an adequate estimate of the density of the data. In this case, we may wish to avoid the issues associated with the use of heteroscedastic components and to restrict the component-covariance matrices tobe equal. An example concerns the use of mixture models t0 represent individual group densities for use in a discriminant analysis. being being

<a id="sec-3-9-3"></a>

# 3.9.3 Starting Points

In Section 2.12 we have discussed the possible choices for the starting value of a mixture model via the EM algorithm. There we mentioned that in addition to random starts provided by random partitions of the data into 9 groups corresponding to the 9 components of the mixture model, we can use The EMMIX program of McLachlan et al. (1999)can be used to fit anormal mixture model from a user-specified starting value or from starting values provided automatically according to the user's specifications: The latter include random starts obtained by either random partitions or randomly generated initial component means according to (2.40). The user also can specify variety of other starting points obtained by clustering procedures such as k-means or commonly used hierarchical ones. fitting

<a id="sec-3-10"></a>

# 3.10 SPURIOUS LOCAL MAXIMIZERS

<a id="sec-3-10-1"></a>

# 3.10.1 Introduction

In practice, consideration has to be given t0 the problem of relatively local maxima that occur as a consequence of a fitted component having a very small (but nonzero) variance for univariate data or generalized variance (the determinant of the covariance matrix) for multivariate data. Such component corresponds to a cluster containing a few data either relatively close together or almost lying in a lower-dimensional subspace in the case of multivariate data. There is thus a need to monitor the relative size of the fitted mixing proportions and of the component variances for univariate observations; or of the generalized component variances for multivariate data, in an attempt to identify these spurious local maximizers. The possibility that for a given starting E the EM algorithm may converge to aspurious local maximizer or may not converge at all is not a failing of this algorithm. Rather it is a consequence of the properties of the likelihood function for the normal mixture model with unrestricted component-covariance matrices in the case of unbinned data: large points point

In the absence of any information on the normal components in the mixture model to be fitted to some independent data, a common strategy is to run the EM algorithm from a variety of starting values as discussed in the previous section. The intent is to choose as the MLE of the parameter vector $\Psi$ the local maximizer corresponding to the largest of the local maxima located. As noted in the previous sections; some care needs tobe exercised in the case of unrestrictedcomponent-covariance matrices as the likelihood is then unbounded . The detection of these singularities is not a problem in practice, as can be detected by one or more of the component-covariance matrices becoming singular in the EM iterative process. they

However, there often exist other solutions which may be regarded as spurious, lying very close to the edge of the parameter space, but with component-covariance matrices that are not actually singular; although may be close to singular for some components. These solutions often have a high likelihood, but are of little practical use or real-world interpretation. It often seems in these cases that the model is a small localized random pattern in the data rather then any underlying group structure. These spurious solutions frequently have very few points in one cluster; which has little variation in one or more of the cluster's axes (small eigenvalues of the component-covariance matrix) compared to the other clusters. they fitting

One situation where an apparent spurious solution would be of practical interest is where one (or more) of the fitted components correspond to a small number of points that are distant from the rest of the sample; see Aitkin and Tunnicliffe Wilson (1980) and Jorgensen (1990)

Before we discuss how the presence of these spurious solutions can be detected in the automatic of normal mixture models with unrestricted componentcovariance matrices; we shall give some examples. fitting

<a id="sec-3-10-2"></a>

# 3.10.2 Example 3.6: Synthetic Data Set 2

To demonstrate the occurrence of what is meant by a spurious local maximizer due to a few points lying close together; we generated a random sample of size n = 50 points from a mixture of two univariate normal densities in equal proportions with means 0 and 2, and common unit variance. We fitted a mixture of g =2 univariate normal densities with

$$
f ( y _ { j } ; \varPsi ) = \sum _ { i = 1 } ^ { } \pi _ { i } \phi ( y _ { j } ; \mu _ { i } , \sigma _ { i } ^ { 2 } ) .
$$

found using the Stochastic EM algorithm as described in Section 2.13. Theresults are summarized in Table 3.6 being

Table 3.6 Local Maximizers for Synthetic Data Set 2

| Local Maximizer | L log   | T1    |        |       |             |       |             |
| --------------- | ------- | ----- | ------ | ----- | ----------- | ----- | ----------- |
|                 |         | 0.157 | ~0.764 | 1.359 | 0.752       | 1.602 | 0.4696      |
|                 | ~165.94 | 0.020 | ~2.161 | 1.088 | 5.22 x 10-8 | 2.626 | 1.97 x 10-9 |
| (binned)        | =187.63 | 0.205 | ~0.598 | 1.400 | 0.399       | 1.612 | 0.2475      |

spurious solution. This is because its first fitted component corresponds to a cluster of the two points closest to each other in the generated sample; with the second fitted component corresponding to the rest of the sample; see Figure 3.5 in which we have fitted the normal mixture density for this fit "2. The corresponding fit for V1, which we would conclude to be the MLE of %, is plotted in Figure 3.6.

0,75

Fig. 3.5 Histogram of Synthetic Data Set 2 for fit 42 of the normal mixture density.

Fig. 3.6 Histogram of Synthetic Data Set 2 for fit %1 of the normal mixture density.

The occurrence of spurious solutions of this nature are due to the fact that the data are continuous. If we were to bin the data into intervals and then fit the mixture model to the binned data, do not occur. To illustrate this, we have reported in Table 3.6 the summary of the fit %3 after first binning the data into seven intervals of equal be seen that it is fairly similar to that for $\Psi$1, confirming that V1 is the MLE for the data in unbinned form. In this example; the tell-tale sign that %2 is a spurious local maximizer is the very small value for the mixing proportion of the first component and the huge imbalance between the estimated component variances. they

Fig. 3.7 Histogram of Synthetic Data Set 2 for fit %s of the normal mixture density.

![image 11](mclachlan2000_images/imageFile11.png)

<a id="sec-3-10-3"></a>

# 3.10.3 Example 3.7: Synthetic Data Set 3

This data set consists of 100 obscrvations randomly gencrated from a mixture of two bivariate normal components in equal proportions. In Figure 3.8 we give the clustering implied by what we concluded to be the ML solution under a bivariate normal mixture model without any restrictions on the component-covariance matrices. The log likelihood at this solution was equal to ~336.021. In Figure 3.9 we give the implied clustering from another solution found corresponding to a higher value (~333.321)of the likelihood function. This solution wouldqualify as spurious, as the points in the cluster corresponding to one of the two components are almost collinear. being

X

x#\*

+##

Xx x

X

X

- Fig. 3.8 Plot of two-group clustering of Synthetic Data Set 3 implied by MLE.
- Fig. 3.9 Plot of two-group clustering of Synthetic Data Set 3 implied by solution corre sponding to a higher local maximum than MLE

<a id="sec-3-10-4"></a>

# 3.10.4 Example 3.8: Modeling Hemophilia Data under Heteroscedasticity

We return here to the hemophilia data set introduced in Example 3.5, but now we fit a two-component normal mixture model with unrestricted component-covariance matrices . Five local maximizers were located. The first three were obtained in the analysis of McLachlan and Basford (1988), while the fourth and fifth were obtained in the analyses of this data set by Celeux et al. (1996) and Peel (1998), respectively. The values of the component-generalized variances for the five solutions are listed in Table 3.7, along with the values of the eigenvalues of the component-covariance matrices. It is clear from the imbalances between the component-generalized variances and the eigenvalues for the fourth and fifth solutions that they are spurious. This can be confirmed from a plot of the asymptotic 959 confidence ellipsoidal region for the mean of the second component in these two solutions.

Table 3.7 Local Maximizers for Hemophilia Data Set under Heteroscedasticity

| Sol. | 21      | X1    | X12   |       |        | X22   | L log   |
| ---- | ------- | ----- | ----- | ----- | ------ | ----- | ------- |
|      | 9428    | 51    | 182   | 28860 | 70     | 410   | ~613.73 |
| 2    | 28895   | 420   | 68    | 6315  | 204    | 31    | ~613.97 |
| 3    | 52962   | 395   | 134   | 38    | 13     | 3     | ~612.09 |
| 4    | 54336.9 | 402.7 | 134.9 | 16.0  | 0.0963 | 166.5 | 608.262 |
| 5    | 54215.7 | 400.8 | 135.3 | 3.4   | 0.0237 | 144.1 | 607.944 |

<a id="sec-3-10-5"></a>

# 3.10.5 Detection of Spurious Local Maximizers

As noted in the previous section; spurious solutions typically have a small number of points in at least one cluster which has a relatively small generalized variance. Hence the ratio of the fitted generalized component variances can be a useful guide; or warning, that a spurious solution has been found. A more informative approach is to examine the actual eigenvalues of the covariance matrix in question; rather than the determinant (which is the product of the eigenvalues). The individual eigenval ues offer a much better reflection of the shape of the clusters, with each eigenvalue corresponding to the variance along the elliptical axis (eigenvector) of the cluster. In this way the user can discern between small compact clusters and long thin clusters.

There is also a need to monitor the distances bctween the fitted component means where there appear to be spurious local maximizers. The Euclidean distances between apparent spurious and nonspurious component means could be calculated, but may be unreliable if the feature variables are measured on disparate scales. In such cases, one may want to consider the Mahalanobis distances between the apparent spurious and nonspurious component means; using as covariance matrix the estimated covariance matrix for the relevant nonspurious component. Even then, small intercomponent mean distances need not reflect spurious clusters, as one can have a situation where twoclusters have similar means but are different in shape due to their covariance quite matrices 'quitedisparate; see Figure 3.10. Hence there is really a needto monitor the distances between points in an apparent spurious cluster and the points in nearby nonspurious clusters. being

Fig. 3.10 Representation of a legitimate solution that would seem spurious when only intercomponent mean distances are considered .

<a id="sec-3-10-6"></a>

# 3.10.6 Example 3.9: Galaxy Data Set

To illustrate the point that a relatively small component variance does not necessarily imply a spurious solution; we consider the galaxy data set analyzed in Roeder (1990) This set contains measurements of the velocities of 82 galaxies diverging away from OUr own galaxy. In Figure 3.11 we give the plot of the six-component solution corresponding to the largest of the local maximizers found, with the data in histogram form. The estimated component variances are given in Table 3.8. along From Figure 3.11 we have a seemingly spurious solution; the two small clusters centered around 16 and 26.98, corresponding to components 2 and 5, have relatively very small variances . However; on closer examination, it seems reasonable that the clusters in the center of the data set. This can only be confirmed if more observations become available. For this data set, Richardson and Green (1997) concluded from their approach that the number of components ranged from 5 to 7, while McLachlan and Peel (1997b) provided support for 9 components.

0,15

1

Fig. 3.11 Plot of fitted six-component normal mixture density for galaxy data set.

Table 3.8 A

| Component i | Ti    |        |           |
| ----------- | ----- | ------ | --------- |
|             | 0.085 | 9.710  | 0.178515  |
| 2           | 0.024 | 16.127 | 0.001849  |
| 3           | 0.037 | 33.044 | 0,849564  |
| 4           | 0.425 | 22.920 | 1.,444820 |
| 5           | 0.024 | 26.978 | 0.00030   |
| 6           | 0.404 | 19.790 | 0.454717  |

Another property of spurious solutions is that the EM algorithm converges to them very rarely and often only when a particular starting is given: This reflects a very localized peak in the likelihood function. This is a tell-tale sign that a spurious solutionhas been found. This ideais very useful since potentially legitimate solutions such as the one seen in the galaxy data set example above will not have this property. However, for extremely data sets, especially where not enough clusters are fitted, the repeatability aspect might not be as useful. point large

<a id="sec-3-11"></a>

# 3.11 EXAMPLE 3.10: PREVALENCE OF LOCAL MAXIMIZERS

We consider now the well-known set of Iris data as originally collected by Anderson (1935) and first analyzed by Fisher (1936). It consists of measurements of the length and width of both and of 50 plants for each of three types of Iris species setosa, versicolor, and virginica. As pointed out by Wilson (1982), the Iris data were collected originally by Anderson (1935) with the view to seeing whether there was "evidence of continuing evolution in any group of plants: The aural approach of Wilson (1982) to data analysis suggested that both the versicolor and virginica species should each be split into two subspecies. sepals petals

Hence we focus on the clustering of the n = 50 observations in the Iris virginica set, which are plotted in Figure 3.12in the space of the first two principalcomponents the sample correlation matrix of the data. We considered a clustering of this data set into two clusters C1 and C2 by a mixture of two heteroscedastic normal components. The membership of the smaller-sized cluster (C1) is reported in Table 3.9 for the clustering implied by each of fifteen solutions of the likelihood equation. Also listed in Table 3.9 for each of these local maximizers is the value of using fitting the determinant of each of the two component-covariance matrices, |B1l and and the value of the likelihood. The clustering implied by the first solution S1 listed in Table 3.9, which had been obtained previously by Wilson (1982), has nine observations in the first cluster. This solution can be found by running the EM algorithm from an initial partition of the data given by either Ward's or the farthest neighbor hierarchical clustering procedures in standardized or unstandardized forms. It can also be found using random starts, but our results suggest that a very number of random starts is needed if it is to be found with a high degree of probability in a given run. It was not found when running the EM algorithm from the initial partition provided by the k-means algorithm; which was carried out 1,000 times, different initial seeds each time. On each of these 1,000 runs, the EM algorithm so initialized converged to the same local maximum; which was less than the local maximum with S1. log large using It can be seen from Figure 3.12 that the nine in the smaller-sized cluster C1 of solution S1 lie in an extreme portion of the scatter plot of the first two principal components using the sample correlation matrix of the data; and they can be separated almost from the other points by a straight line. However, on the question of whether there are signs of continuing evolution in the virginica species; this two-group structure would not be considered significant at a conventional level: The value of ~2log X for the test of g = 1 versus g =2is43.2. The assessed P-value, as obtained by resampling on the basis of 99 replications; is 409 . Since 9 = 1 under the null hypothesis; the bootstrap replications of ~2log X are actual applications of this test statistic. points In order to demonstrate the occurrence of multiple maxima, some of which may be spurious; in data sets without a strong group structure; we ran the stochastic version of the EM algorithm (Celeux and Diebolt, 1985) from 1,000 random starting points; limiting attention to solutions at which the likelihood had a greater value than that for the first solution S1. The stochastic version allows the EM algorithmto have a chance to escape from the current EM sequence. But evidently in this example, such escapes often led to convergence in the end to what we have concluded to be spurious local maximizers. In Table 3.9 we list fourteen such solutions found, labeled S2 to S15, in order of increasing value of the corresponding local maxima. They are a selection from the 51 distinct local maxima found that were greater than that for S1 and include the six largest found. Given the imbalance in the estimates of the component generalized variances for these fourteen solutions, would appear to be spurious. However; it is not suggested that the clustering of a data set should be based solely on single solution of the likelihood equation; but rather on the various solutions considered collectively. The smaller-sized clusters implied by eight of these fourteen solutions have only five members. Hence given that the data are of dimension p = 4,it is not surprising that the fittedcovariance matrix for the first component of the mixture is nearly singular foreach of them; with ageneralized variance equal toonly 7.6x or smaller. In this sense, these eight solutions would be regarded as spurious. Not withstanding that, the solutions S2, S4, S6, and S13 provide some support to the clustering implied by S1 in that at least four ofthe five members of the first cluster C1 implied by these four solutions (actually all five members except in the case of S6 are subset of C1 as implied by S1. The first clusters C1 implied by the solutions S, to S12 have no members in common with that of S1. Further; it can be confirmed from scatter plots and the Mahalanobis distances between the fitted component means that solutions S3, S5, S7 to S12, S14, and S15 do not provide as much separation between the means of the implied clusters. Thus these solutions would appear to be more spurious in nature rather than representing a genuine grouping. In Table 3.10 we have listed for each solution the Mahalanobis squared distance between the two fitted component means and also the average Mahalanobis squared distance between the points in the smaller- and larger-sized clusters. In each instance, the covariance matrix used in these calculations was the estimated component-covariance matrix corresponding t0 the larger-sized cluster. they they 10-8

![image 12](mclachlan2000_images/imageFile12.png)

Another way of proceeding to reduce the prevalence of solutions corresponding to artificially small values of the generalized fitted variances is to restrict the covariance matrices to be the same. Under homoscedasticity; the first cluster implied by the ML solution (assuming it is the global maximizer) contains the union of all members of the first clusters implied by the heteroscedastic solutions S1, S2, S4, S6, and S13, with observations 9 and 36. The solution corresponding to the largest maximum located under the less restrictive assumption ofequal correlation matrices gives almost the same clustering as S4, but with the observation numbered 31 moved to the largersized cluster. The solution corresponding to the second largest of the local maxima located under the assumption of equal correlation matrices gives the same clustering as S1 . along

Table 3.9 Results of Fitting a Mixture of g = 2 Heteroscedastic Normal Components to Iris Virginica Species

| Solution No. | Cluster C1                             | L      | 2           |             |
| ------------ | -------------------------------------- | ------ | ----------- | ----------- |
|              | 6,8,18,19,23, 26,30,31,32              | 36.994 | 1.4 x 10-6  | 3.7 x 10-5  |
| 2            | 6,18,19,23,32                          | 36.987 | 7.6 x 10-8  | x 10-5 5.2  |
| 3            | 10,13,17,21,26 30,32,40,41,42 44,46,47 | 35.622 | 2.9 x 10-7  | 7.3 x 10-5  |
| 4            | 6,18,19,23,31                          | 35.406 | 6.8 x 10-9  | 6.3 x 10-5  |
| 5            | 5,18,21,32,35 , 40,41,42,44,46         | 34,427 | 6.2 x 10-8  | 7.2 x 10-5  |
| 6            | 6,18,19,32,35                          | 34.063 | 1.5 x 10-8  | 5.5 x 10-5  |
| 7            | 32,36,43                               |        | 10-9        | 9.7 x 10-5  |
| 8            | 2,7,13,20,30 32,36,43                  | 32.862 | 3.5 x 10-10 | 1.4 x 10-4  |
|              | 1,16,41,42,45 46,49                    | 32.225 | 4.1 X 10-8  | 8.8 x 10-5  |
| 10           | 1,37,41,42,49                          | 30.374 | 2.9 x 10-11 | 9.3 x 10-5  |
| 11           | 20,35,42,46,47                         | 29.756 | 8.0 x 10-11 | 8.0 x 10 -5 |
| 12           | 2,7,17,40,42, 43,48                    | 28.581 | 7.6 x 10-11 | 1.2 x 10~4  |
| 13           | 8,19,23,30,31                          | 27.899 | 8.0 x 10-11 | 7.4 x 10-5  |
| 14           | 8,19,23,28,39                          | 25.071 | 1.3 x 10-11 | 8.0 x 10-5  |
| 15           | 3,6,17,39,40                           | 23.536 | 8.9 x 10-12 | 1.4 x       |

Table 3.10 Intercomponent Mean and Point Mahalanobis Squared Distances

| Solution |         | Intercomponent Mean Distance | Intercomponent Point Distance |
| -------- | ------- | ---------------------------- | ----------------------------- |
|          | 36.994  | 11.12                        | 16.78                         |
| 2        | ~36.987 | 8.77                         | 16.48                         |
| 3        | ~35.622 | 1.78                         | 5.40                          |
| 5        | ~35.406 | 9.96                         | 14.52                         |
|          | ~34.427 | 0,40                         | 7.21                          |
| 6        | ~34.063 | 5.62                         | 14.27                         |
| 7        | 33.690  | 0.49                         | 6.09                          |
| 8        | ~32.862 | 0.80                         | 2.03                          |
| 9        | ~32.225 | 3.96                         | 7.45                          |
| 10       |         | 1.52                         | 6.31                          |
| 11       | 29.756  | 2.29                         | 9.80                          |
| 12       | 28.581  | 0.79                         | 4.53                          |
| 13       | ~27.899 | 8.47                         | 12.05                         |
| 14       | 25.071  | 2.05                         | 11.04                         |
| 15       | 23.536  | 0.96                         | 3.92                          |

<a id="sec-3-12"></a>

# 3.12 ALTERNATIVE MODELS FOR COMPONENT-COVARIANCE MATRICES

<a id="sec-3-12-1"></a>

# 3.12.1 Spectral Representation

Wehave seen that ag-component normal mixture model with unrestrictedcomponenteach component-covariance matrix $Z_j$ (i = 1, 9). Banfield and Raftery (1993) introduced a parameterization of the component-covariance matrix $Z_j$ based on a variant of the standard spectral decomposition of $Z_j$,

$$
\Sigma _ { i } = \sum \lambda _ { i v } a _ { i v } a _ { i v } ^ { T } ,
$$

where denote the eigenvectors corresponding to the eigenvalues À;1 2 9) expressed $Z_j$ further as Q;l, Qip They Another requires

$$
( 3 . 2 6 )
$$

where A; = (ail, ) is the (orthogonal) matrix of the eigenvectors of $Z_j$. Conventions for normalizing X; and A; include taking X; = X;1 (the largest eigenvalue of S;) for which then aip

$$
( 3 . 2 7 )
$$

$$
\Lambda _ { i } = d i a g ( \lambda _ { i 1 } / \lambda _ { i } , \dots
$$

The parameter X; controls the volume of the cluster corresponding to the ith component, A; its shape; and A; its orientation. A reduction in the number of parameters the constraint A; = A (i = 1, 9) imposes the same orientation on the g clusters.

Applications of mixture models under the model (3.26) for the component-covar iance matrices have been considered since by Bensmail and Celeux (1996), Bensmail et al. (1997), Campbell et al. (1997), Dasgupta and Raftery (1998), and Fraley and Raftery (1998).

<a id="sec-3-12-2"></a>

# 3.12.2 Example 3.11: Minefield Data Set

We consider the simulated minefield data as analyzed by Dasgupta and Raftery (1998) and Fraley and Raftery (1998); see Figure 3.13. The data arose from the processing of a series of images taken by a reconnaissance aircraft in which a large number of points are identified as representing possible mines, but many ofthese are in fact false positives (noise). The assumption is that the imaged area does not lie completely within a minefield, and that if there is a minefield , it will occur in an area where there is higher density of identified points. The aims were to determine whether the image contains one or more minefields, and to give the location of any minefields that may be present. The denoising of the data in Figure 3.13 was undertaken the nearest-neighbor-based procedure of Byers and Raftery (1998). using

Dasgupta and Raftery (1998) fitted a g-component normal mixture for various 9 plus a uniform component (with unknown mixing proportion),

$$
f _ { 0 } ( y _ { j } ) = 1 / v ,
$$

corresponding to the background noise (clutter), such as other metal objects and rocks, which was assumed to be distributed as a homogeneous spatial Poisson point

![image 13](mclachlan2000_images/imageFile13.png)

<a id="sec-simulated-minefield-with-noise"></a>

**Simulated Minefield with Noise**

<a id="sec-denoised-minefield-data"></a>

**Denoised Minefield Data**

g

8

8

8

8

8

20

80

100

120

120

60

80

20

40

BIC for the Minefield Data

Model-Based Classification

8

8

8

8

8

constant

unconstrained

120

100

20

40

60

8

10

15

Fig. 3.13 Simulated minefield with noise and mixture modcl-basedclustering after a nearest neighbor denoising. From and Raftery (1998) Fraley

computed as the volume of the smallest hyperrectangle with sides parallel to the axes that contains all the data points. However, as noted by Fraley and Raftery (1998), this could overestimate v in many cases. Other possibilities include taking v to be the volume of the smallest hyperrectangle with sides parallel to the principal component axes that contains all the data points Or taking v to be the volume of the convex hull of the data.

To specify the component-covariance matrices; Dasgupta and Raftery (1998) used the parameterized forms (3.26) and (3.27) for the S;. Of particular interest in this application for p 2 dimensions is the model in which the shapes of the clusters implied by (3.26) are the same, but the volumes and orientations are different. That is,

$$
\Lambda _ { i } = \text {diag} ( 1 , \, \alpha ) \ \ ( i = 1 , \dots , g ) ,
$$

where œ < 1 is the common value of the ratio of the second to first eigenvalue; will be tend to be and narrow (highly linear), as in the case of minefields: they long

From the plot of the BIC criterion in Figure 3.13,it can be seen that three clusters (g = 2 normal components plus the noise component) and component-covariance matrices of the same shape (a; œ) and equal volume (X; = X1) for i = 1,2 are favored. Note that the BIC criterion in Figure 3.13 is written as the negative of its usual form (see Section 6.9.3).

<a id="sec-3-13"></a>

# 3.13 SOME OTHER MODELS

In this section we consider normal mixture models for some experimental designs that involve more than a simple random sample having been observed on the phenomenon under study. There is also the work of Wedel, ter Hofstede, and Steenkamp (1998), who have investigated the effects of a complex sampling design on the estimation of mixture models.

<a id="sec-3-13-1"></a>

# 3.13.1 Clustering of Treatment Means in ANOVA

A common problem in practice is the analysis of experiments designed to compare treatments. In the situation where an analysis of variance (ANOVA) leads to a significant F-test for the difference between treatment means, there is the problem of isolating those treatments that do not appear to be different. This problem continues to attract attention in the literature; see, for example, Bautista, Smith, and Steiner (1997) and a comment on this paper by McLachlan (2000)

One approach to this problem is to cluster the treatment means. The possibility of using cluster analysis in place of multiplecomparison procedures had been suggested by O'Neill and Wetherill (1971). In the discussion of this paper, Nelder (1971) commented that one of the patterns to look for in the sample means of the treatments was whether 'the means divide into two or more groups within which look like samples from normal distributions:' The normal mixture model-based approach to this problem, as developed in Aitkin (1980) and Basford and McLachlan (1985b) is in keeping with the spirit of this comment. they variances to 02 /r1, 02 |rn, respectively; where rj denotes the number of observations made on the jth treatment. In addition, s2 denotes an independent estimate of 02 , distributed as equal

With this mixture approach, the n treatment means, denoted here by 91, are assumed to be distributed (independently) about their means p1,

$$
\nu s ^ { 2 } / \sigma ^ { 2 } \sim \chi _ { \nu } ^ { 2 } .
$$

This covers various experimental designs, including a completely randomized design with unequal replicates and, for equal rj, more involved designs with equireplicated treatments; see McLachlan and Basford (1988, Chapter 6).

Under a normal mixture model with g components; it is assumed further that /; is distributed as

$$
\sigma ^ { 2 } / r _ { j } ) \quad \text {in} \ G _ { i } \text { with prob. } \pi _ { i } \quad ( i = 1 , \dots , g ) .
$$

The likelihood for the vector of unknown parameters formed on the basis of g1, In under the mixture model (3.30) and also s2 under (3.29) is given, up to terms not involving the unknown parameters, by

$$
\log L ( \Psi ) = \sum _ { j = 1 } ^ { n } \log \sum _ { i = 1 } ^ { y } \pi _ { i } \phi ( y _ { j } ; \mu _ { i } , \sigma ^ { 2 } / r _ { j } ) - \frac { 1 } { 2 } \nu \log \sigma ^ { 2 } - \frac { 1 } { 2 } \nu s ^ { 2 } / \sigma ^ { 2 } . \quad ( 3 . 3 1 )
$$

This mixture model can be fitted to the treatments using the EM algorithm. The FORTRANlisting ofaprogram for this purpose is given in the appendix ofMcLachlan and Basford (1988). A probabilistic clustering of the treatments is obtained in terms of their fitted posterior probabilities of component membership. An outright clustering into distinct groups is obtained by assigning each treatment mean to the group to which it has the highest posterior probability of belonging:

McLachlan (2000) applied this approach to the six treatments in the example considered by Bautistaet al. (1997). These treatments, designated as 3DOkI, 3DOkS , 3DOk7 COMP, 3DOk4, and 3DOk13 , have means equal to 28.82, 23.98, 19.92, 18.70, 14.74, and 13.26, respectively. For 9 = 2,it results in the first four treatments being clustered into one group and the remaining two in another group. For 9 = 3, the first two treatments are grouped together in one cluster; the next three in another; while the last treatment forms a group on its own. These partitions of the treatment means agree with those of Bautista et al. (1997) On the question of whether there should be 9 =2 or 3 groups, the value of \_2 X (that is, twice the increase in the likelihood for 9 2 3 over g =2) is 4.702. An assessment of the P-value can be obtained by using a resampling approach as in McLachlan (1987). Its application here with B 19 bootstrap replications leads to the null hypothesis of g = 2 groups being retained at any conventional level of significance. log ~ log

<a id="sec-3-13-2"></a>

# 3.13.2 Three-Way Models

Normal mixture models have been applied successfully to so-called three-way data by Basford and McLachlan (1985c) and, more recently; by Hunt and Basford (1999) in the case where there are also categorical data present` Specifically, in the terminology of Basford and McLachlan (1985c), suppose we wish tocluster genotypes on the basis of genotype by attribute by environment data. We let the observation

$$
y _ { j } = ( y _ { j 1 } ^ { T } , \dots , y _ { j } ^ { T } )
$$

contain the multiattribute responses of the jth genotype in all r environments, where Ujm is a vector of dimension p giving the response of the jth genotype in the mth environment (m = 1, The vectors Vjm (j = 1, n; m = 1, are taken to be independently distributed, Under the mixture model proposed by Basford and McLachlan (1985d),it is assumed that each genotype belongs to one of g possible groups G1, Gg in proportions $\pi_1$, Tg, so that in a given environment m,

$$
Y _ { j } \sim N ( \mu _ { i _ { m } } , \Sigma _ { i } ) \quad \text {in} \, G _ { i } \text { with probability} \, \pi _ { i } \quad ( i = 1 , \dots , g ) .
$$

The group-conditionalcovariance matrix $Z_j$ is taken not todepend on the environment. This model covers the general situation where there may be some interpretation between genotypes and environments.

<a id="sec-3-13-3"></a>

# 3.13.3 Example 3.12: Consumer Data on Cat Food

To illustrate the use of a normal mixture model to so-called three-way data, we consider here the consumer study on a cat food trial, as analyzed in Jones and McLachlan (1992b) using mixtures of normal linear regression models. In other work on mixtures of normal regression models; Quandt and Ramsey (1978) and Kiefer (1978) studied the case of data comprising two regression equations; including the use of moment generating function techniques for parameter estimation. De Veaux (1989) developed an EM approach to the two regression situation. Similar estimating equations were used by DeSarbo Cron (1988) for the case of relating an attribute scored by individuals to auxiliary information on the individuals and where the number of groups in the data were unknown. Mixtures of generalized linear models are to be covered in some depth in Chapter 5 . applied fitting and

Jones and McLachlan (1992) considered the assessment of r = 10 different cat food ilems by n = 86 individuals who rated the products with regard to p = attributes: appearance, texture, aroma and overall acceptability. Sothisis a three-way data set, consisting of data on individuals by attributes by items. For each of these attributes, the consumers marked a survey sheet on a scale that ranged between and 100. These measurements were scaled to lie between ~1 and before the following analyses. In this example; an auxiliary measurement was taken. It consisted of a variable derived from scores of the products made by an expert sensory These scores were composed from a variety of individual descriptors of meat quality and also took values between 0 and 100. These scores were reduced to a single dimension principal component analysis and this dimension was interpreted as measuring the "chunkiness" of the products. Its values over the ten products ranged between ~2 and 2 panel. using Jones and McLachlan (1992b) proposed a normal mixture model with g components corresponding to the existence of g groups G1, G, among the individuals. Under their model, the vector Ujr containing the scores by the jth individual for the = 4 attributes for the mth item is assumed to be normally distributed with mean in each group related by a linear regression model to the auxiliary measurement zm; that is,

$$
Y _ { j m } \sim N ( \beta _ { i } x _ { m } , \Sigma _ { i } ) \ \text { in } \ G _ { i } = ( i = 1 , \dots , g ) ,
$$

1 vector of parameters for group i and æm is the auxiliary measurement for the mth item. The likelihood was formed under the assumption of independence of the log

In Table 3.11 we report the estimates obtained by Jones and McLachlan (1992b) for the regression coefficients and the attribute variances for g 1 to 3 groups. From the coefficients in Table 3.11, Jones and McLachlan (1992) inferred that the group with the largest proportion of consumers places the least weight on the "chunkiness' of the product, and the other two groups place increasing weight on this aspect of the product. This was of interest at the time to product developers as 'chunkiness" was one of the strong selling points for this type of product in advertising campaigns. The third attribute; aroma; had (as one would expect) the weakest link with "chunkiness" of the four variables over all three groups. This attribute also had the largest variance within each of the three groups.

Table3.11 Attribute Regression Coefficients for Three-Group Clustering ofEighty-Six Subjects in a Cat Food Trial

| No. Group |     | Regression Coefficients Attribute |     |     |     | Variances Attribute |     |     |     |
| --------- | --- | --------------------------------- | --- | --- | --- | ------------------- | --- | --- | --- |
|           | Ti  |                                   | 2   |     |     |                     | 2   |     |     |
|           | 41  | 055                               | 132 | 019 | 098 | 097                 | 084 | 100 | 091 |
|           | 09  | 021                               | 018 | 021 | 031 | 010                 | 007 | 008 | 007 |
| 2         | 31  | 126                               | 161 | 120 | 137 | 086                 | 077 | 087 | 083 |
|           | 05  | 027                               | 016 | 041 | 018 | 007                 | 006 | 007 | 007 |
| 3         | 27  | 237                               | 277 | 071 | 213 | 049                 | 031 | 095 | 059 |
|           | 07  | 020                               | 022 | 017 | 017 | 007                 | 008 | 009 | 007 |

Source: Adapted from Jones and McLachlan (1992b)

<a id="sec-3-13-4"></a>

# 3.13.4 Errors-In-Variables Model

To further illustrate the usefulness of normal mixture models in providing a flexible framework for parametric modeling, we briefly consider the errors-in-variables problem studied by Carroll, Roeder; and Wasserman (1999). In a typical erTors in-variables model, the response variable Yj is functionally related to a predictor variable U; that is unobserved because either it is impractical or impossible to mea sure it directly. To compensate, a surrogate variable X; is observed instead of the latent predictor variable UjThis surrogate variable is assumed to be related to the truth by a simple measurement process. The simplest example of such a model is the basic measurement error model,

$$
\begin{array} { r l r } { Y _ { j } } & = } & { \beta _ { 0 } + \beta _ { 1 } U _ { j } + \epsilon _ { j } , } \\ { X _ { j } } & = } & { U _ { j } + e _ { j } , } \end{array}
$$

where €j and ej are independent of U; . The random variable $Y_j$ has mean # and variance 02, ej has mean zero and variance 0?, and €j has mean zero and variance ; all these random variables are uncorrelated. Carroll et al. (1999) considered a version of this model with missing surrogate data and a change-point Berkson model. Their model was motivated by a dietary assessment study where $Y_j$ corresponds to the Food Frequency Questionnaire (FFQ) and Xj t0 the multiple-day food record (FR) The unobservable U; corresponds to the true long-term usual daily diet. Data on is observed for a number ( M) of individuals. At the second stage, a smaller number of these individuals are selected by stratified sampling on the basis of their F'FQ scores. On each individual so selected, the FRis observed for a number of as it is an imprecise measurement of the true usual intake. days,

For this missing-data version of the errors-in-variables problem; the method of moments is still consistent and asymptotically efficient. But the other commonly used approach, maximum likelihood based on all random variables normally distributed, is not. By modeling the distribution of U; by a mixture of g normal distributions; Carroll et al. (1999) were able to provide a parametric model that has the efficiencies of a parametric model but also shares the robustness properties of the method of moments estimator. The mixture model can be fitted in either a frequentist framework Or a Bayesian framework. Carroll et al. (1999) adopted the latter approach, using the posterior simulation methods to be described in the next chapter. They were able also to develop a similar model for the change-point problem by modeling the measurement error by a normal mixture. being

4

