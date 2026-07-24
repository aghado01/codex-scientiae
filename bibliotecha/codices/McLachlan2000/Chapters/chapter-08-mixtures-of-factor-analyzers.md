<a id="sec-mixtures-of-factor-analyzers"></a>

# Mixtures of Factor Analyzers

<a id="sec-8-1"></a>

# 8.1 INTRODUCTION

Factor analysis is commonly used for explaining data, in particular; correlations between variables in multivariate observations. It can be used also for dimensionality reduction; although the method of principal component analysis is more widely used in this role. However, the effectiveness of these two statistical techniques is limited by their global linearity. The applicability of these two methods can be widened by combining local models of them in the form of a finite mixture; along the lines proposed by Ghahramani and Hinton (1997) and Tipping and Bishop (1997).

In this chapter we shall focus on mixtures of factor analyzers from the perspective of both a method for model-based density estimation for high-dimensional data (and hence for the clustering of such data) and a method for local dimensionality reduction. We shall also discuss the close link of mixtures of factor analyzers with mixtures of probabilistic principal component analyzers. The mixtures of factor analyzers model enables a normal mixture model to be fitted to high-dimensional data. The number of free parameters is controlled through the dimension 9 of the latent factor space. It allows an interpolation in model complexities from isotropic to full covariance structures without any restrictions.

Before we proceed to introduce mixtures of factor analyzers, we briefly look at the use of principal components for revealing group structure and dimension reduction:

<a id="sec-8-2"></a>

# 8.2 PRINCIPAL COMPONENT ANALYSIS

In exploring high-dimensional data sets for group structure, it is typical to rely on "second-order' multivariate techniques, in particular; principal component analysis (PCA); see Huber (1985), Friedman (1987), and Jones and Sibson (1987) and the subsequent discussions for an excellent account of available exploratory multivariate techniques. Here we briefly discuss a PCA on the sample covariance matrix

$$
V = \sum _ { j = 1 } ^ { n } ( y _ { j } - \overline { y } ) ( y _ { j } - \overline { y } ) ^ { T } / n .
$$

$$
( 8 , 1 )
$$

We let a1, ap be the (unit) eigenvectors, corresponding to the eigenvalues X1 2 2 Xp of V. In the case where the variates measured on disparate scales, we wish to replace the sample correlation matrix. are Vby may

If there are only a few groups and are well-separated, and the between-group variation dominates the within-group variation; then projections of the feature data $y_j$ onto the first few principal axes should portray the group structure. However; a PCA of not always be useful. This was stressed by Chang (1983), who showed in the case of two groups that the principal component of the feature vector that provides the best separation between the two groups in terms of Mahalanobis distance is not necessarily the first component a{ uj; see McLachlan (1992, Section 6.6). they Vmay point

To illustrate we generated a sample of size n = 100 five-dimensional obser vations from two groups G1 and G2 with means this,

$$
a n d
$$

and covariance matrices

$$
\Sigma _ { 1 } = \text {diag} ( 1 , \, 1 0 , \, 1 0 , \, 1 0 , \, 1 0 )
$$

and These two groups are well separated. However; the distribution of the feature vector limited to one direction in the feature space with the within-group variation in the other orthogonal directions being relatively very large. As a consequence, PCA fails to locate the optimal viewing direction for group structure. It can be seen from Figure 8.1 that the plot of the first two principalcomponents (based on the correlation matrix) provides no evidence of the presence of two groups in the data. Indeed, if we were to proceed to fit a mixture of g =2 normal components to just these first two principal components, we would obtain a clustering that would misallocate 44% of the data points. In contrast, if we were to fit a mixture of g =2 factor analyzers with 9 2 factors, as to be considered shortly in Section 8.11, we would obtain a clustering that misallocates only one point.

$$
\left ( \begin{array} { c c c } 1 & & & \\ 3 & 1 0 & & \\ 0 & 0 & 1 0 & \\ 0 & 0 & 0 & 1 0 \\ & 0 & 0 & 0 & 0 & 1 0 & \end{array} \right ) .
$$

We then obtained the feature data, 91, Un , by premultiplying each of these generated 100 observations by an orthogonal matrix,

$$
H = \left ( \begin{array} { c c c c c } \cos ( \pi / 4 ) & - \sin ( \pi / 4 ) & 0 & 0 & 0 & 0 \\ \sin ( \pi / 4 ) & \cos ( \pi / 4 ) & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \\ 0 & 0 & 0 & 0 & \cos ( \pi / 4 ) & - \sin ( \pi / 4 ) \\ 0 & 0 & 0 & 0 & \sin ( \pi / 4 ) & \cos ( \pi / 4 ) \end{array} \right ) .
$$

![image 26](mclachlan2000_images/imageFile26.png)

Flg. 8.1 Plot of the first two principal components with true group of origin shown (0 and x denote membership of groups G1 and G2, respectively).

<a id="sec-single-factor-analysis-model"></a>

# 8.3 SINGLE-FACTOR ANALYSIS MODEL

We let Yí, Yn denote a random sample of size n on a p-dimensional random vector. In a typical factor analysis model, each observation $Y_j$ is modeled as

$$
+ \, e _ { j } \ \ ( j = 1 , \dots , n ) ,
$$

where Uj is aq-dimensional (9 < p) vector of latent or unobservable variables called factors and B is a p X 9 matrix of factor loadings (parameters) . It is assumed that

$$
( Y _ { 1 } ^ { T } , U _ { 1 } ^ { T } ) ^ { T } , \dots , ( Y _ { n } ^ { T } , U _ { n } ^ { T } ) ^ { T }
$$

are iid. The U; are assumed to be iid. as N(o, Iq), independently of the errors ej, which are assumed to be iid. as N(o, D), where D is a diagonal matrix,

$$
, \sigma _ { p } ^ { 2 } ) ,
$$

