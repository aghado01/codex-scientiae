--- ENRICHED TEXT OUTPUT ---

[Page 1]

Open Access Theses & Dissertations

2015-01-01

Luis Angel Mora University of Texas at El Paso, lusmora4@gmail.com

Follow this and additional works at: https://digitalcommons.utep.edu/open_etd

Part of the Statistics and Probability Commons

Mora, Luis Angel, "Bayesian Adaptive Penalized Splines In Nonparametric Regression And In Spectral Time Series Analysis" (2015). Open Access Theses & Dissertations.1104.

https://digitalcommons.utep.edu/open_etd/1104

This is brought to you for free and open access by DigitalCommons@UTEP. It has been accepted for inclusion in Open Access Theses & Dissertations by an authorized administrator of DigitalCommons@UTEP. For more information, please contact lweber@utep.edu .


[Page 2]

Department of Mathematical Science

APPROVED:

Ori Rosen, Chair, Ph.D.

Joan Staniswalis, Ph.D.

Vanessa Lougheed, Ph.D.


[Page 3]

c Copyright


Luis Angel Mora

2015


[Page 5]

BAYESIAN ADAPTIVE PENALIZED SPLINES IN NONPARAMETRIC REGRESSION AND IN SPECTRAL TIME SERIES ANALYSIS


THESIS Presented to the Faculty of the Graduate School of The University of Texas at El Paso in Partial Fulﬁllment of the Requirements for the Degree of

Department of Mathematical Science THE UNIVERSITY OF TEXAS AT EL PASO August 2015


[Page 6]

First and foremost, I would like to thank God for giving me the wisdom and courage in my life.

I want to thank deeply my advisor, Dr. Ori Rosen for taking me under his wing and giving me the opportunity to work along his side. It is a tremendous honor and privilege to be counted amongst his students. He was patient, supportive, but above all, he trusted my abilities even when I doubted in them. His belief in me and great sense of humor enriched my thesis experience, not only intellectually, but emotionally as well.

I want to also thank my committee members, Dr. Joan Staniswalis of the Department of Mathematical Sciences and Dr. Vanessa Lougheed of the Department Biological Sciences, both at The University of Texas at El Paso. Their presence on my committee was comforting and their support was invaluable.

Additionally, I want to thank the professors of statistics of the Department of Mathematical Sciences for all they do for the students: Dr. Panagais Moschopoulos, Dr. Amy Wagler, Dr. Naijun Sha, and Dr. Xiogang Su, all of whom I consider to be great role models. They are truly amazing individuals with exceptional abilities.


[Page 7]

As a special note, I would like to extend my gratitude to the following individuals:

She always provided the nurturing and support that we all sometimes need. I did not have the opportunity to be a student in one of her classes, however, that did not stop me from discovering an even greater passion for statistics thanks to her. Moreover, I thank her for pushing me to my limits.

He was my mentor and didn’t think twice being honest and blunt. I admired that of him, even though I think he never realized it. I learned from him the importance of being calm, but not hesitant in executing tasks. I thank him for sharing those values and his wealth of knowledge with me.

I want to thank my family for all their support and love. In the darkest times they gave me the strength and motivation to keep placing one foot in front of the other. They are my backbone and I could have not achieved this without them.


[Page 8]

A Bayesian approach to nonparametric regression using Penalized splines (P-splines) is presented. The approach uses the linear mixed model formulation of P-spines. The usual model assumes a single value for the smoothing parameter controlling the amount of smoothing of the ﬁtted function. The main focus of the thesis is on spatially adaptive smoothing where the smoothing parameter is a function of the covariate so that diﬀerent amounts of smoothing are applied in diﬀerent regions of the covariate. An application to spectral time series analysis will be demonstrated. Markov chain Monte Carlo methods are used to make inference based on the posterior distribution.


[Page 9]

Page

......................... .

...


Abstract................................ .

.

...

vii

Table of Contents............................

.

... .

viii

Chapter


Introduction........

.............


1.1.. .

.............


1.2.... .

.............



Nonparametric Regression.. .

......... .


2.1..

.............


2.2 .

.............


2.3 .

.............


2.4 .

Bayesian Nonparametric Regression....


.............

.............


2.6..

.............


2.7.... .

.............



Spatially Adaptive Smoothing .

......... .


3.1..

.............


3.2 .

Bayesian Adpative Penalized Splines.. .


3.3........

........... .


3.4 .

.............


3.5..

.............


3.6..

.............



Spatially Adaptive Smoothing for Spectral Analysis


4.1 Spectral Analysis..

.............



[Page 10]

4.1.1 Stationarity...... 4.1.2 Periodogram...... 4.1.3 The Spectral Density .

28 28 30

4.2

........... .


4.3

........... .


4.4

........... .


4.5

........... .



Application..........

...


5.1

Southern Oscillation Index (SOI)


5.2

........... .


5.3

........... .


Appendix


Derivation of Sampling Schemes

. .


A.1

BPS Sampling Scheme....


A.2

BAPS Sampling Scheme.. .


A.3

Whittle Sampling Scheme..



Code................ .


B.1

Bayesian Penalized Splines Code


B.2

........... .


B.3

BAPS Code (Whittle estimate)


B.3.1 Non-Adaptive Whittle


B.3.2 Adaptive Whittle.. .


Curriculum Vitae .



[Page 11]

This chapter is devoted to a brief introduction to the methodology of nonparametric regression and time series. The idea is to estimate an unknown function via a ﬁnite number of basis functions. The estimation is done by using Penalized Splines (P-splines). The thesis ﬁrst describes the methodology of nonparametric regression. Secondly, in Chapter 2 it will be shown that P-splines have a Linear Mixed Model (LMM) representation which can naturally be handled using a Bayesian approach. Thirdly, Chapter 3 explores spatially adaptive P-splines. These models are useful when the degree of smoothness of the underlying function varies with the covariate. Lastly, we employ spatially adaptive penalized splines in spectral estimation in Chapter 4, followed by an application to a real data set in Chapter 5. Simulations are done for each method. Markov chain Monte Carlo (MCMC) methods are used throughout the study.

The use of P-splines was popularized by Eilers and Marx (1996). The methodology relies on a relatively small number of basis functions. Although, there is a wide variety of basis functions available, in what follows, we use truncated polynomials (Ruppert et al., 2003) given by

$$
( x - \kappa ) _ { + } ^ { p } = \begin{cases} \ ( x - \kappa ) ^ { p } & \text {if } x \geq \kappa \\ 0 & \text {otherwise }.\end{cases}
$$

 The function ( x − κ ) p + is constructed using a covariate value x and a knot κ that is located in the range of the covariate space. Any function of the above form is referred to as a


[Page 12]

$$
f ( x ) = \beta _ { 0 } + \beta _ { 1 } x + \dots + \beta _ { p } x ^ { p } + \sum _ { j = 1 } ^ { K _ { \ } } b _ { j } ( x - \kappa _ { j } ) _ { + } ^ { p },
$$

where κ j is the j th knot in a set of knots ( κ 1,...,κ K κ ). The knots used in this thesis are quantiles of the observed covariate values.

As an example, Figure 1.1 displays the function ( x − κ ) p + for p = 1, 2, and 3. The data used is a sequence of 100 numbers in the interval [0, 1] with 10 evenly spaced knots.

(a)

(b)

(c)

0.8

0.8

0.6

0.6

0.6

0.4

0.4

0.4

0.2

0.2

0.2

0.0

0.0

0.0

0.0

0.2

0.4

0.6

0.8

1.0

0.0

0.2

0.4

0.6

0.8

1.0

0.0

0.2

0.4

0.6

0.8

1.0

Figure 1.1: (a) Truncated polynomials of degree 1 (lines); (b) truncated polynomials of degree 2 (quadratic basis); (c) truncated polynomials of degree 3 (cubic basis).


[Page 13]

A time series is a sequence of random variables { Y t } at time points t = 0, ± 1, ± 2, ± 3,..., which can also be viewed as a stochastic process. The expected value of the process at time t is given by

$$
E ( Y _ { t } ) = \mu _ { t }, \ \ t = 0, \pm 1, \pm 2, \pm 3, \dots,
$$

and its autocovariance function, γ t,s, is deﬁned to be

$$
E \left [ ( Y _ { t } - \mu _ { t } ) ( Y _ { s } - \mu _ { s } ) \right ] = C o v ( Y _ { t }, Y _ { s } ) = \gamma _ { t, s },
$$

for all time points t,s = 0, ± 1, ± 2, ± 3,....For a time series, analysis can be done in either the time domain or in the frequency domain. When we speak of time domain analysis, data are analyzed over a period of time. The time unit can be seconds, minutes, hours, etc.

The monthly values of the Southern Oscillation Index (SOI) are an example of a time series, see Figure 1.2. In Chapter 5, more details will be given for this particular time series.

Correlation properties of a time series are usually the basis for the analysis in the time domain. Parametric models that we wish to ﬁt to a time series take this correlation into account. For example, consider the process { Y t }.If we wish to ﬁt the following autoregressive model of order 2

$$
Y _ { t } = \phi _ { 1 } Y _ { t - 1 } + \phi _ { 2 } Y _ { t - 2 } + e _ { t }
$$

then the data y 1,...,y n are used to estimate the parameters φ 1 and φ 2.The error terms e 1,...e n are assumed independent, identically distributed random variables with mean zero and variance σ 2 e .

In frequency domain analysis, a time series is analyzed based on its frequency properties. Consider the cosine wave

$$
Y _ { t } = R \cos ( 2 \pi \omega t + \Phi ) + e _ { t },
$$


[Page 14]



SOI

−20

−40

1880

1900

1920

1940

1960

1980

2000

2020

Year

Figure 1.2: Monthly values of the Southern Osciallation Index (SOI).

where the amplitude of the cosine function (1.3) is R > 0, its frequency is ω, and Φ is its phase. The period of the wave, 1 /ω, is the time it takes to complete a cycle. Model (1.3) is not very convenient in estimation since it is not linear in Φ. Using a Trigonometric identity, model (1.3) can be rewritten as

$$
Y _ { t } = A \cos ( 2 \pi \omega t ) + B \sin ( 2 \pi \omega t ) + e _ { t },
$$

where R = √ A 2 + B 2 and Φ = arctan( − B/A ), and conversely, A = R cos(Φ) and B = − R sin(Φ). For a ﬁxed frequency ω, cos(2 πωt ) and sin(2 πωt ) are used as predictor variables and the A and B are estimated using ordinary least squares. In Chapter 4, we will see how this cosine wave helps motivate spectral analysis.

The thesis is structured as follows: Chapter 2 introduces penalized splines in a Bayesian approach and the core model of the thesis. Chapter 3 covers spatially adaptive nonparamtric regression. In Chapter 4, we discuss spectral time series analysis and deﬁne


[Page 16]

Unlike linear regression, nonparametric regression assumes that f is a smooth function, but not necessarily linear. Thus, the data analyst is not restricted by a pre-speciﬁed shape of the regression function. Consider the regression model

$$
y _ { i } = f ( x _ { i } ) + \epsilon _ { i }, \ \epsilon _ { i } \stackrel { i i d } { \sim } N ( 0, \sigma _ { \epsilon } ^ { 2 } ),
$$

where f ( · ) is an unknown function. The goal of nonparametric regression is to estimate the function f ( · ).

Given a set of data { (( x 1,y 1 ),... ( x n,y n )) }, consider again model (2.1) where

$$
f ( x _ { i } ) = \beta _ { 0 } + \beta _ { 1 } x _ { i } + \dots + \beta _ { p } x _ { i } ^ { p } + \sum _ { j = 1 } ^ { K _ { \kappa } } b _ { j } ( x _ { i } - \kappa _ { j } ) _ { + } ^ { p } .
$$

In (2.2) p > 0 and { κ j } K κ j =1 are ordered ﬁxed knots. Let β = ( β 0,...,β p ) and b = ( b 1,...,b K κ ) be the vectors of unknown parameters. Also, let

$$
X = \begin{bmatrix} 1 & x _ { 1 } & \dots & x _ { 1 } ^ { p } \\ \vdots & \vdots & \ddots & \vdots \\ 1 & x _ { n } & \dots & x _ { n } ^ { p } \end{bmatrix}, \ \ Z = \begin{bmatrix} ( x _ { 1 } - \kappa _ { 1 } ) _ { + } ^ { p } & \dots & ( x _ { 1 } - \kappa _ { K _ { n } } ) _ { + } ^ { p } \\ \vdots & \ddots & \vdots & \vdots \\ ( x _ { n } - \kappa _ { 1 } ) _ { + } ^ { p } & \dots & ( x _ { n } - \kappa _ { K _ { n } } ) _ { + } ^ { p } \end{bmatrix} .
$$

In addition, deﬁne T = [ X,Z ], θ = ( β  , b )  , and let y = ( y 1,...,y n ) .

In ordinary linear regression, the estimators are given by

$$
\hat { \theta } = \arg \min _ { \theta } \left \{ \left \| y - T \theta \right \| ^ { 2 } \right \}
$$


[Page 17]

and the regression ﬁt is ˆ y = T ˆ θ.However, the least-squares method will usually overﬁt the data, resulting in a rough estimate. To facilitate a smoother estimate, consider the minimization

$$
\min _ { \theta } \left \{ \| y - T \theta \| ^ { 2 } + \lambda b ^ { \prime } b \right \} .
$$

In (2.5), the roughness penalty term, λ b b, leads to shrinking b towards zero, thus resulting in a smoother ﬁt compared to the one based on (2.4). The smoothing parameter λ controls the amount of smoothing. The larger λ, the smoother the resulting ﬁt.

Mixed model methodology is used widely in applications such as longitudinal studies. In linear regression, one assumes that f ( x ) depends linearly on x, i.e., f ( x ) = β 0 + β 1 x.The unknown parameters β 0 and β 1 are commonly estimated via the method of least squares. In Section 2.3 we will see that penalized splines can be formulated as linear mixed models. In this section we give some background on LMMs.

Observations are collected into groups or clusters in the mixed model setting. If we take for example longitudinal data, observations are collected repeatedly over time for individual subjects. These groups of data for individual subjects are independent, but usually correlated within-subjects. Two sources of variation are thus present, within groups and between groups. Accounting for within-subject correlation is one challenge in longitudinal data analysis which can be tackled by mixed models.

Consider the following study on pig weights over a period of nine weeks (Ruppert et al., 2003). Figure 2.1 shows the measurements pertaining to 48 pigs. Lines are drawn, connecting the measurements that belong to the same pig. Denote the weight of the i th pig in the j th week by weight ij and let week j = j be the week in which the measurements for a pig are recorded. If we consider the data as cross-sectional (i.e., there is only a single time measurement for a given pig rather than repeated time measurements), then we can


[Page 18]



weight







number of weeks

Figure 2.1: Lines connecting points belonging to the same pig.

$$
\ w e i g h t _ { i j } = \beta _ { 0 } + \beta _ { 1 } w e e k _ { j } + \epsilon _ { i j }, \quad 1 \leq i \leq 4 8, \quad 1 \leq j \leq 9,
$$

where the ij are independent and identically distributed random variables (i.i.d) from N (0,σ 2 ). However, model (2.6) does not account for the within-pig correlation of weight measurements. One solution to this drawback is to add an individual intercept α i, for each pig i so that,

$$
\ w e i g h t _ { i j } = \alpha _ { i } + \beta _ { 1 } w e e k _ { j } + \epsilon _ { i j } .
$$

Adding this extra parameter to each individual pig improves the estimate of the slope β 1, but the practicality of model (2.7) is reduced, due to the large number of parameters. In addition, too much credence is placed on this random sample of pigs. We need to take into account the fact that this sample is only a subset of a broader population. A solution is to add to (2.6) random intercepts, b 1,..., b 48,


[Page 19]

$$
\ w e i g h t _ { i j } = \beta _ { 0 } + b _ { i } + \beta _ { 1 } w e e k _ { j } + \epsilon _ { i j },
$$

where the b i iid ∼ N (0,σ 2 b ) with variance component σ 2 b > 0. The b i ’s are an example of a random eﬀect that helps explain the randomness of other pig samples and helps account for the correlations of weight measurements within individual pigs.

The linear mixed model can be generalized and rewritten in a compact form. This leads to

$$
y = X \beta + Z b + \epsilon .
$$

The expected value and variance-covariance matrix of the random vectors in expression (2.9) are given by

$$
E \begin{bmatrix} b \\ \epsilon \end{bmatrix} = \begin{bmatrix} 0 \\ 0 \end{bmatrix} \quad \text {and} \ \ C o \begin{bmatrix} b \\ \epsilon \end{bmatrix} = \begin{bmatrix} G & 0 \\ 0 & R \end{bmatrix},
$$

respectively. In the pig example, G = σ 2 b I K κ, and R = σ 2   I n where I K κ is a K κ × K κ identity matrix, I n is a n × n identity matrix, and σ 2 b and σ 2   are positive constants.Estimation of the ﬁxed and random eﬀects can be done by making the following distributional assumptions (Robinson, 1991), on ( y | b ) and b,

$$
( y | b ) \sim N ( X \beta + Z b, R ), \ \ b \sim N ( 0, G ) .
$$

The joint density for ( y, b ) is then

$$
p ( y, b ) \ & = \ p ( y | b ) p ( b ) \\ & \quad \infty \ \exp \left \{ - \frac { 1 } { 2 } ( y - T \theta ) ^ { \prime } R ^ { - 1 } ( y - T \theta ) - \frac { 1 } { 2 } b ^ { \prime } G ^ { - 1 } b \right \} .
$$


[Page 20]

