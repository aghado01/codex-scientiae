<a id="sec-hidden-markov-models"></a>

# Hidden Markov Models

<a id="sec-13-1"></a>

# 13.1 INTRODUCTION

The hidden Markov model (HMM) is increasingly being adopted in applications; since it provides a convenient way of formulating an extension of a mixture model to

$$
f ( y _ { j } ; \Psi ) = \sum _ { i = 1 } ^ { j } \pi _ { i } \, f _ { i } ( y _ { j } ; \theta _ { i } )
$$

for the density of an observation $Y_j$. In our treatment of mixture models in the previous chapters for independent data, we have introduced the component-indicator vector $z_j$, where zij according to whether %; is viewed as belonging, or not belonging, to the ith component of the mixture (i = 1, 9) These vectors 21, Zn are taken tobe iid. according to amultinomial distribution consisting of one draw on g categories with proportions $\pi_1$, Tg; that is,

$$
( 1 3 . 2 )
$$

The feature vectors %1, Un are assumed tobe conditionally independent given 21, zn; that is,

$$
f ( y _ { 1 } , \dots , y _ { n } \ | \ z _ { 1 } , \dots , z _ { n } ; \xi ) = \prod _ { j = 1 } ^ { n } f ( y _ { j } \ | \ z _ { j } ; \xi ) ,
$$

where

$$
f ( y _ { j } \, | \, z _ { j } ; \xi ) = \prod _ { i = 1 } ^ { j } f _ { i } ( y _ { j } ; \theta _ { i } ) ^ { z _ { i j } }
$$

and € denotes the unknown parameters in 01, 0g known a to be distinct. From (13.2) and (13.3), the Yj will be iid. according to the mixture density (13.1) Titterington (1990) contrived the nomenclature hidden multinomial for the mixture model. priori

The hidden Markov extension relaxes the independence assumption on the $Y_j$ by taking successive observations to be correlated through their component of origin. With this approach, the independence assumption (13.2) on the component-indicator vectors $z_j$ is relaxed. Usually, a stationary Markovian model is formulated for the distribution of the hidden vectors Z1, In one dimension; this Markovian model is aMarkov chain (see, for example, Holst and Lindgren (1991))andin two and higher dimensions it is a Markov random field (MRF); see Besag (1986, 1989). The conditional distribution of the observed vector $Y_j$ is formulated as before to depend only on the value of Zj, the component of origin (state of the Markov process) ; and to be conditionally independent as in (13.3). With the relaxation of (13.2), the marginal density of the feature vector Yj will not have its simple representation (13.1) of a mixture density as in the independence case.

Hidden Markov models are closely related to state-space models, in which unobserved state variables determine the distribution of the observations. In many applications; the goal is reconstruction of the state variable based on an observation set. This is achieved by the Kalman filter in Gaussian linear state-space models; scc Leroux and Puterman (1992)

For general HMMs, Lindgren (1978) constructed consistent and asymptotically normal estimators of the component distributions; but he did not consider estimation of the transition probabilities: Leroux (1992b) established the consistency of the MLE for general HMMs under mild conditions; while local asymptotic normality was proved by Bickel and Ritov (1996). Recently; Bickel, Ritov; and Rydén (1998) showed that under mild conditions the MLE is asymptotically normal and that the observed information matrix is consistent estimator of the expected information: The relation between HMMs and graphical models has been reviewed recently in Smyth, Heckerman, and Jordan (1997) Ghahramani and Jordan (1997) have proa generalization of HMMs in which each hidden component (state) is factored into multiple components and is therefore represented in a distributed manner. posed