Thus, conditional on the $u_j$, the $Y_j$ are independently distributedas N(u+Buj, D). Unconditionally; the $Y_j$ are iid. according to a normal distribution with mean / and covariance matrix



Thus the factors in $u_j$ are intended to explain the correlations between the variables in Yj, while the error terms ej represent the unexplained noise unique to a particular Uj (j = 1, n). Note that in the case of 9 > 1, there is an infinity of choices for B, since this model is still satisfied if we replace uj by and Bby BHT where His any orthogonal matrix of order 9. As 39(9 ~ 1) constraints are needed for Bto be uniquely defined, the number of free parameters is Huj



see Lawley and Maxwell (1971, Chapter 1). If 9 is chosen sufficiently smaller than p so that the difference

$$
( 8 , 5 )
$$

is positive; then the representation (8.3) imposes some constraints on the covariance matrix > and thus reduces the number of free parameters to be estimated.

<a id="sec-8-4"></a>

# 8.4 EM ALGORITHM FOR A SINGLE-FACTOR ANALYZER

The factor analysis model (8.2) can be fitted by maximum likelihood, although the solution has to be computed iteratively as no closed-form expressions exist for the MLEs of B and D. can be computed iteratively via the EM algorithm as considered in Dempster et al. (1977); see Rubin and Thayer (1982) and McLachlan and Krishnan (1997, Chapter 5) for further details. The MLE of the mean H is obviously the sample mean g of the n observed values 91, Un corresponding to the random sample Y1, loss of generality. Accordingly; we let the parameter vector " of unknown parameters consist of the elements of B and the diagonal elements of D. The (incomplete-data) likelihood for V that can be formed from the observed data y = (u{ . They og