One way of deriving the estimators uses Henderson’s justiﬁcation (Henderson, 1950). Maximizing the joint density (2.11) with respect to β and b, is equivalent to minimizing the criterion

$$
( y - T \theta ) ^ { \prime } R ^ { - 1 } ( y - T \theta ) + b ^ { \prime } G ^ { - 1 } b,
$$

which leads to the best linear unbiased predictor (BLUP) of θ = ( β  , b )  .Moreover, we can easily express (2.12) as follows:

$$
( y - T \theta ) ^ { \prime } R ^ { - 1 } ( y - T \theta ) + \theta ^ { \prime } H \theta, \quad H = \begin{bmatrix} 0 & 0 \\ 0 & G ^ { - 1 } \end{bmatrix} .
$$

By diﬀerentiating the the above expression and equating the derivative to zero, we can solve for θ and write its BLUP as

$$
\hat { \theta } = ( T ^ { \prime } R ^ { - 1 } T + H ) ^ { - 1 } T ^ { \prime } R ^ { - 1 } y .
$$

The ﬁtted values are therefore BLUP( y ) = X ˆ β + Z ˆ b = T ˆ θ .

Note that criterion (2.12) is similar to the penalized spline criterion (2.5). Dividing (2.5) by σ 2  , leads to spline criterion as

$$
& = \frac { 1 } { \sigma _ { \epsilon } ^ { 2 } } \| y - T \theta \| ^ { 2 } + \frac { \lambda } { \sigma _ { \epsilon } ^ { 2 } } b ^ { \prime } b \\ & = \frac { 1 } { \sigma _ { \epsilon } ^ { 2 } } ( y - T \theta ) ^ { \prime } ( y - T \theta ) + \frac { \lambda } { \sigma _ { \epsilon } ^ { 2 } } b ^ { \prime } b .
$$

Comparing (2.12) to (2.15), it becomes clear that for the P-splines, R = σ 2 I n and G = σ 2 λ I n ≡ σ 2 b I K κ with λ = σ 2 /σ 2 b.It is evident that the penalized spline criterion for a spline is exactly the BLUP criterion for a mixed model. Thus, P-splines can be written as mixed models with a smoothing parameter λ.In the next section we will see how to perform the estimation in a Bayesian setting.

In this section, a Bayesian approach to penalized splines is examined. The Bayesian philosophy in statistics is based on the practice of treating parameters as random variables. By


[Page 21]

The main characteristics of Bayesian analysis are

In particular, Bayesian inference is based on a set of unknown parameters, say,

$$
\theta = ( \theta _ { 1 }, \dots, \theta _ { N } ) .
$$

Any prior beliefs or characterizations of the parameters can be modeled by a probability density function p ( θ ). Consider now a vector of observed data

$$
\mathcal { X } = ( X _ { 1 }, \dots, X _ { n } )
$$

with a probability distribution that depends on the parameter vector θ.The likelihood L ( X| θ ) represents the relationship between the parameter vector and the observed data and we think of L ( X| θ ) as a function of θ.From Bayes Theorem, the posterior distribution is given by

$$
p ( \theta | \mathcal { X } ) = \frac { \mathcal { L } ( \mathcal { X } | \theta ) p ( \theta ) } { \int \mathcal { L } ( \mathcal { X } | \theta ) p ( \theta ) d \theta } .
$$

Under a squared loss function, the Bayes estimator of θ is the posterior mean E( θ |X ). In most cases, the posterior mean is mathematically intractable. MCMC methods facilitate multidimensional integration by simulating from the posterior distribution

$$
p ( \theta | \mathcal { X } ) \, \infty \, \mathcal { L } ( \mathcal { X } | \theta ) p ( \theta ),
$$

and then computing summary statistics of the distribution.


[Page 22]

In this section, the priors for the the mixed model are described. As before, P-splines can be represented as the mixed model,

$$
y = X \beta + Z b + \epsilon .
$$

Let ( β, b,σ 2 b,σ 2 ) be the vector of the ﬁxed eﬀects, random eﬀects, and variance components. For a fully Bayesian approach, prior distributions are placed on ( β, b,σ 2 b,σ 2 ). The priors are as follows:

$$
\sigma _ { \epsilon } ^ { 2 } \sim I G ( A _ { \epsilon }, B _ { \epsilon } ), \ \ A _ { \epsilon } > 0, \ \ B _ { \epsilon } > 0 .
$$

$$
\sigma _ { b } ^ { 2 } \sim I G ( A _ { b }, B _ { b } ), \ \ A _ { b } > 0, \ \ B _ { b } > 0 .
$$

These prior speciﬁcations for the variance components are sensitive to the selection of the hyperparameters A  ,B  ,A b, and B b.Selecting values for these parameters must be addressed carefully since diﬀerent values may lead to diﬀerent results.

In the context of the mixed model methodology, let θ = ( β  , b ) be the parameter vector containing the ﬁxed and random eﬀects. The posterior distribution for the mixed model is given by

$$
p ( \beta, b, \sigma _ { \epsilon } ^ { 2 }, \sigma _ { b } ^ { 2 } | y ) \subset p ( y | \beta, b, \sigma _ { \epsilon } ^ { 2 } ) p ( \sigma _ { \epsilon } ^ { 2 } ) p ( b | \sigma _ { b } ^ { 2 } ) p ( \sigma _ { b } ^ { 2 } ) p ( \beta ) .
$$


[Page 23]

Gibbs sampling is one of the main MCMC methods. A Gibbs sampling algorithm is implemented by considering the full conditional posterior distributions for the individual parameters. The full conditional posterior distribution for θ is expressed as follows:

$$
p ( \theta | y, \sigma _ { \epsilon } ^ { 2 }, \sigma _ { b } ^ { 2 } ) & \, \infty \exp \left \{ - \frac { 1 } { 2 \sigma _ { \epsilon } ^ { 2 } } \| y - T \theta \| ^ { 2 } - \frac { 1 } { 2 \sigma _ { b } ^ { 2 } } \| b \| ^ { 2 } - \frac { 1 } { 2 \sigma _ { \beta } ^ { 2 } } \| \beta \| ^ { 2 } \right \} \\ & = \exp \left \{ - \frac { 1 } { 2 \sigma _ { \epsilon } ^ { 2 } } \left ( \| y - T \theta \| ^ { 2 } + \frac { \sigma _ { \epsilon } ^ { 2 } } { \sigma _ { b } ^ { 2 } } \| b \| ^ { 2 } \right ) - \frac { 1 } { 2 \sigma _ { \beta } ^ { 2 } } \| \beta \| ^ { 2 } \right \} .
$$

Equation (2.20) can be further expanded by collecting terms and completing the square. The result is a multivariate normal distribution, N ( µ θ, Σ θ ), where

$$
\mu _ { \theta } = \left ( T ^ { \prime } T + \sigma _ { \epsilon } ^ { 2 } D ^ { - 1 } \right ) ^ { - 1 } T ^ { \prime } y, \quad \Sigma _ { \theta } = \sigma _ { \epsilon } ^ { 2 } \left ( T ^ { \prime } T + \sigma _ { \epsilon } ^ { 2 } D ^ { - 1 } \right ) ^ { - 1 },
$$

where D = diag( σ 2 β,...,σ 2 β,σ 2 b,...,σ 2 b ).

The full conditional distributions for the variance components σ 2 and σ 2 b are inverse gamma distributions, i.e.,

$$
( \sigma _ { \epsilon } ^ { 2 } | y, \beta, b ) \sim I G \left ( \frac { n } { 2 } + A _ { \epsilon }, \frac { 1 } { 2 } \| y - T \theta \| ^ { 2 } + B _ { \epsilon } \right )
$$

and

$$
( \sigma _ { b } ^ { 2 } | b ) \sim I G \left ( \frac { K _ { \kappa } } { 2 } + A _ { b }, \frac { 1 } { 2 } | | b | | ^ { 2 } + B _ { b } \right ) .
$$

The Gibbs sampler is used to sample from p ( β,b,σ 2  ,σ 2 b | y ) by sampling from the full conditional distributions presented above. The sampling scheme for the Bayesian approach to P-splines iterates over the following steps:

$$
N \left \{ \left ( T ^ { \prime } T + \sigma _ { \epsilon } ^ { 2 } D ^ { - 1 } \right ) ^ { - 1 } T ^ { \prime } y, \sigma _ { \epsilon } ^ { 2 } \left ( T ^ { \prime } T + \sigma _ { \epsilon } ^ { 2 } D ^ { - 1 } \right ) ^ { - 1 } \right \} .
$$


[Page 24]

A brief application (Ruppert et al., 2003) is presented in this section. The LIDAR data consist of n = 221 observations. The covariate, range, is the distance that light travels before coming back to its source, and the dependent variable is log ratio, which is the logarithm of the ratio of light received from two laser sources. Again, assume

$$
y _ { i } = f ( x _ { i } ) + \epsilon _ { i } .
$$

The above sampling scheme was applied to the LIDAR data with 10,000 iterations, the ﬁrst 2000 of which were used as a burn-in period. Estimates using basis functions of degree p = 1 and 2 are displayed. The number of knots for this application is K κ = 40. Pointwise 95% credible intervals are also shown for each estimate (see Figure 2.2). The credible intervals are calculated by computing the 2.5th percentile and 97.5th percentile of the MCMC iterations of T ˆ θ at each covariate value. From the plot, both estimates provide a good ﬁt for the data.

0.0

−0.2

−0.4

log(ratio)

Linear Fit Quadratic

Quadratic Fit

Intervals (p = 1) 95% Credible Intervals (p = 2)

95% Credible Intervals (p = 2)

−0.6

−0.8

400

450

500

550

600

650

700

range

Figure 2.2: P-spline estimates of degrees p = 1 (solid line) and p = 2 (dashed line) to the LIDAR data along with pointwise 95% credible intervals.


[Page 25]

There is a large literature on spatially adaptive smoothing. Ruppert and Carroll (2000) achieve spatial adaptability by using local smoothing parameters on the diﬀerence penalties of the regression coeﬃcients. They then model the logarithm of the penalties as a linear spline. Denison et al. (1998) proposed a model using piecewise polynomials to estimate a function f ( x ). They ﬁt low order polynomials that are non zero between knots whose locations are selected adaptively using MCMC methods. Their method fared well compared to the wavelet methods of Donoho and Johnstone (1994).

More recently, DiMatteo et al. (2001) proposed adaptive models using free-knot splines. Their method is referred to as Bayesian adaptive regression splines (BARS). It incorporates knots that are located within the range of the data and assumes f ( x ) is a cubic regression spline constructed using cubic B-spline basis functions. The prior placed on the number of knots is Poisson. DiMatteo et al. (2001) show that the mean square error (MSE) of their method is signiﬁcantly smaller compared to the method of Denison et al. (1998).

Baladandayuthapani et al. (2005) model the smoothing parameter as a function of the covariate. The same idea is used by Crainiceanu et al. (2007). A set of knots κ 1,...,κ K is ﬁxed over the range of x, with spline coeﬃcients a i,...,a K  .More speciﬁcally, the smoothing parameter is modeled as a P-spline of degree d constructed using truncated polynomials. Their method was compared to that of Ruppert and Carroll (2000) who computed the average mean square error (AMSE) of over 100 simulations. Even though Crainiceanu et al. (2007)’s method performed slightly better than that of Ruppert and


[Page 26]

$$
f ( x ) = \sqrt { x ( 1 - x ) } \sin \left \{ \frac { 2 \pi ( 1 + 2 ^ { ( 9 - 4 j ) / 5 } ) } { x + 2 ^ { ( 9 - 4 j ) / 5 } } \right \},
$$

where j determines the severity of the oscillations in the function. The AMSE reported for the Doppler function with j = 3 was 0.0011 and 0.0012 for non-spatially adaptive and spatially adaptive smoothing parameters, respectively. Knot selection schemes are also used often for spatially adaptive estimations. For example, Zhou and Shen (2001) presented an algorithm that selects the optimal candidate knots for a regression spline. The algorithm is an improvement over traditional stepwise knot selection schemes by relocating knots closer to optimal knots, searching with more frequency intervals that need more knots, and using local spline regression to reduce computation. Several functions were used for testing the method of Zhou and Shen (2001), in addition to an application to a signal processing data set. Results demonstrated that the knot selection was a good estimate for the signal processing example.

In the frequentist realm, another method involving free-knot splines is that of Miyata and Shen (2003). These authors propose a knot selection scheme where estimation is performed using an evolutionary algorithm to ﬁnd the optimal tuning parameter for the cubic B-spline representation of the model. This method is then compared to other methods in the literature such as that of Denison et al. (1998), DiMatteo et al. (2001) and Zhou and Shen (2001). The method of Miyata and Shen (2003) performs relatively well across all their simulations. However, when testing it method for the “hump” function, h ( x ) = sin( x ) + 2exp( − 30 x 2 ), x ∈ [ − 2, 2], the method manages to smooth the right tail of the function but undersmooths its left tail. In Section 3.6, we will see this function again for the simulation study presented in this chapter using the BAPS model.

Local bandwidth selection methods are also used successfully in spatially adaptive smoothing by Staniswalis (1989). This method estimates the optimal local bandwidth, b L ( x ), by firstly providing a consistent estimator for the MSE of the kernel estimates, and then minimizing this estimator using ˆ b L ( x ). Additionally, asymptotic normality of the estimate of b L ( x ) is proved. This method proved to be superior to the general global bandwidth method also presented in her study. The method involving local bandwidth selection provides adequate smoothing in areas where a global bandwidth undersmooths the simulation data. A hybrid nonparameteric model is additionally presented by Staniswalis and Yandell (1992). They combine properties of cubic smoothing splines and adaptive kernel estimators to achieve spatially adaptive estimates. The data are first smoothed using a local bandwidth kernel estimator, followed by applying a penalized likelihood to compute a global fit to the presmoothed data.


[Page 27]

Following the hybrid methodology, a model combining characteristics of adaptive regression splines and smoothing splines is proposed by Lou and Wahba (1997). This procedure is called hybrid adaptive splines (HAS). It uses a forward stepwise regression procedure to select the basis functions from a set of basis, and then uses the selected basis functions in penalized regression. The method is compared to the wavelet methods of Donoho and Johnstone (1995). Among the seven examples presented in their study, the HAS procedure for spatial adapivity and the SUREShrink method of Donoho and Johnstone (1995) provide good estimates to examples 1-5. For examples 6-7 a non-adaptive method outperformed both the HAS and the SUREShrink methods.

Another class of spatially adaptive methods involves mixing splines. Wood et al. (2002) presents a Bayesian model that is a mixture of smoothing splines, each having its own smoothing parameter over the domain of the covariate. The mixture model uses individual weights that depend on the covariate value x.What allows the model to be spatially adaptive is fact that the weights vary over the covariate space. Selecting the appropriate number of spline components is done via a modiﬁed Bayesian information criterion (BIC). The mixture-of-splines estimate was similar in performance to the methods of Denison et al. (1998), Lou and Wahba (1997), and Smith and Kohn (1996). In some cases the mixtureof-splines estimate performed better than the other methods across the four test functions that were considered.


[Page 28]

The trade-oﬀ between bias and variance is controlled by the smoothing parameter λ as was mentioned in Chapter 2. However, for functions with varying oscillations or functions with discontinuities, a single smoothing parameter is inadequate (Scheipl and Kneib, 2009). In this chapter, we introduce spatially adaptive smoothing. Allowing λ to be locally adaptive improves the accuracy of inference and reduces the mean squared error (Ruppert and Carroll, 2000). The following method is referred to as Bayesian Adaptive Penalized Splines (BAPS).

Consider the model

$$
y _ { i } = f ( x _ { i } ) + \epsilon _ { i },
$$

where

$$
f ( x _ { i } ) = \beta _ { 0 } + \beta _ { 1 } x _ { i } + \dots + \beta _ { p } x _ { i } ^ { p } + \sum _ { j = 1 } ^ { K _ { \kappa } } b _ { j } ( x _ { i } - \kappa _ { j } ) _ { + } ^ { p } .
$$

In Chapter 2, b ∼ N ( 0,σ 2 b I K κ ), i.e., σ 2 b is common to all the b j, j = 1,...,K κ.To make the model spatially adaptive, Yue et al. (2012) proposed spatially adaptive precisions δ j,

$$
( b _ { j } | \delta _ { j } ) \stackrel { i n d } { \sim } N ( 0, \delta _ { j } ^ { - 1 } ), \quad j = 1, \dots, K _ { \kappa } .
$$

Moreover, deﬁne δ j as

$$
\delta _ { j } = \delta \exp ( \gamma _ { j } ),
$$

where δ is a scale parameter.

Let ι 1,...,ι K ι be a second layer of knots that covers the range of the knots κ 1,...,κ K κ.The model proposed by Yue et al. (2012) then speciﬁes γ j as

$$
\gamma _ { j } = \sum _ { k = 1 } ^ { K _ { \iota } } b _ { \gamma k } I ( \kappa _ { j } \geq \iota _ { k } ), \ \ j = 1, \dots, K _ { \kappa },
$$


[Page 29]

i.e., as a piecewise constant or

$$
\gamma _ { j } = \sum _ { k = 0 } ^ { K _ { \iota } } b _ { \gamma k } ( \kappa _ { j } - \iota _ { k } ) _ { + }, \quad j = 1, \dots, K _ { \kappa },
$$

i.e., as truncated lines. A normal homoscedastic prior with precision η is placed on the new random eﬀects b γk,

$$
( b _ { \gamma k } | \eta ) \stackrel { i i d } { \sim } N ( 0, \eta ^ { - 1 } I _ { K _ { \ell } + q } ),
$$

