<a id="sec-assessing-the-number-of-components-in-mixture-models"></a>

# Assessing the Number of Components in Mixture Models

<a id="sec-6-1"></a>

# 6.1 INTRODUCTION

<a id="sec-6-1-1"></a>

# 6.1.1 Some Practical Issues

Testing for the number of components g in a mixture is an important but very diffi cult problem which has not been completely resolved. We have seen in the previous chapters that finite mixture distributions are employed in the modeling of data with two main purposes in mind. One is to provide an appealing semiparametric framework in which to model unknown distributional shapes, as an alternative say, the kernel density method; see Escobar and West (1995), Robert (1996), and Roeder and Wasserman (1997). The other is to use the mixture model to provide a modelbased clustering. In both situations; there is the question of how many components to include in the mixture. to,

In the former situation of density estimation, the commonly used criteria of AIC and BIC would appear to be adequate for choosing the number of components 9 for a suitable density estimate. In particular, Leroux (1992a) established under mild conditions that certain penalized likelihood criteria, including AIC and BIC, do not underestimate the true number of components, asymptotically. Roeder and Wasserman (1997) have shown that when anormal mixture model is used toestimate a density "nonparametrically" the density estimate that uses BIC to select the number of components in the mixture is consistent. Other satisfactory conclusions for the use of AIC or BIC in this situation are discussed in Biernacki, Celeux, and Govaert (1998), wwik and Koronacki (1997), and Solka et al. (1998) log In this chapter we shall concentrate on the choice of the number of components in the latter situation where the mixture model is used in a clustering context. In cluster or latent class analyses, the choice of the number of components arises with the question of how many clusters or classes there are.

As discussed in Roeder (1994), if no information is available concerning the component densities, then arguably this problem is more appropriately considered in terms of an assessment of the number of modes. Inferential procedures for assessing the number of modes of a distribution are described by Titterington et al. (1985, Section 5.6) including the univariate technique of Silverman (1981, 1986) which uses the kernel method to estimate the density function nonparametrically and which permits the assessment of modality under certain circumstances. Other papers on tests for the number of modes include Hartigan and Hartigan (1985), Wong (1985), Hartigan (1988), Hartigan and Mohanty (1992), and Fisher, Mammen, and Marron (1994). However, a drawback of this approach is that the components of the mixture have to be fairly wide apart in order to bedetected. As seen in Section 1.5.1,a mixture distribution can be unimodal if the components are not sufficiently far apart. prior

The specification of a parametric family for the component densities may have a major impact on the clustering so obtained. In Section 6.2 we shall present an analysis of some stamp data, where the number of types of paper used in the production of these stamps depends on whether the component variances should be comparable in size

Another practical issue arises with the parametric specification of the component densities when the number of components in a mixture model are taken to reflect the number of distinct groups in a population: As noted in Section 1.5.2, modeling the distribution of data that have asymmetrical distributions. Indeed, any continuous distribution can be approximated arbitrarily well by a finite mixture of normal densities with common variance (or covariance matrix in the multivariate case) Thus if a normal mixture used todetect the presence of grouping in somedata; then there may not be a one-to-one correspondence between the mixture components and the groups if the data have a skewed distribution within some of the groups. This is because more than one normal component may be needed to model a skewed group-conditional distribution (Section 1.6). We shall illustrate this problem in Section 6.1.3, using the case study of Gutierrez et al. (1995), in which there is an adjustment for skewness in the of the normal mixture model. being being fitting

<a id="sec-6-1-2"></a>

# 6.1.2 Order of a Mixture Model

Cutler and Windham (1994) explain some of the difficulties in discussing the choice of functionals, which are measures of goodness-of-fit of a model for a given number of components 9 They note that one difficulty has been discussed by Donoho (1988), who out that; "near any distribution of interest, there are empirically indistinguishable distributions (indistinguishable at a given sample size) where the functional takes on arbitrarily values: A mixture density with 9 components might be empirically indistinguishable from one with either fewer than g components points Or more than g components. It is therefore sensible in practice to approach the question of the number of components in a mixture model in terms of an assessment of the smallest number of components in the mixture compatible with the data. To this end, the true order 9 of the g-component mixture model

$$
f ( $y_j$ \Psi ) = \sum _ { i } \pi _ { i } \, f _ { i } ( $y_j$ \theta _ { i } )
$$

different and all the associated mixing proportions Ti are nonzero.

<a id="sec-6-1-3"></a>

# 6.1.3 Example 6.1: Adjusting for Effect of Skewness on the LRT

The effect of skewness on hypothesis tests for the number of components in normal mixture models has been discussed in Section 1.6. In the work of Maclean et al. (1976), Schork and Schork (1988), and Gutierrez et al. (1995) on this problem, the Box-Cox (1964) transformation is employed initially in an attempt to obtain normal components . Hence to model some univariate data y1 , Yn by a two-component mixture distribution, the density of Yj is taken to be

where

$$
f ( y _ { j } ; \Psi ) = \{ \pi _ { 1 } \phi ( y _ { j } ^ { ( \zeta ) } ; \mu _ { 1 } , \sigma _ { 1 } ^ { 2 } ) + \pi _ { 2 } \phi ( y _ { j } ^ { ( \zeta ) } ; \mu _ { 2 } , \sigma _ { 2 } ^ { 2 } ) \} \, y _ { j } ^ { \zeta - 1 } ,
$$

$$
y ^ { ( \zeta ) } \ & = \ ( y _ { j } ^ { \zeta } - 1 ) / \zeta \quad \text {if } \zeta \neq 0 , \\ & = \ \log y _ { j } \quad \text {if } \zeta = 0 ,
$$

and where the last term on the right-hand side of (6.2) corresponds to the Jacobian of the transformation from to Yj -

Gutierrez et al. (1995) adopted this mixture model of transformed normal components in an attempt to identify the number of underlying physical phenomena behind tomato root initiation; The observation %j corresponds to the inverse proportion of the jth lateral root which expresses GUS (j =1, 40). This measurement is a possible indicator of the number of initial cells in the lateral root\_ In Figure 6.1 we report the kernel density estimate and the normal Q-Q plot ofthe $y_j$ . It shows that the data are clearly skewed with a mode at $y_j$ = 2 initial cells. However; Gutierrez et al. (1995) noted that if the reciprocals of the data are used, then the 'population appears to be normally distributed; see Figure 6.2. confirmed this by the application of the likelihood ratio test (LRT) for homogeneity versus a two-component normal model applied to the data; firstly in their original form and then to the reciprocals of the data. The P-values for these two tests were equal to 0.012 and 0.955, respectively. The former P-value was obtained through their simulation of the null distribution of the likelihood ratio test statistic (LRTS) , X, which yielded a distribution bounded As the primary interest of Gutierrez et al. (1995) was in determining whether the observed data were They ~2log - the result of one or possibly two underlying physical phenomena; reanalyzed the data; adjusting for skewness through the use of the mixture model (6.2). For fixed Ç this model can be fitted by ML estimation as for a two-component normal mixture, and so it was fitted unconditionally through a search over (. The parameter estimates so obtained were Ç = and #1 0.91. That Ç is closer to ~1 than 1 reveals that y5 is more conducive to the normal mixture model (6.2) The P-value for the LRT of g = 1 versus g 2 was found by simulation to be 0.957. The null distribution of the LRTS was virtually unaffected by the transformation; which was anticipated from usual likelihood theory given that a free parameter was added under both the null and alternative hypotheses. Thus when the Box-Cox adjustment is made for skewness; the LRT is nonsignificant, grid and so there is little evidence of any major secondary underlying phenomena. Subsequent simulations by Gutierrez et al. (1995) indicated that the power of the LRT here is less than 109 and that a sample size of n > 350 would be needed to attain a power of 509. These simulations also revealed that there is little drop in power in the Box-Cox transformation . using

![image 18](mclachlan2000_images/imageFile18.png)

Fig. 6.1 From Gutienez et al. (1995)

25

25

20

20

1d

1

05

15

0.0

0.5

10

410

05

2.0

2.5

25 .20

05

0.5

10

2,0

25

15

15

0,6

Quantiles of Standard Normal

Fig. 6.2 From Gutierrez et al. (1995).

<a id="sec-6-2"></a>

# 6.2 EXAMPLE 6.2: 1872 HIDALGO STAMP ISSUE OF MEXICO

Izenman and Sommer (1988) considered the modeling of the distribution of stamp thickness for the printing of a given stamp issue from different types of paper. Their main concern was the application of the nonparametric approach to identify components by the resulting placement of modes in the density estimate. The specific example of a philatelic mixture, the 1872 Hidalgo issue of Mexico, was used as a particularly graphic demonstration of the combination of a statistical investigation and extensive historical data to reach conclusions regarding the mixture components.

For comparison with a parametric approach, Izenman and Sommer (1988) fitted by maximum likelihood a mixture of normal components with unequal variances to the data. They used the LRTS, as modified by the rule of thumb of Wolfe (1971), to test for the smallest number g of components compatible with the data. It yielded 9 = 3components; which is in apparent conflict with their nonparametric solution of seven modes\_ In an attempt to resolve this conflict, Basford, McLachlan, and York (1997b) considered further the of a normal mixture model to the data. demonstrated that by restricting the component variances to be the same, the LRT for the smallest number of components in the mixture model ultimately leads to results consistent with the nonparametric approach. fitting They

The data as analyzed by Izenman and Sommer (1988) are displayed in histogram form in Figure 6.3. are the thicknesses in mm of 485 unwatermarked used white wove stamps. Izenman and Sommer (1988) tested for multimodality; using nonparametric kernel density estimation techniques (Silverman, 1981) t0 determine the most probable number of modes in the underlying density. They concluded that the stamp thickness data were consistent with an underlying density having seven modes. the extensive historical information, plus an analysis of some related data (the 1868 issue), concluded that seven modes was a sensible description of these data; that is, it is plausible that paper of seven diffcrent thicknesses was used in the production of this stamp issue. They Using they

For comparison with the nonparametric mode technique, Izenman and Sommer (1988) fitted a mixture of seven normal distributions with unrestricted variances; see Figure 6.3. This produced a consistent result in the sense that the parametrically fitted mixture density had modes at almost the same locations as the seven modes previously determined. fitting

Actually, Basford et al. (1997b) located another 9 solution corresponding to a larger local maximum of the likelihood function: It differs from the latter by devoting component to model the outlying observations in the lower tail of the data. It thus

![image 19](mclachlan2000_images/imageFile19.png)

Fig. 6.3 Plot of g = 7-component normal mixture fit with unrestricted variances given by Izenman and Sommer (1988). From Basford et al. (1997b).

uses only one rather than two components to model the modes in the histogram at

9 = 1, Izenman and Sommer (1988) determined that only 9 =3 components in the heteroscedastic normal mixture model were needed. This fit (Figure 6.4) is given by

$$
0 . 1 9 6 N ( 0 . 0 7 1 2 , \ 0 . 0 0 0 0 1 7 6 ) + 0 . 3 6 7 N ( 0 . 0 7 8 6 , \ 0 . 0 0 0 0 5 6 4 ) \\ + 0 . 4 3 7 N ( 0 . 0 9 8 9 , \ 0 . 0 0 0 1 9 6 6 6 ) .
$$

The values of the likelihood for g = 1 to 9 are listed in Table 6.1 for both log unrestricted and equal variances for the normal components.

![image 20](mclachlan2000_images/imageFile20.png)

6.4 Plot of g 3-component normal mixture fit with unrestricted variances. From Basford et al. (1997). Fig.

Table 6.1 Valuc of the Likelihood for g = 1 to 9 Normal Components Log

| Number of Components | Unrestricted Variances | Equal Variances |
| -------------------- | ---------------------- | --------------- |
|                      | 1350.3                 | 1350.3          |
| 2                    | 1484.8                 | 1442.6          |
| 3                    | 1518.8                 | 1475.7          |
| 4                    | 1521.9                 | 1487.4          |
| 5                    | 1527.1                 | 1489.5          |
|                      |                        | 1512.9          |
| 6                    | 1538.7                 | 1525.3          |
| 8                    | 1544.1                 | 1535.1          |
| 9                    | 1552.2                 | 1536.5          |

Source: From Basford et al. (1997).