$$
\log L ( \Psi ) = - \frac { 1 } { 2 } n \{ \log | \ B B ^ { T } + D \ | + \sum _ { j = 1 } ^ { m } ( y _ { j } - \overline { y } )
$$

In order to apply the EM algorithm and its variants to this problem, we follow Dempster et al. (1977) and formulate

$$
y _ { c } = 0
$$

as the complete-data vector, where where $u_j$ corresponds to Uj The complete-data likelihood is, but for an additive constant, log

$$
\log L _ { c } ( \Psi ) = - \frac { 1 } { 2 } n \log | \ D | - \frac { 1 } { 2 } \sum _ { j = 1 } ^ { n } \{ ( y _ { j } - 1 ) |
$$

The complete-data density belongs to the exponential family, and the completedata sufficient statistics are Cyu, and Cuu, where Cyy'

$$
C _ { y y } = \sum _ { j = 1 } ^ { n } ( y _ { j } - \overline { y } ) ( y _ { j } - \overline { y } ) ^ { T } ; \, C _ { y u } = \sum _ { j = 1 } ^ { n } ( y _ { j } - \overline { y } ) u _ { j } ^ { T } ;
$$

To calculate the conditional expectations of these sufficient statistics given the observed data, we need to use the result that the random vector multivariate normal distribution with mean



and covariance matrix

$$
\left ( \begin{array} { c c } { { B B ^ { T } + D } } & { { B } } \\ { { B ^ { T } } } & { { I _ { q } } } \end{array} \right ) .
$$

It thus follows that the conditional distribution of Uj given Uj is given by

$$
U _ { j } \left | y _ { j } \sim N ( \gamma ^ { T } ( y _ { j } - \mu ) , \, I _ { q } - \gamma ^ { T } B )
$$

for j = 1, 1, where

$$
\gamma = ( B B ^ { T } + D ) ^ { - 1 } \, B .
$$

The EM algorithm is implemented as follows on the (k + 1)th iteration.

E-Step. expectation of these sufficient statistics given the observed data y:

$$
\text {expectation of these sufficient statistics given the observed data} \\ E _ { x ^ { ( k ) } } ( C _ { y y } | y ) = C _ { y y } , \\ E _ { x ^ { ( k ) } } ( C _ { y u } | y ) = C _ { y u ^ { ( k ) } } , \\ \text {and} \\ E _ { x ^ { ( k ) } } ( C _ { u u } | y ) = \gamma ^ { ( k ) ^ { T } } C _ { y y } \gamma ^ { ( k ) } + n \omega ^ { ( k ) } , \\ \text {where} \\ \gamma ^ { ( k ) } = \{ B ^ { ( k ) } B ^ { ( k ) ^ { T } } + D ^ { ( k ) } \} ^ { - 1 } B ^ { ( k ) } \\ \text {and} \\ \omega ^ { ( k ) } = I _ { q } - \gamma ^ { ( k ) ^ { T } } B ^ { ( k ) } .
$$

M-Step. Calculate

$$
B ^ { ( k + 1 ) } = C _ { y y } \gamma ^ { ( k ) } ( \gamma ^ { ( k ) } { ^ { T } } C _ { y y } \gamma ^ { ( k ) } + n \omega ^ { ( k ) } ) ^ { - 1 }
$$

and

$$
D ^ { ( k + 1 ) } & \\ & = n ^ { - 1 } \text {diag} \{ C _ { y y } - C _ { y y } \gamma ^ { ( k ) } ( \gamma ^ { ( k ) } ) ^ { T } C _ { y y } \gamma ^ { ( k ) } + \\ & = n ^ { - 1 } \text {diag} \{ C _ { y y } - C _ { y y } \gamma ^ { ( k ) } B ^ { ( k + 1 ) ^ { T } } \} .
$$

The inversion of the current value of the px p matrix (BBT +D)on each iteration can be undertaken the result that using

$$
( B B ^ { T } + D ) ^ { - 1 } = D ^ { - 1 } - D ^ { - 1 } B ( I _ { q } + B ^ { T } D ^ { - 1 } B ) ^ { - 1 } B ^ { T } D ^ { - 1 } ,
$$

where the right-hand side of (8.11) involves only the inverses of 9 \* 9 matrices; since Dis a diagonal matrix. The determinant of (BBT + D)can then be calculated as

$$
-
$$

Liu and Rubin (1994, 1998) have considered the application of the ECME algorithmto this problem: The M-stepis replaced by twoCM-steps. On the first CM-step, B(k+1) is calculated as on the M-step above; while on the second CM-step the onal matrix D(k+1) is obtained by using an algorithm such as Newton-Raphson to maximize the actual likelihood with B fixed at +1) diagB(k \_ log

Dunmur and Titterington (1998b) have considered latent profile models, which include the standard factor analysis model above but with each latent vector U; being categorical rather than normally distributed. They noted that this categorical-factor analysis model has links with factorial models as proposed in Hinton Zeal (1994) and Ghahramani (1995). and

<a id="sec-8-5"></a>

# 8.5 DATA VISUALIZATION IN LATENT SPACE

An original data tribution of its associated q-dimensional latent factor Uj . A convenient summary of this distribution is its mean. Hence we can portray the Uj in 9-dimensional space by plotting the estimated conditional expectation of each U; given Uj that is, the (estimated) posterior mean of the factor U; (j = 1, n) We have that point

$$
\hat { u } _ { j } \ & = \ E _ { \hat { y } } \{ U _ { j } \ | \ y _ { j } \} \\ & = \ \hat { \gamma } ^ { T } ( y _ { j } - \bar { y } ) ,
$$

<a id="sec-8-6"></a>

# 8.6 MIXTURES OF FACTOR ANALYZERS

As the single-factor analysis model (8.2) provides only a global linear model for the representation of the datain alower-dimensional subspace; the scope of its application is limited. Aglobal nonlinear approach can be obtained by postulating a finite mixture of linear submodels for the distribution of the full observation vector $Y_j$ given the (unobservable) factors uj That is, we can provide a local dimensionality reduction method by assuming that the distribution of the observation Yj can be modeled as

$$
Y _ { j } = \mu _ { i } + B _ { i } U _ { i j } + e _ { i j } \quad \text {with prob. } \pi _ { i } \quad ( i = 1 , \dots , g )
$$

for j = 1, n, where the factors U;l, Uin are distributed independently which are distributed independently N(o, D;) , where D; is a diagonal matrix (i = 1, g). The so-called mixing proportions T; are nonnegative and sum to one. eij'

Thus; unconditionally; the density of each observation $Y_j$ is a mixture of g normal densities in proportions $\pi_1$, Tg; that is,

$$
( 8 . 1 4 )
$$

where

$$
\Sigma _ { i } = B _ { i } B _ { i } ^ { T } + D _ { i } \ \ ( i = 1 , \dots , g ) .
$$

D;, along with the mixing proportions $\pi_i$ ($i = 1, 9 1) on putting "g 1 = 291

In Ghahramani and Hinton (1997), D; is taken to be the same for each component i; see also Yung (1997). More recently, Ghahramani and Beal (2000) have considered a Bayesian approach, using a deterministic variational approximation to full Bayesian integration over model parameters. In work on related models, Jedidi, Jagpai, and DeSarbo (1997) have considered the of a general finite mixture structural equation. Shi and Lee (2000) have considered a single-component model with mixed continuous and polytomous latent variables. Attias (1999b, 2000) has recently proposed a technique that he calls independent factor analysis, which further extends ordinary factor analysis. fitting

The mixtures of factor analyzers model (8.14) is also useful in the modeling of high-dimensional data by mixtures of normal components; particularly in situations where there are limited data. With the fitting of a mixture of normal components This means that as the number of components g in the mixture model grows, the total number of parameters can quickly become very large relative to the sample size n, leading to overfitting. The mixture of factor analyzers model provides way of controlling the number of parameters through the reduced model (8.15) for the component-covariance matrices. It thus provides a model intermediate between the independent and unrestricted models. The adequacy of the fit ofamixture of factor analyzers with 9 factors can be tested using the likelihood ratio statistic.

<a id="sec-8-7"></a>

# 8.7 AECM ALGORITHM FOR FITTING MIXTURES OF FACTOR ANALYZERS

<a id="sec-8-7-1"></a>

# 8.7.1 AECM Framework

The likelihood for $ that can be formed from the observed data y under model (8.14) is log

$$
\log L ( \Psi ) = \sum _ { j = 1 } ^ { n } \log \{ \sum _ { i = 1 } ^ { y } \pi _ { i } \phi ( y _ { j } ; \mu _ { i } , \Sigma _ { i } ) \} .
$$

We can use the alternating expectation-conditional maximization (AECM) algorithm as developed by and van Dyk (1997) to fit the mixture of factor analyzers The expectation-conditional maximization (ECM) algorithm proposed by and Rubin (1993) replaces the M-step of the EM algorithm by a number of computationally simpler conditional maximization (CM) steps. The AECM algorithm is an extension of the ECM algorithm, where the specification of the complete data is allowed to be different on each CM-step. Meng Meng

To apply the AECM algorithm to the fitting of the mixture model (8.14), we partition the vector of unknown parameters V as where %1 contains the mixing proportions T; (i 9 1) and the elements of the component means #; (; = 1, 9) The subvector 42 contains the elements of the B; and the Di = 1, 9) . Concerning the specification of the incomplete data, we have noted in Chapter 2 that for the fitting of mixture models in general, it is useful to conceptualize each observation %; as having arisen from one of the components of the mixture and then to declare the component-indicator vector $z_j$ s0 associated with U; as missing data; In this framework, zij = ($z_j$); is one or zero, according to whether Uj arose or did not arise from the ith component (i = 1, 9; j = 1, n) The conditional expectation of Zij given $y_j$ is the posterior probability that the jth observation comes from the ith component, given by

$$
( y _ { j } ; \Psi ) \ & = \ \Pr \{ Z _ { i j } = 1 \ | \ y _ { j } \} \\ & = \ \pi _ { i } \, \phi ( y _ { j } ; \mu _ { i } , \, \Sigma _ { i } ) / \sum _ { h = 1 } ^ { g } \pi _ { h } \phi ( y _ { j } ; \mu _ { h } , \, \Sigma _ { h } ) ,
$$

where >; has the form (8.15) (i = 1, g; j = 1, n)

AECM algorithm. For this application of the AECM algorithm; one iteration consists of two cycles, and there is one E-step and one CM-step for each cycle. The two CM-

<a id="sec-8-7-2"></a>

# 8.7.2 First Cycle

For the first of the AECM algorithm, we specify the missing data to be just the component-indicator vectors, 21, The complete-data likelihood is then cycle log given by

$$
\log L _ { c } ( \Psi ) = \sum _ { i = 1 } ^ { y } \sum _ { j = 1 } ^ { n } z _ { i j } \log \{ \pi _ { i } \phi ( y _ { j } ; \mu _ { i } , \Sigma _ { i } ) \} .
$$

Hence the E-step on the first = on the (k+ 1)th iteration requires the calculation cycle

$$
| y \}
$$

is the conditional expectation of the complete-data likelihood (8.18) given % its current conditional expectation given the observed data (effectively %;); that is, we The first CM-step is implemented by maximizing so obtained contains the new estimates of the T; and U; given by log

$$
( k + 1 ) = \sum _ { j = 1 } ^ { n } \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) / n
$$

and

$$
) y _ { j } / \sum _ { j = 1 } \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } )
$$