for k = 0,...,K ι when q = 1 (truncated lines) and for k = 1,...,K ι when q = 0 (piecewise constant). Equations (3.4) and (3.5) are P-splines of degree 0 and 1, respectively.

This section is devoted to describing the priors used in the BAPS model. To begin, the prior placed on the ﬁxed eﬀects β is the same as in Chapter 2. The density p ( y | b, β,τ ) is normal, i.e.,

$$
( y | \beta, b, \tau ) \sim N ( X \beta + Z b, \tau ^ { - 1 } I _ { n } ),
$$

where τ is a precision parameter. The parameter τ has the improper Jeﬀrey’s prior,

$$
p ( \tau ) \, \infty \, \frac { 1 } { \tau } .
$$

Let ξ 1 = δ/τ and ξ 2 = η/δ be a parametrization of the smoothing parameters. It follows that δ = τξ 1.For a fully Bayesian approach, ξ 1 and ξ 2 need hyper prior speciﬁcations. The priors suggested by Yue et al. (2012) follow directly from the work of Liang et al. (2008) and Yue and Speckman (2010) where a Pareto prior is placed on ξ 1,

$$
p ( \xi _ { 1 } | c ) = \frac { c } { ( c + \xi _ { 1 } ) ^ { 2 } }, \quad \xi _ { 1 } \geq 0, \quad c > 0,
$$

and an inverse gamma prior with pdf p ( ξ 2 | a,b ) ∝ ξ − ( a +1) 2 e − b/ξ 2, ξ 2 > 0, a > 0, b > 0, is placed on ξ 2.However, Yue et al. (2012) use a Pareto prior on ξ 2 as well. To ease the computation,


[Page 30]

$$
p ( \xi _ { i } | c ) = \int _ { 0 } ^ { \infty } p ( \xi _ { i } | \rho _ { i } ) p ( \rho _ { i } | c ) d \rho _ { i } .
$$

The joint distribution of the b j ’s is normal with zero mean vector and variance-covariance matrix δ j I K κ (see Equation (3.2)). Using (3.3) we can write ( b | γ,τ,ξ 1 ) ∼ N ( 0, ( τξ 1 ) − 1 D − 1 γ ), where D γ =diag( e γ 1,...,e γ K κ ) and γ = Z γ b γ where b γ = ( b γ 1,...,b γK ι )   and

$$
Z _ { \gamma } = \begin{bmatrix} ( \kappa _ { 1 } - \iota _ { 1 } ) _ { + } ^ { q } & \dots & ( \kappa _ { 1 } - \iota _ { K _ { \iota } } ) _ { + } ^ { q } \\ \vdots & \ddots & \vdots \\ ( \kappa _ { K _ { \kappa } } - \iota _ { 1 } ) _ { + } ^ { q } & \dots & ( \kappa _ { K _ { \kappa } } - \iota _ { K _ { \iota } } ) _ { + } ^ { q } \end{bmatrix},
$$

that is, in the design matrix Z γ the knots { κ j } K κ j =1 are treated as covariate values with knots { ι k } K ι k =1.The parameter vector b γ ∼ N ( 0,η − 1 I K ι + q ). Note that η = δξ 2 and δ = τξ 1, so η = τξ 1 ξ 2.The prior on b γ can then be written as ( b γ | τ,ξ 1,ξ 2 ) ∼ N ( 0, ( τξ 1 ξ 2 ) − 1 I K ι + q ). This completes the prior speciﬁcation for the BAPS model. Yue et al. (2012) show that the choice of priors leads to a proper posterior distribution.

In this section, we present the sampling scheme for the BAPS model. Let T = [ X,Z ]. To sample from the posterior

$$
p ( \beta, b, \tau, \xi _ { 1 }, \xi _ { 2 }, \rho _ { 1 }, \rho _ { 2 }, \gamma | y ) & \otimes p ( y | \beta, b, \tau ) p ( \tau ) p ( \beta ) p ( b | \gamma, \tau, \xi _ { 1 } ) p ( \xi _ { 1 } | \rho _ { 1 } ) p ( \xi _ { 2 } | \rho _ { 2 } ) \\ & \times p ( \rho _ { 1 } | c _ { 1 } ) p ( \rho _ { 2 } | c _ { 2 } ) p ( b _ { \gamma } | \tau, \xi _ { 1 }.\xi _ { 2 } ) .
$$

The full conditional posterior distributions for the individual parameters ( β, b,τ,ξ 1,ξ 2,ρ 1,ρ 2, γ ) are as follows.

1. The parameter vectors β and b are sampled jointly as θ = ( β  , b ) from the multivariate normal distribution, N ( µ θ,Q θ ), where

$$
\mu _ { \theta } = \tau Q _ { \theta } T ^ { \prime } y,
$$


[Page 31]

$$
Q _ { \theta } = ( \tau T ^ { \prime } T + \Lambda _ { y } ) ^ { - 1 },
$$

and Λ y = diag(1 /σ 2 β,..., 1 /σ 2 β,τξ 1 e γ 1,...,τξ 1 e γ K κ ).

$$
G \left ( \frac { 1 } { 2 } ( n + K _ { \kappa } + K _ { \iota } + q ), \frac { 1 } { 2 } ( \| y - T \theta \| ^ { 2 } + \xi _ { 1 } b ^ { \prime } D _ { \gamma } b + \xi _ { 1 } \xi _ { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } ) \right ) .
$$

$$
G \left ( \frac { 1 } { 2 } ( K _ { \kappa } + K _ { \iota } + q ) + 1, \frac { 1 } { 2 } \tau b ^ { \prime } D _ { \gamma } b + \frac { 1 } { 2 } \tau \xi _ { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } + \rho _ { 1 } \right ) .
$$

$$
G \left ( \frac { 1 } { 2 } ( K _ { \iota } + q ) + 1, \frac { 1 } { 2 } \tau \xi _ { 1 } b ^ { \prime } _ { \gamma } b _ { \gamma } + \rho _ { 2 } \right ) .
$$

$$
p ( b _ { \gamma } | \gamma, b, \delta, \eta ) \, \in \, | D _ { \gamma } | ^ { 1 / 2 } \exp \left \{ - \frac { 1 } { 2 } \tau \xi _ { 1 } b ^ { \prime } D _ { \gamma } b - \frac { 1 } { 2 } \tau \xi _ { 1 } \xi _ { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } \right \} .
$$

A new value b ∗ γ is proposed from N ( ˆ b γ, ˆ Σ b γ ), where ˆ b γ = arg max b γ log p ( b γ | γ, b,τ,ξ 1,ξ 2 ) and 2 1

$$
\hat { \Sigma } _ { b _ { \gamma } } = \left [ - \frac { \partial ^ { 2 } \log p ( b _ { \gamma } | \gamma, b, \tau, \xi _ { 1 }, \xi _ { 2 } ) } { \partial b _ { \gamma } \partial b _ { \gamma } ^ { \prime } } | _ { b _ { \gamma } = \hat { b } _ { \gamma } } \right ] ^ { - 1 } .
$$

The new value, b ( t +1) γ, satisﬁes

$$
b _ { \gamma } ^ { ( t + 1 ) } = \left \{ \begin{array} { l l } { b _ { \gamma } ^ { * } } & { w i t h \text { probability } \alpha _ { \gamma } } \\ { b _ { \gamma } ^ { ( t ) } } & { w i t h \text { probability } 1 - \alpha _ { b _ { \gamma } }, } \end{array}
$$

where b ( t ) γ is the current value. The acceptance probability is

$$
\alpha _ { b _ { \gamma } } = \min \left \{ \frac { p ( b _ { \gamma } ^ { * } | \gamma, b, \tau, \xi _ { 1 }, \xi _ { 2 } ) g ( b _ { \gamma } ^ { ( t ) } | b _ { \gamma } ^ { * } ) } { p ( b _ { \gamma } ^ { ( t ) } | \gamma, b, \tau, \xi _ { 1 }, \xi _ { 2 } ) g ( b _ { \gamma } ^ { * } | b _ { \gamma } ^ { ( t ) } ) }, 1 \right \},
$$

where g ( b ∗ γ | b ( t ) γ ) is the proposal density for b ∗ γ, i.e., N ( ˆ b γ, ˆ Σ b γ ) .


[Page 32]

In Yue et al. (2012)’s method, the b γk ’s are sampled in blocks (see Yue and Speckman (2010)), rather than jointly. They split the vector b γ into V blocks: b γ = ( b γ 1,..., b γ V )  .They then use a random walk Metropolis-Hastings step with acceptance probability

$$
\alpha _ { v } = \min \left \{ \frac { \pi ( b _ { \gamma v } ^ { * } ) } { \pi ( b _ { \gamma v } ^ { ( t ) } ) }, 1 \right \}
$$

to update each block where the proposal distribution for the new value b ∗ γv is the prior distribution for b γ, i.e., π ( b γv ) = p ( b γv | b, b γ ( − v ), γ,τ,ξ 1,ξ 2, γ ) and b γ ( − v ) is the vector containing the remaining vectors.

Details on the sampling scheme can be found in Appendix A.2.

In this section we conduct Monte Carlo simulations using the BAPS model. Based on the examples presented, we compare the performance of the BAPS model with its non-adaptive version, the Bayesian Penalized Splines (BPS) model. Two diﬀerent functions taken from Yue et al. (2012) are used for the simulation. One is a smoothly varying function, and the other is a spatially inhomogeneous function. For each setting, we present 10 diﬀerent simulations. The number of knots for the BAPS and the BPS models is K κ = 30 with sub knots K ι = 10 for the BAPS model. Pointwise 95% credible intervals are also part of the displays. The ﬁxed parameters were set to c 1 = c 2 = 1 in the posterior distributions for the parameters ρ 1 and ρ 2 in the BAPS model. For the BPS model A = A b = B = B b = 0

For the ﬁrst setting, we consider a natural spline with knots located at the points (0.2, 0.6, 0.7) and coeﬃcients (20, 4, 6, 11, 6). We evaluate the knots and coeﬃcients at n=101 equally spaced points on [0, 1]. Gaussian noise with mean zero and standard deviation τ − 1 / 2 = 0.9 was added to the function values. The degree of the basis functions used for the estimation is p = 2. Figures 3.1 and 3.2 show the BAPS estimates and BPS estimates for the natural spline function. Figure 3.1 shows the results corresponding to ﬁve simulated samples while Figure 3.2 displays the results for the remaining ﬁve simulated


[Page 33]

In the second setting, we generate data from the function

$$
h ( x ) = \sin ( x ) + 2 \exp ( - 3 0 x ^ { 2 } ), \ \ x \in [ - 2, 2 ] .
$$

The function was evaluated at n=101 equally spaced points. Again, Gaussian noise with mean zero and standard deviation τ − 1 / 2 = 0.3 was added to the function values. The degree of basis functions used for the estimation for this setting is p = 2. From ﬁgures 3.3 and 3.4 we can appreciate the performance of the BAPS model. The BPS estimate is unable to ﬂatten out the tails of the function. The BAPS estimate, however, is able to ﬂatten out the tails and comes relatively closer than the BPS model at estimating the hump.

In the next chapter, we will apply the BAPS methodology to spectral time series analysis.


[Page 34]



True Function

True Function



Fit

Adaptive Fit

95% CI

95% CI



0.0

0.2

0.4

0.6

0.8

1.0

0.0

0.2

0.4

0.6

0.8

1.0









0.0

0.2

0.4

0.6

0.8

1.0

0.0

0.2

0.4

0.6

0.8

1.0









0.0

0.2

0.4

0.6

0.8

1.0

0.0

0.2

0.4

0.6

0.8

1.0







0.0

0.2

0.4

0.6

0.8

1.0

0.0

0.2

0.4

0.6

0.8

1.0







0.0

0.2

0.4

0.6

0.8

1.0

0.0

0.2

0.4

0.6

0.8

1.0

Figure 3.1: BAPS and BPS estimates for the natural spline. The ﬁrst column displays the BPS estimates; the second column displays the BAPS estimates. In each column, the solid line represents the true function; the dashed line represents the estimate; and the dotted lines represent pointwise 95% credible intervals. (First 5 simulations)


[Page 35]



True Function

True Function



Fit

Adaptive Fit

95% CI

95% CI



0.0

0.2

0.4

0.6

0.8

1.0

0.0

0.2

0.4

0.6

0.8

1.0







0.0

0.2

0.4

0.6

0.8

1.0

0.0

0.2

0.4

0.6

0.8

1.0









0.0

0.2

0.4

0.6

0.8

1.0

0.0

0.2

0.4

0.6

0.8

1.0









0.0

0.2

0.4

0.6

0.8

1.0

0.0

0.2

0.4

0.6

0.8

1.0









0.0

0.2

0.4

0.6

0.8

1.0

0.0

0.2

0.4

0.6

0.8

1.0

Figure 3.2: BAPS and BPS estimates for the natural spline. The ﬁrst column displays the BPS estimates; the second column displays the BAPS estimates. In each column, the solid line represents the true function; the dashed line represents the estimate; and the dotted lines represent pointwise 95% credible intervals. (Second 5 simulations)


[Page 36]



True Function

True Function



Fit

Adaptive Fit

95% CI

95% CI























































































Figure 3.3: BAPS and BPS estimates for the function (3.12). The ﬁrst column displays the BPS estimates; the second column displays the BAPS estimates. In each column, the solid line represents the true function; the dashed line represents the estimate; and the dotted lines represent pointwise 95% credible intervals.(First 5 simulations)


[Page 37]



True Function

True Function



Fit

Adaptive Fit

95% CI

95% CI















2.0

2.0

0.5

0.5

−1.0

−1.0





























1.5

1.5

0.0

0.0

−1.5

−1.5











1.5

1.5

0.0

0.0

−1.5

−1.5











Figure 3.4: BAPS and BPS estimates for the function (3.12). The ﬁrst column displays the BPS estimates; the second column displays the BAPS estimates. In each column, the solid line represents the true function; the dashed line represents the estimate; and the dotted lines represent pointwise 95% credible intervals. (Second 5 simulations)


[Page 38]

A brief introduction to time series was given in Chapter 1. It was mentioned that time series analysis can be done in either the time domain or the frequency domain. In this chapter we focus on the frequency domain.

The idea of stationarity is that the mean and variance of a time series are constant for all time points t.A process is said to be weakly stationary, if it has a constant mean and

$$
\gamma _ { t, s } = C o v ( Y _ { t - s }, Y _ { 0 } ) = C o v ( Y _ { 0 }, Y _ { t - s } ) = C o v ( Y _ { 0 }, Y _ { | t - s | } ) = \gamma _ { | t - s | },
$$

for all time points t,s.Unlike weak stationarity, a process { Y t } is strictly stationary, when the joint distributions for the variables Y t 1,...,Y t n and Y t 1 −  ,...,Y t n − are the same for all time points t = 1,...,n and lags (Cryer and Chan, 2008).

In Chapter 1, we brieﬂy discussed the frequency domain and showed how the cosine wave (1.3) can be expanded using Trigonometric identities. In this section, the saturated cosine model will be introduced. For any time series sample y 1,...,y n, where n is odd, we can


[Page 39]

$$
Y _ { t } = A _ { 0 } + \sum _ { j = 1 } ^ { ( n - 1 ) / 2 } [ A _ { j } \cos ( 2 \pi \omega _ { j } t ) + B _ { j } \sin ( 2 \pi \omega _ { j } t ) ]
$$

for t = 1,...,n and suitably chosen coeﬃcients (see Shumway and Soﬀer (2011)). The coeﬃcients A  and B  can be found using regression results. The Fourier frequencies, /n,  = 1,..., ( n − 1) / 2 lead to simple expressions for A  and B , since for these frequencies the sines and cosines are orthogonal. These expressions for A 0, the A  ’s and B  ’s are ˆ A 0 = Y,

$$
\hat { A } _ { j } = \frac { 2 } { n } \sum _ { t = 1 } ^ { n } y _ { t } \cos ( 2 \pi t / n ), \quad \text {and} \quad \hat { B } _ { j } = \frac { 2 } { n } \sum _ { t = 1 } ^ { n } y _ { t } \sin ( 2 \pi t / n ),
$$

respectively. In the case where n is even, the estimates for A 0, A j ’s and B j ’s are similar.

Given data y 1,...,y n, the discrete Fourier transform (DFT), where i = √ − 1, is deﬁned as n

$$
d ( \omega _ { j } ) = \frac { 1 } { \sqrt { n } } \sum _ { t = 1 } ^ { n } y _ { t } e ^ { - 2 \pi i \omega _ { j } t } \\
$$

for  = 0, 1,...,n − 1 and ω  = /n (Fourier frequencies). The periodogram is deﬁned as

$$
I _ { n } ( \omega _ { j } ) = \left | d ( \omega _ { j } ) \right | ^ { 2 }, \ \jmath = 0, 1, \dots, n - 1 .
$$

Let the cosine and sine transforms be deﬁned as

$$
d _ { \mathcal { C } } ( \omega _ { j } ) = \frac { 1 } { \sqrt { n } } \sum _ { t = 1 } ^ { n } y _ { t } \cos ( - 2 \pi \omega _ { j } t ) \quad \text {and} \quad d _ { \mathcal { S } } ( \omega _ { j } ) = \frac { 1 } { \sqrt { n } } \sum _ { t = 1 } ^ { n } y _ { t } \sin ( - 2 \pi \omega _ { j } t ),
$$

receptively, where ω  = /n,  = 0, 1,...,n − 1 (Shumway and Soﬀer, 2011). Then

$$
I _ { n } ( \omega _ { j } ) = d _ { \mathcal { C } } ^ { 2 } ( \omega _ { j } ) + d _ { \mathcal { S } } ^ { 2 } ( \omega _ { j } ) .
$$

$$
I _ { n } ( \omega _ { j } ) & = \frac { n } { 4 } [ \hat { A } _ { j } ^ { 2 } + \hat { B } _ { j } ^ { 2 } ] \\ & = \frac { 1 } { n } \left | \sum _ { t = 1 } ^ { n } y _ { t } e ^ { - 2 \pi i \omega _ { j } t } \right | ^ { 2 } .
$$

The overall behavior of time series can then be summarized by identifying the cosine-sine pairs in the time series. The relative strength of the cosine-sine pairs is determined by the heights at the various frequencies ω  = /n,  = 0, 1,...,n − 1 (Cryer and Chan, 2008).


[Page 40]

If the autocovariance function, γ  , of a stationary process satisﬁes

$$
\sum _ { \ell = - \infty } ^ { \infty } | \gamma _ { \ell } | < \infty,
$$

then it can be represented as

$$
\gamma _ { \ell } = \int _ { - 1 / 2 } ^ { 1 / 2 } f ( \omega ) \exp ( - 2 \pi i \ell \omega ) d \omega, \quad \ell = 0, \pm 1, \pm 2, \dots
$$

where the spectral density, f ( ω ), has the representation

$$
f ( \omega ) = \sum _ { \ell = - \infty } ^ { \infty } \gamma _ { \ell } \exp ( - 2 \pi i \ell \omega ), \quad - 1 / 2 \leq \omega \leq 1 / 2 .
$$

The spectral density is symmetric over the domain − 1 / 2 ≤ ω ≤ 1 / 2, i.e., f ( ω ) = f ( − ω ), periodic and nonnegrative. From (4.10), for = 0, γ 0 = Var( Y t ) = 1 / 2 − 1 / 2 f ( ω ) dω.This shows that the total variance of the time series is the integral of f ( ω ) over the entire range of frequencies. All mathematical properties of probability density functions can be applied to spectral densities with the exception that the area under the spectral density is Var( Y t ).

Let ω m = m/n, for m = 1,...,M, be the Fourier frequencies where M = n − 1) / 2  .The notation w represents the largest integer not greater than w.Again, let C = [ X,Z ] where X denotes the m × ( p + 1) matrix whose i th row is (1,ω i,...,ω p i ) and Z is a matrix whose i th row is equal to (( ω i − κ 1 ) p +,..., ( ω i − κ K κ ) p + ). Given a stationary process { Y t }, Whittle (1957) shows that the values I n ( ω m ) are approximately independent and exponentially distributed with mean f ( ω m ), i.e., the pdf of I n ( ω m ) is given by