Besides the assessment of g by testing, = as above, for its smallest value compatible with the data; other practical considerations are important if a sensible description or summary of the data is to be reached. For instance; if a mixture model is used to describe a univariate multimodal density; it may be unacceptable from a practical point of view to have the tail of one component (say; the one centered on the highest mean) accounting for data at the lower end (below that of the smallest mean) by allowing its variance to be much greater than the other component variances. This is the case here where the variance of the third component in the g = 3 heteroscedastic normal mixture solution of Izenman and Sommer (1988) is appreciably greater than the variances for the other two components . As a consequence of the left-hand tail of the third component; the four thinnest stamps (ranging from 0.60 mm to 0.66 mm) are assigned to this component (which has a mean of 0.0989 mm) and not the nearest one (which has a mean of 0.0712 mm); see Table 6.2. As argued by Basford et al. (1997b),it seems reasonable to assume that the variability of stamp thickness would be consistent about any particular mean in the production process across the range of mcasurements observed. Thus concluded that the 9 =3 heteroscedastic normal mixture model is impractical for physical considerations, and so considered the of a normal mixture model with the components restricted to having a common variance. long they they fitting

Itcan be seen from Table 6.1 that there is only a slight increase in the log likelihood in preceding from g = 4 to 9 = 5. This is because the common variance of the components in the mixture model is not sufficiently small in the case of g 5 to provide any further modes in the fit. Thus, if on the basis of 1 we were to test 9 versus g + 1 sequentially starting with g = 1, then would terminate at 9 = 4, no matter what sensible criterion were used to decide on the value of 9. testing

If we continue on past g =5 and monitor the increase in the likelihood, then it is clear from Table 6.1 that there is no need to proceed beyond g =8 On whether there is a need to proceed from 9 = 7 to 9 = 8, the value of ~2log X is 19.6, log

Table 6.2 Fitted Posterior Probabilities of Component Membership

| Yj        |     | (u;) | îs($y_j$) |
| --------- | --- | ---- | ------ |
| 060       |     |      | 1.00   |
| 064       |     |      | 1.00   |
| 065       |     |      | 1.00   |
| 066       | 03  |      | 97     |
| .068      | 73  |      | 27     |
| 069       | 92  |      | 08     |
| 070       | 96  |      | 04     |
| 071       | 96  | 01   | 03     |
| 072       | 94  | 02   | 04     |
| 073       | 80  | 12   | 08     |
| 074       | 36  | 50   | 14     |
| .075      | 05  | 83   | 12     |
| 076       |     | 91   | 09     |
| 077       |     | 93   | 07     |
| 078       |     | 94   | 06     |
| 079       |     | 93   | 07     |
| 080       |     | 91   | 09     |
|           |     | 87   | .13    |
| .082      |     | .79  | 21     |
| ,083      |     | 63   | 37     |
| 084       |     | 40   | 60     |
| 085       |     | 18   | 82     |
| .086      |     |      | 94     |
| 087       |     | 01   | 99     |
| ,088      |     |      | 1.00   |
| 089 ~ 112 |     |      | 1.00   |
| .114 .115 |     |      | 1.00   |
| 117       |     |      | 1.00   |
| 119 123   |     |      | 1.00   |
| 125       |     |      | 1.00   |
| 128 131   |     |      | 1.00   |

Source: From Basford et al. (1997b).

which would appear to be significant. For example; if Wolfe's approximation were adopted, which would take X to be x?, then the P-value is practically zero. The g = 7 and g = 8 homoscedastic normal mixture fits for the density are displayed in Figures 6.5 and 6.6, respectively. It can be seen that the additional component in the g = 8-component normal mixture model exists to accommodate the outlying observations in the lower tail of the data. Elsewhere, it practically gives the same fit as the g = 7 homoscedastic solution.

From Basford et al. (1997), the chi-squared goodness-of-fit test statistic for the 9 =8 homoscedastic normal mixture fit is 57.4. While this is highly significant, it has fallen from a value of 158.14 for the g =4 fit. This high value would appear to be due to the rounding of the stamp measurements to the third decimal place, there only 72 distinct values for the 485 measurements (effectively; bins of width 0.001 mm) When Basford et al. (1997b) made allowance for this rounding by the judicious grouping of intervals in forming the chi-squared goodness-of-fit statistic;, the latter was reduced to 20.1 with a P-value of 279. being If the assumption of equal variances is relaxed in the g = 8-component mixture model, then we obtain essentially the same fit as under homoscedasticity. fitting The only difference, really; is that a smaller variance is obtained for the component with the largest fitted mean.

![image 21](mclachlan2000_images/imageFile21.png)

Fig. 6.5 Plot of g = 7-component normal mixture fit with equal variances. From Basford et al.

![image 22](mclachlan2000_images/imageFile22.png)

Fig. 6.6 Plot of g 8-component normal mixture fit with equal variances. From Basford et al (1997b).

<a id="sec-6-3"></a>

# 6.3 APPROACHES FOR ASSESSING MIXTURE ORDeR

In most of the work on inference on the number of components g in a mixture model , Bayesian or otherwise; the approach has been to separate the problem of testing for 9 from the of the mixture model, and hence estimation, for fixed g. However, as discussed in Section 4.7 on the Bayesian approach; the more direct line of modeling the unknown g case by mixing over the fixed g case has been considered by Phillips and Smith (1996) and Richardson and Green (1997). fitting

<a id="sec-6-3-1"></a>

# 6.3.1 Likelihood-Based Methods

The estimation of the order of a mixture model has been considered mainly by consideration of the likelihood, using two main ways. One way is based on a penalized form of the likelihood. As the likelihood increases with the addition of a component to mixture model, the likelihood (usually; the likelihood) is penalized by the subtraction of a term that 'penalizes' the model for the number of parameters in it. This leads to a penalized log likelihood, yielding what are called information criteria for the choice of g log

The other main way for deciding on the order of a mixture model is to carry out a hypothesis test, the likelihood ratio as the test statistic. In this chapter we shall consider these two ways in some detail , commencing with the LRT in Section 6.4. using

We shall see that penalized likelihood criteria; like AIC and BIC , are less demandthan the LRT, which requires bootstrapping in order to obtain an assessment of the P-value. However, produce no number that quantifies the confidence in the result, such as a P-value. ing they

<a id="sec-6-3-2"></a>

# 6.3.2 Nonparametric Methods

As mentioned in Section 6.1.1, the order of a mixture model can be investigated nonparametrically by tests on the number of modes. Other nonparametric methods that have been used for this problem include the work of Henna (1985) and a number of graphical displays such as the normal scores plot (Cassie, 1954; Harding, 1948),the modified percentile plot of Fowlkes (1979), and the more recent approach of Roeder normal density having the same mean and variance as the mixture density is always bimodal . This analytic result and other related results form the basis of a diagnostic test for the number of components in mixture of normals. Previously, Lindsay and Roeder (1992a) had proposed the use of residual diagnostics for determining the number of components.

<a id="sec-6-3-3"></a>

# 6.3.3 Method of Moments

Heckman, Robb, and Walker (1990), Furman and Lindsay (1994a), and DacunhaCastelle and Gassiat (1997b) have used the method of moments to test for the number of components in mixture model. Also; Vlassis and Likas (1999) and Vlassis, Papakonstantinou, and Tsanakas (1999) have considered a kurtosis-based approach to this problem.

<a id="sec-6-4"></a>

# 6.4 LIKELIHOOD RATIO TEST STATISTIC

<a id="sec-6-4-1"></a>

# 6.4.1 Introduction

An obvious way of approaching the problem of testing for the smallest value of the number of components in a mixture model is to use the LRTS, ~2 1. Suppose we wish to test the null hypothesis, log

$$
H _ { 0 } \colon g = g _ { 0 }
$$

versus conditions (Cramér, 1946) about the asymptotic properties of the MLE are not valid under the null hypothesis In particular; the asymptotic distribution of the MLE in the nonidentifiable case under Ho is unknown. The lack of identifiability leads to a degeneracy in the information matrix when considering the asymptotic null distribu tion of the (normalized) likelihood formed under the alternative distribution H1. As a consequence; when classical Taylor series expansions for the LRTS, the remainder terms may not be bounded uniformly. log using

$$
H _ { 1 } \colon g = g _ { 1 }
$$

for some 91 =g0 + 1 in practice as it is common to keep adding components until the increase in the likelihood starts to fall away as g exceeds some threshold. The value of this threshold is often taken to be the go in Ho Of course it can happen that the likelihood may fall away for some intermediate values of g only to increase sharply at some larger value of g, as in Example 6.2. log

against Ho will be strong if X is sufficiently small, or equivalently; if ~2log X is sufficiently where large,

$$
\hat { \Psi } _ { 1 } ) - \log L ( \hat { \Psi } _ { 0 } ) \}
$$

is twice the increase in the likelihood or the decrease in deviance. Unfortunately with mixture models, regularity conditions do not hold for ~2log X to have its usual asymptotic null distribution of chi-squared with degrees of freedom equal to the difference between the number of parameters under the null and alternative hypotheses. log

To briefly explain why this is so, suppose that the component densities are completely specified. Then the parameter vector $\Psi$consists ofjust the mixing proportions: Thus, as 90 < 91 in (6.4) and (6.5), the null hypothesis is specified by the true value of y on the boundary of the parameter space (with one or more of the mixing proportions specified as zero) Further, if the component densities belong to, say the same parametric family f($y_j$; 0) with 0 unspecified, then Ho will hold also if = 0; for some h # i That is, Ho corresponds to nonidentifiable subset of the parameter space Thus with the true value of the parameter vector under Ho lying on the boundary of the parameter space and also in nonidentifiable subset if the component densities depend on unknown parameters, the classic regularity being

<a id="sec-6-4-2"></a>

# 6.4.2 Example 6.3: Breakdown in Regularity Conditions

We now present an example to illustrate the breakdown in the standard regularity conditions. Consider a mixture of g =2 univariate normal densities in proportions $\pi_1$ and T2 = 1 T1 with means #1 = and p2 and common unit variances, where T1 and /2 are unspecified. Suppose we wish t0 test

versus



$$
H _ { 1 } \colon f ( y _ { j } ; \Psi ) = \pi _ { 1 } \phi ( y _ { j } ; 0 , 1 ) + \pi _ { 2 } \phi ( y _ { j } ; \mu _ { 2 } , 1 ) .
$$

The parameter space is given by

$$
\Omega = \{ \Psi = ( \pi _ { 1 } , \, \mu _ { 2 } ) ^ { T } \colon [ 0 , 1 ] \times ( - \infty , \infty ) \} .
$$

and the line segment [0,1] on the T1-axis when p2 = O; that is,



When the null hypothesis Ho holds, the parameter vector V is on the boundary of the

0, 1) Then it converges in probability to 90. to the common value of the as specified under Ho. In this sense, one might anticipate that ~2log > would be reasonably behaved as n 4 0 But Hartigan (1985a, 1985b) showed that 1 is asymptotically unbounded above in probability at a very slow rate In practice; we can approximate it by the bootstrap; as to be discussed in Section 6.6. But firstly; we consider some theoretical results that have been obtained for the null distribution of \_2 X in special cases. ~2log

<a id="sec-6-5"></a>

# 6.5 DISTRIBUTIONAL RESULTS FOR THE LRTS

A lot of theoretical conjectures and simulations have been published on the null distribution of the LRTS, -2 X, for inference on the number of components in a finite mixture model. We consider here some of the theoretical results that have been derived in special cases.

<a id="sec-6-5-1"></a>

# 6.5.1 Some Theoretical Results

The article by Ghosh and Sen (1985) provides a comprehensive account of the break down in regularity conditions for the classical asymptotic theory to hold for the LRTS, ~2log XFor a mixture of two known but general univariate densities in unknown proportions, Titterington (1981) and Titterington et al. (1985) considered the LRT of Ho 9 = 1 (T1 = 1) versus H1 9 = 2 (T1 < 1). They showed asymptotically distributed as chi-squared with one degree of freedom: Another way of expressing this is that the asymptotic null distribution of ~2 Xis the same as the distribution of log

$$
\{ \max ( 0 , W ) \} ^ { 2 } ,
$$

where W is a standard normal random variable. further way of expressing this is to say that

$$
5 \lambda \sim
$$

under Ho, where X8 denotes the degenerate distribution that puts mass at zero. In his monograph, Lindsay (1995, Section 4.2) referred to this distribution as chi-bar squared; that is, a mixture of chi-squared distributions.

Hartigan (1985a, 1985b) obtained the same result for the asymptotic null distribution of ~2log X in the case of the two-component normal mixture,

$$
( 6 . 1 1 )
$$

with unspecified T1 but known common variance and known means p1 and p2 where, as in the previous example, the null hypothesis Ho 9 = 1 was specified by T1 =l This example was considered also by Ghosh and Sen (1985) in the course of their development of asymptotic theory for the distribution of the LRTS for mixture models. They were able to derive the limiting null distribution of showed in the limit, that X is distributed as a certain functional, They

$$
\max \left \{ 0 , \sup _ { \mu _ { 2 } } W ( \mu _ { 2 } ) \right \} \left \} \left | ^ { 2 } , \, ,
$$