for i = 1, We now set +1/2) equal to

<a id="sec-8-7-3"></a>

# 8.7.3 Second Cycle

For the second for the updating of 42, which contains the elements of the B; and the Di, we specify the missing data to be the factors 21, Un, aS well as thc component-indicator vectors, The complete-data likelihood is then given by cycle log 21,

$$
\log L _ { c } ( \Psi ) = \sum _ { i = 1 } ^ { y } \sum _ { j = 1 } ^ { n } z _ { i j } \{ \pi _ { i } \phi ( y _ { j } ; \mu _ { i } + B _ { i } u _ { i j } , \, \Sigma _ { i } ) \} .
$$

The E-step on the second cycle on the (k + 1)th iteration therefore requires the calculation of Q2("; which denotes the conditionalexpectation of (8.18) given the observed data y, using 1/2) for w. In additionto updating the posterior probabilities of component membership to it requires calculating the conditional expectation of T;(uj;

$$
( 8 . 2 2 )
$$

and which are given by and respectively, where and for i = 1, ''1 9

$$
u _ { i } ) ^ { T } \, | \, y _ { j } \} ,
$$

$$
\tau _ { i } ( y _ { j } ; \mathbf \Psi
$$

$$
( 8 . 2 4 )
$$

$$
^ { T } ( y _ { j } - \mu _ { i } ) ( y _ { j } - \mu _ { i } ) ^ { T } \gamma _ { i } ^ { ( k ) } + \omega _ { i } ^ { ( k ) } \} ,
$$

$$
+
$$

$$
( 8 . 2 6 )
$$

$$
( 8 , 2 7 )
$$

The CM-step on this second is implemented by the maximization of over % with V1 set equal to This yields the updated esti mates cycle

$$
B _ { i } ^ { ( k + 1 ) } = V _ { i } ^ { ( k + 1 / 2 ) } \gamma _ { i } ^ { ( k ) } ( \gamma _ { i } ^ { ( k ) ^ { T } } V _ { i } ^ { ( k + 1 / 2 ) } \gamma _ { i } ^ { ( k ) } + \omega _ { i } ^ { ( k + 1 / 2 ) } ) ^ { - 1 }
$$

and