$$
p ( I _ { n } ( \omega _ { m } ) ) = f ( \omega _ { m } ) ^ { - 1 } \exp ( - I _ { n } ( \omega _ { m } ) / f ( \omega _ { m } ) ) .
$$


[Page 41]

Moreover, he shows that for large n the likelihood for { Y t }, conditional on f, can be approximated by

$$
\text {proximated by} \\ p ( y | f ) & = \prod _ { m = 1 } ^ { M } f ( \omega _ { m } ) ^ { - 1 } \exp \left \{ - I _ { n } ( \omega _ { m } ) / f ( \omega _ { m } ) \right \} \\ & = \prod _ { m = 1 } ^ { M } \exp \{ - \log f ( \omega _ { m } ) - I _ { n } ( \omega _ { m } ) / f ( \omega _ { m } ) \} \\ & = \prod _ { m = 1 } ^ { M } \exp \{ - \log f ( \omega _ { m } ) - I _ { n } ( \omega _ { m } ) \exp [ - \log f ( \omega _ { m } ) ] \} \,.\\ \text {et.} \, - \log f ( \omega _ { m } ) & = c ^ { \prime } \, \theta.\text { where } c ^ { \prime } \text { is the math row of } C.\text { Then } ( 4.1 3 ) \text { becomes}
$$

Let − log f ( ω m ) = c m θ, where c m is the m th row of C.Then (4.13) becomes

$$
p ( y | f ) = \exp \left \{ \sum _ { m = 1 } ^ { M } [ c _ { m } ^ { \prime } \theta - I _ { n } ( \omega _ { m } ) \exp ( c _ { m } ^ { \prime } \theta ) ] \right \} .
$$

Whittle likelihood has been used before to estimate the spectral density. Early references include Wahba (1980) who modeled the log-spectral density using cubic smoothing splines and Pawitan and O’Sullivan (1994) who used a penalized version of the Whittle likelihood. The next section will be devoted to prior speciﬁcation on the parameters for this model.

In this section, the priors for the Whittle likelihood result in a spatially adaptive estimate of the spectral density, similar to the spatially adaptive estimates in Chapter 3. Firstly, the prior placed on the ﬁxed coeﬃcients β remains the same, as in Chapter 2. Recall that in order to make the estimate spatially adaptive, we placed a normal prior on the b j ’s with variance δ − 1 j.For spectral smoothing, we make a slight alteration to the precisions. The parameter τ no longer appears in the likelihood, so δ in this chapter is simply a scale parameter, no longer equal to τξ 1, as was the case in Chapter 2. Then, let δ j = δ exp( γ j ). The prior placed on b is

$$
( b | \gamma, \delta ) \sim N ( 0, \delta ^ { - 1 } D _ { \gamma } ^ { - 1 } ),
$$


[Page 42]

where D γ =diag( e γ 1,...,e γ K κ ) and

$$
\gamma _ { j } = \sum _ { k = 1 } ^ { K _ { \iota } } b _ { \gamma k } I ( \kappa _ { j } \geq u _ { k } ), \ \ j = 1, \dots, K _ { \kappa },
$$

when q = 0 (piecewise constant) or

$$
\gamma _ { j } = \sum _ { k = 0 } ^ { K _ { \iota } } b _ { \gamma k } ( \kappa _ { j } - \iota _ { k } ) _ { + }, \ \ j = 1, \dots, K _ { \kappa },
$$

when q = 1 (truncated lines). Next, as in the BAPS model of Chapter 3, the prior placed on the random eﬀects b γk is normal with mean zero and precision η, i.e.,

$$
( b _ { \gamma } | \eta ) \sim N ( 0, \eta ^ { - 1 } I _ { K _ { \ell } + q } ) .
$$

The prior placed on θ is thus

$$
p ( \theta ) & \ = \ p ( \beta ) \times p ( b ) \\ & \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
$$

where Λ =diag 1 /σ 2 β,..., 1 /σ 2 β,δe γ 1,...,δe γ K κ  .To complete the prior speciﬁcation, the work of Gelman (2006) is utilized to place priors on the standard deviations δ − 1 / 2 and η − 1 / 2.The priors on these standard deviations are independent folded t distributions whose density is p ( x ) ∝ [1+( x/G ) 2 /ν ] − ( ν +1) / 2, x > 0, where ν and G are ﬁxed parameters. For the simulations in this chapter, we let ν = 2 and G = 10 5.The folded t distribution has a scale mixture representation which can be utilized to simplify the sampling scheme. A folded t prior on δ − 1 / 2 is equivalent to the scale mixture

$$
( \delta ^ { - 1 } | \nu _ { 1 }, g _ { 1 } ) \sim I G ( \nu _ { 1 } / 2, \nu _ { 1 } / g _ { 1 } ), \ \ g _ { 1 } \sim I G ( 1 / 2, \nu _ { 1 } / G _ { 1 } ^ { 2 } ) .
$$

Similarly, a folded t prior on η − 1 / 2 can be represented by

$$
( \eta ^ { - 1 } | \nu _ { 2 }, g _ { 2 } ) \sim I G ( \nu _ { 2 } / 2, \nu _ { 2 } / g _ { 2 } ), \ \ g _ { 2 } \sim I G ( 1 / 2, \nu _ { 2 } / G _ { 2 } ^ { 2 } ),
$$

see Wand et al. (2012).


[Page 43]

The posterior distribution for this model is given by

p ( β, b, b γ,δ,η,g 1,g 2 | I ) ∝ p ( I | β, b ) p ( b | γ,δ ) p ( δ | g 1 ) p ( g 1 ) p ( b γ | η ) p ( η | g 2 ) p ( g 1 ) p ( β ),

where I = ( I n ( ω 1 ),..., ( I n ( ω M ))  .To draw ( β, b, b γ,δ,η,g 1,g 2 ) from their joint posterior distribution, MCMC methods are employed as follows:

1. The parameter vectors β and b are sampled jointly as θ = ( β  , b ) via a MetropolisHastings step from its conditional posterior distribution whose logarithm is

$$
\log p ( \theta | I, C ) = \sum _ { m = 1 } ^ { M } [ c _ { m } ^ { \prime } \theta - I _ { n } ( \omega _ { m } ) \exp ( c _ { m } ^ { \prime } \theta ) ] - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda \theta,
$$

where c m is the m th row of C .

$$
p ( b _ { \gamma } | \gamma, b, \delta, \eta ) \, \in \, | D _ { \gamma } | ^ { 1 / 2 } \exp \left \{ - \frac { \delta } { 2 } b ^ { \prime } D _ { \gamma } b - \frac { \eta } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } \right \} .
$$

$$
I G \left ( \frac { 1 } { 2 } ( \nu _ { 1 } + 1 ), \nu _ { 1 } \delta + \frac { 1 } { G _ { 1 } ^ { 2 } } \right ) .
$$

$$
G \left ( \frac { 1 } { 2 } ( K _ { \iota } + q + \nu _ { 2 } ), \frac { 1 } { 2 } b _ { \gamma } ^ { \prime } b _ { \gamma } + \frac { \nu _ { 2 } } { g _ { 2 } } \right ) .
$$

$$
I G \left ( \frac { 1 } { 2 } ( \nu _ { 2 } + 1 ) ), \nu _ { 2 } \eta + \frac { 1 } { G _ { 2 } ^ { 2 } } \right ) .
$$

For further details on the derivations of the full conditional posterior distributions for the various parameters and the Metropolis-Hastings steps, refer to Appendix A.3.


[Page 44]

In this section we explore the model presented via Monte Carlo simulations. Samples are generated from an AR(2) model,

$$
Y _ { t } = \phi _ { 1 } Y _ { t - 1 } + \phi _ { 2 } Y _ { t - 2 } + e _ { t }, \ \ e _ { t } \sim N ( 0, \sigma _ { e } ^ { 2 } ) .
$$

In the ﬁrst simulation setting, φ 1 = 1.5 and φ 2 = − 0.75 while in the second simulation setting, φ 1 = 0.1 and φ 2 = 0.4. The theoretical spectral density for an AR(2) process is

$$
f ( \omega ) = \frac { \sigma _ { e } ^ { 2 } } { 1 + \phi _ { 1 } ^ { 2 } + \phi _ { 2 } ^ { 2 } - 2 \phi _ { 1 } ( 1 - \phi _ { 2 } ) \cos ( 2 \pi \omega ) - 2 \phi _ { 2 } \cos ( 4 \pi \omega ) } .
$$

This spectral density may have diﬀerent shapes depending on the values of φ 1 and φ 2.The ﬁrst setting has peaked spectrum, while the second one has trough spectrum. Ten samples of size 1000 are generated from each setting. Each sample was run for 2000 MCMC iterations with a burn-in period of 500. Two versions of the model were ﬁt to the samples: spatially adaptive and non spatially adaptive. Quadratic basis functions and K κ = 30 knots were used for the non-adaptive and adaptive ﬁts. For the adaptive case, K ι = 10 knots with basis functions of degree q = 0 are used. Additionally, the plots also display the “smoothed” periodogram using a third (frequentist) method presented by Cryer and Chan (2008). For the Bayesian methods, pointwise 95% credible intervals are also displayed. For the frequentist methods, pointwise 95% conﬁdence intervals are computed as follows:

$$
\log [ \bar { f } ( \omega ) ] + \log \left [ \frac { d f } { \chi _ { d f, 1 - \alpha / 2 } ^ { 2 } } \right ] \leq \log [ f ( \omega ) ] \leq \log [ \bar { f } ( \omega ) ] \leq + \log \left [ \frac { d f } { \chi _ { d f, \alpha / 2 } ^ { 2 } } \right ],
$$

where f ( ω ) is the smoothed periodogram given by

$$
\bar { f } ( \omega ) = \sum _ { \ell = - a } ^ { a } W _ { a } ( \ell ) I _ { n } \left ( \omega + \frac { \ell } { n } \right ) .
$$

In equation (4.19), The degrees of freedom in equation (4.18) are given by

$$
W _ { a } ( \ell ) = \frac { 1 } { 2 a + 1 }, \quad - a \leq \ell \leq a .
$$


[Page 45]

$$
d f = \frac { 2 } { \sum _ { \ell = - a } ^ { a } W _ { a } ^ { 2 } ( \ell ) },
$$

and χ 2 df, 1 − α/ 2 and χ 2 df,α/ 2 denote the 100(1 − α/ 2)% and 100( α/ 2)%, percentiles, respectively, of a chi-square distribution on df degrees of freedom.

Figures 4.1 and 4.2 display the ﬁrst and second ﬁve samples,respectively, generated from the AR(2) process with φ 1 = 1.5 and φ 2 = − 0.75. The left column in each ﬁgure displays the non-adaptive estimates, the middle column displays the adaptive estimates, and the last column displays the estimates of the frequentist method. Each plot shows the true log spectral density, the estimate, and pointwise 95% credible (or conﬁdence) intervals. The true spectral density has a prominent peak at frequency ω = 80 / 1000 = 0.08, where log f (0.08) = 4.15855. Overall, the adaptive estimates outperform the nonadaptive estimates in both settings. The non-adaptive estimate is unable to ﬂatten out the tail, unlike the adaptive method, that manages to ﬂatten out the tail and catch the peak with better accuracy. For the trough spectral density, (Figures 4.4 and 4.5) there is little diﬀerence between the adaptive and non-adaptive ﬁts. To show the three methods more clearly, Figures 4.3 and 4.6 display the ﬁt for a particular sample.

In the next chapter, we will use a real data set to apply the method presented in this thesis.


[Page 46]




True Function

True Function

True Function




Fit

Adaptibe Fit

Cryer & Chan Fit

95% CI

95% CI

95% CI







0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5













0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5













0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5













0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5













0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

Figure 4.1: Estimates of the log spectral density based on the simulated samples from the AR(2) process with parameters φ 1 = 1.5 and φ 2 = − 0.75. The ﬁrst column displays the non-adaptive estimates; the second column displays the adaptive estimates; and the third column displays the estimates using the frequentist method. In each column, The solid line represents the true spectral density; the dashed line represents the estimate; and the dotted lines represent pointwise 95% credible (or conﬁdence) intervals. (First 5 simulations).


[Page 47]




True Function

True Function

True Function




Fit

Adaptibe Fit

Cryer & Chan Fit

95% CI

95% CI

95% CI







0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5













0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5













0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5













0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5













0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

Figure 4.2: Estimates of the log spectral density based on the simulated samples from the AR(2) process with parameters φ 1 = 1.5 and φ 2 = − 0.75. The ﬁrst column displays the non-adaptive estimates; the second column displays the adaptive estimates; and the third column displays the estimates using the frequentist method. In each column, The solid line represents the true spectral density; the dashed line represents the estimate; and the dotted lines represent pointwise 95% credible (or conﬁdence) intervals. (Second 5 simulations).


[Page 48]

True Function Fit

True Function Adaptive Fit

True Function Cryer & Chan

Fit

Adaptive Fit

Cryer & Chan Fit

95% CI

95% CI

95% CI













0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

Figure 4.3: Log spectral estimates of the 3rd simulated sample from the AR(2) process with parameters φ 1 = 1.5 and φ 2 = − 0.75. The ﬁrst plot displays the non-adaptive estimate; the second plot displays the adaptive estimate; and the third plot displays the estimate using the frequentist method. The solid line represents the true spectral density; the dashed line represents the estimate; and the dotted lines represent pointwise 95% credible (or conﬁdence) intervals.


[Page 51]




True Function Fit

True Function Adaptive Fit

True Function Cryer & Chan

Fit

Adaptive Fit

Cryer & Chan Fit

95% CI

95% CI

95% CI










0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

0.0

0.1

0.2

0.3

0.4

0.5

Figure 4.6: Log spectral estimates of the 3rd simulated sample from the AR(2) process with parameters φ 1 = 0.1 and φ 2 = 0.4. The ﬁrst plot displays the non-adaptive estimate; the second plot displays the adaptive estimate; and the third plot displays the estimate using the frequentist method. The solid line represents the true spectral density; the dashed line represents the estimate; and the dotted lines represent pointwise 95% (or conﬁdence) credible intervals.


[Page 52]

In this chapter, we apply the method of smoothing the spectrum of a time series to a real data set. The example used is the El Nin˜o Southern Oscillation (ENSO) phenomenon, where we model the spectrum of one indicator of ENSO, that is, the Southern Oscillation Index (SOI).

The El Ni˜no Southern Oscillation (ENSO) phenomenon is the change of temperature in the Tropical Eastern Paciﬁc Ocean that results in weather and climate episodes around the world. There has been much debate weather the intensity and frequency of ENSO has changed over the last century due to human-induced global warming. One particular indicator for ENSO that was used by Rosen et al. (2009) was the Southern Oscillation Index (SOI), which is the center of this application. The monthly standardized anomaly of the mean sea-level pressure diﬀerences between Tahiti and Darwin is what we refer to as the SOI. Negative values of the SOI that are below -8 are representative of El Nin˜o episodes and are associated with the warming of the central and eastern Paciﬁc Ocean. Positive values of the SOI above +8 are representative of La Ni˜na episodes and are associated with warm sea temperatures to the north of Australia. The data are available from the Australian Bureau of Meteorology at http://www.bom.gov.au/climate/current/soihtm1.shtml and consist of measurements from the year 1876 to present.