where W(:) is a Gaussian process with zero mean and covariance kernel depending Ghosh and Sen (1985) established a similar result for component densities from a general parametric family under certain conditions. For the case where the vector of parameters % was not assumed to be identifiable, they imposed a separation condition Hartigan (19852, 1985b) showed that if p2 is unknown with no restrictions on it, then X is asymptotically infinite. Also, Bickel and Chernoff (1993) investigated the null behavior of the LRTS for this model. ~2log Berdai and Garel (1996) established the result corresponding to (6.12) when all the parameters in (6.11) were unknown; including the common variance 02 but with

$$
\Delta = | \, \mu _ { 1 } - \mu _ { 2 } \, | \, / \sigma
$$

is the Mahalanobis distance. By making use of a bound suggested in Davies (1977), calculated the upper percentiles of this asymptotic distribution of the LRTS and compared them with the corresponding percentiles of the x2 distribution; which is Wolfe's approximation for this problem. The x? distribution was confirmed in the simulations of McLachlan (1987) and Thode, Finch, and Mendell (1988) to provide reasonable approximation in this case. Berdai and Garel (1996) found that there was reasonable agreement between the asymptotic percentiles and the x? percentiles; provided that a2 was not too large. As the range of is allowed to increase by increasing 02, the percentiles increase beyond the x? percentiles; albeit very slowly. is 5.89 when A is restricted to [0.1, 6] , increasing t0 7.717, when A is restricted to [0.1, 15]. This behavior of the percentiles increasing with the range of is consistent with the above result of Hartigan (1985a, 1985b) that the LRTS goes to infinity in probability (but at a very slow rate) in the case of an unbounded parameter space. they

Garel (1998) claimed that the separation condition of Ghosh and Sen (1985) can be removed. The removal of this condition has been investigated also by DacunhaCastelle and Gassiat (1997a) and Lemdani and Pons (1999). All these authors agree that it is possible to remove the separation condition. But what are the relevant hypotheses to assume is still an open question. Following on from the work of Leroux (1992a), Keribin (1998) recently considered the form of a penalty term so that the penalized form of the likelihooddoes not overestimate asymptotically the order of a mixture model. log

In an attempt to overcome the shortcomings of the LRT for the number of components in a mixture model in a frequentist framework, Bayesian approaches have been suggested. For example, Aitkin and Rubin (1985) adopted an approach which places a distribution on the vector of mixing proportions "An advantage of this proposal is that any null hypothesis about the number of components is fied in the interior of the parameter space. However, Quinn, McLachlan, and Hjort (1987) showed that the asymptotic null distribution of \_2 X will not necessarily be chi-squared, as regularity conditions still do not hold. In particular, for the test of Ho 9 = 1 versus H1 9 = 91 (> 1) for component densities belonging to the same parametric family; showed that 1 /n times the observed information matrix prior speci they

In some other work, Feng and McCulloch (1992) showed that the LRTS has its classical asymptotic properties if the paramcter space is extended. Böhning et al.

(1994)have examined the general case ofexponential family component densities and showed that the asymptotic distribution of the relevant test statistic is not chi-squared. They also gave an interesting geometrical interpretation of the failure of regularity conditions which lead to the rejection of the asymptotic result. More recently; Wu and Xu (1999) have studied local sequential testing procedures in a normal mixture model. In a variation of the normal mixture model, Nettleton (1999) has derived the asymptotic null distribution of versions of the LRTS for hypotheses that place linear inequality constraints on the component means.

A number of papers have been written on the LRTS and modifications to it in special cases where some of the parameters are known; including those by Durairajan and Kale (1979, 1982), Goffinet, Loisel, and Laurent (1992), Mangin, Goffinet; and Elsen (1993), Chen (1994), Mangin and Goffinet (1995), Chen and Cheng (1997), and Polymenis and Titterington (1999) For example; Goffinet et al. (1992) established for the model (6.11) that the asymptotic distribution of ~2log X is x? for fixed T1 + 0.5 =0.5.

Concerning mixtures of discrete component distributions, Shoukri and Lathrop (1993), Chernoff and Lander (1995), Lemdani and Pons (1995, 1997), and and Rathouz (1999) have considered testing for homogeneity in the binomial mixture model with applications to genetic linkage analysis. Simar (1976), Symons; Grimson, and Yuan (1983), Böhning et al. (1994), Leroux and Puterman (1992), and Karlis and Xekalaki (1999) have considered the problem for mixtures of Poisson distributions. Chen (1998) proposed adding a particular type of penalty function to the LRTS. He showed that the resulting penalized LRTS has a simple limiting distribution for mixture models with multinomial components . Liang

<a id="sec-6-5-2"></a>

# 6.5.2 Some Simulation Results

There have been several simulation results reported in the literature on the null distri bution of the LRTS and its power. These results have been reviewed in Titteringtonet al. (1985), McLachlan (1987), McLachlan and Basford (1988), Thode et al. (1988), Mendell, Thode, and Finch (1991), Mendell, Finch, and Thode (1993), and Chuang and Mendell (1997).

One of the initial simulation studies on the LRTS for mixtures was by Wolfe He considered the LRT for assessing the null hypothesis that the data arise from a normal mixture of go components versus the alternative that arise from 91 components (go < 91). He forward a recommendation on the basis of a small scale simulation study performed for go = 1 and 91 = 2 in the case of multivariate normal component densities with a common covariance matrix. they put

It follows from his proposal that the null distribution of ~2 X would be approximated as

$$
- 2 C \log \lambda \sim \chi _ { d _ { 1 } } ^ { 2 } ,
$$

where the degrees of freedom, d1, is taken to be twice the difference in the number of parameters in the two hypotheses; not including the mixing proportions. His suggested value of C is

$$
( n - 1 - p - \frac { 1 } { 2 } g _ { 1 } ) / n ,
$$

which is similar to the correction factor

$$
( 6 . 1 4 )
$$

derived by Bartlett (1938), for improving the asymptotic chi-squared distribution of X for the problem of testing the equality of 91 means in a multivariate analysis of variance; see McLachlan and Basford (1988, Section 1.10). log

Some simulations performed by Everitt (1981) for 9 = 1 versus g 2 normal components with equal covariance matrices suggested that the ratio n/p needs to be at least five if Wolfe's (1971) approximation is to be applicable for the determination of P-values. Even then the simulated power of the test was low when the Mahalanobis distance was not greater than two testing

<a id="sec-6-5-3"></a>

# 6.5.3 Mixtures of Two Unrestricted Normal Components

We consider some results for the null distribution of the LRTS in testing the null hypothesis Ho 9 1 versus the alternative hypothesis H1 9 = 2 in the 9component univariate normal mixture model

$$
( 6 . 1 5 )
$$

with no restrictions on the component variances\_

Some initial simulations for this model were performed by McLachlan (1987). He concluded that the X8 distribution provided a better fit to the null distribution of X than the x? distribution using the approximation of Wolfe (1971). Feng and McCulloch (1994) performed some simulations to demonstrate the dependence of the null distribution of the LRTS on the constraints placed on the minimum value C of the fitted component variances ô? and ô?. In their simulations, found the null distribution of ~2log X to lie between a x? and x} distribution for C = to lie Another source of difference between some of the reported results in the literature is the extent of the search for local maxima when finding the MLE under the alternative hypothesis. To illustrate this point, we carried out some simulations of ~2log X for the present model with € = for data generated from a single normal distribution; having the same mean of zero and variance 4, as in and McCulloch (1994). In the two-component mixture model under the alternative hypothesis; we endeavored was a spurious local maximizer or not. The consequent simulated null distribution was closer to a they 10-6 10-10 Feng fitting being

Brooks and Morgan (1995) compared the results of their hybrid algorithm; which combines simulated annealing with traditional techniques for this same problem: The simulated plot so0 produced for the null distribution of -2 log

of the xão up to the 9Oth percentiles. At the time, they consequently concluded that their hybrid algorithm was more effective than the EM algorithm in the two-component heteroscedastic normal mixture model specified under H1But our current simulations demonstrate that the EM algorithm can actually find larger local maxima if need be, although are of limited practical interest given that may correspond to spurious solutions. fitting they they

<a id="sec-6-5-4"></a>

# 6.5.4 Mixtures of Two Exponentials

Seidel et al. (2000a) studied the two-component exponential model,

$$
( 6 . 1 6 )
$$

where

$$
f ( y _ { j } ; \theta ) = \exp ( - \theta y _ { j } ) ,
$$

and y = demonstrated how different starting strategies and different results for the LRT of homogencity against the two-component model; see They

$$
\hat { \Psi } _ { 0 } = \hat { \theta } _ { 0 } = \{ \sum _ { j = 1 } ^ { n } y _ { j }
$$

Under the alternative hypothesis H1, the MLE $\hat{\Psi}$1 ofvhas to be computed iteratively. Seidel et al. (2000a) used the EM algorithm with two different starting strategies. With the first, START-A, the initial value 0{0) = Y(n) = 0.5, where y(1) y(n) denote the order statistics and 9 + 0.500, where 0 denotes the true value of 0 under the null hypothesis.

With the first, STOP-A, the EM algorithm in fitting the MLE under H1 was terminated when specified value of acc. In Table 6.3, acc was set at Their second stopping rule, STOP-B, was based on the directional derivative; log 10-5 .

$$
\overline { j = 1 }
$$

The EM algorithm in under H1 was terminated when fitting

$$
\} < n \cdot a c c .
$$

In Table 6.3 we report the simulated values obtained by Seidel et al. (2000a) for the upper percentiles of the null distribution of ~2log X for the various combinations of

Table 6.3 Quantiles of the Null Distribution of the LRTS for Homogeneity under Different Starting and Termination Strategies for Exponential Components

|             | Published in          | START-A |        | START-B |        |
| ----------- | --------------------- | ------- | ------ | ------- | ------ |
| Percentiles | Böhning et al. (1994) | STOP-A  | STOP-B | STOP-A  | STOP-B |
|             | 100                   |         |        |         |        |
| 90          | 1.69                  | 3.36    | 3.36   | 2.22    | 2.44   |
| 95          | 3.26                  | 4.73    | 4.76   | 3.64    | 3.80   |
| 97.5        | 4.67                  | 6.13    | 6.19   | 5.04    | 5.23   |
| 99          | 6.33                  | 8.15    | 8.01   | 6.94    | 7.09   |
|             | = 1000                |         |        |         |        |
| 90          | 1.49                  | 3.49    | 3.52   | 1.50    | 2.60   |
| 95          | 2.59                  | 4.95    | 4.99   | 2.55    | 4.09   |
| 97.5        | 3.76                  | 6.42    | 6.42   | 3.71    | 5.52   |
| 99          | 5.48                  | 8.30    | 8.40   | 5.34    | 7.41   |
|             | n = 10,000            |         |        |         |        |
| 90          | 0.50                  | 3.23    | 3.41   | 1.09    | 1.57   |
| 95          | 1.86                  | 4.65    | 4.84   |         | 2.73   |
| 97.5        | 3.19                  | 6.06    | 6.19   | 3.39    | 4.01   |
| 99          | 4.94                  | 7.93    | 8.16   | 5.10    | 5.73   |

Source: Adapted from Seidel et al. (2000a)

starting and stoppingstrategies versus the corresponding values published in Böhning et al. (1994) for three different levels of the sample size n (the null distribution of the LRTS does not depend on 0). It can be seen that the simulated percentiles differ markedly, depending on how the EM algorithm was started and terminated. In an attempt to these differences, Seidel et al. (2000a) noticed that the value of only slightly larger than the likelihood under the null. Hence when the latter is subtracted from log L(û) to form relative errors in L(4) can produce large relative errors in 1 explain log log log log log =

<a id="sec-6-6"></a>

# 6.6 BOOTSTRAPPING THE LRTS

<a id="sec-6-6-1"></a>

# 6.6.1 Implementation

McLachlan (1987) proposed a resampling approach to the assessment of the P-value of the LRTS in testing

$$
H _ { 0 } \colon g = g _ { 0 } \quad \lor \quad H _ { 1 } \colon g = g _ { 1 }
$$

for a specified value of go. Previously Aitkin et al. (1981) had adopted a resampling approach in the context of a latent class analysis. Bootstrap samples are generated from the mixture model fitted under the null hypothesis of go components. That is, the bootstrap samples are generated from the mixture model with the vector $\Psi$ of unknown parameters replaced by its MLE $\hat{\Psi}$g computed by consideration of the log likelihood formed from the original data under Ho. The value of ~2 Ais computed for each bootstrap sample after mixture models for 9 g0 and 91 in turn to it. The process is repeated independently a number of times B, and the replicated values of ~2log X formed from the successive bootstrap samples provide an assessment of the bootstrap, and hence of the true, null distribution of -2 It enables an approximation to be made to the achieved level of significance P corresponding to the value of \_2 X evaluated from the original sample. The jth-order statistic of the B bootstrap replications can be used to estimate the quantile of order ; / (B + 1) A preferable alternative would be to use the jth-order statistic as an estimate of the quantile of order (3j - 1)/(3B + 1); see Hoaglin (1985). fitting log