The hidden Markov chain isoften arealistic model when the observations U; appear sequentially in time and tend to cluster or to alternate between different possible components (subpopulations). It is finding widespread application in many areas, and Puterman, 1992; and Puterman, 1999), computational molecular biology (Kroghet al., 1994; Churchill, 1995),finance (Rydén, Teräsvirta; and Asbrink, 1998), neurophysiology (Fredkin and Rice, 1992), and speech and character recognition (Rabiner and 1986; Kundu and He, 1991; Digalakis, 1999); see also the monograph of MacDonald and Zucchini (1997). In speech recognition applications, Wang Juang, the indexing subscript j generally represents speech frames and $Y_j$ is taken to be a finitely many-valued vector, representing random functions of the underlying (hidden) prototypical spectra; see Rabiner (1989) and and Rabiner (1991). Juang Parameter estimation in hidden Markov models usually relies on maximum likelihood or Bayesian methods; moments methods intractable in this setting. The dependency structure can only exacerbate the difficulties met in mixture estimation for iid. data; see, for example, Robert, Celeux, and Diebolt (1993) and Archer and Titterington (1997). being In image-processing applications, the subscript j indexes pixel sites; but we use the term 'pixel" liberally as in York, and Mollie (1991), allowing for pixel arrays that have no direct connection with "picture elements. In some applications; the hidden variable $Z_j$ may represent some discretized characteristic of the pixel, about which inference is required to be made and $Y_j$ is an observable feature of a pixel statistically related to the hidden characteristic of the pixel. For instance; in the example to be considered in Section 13.5 on the tissue-segmentation of a region of the human brain into the component regions of white matter; gray matter, and cerebrospinal fluid, $z_j$ is a three-dimensional indicator vector denoting the component membership of the jth pixel on which the feature vector Uj has been recorded. The latter contains the multispectral magnetic resonance images obtained for the jth pixel. In this example, the $z_j$ will not be independently distributed because of the spatial correlation between neighboring pixels. In some other applications; the hidden vari able Zj may take values over a continuum representing the gray levels or a similar characteristic of the true image and $Y_j$ is a blurred version of the hidden true image see Qian and Titterington (1991). Besag,

<a id="sec-13-2"></a>

# 13.2 HIDDEN MARKOV CHAIN

<a id="sec-13-21"></a>

# 13.21 Definition

We first consider the case where the dependence between the unobservable (hidden) component-indicator vectors $Z_j$ is specified by a stationary Markov chain with 9. Thus

$$
\ p r \{ Z _ { i , j + 1 } = 1 \, | \, Z _ { h j } = 1 \} \, \} = \pi _ { h i } \quad ( h , i = 1 , \dots , g )
$$

for each j (j = 1, n - 1). The initial distributionof the Markov chain is defined by Toi (i = 1, 9)

We can therefore write the distribution of Z as

where and

$$
( z _ { 1 } ; \beta ) \, \prod _ { j = 2 } ^ { n } p ( z _ { j } \, | \, z _ { j - 1 } ; \beta ) ,
$$

$$
; \beta ) = \prod _ { i = 1 } ^ { j } \pi _ { 0 j } ^ { z _ { i } }
$$

$$
p ( z _ { j } \ | \ z _ { j - 1 } ; \beta ) & = \prod _ { h = 1 } ^ { j } \prod _ { i = 1 } ^ { j } \pi _ { h i } ^ { z _ { i , j - 1 } z _ { i j } } , \\
$$

where ß contains the initial probabilities Toi and the transition probabilities Here we are using p(-) as a generic notation for a probability function. Tij-

<a id="sec-13-2-2"></a>

# 13.2.2 Some Examples

Bickel et al. (1998) contains some examples of hidden Markov chains. In one, there are 9 2 hidden components with the ith componentdistributionof $Y_j$ being Poisson with mean p; (i = 1,2). Albert (1991) proposed this hidden Markov chain as a model for aseries of daily counts of epileptic seizures in one patient; see also Le et al. (1992) Leroux and Puterman (1992) this model to fetal lamb movements . applied

In another example, there are 9 = 2 hidden components, where the ith This model has been used to model electric current through channels in ion membranes; see Guttorp (1995, p. 109) and Fredkin and Rice (1992) for further details. again

<a id="sec-13-3"></a>

# 13.3 APPLYING EM ALGORITHM TO HIDDEN MARKOV CHAIN MODEL

<a id="sec-13-3-1"></a>

# 13.3.1 EM Framework

We now describe the application of the EM algorithm to this problem, known in the HMM literature as the Baum-Welch algorithm. Baum and his collaborators formulated this algorithm before the appearance of the EM algorithm in Dempster et al. (1977) and established the convergence properties for this algorithm; see Baum and Petrie (1966), Baum and Eagon (1967), and Baum et al. (1970). The E-step can be implemented exactly, but it does require a forward and backward recursion through the data, which is time-consuming and numerically sensitive; even though modified algorithms have been designed (Devijver, 1985)

The M-step can be implemented in closed form, provided that the MLEs of the are available in closed form. In our description here of the EM process, f:($y_j$) denotes the probability that $Y_j$ = Uj given its membership of the ith component of the chain; that is,

$$
Y _ { j } = y _ { j } \ | \ Z _ { i j } = 1 \} \quad ( i = 1 , \dots , g ; \ j = 1 , \dots , n ) .
$$

The vector of % of unknown parameters thus consists of ß and the component prob abilities for the distinct values taken on by the Yj -