Figure 5.1 shows the monthly values of the SOI. The sample size is n = 1673, with measurement values from January 1876 to June 2015.


[Page 53]



SOI

−20

−40

1880

1900

1920

1940

1960

1980

2000

2020

Year

Figure 5.1: Monthly values of the Southern Oscillation Index (SOI).

Two settings are considered for the application: The ﬁrst setting utilizes quadratic basis functions to smooth the log periodogram of the SOI time series; the second setting utilizes cosine basis functions. The adaptive and non-adaptive methods were ﬁt to the data running the algorithm for 2000 iterations with a burn-in period of 500. The number of knots for both ﬁts is K κ = 50. In the adaptive case, K ι = 15 knots are used for the piecewise constant basis functions. Figure 5.2 displays the log periodogram and the pointwise 95% credible intervals for the ﬁts based on quadratic basis functions.


[Page 54]

It is seen that in this case the non-adaptive ﬁt does a poor job in the low frequency region where there seems to be a peak in the log periodogram. The adaptive ﬁt is more satisfactory. Using the adaptive estimate there is a peak at ω = 35 / 1673 ≈ 0.02, that corresponds to a cycle of 1673 / 35 = 48, corresponding to 4 years. Figure 5.3 is analogous to Figure 5.2 except that this time cosine basis functions are used for both the adaptive and non-adaptive methods. These basis functions (see Eubank (1999)) are given by

$$
\frac { \sqrt { 2 } } { \pi ( j - 1 ) } \cos ( \omega [ j - 1 ] \pi ) .
$$

The corresponding ﬁts are essentially the same for both the adaptive and the non-adaptive methods. The peak seems to be slightly better estimated compared to the ﬁts corresponding to the polynomial basis functions, but the rest of the ﬁt is wigglier. In this case the peak occurs at about 50 months, which is close to the result based on Figure 5.2.

This thesis focused on the study of spatially adaptive splines from a Bayesian point of view. As was shown through various examples, spatial adaptivity may provide better ﬁts.


[Page 55]




Log spectrum


Adaptive Fit

Non−adaptive Fit

95% Credible Intervals

95% Credible Intervals



0.0

0.1

0.2

0.3

0.4

0.5

Frequency

Figure 5.2: Adaptive estimate of the log spectrum (solid line); non-adaptive estimate of the log spectrum (dashed-dotted line); pointwise 95% credible intervals for the adaptive ﬁt (dashed lines); and pointwise 95% credible intervals for the non-adaptive ﬁt (dotted lines) against frequency for monthly values of the SOI. The ﬁt are based on quadratic basis functions.


[Page 56]




Log spectrum


Adaptive Fit

Non−adaptive Fit

95% Credible Intervals

95% Credible Intervals



0.0

0.1

0.2

0.3

0.4

0.5

Frequency

Figure 5.3: Adaptive estimate of the log spectrum (solid line); non-adaptive estimate of the log spectrum (dashed-dotted line); pointwise 95% credible intervals for the adaptive ﬁt (dashed lines); and pointwise 95% credible intervals for the non-adaptive ﬁt (dotted lines) against frequency for monthly values of the SOI. The ﬁt are based on cosine basis functions.


[Page 57]

Baladandayuthapani, V., Mallick, B., and Carrol, R. (2005), “Spatially adaptive Bayesian regression rplines (P-splines),” Journal of Computational and Graphical Statistics, 14, 378–394.

Crainiceanu, C., Ruppert, D., Carrol, R., Joshi, A., and Goodner, B. (2007), “Spatially adaptive Bayesian penalized splines with heteroscedastic errors,” Journal of Computational and Graphical Statistics, 16, 265–288.

Cryer, J. D. and Chan, K.-S. (2008), Time Series Analysis with Applications in R, Springer, 2nd ed.

Denison, D., Mallick, B., and Smith, A. (1998), “Automatic Bayesian curve ﬁtting,” Journal of the Royal Statistical Society. Series B (Statistical Methodology), 60, 333–350.

DiMatteo, I., Genovese, C., and Kass, R. (2001), “Bayesian curve-ﬁtting with free-knot splines,” Biometrika, 88, 1055–1071.

Donoho, D. and Johnstone, I. (1994), “Ideal spatial adaptation by wavelet shrinkage,” Biometrika, 3, 425–455.

(1995), “Adapting to unknown smoothness via wavelent shrinkage,” Journal of the American Statistical Association, 90, 1200–1224.

Eilers, P. and Marx, B. (1996), “Flexible smoothing with B-splines and penalties,” Statistical Science, 11, 89–102.

Eubank, R. L. (1999), Nonparametric Regression and Spline Smoothing, Marcel Dekker, 2nd ed.


[Page 58]

Gelman, A. (2006), “Prior distribution for variace components in hierarchcal model (comment on article by Browne and Draper),” Bayesian Analysis, 1, 515–534.

Henderson, C. R. (1950), “Estimation of genetic paramters (abstract),” Annals of Mathematical Statistics, 21, 309–310.

Liang, F., Paulo, R., Molina, G., Clyde, M. A., and Berger, J. O. (2008), “Mixture g priors for Bayesian variable selection,” Journal of the American Statistical Association, 103, 410–423.

Lou, Z. and Wahba, G. (1997), “Hybrid adaptive splines,” Journal of the American Statistical Association, 92, 107–116.

Miyata, S. and Shen, X. (2003), “Adaptive free-knot splines,” Journal of Computational and Graphical Statistics, 12, 197–213.

Pawitan, Y. and O’Sullivan, F. (1994), “Nonparametric spectral density estimation using penalized Whittle likelihood,” Journal of the American Statistical Association, 89, 600– 610.

Robinson, G. (1991), “That BLUP is a good thing: estimation of random eﬀects,” Statistical Science, 6, 15–32.

Rosen, O., Stoﬀer, D. S., and Wood, S. (2009), “Local spectral analysis via a Bayesian mixture of smoothing splines,” Journal of the American Statistical Association, 104, 249–262.

Ruppert, D. and Carroll, R. (2000), “Spatially-adaptive penalties for spline ﬁtting,” Australin and New Zealand Journal of Statistics, 42, 205–223.

Ruppert, D., Wand, M., and Carrol, R. (2003), Semiparametric Regression, Cambridge University Press.


[Page 59]

Scheipl, F. and Kneib, T. (2009), “Locally adaptive bayesian P-splines with a normalexponential-gamma Prior,” Computational Statistics and Data Analysis, 53, 3533–3552.

Shumway, R. H. and Soﬀer, D. S. (2011), Time Series Analysis and Its Applications, Springer, 3rd ed.

Smith, M. and Kohn, R. (1996), “Nonparametric regression using Bayesian variable selection,” Journal of Econometrics, 75, 317–343.

Staniswalis, J. G. (1989), “Local bandwidth selection for kernel estimates,” Journal of the American Statistical Association, 84, 284–288.

Staniswalis, J. G. and Yandell, B. S. (1992), “Locally adaptive smoothing splines,” Journal of Statistical Computatiion and Simulation, 43, 45–53.

Wahba, G. (1980), “Automatic smoothing of the log periodogram,” Journal of the American Statistical Association, 75, 122–132.

Wand, M., Ormerod, J. T., Padoan, S. A., and Fru¨hwirth, R. (2012), “Mean ﬁeld variational Bayes for elaborate distributions,” Bayesian Analysis, 7, 847–900.

Whittle, P. (1957), “Curve and periodogram smoothing,” Journal of the Royal Statistical Society. Series B (Methodology), 19, 38–63.

Wood, S., Jiang, W., and Tanner, M. (2002), “Bayesian mixture of splines for spatially sdaptive nonparametric regression,” Biometrika, 89, 513–528.

Yue, Y. and Speckman, P. (2010), “Nonstationary spatial Gaussian Markov random ﬁelds,” Journal of Computational and Graphical Statistics, 19, 96–116.

Yue, Y., Speckman, P., and Sun, D. (2012), “Priors for Bayesian adaptive spline smoothing,” Annals of the Institute of Statistical Mathematics, 64, 577–613.

Zhou, S. and Shen, X. (2001), “Spatially adaptive regression splines and accurate knot selection schemes,” Journal of the American Statistical Association, 96, 247–259.


[Page 60]

The derivation of the full conditional distributions for the BPS model is provided in this section.

$$
1.\, & \, Sampling \theta \\ p ( \theta | \sigma ^ { 2 } _ { \epsilon }, \sigma ^ { 2 } _ { b }, y ) \, & \, \infty \, \ p ( y | \beta, b, \sigma ^ { 2 } _ { \epsilon } ) p ( b | \sigma ^ { 2 } _ { b } ) p ( \sigma ^ { 2 } _ { b } ) p ( \sigma ^ { 2 } _ { \epsilon } ) \\ & \, \infty \, \exp \left \{ - \frac { 1 } { 2 \sigma ^ { 2 } _ { \epsilon } } ( y - T \theta ^ { \prime } ) ^ { ( y - T \theta ) } \right \} \times \exp \left \{ - \frac { 1 } { 2 \sigma ^ { 2 } _ { b } } b ^ { \prime } b \right \} \times \exp \left \{ - \frac { 1 } { 2 \sigma ^ { 2 } _ { \beta } } \beta ^ { \prime } \beta \right \} \\ & = \, \exp \left \{ - \frac { 1 } { 2 \sigma ^ { 2 } _ { \epsilon } } ( y - T \theta ^ { \prime } ) ^ { ( y - T \theta ) } - \frac { 1 } { 2 \sigma ^ { 2 } _ { b } } b ^ { \prime } b - \frac { 1 } { 2 \sigma ^ { 2 } _ { \beta } } \beta ^ { \prime } \beta \right \} \\ & = \, \exp \left \{ - \frac { 1 } { 2 \sigma ^ { 2 } _ { \epsilon } } ( y ^ { \prime } - \theta ^ { \prime } T ^ { \prime } ) ( y - T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } D ^ { - 1 } \theta \right \} \\ & = \, \exp \left \{ - \frac { 1 } { 2 \sigma ^ { 2 } _ { \epsilon } } ( y ^ { \prime } y - 2 \theta ^ { \prime } T ^ { \prime } y + \theta ^ { \prime } T ^ { \prime } T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } D ^ { - 1 } \theta \right \} \\ & \quad \times \exp \left \{ - \frac { 1 } { 2 \sigma ^ { 2 } _ { \epsilon } } ( - 2 \theta ^ { \prime } T ^ { \prime } y + \theta ^ { \prime } T ^ { \prime } T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } D ^ { - 1 } \theta \right \} \\ & = \, \exp \left \{ \frac { 1 } { \sigma ^ { 2 } _ { \epsilon } } \theta ^ { \prime } T ^ { \prime } y - \frac { 1 } { 2 \sigma ^ { 2 } _ { \epsilon } } \theta ^ { \prime } T ^ { \prime } T \theta - \frac { 1 } { 2 } \theta ^ { \prime } D ^ { - 1 } \theta \right \} \\ & = \, \exp \left \{ \frac { 1 } { \sigma ^ { 2 } _ { \epsilon } } \theta ^ { \prime } T ^ { \prime } y - \frac { 1 } { 2 } \theta ^ { \prime } \left [ \frac { 1 } { \sigma ^ { 2 } _ { \epsilon } } T ^ { \prime } T + D ^ { - 1 } \right ] \theta \right \} \\ \\ & \quad \times \exp \left \{ \frac { 1 } { 2 } \theta ^ { \prime } T ^ { \prime } y - \frac { - 1 } { 2 } \theta ^ { \prime } \left [ \frac { 1 } { \sigma ^ { 2 } _ { \epsilon } } T ^ { \prime } T + D ^ { - 1 } \right ] \theta ^ { \prime } \right \} \\ & = \, \exp \left \{ \frac { 1 } { 2 } \theta ^ { \prime } T ^ { \prime } y - \frac { - 1 } { 2 } \theta ^ { \prime } \left [ \frac { 1 } { \sigma ^ { 2 } _ { \epsilon } } T ^ { \prime } T + D ^ { - 1 } \right ] \theta ^ { \prime } \right \} \\ & = \, \exp \left \{ \frac { 1 } { 2 } \theta ^ { \prime } T ^ { \prime } y - \frac { 1 } { 2 } \theta ^ { \prime } \left [ \frac { 1 } { \sigma ^ { 2 } _ { \epsilon } } T ^ { \prime } T + D ^ { - 1 } \right ] \theta ^ { \prime } \right \} \\
$$

$$
& \text {Note that } \Sigma _ { \theta } = \left ( \frac { 1 } { \sigma _ { 2 } ^ { 2 } } T ^ { \prime } T + D ^ { - 1 } \right ) ^ { - 1 } = \sigma _ { \epsilon } ^ { 2 } ( T ^ { \prime } T + \sigma _ { \epsilon } ^ { 2 } D ^ { - 1 } ) ^ { - 1 }.\ \text {By solving for } \mu _ { \theta }, \, i.e., \\ & \Sigma _ { \theta } ^ { - 1 } \mu _ { \theta } = \frac { 1 } { \sigma _ { 2 } ^ { 2 } } T ^ { \prime } y \Rightarrow \mu _ { \theta } = \frac { 1 } { \sigma _ { 2 } ^ { 2 } } \Sigma _ { \theta } T ^ { \prime } y .
$$


[Page 61]

$$
p ( \sigma _ { b } ^ { 2 } | y, b, \beta, \sigma _ { \epsilon } ^ { 2 } ) & \quad \infty \quad p ( b | \sigma _ { b } ^ { 2 } ) p ( \sigma _ { b } ^ { 2 } ) \\ & \quad \infty \quad ( \sigma _ { b } ^ { 2 } ) ^ { - \frac { K _ { s } } { 2 } } ( \ \sigma _ { b } ^ { 2 } ) ^ { - ( A _ { b } + 1 ) } \exp \left \{ - \frac { 1 } { 2 \sigma _ { b } ^ { 2 } } \| b \| ^ { 2 } \right \} \times \exp \left \{ - \frac { B _ { b } } { \sigma _ { b } ^ { 2 } } \right \} \\ & = \ ( \ \sigma _ { b } ^ { 2 } ) ^ { - \frac { K _ { s } } { 2 } } ( \ \sigma _ { b } ^ { 2 } ) ^ { - ( A _ { b } + 1 ) } \exp \left \{ - \frac { 1 } { 2 \sigma _ { b } ^ { 2 } } \| b \| ^ { 2 } - \frac { B _ { b } } { \sigma _ { b } ^ { 2 } } \right \} \\ & = \ ( \ \sigma _ { b } ^ { 2 } ) ^ { - ( \frac { K _ { s } } { 2 } + A _ { b } + 1 ) } \exp \left \{ - \frac { 1 } { \sigma _ { b } ^ { 2 } } \left [ \frac { 1 } { 2 } \| b \| ^ { 2 } + B _ { b } \right ] \right \} .
$$

$$
p ( \sigma _ { b } ^ { 2 } | y, b, \beta, \sigma _ { b } ^ { 2 } ) & \quad \approx \ p ( y | \beta, b, \sigma _ { \epsilon } ^ { 2 } ) p ( \sigma _ { \epsilon } ^ { 2 } ) \\ & \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \quad \
$$


[Page 62]

The derivation of the full conditional distributions for the BAPS model is provided in this section.