$$
+ 1 ) = d i a g \{ V _ { i } ^ { ( k + 1 / 2 ) } - V
$$

$$
( 8 . 2 9 )
$$

where

$$
V _ { i } ^ { ( k + 1 / 2 ) } = \frac { \sum _ { j = 1 } ^ { n } \tau _ { i } ( y _ { j } ; \Psi ^ { ( k + 1 / 2 ) } ) \left ( y _ { j } - \mu _ { i } ^ { ( k + 1 ) } \right ) ( y _ { j } - \mu _ { i } ^ { ( k + 1 ) } ) ^ { T } } { \sum _ { j = 1 } ^ { n } \tau _ { i } ( y _ { j } \colon \Psi ^ { ( k + 1 / 2 ) } ) } .
$$

By construction of this AECM algorithm,

$$
\kappa + 1 / 2 ) _ { ; }
$$

and

which ensures that

$$
( k + 1 / 2 ) _ { ; \, \Psi } ( k + 1 / 2 ) _ { ) } ,
$$

$$
L ( \Psi ^ { ( k + 1 / 2 ) } ) \geq L ( \Psi ^ { ( k ) } )
$$

and

$$
L ( \Psi ^ { ( k + 1 ) } ) \geq L ( \Psi ^ { ( k + 1 / 2 ) } ) ,
$$

respectively; see Meng and Rubin (1993) and and van Dyk (1997). Thus the (incomplete-data) likelihood L($) is not decreased after each cycle, and hence after each iteration, of the AECM algorithm. Meng

<a id="sec-8-7-4"></a>

# 8.7.4 Representation of Original Data

With this g-component mixture model of factor analyzers, the dimension of the data is reduced locally by 9 normal component distributions with covariance matrices of the form (8.15), where the contribution ofapoint to the process is weighted by its posterior probabilities of component membership. being fitting

To consider the representation of an original data point %; in q-dimensions; have that the estimated conditional expectation of the unobservable factor given Uj and also its membership of the ith component is from (8.12) equal to we

$$
\{ U _ { i j } \ | \ y _ { j } , z _ { i j } = 1 \} \\ ( y _ { j } - \hat { \mu } _ { i } ) .
$$

If we average these (estimated) conditional expected component scores over the estimated posterior distribution of the component membership of U;, we obtain ûij

$$
\hat { u } _ { j } = \sum _ { i = 1 } ^ { y } \tau _ { i } ( y _ { j } ; \hat { \Psi } ) \, \hat { \gamma } _ { i } ^ { T } ( y _ { j } - \hat { \mu } _ { i } )
$$

n)

We can thus display U; in two-dimensional space by mapping it either onto the corresponding posterior mean û; for 9 = 2 factors or onto for that value of i for which êij 1. These plots of the estimated posterior factor means may be useful for exploring group structure in a data set, as demonstrated in the series of papers by Tipping and Bishop (1997, 1999a), Bishop (1998), and Bishop and Tipping (1998) on the use of the related model of mixtures of probabilistic PCAs. However, it is noted that these plots are not always useful in exhibiting group structure in data; as will be demonstrated in Section 8.11. ûij

<a id="sec-8-8"></a>

# 8.8 LINK OF FACTOR ANALYSIS WITH PROBABILISTIC PCA

Principal component analysis (PCA)is apopular technique for reducing the dimension of data, in particular for visualizing the data in two or three dimensions. However, its effectiveness is limited by its global linearity. One nonlinear extension of this technique can be obtained by attempting to combine separate principal component analyses in the form of a finite mixture model. correspond to an underlying density function for the data; and so there has been no useful way t0 combine the separate analyses.

Bishop and Tipping (1998) and Tipping and Bishop (1997, 1999a) formulated a mixture of probabilistic principal component analyzers by adopting a model that is closely related to the factor analysis model (8.13). To discuss now this link between factor analysis and PCA, we firstly consider the case of a single-factor analyzer and single-principal component analyzer:.

In factor analysis; the subspace defined by the columns of B will generally not correspond to the principal subspace. However, as noted by Tipping and Bishop

(1999a, 1999),it had been observed in the literature that the factor loadings in Bin single-factor analyzer (8.2) were similar to the principal component axes in situations where the estimates of the diagonal matrix D were approximately equal; see, for example, Rao (1955), Anderson (1963), and Basilevsky (1994). quite

In their model for aprobabilistic PCA, Tipping and Bishop (1997,1999a) proposed taking the diagonal covariance matrix D for the error terms to have the isotropic structure,

$$
D = \sigma ^ { 2 } \, I _ { p } .
$$

In this isotropic case, showed that the MLEs B and ô?2 are related to PCA, since Bisthe matrix whose columns are scaled eigenvectors of the sample covariance matrix V defined by (8.1), and ô2 is the average of the variance in the discarded dimensions; see also Tippingand Bishop (1999b). These derivations were undertaken previously by Lawley (1953) and Anderson and Rubin (1956), but it was not noted explicitly as in Tipping and Bishop (1997) that the principal component eigenvectors correspond tothe global maximum of the likelihood. More specifically; the likelihood they

function (8.16) with D specified by (8.33) is maximized by

$$
( 8 . 3 4 )
$$

where