The complete data are declared to be the observed data vector y and the hidden = zT)T , containing the component labels. The complete-data likelihood is given by log

$$
\log L _ { c } ( \varPhi ) & \, \equiv \, \log p ( z ) + \log f ( y \, | \, z ) \\ & \, = \, \log p ( z ) + \sum _ { i = 1 } ^ { g } \sum _ { j = 1 } ^ { n } \log f _ { i } ( y _ { j } ; \theta _ { i } ) ,
$$

where

$$
\log p ( z ) = \sum _ { i = 1 } ^ { 9 } z _ { i 1 } \log \pi _ { i } + \sum _ { h = 1 } ^ { 9 } \sum _ { i = 1 } ^ { 9 } \sum _ { j = 1 } ^ { 9 } z _ { h , j } z _ { i , j + 1 } \log \pi _ { h i } .
$$

$$
( 1 3 . 1 1 )
$$

<a id="sec-13-3-2"></a>

# 13.3.2 E-Step

The E-step requires the calculation of the conditional expectation of (13.10), given the observed data y. On taking this expectation; we have on the (k + 1)th iteration that

$$
= \sum _ { i = 1 } \tau _ { i 1 } ^ { ( k ) } \log \pi _ { 0 i } + \sum _ { h = 1 } ^ { g } \sum _ { i = 1 } ^ { g } \sum _ { j = 1 } ^ { n - 1 } \tau _ { h i j } ^ { ( k ) } \log \pi _ { P } \\ + \sum _ { i = 1 } ^ { g } \sum _ { j = 1 } ^ { n } \tau _ { i j } ^ { ( k ) } \log f _ { i } ( y _ { j } ; \theta _ { i } ) ,
$$

$$
( 1 3 . 1 2 )
$$

(k) where and T denote the current values of the conditional probabilities defined as Thij

$$
\tau _ { h i j } = \text {pr} \{ Z _ { h j } = 1 , \, Z _ { i , j + 1 } = 1 \, | \, y \} \quad ( j = 1 , \dots , n - 1 )
$$

and

$$
\tau _ { i j } = \text {pr} \{ Z _ { i j } = 1 \, | \, y \} \ \ ( j = 1 , \dots , n ) .
$$

From (13.13), we have that

and

$$
\tau _ { i j } = \sum _ { h = 1 } ^ { n } \tau _ { h i , j - 1 } \quad ( j = 2 , \dots , n )
$$

$$
\tau _ { i 1 } = \pi _ { 0 i } f _ { i } ( y _ { 1 } ) / \sum _ { h = 1 } \pi _ { 0 h }
$$

<a id="sec-13-3-3"></a>

# 13.3.3 Forward-Backward Recursions on E-Step

The posterior probabilities Thij and T;j can be expressed in terms of the following probabilities:

$$
a _ { i j } = p r \{ Y _ { 1 } = y _ { 1 } , \dots , Y _ { j } = y _ { j } , Z _ { i j } = 1 \} \ \ ( j = 1 , \dots , n )
$$

and

$$
b _ { i j } = \i \lceil Y _ { j + 1 } = y _ { j + 1 } , \dots , Y _ { n } = y _ { n } \rceil \ Z _ { i j } = 1 \} \quad ( j = n - 1 , n - 2 , \dots , 1 ) .
$$

Rabiner ( 1989) refers to the as the "forward' probabilities and to the bij as the can be expressed as @ij Thij

$$
\tau _ { h i j } = \frac { a _ { h j } \, \pi _ { h i } f _ { i } ( y _ { j + 1 } ) b _ { i , j + 1 } } { \sum _ { h = 1 } ^ { g } \sum _ { i = 1 } ^ { g } a _ { h j } \, \pi _ { h i } f _ { i } ( y _ { j + 1 } ) b _ { i , j + 1 } } ,
$$

$$
a _ { h j }
$$

since the numerator is pr{ Zhj = 1, =1Y = y} and the denominator is pr{Y=y} Zi,j+1

The values of\_ are calculated by forward recursion as follows on the (k + 1)th iteration.

<a id="sec-initialization"></a>

**Initialization:**

Induction:

$$
a _ { i 1 } ^ { ( k ) } = \pi _ { 0 i } ^ { ( k ) } f _ { i } ^ { ( k ) } ( y _ { 1 } ) \ \ ( i = 1 , \dots , g ) .
$$

$$
a _ { i , j + 1 } ^ { ( k ) } = [ \sum _ { h = 1 } ^ { g } a _ { h j } ^ { ( k ) } \pi _ { h i } ^ { ( k ) } ] f _ { i } ^ { ( k ) } ( y _ { j + 1 } ) \ \ ( j = 1 , \dots , n - 1 ) .
$$