$$
1.\, & \, Sampling \, \theta \\ p ( \theta | b, \beta, \gamma, \tau, \xi _ { 1 }, y ) \quad \otimes \quad p ( y | b, \theta, \tau ) p ( b | \tau, \xi _ { 1 } ) p ( \beta ) p ( \tau ) p ( \xi _ { 1 } | \rho _ { 1 } ) \\ & \quad \otimes \quad \exp \left \{ - \frac { \tau } { 2 } ( y - T \theta ) ^ { \prime } ( y - T \theta ) \right \} \times \exp \left \{ - \frac { 1 } { 2 } \tau \xi _ { 1 } b ^ { \prime } D, b \right \} \times \exp \left \{ - \frac { 1 } { 2 \sigma _ { 2 } ^ { 3 } } \beta ^ { \prime } \beta \right \} \\ & = \quad \exp \left \{ - \frac { \tau } { 2 } ( y - T \theta ) ^ { \prime } ( y - T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & = \quad \exp \left \{ - \frac { \tau } { 2 } ( y ^ { \prime } - \theta ^ { \prime } T ^ { \prime } ) ( y - T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & = \quad \exp \left \{ - \frac { \tau } { 2 } ( y ^ { \prime } y - 2 \theta ^ { \prime } T ^ { \prime } y + \theta ^ { \prime } T ^ { \prime } T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & \quad \otimes \quad \exp \left \{ - \frac { \tau } { 2 } ( - 2 \theta ^ { \prime } T ^ { \prime } y + \theta ^ { \prime } T ^ { \prime } T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & = \quad \exp \left \{ \tau \theta ^ { \prime } T y - \frac { \tau } { 2 } \theta ^ { \prime } T T \theta - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & = \quad \exp \left \{ \tau \theta ^ { \prime } T y - \frac { 1 } { 2 } \theta ^ { \prime } [ \tau T ^ { \prime } T + \Lambda _ { y } ] \theta \right \} \\ & = \quad \exp \left \{ \tau \theta ^ { \prime } T y - \frac { 1 } { 2 } \theta ^ { \prime } [ \tau T ^ { \prime } T + \Lambda _ { y } ] \theta \right \} \\ & \quad \otimes \quad \exp \left \{ \tau T ^ { \prime } T + \Lambda _ { y } \theta \right \} .
$$

Note that Q θ = ( τT T + Λ y ) − 1.By solving for µ θ, i.e., Q − 1 θ µ θ = τT y ⇒ µ θ = τQ θ T y .

$$
p ( \tau | \gamma, b, \xi _ { 1 }, \xi _ { 2 }, y ) & \quad \otimes \quad p ( y | \beta, b, \tau ) p ( \tau ) p ( b | \tau, \xi _ { 1 } ) p ( b _ { \gamma } | \tau, \xi _ { 1 }, \xi _ { 2 } ) \\ & \quad \otimes \quad \tau ^ { \frac { \hbar { \ell } } { 2 } ( \xi _ { 1 } ) ^ { \frac { 2 } { 2 } } ( \xi _ { 1 } \xi _ { 2 } ) ^ { \frac { K + a } { 2 } - \tau ^ { 1 } } \exp \left \{ - \frac { \tau } { 2 } \| y - T \theta \| ^ { 2 } - \frac { \tau \xi _ { 1 } } { 2 } b ^ { \prime } D, b - \frac { \tau \xi _ { 1 } } { 2 } b ^ { \xi _ { 1 } } _ { \gamma } b ^ { \prime } _ { \gamma } \right \} \\ & \quad \otimes \quad \tau ^ { \frac { n + K _ { s } + K _ { 1 } + a } { 2 } - 1 } \exp \left \{ - \frac { \tau } { 2 } \| y - T \theta \| ^ { 2 } - \frac { \tau \xi _ { 1 } } { 2 } b ^ { \prime } D, b - \frac { \tau \xi _ { 1 } } { 2 } b ^ { \prime }, b \right \} \\ & = \quad \tau ^ { \frac { n } { 2 } ( n + K _ { s } + K _ { 1 } + a ) - 1 } \exp \left \{ - \frac { \left [ 1 } { 2 } \| y - T \theta \| ^ { 2 } + \frac { \xi _ { 1 } } { 2 } b ^ { \prime } D, b + \frac { \xi _ { 1 } \xi _ { 2 } } { 2 } b ^ { \prime } b _ { \gamma } \right ] \right \}, \quad \tau > 0 .
$$


[Page 63]

$$
p ( \xi _ { 1 } | \gamma, b, \tau, \xi _ { 2 } ) & \quad \infty \quad p ( b | \tau, \xi _ { 1 } ) p ( b _ { \gamma } | \tau, \xi _ { 1 }, \xi _ { 2 } ) p ( \xi _ { 1 } | \rho _ { 1 } ) \\ & \quad \infty \quad ( \tau \xi _ { 1 } ) ^ { \frac { K _ { s } } { 2 } } ( \tau \xi _ { 1 } \xi _ { 2 } ) ^ { \frac { K _ { + } a } { 2 } } \exp \left \{ - \frac { \tau \xi _ { 1 } } { 2 } b ^ { \prime } D _ { \gamma } b - \frac { \tau \xi _ { 1 } \xi _ { 2 } } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } - \rho _ { 1 } \xi _ { 1 } \right \} \\ & \quad \infty \quad \xi _ { 1 } ^ { K _ { + } + q } \quad \exp \left \{ - \frac { \tau \xi _ { 1 } } { 2 } b ^ { \prime } D _ { \gamma } b - \frac { \tau \xi _ { 1 } \xi _ { 2 } } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } - \rho _ { 1 } \xi _ { 1 } \right \} \\ & = \quad \xi _ { 1 } ^ { \frac { 1 } { 2 } ( K _ { \tau } + K _ { \ell } + q ) + 1 - 1 } \exp \left \{ - \xi _ { 1 } \left [ \frac { \tau } { 2 } b ^ { \prime } D _ { \gamma } b + \frac { \tau \xi _ { 2 } } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } + \rho _ { 1 } \right ] \right \}, \quad \xi _ { 1 } > 0 .
$$

$$
p ( \xi _ { 2 } | b _ { \gamma }, \tau, \xi _ { 1 }, \rho _ { 2 } ) & \quad \infty \quad p ( b _ { \gamma } | \tau, \xi _ { 1 }, \xi _ { 2 } ) p ( \xi _ { 2 } | \rho _ { 2 } ) \\ & \quad \infty \quad ( \tau \xi _ { 1 } \xi _ { 2 } ) ^ { \frac { K _ { + } + q } { 2 } } \exp \left \{ - \frac { \tau \xi _ { 1 } \xi _ { 2 } } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } - \rho _ { 2 } \xi _ { 2 } \right \} \\ & \quad \infty \quad \xi _ { 2 } ^ { \frac { K _ { + } + q } { 2 } } \exp \left \{ - \frac { \tau \xi _ { 1 } \xi _ { 2 } } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } - \rho _ { 2 } \xi _ { 2 } \right \} \\ & = \quad \xi _ { 2 } ^ { \frac { K _ { + } + q } { 2 } + 1 - 1 } \exp \left \{ - \xi _ { 2 } \left [ \frac { \tau \xi _ { 1 } } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } + \rho _ { 2 } \right ] \right \}, \quad \xi _ { 2 } > 0 .
$$

$$
p ( \rho _ { i } | \xi _ { i }, c _ { i } ) & \quad \infty \quad p ( \xi _ { i } | \rho _ { i } ) p ( \rho _ { i } | c _ { i } ) \\ & \quad \infty \quad \rho _ { i } \exp \left \{ \xi _ { i } \rho _ { i } \right \} \times c _ { i } \exp \left \{ c _ { i } \rho _ { i } \right \} \\ & \quad \infty \quad \rho _ { i } \exp \left \{ - \xi _ { i } \rho _ { i } - c _ { i } \rho _ { i } \right \} \\ & = \quad \rho _ { i } ^ { 2 - 1 } \exp \left \{ - \rho _ { i } [ \xi _ { i } + c _ { i } ] \right \} .
$$

$$
p ( b _ { \gamma } | \gamma, b, \tau, \xi _ { 1 }, \xi _ { 2 } ) & \quad \infty \quad p ( b _ { \gamma } | \tau, \xi _ { 1 }, \xi _ { 2 } ) p ( b | \tau, \xi _ { 1 } ) \\ & \quad \infty \quad \tau \xi _ { 1 } ^ { \frac { K _ { \xi } } { 2 } } \left | D _ { \gamma } \right | ^ { \frac { 1 } { 2 } } \exp \left \{ - \frac { \tau \xi _ { 1 } } { 2 } b ^ { \prime } D _ { \gamma } b \right \} \times \exp \left \{ - \frac { \tau \xi _ { 1 } \xi _ { 2 } } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } \right \} \\ & = \ | D _ { \gamma } | ^ { \frac { 1 } { 2 } } \exp \left \{ - \frac { \tau \xi _ { 1 } } { 2 } b ^ { \prime } D _ { \gamma } b - \frac { \tau \xi _ { 1 } \xi _ { 2 } } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } \right \} .
$$


[Page 64]

Partial derivatives:

$$
P a r t i a l d e r v a t i v e s \colon \\ \log p ( b _ { \gamma } | \gamma, b, \tau, \xi _ { 1 }, \xi _ { 2 } ) \ & = \ \frac { 1 } { 2 } \sum _ { j = 1 } ^ { K _ { \kappa } } z _ { \gamma _ { j } } ^ { \prime } b _ { \gamma } - \frac { 1 } { 2 } \tau \xi _ { 1 } \sum _ { j = 1 } ^ { K _ { \kappa } } b _ { j } ^ { 2 } \exp \{ z _ { \gamma _ { j } } ^ { \prime } b _ { \gamma } \} - \frac { 1 } { 2 } \tau \xi _ { 1 } \xi _ { 2 } b _ { \gamma } ^ { \prime } b _ { \gamma } \\ \frac { \partial \log p ( b _ { \gamma } | \gamma, b, \tau, \xi _ { 1 }, \xi _ { 2 } ) } { \partial b _ { \gamma } } & \ = \ \frac { 1 } { 2 } Z _ { \gamma _ { 1 } } ^ { \prime } 1 - \frac { 1 } { 2 } \tau \xi _ { 1 } \sum _ { j = 1 } ^ { K _ { \kappa } } b _ { j } ^ { \prime } \exp \{ z _ { \gamma _ { j } } ^ { \prime } b _ { \gamma } \} z _ { \gamma _ { j } } - \tau \xi _ { 1 } \xi _ { 2 } b _ { \gamma } \\ \frac { \partial ^ { 2 } \log p ( b _ { \gamma } | \gamma, b, \tau, \xi _ { 1 }, \xi _ { 2 } ) } { \partial b _ { \gamma } \partial b _ { \gamma } ^ { \prime } } & \ = \ - \frac { 1 } { 2 } \tau \xi _ { 1 } \sum _ { j = 1 } ^ { K _ { \kappa } } b _ { j } ^ { 2 } \exp \{ z _ { \gamma _ { j } } ^ { \prime } b _ { \gamma } \} z _ { \gamma _ { j } } z _ { \gamma _ { j } } ^ { \prime } - \tau \xi _ { 1 } \xi _ { 2 } I _ { K _ { \ell } + q }, \\ \intertext { w h o r e } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n g h a t i v e s } \intertext { p a r t i a l d e r v a t i v e s } \intertext { s i n t a i n
$$

where z γ j is the j th row of Z γ.Propose a new value b ∗ γ from N ( ˆ b γ, ˆ Σ b γ ), where ˆ b γ = arg max b γ log p ( b γ | γ, b,τ,ξ 1,ξ 2 ) and

$$
\hat { \Sigma } _ { b _ { \gamma } } = \left [ - \frac { \partial ^ { 2 } \log p ( b _ { \gamma } | \gamma, b, \tau, \xi _ { 1 }, \xi _ { 2 } ) } { \partial b _ { \gamma } \partial b _ { \gamma } ^ { \prime } } | _ { b _ { \gamma } = \hat { b } _ { \gamma } } \right ] ^ { - 1 } .
$$

Accept the new value via

$$
b _ { \gamma } ^ { ( t + 1 ) } = \begin{cases} \ b _ { \gamma } ^ { * } & \text {with probability $\alpha_{\gamma}$} \\ \ b _ { \gamma } ^ { ( t ) } & \text {with probability $1-\alpha_{\gamma}$}, \end{cases}
$$

with acceptance probability

$$
\alpha _ { b _ { \gamma } } = \min \left \{ \frac { \pi ( b _ { \gamma } ^ { * } | \gamma, b, \tau, \xi _ { 1 }, \xi _ { 2 } ) g ( b _ { \gamma } ^ { ( t ) } | b _ { \gamma } ^ { * } ) } { \pi ( b _ { \gamma } ^ { ( t ) } | \gamma, b, \tau, \xi _ { 1 }, \xi _ { 2 } ) g ( b _ { \gamma } ^ { * } | b _ { \gamma } ^ { ( t ) } ) }, 1 \right \},
$$

such that π ( b γ | γ, b,τ,ξ 1,ξ 2 ) = p ( b γ | γ, b,τ,ξ 1,ξ 2 ) and g ( b ∗ γ | b ( t ) γ ) is the proposal density for b ∗ γ, i.e., N ( ˆ b γ, ˆ Σ b γ ) .


[Page 65]

The derivation of the full conditional distributions for the BAPS model for spectral analysis is provided in this section.

$$
p ( \theta | I, C ) & \ \ \infty \ \ p ( y | f ) \times p ( \theta ) \\ & \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
$$

where c m is the m th row of C .

Partial derivatives:

$$
\text {critical derivatives} \colon & & \log p ( \theta | I, C ) \ = \ \sum _ { m = 1 } ^ { M } [ c ^ { \prime } _ { m } \theta - I _ { m } ( \omega ) \exp ( c ^ { \prime } _ { m } \theta ) ] - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda \theta \\ & & \frac { \partial \log p ( \theta | I, C ) } { \partial \theta } \ = \ \sum _ { m = 1 } ^ { M } [ c _ { m } - I _ { m } ( \omega ) \exp ( c ^ { \prime } _ { m } \theta ) c _ { m } ] - \Lambda \theta \\ & & \frac { \partial ^ { 2 } \log p ( \theta | I, C ) } { \partial \theta \partial \theta ^ { \prime } } \ = \ - \sum _ { m = 1 } ^ { M } [ I _ { m } ( \omega ) \exp ( c ^ { \prime } _ { m } \theta ) c _ { m } c ^ { \prime } _ { m } ] - \Lambda \\ & & \text {sorted Partial derivatives} .
$$

Vectorized Partial derivatives:

$$
\begin{array} { r l } & { o r z e d \, P a r t i a l d e r v a t i v e s \colon } \\ & { \quad \log p ( \theta | I, C ) \ = \ \sum _ { m = 1 } ^ { M } [ C \theta - \exp ( C \theta ) I _ { m } ( \omega ) ] - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda \theta } \\ & { \quad \frac { \partial \log p ( \theta | I, C ) } { \partial \theta } \ = \ C ^ { \prime } ( 1 - I * \exp ( C \theta ) ) - \Lambda \theta } \\ & { \frac { \partial ^ { 2 } \log p ( \theta | I, C ) } { \partial \theta \partial \theta ^ { \prime } } \ = \ - C ^ { \prime } d i a g \{ I _ { m } ( \omega ) \exp ( C \theta ) \} C - \Lambda, } \end{array}
$$

$$
\partial \theta \partial \theta ^ { \prime }
$$

where ∗ is the entrywise product of two matrices of the same dimension. Propose a new value θ ∗ from N ( ˆ θ, ˆ Σ θ ), where ˆ θ = arg max θ log p ( θ | I,C ) and

$$
\hat { \Sigma } _ { \theta } = \left [ - \frac { \partial ^ { 2 } \log p ( \theta | I, C ) } { \partial \theta \partial \theta ^ { \prime } } | _ { \theta = \hat { \theta } } \right ] ^ { - 1 } .
$$


[Page 66]

Accept the new value via

$$
\theta ^ { ( t + 1 ) } = \begin{cases} \ \theta ^ { * } & \text {with probability $\alpha_{\theta}$} \\ \ \theta ^ { ( t ) } & \text {with probability $1-\alpha_{\theta}$}, \end{cases}
$$

with acceptance probability

$$
\alpha _ { \theta } = \min \left \{ \frac { \pi ( \theta ^ { * } | I, C ) g ( \theta ^ { ( t ) } | \theta ^ { * } ) } { \pi ( \theta ^ { ( t ) } | I, C ) g ( \theta ^ { * } | \theta ^ { ( t ) } ) }, 1 \right \}
$$

such that π ( θ | I,C ) = p ( θ | I,C ) and g ( θ ∗ | θ ( t ) ) is the proposal density for θ ∗, i.e., N ( ˆ θ, ˆ Σ θ ) .

$$
p ( b _ { \gamma } | \gamma, b, \eta, \delta ) & \quad \infty \quad p ( b _ { \gamma } | \eta ) p ( b | \delta ) p ( \delta | g _ { 1 } ) \\ & \quad \infty \quad \delta ^ { \frac { K _ { s } } { 2 } } | D _ { \gamma } | ^ { \frac { 1 } { 2 } } \exp \left \{ - \frac { \delta } { 2 } b ^ { \prime } D _ { \gamma } b \right \} \times \exp \left \{ - \frac { \eta } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } \right \} \\ & = \ \left | D _ { \gamma } \right | ^ { \frac { 1 } { 2 } } \exp \left \{ - \frac { \delta } { 2 } b ^ { \prime } D _ { \gamma } b - \frac { \eta } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } \right \} .
$$

Partial derivatives:

$$
P a r t i a l \ d e r i v a t i v e s \colon \\ \log p ( b _ { \gamma } | \gamma, b, \eta, \delta ) \ = \ \frac { 1 } { 2 } \sum _ { j = 1 } ^ { K _ { \kappa } } z _ { \gamma _ { j } } ^ { \prime } b _ { \gamma } - \frac { 1 } { 2 } \delta \sum _ { j = 1 } ^ { K _ { \kappa } } b _ { j } ^ { 2 } \exp \{ z _ { \gamma _ { j } } ^ { \prime } b _ { \gamma } \} - \frac { 1 } { 2 } \eta b _ { \gamma } ^ { \prime } b _ { \gamma } \\ \frac { \partial \log p ( b _ { \gamma } | \gamma, b, \eta, \delta ) } { \partial b _ { \gamma } } \ = \ \frac { 1 } { 2 } Z _ { \gamma _ { 1 } } ^ { \prime } 1 - \frac { 1 } { 2 } \delta \sum _ { j = 1 } ^ { K _ { \kappa } } b _ { j } ^ { 2 } \exp \{ z _ { \gamma _ { j } } ^ { \prime } b _ { \gamma } \} z _ { \gamma _ { j } } - \eta b _ { \gamma } \\ \frac { \partial ^ { 2 } \log p ( b _ { \gamma } | \gamma, b, \eta, \delta ) } { \partial b _ { \gamma } \partial b _ { \gamma } ^ { \prime } } \ = \ - \frac { 1 } { 2 } \delta \sum _ { j = 1 } ^ { K _ { \kappa } } b _ { j } ^ { 2 } \exp \{ z _ { \gamma _ { j } } ^ { \prime } b _ { \gamma } \} z _ { \gamma _ { j } } z _ { \gamma _ { j } } ^ { \prime } - \eta I _ { K _ { \imath } + q } \\ \text {where } z _ { \gamma _ { j } } \text { is the } \text {th row of } Z _ { \gamma _ { j } } \text { .} \text {Propose a new value } b _ { \kappa } ^ { * } \text { from } N ( \hat { b } _ { \gamma, \hat { \Sigma } _ { h } } ) \text {, where}
$$

