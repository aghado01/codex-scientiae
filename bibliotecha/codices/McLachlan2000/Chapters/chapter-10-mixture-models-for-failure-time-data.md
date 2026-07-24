<a id="sec-mixture-models-for-failure-time-data"></a>

# Mixture Models for Failure-Time Data

<a id="sec-10-1"></a>

# 10.1 INTRODUCTION

Itis only in relatively recent times that the potential of finite mixture models has started to be exploited in survival and reliability analyses. Mixture models can be used to analyze failure-time data in a variety of situations. As a flexible way ofmodeling data; mixture models have obvious applications in situations where a single parametric family may not suffice. For example; following open-heart surgery, Blackstone, Naftel, and Turner (1986) consider that the risk of death can be characterized by three merging phases: an early phase in which the risk is relatively high, a middle phase of constant risk, and finally a late phase in which the risk starts to increase as the patient ages. These phases overlap each other in time and thus cannot be modeled satisfactorily by attempting to fit a separate parametric model to each discrete time component mixture model with three components corresponding to the three phases of death provides an effective way of modeling survival; see, for example, McGiffin et al. (1993) and McLachlan and McGiffin (1994). These models can be viewed in the mixtures-of-experts framework, as considered in Chapter 5. This was the approach taken by Rosen and Tanner ( 1999), who proposed a mixture of Cox experts in which the components were taken to follow the Cox proportional hazards model:.

The Weibull distribution is perhaps the most widely used lifetime distribution model because of its flexibility and simple expressions for the density; survival , and hazard functions. The Weibull hazard function can be monotone increasing, decreas or constant, depending upon the value of the shape parameter for the distribution. It has been found that such flexibility provides a fit for a wide variety of lifetime good data. Hence it is not surprising that mixtures of Weibull distributions are widely used in survival and reliability analyses with heterogeneous data; For example, Patra and (1999) considered a multivariate mixture of Weibull distributions in reliability modeling. Some characteristics of mixtures of Weibulls can be found in Gupta and Gupta (1996). Dey Another situation where mixture distributionscan play auseful role is in modeling time to failure in the case of competing risks of failure. In this chapter, we shall focus on the latter situation. The results are to be presented mainly in a survival analysis context, but apply equally well to problems in reliability analysis. they When the shape parameter is set equal to one in the Weibull distribution;, we obtain the exponential . Mixtures of exponential distributions are also widely used in science and the social sciences. It is frequently adopted to model the distribution of time to failure in those situations where the hazard function is observed empirically to decline with time. Heckman et al. (1990) have presented nonparametric tests to distinguish mixtures of exponentials from more general models with declining hazards. McLachlan (1995) has provided a review of mixtures of exponential distributions. applied

<a id="sec-10-2"></a>

# 10.2 COMPETING RISKS

<a id="sec-10-2-1"></a>

# 10.2.1 Mixtures of Survival Functions

In the analysis of failure-time data, it is often necessary to consider different types taken to have failed with the occurrence of the first failure from either cause, and observe the time T to failure and the type of failure i (i = 1,2) In the case where the study terminates before failure occurs, T is the censoring time and the censoring indicator & is set equal to zero to indicate that the failure time is right-censored. we

The traditional approach to the modeling of the distribution of failure time in the case of competing risks is to postulate the existence of so-called latent failure times, T1 and T2, corresponding to the two causes and to proceed with the modeling of T = min(T, T2) on the basis that the two causes are independent of each other; see David and Moeschberger (1978) and Kalbfleisch and Prentice (1980).

An alternative approach is to adopt a two-component mixture model, whereby the survival function of T is modeled as

$$
( 1 0 . 1 )
$$

where the ith component-survival function S;(t; \*) denotes the conditional survival function; given that failure is due to the ith cause, and #;(æ) is the probability of failure from the ith cause (i = 1,2). Here z is a vector of covariates associated with the item: It is common to assume that the mixing form,

$$
\pi _ { 1 } ( x ; \beta ) = 1 - \pi _ { 2 } ( x ; \beta ) = \exp ( a + b ^ { T } x ) / \{ ( 1 + \exp ( a + b ^ { T } x ) ) , \quad ( 1 0 . 2 )
$$

where / (a, 6T)T is the vector of logistic regression coefficients; see Farewell (1977, 1982,1986) .

The mixture model (10./) is expressed in terms of the survival functions, but it could be expressed equivalently in terms of the density functions, namely;

$$
( 1 0 . 3 )
$$

where

$$
t \ = 1 , \dots , g ) .
$$

This mixture approach provides an alternative method to that of Prentice et al. (1978), who characterize the joint distribution of the failure time and the type of failure in terms of cause-specific hazard functions.

The mixture approach was adopted by Larson and Dinse (1985), who assumed also that the component-survival functions follow a proportional hazards model (Cox, 1972) and that the baseline hazard functions hoi(t) (i = 1, 2) are piecewise constant for simplicity. That is,

$$
h _ { i } ( t ; x ) \ & = \ e ^ { \gamma _ { i } ^ { T } x } h _ { 0 i } ( t ) \\ & = \ e ^ { \gamma _ { i } ^ { T } x + \alpha _ { i , m } } , \quad \text {if } t \in J _ { m } ,
$$