<a id="sec-termination"></a>

**Termination:**

$$
\dots , Y _ { n } = y _ { n } ) = \sum _ { i = 1 } ^ { \tilde { \sum } _ { a _ { i } ^ { ( n ) } } ( p _ { i } ) }
$$

The values of are calculated by backward recursion as follows on the (k + 1)th iteration.

<a id="sec-initialization"></a>

**Initialization:**

Induction:

$$
b _ { h n } ^ { ( k ) } = 1 \ \ ( h = 1 , \dots , g ) .
$$

$$
^ { \prime } = \bigcup \lim i t s _ { h \in \mathbb { Z } } \pi _ { h } ^ { ( r _ { h } ) }
$$

The final computation in the E-step consists of plugging these values and the current parameter values into equation (13.18) as follows:

$$
\frac { a _ { h j } ^ { ( k ) } \, \pi _ { h i } ^ { ( k ) } f _ { i } ^ { ( k ) } ( y _ { j + 1 } ) b _ { i , j + 1 } ^ { ( k ) } } { \sum _ { h = 1 } ^ { g } \sum _ { i = 1 } ^ { g } a _ { h j } ^ { ( k ) } \, \pi _ { h i } ^ { ( k ) } f _ { i } ^ { ( k ) } ( y _ { j + 1 } ) b _ { i , j + 1 } ^ { ( k ) } } \quad ( j = 1 , \dots , n - 1 ) .
$$

$$
a _ { h j } ^ { ( k ) }
$$

<a id="sec-13-3-4"></a>

# 13.3.4 M-Step

The M-step consists in finding the updated estimates of the parameters from the Q function (13.12). They are acombination ofthe MLEs for the multinomial parameters and Markov chain transition probabilities. The updated parameters are computed as

$$
\pi _ { 0 i } ^ { ( k + 1 ) } = \tau _ { \tau }
$$

$$
\pi _ { h i } ^ { ( k + 1 ) } = \sum _ { j = 1 } ^ { n - 1 } \tau _ { h s } ^ { ( i ) }
$$

and

$$
f _ { i } ^ { ( k + 1 ) } ( y _ { j } ) = \sum _ { m = 1 } ^ { n - 1 } \tau _ { i m } ^ { ( k ) } \delta ( y _ { m } - y _ { j } ) / \sum _ { m = 1 } ^ { n - 1 } \tau _ { i m } ^ { ( k ) } ,
$$

v) is one if u = v and zero otherwise.

Recently, Dunmur and Titterington (1998a) studied the influence of initial condi tions on the ML estimation for a homogeneous binary Markov chain corrupted by binary channel noise. concluded that the MLEs are dependent on the initial estimates . In some cases, the algorithm converges not to a sensible solution; but to the fixed of the forward-backward algorithm used on the They point E-step.

<a id="sec-13-3-5"></a>

# 13.3.5 Numerical Instabilities

As explained in Leroux and Puterman (1992), the forward-backward algorithm for the calculation of thea;j and the bij is numerically unstable in many situations. This is because it impossible to calculate and store sequences. Various methods have been proposed for avoiding this problem in speech recognition (Devijver, 1985) In general , Leroux and Puterman (1992) suggest determining for each j the value of r for which 9) Then 0;,j+1 (i = 1, 9) is computed. A similar procedure is applied to the bij Afterward, the a;j and the bij can be reconstructed for the purpose of computing Tij and Thij; see also Turner, Cameron, and Thomson (1998). @ij long

<a id="sec-13-4"></a>

# 13.4 HIDDEN MARKOV RANDOM FIELD

Concerning more general Markov models, Qian and Titterington (1990) considered parameter estimation for the Gibbs chain, which is a more general model than the Markov chain model. Weconsider now estimation for ahidden MRF, which is perhaps the most familiar of more general HMMs. Here now the subscript j indexes a pixel site.

<a id="sec-13-4-1"></a>

# 13.4.1 Specification of Markov Random Field

The distribution of Z is specified by that of a Gibbs distribution;

$$
p ( z ) = \exp \{ - U ( $z_j$ \beta ) \} / C ( \beta ) ,
$$

where C(P) is a normalizingconstant (the partition function), and the energy function U($z_j$ ß) takes the form

$$
U ( $z_j$ \beta ) = \sum _ { \epsilon \in \mathcal { S } } V _ { \epsilon } ( $z_j$ \beta ) ,
$$