where z γ j is the j th row of Z γ.Propose a new value b ∗ γ from N ( ˆ b γ, ˆ Σ b γ ), where ˆ b γ = arg max b γ log p ( b γ | γ, b,η,δ ) and

$$
\hat { \Sigma } _ { b _ { \gamma } } = \left [ - \frac { \partial ^ { 2 } \log p ( b _ { \gamma } | \gamma, b, \eta, \delta ) } { \partial b _ { \gamma } \partial b _ { \gamma } ^ { \prime } } | _ { b _ { \gamma } = \hat { b } _ { \gamma } } \right ] ^ { - 1 } .
$$

Accept the new value via

$$
b _ { \gamma } ^ { ( t + 1 ) } = \begin{cases} \ b _ { \gamma } ^ { * } & \text {with probability $\alpha_{\gamma}$} \\ \ b _ { \gamma } ^ { ( t ) } & \text {with probability $1-\alpha_{\gamma}$}, \end{cases}
$$


[Page 67]

with acceptance probability

$$
\alpha _ { b _ { \gamma } } = \min \left \{ \frac { \pi ( b _ { \gamma } ^ { * } | \gamma, b, \eta, \delta ) g ( b _ { \gamma } ^ { ( t ) } | b _ { \gamma } ^ { * } ) } { \pi ( b _ { \gamma } ^ { ( t ) } | \gamma, b, \eta, \delta ) g ( b _ { \gamma } ^ { * } | b _ { \gamma } ^ { ( t ) } ) }, 1 \right \},
$$

such that π ( b γ | γ, b,η,δ ) = p ( b γ | γ, b,η,δ ) and g ( b ∗ γ | b ( t ) γ ) is the proposal density for b ∗ γ, i.e., N ( ˆ b γ, ˆ Σ b γ ) .

$$
p ( \delta | b, \gamma, g _ { 1 } ) & \quad \infty \ \ p ( b | \gamma, \delta ) p ( \delta | g _ { 1 } ) \\ & \quad \ \alpha \ \delta ^ { \frac { K _ { s } } { 2 } } | D _ { \gamma } | ^ { 2 } \exp \left \{ - \frac { \delta } { 2 } b ^ { \prime } D, b \right \} \times ( \delta ^ { - 1 } ) ^ { - ( \frac { \lambda _ { 1 } } { 2 } + 1 ) } \exp \left \{ - \frac { \nu _ { 1 } \delta } { g _ { 1 } } \right \} \\ & \quad \ \alpha \ \delta ^ { \frac { K _ { s } } { 2 } } \exp \left \{ - \frac { \delta } { 2 } b ^ { \prime } D _ { \gamma } b \right \} \times ( \delta ^ { - 1 } ) ^ { - ( \frac { \lambda _ { 1 } } { 2 } + 1 ) } \exp \left \{ - \frac { \nu _ { 1 } \delta } { g _ { 1 } } \right \} \\ & = \ \delta ^ { \frac { K _ { s } } { 2 } } ( \delta ^ { - 1 } ) ^ { - ( \frac { 1 } { 2 } + 1 ) } \exp \left \{ - \frac { \delta } { 2 } b ^ { \prime } D _ { \gamma } b \right \} \times \exp \left \{ - \frac { \nu _ { 1 } \delta } { g _ { 1 } } \right \} \\ & = \ \delta ^ { \frac { K _ { s } + \frac { \nu _ { 1 } } { 2 } - 1 } { 2 } } \exp \left \{ - \frac { \delta } { 2 } b ^ { \prime } D _ { \gamma } b - \frac { \nu _ { 1 } \delta } { g _ { 1 } } \right \} \\ & = \ \delta ^ { \frac { K _ { s } + \frac { \nu _ { 1 } } { 2 } - 1 } { 2 } } \exp \left \{ - \delta \left [ \frac { 1 } { 2 } b ^ { \prime } D _ { \gamma } b + \frac { \nu _ { 1 } } { g _ { 1 } } \right ] \right \}, \quad \delta > 0.\\
$$

$$
p ( g _ { 1 } | \delta ) & \quad \infty \quad p ( \delta | g _ { 1 } ) p ( g _ { 1 } ) \\ & \quad \times \quad \frac { ( \nu _ { 1 } / g _ { 1 } ) ^ { \frac { \nu _ { 1 } } { 2 } } } { \Gamma ( \nu _ { 1 } / 2 ) } \exp \left \{ - \frac { \nu _ { 1 } \delta } { g _ { 1 } } \right \} \times g _ { 1 } ^ { - \frac { 3 } { 2 } } \exp \left \{ - \frac { 1 } { G _ { 1 } ^ { 2 } g _ { 1 } } \right \} \\ & \quad \times \quad g _ { 1 } ^ { - \frac { \nu _ { 1 } } { 2 } } g _ { 1 } ^ { - \frac { 3 } { 2 } } \exp \left \{ - \frac { \nu _ { 1 } \delta } { g _ { 1 } } - \frac { 1 } { G _ { 1 } ^ { 2 } g _ { 1 } } \right \} \\ & = \quad g _ { 1 } ^ { - \frac { \nu _ { 1 } - \frac { 3 } { 2 } } { 2 } } \exp \left \{ - \frac { \nu _ { 1 } \delta } { g _ { 1 } } - \frac { 1 } { G _ { 1 } ^ { 2 } g _ { 1 } } \right \} \\ & = \quad g _ { 1 } ^ { - ( \frac { \nu _ { 1 } + 1 } { 2 } + 1 ) } \exp \left \{ - \frac { 1 } { g _ { 1 } } \left [ \nu _ { 1 } \delta + \frac { 1 } { G _ { 1 } ^ { 2 } } \right ] \right \}, \quad g _ { 1 } > 0 .
$$


[Page 68]

$$
p ( \eta | b _ { \gamma }, g _ { 2 } ) & \quad \infty \quad p ( b _ { \gamma } | \delta ) p ( \eta | g _ { 2 } ) p ( g _ { 2 } ) \\ & \quad \infty \quad \eta ^ { \frac { K _ { \gamma + a } + a } { 2 } } \exp \left \{ - \frac { \eta } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } \right \} \times ( \eta ^ { - 1 } ) ^ { - ( \frac { \nu _ { 2 } + 1 } { 2 } ) } \exp \left \{ - \frac { \nu _ { 2 } \eta } { g _ { 2 } } \right \} \\ & = \ \eta ^ { \frac { K _ { \gamma + a } + a } { 2 } } ( \eta ^ { - 1 } ) ^ { - ( \frac { \nu _ { 2 } + 1 } { 2 } ) } \exp \left \{ - \frac { \eta } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } - \frac { \nu _ { 2 } \eta } { g _ { 2 } } \right \} \\ & = \ \eta ^ { \frac { K _ { \gamma + a } + \nu _ { 2 } - 1 } { 2 } } \exp \left \{ - \frac { \eta } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } - \frac { \nu _ { 2 } \eta } { g _ { 2 } } \right \} \\ & = \ \eta ^ { \frac { K _ { \gamma + a } + \nu _ { 2 } - 1 } { 2 } } \exp \left \{ - \eta \left [ \frac { 1 } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } + \frac { \nu _ { 2 } } { g _ { 2 } } \right ] \right \}, \quad \eta > 0 .
$$

$$
p ( g _ { 2 } | \eta ) & \quad \infty \quad p ( \eta | g _ { 2 } ) p ( g _ { 2 } ) \\ & \quad \infty \quad \frac { ( \nu _ { 2 } / g _ { 2 } ) ^ { \frac { \nu _ { 2 } } { 2 } } } { \Gamma ( \nu _ { 2 } / 2 ) } \exp \left \{ - \frac { \nu _ { 2 } \eta } { g _ { 2 } } \right \} \times g _ { 2 } ^ { - \frac { 3 } { 2 } } \exp \left \{ - \frac { 1 } { G _ { 2 } ^ { 2 } g _ { 2 } } \right \} \\ & \quad \times \quad g _ { 2 } ^ { - \frac { \nu _ { 2 } } { 2 } } g _ { 2 } ^ { - \frac { 3 } { 2 } } \exp \left \{ - \frac { \nu _ { 2 } \eta } { g _ { 2 } } - \frac { 1 } { G _ { 2 } ^ { 2 } g _ { 2 } } \right \} \\ & = \quad g _ { 2 } ^ { - \frac { \nu _ { 2 } } { 2 } - \frac { 3 } { 2 } } \exp \left \{ - \frac { \nu _ { 2 } \eta } { g _ { 1 } } - \frac { 1 } { G _ { 2 } ^ { 2 } g _ { 2 } } \right \} \\ & = \quad g _ { 2 } ^ { - \frac { ( \nu _ { 2 } + 1 } { 2 } + 1 ) } \exp \left \{ - \frac { 1 } { g _ { 2 } } \left [ \nu _ { 2 } \eta + \frac { 1 } { G _ { 2 } ^ { 2 } } \right ] \right \}, \quad g _ { 2 } > 0 .
$$


[Page 69]

The notation mt and ms in the following code refers to the K κ and K ι knots, respectively.

library(MASS) library(SemiPar) library(MCMCpack) k = 40 data(lidar) x = lidar$range y = lidar$logratio n=length(y) N=10000 degp=1 knots = quantile(unique(x), seq(0,1, length=(k+2))[-c(1,(k+2))]) dimnames(X) = NULL Z = outer(x, knots, "-") Z = Z*(Z>0) Z=Z^degp dimnames(Z) <NULL X=matrix(1,nrow=n, ncol=degp+1) for(p in 1:degp){ X[,p+1]=x^p } C=cbind(X,Z) CT=t(C) B=CT%*%C betav=10000 gamma=matrix(0, nrow=N+1, ncol=k+degp+1) vare=matrix(1, nrow=N+1, ncol=1) varu=matrix(1, nrow=N+1, ncol=1) Au=0


[Page 70]

Bu=0 Aupost=(k/2)+Au Ae=0 Be=0 Aepost=(n/2) + Ae for(i in 1:N){ print(i) D_inv=diag(c(rep(1/betav,degp+1),rep(1/varu[i],k))) gam=(B/vare[i])+D_inv sigma=solve(gam,diag(k+degp+1),tol=10^-50) mu=(sigma%*%CT%*%y)/vare[i] gamma[i+1,]=mvrnorm(1, mu, sigma) #Sample from inverse gamma of random effects U=gamma[i+1,(degp+2):(k+degp+1)] Bupost=Bu +0.5*(t(U)%*%U) varu[i+1]=rinvgamma(1,Aupost,Bupost) #Sample from inverse gamma of residuals G=gamma[i+1,] W=y-C%*%G Bepost=Be + 0.5*(t(W)%*%W) vare[i+1]=rinvgamma(1,Aepost,Bepost) } burn=2000 gammapost=apply(gamma[burn:N,],2,mean) fit1=C%*%gammapost #Credible Intervals gammaa=gamma[burn:N,] fitss=matrix(0, nrow=(N-burn+1),ncol=n) for(b in 1:(N-burn+1)){ fitss[b,]=C%*%gamma[b,] } ci=apply(fitss,2, quantile,c(0.025,0.975)) lines(x, ci[1,], lty=4,lwd=1) lines(x, ci[2,], lty=4,lwd=1) #Plot plot(x,y,col=6) lines(x,fit1,lwd=2,col=4) lines(x, ci[1,], lty=3,lwd=2,) lines(x, ci[2,], lty=3,lwd=2)


[Page 71]

#Functions###################################### #Natural Spline ============================== #t=seq(0,1, length=n) # B=c(20,4,6,11,6) # nudos=c(0,0.2,0.6,0.7) # Z=ns(t, knots=nudos, Boundary.knots=c(0,1)) # func=Z%*%B # y=func+rnorm(n,0,.9) #Hump function ============================== t=seq(-2,2,length=n) y=sin(t)+2*exp(-30*t^2)+ rnorm(n,0,0.3) ############################################### mt=40 ms=10 degp=2 degq=1 mss=ms+degq #t knots tknots = quantile(unique(t), seq(0,1, length=(mt+2))[-c(1,(mt+2))]) Z = outer(t, tknots, "-") Z = Z*(Z>0) Z=Z^degp dimnames(Z)=NULL #s knots sknots = quantile(unique(tknots), seq(0,1, length=(ms+2))[-c(1,(ms+2))]) sknots=c(0,sknots) #sknots=sort(sknots, decreasing=FALSE) Z_gamma = outer(tknots, sknots, "-") Z_gamma = Z_gamma*(Z_gamma>0) Z_gamma=Z_gamma^degq dimnames(Z_gamma)=NULL ##For degq==0 Piecewise constants################################ #tknots = quantile(unique(t), seq(0,1, length=(mt+2))[-c(1,(mt+2))]) #Z=matrix(0,nrow=n,ncol=mt) #for(a in 1:mt){ Z[,a]=t-tknots[a] #} #Z=Z*(Z>0) #Z=Z^degp #sknots = quantile(unique(tknots), seq(0,1, length=(ms+2))[-c(1,(ms+2))])


[Page 72]

#Z_gamma=matrix(0,nrow=mt,ncol=mss) #for(k in 1:mss){ # Z_gamma[,k]=tknots>sknots[k] #} ############################################################## #Data preparation betasqrt=100 c=c(1,1) X=matrix(1,nrow=n, ncol=degp+1) for(d in 1:degp){ X[,d+1]=t^d } T=cbind(X,Z) Ttran=t(T) R=Ttran%*%T theta=matrix(1, nrow=N+1, ncol=mt+degp+1) tau=matrix(1, nrow=N+1, ncol=1) xi=matrix(1, nrow=2, ncol=N+1) rho=matrix(1, nrow=2, ncol=N+1) b_gamma=matrix(0,nrow=N+1, ncol=mss) alpha=c() trustobj=function(param,b,tau,xi1,xi2,Z_gamma){ gamma=Z_gamma%*%param e=exp(gamma) D_gamma=diag(c(e)) one=rep(1,mt) sum1=matrix(0, nrow=mss, ncol=1) sum2=matrix(0,mss,mss) for(j in 1:mt){ coef=as.vector(exp(t(Z_gamma[j,])%*%param)) sum1=sum1 + (b[j]^2)*coef*Z_gamma[j,] sum2=sum2 + (b[j]^2)*coef*Z_gamma[j,]%*%t(Z_gamma[j,]) } f=0.5*(sum(gamma)-tau*xi1*t(b)%*%D_gamma%*%b-tau*xi1*xi2*t(param)%*%param) g=0.5*t(Z_gamma)%*%one -0.5*tau*xi1*sum1-tau*xi1*xi2*param H=-0.5*tau*xi1*sum2-tau*xi1*xi2*diag(mss) list(value = f, gradient = g, hessian = H) } for(i in 1:N){ print(i) gamma=Z_gamma%*%b_gamma[i,] e=exp(gamma)


[Page 73]

D_gamma=diag(c(e)) para=tau[i]*xi[1,i] Lamda_y=diag(c(rep(1/betasqrt, degp+1), para*e)) Q_theta=tau[i]*R + Lamda_y Q_theta_inv=chol2inv(chol(Q_theta)) #solve(Q_theta,tol=1.6912e-45) mu_theta=tau[i]*(Q_theta_inv%*%Ttran%*%y) #Drawing theta theta[i+1,]=mvrnorm(1,mu_theta, Q_theta_inv) #Drawing tau b=theta[i+1,(degp+2):(mt+degp+1)] U=theta[i+1,] V=y-T%*%U BDB=t(b)%*%D_gamma%*%b Bsqr=t(b_gamma[i,])%*%b_gamma[i,] tau_shape=0.5*(n+mt+mss) tau1=t(V)%*%V tau2=xi[1,i]*(BDB) tau3=xi[1,i]*xi[2,i]*(Bsqr) tau_rate=0.5*(tau1+tau2+tau3) tau[i+1]=rgamma(1, tau_shape,scale=1/tau_rate) #Drawing xi1 xi1_shape=0.5*(mt+mss)+1 xi11=0.5*tau[i+1]*(BDB) xi12=0.5*tau[i+1]*xi[2,i]*(Bsqr) xi1_rate=xi11+xi12+rho[1,i] xi[1,i+1]=rgamma(1,xi1_shape, scale=1/xi1_rate) #Drawing xi2 xi2_shape=0.5*(mss) + 1 xi2_rate=0.5*(tau[i+1]*xi[1,i+1]*Bsqr) +rho[2,i] xi[2,i+1]=rgamma(1,xi2_shape, scale=1/xi2_rate) #Drawing rho_1 and rho_2 rho1_rate=xi[1,i+1] + c[1] rho[1,i+1]=rgamma(1, 2, scale=1/rho1_rate) rho2_rate=xi[2,i+1] + c[2] rho[2,i+1]=rgamma(1, 2,scale=1/rho2_rate) m=trust(trustobj,parinit=rep(0,mss),b=theta[i+1,(degp+2):(mt+degp+1)],tau=tau[i+1],xi1=xi[1,i+1],xi2=xi[2,i+1], Z_gamma=Z_gamma,blather=TRUE,rinit=100,rmax=100,minimize=FALSE) b_gamma_max=m$argument H=m$hessian b_gamma[i+1,]=mvrnorm(1,b_gamma_max,-solve(H)) #Metropolis-Hastings Drawing b_gamma


[Page 74]

gamma_prop=Z_gamma%*%b_gamma[i+1,] D_gamma_prop=diag(c(exp(gamma_prop))) log_proposal_curr=-0.5*(t(b_gamma[i,]-b_gamma_max)%*%(-H)%*%(b_gamma[i,]-b_gamma_max)) log_proposal_prop=-0.5*(t(b_gamma[i+1,]-b_gamma_max)%*%(-H)%*%(b_gamma[i+1,]-b_gamma_max)) log_lik_gamma_curr=0.5*(sum(gamma)tau[i+1]*xi[1,i+1]*t(b)%*%D_gamma%*%b-tau[i+1]*xi[1,i+1]*xi[2,i+1]*(t(b_gamma[i,])%*%b_gamma[i,])) log_lik_gamma_prop=0.5*(sum(gamma_prop)tau[i+1]*xi[1,i+1]*t(b)%*%D_gamma_prop%*%b-tau[i+1]*xi[1,i+1]*xi[2,i+1]*(t(b_gamma[i+1,])%*%b_gamma[i+1,])) M_H_ratio=log_lik_gamma_prop+log_proposal_curr-log_lik_gamma_curr-log_proposal_prop alpha[i]=min(c(1,exp(M_H_ratio))) u=runif(1) if(u > alpha[i]){ b_gamma[i+1,] = b_gamma[i,] } } #mean(alpha) burnin=2000 theta_post=apply(theta[burnin:N,], 2, mean) BAPS_fit=T%*%theta_post #Plots############################ plot(t,y,type="n") # lines(t,sin(t)+2*exp(-30*t^2), lty=1) #lines(t,func) lines(x,BAPS_fit,lty=2,col=’red’) #Credible Intervals################# burn=2000 theta1=theta[burn:N,] fits=matrix(0, nrow=(N-burn+1),ncol=n) for(b in 1:(N-burn+1)){ fits[b,]=T%*%theta1[b,] } ci=apply(fits,2, quantile,c(0.025,0.975)) lines(t, ci[1,], lty=4,lwd=1) lines(t, ci[2,], lty=4,lwd=1)