where $Y_j$ is a vector of parameters, J1, JM are M prespecified disjoint intervals that totally exhaust the nonnegative real line; and œim is the parameter representing the log of the ith component-baseline hazard on the mth interval Jm (i = 1,2; m = 1, As an alternative to this specification of hoi(t), we can adopt some parametric form for the ith component-baselinehazard function hoi(t) (i = 1,2). For example; Gordon (1990a) adopted the Gompertz distribution fto specify the conditional survival functions in the context of estimating the "cure" rate of breast cancer after a treatment therapy. She also examined the applicability of the mixture model for Kuk (1992) and Kuk and Chen (1992), on the other hand, considered a semiparametric version of (10.4) by treating the baseline hazard functions hoi (t) as nuisance parameters to be eliminated during the analysis.

<a id="sec-10-2-2"></a>

# 10.2.2 Latent Failure-Time Approach

With the traditional approach to the handling of competing risks; consideration is given to the hypothetical latent failure times corresponding to each cause in the absence of theother (Moeschberger and David, 1971). Accordingly; welet T1 be the latent failure time due to the first cause in the absence of the second; and, likewise, we let T2 be the = 1,2) With this approach, it is common to assume that the competing risks are independent. Under this assumption, the survival function S(t; \*) for the observable T = min(T1, T2) is given by

$$
( t ; x ) = \int _ { 0 } ^ { \infty } f _ { l 1 } ( u ; x ) S _ { l 2 } ( u ; x ) \, d u + \int _ { 0 } ^ { \infty } f _ { l 2 } ( u ; x ) S _ { l 1 } ( u ; x ) \, d u .
$$

We can write (10.S) as the two-component mixture model (10.1), where the mixing proportions Ti(æ) are given by

$$
\pi _ { 1 } ( x ) = 1 - \pi _ { 2 } ( x ) = \int _ { 0 } ^ { \infty } f _ { l 1 } ( u ; x ) S _ { l 2 } ( u ; x ) \, d u
$$

and the component-survival functions S;(t; 2) are given by

$$
( 1 0 . 7 )
$$

and

$$
S _ { 2 } ( t ; x ) & = \left \{ \int _ { t } ^ { \infty } f _ { l 2 } ( u ; x ) S _ { l 1 } ( u ; x ) d u \right \} / \pi _ { 2 } ( x ) . \\
$$

$$
S _ { 2 } ( t ; x ) =
$$

Itcan be seen fromthe forms (10.7)and (10.8) for the component-survival functions that if the latent failure due to one risk is much greater than the other; then this will affect the component-survival function corresponding to the other risk through the effect of truncation in the integrand of the integrals on the right-hand sides of (10.7) and (10.8). It suggests that in practice there may be a need to have the components of the two-component mixture model (10.1) interrelated or some constraints imposed on them in modeling competing risks. We shall demonstrate this in the case study to follow shortly.

Note that modeling the overall hazard function as a mixture is equivalent to using a latent failure-time approach.

<a id="sec-10-2-3"></a>

# 10.2.3 ML Estimation for Mixtures of Survival Functions