where S is a class of subsets of the sites, and V, is the potential function associated with subset s. In the context of images, the structure of the Gibbs function is intended to reflect plausible local, spatial correlation in the true scene; see Geman and Geman (1984) and Besag (1986). As in the hidden Markov chain case; the marginal density

We need the following notation Let

$$
j _ { r } \}
$$

contain the labels of r pixels in some prescribed neighborhood of pixel j, and put

$$
=
$$

The simplest departure from independence is a first-order MRF, in which the neighbors of each pixel j comprise its available N, S, E, and W adjacencies: On the boundary, where pixels have less neighbors; assumptions are made for convenience: A first-order assumption is viewed by Besag (1986) to be unrealistic for most practical purposes. For a second-order field, the available pixels which are diagonally adjacent to pixel j are included also. Thus each interior pixel j has eight neighbors.

Regarding possible choices for p(z) , Besag (1986) has found that his ICM algorithm has performed well for the (second-order) locally dependent MRF model for which

$$
1 \, | \, z _ { \partial j } \} \, \infty \, \exp ( \beta u _ { i j } ) ,
$$

where uij is the number of the prescribed neighbors of pixel j belonging to the ith component (i = 1, 9)

<a id="sec-13-4-2"></a>

# 13.4.2 Application of EM Algorithm

To examine the application of the EM algorithm to this more general HMM, we shall continue to assume that the feature vectors Uj are conditionally independent as specified by (13.3) But we no longer assume that each $Y_j$ is discrete.

From (13.3) and (13.20), the complete-data log likelihood is given by

$$
\log L _ { c } ( \Psi ) \ = \ \log p ( z ) + \sum _ { j = 1 } ^ { n } \log f ( y _ { j } \ | \ z _ { j } ; \xi )
$$

$$
\log L _ { c } ( \Psi ) & = \log p ( z ) + \sum _ { j = 1 } ^ { n } \log f ( y _ { j } \ | \ z _ { j } ; \xi ) \\ & = \ - U ( $z_j$ \beta ) - \log C ( \beta ) + \sum _ { i = 1 } ^ { g } \sum _ { j = 1 } ^ { n } z _ { i j } \log f _ { i } ( y _ { j } ; \theta _ { i } ) .
$$

The EMalgorithm for the hidden MRFisconsiderably more difficult. Asexplained by Qian and Titterington (1991),it is impossible to obtain an explicit solution via the EM algorithm where "explicit" means that an explicit formula exists; not requiring numerical integration or summation on the E-step nor iterative solution on the Mstep. To see this; the E-step on the (k + 1)th iteration requires the computation of the conditional expectation of (13.22), using the current fit <{k) for 4, which is given by

$$
3 ) - \log C ( \beta ) + \sum _ { i = 1 } ^ { y } \sum _ { j = 1 } ^ { n } \tau _ { i j } ^ { ( k ) }
$$

where

$$
W _ { \delta } ^ { ( k ) } ( \beta ) = E _ { \Psi ^ { ( k ) } } \{ V _ { i } ( $Z_j$ \beta ) \, | \, y ) \}
$$

and

$$
\tau _ { i j } ^ { ( k ) } = p r _ { \varPsi ^ { ( \tilde { k } ) } } \{ Z _ { i j } = 1 \, | \, y \} .
$$