library(TSA)


[Page 75]

library(tseries) library(trust) library(MASS) library(MCMCpack) library(mvtnorm) library(mnormt) dat=scan("/Users/luismora/Desktop/thesisdata.txt") dat=dat-mean(dat) #Trough Spectral Density: phi=c(0.1,0.4)################## #Peak Spectral Density: phi=c(1.5, -0.75)################# phi=c(0.1,0.4) ts=arima.sim(model=list(ar=phi),n) y=ts-mean(ts) #True Spectral Density for AR(2) process################## phi1=phi[1]^2 phi2=phi[2]^2 truesd=(1^2)/(1+phi1 + phi2 2*phi[1]*(1-phi[2]) *cos(2*pi*f)-2*phi[2]*cos(4*pi*f)) #################################################### n=length(dat)# or length(y) plot(dat,type="l") M=floor((n-1)/2);M tran=fft(dat)/sqrt(n);tran I=as.vector(abs(tran)^2) A=I[2:(M+1)] length(A) plot(A,type=’l’) f=(1:M)/n #################################################### N=2000 burn=500 mt=30 degp=2 ######################################################################### When using cosine basis functions, let degp == 0 ######################################################################### #Data========================================== # X=matrix(1,nrow=M, ncol=degp+1) # for(k in 1:degp){ # X[,k+1]=x^k # } #t knots tknots = quantile(unique(f), seq(0,1, length=(mt+2))[-c(1,(mt+2))])


[Page 76]

Z=matrix(0,nrow=M,ncol=mt) for(s in 1:mt){ Z[,s]=f-tknots[s] } Z=Z*(Z>0) Z=Z^degp # X=cbind(rep(1,M),f,f^2) C=cbind(X,Z) # # C=matrix(1,nrow=length(f), ncol=(mt+1)) # for(j in 2:(mt+1)){ # C[,j]=sqrt(2)*(cos((j-1)*pi*f)/(pi*(j-1))) # } # dim(C) #========================================================= trustthe=function(the,Lambday,D,P){ f=sum(D%*%theexp(D%*%the)*P) 0.5*t(the)%*%Lambday%*%the g=t(D)%*%(1P*exp(D%*%the)) Lambday%*%the h=-t(D)%*%diag(as.vector(P*exp(D%*%the)))%*%D Lambday list(value = f, gradient = g, hessian = h) } #Fixed Parameters======================================== G=10^5 nu=2 #Parameters============================================== theta=matrix(1,nrow=N+1,ncol=mt+degp+1) delta=matrix(1,nrow=N+1,ncol=1) g1=matrix(1,nrow=N+1, ncol=1) alpha1=c() sigmasqrt=100 gshape=0.5*(nu+1) delta.a=0.5*(mt+nu) for(i in 1:N){ print(i) Lamda_y=diag(c(rep(1/sigmasqrt,degp+1), rep(delta[i],mt))) z=trust(trustthe,parinit=rep(0,mt+degp+1), Lambday=Lamda_y,D=C,P=A, blather=TRUE,rinit=100,rmax=100,minimize=FALSE) thetamax=z$argument h=-z$hessian #Drawing thetA theta[i+1,]=mvrnorm(1,thetamax,chol2inv(chol(h))) #Metropolis-Hastings Step


[Page 77]

whittle_lik_curr=sum(C%*%theta[i,]exp(C%*%theta[i,])*A) 0.5*t(theta[i,])%*%Lamda_y%*%theta[i,] whittle_lik_pro=sum(C%*%theta[i+1,]exp(C%*%theta[i+1,])*A) 0.5*t(theta[i+1,])%*%Lamda_y%*%theta[i+1,] proposal_theta_curr= -0.5*(t(theta[i,] thetamax)%*%(h)%*%(theta[i,] thetamax)) proposal_theta_prop= -0.5*(t(theta[i+1,] thetamax)%*%(h)%*%(theta[i+1,] thetamax)) MH_ratio= whittle_lik_pro + proposal_theta_curr whittle_lik_curr proposal_theta_prop alpha1[i]=min(c(1,exp(MH_ratio))) u1=runif(1) if(u1 > alpha1[i]){ theta[i+1,] = theta[i,] } b=theta[i+1,(2+degp):(mt+degp+1)] #When using Cosine Basis : theta[i+1,2:(mt+1)] #Drawing delta and g1 delta.b=0.5*t(b)%*%b + nu/g1[i] delta[i+1]=rgamma(1,shape=delta.a,scale=1/delta.b) g1b=nu*delta[i+1] + (1/G)^2 g1[i+1]=1/rgamma(1,shape=gshape,scale=1/g1b) } k=kernel(’daniell’,m=25) s=spec(dat, kernel=k, ci.plot=TRUE, ci.col=NULL,log=’yes’,demean=FALSE) lines(s$freq,log(s$spec),lty=3,lwd=2) lines(s$freq,log(s$spec)+log(102/qchisq(.025,102)),col="navy",lty=4,lwd=1) lines(s$freq,log(s$spec)+log(102/qchisq(.975,102)),col="navy",lty=4,lwd=1) #Plots and Fit####################################### mean(alpha1) theta_post=apply(theta[burn:N,], 2, mean) fit=-C%*%theta_post plot(f,log(A),lwd=0.5) lines(f,fit,lty=6,lwd=1) #Credible Intervals################################### theta1=theta[burn:N,] fits=matrix(0, nrow=(N-burn+1),ncol=M) for(h in 1:(N-burn+1)){ fits[h,]=-C%*%theta1[h,] } cii=apply(fits,2, quantile,c(0.025,0.975)) lines(f, cii[1,],lty=3,lwd=1) lines(f, cii[2,],lty=3,lwd=1)

#===============================================


[Page 78]

N=2000 burn=500 mt=50 ms=15 degp=2 degq=0 df=4 mss=ms+degq ######################################################################### When using cosine basis functions, let degp == 0 ######################################################################### #Data========================================== # X=rep(1,M) # t knots # tknots = quantile(unique(f), seq(0,1, length=(mt+2))[-c(1,(mt+2))]) # Z = outer(f, tknots, "-") # Z = Z*(Z>0) # Z=Z^degp # dimnames(Z)=NULL # Z=matrix(0,nrow=M,ncol=mt) # for(s in 1:mt){ # Z[,s]=f-tknots[s] # } # Z=Z*(Z>0) # Z=Z^degp tknots = quantile(unique(f), seq(0,1, length=(mt+2))[-c(1,(mt+2))]) Z=matrix(0,nrow=M,ncol=mt) for(a in 1:mt){ Z[,a]=f-tknots[a] } Z=Z*(Z>0) Z=Z^degp #s knots sknots = quantile(unique(tknots), seq(0,1, length=(ms+2))[-c(1,(ms+2))]) # # sknots=c(0,sknots) # Z_gamma = outer(tknots, sknots, "-") # Z_gamma = Z_gamma*(Z_gamma>0) # # Z_gamma=Z_gamma^degq # dimnames(Z_gamma)=NULL # Z_gamma Z_gamma=matrix(0,nrow=mt,ncol=mss) for(k in 1:mss){


[Page 79]

Z_gamma[,k]=tknots>sknots[k] } #Truncated Polynomials # X=matrix(1,nrow=M, ncol=degp+1) # for(k in 1:degp){ # X[,k+1]=x^k # } X=cbind(rep(1,M),f,f^2) C=cbind(X,Z) #Cosine Basis Functions # C=matrix(1,nrow=length(f), ncol=(mt+1)) # for(j in 2:(mt+1)){ # C[,j]=sqrt(2)*(cos((j-1)*pi*f)/(pi*(j-1))) # } #========================================================= trustthe=function(the,Lambday,D,P){ f=sum(D%*%theexp(D%*%the)*P) 0.5*t(the)%*%Lambday%*%the g=t(D)%*%(1P*exp(D%*%the)) Lambday%*%the h=-t(D)%*%diag(as.vector(P*exp(D%*%the)))%*%D Lambday list(value = f, gradient = g, hessian = h) } trustgam=function(param,b,del,et,Z_gamma){ gamma=Z_gamma%*%param e=exp(gamma) D_gamma=diag(c(e)) one=rep(1,mt) sum1=matrix(0, nrow=mss, ncol=1) sum2=matrix(0,mss,mss) for(j in 1:mt){ coef=as.vector(exp(t(Z_gamma[j,])%*%param)) sum1=sum1 + (b[j]^2)*coef*Z_gamma[j,] sum2=sum2 + (b[j]^2)*coef*Z_gamma[j,]%*%t(Z_gamma[j,]) } f=0.5*(sum(gamma)del*t(b)%*%D_gamma%*%bet*t(param)%*%param) g=0.5*t(Z_gamma)%*%one 0.5*del*sum1-et*param h=-0.5*del*sum2 et*diag(mss) list(value = f, gradient = g, hessian = h) } #Fixed Parameters======================================== G=10^5 nu=2 #Parameters==============================================


[Page 80]

theta=matrix(1,nrow=N+1,ncol=mt+degp+1) b_gamma=matrix(1,nrow=N+1,ncol=mss) delta=matrix(1,nrow=N+1,ncol=1) g1=matrix(1,nrow=N+1, ncol=1) g2=matrix(1,nrow=N+1, ncol=1) eta=matrix(1,nrow=N+1,ncol=1) alpha1=c() alpha2=c() sigamsqr=100 gshape=0.5*(nu+1) eta.a=0.5*(mss+nu) delta.a=0.5*(mt+nu) for(i in 1:N){ print(i) gamma=Z_gamma%*%b_gamma[i,] D_gamma=diag(c(exp(gamma))) Lamda_y=diag(c(rep(1/sigamsqr,degp+1), delta[i]*exp(gamma))) z=trust(trustthe,parinit=rep(0,mt+degp+1), Lambday=Lamda_y,D=C,P=A, blather=TRUE,rinit=100,rmax=100,minimize=FALSE) thetamax=z$argument h=-z$hessian #Drawing theta #Sigma=(df/(df-2))*chol2inv(chol(h)) theta[i+1,]=mvrnorm(1,thetamax,chol2inv(chol(h))) #rmvt(1,delta=thetamax,sigma=Sigma,df=4) #Metropolis-Hastings Step whittle_lik_curr=sum(C%*%theta[i,]exp(C%*%theta[i,])*A) 0.5*t(theta[i,])%*%Lamda_y%*%theta[i,] whittle_lik_pro=sum(C%*%theta[i+1,]exp(C%*%theta[i+1,])*A) 0.5*t(theta[i+1,])%*%Lamda_y%*%theta[i+1,] #proposal_theta_curr=dmvt(theta[i,],delta=thetamax,sigma=Sigma,df=4,log=TRUE) #proposal_theta_prop=dmvt(theta[i+1,],delta=thetamax,sigma=Sigma,df=4,log=TRUE) proposal_theta_curr= -0.5*(t(theta[i,] thetamax)%*%(h)%*%(theta[i,] thetamax)) proposal_theta_prop= -0.5*(t(theta[i+1,] thetamax)%*%(h)%*%(theta[i+1,] thetamax)) MH_ratio= whittle_lik_pro + proposal_theta_curr whittle_lik_curr proposal_theta_prop alpha1[i]=min(c(1,exp(MH_ratio))) u1=runif(1) if(u1 > alpha1[i]){ theta[i+1,] = theta[i,] } b=theta[i+1,(degp+2):(mt+degp+1)] #When using Cosine basis: theta[i+1,2:(mt+1)] #Drawing bgamma o=trust(trustgam,parinit=rep(0,mss),b=b,del=delta[i],et=eta[i],Z_gamma=Z_gamma,blather=TRUE,rinit=100,rmax=100,minimize=FALSE) b_gamma_max=o$argument


[Page 81]

H=-o$hessian #Drawing bgamma b_gamma[i+1,]=mvrnorm(1,b_gamma_max,chol2inv(chol(H))) #Metropolis-Hastings Drawing b_gamma gamma_prop=Z_gamma%*%b_gamma[i+1,] D_gamma_prop=diag(c(exp(gamma_prop))) log_proposal_curr=-0.5*(t(b_gamma[i,]-b_gamma_max)%*%(H)%*%(b_gamma[i,]-b_gamma_max)) log_proposal_prop=-0.5*(t(b_gamma[i+1,]-b_gamma_max)%*%(H)%*%(b_gamma[i+1,]-b_gamma_max)) log_lik_gamma_curr=0.5*(sum(gamma)-delta[i]*t(b)%*%D_gamma%*%b eta[i]*t(b_gamma[i,])%*%b_gamma[i,]) log_lik_gamma_prop=0.5*(sum(gamma_prop)-delta[i]*t(b)%*%D_gamma_prop%*%b-eta[i]*t(b_gamma[i+1,])%*%b_gamma[i+1,]) M_H_ratio=log_lik_gamma_prop+log_proposal_curr-log_lik_gamma_curr-log_proposal_prop alpha2[i]=min(c(1,exp(M_H_ratio))) u2=runif(1) if(u2 > alpha2[i]){ b_gamma[i+1,] = b_gamma[i,] } #Drawing delta and g1 delta.b=0.5*t(b)%*%D_gamma%*%b + nu/g1[i] delta[i+1]=rgamma(1,shape=delta.a,scale=1/delta.b) g1b=nu*delta[i+1] + (1/G)^2 g1[i+1]=1/rgamma(1,shape=gshape,scale=1/g1b) #Drawing eta and g2 eta.b=0.5*t(b_gamma[i+1,])%*%b_gamma[i+1,]+nu/g2[i] eta[i+1]=rgamma(1,shape=eta.a,scale=1/eta.b) g2b=nu*eta[i+1] + (1/G)^2 g2[i+1]=1/rgamma(1,shape=gshape,scale=1/g2b) } ############################################### k=kernel(’daniell’,m=25) s=spec(dat, kernel=k, ci.plot=TRUE, ci.col=NULL,log=’yes’,demean=FALSE) plot(f,log(A),col=’wheat’) lines(s$freq,log(s$spec),lty=3,lwd=2) lines(s$freq,log(s$spec)+log(102/qchisq(.025,102)),col="deepskyblue",lty=4,lwd=1) lines(s$freq,log(s$spec)+log(102/qchisq(.975,102)),col="deepskyblue",lty=4,lwd=1) #Plot and Fits#################################### cbind(mean(alpha1),mean(alpha2)) theta_post=apply(theta[burn:N,], 2, mean) BAPS_fit=-C%*%theta_post plot(f,log(A),type=’n’,lwd=1) lines(f,BAPS_fit, lty=1,lwd=1) #Credibel Intervals################################# theta=theta[burn:N,]


[Page 82]

fits=matrix(0, nrow=(N-burn+1),ncol=M) for(h in 1:(N-burn+1)){ fits[h,]=-C%*%theta[h,] } ci=apply(fits,2, quantile,c(0.025,0.975)) lines(f, ci[1,],lty=2,lwd=1) lines(f, ci[2,],lty=2,lwd=1)


[Page 83]

Luis Angel Mora was born on December 03, 1988. The ﬁrst son of Maria de la Luz Mora and Roumaldo Mora, he graduated from Gadsden High School, Anthony, New Mexico, in the spring of 2007. Luis entered New Mexico State University in the fall of 2007. While pursuing his bachelor’s degree in mathematics he worked as a mathematics tutor and library assistant at New Mexico State University. Luis received his bachelor’s degree in mathematics with a minor emphasis in management in the summer of 2012.

In the fall of 2013, he entered the Graduate School of The University of Texas at El Paso. While pursuing a master’s degree in Statistics he worked as a Teaching Assistant and supervised tutors at the mathematics tutoring center.

Permanent address: 653 Mesilla View Drive Chaparral, New Mexico 88081