$$
\begin{array} { r l r } { A } & { = } & { ( a _ { 1 } , \dots , a _ { q } ) , } \\ { A } & { = } & { d i a g ( \lambda _ { 1 } , \dots , \lambda _ { q } ) , } \\ { \hat { \sigma } ^ { 2 } } & { = } & { \sum _ { h = q + 1 } ^ { p } \lambda _ { h } / ( p - q ) , } \end{array}
$$

and aq are the (unit) eigenvectors; corresponding to the eigenvalues X1 X 9 orthogonal matrix. 01,

From (8.12) and (8.34), have for the probabilistic PCA model that the estimated conditional expectation of corresponding to Uj , ûj, is given by we U;

$$
\hat { u } _ { j } \ & = \ \hat { B } ^ { T } ( \hat { B } \hat { B } ^ { T } + \hat { \sigma } ^ { 2 } I _ { p } ) ^ { - 1 } ( y _ { j } - \bar { y } ) \\ & = \ \ ( \hat { B } ^ { T } \hat { B } + \hat { \sigma } ^ { 2 } I _ { q } ) ^ { - 1 } \hat { B } ^ { T } ( y _ { j } - \bar { y } ) ,
$$

where (8.36) follows from (8.35) on noting that

$$
\hat { B } ^ { T } ( \hat { B } \hat { B } ^ { T } + \hat { \sigma } ^ { 2 } I _ { p } ) ^ { - 1 } = ( \hat { B } ^ { T } \hat { B } + \hat { \sigma } ^ { 2 } I _ { q } ) ^ { - 1 } \hat { B } ^ { T } .
$$

need not be an orthogonal projection in the factor space, since they

$$
\hat { B } ^ { T } \hat { B } = R ^ { T } ( \Lambda - \hat { \sigma } ^ { 2 } I _ { q } ) R ,
$$

which is not diagonal for R # Iq (Tipping and Bishop, 1999a) As ô2 \_ 0, see from (8.36) that the probabilistic PCA becomes equivalent in the limit to standard PCA. On further distinctions between factor analysis andprobabilistic PCA, neither of the factors found by, say; atwo-factor model is necessarily the same as that foundby a single-factor model. However; with probabilistic PCA, we see that the principal axes the form of the factor analysis solution is preserved under diagonal H; that is, under scaling of each variable in the observation vector $\Psi$;j On the other hand, H needs to be orthogonal (corresponding t0 a rotation of the axes) for the probabilistic PCA solution to be preserved. This is where factor analysis and standard PCA fundamentally differ. With the factor analysis model (8.13), the latent variables are intended to explain the correlations between the variables in the observation vector Yj, while the error term ej represents variability unique to a particular $Y_j$With standard PCA, covariance and variance terms are treated identically. we Hyj'

<a id="sec-8-9"></a>

# 8.9 MIXTURES OF PROBABILISTIC PCAs

(8.14) and (8.15) with each D; now having the isotropic structure

$$
D _ { i } = \sigma _ { i } ^ { 2 } I _ { p } \quad ( i = 1 , \dots , g ) .
$$

From the previous section; it follows that under this isotropic restriction assumption (8.37) the CM-step for the updating of B; and D; is not necessary since, given explicitly by an eigenvalue decomposition of the p \* pcomponent-weighted covariance matrix, vk +1/2) That is, application of the EM algorithm will suffice with just the component-indicator vectors as the declared missing data. However; we may still wish to use the AECM algorithm as described in Section 8.7, since it necessitates only the inversion ofq x 9 matrices and is of computational complexity 0(93) . Under the additional isotropic restriction (8.37), the common diagonal element 0? of D; is estimated by the trace of the right-hand side of (8.30) divided by p.

Hinton, Dayan, and Revow (1997) have given an excellent discussion of the use of mixtures of factor and probabilistic analyzers in the context of the clustering of handwritten digits. More recently, Ghahramani and Hinton (1998) and Bishop; Svensén, and Williams (1999) have considered a nonlinear form of factor analysis by replacing the factor vector in (8.13) by a nonlinear function so as to give a nonlinear ping from the observed data space to the latent space. They call their latent model the generative topographic mapping; see also Bishop (1998). map-

<a id="sec-8-10"></a>

# 8.10 INITIALIZATION OF AECM ALGORITHM

We now make use of the link of factor analysis with the probabilistic PCA model of the mixture of factor fitting analyzers via the AECM algorithm; as described in Section 8.7. We proceed on the basis that under the mixture of factor analyzers model (8.14), is transformed as D;1/2uj, then its ith component-covariance matrix has the form

$$
D _ { i } ^ { - 1 / 2 } \Sigma _ { i } D _ { i } ^ { - 1 / 2 } = ( D _ { i } ^ { - 1 / 2 } B _ { i } ) ( D _ { i } ^ { - 1 / 2 } B _ { i } ) ^ { T } + I _ { p } ,
$$

Hence by using some initial value initial value

$$
B _ { i } ^ { ( 0 ) } = D _ { i } ^ { ( 0 ) ^ { 1 / 2 } } A _ { i } ( \Lambda _ { i } - I _ { q } ) ^ { 1 / 2 } \ \ ( i = 1 , \dots , g ) ,
$$

where the 9 columns of the matrix A; are the eigenvectors corresponding to the 2 of

$$
( 8 . 4 0 )
$$

and A; = $Z_j$ in (8.39), we can get a negative value for the term

$$
( \Lambda _ { i } - I _ { q } )
$$