Exact computation of both (13.24) and (13.25) is typically impossible (Kay and Titterington; 1986). Concerning the M-step, we have to calculate the updated value {(k+1) for € containing the distinct elements of 01, 0g known a to be distinct. It can be seen from (13.23) that the computation of involves the maximization of the same type of function as in the of a mixture model toiid. data. But maximization of (13.23) with respect to ß is not easy, in general, largely because the computation of the partition function C(ß) is hardly ever feasible. Thus; practical proposition: priori fitting

<a id="sec-13-4-3"></a>

# 13.4.3 Restoration Step

Qian and Titterington (1991) have suggested an approximation that replaces the Estep by a stochastic restoration For the E-step on the (k + 1)th iteration; the idea is to replace z in the complete-data likelihood by a current estimate of 2, 2(k) . The latter might be the segmentation obtained by running the ICM algorithm of (1986) or the maximum a posteriori (MAP) estimate of Geman and Geman (1984), based on the observed data y and the current estimate %(k) . In the case of binary images; the MAP estimate can be computed cxactly (Greig, Porteous; and Seheult, 1989). log Besag special

maximizes; Lc(w; z(\*)) , the complete-data log likelihood with 2 replaced by z(k) . However; this is analogous to using the classification ML approach as described in Section 2.21 to estimate the parameters in the component densities. As explained there, it leads to biased parameter estimates; see also Qian and Titterington (1991) on this in the present context. log point

<a id="sec-13-4-4"></a>

# 13.4.4 An Improved Approximation to EM Solution

As discussed in Qian and Titterington (1991), an improved estimator of & can be obtained using the idea of the pseudo likelihood: The latter was proposed by Besag (1975) as given by

$$
j = 1
$$

The maximizer of the pseudo likelihood is often consistent (Geman and Graffigne; 1987); see Cadez and Smyth (1998) for a recent application of it as an approximation to the MLE. Also, Dunmur and Titterington (1998b) have noted the link of the pseudo likelihood with the mean-field approximation as considered by Zhang (1992, 1993).

(1986), and Titterington (1986), and Qian and Titterington (1991, 1992) have considered approximationsto the EM algorithm for this problem. Ascan be seen from (13.23) and (13.25), we can carry out the maximization of the Q-function for updating the @; as for ii.d. data.This is provided that we can calculate the posterior (k) probabilities We can do this approximately if, analogous to the idea of the pseudo likelihood, we approximate p(z) as Kay Kay

Then

where

$$
\mathcal { B } ^ { ( k ) } ) = \prod _ { j = 1 } ^ { \infty } p ( z _ { j } \, | \, z _ { \theta j } ^ { ( k ) } ) .
$$

$$
y , z _ { \theta j } ^ { ( k ) } \} \\ \Big / \sum _ { h = 1 } ^ { g } \pi _ { h j } ^ { ( k ) } \, f _ { h } ( y _ { j } ; \theta _ { h } ^ { ( k ) } ) , \quad ( 1 3 . 2 8 )
$$

if we adopt model (13.21). Here It follows that if the 0; have no elements known a to be in common; then the updated estimate 0(\*+1) is a solution of priori

$$
u _ { i j } ^ { ( k ) } ) / \sum _ { h = 1 } ^ { j } \exp ( \beta ^ { ( k ) } u _ { h j } ^ { ( k ) } ) ,
$$

$$
( i = 1 , \dots , g ) .
$$