We now consider the of the mixture model (10.1) by maximum likelihood. The observed data are of the form y = (v{ . fitting"

$$
T \ ( j = 1 , \dots , n )
$$

and where &; =iif the jth entity failed due to cause i (i = 1,2) and ô; = 0 ifthe jth entity had not failed by the end of the study (that is, the failure time is right-censored at time t;)

is a vector of unknown parameters (i = 1, 2) The vector of all unknown parameters is given by v = The log likelihood for $\Psi$ that can be formed from the observed data y is given by

$$
\log L ( \Psi ) & = \sum _ { j = 1 } ^ { n } [ I _ { [ 1 ] } ( \delta _ { j } ) \log \{ \pi _ { 1 } ( x _ { j } ; \beta ) f _ { 1 } ( t _ { j } ; \theta _ { 1 } , x _ { j } ) \} \\ & + I _ { [ 2 ] } ( \delta _ { j } ) \log \{ \pi _ { 2 } ( x _ { j } ; \beta ) f _ { 2 } ( t _ { j } ; \theta _ { 2 } , x _ { j } ) \} \\ & + I _ { [ 0 ] } ( \delta _ { j } ) \log S ( t _ { j } ; \Psi , x _ { j } ) ] ,
$$

If the component-survival functions belong to the exponential family; then we can fit the model (10.1) within the framework of mixtures of GLMs, as discussed in Chapter 5. McLachlan et al. (1997) have developed a program for this model in the case where the component-survival functions are specified by assuming proportional hazards and taking the baseline hazard functions hoi(t) (i = 1,2) to have the Gompertz form. That is, the ith component-hazard function is specified as fitting

$$
h _ { i } ( t ; \theta _ { i } , \varepsilon ) = \exp ( \gamma _ { i } ^ { T } \varepsilon ) \, h _ { 0 i } ( t ) \quad ( \dot { i } = 1 , 2 ) ,
$$

$$
h _ { i } ( t ; \theta _ { i } , \mathfrak { a } ) & = \exp ( \gamma _ { i } ^ { T } \mathfrak { a } ) \, h _ { 0 i } ( t ) \quad ( i = 1 , 2 ) , \\ h _ { 0 i } ( t ) & = \exp ( \lambda _ { i } + \kappa _ { i } \, t ) ,
$$

where

with Ki Y)T (i = 1,2). The identifiability of mixtures of Gompertz distributions has been established by Gordon (1990a) in the case of mixing proportions that do not depend on any covariates: The extension to the case of mixing proportions specified by the logistic model (10.2) is straightforward. It follows that sufficient condition for identifiability of the Gompertz mixture model is that the matrix (æt zt)T be of full rank, where

$$
=
$$

This model does not admit a closed-form solution on the M-step of the EM algorithm. But the calculation can be simplified by replacing the M-step with two computationally simple conditional maximization (CM) steps, as with the extension of the EM algorithm that Meng and Rubin (1993) termed the expectation-conditional maximization (ECM) algorithm. The two CM-steps here correspond to the subdivi-

<a id="sec-10-3"></a>

# 10.3 EXAMPLE 10.1: HEART-VALVE DATA

<a id="sec-10-3-1"></a>

# 10.3.1 Description of Problem

To illustrate the application of mixture models for competing risks in practice, we consider the problem studied in Ng et al. (1999). considered the use of the two-component mixture model (10.1) to estimate the probability that a patient valve replaced by a xenograft prosthesis. At the time of the initial replacement operation, the surgeon has the choice of using either a mechanical valve or a biologic val such as a xenograft (made from porcine valve tissue) Or an allograft (human take blood-thinning drugs for the rest of hishher life to avoid thromboembolic events. On the other hand, biologic valves have a finite working life, and thus have to be replaced if the patient were to live for a sufficiently long enough time after the initial replacement operation. Thus inferences about the probability that a patient of They aged ve, they given age will need to undergo a rereplacement operation can be used to assist a heart surgeon in deciding on the type of valve to be used in view of the 'patient's S age.

With respect to this problem; we now let T denote the time to either a rereplacement operation or to death without a rereplacement operation. For brevity; we shall henceforth refer to the event of a rereplacement operation as a reoperation. The data set consisted of n = 950 cases of aortic valve replacements that were performed with xenograft prostheses. There were 62 subsequent valve-replacement operations due to either xenograft degeneration or some other reason, while 198 patients died without a reoperation: The remaining 690 survival times were all censored. The proportion of censored observations was as as 739. large

The observed data are of the form

$$
y _ { 1 } = ( t _ { 1 } , \, x _ { 1 } , \, \delta _ { 1 } ) ^ { T } , \dots , y _ { n } = ( t _ { n } , \, x _ { n } , \, \delta _ { n } ) ^ { T } ,
$$

where ôj 1 if the jth patient undergoes a reoperation, 6; = 2 if the jth patient = 0 if the jth patient is still alive without having undergone reoperation by the end of the study (that is, the failure time is then right-censored at time t;)

<a id="sec-10-3-2"></a>

# 10.3.2 Mixture Models with Unconstrained Components

For a patient aged x years at the time of the initial replacement operation; we can model the survival function of T by (10.1), where S1(t; c) denotes the conditional survival function given the patient undergoes a reoperation and S2(t; \*) denotes the conditional survival function given the patient dies without needing a reoperation. The proportion T1(z) then represents the probability of interest, namely that patient 2 years at the time of the initial replacement operation will undergo a reoperation in hislher lifetime. The logistic model mixing aged

$$
( 1 0 . 1 1 )
$$

where ß = (a, b)T was adopted for the mixing proportions $\pi_1$(æ) and T2(æ), corresponding to reoperation and death without reoperation, respectively; as a function of the single covariate $ , the age of the patient at the time of the initialreplacement operation. being

With this mixture approach, Nget al. (1999) found that the specification oftypically used parametric forms for the component-survival functions in the mixture model (10.1) gave unsatisfactory results. For example, they initially considered parametric forms for the component-survival functions specified by (10.10). The assumption of the Gompertz model for death in the absence ofthe competing risk of reoperation (that is, for the latent survival function for death) is often used in the literature to model death in the absence of competing risks. However, it does not follow that this model will be applicable for death without a reoperation. Indeed, Ng et al. (1999) found that the Gompertz model for the baseline hazard function and proportional hazards for the effect of age was inadequate for the second component corresponding to death without a reoperation.

<a id="sec-10-3-3"></a>

# 10.3.3 Constrained Mixture Models

Because a xenograft prosthesis will always need replacement if the patient were to live for a sufficiently enough time after the initial operation, the two mixture model components corresponding to reoperation and death without a reoperation need to be interrelated in their parametric specification. Ng et al. (1999) handled this situation by constraining the components so that the component-hazard function for death without a reoperation was always greater than the hazard for reoperation: They effected this by setting the component-survival function corresponding to death without a reoperation to be equal to the component-survival function for reoperation multiplied by some additional survival function. More specifically; set long they

$$
( 1 0 . 1 2 )
$$

where Sa(t; \*) denotes some additional survival function.

From (10.12), it follows that

$$
h _ { 2 } ( t ; x ) \ = \ h _ { a } ( t ; x ) + h _ { 1 } ( t ; x )
$$

$$
\forall t , & & ( 1 0 . 1 4 )
$$

as desired for this problem. The model (10.12) for the component-survival function S2(t; æ) for death without a reoperation has an easy to understand interpretation. Given that a patient willdie without a reoperation, his/her conditional hazard function can be viewed as being equal to the conditional hazard function for reoperation plus

that is, assumed a proportional hazards function with the Gompertz distribution used to model the baseline hazard function. Consequently; the component-hazard function for death without a reoperation no longer had the proportional hazards form: they

However; this assumption of the Gompertz model for both h1(t; 2) and ha(t; $) implies that their sum h2(t; $), corresponding to death without reoperation; must also be an increasing function: However, such a monotone hazard function may not be appropriate in some situations; for example in survival data where the presence of short-term deaths is evident. The occurrence of death very soon after the treatments results in a nonmonotone U-shaped hazard function with three phases (a decreasing hazard, followed by a constant hazard, and finally by an increasing hazard); see; for example, Blackstone et al. (1986)and McGiffin et al. (1993). This led Nget al. (2000) to

$$
h _ { a } ( t ; x ) = \lambda _ { a } \kappa _ { a } t ^ { ( \kappa _ { a } - 1 ) } \exp ( \gamma _ { a } x ) ,
$$

where Xa, Ka > 0 Ka > 1 and is a U-shaped function if Ka

We shall refer to this constrained mixture model with one component based on the Gompertz distribution and the other on Weibull times a Gompertz, as the Weibull*Gompertz-Gompertz mixture model. The FORTRAN program of McLachlan et al. (1997) for the fitting of mixtures of Gompertz components with proportional hazards was modified to handle the constrained form (10.14). In Figure 10.1 we have plotted the estimate of the probability T1($z_j$ ß) that a patient aged z years at the initial replacement operation will undergo a reoperation; as obtained by this constrained mixture model, along with the corresponding estimate of T1(z) obtained by the latent failure-time approach under the assumption ofindependent competing risks. The909 confidence limits are given by the dotted curves. were obtained by applying the nonparametric bootstrap approach with the resampling scheme slightly modified for the competing-risks problem. Let N; be the number of cause i failures (i = 1, 2) and let N3 be the number of censored observations. The bootstrapdata were obtained by sampling separately from each of the three sets, corresponding to failure from cause i (i = 1,2) and to the censored observations, with the sizes of these bootstrap subsamples taken equal to N1, Nz, and N3, respectively; A similar resampling scheme has been used by Golbeck (1992) in bootstrapping life-table estimators. In this application; K = 100 bootstrap samples were used. They It can be seen from Figure 10.1 that beyond 30 years, the Weibull*Gompertz Gompertz mixture model gives an increasingly lower estimate of the probability of reoperation with increasing age of the patient. The difference is due to how the censored observations are 'treated" during the estimation process. With this mixture model, elderly patients with censored observations are regarded as having a higher chance of dying before a reoperation is needed than with the latent failure-time approach.

Fig. 10.1 Estimated probability of reoperation at a given age of patient; Weibull\*Gompertz Gompertz mixture model (solid curve); latent failure-time approach (dashed curve); 909 confidence limits (dotted curves) From Ng et al. (2000)

![image 30](mclachlan2000_images/imageFile30.png)

<a id="sec-10-3-4"></a>

# 10.3.4 Conditional Probability of a Reoperation

Up to now we have focused on the probability that a patient aged z years at the time of the initial replacement operation of the aortic valve by a xenograft prosthesis will have to undergo a reoperation: As apatient can avoid a reoperation by dying first; it is relevant to consider the conditional probability of areoperation within a specified time t after the initial operation given that the patient does not die without a reoperation during this period. We shall denote this conditional probability by CPR(t; %) In Figure 10.2 we have plotted the estimate of this conditional probability; as obtained by Ng et al. (2000), versus with the corresponding plots given by the latent failure-time approach applied under the assumption of independent competing risks. Although in Figure 10.2 we have = 70 years at the time of the initial replacement operation; this estimate for because for large values of t, the proportional hazards model (10.10) for the effect of provides only a crude approximation to reality for large z along aged large

{07

Fig. 10.2 Conditional probability of reoperation (xenograft valve) for specified age of patient: Weibull*Gompertz-Gompertz mixture model (solid curves); latent failure-time approach (dashed curves) With each model, * =30 (top curve), \* = 50 years (middle curve), From Ng et (2000). years al.

<a id="sec-10-3-5"></a>

# 10.3.5 Advantages of Mixture Model-Based Approach

An attractive feature of the mixture model approach is that it does not have to make assumptions about the independence of the competing risks; as with the latent failure time approach. As pointed by Lagakos (1979), assumption of independence of risks seems unreasonable and questionable in most real-life situations. But any model that allows for dependence is restricted to have a simple parametric form for the joint by Nádas (1971). Furthermore, the dependence of the competing risks is nontestable. Cox (1959; 1962, p. 112) and Tsiatis (1975) showed that for any joint distribution for the latent-failure times, there exists ajoint distribution with independent latent-failure times that gives the same distribution of the observable failure times. Thus from the observable failure times and causes of failure alone; it is impossible to distinguish between an independent competing-risks model and an infinitude of dependent models. The identifiability of the latent failure-timc approach with covariates has been considered by Heckman and Honoré (1989) and Slud (1992). Klein and Moeschberger (1987) determined the effects of an incorrect assumption of independence and concluded that departures from independence were of great consequence on the estimates of the overall and marginal survival functions. In contrast to the latent failure-time approach; the postulatedcomponcnt-survival functions and mixing proportions of the mixture model are able to be estimated directly from the observable data.

<a id="sec-10-4"></a>

# 10.4 LONG-TERM SURVIVOR MODEL

<a id="sec-10-4-1"></a>

# 10.4.1 Definition

In some situations where the aim is to estimate the survival distributionfor a particular type of failure, a certain fraction of the population; say may never experience this type of failure. It is characterized by the overall survival curve leveled at a nonzero probability In some applications, the surviving fractions are said to be "cured" (Boag, 1949; Berkson and clinical trial for assessing the efficacy of a treatment therapy for breast cancer; patient may be considered cured if she lives an apparently normal life span and dies of causes other than breast cancer and shows no evidence of the latter disease at death. This is the definition of \*personal cure" in Haybittle (1983); see also Brinkley and Haybittle (1975). In a criminological study; there is the possibility that some offenders will not reoffend after release (Copas and Heydari, 1997). The estimation of T1 is of interest in many of these applications. being Gage,

Itis assumed that an entity or individual has probability T2 = 1 = T1 of failing from the cause of interest and probability T1 of never experiencing failure from this cause. In the usual framework for this problem, it is assumed further that the entity cannot fail from any other cause during the course of the study (that is, during follow-up). We let T be the random variable denoting the time to failure, where T = 0 denotes the event that the individual will not fail from the cause of interest. The probability of this latter event is T1.

The unconditional survival function of T can then be expressed as

$$
S ( t ) = \pi _ { 1 } + \pi _ { 2 } \, S _ { 2 } ( t ) ,
$$

where S2(t) denotes the conditional survival function for failure from the cause of interest. The mixture model (10.16) with the first component having mass one at T = 0 can be regarded as a nonstandard mixture model, as discussed in a general context in Chapter 5. Nonstandardmixture models are used in a variety of 'applications in survival analysis; see, for example, Longini and Halloran (1996) for aclass of models with mass at the origin. frailty point In the typical situation in which the LTS mixture model is applied, the observed data are of the form (t;, for the jth = 2 implies that the jth individual was observed to fail from the cause of interest at time t; during the follow =0 implies that the failure time was censored at time tj. That is, the jth individual had not experienced failure by time t; In this context, the model (10.16) can be fitted by maximum likelihood after the specification of a parametric model S2(t; 02) for S2(t) . An individual who fails from the cause of interest at time ô;)T entity, The model (10.16) is sometimes referred to as the long-term survival (LTS) mixture model for the obvious reason that individuals who will never fail due to the cause of interest can be viewed as being long-term survivors of the cause; see Langlands et al. (1979), Farewell (1982), and Greenhouse and Wolfe (1984). The recent monograph by Maller and Zhou (1996) provides a wide range of applications of the LTS mixture model. Here we have not taken S2(t) nor the T; to depend on covariates, but this situation can be handled as in Section 10.2.

$$
\pi _ { 2 } \, f _ { 2 } ( t _ { j } ; \theta _ { 2 } ) ,
$$

where f2(t; 02) is the density of T corresponding to S2(t; 02) An individual who has been followed to time tj without failure contributes a likelihood factor

$$
\pi _ { 1 } + \pi _ { 2 } \, S _ { 2 } ( t _ { j } ; \theta _ { 2 } ) ,
$$

which is the probability that an individual never experiences failure.

The log

$$
& \log L ( \Psi ) = \sum _ { j = 1 } ^ { n } [ I _ { [ 2 ] } ( \delta _ { j } ) \log \{ \pi _ { 2 } \, f _ { 2 } ( t _ { j } ; \theta _ { 2 } ) \} + I _ { [ 0 ] } ( \delta _ { j } ) \log \{ \pi _ { 1 } + \pi _ { 2 } \, S _ { 2 } ( t _ { j } ; \theta _ { 2 } ) \} ] . \\ & \quad I t \, c a n \, b e \, s e e n \, t h a r \, i n s \, \text {model is simpler to fit than the two-component mixture}
$$

It can be seen that this model is simpler to fit than the two-component mixture model (10.1) in which the survival function for time to failure from a cause or causes other than the cause of interest has to be included in the estimation process .

<a id="sec-10-4-2"></a>

# 10.4.2 Modified Long-Term Survivor Model

We now consider a generalization of the LTS problem where during the follow-up period an individual may be observed to fail from a cause other than the cause of interest. For example, in a study of breast cancer, some individuals may die from another cause and without any symptoms of breast cancer. The LTS mixture model is not directly applicable to such problems. An obvious way to handle this situation is to define the failure time T to be the time to either failure from the cause of interest or failure from a competing cause. A two-component mixture model with components representing the competing causes and the cause of interest; respectively; can be

<a id="sec-10-4-3"></a>

# 10.4.3 Partial ML Approach for Modified Long-Term Survival Model

The competing-risks model (10.1) requires the specification of a suitable parametric form for the conditional survival function S1(t; 01) for time to failure from causes other than the cause of interest. In situations where only a few failures from competing causes OCCUr during the observational period, there may be insufficient datato estimate 01. Moreover, it can be seen from (10.9) that even if we were to ignore those failures from competing causes, we would still have to model S1(t; 01) as it appears in considered how the LTS mixture model can still be used to handle the possibility ofrisk of failure from a competing cause during the observational period. Their proposed modification, which is based on partial ML approach; circumvents the need to model failure from the competing risks, but still provides aconsistent estimator of the conditional survival function for the cause of intcrest and for the proportion who fail from a competing cause. With this ML approach; we do not utilize the information that there are failures from competing causes observed during the followup period. Rather we form their likelihood contributions based on only a subset of the information, namely that the failure of interest did not occur for this group of patients (those with &; 1) during the follow-up period. Hence we are effcctively treating a patient who failed due to a competing cause as having an observation time censored at the end of the follow-up period. That is, if a failure from a competing cause is recorded at time tj, then this event contributes the term fully partial

$$
\pi _ { 1 } + 3
$$

where $t_i = t_i + u_j$, and $u_j$ is the time from the occurrence of failure from a competing cause to the end of the follow-up period.

Because all the available information has not been used in forming the likelihood, Ng and McLachlan (1998) referred to this approach as the partial ML approach, and referred to the approach based on the competing-risks model (I0.1) as the full ML approach. The simplicity of the partial ML approach is somewhat offset by a loss in efficiency of the estimates so obtained. Ng and McLachlan (1998) performed some simulations to compare the efficiency of the partial ML approach relative to the full ML approach for survival in the presence of competing risks. They concluded that the partial ML approach is reasonably efficient; provided that the risk of failure from a competing cause is low compared with the risk of failure from the cause of interest. Practically; for clinical studies, this situation is justified because the risk of failure from the disease under study is usually much higher than that of failure due to other reasons for a cured patient. In these circumstances; the partial ML approach has particularly high relative efficiency if there are limited failures from competing causes; for example, when the follow-up is only of medium duration and the sample size is not In these situations; it is not possible with the full ML approach to estimate reliably theconditional survival function and hence the probability of failure from competing causes. they period large.

<a id="sec-10-4-4"></a>

# 10.4.4 Interpretation of Cure Rate in Presence of Competing Risks

With model (10.16), the probability T2 1 =T1 represents the chance of failing from the cause of interest in the presence of other risks. Equivalently; T1 is the probability that an individual will not fail from the cause of interest, and thus will fail from one of the competing causes. In some applications such as with the estimation of the cure rate of breast cancer; patients who die shortly after the treatment; apparently from a competing cause, might not be regarded as cured even if have no symptoms of the disease at the time of their death. For with early deaths, it is not clear whether would have suffered a relapse from the disease under study if had continued to live for a longer time. Also; some of the early deaths might even be due to the hazards of the treatment; such as postoperative complications. In these applications; T1 can be adjusted by, for example, excluding those patients with death times smaller than To as cured. In so this, we are taking a patient to be cured if helshe lives an apparently normal life span and dies from a competing cause at time at least To after treatment and without any symptoms of the disease. That is, the cure rate is taken to be they they being doing

$$
\pi _ { 1 } \, S _ { 1 } ( T _ { 0 } ) .
$$

With the partial ML approach, the conditional survival function S1(t) is not estimated. But if the smallest censored time is greater than To, then we are still able to estimate S1(To) by

$$
1 - \frac { n _ { T _ { 0 } } } { n \pi _ { 1 } } ,
$$

where n is the total number of patients and is the number of patients who died from competing cause before time To. was reported in Burch (1976, p. 387) that there is a probability of 0.73 for a recurrence within 5 A value of To could be used if a tighter interpretation of normal life span is assumed. Obviously; To should be chosen before the study so as not to induce biases . nTo larger~ years

<a id="sec-10-4-5"></a>

# 10.4.5 Example 9.2: Breast Cancer Data

Ng and McLachlan (1998) analyzed the breast cancer data of Boag (1949) t0 illustrate the application of the full ML and the proposed partial ML approaches in the estimation of cure rate. The data were recorded for 12/ patients having treatment for breast cancer. For their analysis, the patients were classified as follows:

1 . Those who responded favorably to treatment and were free from signs or symptoms of breast cancer at their death from other causes at time t ('; = 1);

those who died due to breast cancer at time t; ('; = 2);

3 . those who were still alive at the end of follow-up period

The number (proportion) in each category was 18(15%), 78(649), and 25(219), respectively. These data are given in Table 10.1.

Table 10.1 Breast Cancer Data

| Survival Times (in months of Those Who Died |      |      |      |     |     |      |     | Length of Time (in months) Survivors Were in the Study |     |
| ------------------------------------------- | ---- | ---- | ---- | --- | --- | ---- | --- | ------------------------------------------------------ | --- |
| 0.3                                         | 12.2 | 17.5 | 28.2 | 41  | 78  | 0.3  | 110 | 111                                                    | 136 |
| 5.0                                         | 12.3 | 17.9 | 29.1 | 42  | 80  |      | 111 | 112                                                    | 141 |
| 5.6                                         | 13.5 | 19.8 | 30.0 |     | 84  | 7.4  | 112 | 113                                                    | 143 |
| 6.2                                         | 14.4 | 20.4 | 31   | 46  | 87  | 15.5 | 132 | 114                                                    | 167 |
| 6.3                                         | 14.4 | 20.9 | 3]   | 48  | 89  | 23.4 | 162 | 114                                                    | 177 |
| 6.6                                         | 14.8 | 21.0 | 32   | 48  | 90  | 46   |     | 117                                                    | 179 |
| 6.8                                         | 15.7 | 21.0 | 35   | 51  | 97  | 46   |     | 121                                                    | 189 |
| 7.5                                         | 16.2 |      | 35   | 51  | 98  | 51   |     | 123                                                    | 201 |
| 8.4                                         | 16.3 | 23.0 | 38   | 52  | 100 | 65   |     | 129                                                    | 203 |
| 8.4                                         | 16.5 | 23.6 | 39   | 54  | 114 | 68   |     | 131                                                    | 203 |
| 10.3                                        | 16.8 | 24.0 | 40   | 56  | 126 | 83   |     | 133                                                    | 213 |
| 11.0                                        | 17.2 | 24.0 | 40   | 60  | 131 | 88   |     | 134                                                    | 228 |
| 11.8                                        | 17.3 | 27.9 | 41   | 78  | 174 | 96   |     | 134                                                    |     |

Source: (1949) Boag

For the partial ML approach, those patients with 8; 1 are treated as censored at the end of follow-up period. This information, which would be usually known in practice, was not available to Ng and McLachlan (1998). Hence randomly chose one of the censored times to be the length of the study for each individual whose death was not due to breast cancer. they

For the full ML approach, adopted the Gompertz model they

$$
S _ { 1 } ( t ; \theta _ { 1 } ) = \exp [ - \exp ( \lambda _ { 1 } ) \{ \exp ( \kappa _ { 1 } t ) - 1 \} / \kappa _ { 1 } ] ,
$$

for the conditional survival function for death from causes other than breast cancer the exponential model and

$$
S _ { 2 } ( t ; \theta _ { 1 } ) = \exp ( - \lambda _ { 2 } )
$$

for the conditional survival function for death from breast cancer. The results are given in Table 10.2. Also included there are the cure rates adjusted with To = 4 years (nTo = 7), To = 5 years (nT = 8), and To = 6 years (nTo = 10).

From Table 10.2, it can be observed that the partial ML approach gives estimates comparable withthe fullML approach. The relatively goodperformance of the partial ML approach here can be explained by the fact there is a relatively low risk of death

Table 10.2 Estimates (Estimated Asymptotic Variances) Obtained by the Full and Partial ML Approaches

|            |         |               |               |                   | Cure Rate     |               |         |
| ---------- | ------- | ------------- | ------------- | ----------------- | ------------- | ------------- | ------- |
| Method     | Â1      | k1            |               | Â1                |               |               | T = 6   |
| Full ML    | (0.168) | ~0.002 (2E-5) | 0.0225 (IE-5) | 0.32918 (0.00215) | 0.271 (0.002) | 0.263 (0.002) | (0.002) |
| Partial ML |         |               | 0.0219 (IE-5) | 0.32194 (0.00230) | 0.264 (0.002) | 0.256 (0.002) | (0.002) |

Source: Adapted from Ng and McLachlan (1998).

from other causes compared to death from breast cancer and the sample size is small. The estimates of the cure rate are comparable to those (0.26 and 0.27, respectively) obtained by Boag (1949) and Berkson and Gage (1952) different approaches to analyze the breast cancer data. using

The conditional survival function for death from breast cancer, S2(t; ô2), is plotted in Figure 10.3 for the partial and full ML approaches, along with a nonparametric estimate as proposed by Taylor (1995). It can be seen that there is close agreement between the three estimates of the conditional survival function for death due to breast cancer.

function

survival

60

120

180

240

(months)

The conditional survival function for death due to competing risks: full ML approach partial ML approach nonparametric approach . ~ From Ng and McLachlan (1998).

<a id="sec-10-5"></a>

# 10.5 ANALYSIS OF MASKED SYSTEM-LIFE DATA

<a id="sec-10-5-1"></a>

# 10.5.1 Masked Cause of Failure

We conclude this chapter by considering a problem in reliability analysis where mix ture models form the basis for the estimation of the life of electronic parts in series systems as used, for example; in the telecommunications industry It illustrates the wide use of mixture models in the statistical analysis of reliability data. This problem has been considered by Albert and Baxter (1995), among others .

Suppose there is a series system which functions if and only if all its constituents are functioning: The system is assumed to comprise g components or parts. The life of part i is a random variable with the survival function S(t; 0;) and hazard function 9), where the functional form of S is known and @; is a vector of unknown parameters to be estimated. We let € denote the elements of 01, 8 known a priori to be distinct. Here the vector $ of all unknown parameters is cqual to € in the absence of any mixing proportions to be estimated.

ule containing the failed part is replaced. That is, only the identity of the module containing the failed part is known. This is known as masking (Usher and Guess, 1989; Guess, Usher, and Hodgson, 1990; Usher, 1996). The observed data yconsists of n independent observations on the system so that y = where Uj = (tj, M;)T and where t; is the observed life length of the jth system and M; is the set of labels defining the parts in the module that failed in the jth (j = 1, n) . system

The log likelihood for 4 that can be formed on the basis of the observed data y is given by

$$
\log L ( \Psi ) & \ = \ \sum _ { j = 1 } ^ { n } \log [ \{ \sum _ { i \in M _ { j } } h ( t _ { j } ; \theta _ { i } ) \} \{ \prod _ { i = 1 } ^ { g } S ( t _ { j } ; \theta _ { i } ) \} ] \\ & = \ \sum _ { j = 1 } ^ { n } \{ \log \sum _ { i \in M _ { j } } h ( t _ { j } ; \theta _ { i } ) + \sum _ { i = 1 } ^ { g } \log S ( t _ { j } ; \theta _ { i } ) \} .
$$

$$
\ = \ \sum _ { j = 1 } ^ { \infty } \{ \log \sum _ { i \in M _ { j } } h ( t _ { j } ; \theta _ { i } ) + \sum _ { i = 1 } ^ { J } \log S ( t _ { j } ; \theta _ { i } ) \} .
$$

<a id="sec-10-5-2"></a>

# 10.5.2 Application of EM Algorithm

To apply the EM algorithm to this problem; we define the complete-data vector Uc to be

$$
y _ { c } = 0
$$

where The complete-data log

$$
z = ( z _ { 1 } ^ { T } , \dots , z _ { n } ^ { T } ) ^ { T }
$$

and = ($z_j$); = 1 if part i were the part that failed in the jth system; and is zero otherwise. Zij

$$
= \sum _ { i = 1 } ^ { y } \sum _ { j = 1 } ^ { n } z _ { i j } \{ \log h ( t _ { j } ; \theta _ { i } ) + \log S ( t _ { j } ; \theta _ { i } ) \} .
$$

$$
\log L _ { c } ( \Psi ) = \sum _ { i = 1 } ^ { j } \sum _ { j = 1 } ^ { n } z _ { i j }
$$

Concerning the E-step on the (k + 1)th iteration of the EM algorithm; we have that the current conditional expectation of the complete-data log likelihood is

$$
Q ( \Psi ; \Psi ^ { ( k ) } ) \ & = \ E _ { \Psi ^ { ( k ) } } \{ \log L _ { c } ( \Psi ) \ | \ y \} \\ & = \ \sum _ { i = 1 } ^ { g } \sum _ { j = 1 } ^ { n } \tau _ { i } ( t _ { j } ; \Psi ^ { ( k ) } ) \ \{ \log h ( t _ { j } ; \theta _ { i } ) + \log S ( t _ { j } ; \theta _ { i } ) \} \, ,
$$

$$
\overline { i = 1 } \, \overline { j = 1 }
$$

where

$$
\tau _ { i } ( t _ { j } ; \Psi ^ { ( k ) } ) \ = \ E _ { \Psi ^ { ( k ) } } \{ Z _ { i j } \ | \ y _ { j } \}
$$

g;j = 1, n. It follows that

$$
y _ { j } \} = \left \{ \begin{array} { l l } { h ( t _ { j } ; \theta _ { i } ) / \sum _ { h \in M _ { j } } h ( t _ { j } ; \theta _ { h } ) } & { i f i \in M _ { j } , } \\ { 0 } & { o t h e r w i s e . } \end{array} ( 1 0 . 2 3 )
$$

<a id="sec-10-5-3"></a>

# 10.5.3 Exponential Components

an illustration; we consider the special case of an exponential distribution for the parts, As

$$
f ( $y_j$ \alpha _ { i } ) = \alpha _ { i } \exp ( - \alpha _ { i } t _ { j } ) I _ { ( 0 , \infty ) } ( t _ { j } ) ,
$$

$$
( k ) = \sum _ { i = 1 } ^ { s } \sum _ { j = 1 } ^ { n } \tau _ { i } ( t _ { j } ; \Psi ^ { ( k ) } ) \{ \log \alpha _ { i } - \alpha _ { i } t _ { j } \} .
$$

On differentiation of the right-hand side of (10.24) with respect to œi, we have that

$$
( 1 0 . 2 4 )
$$

where

$$
\alpha _ { i } ^ { ( k + 1 ) } = \{ \sum _ { j = 1 } ^ { n } t _ { j } / \sum _ { j = 1 } ^ { n } \tau _ { i } ( t _ { j } ; \varPsi ^ { ( k ) } ) \} ^ { - 1 } \quad ( i = 1 , \dots , g ) ,
$$

$$
0 ) = \left \{ \begin{array} { c c } { \alpha } \\ { 0 } \end{array} \right \}
$$

$$
\tau _ { i } ( t _ { j } ; \Psi ^ { ( k ) } ) = \begin{cases} & \alpha _ { i } ^ { ( k ) } / \sum _ { h \in M _ { j } } \alpha _ { h } ^ { ( k ) } & \text {if } i \in M _ { j } , \\ & 0 & \text {otherwise.} \end{cases}
$$

<a id="sec-10-5-4"></a>

# 10.5.4 Weibull Components

Albert and Baxter (1995) also considered the case where the density of the life of

each part is Weibull with survival function

$$
S ( t ; \theta _ { i } ) = \exp \{ - ( \alpha _ { i } t ) ^ { \kappa _ { i } } \} I _ { ( 0 , \infty ) } ( t ) ,
$$

$$
( i = 1 , \dots , g ) .
$$

However, the solution to the M-step does not exist in closed form. On differentia the equations

and

$$
+ 1 ) = \left \{ \sum _ { j = 1 } ^ { j } t _ { j } ^ { \kappa _ { i } } / \sum _ { j = 1 } ^ { j } \tau _ { i } ( t _ { j } ; \Psi ^ { ( k ) } ) \right \}
$$

$$
\overline { j = 1 }
$$

$$
- ( \alpha _ { i } t _ { j } ) ^ { \kappa _ { i } } \log ( \alpha _ { i } t _ { j } ) ] = 0
$$

for i = 1, 9

These equations do not admit a closed-form solution. But suggest that the solution to the M-step on the (k + 1)th iteration of the EM algorithm be replaced by two computationally simple CM steps; thus using an ECM algorithm. they

We partition 4 as

$$
\Psi = ( \Psi _ { 1 } ^ { T } , \Psi _ { 2 } ^ { T } ) ^ { T } ,
$$

where

$$
\Psi _ { 1 } = ( \alpha _ { 1 } , \dots , \alpha _ { g } ) ^ { T }
$$

is the vector of Weibull scale parameters and

$$
\Psi _ { 2 } = ( \kappa _ { 1 } , \dots
$$

is the vector of Weibull shape parameters:

With the first CM-step; wechoose [{\*+1) to be the value of €1 that maximizes the Q-function with V2 fixed at

$$
Q ( \Psi _ { 1 } , \Psi _ { 2 } ^ { ( k ) } ; \Psi ^ { ( k ) } )
$$

with respect to 41. We then choose

This leads to given by (10.27) where k; is fixed at is then given as a root of (10.28) with a; fixed at being

Albert and Baxter (1995) suggested similar approach to the computation of which called pseudo-alternating EM (PAEM) algorithm. With this approach, %{+1) is chosen to maximize the actual (incomplete-data) likelihood, log L (v), and not the Q-function, subject to € = This corresponds to the ECME (expectation-conditional maximization either) algorithm of Liu and Rubin (1994). The ECM and ECME algorithms preserve the appcaling convergence properties of the EM algorithm, such as its monotone convergence. The reader is referred to McLachlan and Krishnan (1997) for a detailed account of the ECM and ECME algorithms. they log using