If a very accurate estimate of the P-value were required, then B may have to be very large (Efron and Tibshirani, 1993) Usually, however, there is no interest in estimating a P-value with high precision. Even with a limited replication number B, the amount of computation involved is still considerable; in particular for values of easily and efficiently implemented on parallel computing hardware, for example, by using B parallel processors (Smyth, 2000).

As discussed earlier in the chapter, the distribution of the LRTS obtained via simulation will depend to varying degrees on the adopted parametric model, the starting strategy, the stopping rule, and the handling of the occurrence of spurious process. In using the bootstrap to assess the null distribution of the LRTS, it is important that the same procedures be used in the mixture model to the bootstrap data as to the original sample. In the case of normal components, the bootstrap-based LRT can be carried out using the EMMIX program of McLachlan et al. (1999); see also McLachlan and Peel (1996). fitting fitting

In the narrower sense where the decision tobe made concerns solely the rejection or retention of the null hypothesis at a specified significance level œ, Aitkin et al. (1981) noted how; analogous to the Monte Carlo test procedure of Barnard (1963) and Hope (1968), the bootstrap replications can be used t0 provide a test of approximate size Q The test that rejects Ho if -2 X for the original data is greater than the jth smallest of its K bootstrap replications has size

$$
\alpha = 1 - j / ( B + 1 )
$$

approximately. For if any difference between the bootstrap and true null distributions of X is ignored, then the original and subsequent bootstrap values of ~2 log X can be treated as the realizations of a random sample of size B+1, andthe probability that a specified member is greater than j of the others is 1 ~ i/(B + 1) For some hypotheses the nulldistributionof X willnot depend on any unknown parameters, and so then there will be no difference between the bootstrap and true null distribution of ~2log-

~2l0gX. An example is the case of normal populations with all parameters unknown where g0 = 1 under Ho. The normality assumption is not crucial in this example.

Note that the result (6.18) to the unconditionalsize of the test and not to its size conditional on the B bootstrap values of ~2logX. For a specified significance level œ, the values of j and B can be appropriately chosen according to (6.18) For = 0.05, the smallest value of B needed is 19 with j = 19. As cautioned above on the estimation of the P-value for the LRT, B needs to be very large to ensure an accurate assessment. In the present context the size of B manifests itselfin the power of the test; see Hope (1968). Although the test may have essentially the prescribed size for small B, its power may be well below its limiting value as For the 0.05 level test of a single normal population versus a mixture of two normal homoscedastic populations; McLachlan (1987) performed some simulations to demonstrate the improvement in the power as B was increased from 19 through 39 to 99. applies

In general, the use of the estimate in place of the unknown value of $ under the null hypothesis, will affect the accuracy of the P-values assessed on the basis of the bootstrap replications of _2 In Section 6.7 we report some simulation results from McLachlan and Peel (1997a) to demonstrate this effect. log _

<a id="sec-6-6-2"></a>

# 6.6.2 Application to Three Real Data Sets

McLachlan and Peel (1997b) fitted a mixture of normal components with unrestricted variances to the so-called acidity; enzyme, and galaxy data sets, which were analyzed in Richardson and Green (1997). The first data set concerns an acidity index measured in a sample of 155 lakes in north-central Wisconsin; and it has been analyzed previously (on the log scale) by Crawford et al. (1992) and Crawford (1994). The second data set concerns the distribution of enzymatic activity in the blood, for an enzyme involved in the metabolism of carcinogenic substances; among a groupof 245 unrelated individuals. This data set was analyzed by Bechtel et al. (1993), who identified a mixture of two skewed distributions the maximum likelihoodtechnique implemented in the program of Maclean et al. (1976). The third data set (galaxy data set) was introduced in Section 3.10.6. Histograms of the three data sets are shown in Figure 6.7. using

been seen that in a number of cases in Table 6.4 the assessed P-value lies between 59 and 109 . Performing further bootstrap replications in thesc cases did not clarify the situation. Also, it should be noted that these assessed P-values should not be interpreted too finely; as it is the bootstrap rather than the actual P-value that is assessed in these cases since the value of g under the null hypothesis is greater than one. being

On the basis of these P-values interpreted rigidly at the 5% level of significance; 9 would be chosen to be equal to 2, 3, and 6, for the acidity; enzyme, and galaxy data respectively. If the significance level were increased to 109, it would result in g being chosen equal to 3, 4, and 6 for the acidity; enzyme; and galaxy data sets, respectively. This is in general agreement with the results obtained with the sets, galaxy data set

![image 23](mclachlan2000_images/imageFile23.png)

Table 6.4 P-Values Using Bootstrap LRT

|          | P-Value for g (versus g + 1) |      |      |      |      |      |
| -------- | ---------------------------- | ---- | ---- | ---- | ---- | ---- |
| Data Set |                              | 2    | 3    |      | 5    |      |
| Acidity  | 0.01                         | 0.08 | 0.44 |      |      |      |
| Enzyme   | 0.01                         | 0.02 | 0.06 | 0.39 |      |      |
| Galaxy   | 0.01                         | 0.01 | 0.01 | 0.04 | 0.02 | 0.22 |

Source: From McLachlan and Peel (1997b)

fully Bayesian framework for 9 in Richardson and Green (1997), except in for the acidity data set. For this set, their Bayesian approach provides essentially equal support for g = 2-6, whereas according to the P-values assessed by resampling; one would not go beyond g = 3 components A Bayesian analysis of the galaxy data set has been undertaken also by Carlin and Chib (1995) and Chib (1995). In the latter, normal mixture models with 9 = 2 or 3 components were preferred. part

<a id="sec-6-6-3"></a>

# 6.6.3 Applications in Astronomy

Inthe previous section, weconsidered adata set on the velocities of galaxies; which has been used by various statisticians for testing their clustering techniques. The structure of such sets is of much interest in astronomy. As explained by Kriessler and Beers (1997), it was once assumed that most clusters were relaxed systems that could be adequately modeled by a simple set of parameters; such as asingle-core radius and the concluded that many; perhaps even most, clusterings are far from being in dynamical equilibrium: Evidence cited includes the existence of: (a) "clumpy" distributions of galaxies seen in the projection on the sky; (b) apparent structure in the distribution of radial velocities for cluster membership, and (c) multiple centers of X-ray-derived temperature profiles; suggestive of ongoing collisions.

The desire to identify substructure in clusters of galaxies has led to the bootstrap form of the LRT for the number of components in a mixture model applied in studies in astronomy. Recent papers in the astronomical literature in which this method has been used for investigating substructure in galaxy clusters include those by Ashman and Bird (1993, 1994), Bird (1994a, 1994b, 1995), Beers and SommerLarsen (1995), Bird, Davis, and Beers (1995), Davis et al. (1995), Zepf, Ashman; and Geisler (1995), and Bridges et al. (1997), being

For example, Kriessler and Beers (1997)concluded from their use of this statistical test that 57% of the Dressler (1980) morphological-sample clusters have statistically significant substructure. Figure 6.8, which is taken from Kriessler and Beers (1997), gives the contour plots of bivariate normal mixtures fitted to the positions of some of the galaxy clusters.

![image 24](mclachlan2000_images/imageFile24.png)

6.8 Adaptive-kernel density contour maps of galaxy positions in Dressler's morphological sample; The filled circles indicate the positions of galaxies identified by Dressler (1980) as D or cD. The crosses mark the average positions identified as significant in the normal mixture fit. Adapted from Kriessler and Beers (1997). Fig.

<a id="sec-6-7"></a>

# 6.7 EFFECT OF ESTIMATES ON P-VALUES OF BOOTSTRAPPED LRTS

<a id="sec-6-7-1"></a>

# 6.7.1 Some Simulation Results

As noted above; the bootstrap replications of the LRTS are actual replications when the value of g0 is 1 in the case of normal components. McLachlan and Peel (1997a) performed some simulations to investigate the effect of assessing the P-value of the LRT on the basis of the bootstrap rather than actual replicates of ~2 1 Attention was confined to mixtures of normal components with equal covariance matrices. For simplicity; the focus was on the case of go = 2 versus 91 =3. In this special case of two normal components with means #1 and /42 and common covariance matrix 2, it can be assumed without loss of generality that log

$$
a n d
$$

$$
\Delta = \{ ( \mu _ { 1 } - \mu _ { 2 } ) ^ { T } \Sigma ^ { - 1 } ( \mu _ { 1 } - \mu _ { 2 } ) \}
$$

is the Mahalanobis distance between the two components.

In this case, the null distribution of -2 X will depend only on n, T1, and A In their simulations, McLachlan and Peel (1997a) took the mixing proportions to be equal (T1 = T2 = 0.5) and took the sample size n to be 100. There were two levels of A (4 =2 and 3), corresponding to moderately and widely separated components; respectively. The dimension of the observation vector ranged from p = 1 to p = 8 The percentiles of the null distribution of -2 1 were based on 999 simulation trials. Concerning the effectiveness of the bootstrapping of ~2 X, 50 simulation trials were performed for each combination of the parameters and p with T1 = 0.5 and n = 100. On each trial, B = 99 bootstrap replications were used to assess the percentiles of the null distribution of 1 log log\_ ~2log

Corresponding to the (simulated) 9Oth and 95th percentiles of the null distribution we list in Table 6.5 the averages of the bootstrap-based estimates of these percentiles extracted from the results of McLachlan and Peel (1997a) The percentage areas to the left of these average percentile estimates under the actual (simulated) null distribution of ~2log X (that is, the actual order of these percentiles) are given in parentheses alongside them; see McLachlan and Peel (1997a) for the root mean squared errors of these bootstrap-based estimates of the percentiles. In Table 6.5, Â is the mean of Â over the 50 simulation trials. We give in Table 6.6 the empirical results obtained by McLachlan and Peel (1997a) in each series of 50 simulation trials for the Type I error of the resampling approach when applied at a nominal level of œ 6.6 provide some as to the effect of using bootstrap replications in place of actual replicates of the test statistic ~2 X under the null hypothesis. As to be expected, the effect is more marked for A = 2 than for A =3, and it increases as the dimension p of the observation vector increases for a given level of A guide

Table 6.5 Summary of Simulation Results for the Null Distribution of the LRTS

|     |      |      | Simulated Percentile |      |      | Bootstrap Estimate of Percentile (Actual Percentage) |              |              |
| --- | ---- | ---- | -------------------- | ---- | ---- | ---------------------------------------------------- | ------------ | ------------ |
|     |      | Â    | 909                  | 959  | 999  | 909                                                  | 959          |              |
|     | 2    | 3.08 | 5.0                  | 6.2  | 9.6  | 5.1 (91.09)                                          | 6.7 (96.09)  | 10.7 (99.49) |
| 3   |      | 3.12 | 4.9                  | 6.5  | 9.8  | 4.8 (89.69)                                          | 6.3 (94.59)  | 10.6 (99.69) |
|     | 2    | 2.89 | 20.9                 | 23.0 | 28.1 | 17.8 (79.19)                                         | 20.3 (89.19) | 26.8 (98.69) |
|     | 3.34 | 17.9 |                      | 20.2 | 26.1 | 16.6 (87.19)                                         | 18.8 (92.49) | 24.6 (98.79) |
| 8 2 | 3.38 |      | 40.2                 | 44.3 | 48.9 | 32.7 (67.29)                                         | 36.3 (81.29) | 45.1 (95.89) |
| 3   | 3.67 |      | 36.1                 | 39.0 |      | 30.6 (72.19)                                         | 33.7 (82.79) | 41.4 (96.79) |

Source: Adapted McLachlan and Peel (1997a) from

Table 6.6 Percentage of the 50 Simulation Trials for which a Type Error Occurred

|     |       | Percentage of Observed Type I Errors |       |       |
| --- | ----- | ------------------------------------ | ----- | ----- |
| p   |       | 109                                  | 59    | 19    |
|     | 2     |                                      | 8% 09 | 4%    |
| 2   | 3 2 3 | 149 189 16%                          | 109   | 09 09 |
| 3   | 3     | 149 8%                               | 6%    | 09 09 |
| 4   | 2 3   | 18% 49                               | 6% 4  | 29    |
| 5   | 2     | 229 10%                              | 169   |       |
|     | 3     |                                      | 4%    |       |
|     | 2     |                                      | 169   |       |
| 6   | 3     |                                      | 8%    | 6% 29 |
|     |       | 28%                                  |       |       |
|     |       |                                      |       | 29    |
| 7   |       | 209                                  | 109   |       |
|     | 2     |                                      |       |       |
|     | 3 2   | 249                                  | 129   | 09    |
| 8   |       | 429                                  | 189   | 49    |
|     |       | 32%                                  |       |       |