Analogous to the ICE algorithm as suggested by Owen (1986), we could replace u{j by

$$
i _ { m }
$$

$$
\sum _ { j = 1 } ^ { n } \tau _ { i j } ^ { ( k ) } \partial \log f _ { i } ( y _ { j } ; \theta _ { i } ) / \partial \theta _ { i } = 0 \quad ( i = 1 , \dots , g ) .
$$

If ß is not specified, but has to be estimated from the observed data; then @(k+1) can be computed by maximization of the pseudo likelihood

$$
j = 1
$$

<a id="sec-13-4-5"></a>

# 13.4.5 Approximate M-Step for Normal Components

To illustrate the above approximation to the EM solution, suppose that the ith component density is normal with mean #; and covariance matrix S; (i = 1, 9); that is,

$$
f _ { i } ( y _ { j } ; \theta _ { i } ) = \phi ( y _ { j } ; \mu _ { i } , \Sigma _ { i } ) .
$$

Then (13.30), we have that the updated estimates and $Z_j$ on the (k + 1)th iteration of the EM algorithm are given by using

and

where

$$
\mu _ { i } ^ { ( k ) } = \sum _ { j = 1 } ^ { \infty } \tau _ { i j } ^ { ( k ) } \, y _ { j } / \sum _ { j = 1 } ^ { \infty } \tau _ { i j } ^ { ( k ) }
$$

$$
\Sigma _ { i } ^ { ( k + 1 ) } = \sum _ { j = 1 } ^ { n } \tau _ { i j } ^ { ( k ) } \left ( y _ { j } - \mu _ { i } ^ { ( k + 1 ) } \right ) ( y _ { j } - \mu _ { i } ^ { ( k + 1 ) } ) ^ { T } / \sum _ { j = 1 } ^ { n } \tau _ { i j } ^ { ( k ) } ,
$$

$$
= \frac { \pi _ { i j } ^ { ( k ) } \phi ( y _ { j } ; \mu _ { i } ^ { ( k ) } , \Sigma _ { i } ^ { ( k ) } ) } { \sum _ { h = 1 } ^ { g } \pi _ { h j } ^ { ( k ) } \phi ( y _ { j } ; \mu _ { h } ^ { ( k ) } , \Sigma _ { h } ^ { ( k ) } ) } .
$$

<a id="sec-13-5"></a>

# 13.5 EXAMPLE 13.1: SEGMENTATION OF MR IMAGES

Tissue segmentation of multispectral magnetic resonance (MR) images of the human brain has a large potential to facilitate an imaging-based medical diagnosis. The segmentation of MR images provides a way to quantify the volume sizes of different tissue types of the human brain and then to display the tissue structures in three dimensions (3D). In particular, the existence of tumors and their volume sizes provide useful informationin the diagnosis of patients. On the other hand, accurate estimation of the tissue parameters may help to monitor changes in brain hemodynamics and metabolism resulting from neuronal activity.

Nget al. (1995) considered the segmentation of two-dimensional (2D) MR images, while McLachlan et al. (1996) considered the extension to the segmentation of 3D images where %; was recorded for a scene consisting of 2563 voxels. The vector U; contains the image intensities corresponding t0 T1 (the spin-lattice relaxation time)

In the example reported here from McLachlan et al. (1996), 3D MR images were acquired from the head of a volunteer with a 27-cm field of view. All images were during Fourier transformation. The imaging matrix was rotated so that the read and slow-phase directions were perpendicular to the principal axis of the hippocampus.

The contextual segmentation of these 3D images was carried out (with ß = 1) in the MRF specified by (13.21) The component densities were taken to be trivariate normal and their parameters estimated by (13.31) and (13.32) using the approximate version of the EM algorithm. The noncontextual segmentation was used to define initially the component memberships of the voxels in the images. Three groups were specified, corresponding to the three tissue types brain-white matter; brain-gray after removal of the regions from the image slice of one of the images, the Ti-weighted image; along with the segmented regions corresponding to CSF and the gray and white matter.

![image 36](mclachlan2000_images/imageFile36.png)

13.1 From top left-hand corner clockwise: Ti-weighted image and segmented regions corresponding to gray matter, CSF, and white matter. From McLachlan et al. (1996)

<a id="sec-13-6"></a>

# 13.6 BAYESIAN APPROACH

Robert et al. (1993) and Shephard (1994) have demonstrated that the hidden Markov chain model is amenable to Bayesian estimation based on Gibbs sampling. There are some difficulties for Bayesian estimation for the more general hidden MRF model, as considered by Qian and Titterington (1989, 1992), Robert and Titterington (1998), and Rydén and Titterington (1998). Robert, Rydén, and Titterington (1999) have proposed a series of on-line convergence controls for MCMC methods applied to hidden Markov chains.

The posterior density for the HMM is given by

$$
j = 1
$$

$$
( 1 3 . 3 4 )
$$

that & and ß are a independent. Bayesian estimation for this model can be implemented by posterior simulation the lines described in Chapter 4 for a mixture model fitted to ii.d. data, that is, for the hidden multinomial model . As for the latter model, Gibbs sampling can be used to generate realizations of the parameter vector; vector z For this to be practical, simulation from all the complete conditional distributions has to be easyRydén and Titterington (1998) have investigated this for HMMs and have provided modifications to the procedure tocombat any intractability. priori along

The generation of the parameter vector ( in the distribution of Z involves simu lating ß from

$$
( 1 3 . 3 5 )
$$

The generation of & can be undertaken in a manner similar to that for the hidden multinomial model . It involves simulating € from

$$
i = 1 j = 1
$$

$$
( 1 3 . 3 6 )
$$

Finally; the hidden component-indicator vector z can be undertaken by generating each $z_j$ from the conditional distribution

$$
p ( z _ { j } \ | \ z _ { \theta j } , y , \beta , \xi ) \circ p ( z _ { j } \ | \ z _ { \theta j } ; \beta )
$$

for j = 1, 1. This typically involves simulation from a binomial or multinomial distribution.

As explained in Rydén and Titterington (1998), simulation from (13.35) iseasy for a hidden Markov chain model if p(ß) is suitably chosen, since it involves simulating from Beta or Dirichlet distributions; see Robert et al. (1993). But in the case of the hidden MRF model, simulation from (13.35) runs into difficulties because p(z p) typically involves the partition function C(ß) .

Heikkinen and Högmander (1994) and Rydén and Titterington (1998) suggest replacing p(z P) by the pseudo likelihood pPL($z_j$ ß) defined by (13.26). The modified version of (13.35) is therefore

$$
( 1 3 . 3 8 )
$$

to (13.38) the BP estimate, VBP Rydén and Titterington (1998) establish some asymptotic properties of the MCMC procedures denoted by BL and BP.

also consider further versions of the BP solution obtained by using the pseudo likelihood formed from coarser partitions of the index set {1, 2, n} . For the general partition of this set into R blocks; {81, use the likelihood They pseudo they

$$
\left \{ \beta \right ) = \prod _ { r = 1 } ^ { R } p ( z _ { \delta _ { r } } \left | \, z _ { \theta ( \delta _ { r } ) } , \beta \right ) ,
$$

in the rth block &r , but excluding any points in &r from the combined neighborhood. The idea is that the block-pseudo likelihood might be more efficient than the point-pseudo likelihood. This was found to be the case in the examples considered by Rydén and Titterington (1998). points

In other Bayesian work on HMMs, Dunmur and Titterington (1997) have derived versions of the Gibbs sampler suitable for hidden Markov mesh random fields.

<a id="sec-13-7"></a>

# 13.7 EXAMPLES OF GIBBS SAMPLING WITH HIDDEN MARKOV CHAINS

In Section 4.8.4 on the Bayesian approach to mixture estimation, we described the approach of Robert and Titterington (1998) that enabled Gibbs sampling to be carried out without the need of a proper for the of univariate normal mixtures . Their results were presented for the more general hidden Markov chain model rather for independent data. Hence their methods can be used for Bayesian estimation for hidden Markov chain. Concerning the distribution for the transition bilities, modeled each row of the transition matrix by a Dirichlet distribution D(l, The priors and the simulation of the component parameters are essentially the same as discussed in Section 4.8.4 for the independent data case (that is, the hidden multinomial model). In particular; showed that their choice of a partially proper prior led to a proper posterior distribution for $\Psi$. prior fitting prior probathey they

For the same model as above; Robert and Titterington (1998) also the prior feedback method for the computation of the MLE. This method was discussed applied in Section 4.10 for the hidden multinomial model. As the component densities were normal with unequal densities; showed how to modify the density for the variances to ensure that the posterior density is bounded. also considered the case of Poisson component distributions. they prior \_ They We report here one of the examples in Robert and Titterington (1998) on some 341 univariate observations simulated from a three-component hidden Markov chain model with transition matrix In other recent work, Robert et al. (2000) have considered Bayesian inference in hidden Markov chains; reversible jump MCMC methods to enable the number of components 9 to be unspecified. Their work is therefore an extension of the approach of Richardson and Green (1997) for iid. data (the hidden multinomial mixture model) discussed in Chapter 4. As Robert et al. (2000) note, the Markovian structure together with the reversibility constraint lead to a higher level of complexity than in Richardson and Green (1997). using

$$
A = \left ( \begin{array} { c c c c } 0 . 6 2 & 0 . 2 5 & 0 . 1 3 \\ 0 . 0 9 & 0 . 1 8 & 0 . 7 3 \\ 0 . 2 1 & 0 . 6 2 & 0 . 1 3 \end{array} \right ) \, ,
$$

$$
( 1 3 . 4 0 )
$$

and corresponding normal components with means #1 = 3.37, and = 2.45, and variances 0? = = = 0.314. The Bayes estimate of the transition matrix A based on 5,000 iterations of the Gibbs sampler was

$$
\tilde { A } = \left ( \begin{array} { c c c c } 0 . 5 1 & 0 . 3 4 & 0 . 1 5 \\ 0 . 2 0 & 0 . 1 0 & 0 . 7 0 \\ 0 . 1 9 & 0 . 7 3 & 0 . 0 8 \end{array} \right ) \, .
$$

$$
( 1 3 . 4 1 )
$$

The estimated component means and variances were û1 = 0.207, Â2 = 3.34, and

Robert and Titterington (1998) then applied the fcedback method to this data set, using 30 iterations each with 5000 iterations of the Gibbs sampler. The posterior expectations of the component mean and variances so obtained are displayed in Figure 13.2. It can be seen that some of the prior feedback estimates are not yet stable after 30 iterations, although close to the true values of the parameters. At the end of the 30 iterations; the estimated transition matrix A was prior

$$
\hat { A } = \left ( \begin{array} { c c c } 0 . 6 5 & 0 . 2 7 & 0 . 0 9 \\ 0 . 2 0 & 0 . 0 7 & 0 . 7 3 \\ 0 . 1 6 & 0 . 8 2 & 0 . 0 2 \end{array} \right ) \, .
$$

= = 3.34, = =8.18, ô? = 0.336 , which Robert and Titterington (1998) noted does not differ considerably from the corresponding Bayes estimate (13.41), while closer to the true matrix (13.40). being

Means

25

3.0

25

20

1.5

1.0

0.5

0.0

Standard Deviations

25

30

Fig. 13.2 Convergence of the feedback estimates of the component means and variances of the normal hidden Markov chain model. From Robert and Titterington (1998). prior