in (8.39); that is, X;h for some 9 <9. To avoid this situation since the square root of (8.41) is required, we can either restrict 9 to be less than 9 or replace the term (8.41) by (A; -

$$
^ { 1 / 2 } \ \ ( i = 1 , \dots , g ) , \quad ( 8 . 4 2 )
$$

where &? is defined by

$$
\tilde { \sigma } _ { i } ^ { 2 } = \sum _ { h = q + 1 } ^ { p } \lambda _ { i }
$$

can randomly assign the data into g groups and take > {0) to be the sample covariance matrix of the ith group (i = 1, 9) Concerning the choice of Dlo) we can take D {0) to be the diagonal matrix formed from the diagonal elements of >E (0) (i = 1, ''1 9) In this case, the matrix (8.40) has the form of a correlation matrix . This process may be repeated a number of times to provide range of starting values.

Another way of proceeding, if p is not too large relative to n for there to be problems with the inversion of the estimated component-covariance matrices, is to fit a mixture of normal components with, say; equal component-covariance matrices; a number of random starts . The estimate of >; so obtained can then be used using component-covariance matrices to diagonal . That is, we take vo) , where being

$$
\overline { j = 1 }
$$

and where = 1, 9) obtained by fitting a mixture of g normal components with diagonalcomponent-covariance matrices $Z_j$ from a number that is, using Ti,

$$
\pi _ { i } ^ { ( 0 ) } = \tilde { \pi } _ { i } \ \text { and } \ \mu _ { i } ^ { ( 0 ) } = \tilde { \mu } _ { i } .
$$