Source: From McLachlan and Peel (1997a)

As Table 6.5 indicates, there does seem to be a tendency for the resampling approach using bootstrap replications to underestimate the upper percentiles of the null distribution of ~2log >, and hence overestimate the P-value of tests based on this well known that the plug-in estimate of that effectively is used here in the gencration of the bootstrap samples tends to overestimate the true value of A. Hence the bootstrap data are from a normal mixture with components more widely separated than in the original mixture; and so the null hypothesis of go = 2 would be favored by this wider separation. This leads to the bootstrap replicates of ~2 log X tending to be smaller than what the actual replicates would be. This tendency is confirmed in the simulation results in Table 6.5. being

<a id="sec-6-7-2"></a>

# 6.7.2 Double Bootstrapping

In mixture density f(u; %), some to the sensitivity of the assessed P-value to the use of replications can be obtained by performing another of bootstrapping as follows. Replications of X can be formed from bootstrap samples drawn from f($y_j$ "go ), where 'g0 denotes the MLE calculated from a bootstrap sample drawn from f($y_j$ These latter replications of ~2 X and the implied P-value can be contrasted with the original bootstrap replications of -2 X and the implied P-value. fitting guide layer ~2log~ log = log

To illustrate the use of the double bootstrap applied to this problem; we report the results of McLachlan and Peel (1997a), who considered two of the aforementioned combinations of the parameters and p (4 = 2 with p = 4 and 8). We plot in Figures 6.9 and 6.10, corresponding to these two combinations; the inverse of the simulated null distribution of X versus the two bootstrap analogues obtained by resampling from the normal mixture model with parameter vector to 4go ~2log equal The second layer of bootstrapping can be used to adjust the estimates of the percentiles based on the first of bootstrap replicates. These adjusted estimates of the percentiles are reported in*Table 6.7, with the corresponding unadjusted values from Table 6.5, where Â denotes the average value of Â for each series of 50 simulation trials and Â is the MLE of A obtained from a bootstrap sample drawn It can be seen that by performing a second layer of bootstrapping more accurate assessment of the percentiles of the null distribution of can be obtained However; the double bootstrap only partially removes the bias in the bootstrap estimates obtained from the first layer. This can be explained by an examination of Figures 6.9 and 6.10, where it can be seen that the difference between the true and first layered-bootstrap assessment of the percentiles is more marked than between the first and second layered bootstrap assessments layer along ~2log*

Truo

First Layer

Socond Layor

Parceriilo

70

100

Fig. 6.9 Plot of the inverse of the bootstrap-based estimate of the null distribution of 1 =2. From McLachlan and Peel (1997a) ~2l0g

Parconlilo

Truo

Sacond Layor

100

Fig. 6.10 Plot of the inverse of the bootstrap-based estimate of the null distribution of ~2log X for p = 8 and 4 = From McLachlan and Peel (1997a)

Table 6.7 Summary of Simulation Results for the Adjusted Percentile

|     |      |      | Unadjusted Percentile (Actual Percentage) |              | Adjusted Percentile (Actual Percentage) |              |
| --- | ---- | ---- | ----------------------------------------- | ------------ | --------------------------------------- | ------------ |
|     |      |      | 909                                       | 959          | 909                                     | 959          |
|     | 2.89 | 3.19 | 17.8 (79.19)                              | 20.3 (89.19) | 19.0 (84.19)                            | 21.6 (92.29) |
| 8   | 3.38 | 3.89 | 32.7 (67.29)                              | 36.3 (81.29) | (79.79)                                 | 40.2 (90.19) |

Source: From McLachlan and Peel (1997a)

In this particular case of go = 2, where the null distribution of \_2 X depends on the component parameters through just the Mahalanobis distance A, it would be straightforward to produce a suitable adjustment by working with the canonical form of the problem in terms of and aless biased estimate of A (McLachlan, 1992, using Chapter 10) in the production of the first layer of bootstrap replications.

<a id="sec-6-8"></a>

# 6.8 INFORMATION CRITERIA IN MODEL SELECTION

<a id="sec-6-8-1"></a>

# 6.8.1 Bias Correction of the Likelihood Log

Model selection can be approached in terms of the Kullback-Leibler (1951) infor density; then the Kullback-Leibler information of f (w) with respect to an estimate

$$
f ( w ) \log f ( w ; \hat { \Psi } ) \, d w , \ ( 6 . 1 9 )
$$

which is a measure of the divergence of f(w) relative to f(w; #). The aim is to make the Kullback-Leibler information (6.19) small. As the first term on the right-hand side of (6.19) does not depend on the model, only the second term is relevant. It can be expressed as

$$
\eta ( $y_j$ F ) \ & = \ \int f ( w ) \log f ( w ; \hat { \Psi } ) \, d w \\ & = \ \int \log f ( w ; \hat { \Psi } ) \, d F ( w ) ,
$$

where F denotes the true distribution and y = (u{ , yT)T contains the observed data.

A simple estimator of n($y_j$ F) is given by

$$
= \ \frac { 1 } { n } \log L ( \hat { \Psi } ) ,
$$

obtained by replacing F in (6.20) by the empirical distribution function Fn, which places mass 1/n at each observation V; (j = 1, n) Usually this provides an overestimate of the expected density log

$$
\int \log f ( w ) \, d F ( w ) ,
$$

since the empirical distributionfunction Fn is generally closertothe fitted distribution function Fw than the true one F . The bias of n($y_j$ Fn) as an estimator of (6.22) is the functional

$$
b ( F ) \ =
$$

$$
= \ E _ { F } \{ \frac { 1 } { n } \sum _ { j = 1 } ^ { n } \log f ( Y _ { j } ; \hat { \Psi } ) - \int \log f ( w ; \hat { \Psi } ) \, d F ( w ) \} ,
$$

where EF denotes expectation using F as the common distribution function of the (independent) Yí, Yn

An information criterion for model selection can be based on the the bias-corrected likelihood given by log

$$
\log L ( \hat { \Psi } ) - b ( F ) ,
$$

an appropriate estimate of the bias term b(F). The intent is to select the model (that is, the number of components in the present context) to maximize (6.24), and thus to minimize the Kullback-Leibler information (6.19) using

In the literature; the informationcriteria so formed are generally expressed in terms of twice the negative value of this difference; so that are of the form they

$$
- 2 \log L ( \Psi ) + 2 C ,
$$

where the first term on the right-hand side of (6.25) measures the lack of fit and the second term C is the penalty term that measures the complexity of the model. The intent therefore is to choose a model to minimize the criterion (6.25).

<a id="sec-6-8-2"></a>

# 6.8.2 Akaike's Information Criterion

Akaike (1973,1974) showed that b( F) is asymptotically equal to d, where dis equal to the total number of parameters in the model. Thus from (6.24), Akaike's Information Criterion (AIC) selects the model that minimizes

$$
- 2 \log L ( \hat { \Psi } ) + 2 d ;
$$

see Bozdogan and Sclove (1984) and Sclove (1987) on the use of AIC in the present context of selecting the number of components in a mixture.

Konishi and Kitagawa (1996) derived the corresponding asymptotic bias where the true density $f(y_j)$ does not belong to the postulated parametric family and where the parameter vector is not necessarily estimated by maximum likelihood . However, the validity of these asymptotic expansions for b(F) depend on the same regularity conditions needed for the usual asymptotic theory for the null distributionof the LRTS to hold (Titteringtonet al., 1985). As discussed in Section 6.4, these conditions break down for tests on the number of components in a mixture model.

However; in spite of this, the AIC criterion is still often used to assess the order of a mixture model. Many authors (for example; Koehler and Murphee (1988)) obscrved that AIC is order inconsistent and tends to overfit models. In the mixture context, it means that AIC tends tooverestimate the correct number of components (Soromenho; 1993; Celeux and Soromenho, 1996).

<a id="sec-6-8-3"></a>

# 6.8.3 Bootstrap-Based Information Criterion

Ishiguro, Sakamoto; and Kitagawa (1997) proposed that the bias term in (6.24) be esti mated using Efron's (1979) bootstrap;see also Pan (1999). Their Efron (bootstrapped) information criterion, which called EIC, chooses the number of components 9 they on the basis of

$$
- 2 \log L ( \hat { \Psi } ) + 2 b ( \hat { F } _ { n } ) ,
$$

where the (nonparametric) bootstrap bias b(Ên) is approximated by Monte Carlo methods on the basis of B bootstrap From (6.23), samples.

$$
f _ { \dot { F } _ { n } } \{ \frac { 1 } { n } \sum _ { i = 1 } ^ { 2 } \log f ( Y _ { j } ^ { * } ; \hat { \Psi } ^ { * } ) - \frac { 1 } { n } \sum _ { i = 1 } ^ { n } \log f ( Y _ { j } ; \hat { \Psi } ^ { * } ) \} ,
$$

$$
j = 1 & & \overline { j } = 1
$$

where $\* denotes the MLE formed from the bootstrap sample

$$
Y _ { 1 } ^ { * } , \dots , Y _ { n } ^ { * } \stackrel { i . i . d . } { \sim } \hat { F } _ { n } .
$$

We can approximate this bootstrap bias on the basis of B independent bootstrap samples

$$
Y _ { 1 b } , \dots , Y _ { n b } ^ { * } \stackrel { i . i . d . } { \sim } \hat { F } _ { n } \ \ ( b = 1 , \dots , B ) ,
$$

where we let % denote the MLE formed from the bth bootstrap sample (b = 1, B) . This gives

$$
b ( \hat { F } _ { n } ) \approx \frac { 1 } { B } \sum _ { b = 1 } ^ { n } \{ \frac { 1 } { n } \sum _ { j = 1 } ^ { n } \log f ( y _ { j b } ^ { * } ; \hat { \Psi } _ { b } ^ { * } ) - \frac { 1 } { n } \sum _ { j = 1 } ^ { n } \log f ( y _ { j } ; \hat { \Psi } _ { b } ^ { * } ) \} .
$$

Konishi and Kitagawa (1996) showed that the number of bootstrap samples can be greatly reduced by using a variance-reduction technique in the bootstrap simulation: achieved this by noting that the expectation on the right-hand side of (6.23) can be decomposed into three parts as follows: They

$$
b ( F ) = b _ { 1 } ( F ) + b _ { 2 } ( F ) + b _ { 3 } ( F ) ,
$$

where and

$$
b _ { 1 } ( F ) \ = \ E _ { F } \{ \frac { 1 } { n } \sum _ { j = 1 } ^ { n } \log f ( Y _ { j } ; \hat { \Psi } ) - \frac { 1 } { n } \sum _ { j = 1 } ^ { n } \log f ( Y _ { j } ; \Psi ) \}
$$

$$
b _ { 2 } ( F ) \ = \ E _ { F } \{ \frac { 1 } { n } \sum \log f ( Y _ { j } ; \Psi ) - \int \log f ( w ; \Psi ) \, d F ( w ) \}
$$

$$
\overline { j = 1 }
$$

$$
b _ { 3 } ( F ) \ = \ E _ { F } \{ \int \log f ( w ; \Psi ) \, d F ( w ) - \int \log f ( w ; \hat { \Psi } ) \, d F ( w ) \} .
$$

As b2( F) is zero, only the first and third terms on the right-hand side of (6.30) have to be estimated to give

$$
b ( \hat { F } _ { n } ) = b _ { 1 } ( \hat { F } _ { n } ) + b _ { 3 } ( \hat { F } _ { n } ) ,
$$

where

$$
1 ( \hat { F } _ { n } ) \approx \frac { 1 } { B } \sum _ { b = 1 } ^ { B } \{ \frac { 1 } { n } \sum _ { j = 1 } ^ { n } \log f ( y _ { j b } ^ { * } ; \hat { \Psi } ^ { * } ) - \frac { 1 } { n } \sum _ { j = 1 } ^ { n } \log f ( y _ { j b } ^ { * } ; \hat { \Psi } _ { b } ) \}
$$

$$
( \hat { F } _ { n } ) \approx \frac { 1 } { B } \sum _ { b = 1 } ^ { B } \{ \frac { 1 } { n } \sum _ { j = 1 } ^ { n } \log f ( y _ { j } ; \hat { \Psi } ) - \frac { 1 } { n } \sum _ { j = 1 } ^ { n } \log f ( y _ { j } ; \hat { \Psi } _ { b } ^ { * } ) \} .
$$

With the ordinary version of the bootstrap used here, we are effectively estimating all three terms in (6.30). Now; although the bootstrap estimate of the second term will be small, Konishi and Kitagawa (1996) observed from their experiments that it had a much larger variance than that of the bootstrap estimates of b1(F) and b2(F); hence the saving in bootstrap replications when the modified bootstrap approximation that uses only estimates of b1(F) and b3(F). using

<a id="sec-6-8-4"></a>

# 6.8.4 Cross-Validation-Based Information Criterion

The bias correction of the likelihood can be undertaken cross-validation as in Smyth (2000). This cross-validation-based information criterion (CVIC) chooses 9 on the basis of the cross-validated likelihood, log using log

$$
\sum _ { j = 1 } ^ n \log f ( y _ { j } ; \hat { \Psi } _ { ( j ) } ) ,
$$

where '(i) denotes the MLE of % formed from the observed sample y1 after first deleting the jth observation U; (j = 1, n) . The use of cross-validation in this role can be viewed as an alternative method to evaluating the fitted model on a test sample of the same size as the original one (the based.

This 'leave-one-out' cross-validated form would be very time-consuming; given that only one observation is deleted at a time. Hence consideration might be given to v-fold cross-validation where v > 1 observations are deleted at a time The data set is divided up into v disjoint subsets each of size n /v. Another way known as Monte Carlo cross-validation generates B independent partitions of the data set into a test sample of size 7n and a training sample of size (1 Y)n for the estimation of for some fixed value of Y- The main difference between this method and the conventional v-fold cross-validation method is that each data may be used more than once in the test set. Smyth (2000) suggests that the choice of y = 0.5 appears tobe reasonably robust across a variety of problems, while values of B between 20 and 50 appear to be adequate for most applications: Smyth (2000) reports some simulation results in which CVIC implemented via Monte Carlo methods was comparable with the Autoclass algorithm of Cheeseman and Stutz (1996), but the 10-fold cross-validation version was often unreliable. point

Smyth (2000) compared CVIC with BIC and the bootstrap LRTS in their application to the diabetes data analyzed by Reaven and Miller (1979) and subsequently by McLachlan (1992, Section 6.8), Banfield and Raftery (1993),and Fraley and Raftery (1998) among others. also these criteria to decide on the number of clusters in the clustering of Northern Hemisphere geopotential height data; see Smyth, They applied Ide, and Ghil (1999) for details. The three criteria led to the same decision on the number of components in the normal mixture model.

<a id="sec-6-8-5"></a>

# 6.8.5 Minimum Information Ratio Criterion

As discussed in Section 2.14. the rate of convergence of the EM algorithm is deter mined by the largest eigenvalue of the rate matrix,

$$
( 6 . 3 8 )
$$

Or, equivalently; by the smallest eigenvalue of the information rate matrix,

$$
\mathcal { I } _ { c } ^ { - 1 } ( \hat { \Psi } ; y ) I ( \hat { \Psi } ; y ) .
$$

Windham and Cutler (1992) proposed basing the choice of the number of components on (6.39). Their motivation was that, heuristically; a large value of this smallest g be the MLE of < for a g-component mixture model, and let eg be the smallest eigenvalue of (6.39).

With the minimum information ratio (MIR) criterion of Windham and Cutler (1992), which is based on the magnitude of the smallest eigenvalue of the information The value of eg can be computed making use of the result that it is equal to one minus the rate of convergence of the EM algorithm; which can be calculated numerically using (2.46).

Polymenis and Titterington (1998) proposed a modification of the MIR criterion; which was motivated by the remark of Windham and Cutler (1992) that as soon as a mixture model with too many components is fitted, the observed information matrix I(#; v) will be close to singular with the result that the corresponding eg will be close to zero. The idea of Polymenis and Titterington (1998) therefore is to detect the smallest value of g (g) for which e, is "close to zero; and select g to be 9 1. In order to quantify at what point an observed value of eg is close t0 zero, Polymenis and Titterington (1998) propose a Monte Carlo approach as follows:

- 1 . Commencing with g = eg+/eg.
- 2 Generate 99 bootstrap samples of size n from the two-component mixture model with parameter $\Psi$g and calculate a value of r for each of them:

If the observed value of rg is greater than at least 94 of the bootstrap values of rg, increase g by one and repeat steps 1 and 2; otherwise; assume that the number of components is 9 and stop.

In a simulation experiment performed by Polymenis and Titterington (1998), their modified method outperformed the basic method of Windham and Cutler (1992), and it was equivalent to the bootstrap LRT when the components were well separated. When the sample size was increased from n = 1l to n = 300, the modified method became equivalent to the bootstrap LRT for those combinations of the parameters where the components were not well separated.

<a id="sec-6-8-6"></a>

# 6.8.6 Informational Complexity Criterion

Bozdogan (1990, 1993) proposed the informational complexity (ICOMP) criterion in an attempt to improve on the performance of AIC. This criterion has the form

$$
I C O M P ( g ) = - 2 \log L ( \hat { \Psi } ) + C _ { 1 } - C _ { 2 } ,
$$

where

$$
C _ { 1 } = d \log \{ d ^ { - 1 } \text {tr} \mathcal { I } ^ { - 1 } ( \hat { \Psi } ) \}
$$

and

$$
C _ { 2 } = \log | \mathcal { I } ^ { - 1 } ( \hat { \Psi } ) \ | ,
$$

where d is the number of parameters in the model. A concern with this criterion is that it is not invariant under a reparameterization of the model.

Note that in the definitions of C1 and C2 we could have replaced I(v), which is the expected information in the sample, with the expected information in a single observation; since this change would simply result in d being subtracted from both terms To apply this criterion in practice; the expected information matrix I(w) must be estimated. Given the difficulties that would be involved in doing this for a mixture model, Bozdogan (1993) approximates this matrix by using instead the (estimated) expected information matrix for a classified sample. For a g-component normal mixture model, this leads to C1 and C2 estimated by log being

$$
C _ { 1 } = d \log [ d ^ { - 1 } \sum _ { i = 1 } ^ { \infty } \{ \pi _ { i } ^ { - 1 } \text {tr} \hat { \Sigma } _ { i } + \frac { 1 } { 2 } \text {tr} ( \hat { \Sigma } _ { i } \hat { \Sigma } _ { i } ) + \frac { 1 } { 2 } ( \text {tr} \hat { \Sigma } _ { i } ) ^ { 2 } + \sum _ { v = 1 } ^ { \infty } ( \hat { \Sigma } _ { i } ) _ { v v } ^ { 2 } \} ]
$$

and

$$
C _ { 2 } = ( p + 2 ) \sum _ { i = 1 } ^ { g } \log | \hat { \Sigma } _ { i } | - p \sum _ { i = 1 } ^ { g } \log ( n \hat { \pi } _ { i } ) + g p \log ( 2 n ) ,
$$

In their simulations with normal mixture models, Celeux and Soromenho (1996) found that when the component-covariance matrices were very different, ICOMP had tendency, more marked than AIC, to overestimate the order of the mixture model.

<a id="sec-6-9"></a>

# 6.9 BAYESIAN-BASED INFORMATION CRITERIA

<a id="sec-6-9-1"></a>

# 6.9.1 Bayesian Approach

We now consider some criteria that have been derived within a Bayesian framework for model selection, but can be applied also in a non-Bayesian framework; and hence to the choice of the number of components in mixture models considered from either a Bayesian or frequentist perspective. We shall also describe some criteria that apply only within a Bayesian framework.

The main Bayesian-based information criteria use an approximation to the integrated likelihood, as in the original proposal by Schwarz (1978) leading to his Bayesian information criterion (BIC). Available general theoretical justifications of this approximation rely on the same regularity conditions that break down for infer ence on the number of components in a frequentist framework. However, we shall still sketch the derivation of this approximation; assuming that the prerequisite regularity conditions do hold, as use is made of this approximation and results used in its derivation in forming information criteria for model selection regardless of the breakdown in regularity conditions.

<a id="sec-6-9-2"></a>

# 6.9.2 Laplace's Method of Approximation

The Bayes factor for one model against another model is the posterior odds for that model against the other when neither model is favored over the other a priori. It is equal to the ratio of the marginal or integrated likelihood for each model. The reader is referred to Kass and Raftery (1995) for an excellent account of Bayes factors.

We let p(v) denote the density for 4. The integrated likelihood ply) is defined to be prior

$$
\int \exp \{ \log p ( \Psi , y ) \} \, d \Psi ,
$$

$$
( 6 . 4 3 )
$$

where Thus from (6.46), the integrated likelihood is approximated as log

$$
p ( \Psi , y ) = p ( \Psi ) \, L ( \Psi ) .
$$

The results here are conditional on the adopted model for the component densities and the number of components g, but we have suppressed this dependence in our notation here.

$$
\partial \Psi = 0 ,
$$

To approximate the integral (6.43), the integrand is expanded in a second-order Taylor series about the point

$$
( 6 . 4 5 )
$$

on noting from (6.44) that the first-order term vanishes. On substituting this expansion for the integrand into (6.43) and realizing that, apart from a normalizing constant; it is equal to a normal density with mean % and covariance matrix equal to the inverse of H(w), we obtain

$$
\begin{matrix} = \\ = \end{matrix}
$$

$$
( 2 \pi ) ^ { \frac { 1 } { 2 } d } \, | \, H ( \tilde { \Psi } ) \, | ^ { - 1 / 2 } \, .
$$

$$
( \tilde { \Psi } ) \ | + \frac { 1 } { 2 } d \log ( 2 \pi ) . \quad ( 6 . 4 7 )
$$

This approximation is known as Laplace's method or the saddle-point approximation. Laplace's method may be in alternative forms by omitting part of the integrand from the exponent when performing the expansion; see Kass and Raftery (1995). An important variant on (6.47) is applied

$$
\log p ( y ) = \log L ( \hat { \Psi } ) + \log p ( \hat { \Psi } ) - \frac { 1 } { 2 } \log | \, I ( \hat { \Psi } ; y ) \ | + \frac { 1 } { 2 } d \log ( 2 \pi ) ,
$$

where the posterior mode is replaced by the MLE and H(") is replaced by the observed information matrix I(#; u). This approximation thus assumes that the prior is very diffuse so that its effect can be effectively ignored. As cautioned by Ripley (1996, Section 2.6), the assumption that the can be neglected is a strong one. prior

<a id="sec-6-9-3"></a>

# 6.9.3 Bayesian Information Criterion

The Bayesian information criterion (BIC) of Schwarz (1978) is obtained by ignoring terms of 0(1) in (6.48) and noting that

$$
( 6 . 4 9 )
$$

to give

$$
( 6 . 5 0 )
$$

as twice the negative penalized likelihood to be minimized in model selection, including the present situation for the number of components 9 in a mixture model. log

The approximation (6.48) requires the parameters to be identifiable. Hence both this approximation and the expansion (6.47) depend on regularity conditions that do not hold for finite mixture models. However; as and Raftery (1998) note, there chapter, Leroux ( 1992a) has shown that BIC does not underestimate the true number of components, asymptotically. And Roeder and Wasserman (1997) have shown that when a normal mixture model is used to estimate a density "nonparametrically;" the density estimate that uses BIC to select the number of components in the mixture is consistent. also reported a simulation study in which BIC performed very well. Also; Campbell et al. (1997) and Dasgupta and Raftery (1998) have reported encouraging results for BIC applied to mixture models. Fraley They Note that BIC can be used not only to choose the number of components in the mixture model, but also to decide on the adopted model, say, for the component covariance matrices in the parameterization considered in Section 3.12; see, for example, Biernacki and Govaert (1999)

As > 2 for n > 8, it can be seen that the penalty term of BIC penalizes complex models more heavily than AIC, whose penalty term of 2d does not depend on the sample size. As a consequence, it does reduce the tendency of the AIC criterion to fit too many components. On the other hand, it has been found to fit too few components when the model for the component densities is valid and the sample size is not very see, for example; Celeux and Soromenho (1996). If the model for the component densities is not valid, then Biernacki et al. (1998) have found that it tends to fit too many components. logn large;

The criterion BIC has been derived also by Rissanen (1986, 1989) from another perspective based on coding theory.

We have presented BIC in Recently; Roeder and Wasserman (1997) used it in a Bayesian framework to construct an esti mate of pr {g y} of the form

$$
\hat { m } _ { g } / \sum _ { h = 1 } ^ { g _ { u } } \hat { m } _ { h } ,
$$

where

$$
( 6 . 5 2 )
$$

and %h is the posterior mode for the h-component mixture model and dh denotes the number of unknown parameters in it (h = 1, 9u). Here gu is some fixed upper bound for g. Roeder and Wasserman (1997) suggested that gu = 10 should suffice in practice. considered the extension to a nonparametric framework of the mixture model, where 9u is allowed to grow with n, creating what is called a sieve; see also Genovese and Wasserman (1999). As stressed in Roeder and Wasserman (1997),it is important not to let 9 grow too quickly; or the density estimate may be inconsistent. They established that if gu = o(n/logn) , then the posterior estimate is consistent. The same of this result also shows consistency of the posterior for fixed g as as the true density is a mixture of g normals for 1 < 9 < gu. They proof long

<a id="sec-6-9-4"></a>

# 6.9.4 Laplace-Metropolis Criterion

The Bayes factor for a model H1 against another model Ho given the data y is the ratio of the posterior to prior odds, namely B1o

$$
p ( y \, | \, H _ { 0 } ) ,
$$

which is the ratio of the integrated likelihoods where; for a given model H;,

$$
p ( y \, | \, H _ { i } ) = \int p ( \Psi _ { i } \, | \, H _ { i } ) \, L ( \Psi _ { i } \, | \, H _ { i } ) \, d \Psi _ { i } \quad ( i = 0 , 1 ) ,
$$

where %; is the vector of parameters under the model H; (i = 0, 1). As advocated by Raftery (1996), the Bayes factor is a summary of the evidence for H1 against Ho. In Table 6.8 we give the rounded scale for interpreting B1o as provided by Raftery (1996) based on that of Jeffreys (1961).

Raftery (1996) proposed choosing both the model and the number of components 9 in the mixture by using posterior simulation to calculate the required quantities in the Laplace approximation (6.47) to the integrated likelihood. The idea is to use the simulated posterior values for € to avoid having to calculate the posterior mode ñ

Table 6.8 Calibration of the Bayes Factor B1o

| B1o       | 2log B1o | Evidence for H1                                                            |
| --------- | -------- | -------------------------------------------------------------------------- |
|           | 0        | Negative (supports Ho) Barely worth mentioning Positive Strong strong Very |
| 1 to 3    | 0 to 2   |                                                                            |
| 2 to 12   | 2 to 5   |                                                                            |
| 12 to 150 | 5 to 10  |                                                                            |
| > 150     | > 10     |                                                                            |

Source: From Raftery (1996)

Laplace approximation (6.47). They can be approximated by a robust version of location and scale from the simulated posterior replicates of V; see Raftery (1996).

Recently, Aitkin et al. (1996) considered a test for the number of components, using the posterior Bayes factors;, as variation of the "prior" Bayes factors defined above; that is, one uses the posterior density of Vin place of its= density in (6.54). prior

<a id="sec-6-9-5"></a>

# 6.9.5 Laplace-Empirical Criterion

Rather than use the approximation (6.49) which gives the final form of BIC, we might wish to choose the number of components 9 on the basis of (6.48) directly. It is thus the analogue of the Laplace-Metropolis criterion in a non-Bayesian framework: The use of (6.48) requires the calculation of the observed information matrix I(#; ")As discussed in Section 2.15.3,it can be conveniently approximated by the empirical information matrix Ie(#). We shall call the criterion that uses this approximation in (6.48),the Laplace-Empirical (matrix-based) criterion (LEC). This criterion therefore chooses 9 to minimize

$$
- 2 \log L ( \hat { \Psi } ) - 2 \log p ( \hat { \Psi } ) + \log | \, I _ { e } ( \hat { \Psi } ) \, | - d \log ( 2 \pi ) .
$$

Roberts et al. (1998) considered this criterion in the form where the observed second-order partial derivatives of the likelihood in the simplified case of diagonal component-covariance matrices. They then performed a transformationto convert their results tothe general case of unrestrictedcomponent-covariance matrices. However; we have been unable to confirm the validity of this conversion. log

Concerning the specification of a prior for use in this criterion, we can first trans form the data so that the sample covariance matrix is the identity matrix. Roberts et al. (1998) then take the ith component-mean elements (u;)1, (u;)p to be independent and uniformly distributedon the interval [~w,w] (i = 1, 9). They take the diagonal elements of the component-covariance matrices to be independent and uniformly distributedon the interval [0, ß]- Note that with ß fixed, the posterior is not robust; see Robert et al. (2000), who use a hyperprior on the component variances to make the posterior robust.

Roberts et al. (1998) did not specify a for the off-diagonal elements; but could be taken to be independently distributed on the interval [~ß, ß]. They adopted the Dirichlet distribution D(a1, 1, g), as the prior for the mixing proportions T;. For this specification; the log prior they

$$
\begin{array} { r l } { p ( \Psi ) } & { = } & { \log ( g - 1 ) ! - g p \log ( 2 \omega ) - g p \log \beta - \frac { 1 } { 2 } g p ( p - 1 ) \log ( 2 \beta ) } \\ & { = } & { \log ( g - 1 ) ! - g p \log ( \omega ) - \frac { 1 } { 2 } g p ( p + 1 ) \log ( 2 \beta ) . } \end{array}
$$

To make this criterion fully consistent with a frequentist setting; we would need to ignore this term in (6.55). But if we do this, it is no longer invariant under reparameterization. However; its presence has no effect on estimation for a fixed value of g prior log

<a id="sec-6-9-6"></a>

# 6.9.6 Reversible Jump Method

To conclude this section on Bayesian-based methods for choosing the number of components g, we mention the fully Bayesian approaches of Noble (1994), Phillips and Smith (1996), and Richardson and Green (1997) in which the number of components 9 is treated as an unknown parameter in the formulation of the Bayesian model. As seen in Section 4.7, Richardson and Green (1997) use reversible jump MCMC methods to handle this case where the dimension of the parameter space is of varying dimension. The results of Phillips and Smith (1996) and Richardson and Green (1997) were presented for univariate component densities. A marked increase in computational effort would be needed for multivariate components\_

<a id="sec-6-9-7"></a>

# 6.9.7 MML Principle

It can be seen from (6.47) that criteria based on this approximation are very similar to the MML approach defined in Section 4.11, whereby 9 is chosen to minimize the minimum message length. Apart from the lattice constant term, the minimum message length has the same form as (6.47).

<a id="sec-6-10"></a>

# 6.10 CLASSIFICATION-BASED INFORMATION CRITERIA

We consider now some criteria that have been developed by consideration either from a frequentist or Bayesian perspective of the so-called classification likelihood Lc (") , which is the complete-data likelihood (2.26) within the EM framework for the of a mixture model. fitting

<a id="sec-6-10-1"></a>

# 6.10.1 Classification Likelihood Criterion

Biernacki and Govaert (1997) made use of the relationship linking the likelihood L(v) for the mixture model and the complete-data likelihood Lc(v) to propose a criterion for selecting the number of clusters arising from the of a normal mixture model. Although Lc(v) defined by (2.26) is referred to as the completedata likelihood within the EM framework, it is sometimes called the classification likelihood in a classification context; as discussed in Section 2.21. fitting As noted by Hathaway (1986a) among others, can express the mixture log we log

where

$$
\log L ( \Psi ) = \log L _ { c } ( \Psi ) - \log k ( \Psi ) ,
$$

$$
\log k ( \Psi ) = \sum _ { i = 1 } ^ { y } \sum _ { j = 1 } ^ { n } z _ { i j } \log \tau _ { i j }
$$

and where Tij = defined by (1.19). That is, k($) is the conditional density of the vector of componentindicator variables

$$
z =
$$

given the observed data y = (v{ ,

The conditional mean of where log

$$
E N ( \tau ) = - \sum _ { i j } \sum _ { \tau _ { i j } } \tau _ { i j } \log \tau _ { i j }
$$

is the entropy of the fuzzy classification matrix C = ((vij)) and where

$$
( 6 . 5 8 )
$$

and

$$
\tau _ { j } = ( \tau _ { 1 } ( y _ { j } ; \Psi ) , \dots , \tau _ { g } ( y _ { j } ; \Psi ) ) ^ { T }
$$

isthe vector ofposterior probabilities ofcomponent membershipofu; (j = 1, n) We now write the complete-data likelihood as Lc(%; 2) to explicitly denote that it is formed on the basis of z containing the component indicators; in addition to y.

$$
\log L _ { c } ( \hat { \Psi } ; \hat { \tau } ) = \log L ( \hat { \Psi } ) - E N ( \hat { \tau } ) ,
$$

$$
\hat { \tau } _ { i j } = \tau _ { i } ( y _ { j } ; \hat { \Psi } ) \ \ ( i = 1 , \dots , g ; \, j = 1 , \dots , n )
$$

in (6.59). From (6.60), we can form the classification likelihoodinformation criterion (CLC), where g is chosen to minimize

$$
- 2 \log L ( \hat { \Psi } ) + 2 E N ( \hat { \tau } ) ,
$$

where the estimated entropy EN(â) is used as the term that penalizes the model for its complexity.

If the components of the mixture are well separated, then EN(F) will be close to its minimum value of zero. But if the mixture components are poorly separated, then EN(+) will have a large value. Hence how severely this criterion penalizes the likelihood depends on how well separated the fitted components are. According to Biernacki;, Celeux, and Govaert (1999), this criterion works well when the mixing proportions are restricted to equal . But it tends to overestimate the correct number of clusters when no restriction is placed on the mixing proportions: log being

Banfield and Raftery (1993) suggested an approximate Bayesian solution to the choice of the number of clusters using the classification ML approach. Their approx imation, which is a crude approximation to twice the Bayes factor for 9 clusters; leads to the approximate weight of evidence (AWE) criterion having the form log

$$
A W E ( g ) = - 2 \log L _ { c } + 2 d ( 3 / 2 + \log n ) .
$$

When the mixture components are well separated, we have scen above that Lc(#) ~ L(4), and thus it can then be expected to be similar to BIC. When the clusters are not well separated, it has been noted in Section 2.21 that the classification likelihood approach to model leads to severely biased estimates of the parameters. fitting

<a id="sec-6-10-2"></a>

# 6.10.2 Normalized Entropy Criterion

Celeux and Soromenho (1996) proposed using the estimated entropy EN(F) (after normalization) as a criterion in its own right for choosing the number of clusters. This criterion is known as the normalized entropy criterion (NEC). The estimated entropy EN(F) cannot be used directly to assess the number of components in a mixture model, since log L(#) is an increasing function of g. The normalized form is given by

$$
N E C ( g ) = \frac { E N ( \hat { \tau } ) } { \log L ( \hat { \Psi } ) - \log L ( \hat { \Psi } ^ { ^ { * } } ) } ,
$$

where denotes the MLE of % in the case of a single (9 = 1) component. The entropy forg = 1iszero. Asit stands; this criterionis unable todecide between g = 1 and value of g greater than one. Celeux and Soromenho (1996) proposed a rule of thumb, but their procedure was restricted to normal mixtures and had performed disappointingly (Biernacki et al., 1999). In the latter paper, a general procedure was proposed to deal with this problem. Effectively, define NEC(g) to be one for 9 = 1. The modified criterion simply then consists of choosing 9 t0 minimize NEC(g). The justification for setting NEC(1) = 1 is as follows. When comparing perspective to < 9 = g; (i = 0,1) This is because one would expect that the model with the 9 As a consequence, to choose 9 > 1 rather than g > 1 to be greater than its value for 9 = 1. If the latter holds, then it follows from (6.60) that 0 < NEC(g) < 1. Hence the only values of 9 > 1 of interest must satisfy this they prefer larger condition. If there is no value of g such that NEC(g) 1, then there is no reason to choose 9 > 1. According to Biernacki et al. (1999), this improved version of the NEC criterion corrects for the tendency of the original version to prefer g > Iclusters when the true number is one.

A similar type criterion is the partition coefficient (PC) of Bezdek (1981), where

$$
P C ( g ) = \sum _ { i = 1 } ^ { j } \sum _ { j = 1 } ^ { n } \hat { \tau } _ { i j } ^ { 2 }
$$

Numerical experiments reported by Windham and Cutler ( 1992)clearly show that the PC criterion tends to underestimate the order of the mixture model.

<a id="sec-6-10-3"></a>

# 6.10.3 Integrated Classification Likelihood Criterion

We now sketch the development of the integrated classification likelihood (ICL) terion as proposed by Biernacki et al. (1998) introduced this criterion in an attempt to overcome the shortcomings of BIC and CLC. criThey

The integrated classification likelihood is given by

$$
( 6 . 6 4 )
$$

$$
( 6 . 6 5 )
$$

where € = Then

where

$$
p ( y , z ) = p ( z ) \, p ( y \, | \, z ) ,
$$

$$
p ( y | z ) =
$$

and

$$
p ( z ) = \int
$$

Biernacki et al. (1998) adopted the Dirichlet distribution D(œ1, 9). For this prioc, the log integrated likelihood for T is given by

where

$$
\log p ( z ) \ = \ \log \int _ { A } \pi _ { 1 } ^ { \alpha + n _ { 1 } } \cdots \pi _ { g } ^ { \alpha + n _ { g } } \{
$$

$$
K ( n _ { 1 } , \, .
$$

$$
K ( n _ { 1 } , \dots , n _ { g } ) = \sum _ { i = 1 } ^ { g } \log \Gamma ( n _ { i } + \alpha ) - \log \Gamma ( n + g \alpha ) - g \log \Gamma ( \alpha ) + \log \Gamma ( g \alpha )
$$

and

$$
n _ { i } = \sum _ { j = 1 } ^ { n _ { i } = \sum _ { z _ { i j } } z _ { i j } } \ ( i = 1 , \dots , g ) .
$$

On substituting (6.67) into (6.66), we obtain

$$
\log p ( y , z ) = \int \log p ( y \, | \, z , \xi ) \, d \xi + K ( n _ { 1 } , \dots , n _ { g } ) .
$$

Biernacki et al. (1998) then applied the BIC approximation to the first term on the right-hand side of (6.69) to give

$$
- \, \frac { 1 } { 2 } d _ { 1 } \log n + K ( n _ { 1 } , \, \dots , \, n _ { g } ) , \quad ( 6 . 7 0 )
$$

where d1 is the number of unknown parameters in €.

If we maximize the MLE € of € as obtained by consideration of the mixture likelihood L(v). We which is the vector containing the MLEs of the posterior probabilities of component membership of V; (j = 1, n)

It follows then from Section 2.8.4 that the maximum over p(y

the maximum value of p(v

$$
\sum z _ { i j } \log \pi
$$

$$
r _ { i } \log \hat { \pi } _ { i } ,
$$

$$
( 6 . 7 1 )
$$

on noting that

$$
\sum _ { i = 1 } ^ { j } \sum _ { j = 1 } ^ { n } \hat { \tau } _ { i j } \log \hat { \pi } _ { i } = n \sum _ { i = 1 } ^ { j } \hat { \pi } _ { i } \log \hat { \pi } _ { i } .
$$

From (6.60), we can express (6.71) in terms of the mixture log likelihood as

$$
\log L ( \hat { \Psi } ) - E N ( \hat { \tau } ) - n \sum _ { \pi _ { i } } ^ { s } \hat { \pi } _ { i } \log \hat { \pi } _ { i } .
$$

Thus from (6.70) and (6.72), twice the ncgative of the log integrated classification likelihood with z = #can be approximated as

$$
- 2 \log L ( \hat { \Psi } ) + 2 E N ( \hat { \tau } ) + 2 n \sum _ { i = 1 } ^ { g } \hat { \pi } _ { i } \log \hat { \pi } _ { i } + d _ { 1 } \log n - 2 K ( n \hat { \pi } _ { 1 } , \dots , n \hat { \pi } _ { g } ) .
$$

The ICL criterion chooses the number of components 9 to minimize (6.73).

Biernacki et al. (1998) derived an approximation to (6.73) when the nî; are suffi ciently large to approximate the Gamma function by Stirling's formula

$$
\Gamma ( u ) \approx u ^ { u + \frac { 1 } { 2 } } \exp ( - u ) ( 2 \pi ) ^ { 1 / 2 } .
$$

On this approximationin K(nî1, neglecting terms of order 0(1): using

$$
K ( n \hat { \pi } _ { 1 } , \dots , n \hat { \pi } _ { g } ) \approx n \sum _ { i = 1 } ^ { n } \hat { \pi } _ { i } \log \hat { \pi } _ { i } - \frac { 1 } { 2 } ( g - 1 ) \log n .
$$

$$
\hat { \tau } _ { g } ) \approx n \sum _ { i = 1 } ^ { j } \hat { \pi } _ { i } \log \hat { \pi } _ { i } - \frac { 1 } { 2 } ( g - 1 ) \log n .
$$

On substituting (6.74) into (6.73), this expression can be written as

which reduces to

$$
1 \log n -
$$

$$
- 2 \log L ( \hat { \Psi } ) + 2 E N ( \hat { \tau } ) + d \log n ,
$$

We shall refer to this version of the ICL criterion that chooses 9 by minimizing appropriate for large cluster

(6.75) as the ICL_BIC criterion. Although it is only sizes; Biernacki et al. (1998) have found that its performance differs little from the more accurate version (6.73). using

As pointed out by Biernacki et al. (1998), the ICL criterion has a close link with the CS criterion proposed by Cheeseman and Stutz (1996); see also Cheeseman and Heckerman (1997). This criterion is based on (6.73) without the entropy term EN(+) . On using the approximation (6.74), it becomes equivalent to ordinary BIC.

<a id="sec-6-11"></a>

# 6.11 AN EMPIRICAL COMPARISON OF SOME CRITERIA

We report here some simulation results of McLachlan and Ng (2000b) to compare the performances of some of the more recently suggested criteria with classical procedures such as BIC for the selection of the number of components in a mixture model. Seven selection criteria were compared, namely AIC, BIC, EIC [Efron (bootstrapbased) information criterion], CLC (classification likelihood criterion), ICL (integrated classification likelihood) criterion; its BIC-type approximation; ICL-BIC, and LEC (Laplace-Empirical criterion) The latter was implemented with w = 2 and

The EMMIX algorithm of McLachlan et al. (1999) was used to fit normal mixture

models with a varying number of components to three simulated data sets. Ten random starts were performed for each set to initialize the EM algorithm. The solution corresponding to the largest local maximum of the likelihood located was taken as the MLE after elimination of local maximizers considered to be spurious on the basis of the relative sizes of the fitted generalized component variances. log

<a id="sec-6-11-1"></a>

# 6.11.1 Simulated Set 1

Set 1 consisted of n = 625 four-dimensional observations obtained by generating samples separately from each of five normal distributions. The component-sample sizes, means, and covariance matrices; which were those adopted in Bozdogan (1993) and Celeux and Soromenho (1996), are displayed below:

$$
and C e l e x u \text { and Soromenho (1996), are displayed below: } \\ \mu _ { 1 } = ( 1 0 , 1 2 , 1 0 , 1 2 ) ^ { T } & \quad \Sigma _ { 1 } = I _ { p } \quad n _ { 1 } = 7 5 \\ \mu _ { 2 } = ( 8 . 5 , 1 0 . 5 , 8 . 5 , 1 0 . 5 ) ^ { T } & \quad \Sigma _ { 2 } = I _ { p } \quad n _ { 2 } = 1 0 0 \\ \mu _ { 3 } = ( 1 2 , 1 4 , 1 2 , 1 4 ) ^ { T } & \quad \Sigma _ { 3 } = I _ { p } \quad n _ { 3 } = 1 2 5 \\ \mu _ { 4 } = ( 1 3 , 1 5 , 7 , 9 ) ^ { T } & \quad \Sigma _ { 4 } = 4 I _ { p } \quad n _ { 4 } = 1 5 0 \\ \mu _ { 5 } = ( 7 , 9 , 1 3 , 1 5 ) ^ { T } & \quad \Sigma _ { 5 } = 9 I _ { p } \quad n _ { 5 } = 1 5 5 \\ \triangle q \text { component normal mixture model with diagonal component }
$$

A g-component normal mixture model with diagonal component-covariance matrices was fitted. The results are given in Table 6.9, where the superscript \* denotes the true value of g and also, for a given criterion, the value of g selected.

Table 6.9 Determination of the Number of Components: Set 1

| 9   | AIC     | EIC     | BIC     | CLC     | ICLBIC  | ICL     | LEC     |
| --- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| 2   | 12375   | 12377   | 12451   | 12430   | 12540   | 12437   | 12430   |
| 3   | 12022   | 12026   | 12138   | 12220   | 12388   | 12232   | 12080   |
| 4   | 11379   | 11379   | 11535   | 11457   | 11682   | 11475   | 11482   |
| 5\* | 11283\* | 11285\* | 11479\* | 11365\* | 11648\* | 11387\* | 11422\* |
| 6   | 11287   | 11309   | 11522   | 11396   | 11737   | 11423   | 11426   |
|     | 11296   | 11320   | 1157]   | 11542   | 11941   | 11573   | 11449   |

Source: Adapted from McLachlan and Ng (20O0b)

<a id="sec-6-11-2"></a>

# 6.11.2 Simulated Set 2

Set 2 consisted of n = 300 trivariate observations obtained by generating samples means, and covariance matrices as displayed below:

$$
0 ) ^ { T } \ \Sigma _ { 1 } = \left ( \begin{array} { c c c } & & & \\ & 0 & & 4 & 0 \\ & & & 0 & 1 \\ & & & 0 & 0 \end{array} \right ) \quad n _ { 1 } = 2 0 0
$$

$$
\mu _ { 2 } = ( - 6 , 3 , 6 ) ^ { T } \quad \Sigma _ { 2 } = \left ( \begin{array} { c c c } 4 & - 3 . 2 & - 0 . 2 \\ - 3 . 2 & 4 & 0 \\ - 0 . 2 & 0 & 1 \end{array} \right ) \quad n _ { 2 } = 5 0
$$

$$
\mu _ { 3 } = ( 6 , 6 , 4 ) ^ { T } \quad \Sigma _ { 3 } = \left ( \begin{array} { c c c } 4 & 3 . 2 & 2 . 8 \\ 3 . 2 & 4 & 2 . 4 \\ 2 . 8 & 2 . 4 & 2 \end{array} \right ) \quad n _ { 3 } = 5 0
$$

The results are given in Table 6.10 for the fitting of a g-component normal mixture model with unrestricted component-covariance matrices.

Table 6.10 Determination of the Number of Components: Set 2

| 9   | AIC    | EIC    | BIC    | CLC    | ICLBIC | ICL    | LEC    |
| --- | ------ | ------ | ------ | ------ | ------ | ------ | ------ |
| 2   | 4239   | 4245   | 4309   | 4203   | 4311   | 4312   | 4300   |
| 3\* | 3978   | 3982   | 4085\* | 3933   | 4098\* | 4098\* | 4085\* |
|     | 3968   | 3982\* | 4112   | 3905\* | 4128   | 4127   | 4126   |
| 5   | 3967\* | 3982   | 4149   | 4019   | 4298   | 4292   |        |

True value of g or value of g given by criterion: Source: Adapted from McLachlan and Ng (2000b).

<a id="sec-6-11-3"></a>

# 6.11.3 Simulated Set 3

The third simulated set consisted of a sample of n = 200 bivariate observations obtained by generating a sample of n1 = 100 observations from a bivariate normal distribution with mean (3.3,0)T and identity covariance matrix, with a further sample of n2 = 100 observations from the density along

$$
f ( w ) = 0 . 2 5 I _ { ( - 1 , 1 ) } ( w _ { 1 } ) I _ { ( - 1 , 1 ) } ( w _ { 2 } ) .
$$

The results are given in Table 6.11 for a normal mixture model with unre stricted component-covariance matrices. fitting

Table 6.11 Determination of the Number of Components: Set 3

| 9   | AIC    | EIC    | BIC    | CLC    |        | ICL    | LEC    |
| --- | ------ | ------ | ------ | ------ | ------ | ------ | ------ |
|     | 1315   | 1315   | 1308   | 1305   | 1332   | 1720   | 1302   |
| 2\* | 1207   | 1205   | 1244   | 1204   | 1262\* | 1263\* | 1239\* |
| 3   | 1178   | 1179\* | 1234\* | 1175\* | 1265   | 1265   | 1240   |
|     | 1175   | 1184   | 1251   | 1184   | 1306   | 1305   | 1249   |
| 5   | 1174\* | 1185   | 1269   | 1208   | 1362   | 1357   | 1273   |

True value of g or value of g given criterion. by

<a id="sec-6-11-4"></a>

# 6.11.4 Conclusions from Simulations

It can be seen that the integrated classification likelihood (ICL), its large cluster size approximation; ICL-BIC, and the Laplace-Empirical criterion (LEC) are the only criteria to correctly select the true number of components in all three simulated data sets The criterion of ICL-BIC is the easiest to apply of these criteria; while LEC is the hardest in the sense that it requires the evaluation of the determinant of the observed information matrix. The tendency of the AIC criterion to select too many components (clusters) is evident in the results for Sets 2and 3. The bootstrap version of this criterion, EIC, does do a better job for these two sets, but it still selects too many components.