we can take D{O) to be the diagonal matrix formed from the diagonal elements of VO) (i = 1, '1 9)

An alternative way of specifying an initial value B(0) for B; isto randomly specify they

$$
B _ { i } ^ { ( 0 ) } = W _ { i } \left ( | \ V | ^ { 1 / p } \, / q \right ) ^ { 1 / 2 } \ \left ( i = 1 , \dots , g \right ) ,
$$

where the elements of the matrix W; are generated randomly from the standard normal distribution and Vis the sample covariance matrix of the data set. form the (common) initial value for D; from the diagonal elements of V, while selected randomly from a normal distribution with mean 7 and covariance matrix V(i =1, 9) They

<a id="sec-8-11"></a>

# 8.11 EXAMPLE 8.1: SIMULATED DATA

We consider the simulated data used in Section 8.2 as an example of a data set for which a plot of the first two principal components does not reveal the underlying group structure known tobe present. This data set also can be used to show that a plot of the estimated posterior means of 9 = 2 factors does not always give an indication of any group structure. In Figure 8.2 we give the plot of the estimated posterior factor mean uj for a single-component (g=1) factor analyzer with q = 2 factors. It can be seen that this plot gives no indication of the two groups from which the data were generated.

Although a single-component factor analyzer model (with 9 =2 factors) fails as does a PCA in revealing the group structure of this artificial data set, it can still be used to cluster it into two clusters corresponding to the two groups of origin with only one error of misallocation. On the other hand, if we were using a PCA to reduce the dimension of this problem to 9 =2 dimensions, we would obtain a very poor clustering of these data into two clusters with an overall misallocation rate of 449. The advantage of the factor analysis-based approach is that we are able to fit a mixture of factor analyzers, whereas we are unable to consider a mixture of standard PCAs We can only fit a mixture model to the principalcomponents obtained globally through the standard (single) PCA.

Fig. 8.2 Plot of the estimated posterior means of 9 = 2 factors for a single-factor analyzer model (0 and x denote

The increase in the likelihood as a consequence of 9 =2 components instead of a single component (g = 1) is 82.96 (corresponding to a value of 165.92 for ~2log X), which is strongly indicative of the presence of at least two groups in the data. In Figure 8.3 we have plotted the estimated posterior factor means and for those observations assigned to the first and second components, respectively; of the mixture of factor analyzers model. It can be seen that there is no evidence of group structure, which is what we would expect given that the data have been generated from two normal distributions. fitting log û1j û2j\_

(a)i = 1

(b)i = 2

8.3 Plot of the estimated posterior mean ûi; for those observations assigned outright to the ith component of the mixture. Fig.

<a id="sec-8-12"></a>

# 8.12 EXAMPLE 8.2: WINE DATA

To illustrate the use of the mixture of factor analyzers model, we report the analysis of learning repository of the University of California, Irvine (Merz; Murphy, and region in Italy; but derived from three different cultivars. The analysis determined the quantities of p = 13 constituents foundin each of n = 178 wines. Mixtures of factor analyzers were fitted to this data set via the AECM algorithm with the parameters Aha,

In Figure 8.4 we have plotted the values of the estimated posterior means of theq = 2 factors following asingle-component (g=1) factor analysis ofthe wine data. These posterior means have been plotted with their true group labels corresponding to the three different cultivars displayed . But it can be seen that if we were to ignore the group labels, the plot still exhibits the group structure in the data to a degree, with three clusters clearly evident. To further examine this group structure, we fitted a mixture of g = 3 factor analyzers with 9 =2 factors In Figure 8.5(a) we plotted the estimated posterior means of the factor scores for those observations %; assigned outrightto the first component on the basis of the estimated posterior probabilities of component membership. Similarly; the estimated posterior means , and û3j, for those observations assigned outright to the second and third components are plotted in The plots of structure, which is consistent with the fact that this wine data set contains only three different types of wine. ûij ' good have û1j

Fig. 8.4 Plot of the estimated posterior means of the 9 2 factors following singlecomponent (g=l) factor analysis of the wine data set (0,+, and x denote true component membership)

Hence the mixtures of factor analyzers model has been useful here in exploring the group structure of the data and illustrating the structure found. We now consider its usefulness as a model for density estimation for providing a model-based approach to clustering. To cluster this data set, we can model the density of each p = 13dimensional observation $y_j$ by ag = 3-component normal mixture model. A soft or probabilistic clustering of the data can be obtained in terms of the estimated posterior probabilities of component membership; #); a hard or outright clustering is obtained by assigning each observation to the component to which it has the highest estimated posterior probability of belonging: As p = 13 in this application;, the covariance matrix $Z_j$ in the ith component normal distribution has 91 parameters for each i (i = 1,2,3), which means that the total number of parameters is very large relative to the sample size of n = 178. Hence we consider fitting a mixture of factor analyzers for various 9 as a way of reducing the number of parameters to be fitted. T;($y_j$;

(a) i = 1

(b)i = 2

(c)i = 3

Fig. 8.5 Plot of the estimated posterior means of the factor scores for those observations assigned outright to the ith component of the mixture fitted to the wine data.

In Table 8.1, report the overall error rate of the normal mixture model-based approach using restricted forms of the $Z_j$ through the adoption of factor analyzer components for various levels of the number of factors from 9 = 1 to 9 =8, and for the full model (no restrictions on the >;). In the latter case, we have also given the results obtained when the AECM algorithm is started from the true classification of these data. We have also reported the value of minus twice the LRTS X (that is, twice the increase in the log likelihood), as we proceed from a mixture of 9 factor analyzers to one with 9 + 1 component factors. we fitting It can be seen from Table 8.1 that the error rate of the clustering based on the mixture model with unrestricted component-covariance matrices is increased when the known group membership of the data is not used to start the EM algorithm. This lack of knowledge affects the clustering for all but 9 2 and 3 factors, as we can achieve an error rate of one for the other values of q when this knowledge is used to start the AECM algorithm.

Table 8.1 Overall Error Rates for Values of q

|      | L log     | Err | %Err | ~2      |
| ---- | --------- | --- | ---- | ------- |
| 1    | ~3102.254 | 2   | 1.12 |         |
| 2    | 2995.334  | 1   | 0.56 | 213.840 |
| 3    | 2913.122  | 1   | 0.56 | 164.424 |
| 4    | ~2871.655 | 3   | 1.69 | 82.934  |
| 5    | 2831.860  |     | 2.25 | 79.590  |
| 6    | ~2811.290 | ;   | 2.25 | 41.140  |
| 7    | 2799.204  |     | 2.25 | 24./72  |
| 8    | ~2788.542 |     |      | 21.324  |
| Full | 2813.153  |     | 3.93 |         |
| True | ~2781.244 |     | 0.56 |         |

The likelihood reported in Table 8.1 in the full model case is smaller than the likelihood for 6 < 9 < 8, indicating that there is a larger local maximum to be found in the unrestricted case. Indeed, when we start the EM algorithm in the latter case the known classification of the data, we do find a local maximum that is greater than the values reported in Table 8.1 for 6 < 9 < 8 This knowledge of the true classification is not used in starting the AECM algorithm to fit the mixture of factor analyzers for 9 < 8log log using

In practice in a typical cluster analysis; the true classification of the data would knowledge to start the AECM algorithm; the error rate of the outright clustering tends to increase as the number of factors 9 increases. This apparent error rate is smallest for 9 =2 and 3 q0 = 6 versus 9 =90+1 = 7is not significant at a conventional level of significance (P = X to be chi-squared with d = g(p 90) = 21 degrees of freedom under the null hypothesis that 9 = q0 = 6. log =

In Table 8.2 we list the eigenvalues Xih (h = 1, 13) of (8.39). These eigenvalues were used to form the initial value seen that for each i, the Aih start to fall away after h =5or 6, which is consistent with the above result based on the LRT that 9 = 6 factors would appear to be adequate. It suggests that the relative sizes of the Xih (h = 1, p) for each i (i = 1, 9) can be used as to an initial choice for the number of factors q A more informed choice if desired can be made then on the basis of the likelihood ratio statistic applied for nearby values of 9. guide log

Table 8.2 Eigenvalues of the Initial Estimates of the Component-Correlation Matrices

| h   | A1h    |        | Ash    |
| --- | ------ | ------ | ------ |
| 1   | 13.604 | 7.149  | 17.060 |
| 2   | 7.411  | 4.985  | 8.176  |
| 3   |        | 4.,185 | 7.497  |
| 4   | 3.215  | 2.126  | 4.547  |
| 5   | 2.392  | 1.849  | 2.936  |
| 6   | 2.098  | 1.417  | 2.195  |
| 7   | 1.687  | 0.952  | 2.012  |
| 8   | 1.178  | 0.670  | 0.866  |
| 9   | 0.997  | 0.564  | 0.678  |
|     |        | 0.483  | 0.541  |
| 10  | 0.622  | 0.322  | 0.424  |
| 12  | 0.482  | 0.196  | 0.279  |
| 13  | 0.367  | 0.137  | 0.198  |

