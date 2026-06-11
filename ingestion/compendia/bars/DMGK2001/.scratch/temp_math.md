--- ENRICHED TEXT OUTPUT ---

[Page 1]

Department of Statistics, Carnegie Mellon University, Pittsburgh, Pennsylvania 15213, U.S.A.

dimatteo@stat.cmu.edu genovese@stat.cmu.edu kass@stat.cmu.edu

We describe a Bayesian method, for ﬁtting curves to data drawn from an exponential family, that uses splines for which the number and locations of knots are free parameters. The method uses reversible-jump Markov chain Monte Carlo to change the knot conﬁgurations and a locality heuristic to speed up mixing. For nonnormal models, we approximate the integrated likelihood ratios needed to compute acceptance probabilities by using the Bayesian information criterion, , under priors that make this approximation accurate. Our technique is based on a marginalised chain on the knot number and locations, but we provide methods for inference about the regression coe ﬃ cients, and functions of them, in both normal and nonnormal models. Simulation results suggest that the method performs well, and we illustrate the method in two neuroscience applications.

Some key words : BIC; Generalised linear model; Nonparametric regression; Reversible-jump Markov chain Monte Carlo; Smoothing; Unit-information prior.

Smoothing splines are often appealing tools for curve estimation because they provide computationally e ﬃ cient estimation. They tend to do a good job in smoothing noisy data, and they have both frequentist and Bayesian interpretations (Hastie & Tibshirani, 1990; Wahba, 1990). However, in practice, smoothing splines have two shortcomings: they require speciﬁcation of a global smoothness parameter; and, conditionally on the choice of smoothness, they are linear estimators and thus have di ﬃ culty adapting to functions that are heterogeneous over their domains. The ﬁrst problem has been addressed through various data-driven methods, such as crossvalidation, for choosing the smoothness parameter, but such methods are not convincing in small samples and they o ﬀ er no measure of uncertainty in the estimated smoothness. The second problem is more fundamental. Whereas smoothing splines use many knots located at the data, an alternative that has been explored is to use fewer knots that are well placed (Denison et al., 1998; Lindstrom, 1999; Zhou & Shen, 2001; Biller, 2000; Hansen & Kooperberg, 2000; Halpern, 1973; Genovese, 2000; Eilers & Marx, 1996; Smith & Kohn, 1996). This approach is often called curve-ﬁtting with free-knot splines because the number of knots and their locations are determined from the data.

In this paper, we describe a fully Bayesian method for curve-fitting with free-knot splines for data drawn from an exponential family distribution, which we call Bayesian adaptive regression splines. Our implementation is based on reversible-jump Markov chain Monte Carlo (Green, 1995) and incorporates a key observation made by Zhou & Shen (2001). We compare our method's performance to both the Bayesian method of Denison et al. (1998) and the frequentist, iterative spatially adaptive regression spline method of Zhou & Shen (2001). Our method gives more accurate estimates of our test function than either of the others.


[Page 2]

Our method applies to independent data (X 1, Y 1 ),..., (X n, Y n ) that satisfy the following model:

$$
Y _ { i } | X _ { 1 }, \dots, X _ { n } \sim p \{ y | f ( X _ { i } ), \sigma \} \ \ ( i = 1, \dots, n ),
$$

where f is a real-valued function on [a, b], and s is an optional and potentially vectorvalued nuisance parameter. We think of the X i ’s here as observed explanatory variables. The goal is to estimate the unknown function f from these data under the assumption that f lies in some ﬁxed, and usually inﬁnite-dimensional, class of functions.

We focus on the special case when p(y | h, s ) is an exponential family distribution with dispersion parameter s.In particular, when p(.) is a N( h, s 2 ) distribution, we obtain the nonparametric regression model

$$
Y _ { i } = f ( x _ { i } ) + \varepsilon _ { i } \quad ( i = 1, \dots, n ), \quad ( 2 )
$$

where the e i are independent draws from N(0, s 2 ) and s > 0 is unknown.

Our method implicitly assumes that f is well approximated between a and b by a cubic spline with some number of knots. In practice, we will assume that f is such a spline. This class of cubic splines is quite large and approximates any locally smooth function arbitrarily well.

We will denote knot conﬁgurations by pairs (k, j ), where the number of knots k is a nonnegative integer and the knot locations are given by the kvector j = ( j 1,..., j k ), for a < x (1) < j 1 ∏...∏ j k < x (n) < b. Let b j (x), for j = 1,..., k + 2, denote the j th function in a cubic Bspline basis with natural boundary constraints, i.e. linear outside [a, b], and let B k, j be the matrix whose i, j component is b j (x i ). The subscript k, j expresses the dependence of the matrix B k, j on the number and locations of knots. Under our assumptions, we can write f as a linear combination

$$
f ( x ) & = \sum _ { j = 1 } ^ { k + 2 } \beta _ { j } b _ { j } ( x ) & ( 3 ) \\ \varrho & \quad \text {WS} \ \ 1 &
$$

for some vector b = ( b 1,..., b k + 2 ). We have the linear relation B k, j b = f(X) ¬ ( f(X 1 ),..., f(X n )) at the observed design points.

To complete the Bayesian formulation of the model, we must specify a prior on the unknown quantities b, s, k and j.In this paper, we use uniform or Poisson priors on k and a uniform prior on j induced by the uniform prior over the standard ksimplex by rescaling j to [a, b]. Given k and j, we use a particular conjugate Normal prior on b that Kass & Wasserman (1995) called the unit-information prior and, independently, the improper prior p s ( s ) = 1/ s.With these choices, the posterior under the Normal model (2) can be computed analytically. For example, b and s can be integrated out of the posterior in order to obtain a Markov chain for sampling from the marginal posterior on (k, j ):

$$
p ( y | k, \xi ) = \int p ( y | \beta, k, \xi, \sigma ) \pi ( \beta, \sigma | k, \xi ) \, d \beta \, d \sigma.\\ \intertext { a l $ e r $ l o d e $ ( 1 ) $, $ w e r l y $ o n $ a p r o x i m a t i o n $ $ f o r $ r a t i o n $ of m a r g i n a l i h o o d s }
$$

In the general model (1), we rely on an approximation for ratios of marginal likelihoods (4) in terms of the Bayesian information criterion, .Kass & Wasserman (1995) and


[Page 3]

Since the parameter space in the model (1) is a disjoint union of spline spaces, sampling from the posterior beneﬁts from the reversible jump Markov chain Monte Carlo technique introduced by Green (1995) and shown by him to be e ﬀ ective for estimating step functions with variable number and locations of the break points. Denison et al. (1998) generalised this approach to higher-order free-knot splines, producing a potentially powerful nonlinear regression method. However, Denison et al. (1998) avoided specifying a prior on b, preferring instead to plug in its least-squares estimator at each stage. This quasi-Bayesian solution a ﬀ ects how the method penalises dimensionality and often leads to severe overﬁtting.

We use a reversible-jump Metropolis–Hastings Markov chain Monte Carlo simulation on the (k, j ) pairs, with b and s marginalised out. Since we use a fully Bayesian formulation, inferences on b and s can be included with additional post hoc simulations as desired. We can use the results to estimate f with a mean of the posterior sample from f(x) which is a function of b.The mode can also be useful in some cases; while the mean is analytically and computationally tractable, the mode avoids averaging over disparate structures when there are many qualitatively di ﬀ erent functions in regions of high posterior density. By using a spline basis, introducing the unit-information prior and approximating with the , we are able to employ essentially the same Markov chain Monte Carlo implementation with the general model (1) as with the Normal model (2).

In § 2, we provide further details about our choice of priors and our approximation to the likelihood ratios. In § 3, we discuss further details of our posterior simulation. In § 4, we show the results of simulations for three elementary test functions. In §§ 5 and 6, we apply the method to two real datasets. The former uses the Normal model (2) to analyse functional magnetic resonance imaging data; the latter uses a Poisson model based on (1) to estimate the time-intensity function of neuronal ﬁring in a monkey’s brain. Finally, in § 7, we discuss several possible reﬁnements and extensions of our method.

We begin by treating model (2). It is convenient, though not essential as we show below, to use a prior for which (4) may be obtained analytically. We decompose the prior as follows:

$$
\pi ( \beta, k, \xi, \sigma ) = \pi _ { \beta } ( \beta | \xi, k, \sigma ) \pi _ { \xi } ( \xi | k ) \pi _ { k } ( k ) \pi _ { \sigma } ( \sigma ),
$$

where p s ( s ) = 1/ s and mation in the prior, represented by the covariance matrix, is equal to the amount of information in one observation, as represented by the Fisher information matrix. A prior very similar to (5) was used by Smith & Kohn (1996) in a different but related context of spline knot selection, where instead of n in (5) they used a constant between 10 and 1000 which they judged to work well for the data they examined.

$$
\beta | k, \xi, \sigma \sim N _ { k + 2 } \{ 0, \sigma ^ { 2 } n ( B _ { k, \xi } ^ { T } B _ { k, \xi } ) ^ { - 1 } \} .
$$

The remaining priors on j and k could be chosen to express knowledge about these parameters or, equivalently, to force some desired behaviour in the posterior. In our simulations and applications below, we have adopted a prior on j given k induced by a Dir(1, 1,..., 1) prior on the ksimplex by scaling [a, b] to [0, 1]. For k we also adopted a Poisson prior or Uniform prior on {1,..., K 0 }. In many applications, the results are unlikely to be very sensitive to the precise speciﬁcation of the prior on k.

For linear regression models Y = X b + e, with the more general design matrix X replacing B k, j, priors of the form (5) have been used by many authors (Pauler, 1998). Kass & Wasserman (1995) have called these ‘unit-information’ priors because the amount of infor-


[Page 4]

With these choices of priors on b and s, we can compute analytically the marginal posterior for ( j, k) via equation (4). This makes it easy to compute the likelihood ratios p(y | j c, k c )/p(y | j, k), that are used in the reversible jump algorithm to determine whether or not to move from state (k, j ) to candidate state (k c, j c ). For example, one type of move in our Markov chain Monte Carlo implementation involves the addition of a knot. If the current state is (k, j ) and the candidate state is (k c = k + 1, j c ), then the likelihood ratio becomes

$$
\frac { p ( y | k ^ { c }, \xi ^ { c } ) } { p ( y | k, \xi ) } = \frac { 1 } { \sqrt { ( n + 1 ) } } \left ( \frac { y ^ { T } \{ I _ { n } - n ( n + 1 ) ^ { - 1 } B _ { k, \xi } ( B _ { k, \xi } ^ { T } B _ { k, \xi } ) ^ { - 1 } B _ { k, \xi } ^ { T } \} y } { y ^ { T } \{ I _ { n } - n ( n + 1 ) ^ { - 1 } B _ { k, \xi ^ { c } } ( B _ { k, \xi } ^ { T } B _ { k, \xi ^ { c } } ) ^ { - 1 } B _ { k, \xi ^ { c } } ^ { T } \} y } \right ) ^ { n / 2 }.\quad ( 6 ) \\ \text {Similarly, we can obtain disjointly all the conditions} .
$$

Similarly, we can obtain analytically the conditional posterior expectation

$$
E \{ f ( x ) | k, \xi, y \} = \frac { n } { n + 1 } \, B _ { k, \xi } ( B _ { k, \xi } ^ { T } B _ { k, \xi } ) ^ { - 1 } B _ { k, \xi } ^ { T } y \simeq B _ { k, \xi } \hat { \beta },
$$

for any x. The posterior expectation E{f(x) | y} can then be computed by averaging this conditional expectation over (k, j ) samples. This expectation is the Bayes estimator f @ (x) for f (x) under squared-error loss.

When we are making inferences about functionals of f, the uncertainty in b cannot be ignored. With our choice of priors in the normal model, p( b | y, j, k) can be computed analytically, making it easy to assess the uncertainty in b after a simulation on j and k alone. To do this, we draw a value from this posterior for each (k, j ) sample from our chain.

In the more general model (1), we use the same priors. However, it is often infeasible in this case to obtain analytical expressions such as those above. With the unit information prior (5) on b, the likelihood ratio p(y | j c, k c ) / p(y | j, k) in the Markov chain Monte Carlo can be approximated using the  with an error of O(n − D ), and this produces a posterior distribution on (k, j ) that also has an error of O(n − D ); see Appendix 3. Examples in Kass & Wasserman (1995) show that  often produces a very good approximation to the unit-information posterior in practice. Implementation requires maximum likelihood estimators b @ under each spline model, which are often easily computed with standard software. In particular, conditionally on j and k and when the data are drawn from an exponential family distribution, our model in equation (1) becomes a generalised linear model (McCullagh & Nelder, 1989). @

The use of b, that is integrating out the coe ﬃ cients in the chain, is a key feature of both our method and the method of Denison et al. (1998). This approach has two advantages. First, it speeds up the simulation by reducing the dimensionality of the parameter space with minimal additional cost to compute b @.Secondly, it facilitates the jumps between spline models because such moves no longer require a delicate re-balancing of the coe ﬃ cients when knots are added or deleted (Genovese, 2000). However, it is essential that the uncertainty in b be accounted for in the ﬁnal inferences. In the normal model, the simulation on (k, j ) and ( b, s ) can be decoupled because we have analytical expressions for the marginalised expectations. Thus, we can draw samples of ( b, s ) at each step as


[Page 5]

While our method and the spatially adaptive regression spline method of Zhou & Shen (2001) share many features, the primary contrast between the two is that ours is a fully Bayesian simulation method while spatially adaptive regression spline is a frequentist, iterative method. The primary contrast between our method and that of Denison et al. (1998) is that the two Markov chains have di ﬀ erent equilibrium distributions. Denison et al. (1998) do not use a prior on b but instead replace the likelihood ratio p(y | j c, k c )/p(y | j, k) with p(y | b @ c, j c, k c )/p(y | b @, j, k). This plug-in approximation with the least-squares estimator produces a version of the marginal density p DMS (y | j, k) that is monotonically increasing in k; we are more speciﬁc in Appendix 3. As a consequence, unlike that based on , the equilibrium distribution produced by the chain with the plug-in approximation does not have the desired properties: the data cannot be informative about the number of knots, the procedure will tend to overﬁt, and the e ﬀ ect of the prior on k will not vanish as the dataset gets large, since the likelihood will become roughly constant in k as k increases. Indeed, experimentation using the software kindly provided by Denison et al. (1998) displays extreme sensitivity of the posterior on k to the choice of prior on k. Incidentally, we can also see this in the likelihood ratio approximation for the normal model in equation (6) by

$$
& \text {uncoharmonic moduler in equation (0) by} \\ & \quad \frac { p ( y | k, \xi ^ { c } ) } { p ( y | k, \xi ) } \simeq \frac { 1 } { \sqrt { n } } \left ( \frac { ( y - B _ { k, \xi } \hat { \beta } ) ^ { T } ( y - B _ { k, \xi } \hat { \beta } ) } { ( y - B _ { k, \xi } \hat { \beta } ^ { c } ) ^ { T } ( y - B _ { k, \xi } \hat { \beta } ^ { c } ) } \right ) ^ { n / 2 } = \exp ( - \text {BIC/2} ), \\ & \text {where } \hat { \beta } \text { are the least-squares estimates. The method of Denison et al. (1998) omits the}
$$

k, k, where b @ are the least-squares estimates. The method of Denison et al. (1998) omits the consequential factor 1/ √ n in (8), which  includes to penalise the likelihood ratio for dimensionality.

As we indicated in § 1, the framework we have adopted produces a Markov chain with the marginal posterior on (k, j ) as stationary distribution. The Metropolis–Hastings acceptance probability combines the likelihood ratio discussed earlier, a prior ratio p k, j (k c, j c )/ p k, j (k, j ), where p k, j (k, j ) = p j ( j | k) p k (k), and an asymmetry correction q(k, j | k c, j c )/q(k c, j c | k, j ), where q is the proposal density (Tierney, 1994). We use the general scheme used by Green (1995) and Denison et al. (1998), which involves moves that add, delete and relocate knots. In contrast to Denison et al. (1998), where new knots are generated ‘far’ from existing knots, our chain uses the locality heuristic devised in Zhou & Shen (2001), which is based on the idea that more knots are needed where the curve changes rapidly. The heuristic holds that a new knot is more likely to be needed in regions where knots have recently been added.

Let M k represent a model parameterised by (k, j 1,..., j k ). The addition, deletion and relocation steps of the reversible-jump sampler are attempted, respectively, with the following probabilities:

$$
b _ { k } = c \min \{ 1, p ( k + 1 ) / p ( k ) \}, \ \ d _ { k } = c \min \{ 1, p ( k - 1 ) / p ( k ) \}, \ \eta _ { k } = 1 - b _ { k } - d _ { k } .
$$

These probabilities ensure that b k p(k) = d k + 1 p(k + 1). Appendix 1 contains a proof of detailed balance for the following proposal scheme.

Birth step. Suppose that the current model M k contains k knots located at j 1,..., j k.To generate a new candidate knot we first choose one knot uniformly from the set of existing knots. Let j j * be such a knot. The candidate new knot, j cand, is generated by a distribution centred at j j * with some spread parameter t B having density h B ( j cand | j, t B ). In this case the jump probability is given by


[Page 6]

$$
q ( M _ { k + 1 } | M _ { k } ) = b _ { k } \, \frac { 1 } { k } \sum _ { i } h _ { B } ( \xi _ { c a n d } | \xi _ { i } ) ;
$$

in the expression q(M k + 1 | M k ) there is a mixture of densities because the new knot j cand can be generated by any of k di ﬀ erent distributions.

Death step. The candidate knot for deletion is chosen uniformly from the set of existing knots. Let M k be the current model. Then the jump probability of going from M k to M k − 1 is

$$
q ( M _ { k - 1 } | M _ { k } ) = d _ { k } \frac { 1 } { k } .
$$

Relocation step. We ﬁrst choose a candidate knot j j * uniformly from the set of existing knots { j 1,..., j k }. The candidate new location, j cand, for the knot j j * is generated by a distribution centred at j j * with spread parameter t R and having density h R ( j c | j j *, t R ). T

Let j = ( j 1,..., j j * − 1, j j *, j j * + 1,..., j k ) be the current sequence of knots, and let j c = ( j 1,..., j j * − 1, j cand, j j * + 1,..., j k ) T be the candidate new sequence of knots, which di ﬀ ers from j only in the replacement of knot j j * by knot j cand.Note that the candidate new location does not have to be the j* th element. The jump probability is computed as follows:

$$
q ( M _ { c a n d } | M _ { c u r r } ) = \eta _ { k } \, \frac { 1 } { k } \, h _ { R } ( \xi _ { c a n d } | \xi _ { j ^ { * } } ) .
$$

Candidate distributions. One convenient choice for the birth and relocation proposal distributions, with densities h B and h R, would be Beta distributions. The precise form, however, is not likely to make much di ﬀ erence. Once these are selected, it remains to choose values of parameters c, t B and t R.In principle, these may be regarded as tuning parameters, adjusted to produce a chain having good acceptance probabilities.

Here, we choose the constant c to be 0·4 as in Denison et al. (1998); a limited study of our own suggests that this is a good value. We take both the birth and relocation proposals to be Beta distributions with parameters j j * n and (1 − j j * ) n, and we choose n = 50 in our examples. We obtained essentially the same results using for the birth and relocation densities h B and h R a Normal distribution with mean j j * and variance t 2, truncated to [ j j * − 2, j j * + 2 ].

The reversible-jump scheme described in § 3·1 produces a chain on (k, j ). As we indicated in § 2, under model (2) we can obtain draws from the marginal posterior on b, to make inferences about characteristics of f, by also drawing a value of b from the conditional posterior of b given (k, j ) for each sampled value of (k, j ). Under model (1), however, it is usually infeasible to calculate this distribution directly, so additional simulation is required. To avoid a lengthy Markov chain Monte Carlo simulation at each knot conﬁguration from the original chain, we use importance reweighting. This allows more


[Page 7]

Denote by g( b, k, j ) some feature of the curve, such as the location of its maximum, that we wish to estimate. Let q( b | y, j, k) 3 p(y | b, k, j ) p b ( b | k, j ). The posterior expectation of g( b, k, j ) given y may be computed from

$$
of g ( \beta, k, \xi ) \text { given } y \text { may be computed from} \\ & \quad \int \dots \int g ( \beta, \xi, k ) \frac { q ( \beta | y, k, \xi ) } { \hat { q } ( \beta | y, \xi, k ) } \, \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k \\ & \quad E \{ g ( \beta, \xi, k ) | y \} = \frac { } { \int \dots \int } \sum _ { \hat { q } ( \beta | y, \xi, k ) } ^ { \underline { q } ( \beta | y, k, \xi ) } \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k \\ & \quad \simeq \frac { \sum _ { l } g ( \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) w ( \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) } { \sum _ { l } w ( \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) }, \\ \text {where}
$$

where

$$
w ( \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) = \frac { q ( \beta ^ { ( l ) } | y, \xi ^ { ( l ) }, k ^ { ( l ) } ) } { \hat { q } ( \beta ^ { ( l ) } | y, \xi ^ { ( l ) }, k ^ { ( l ) } ) },
$$

( j (l), k (l) ) is the pair accepted by the reversible-jump sampler, i.e. sampled from p(k, j | y), and b (l) is sampled from a suitable approximation q @ to the conditional posterior of b given (k, j ). In fact, we may approximate the likelihood function on b given (k, j ) rather than the full conditional posterior, which is typically easier under model (1), yielding weights of the form

$$
w ( \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) = \frac { p ( y | \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) } { \hat { p } ( y | \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) } .
$$

A standard choice for p @ would be a multivariate t density (Evans & Swartz, 1995). Veriﬁcation that the importance weights are correct when q/q @ is replaced by p/p @ is straightforward; see Appendix 2. From this method of computing posterior expectations we may also obtain posterior variances and posterior interval probabilities.

Our implementation has two key features: ﬁrst, we use a fully Bayesian approach, together with a  approximation to the marginal density (4) and, secondly, we use the locality heuristic of Zhou & Shen (2001) to place new knots. Both of these choices may be contrasted with the implementation of Denison et al. (1998). In our simulation study we compute mean squared error for our Bayesian adaptive regression splines and compare with spatially adaptive regression splines, using the software of Zhou & Shen (2001), and with the Denison et al. method, using software available at http: // www.ma.ic.ac.uk / ~ dgtd. We also investigate the relative importance of the two implementation changes by comparing with what we call the modiﬁed Denison et al. method, which includes the  approximation but not the change in candidate knot locations; we computed the modiﬁed Denison et al. method by inserting the required factor 1/ √ n into their code and recompiling. The Bayesian adaptive regression spline estimates of E{f(x) | y} = E[E{f(x) | y, k, j }] are found from our Markov chain Monte Carlo with runs of length 10 000 following burn-ins of 1000.

In this section we consider three functions: a slowly-varying smooth function, a function with a sharp peak, that is spatially inhomogeneously smooth, and a function with a discontinuity. Noise is added to each in generating the data. The functions together with samples of data are shown in Fig. 1.


[Page 8]

(b) Example 2

(c) Example 3

(a) Example 1

6

2

4

10

1

2

f

(

x

)

f

(

x

)

f

(

x

)

0

0

5

–2

–1

–4

0

0·0

0·2

0·4

0·6

0·8

1·0

0·0

0·2

0·4

0·6

0·8

1·0

0·0

0·2

0·4

0·6

0·8

1·0

x

x

x

Fig. 1. The three true functions used in the simulation study together with one sample.

Example 1. The true function is a spline with three internal knots at (0·2, 0·6, 0·7) T and coe ﬃ cients b = (20, 4, 6, 11, 6) T.The function is evaluated on a regular grid of 101 points, and a zero-mean Normal noise is added to the true function with s = 0·9, so that the signal-to-noise ratio,  ( f )/ s, is 3.

Example 2. The true function is

$$
f ( x ) = \sin ( x ) + 2 \, \exp ( - 3 0 x ^ { 2 } ), \ \ x \in [ - 2, 2 ],
$$

evaluated at 101 regularly spaced points, and the standard deviation of the noise is chosen to be s = 0·3, so that again the signal-to-noise ratio is 3.

Example 3. The true function is a spline with ﬁve knots located at (0·4, 0·4, 0·4, 0·4, 0·7) and coe ﬃ cients (2, − 5, 5, 2, − 3, − 1, 2). The function is evaluated on a regular grid of 201 points in [0, 1], and zero-mean Normal noise is added to the true function with s = 0·55.

We compare our Bayesian adaptive regression splines estimates with spatially adaptive regression splines, Denison et al. (1998), and our modiﬁed Denison et al. estimates using mean squared error

$$
M S E = \frac { 1 } { n } \sum _ { i = 1 } ^ { n } \left \{ \hat { f } ( t _ { i } ) - f ( t _ { i } ) \right \} ^ { 2 }.\\
$$

The average mean squared error, together with standard errors, based on 10 samples of data is reported in Table 1. The Bayesian estimates in Table 1 are all based on a Poisson prior with mean 5 for the number of knots, k. However, when we used a Uniform prior on 1,..., 20 or a Poisson with mean ranging in value between 1 and 20, the mean squared error never changed by more than 25% across these examples, and these changes do not alter the basic ordering found.

We see from Table 1 that Bayesian adaptive regression splines produces values of mean squared error that are smaller than those from Denison et al. (1998) and spatially adaptive regression splines across all three test functions. The modiﬁed Denison et al. method works well for Example 2 and always improves on the original Denison et al. (1998).


[Page 9]

Table 1. Simulation study. Average mean squared errors with estimated standard errors in brackets based on 10 samples obtained using four di V erent procedures





Modiﬁed



Example 1

0·144 (0·030)

0·206 (0·029)

0·103 (0·019)

0·066 (0·007)

Example 2

0·015 (0·001)

0·025 (0·002)

0·012 (0·001)

0·008 (0·001)

Example 3

0·044 (0·006)

0·106 (0·007)

0·091 (0·004)

0·019 (0·003)

Methods: , spatially adaptive regression splines; , Denison et al. (1998); Modiﬁed, modiﬁed Denison et al.; , Bayesian adaptive regression splines.

However, in Examples 1 and 3, Bayesian adaptive regression splines provides substantial further improvement, in part as a result of the locality heuristic for generating new knots. In Fig. 2, we see the true function of Example 3 together with its estimates obtained using di ﬀ erent procedures. Figure 2 suggests that the success of Bayesian adaptive regression splines results from its avoiding overﬁtting and its ability to adapt to sharp jumps in the curves.

(

)

f

x

6

4

2

0

_

2

_

4

_

6

(a) SARS

0·0

0·2

0·4

0·6

x

0·8

1·0

(

)

f

x

6

4

2

0

_

2

_

4

_

6

(b) DMS

0·0

0·2

0·4

0·6

x

0·8

1·0

(

)

f

x

(c) ModiﬁedDMS

6

4

2

0

_

2

_

4

_

6

0·0

0·2

0·4

0·6

0·8

1·0

x

(

)

f

x

6

4

2

0

_

2

_

4

_

6

(d) BARS

0·0

0·2

0·4

0·6

x

0·8

1·0

Fig. 2. Simulation study. Comparisons of the estimates of the discontinuous function of Example 3: solid lines, true curves; dashed lines, estimates of the curve. Methods: , spatially adaptive regression splines; , Denison et al. (1998); Modiﬁed, modiﬁed Denison et al.; , Bayesian adaptive regression splines.

For the functions in both Examples 1 and 3 the posterior mode for the number of knots is the true number of knots, which is three and ﬁve respectively, and the conditional posterior of the locations of the knots given that the modal number of knots is concentrated around the true locations of the knots.


[Page 10]

In a functional magnetic resonance imaging experiment, a subject is placed in a magnetic resonance scanner and asked to perform a sequence of behavioural tasks while threedimensional images of the subject’s brain are acquired at regular intervals. Concentrated neural ﬁring in the brain gives rise to a localised physiological response that is detectable in the images as a small, localised signal change. An analysis of functional magnetic resonance imaging data attempts to identify and characterise these task-related signal changes amidst a complicated noise process and other nuisance sources of variation; see Genovese (2000) for more details.

We consider two simple experiments in which the subject maintains visual ﬁxation on a cross in the centre of the visual ﬁeld while alternating Ssecond periods of rest and an experimental task. In Experiment 1, S = 8 and the task is to tap the thumb and foreﬁnger together. In Experiment 2, S = 42 and the task is to note the location of a ﬂash of light which appears at a random location in the visual ﬁeld. Figure 3 shows magnetic resonance signal time-courses for the two experiments. The signals are taken from small volumes in the brain that are activated by the respective experimental tasks; the task-related signal changes in response to performing the experimental task are visible in both cases.

(a)

Experiment 1

2000

1950

1900

1850

60

0

10

20

30

40

50

Time (sec)

(b)

Experiment 2

600

500

400

300

0

200

400

Time (sec)

600

800

Fig. 3. Magnetic resonance example. The time-courses show the magnetic resonance signal as a thin dotted line. (a) shows the signal for Experiment 1 measured in one volume element over time in ‘local magnetic resonance units’ that depend on the scanner and pre-processing used. Superimposed on the signal are the Bayesian adaptive regression splines ﬁt, solid line in (a), and the spatially adaptive regression spline ﬁt, dashed line. (b) shows the signal for Experiment 2. Superimposed are the spatially adaptive regression spline ﬁt (dashed line), the Bayesian adaptive regression spline ﬁts using a Po(20) prior (solid line) and a Po(3) prior (dotted line) on the number of knots.

Bayesian adaptive regression splines can be useful in functional magnetic resonance imaging in many di ﬀ erent roles. We discuss two here: (i) a ﬂexible denoiser for magnetic resonance time-courses, where all smooth sources of variation are combined into the function being estimated, and (ii) a component in a semiparametric model that explicitly parameterises the task-related signal changes while treating nuisance variation such as drifts ﬂexibly. The ﬁrst approach can serve as a front-end to spatial and regional analyses and group comparisons, automatically incorporating variations in response shape and magnitude across the replicated task blocks in the experiment. The second approach can serve as a component in a hierarchical model for the data and can be used to characterise


[Page 11]

To illustrate the method’s role as a ﬂexible denoiser, Fig. 3(a) compares the denoised time-courses given by Bayesian adaptive regression splines and spatially adaptive regression splines for Experiment 1. Both methods give similar results and appear to capture the gross signal changes quite well. Spatially adaptive regression splines better captures the small, sharp undershoot dips after the main response peak, but Bayesian adaptive regression splines appears more stable near the boundaries of the interval. Both methods give sharper activation peaks than the data seem to suggest by eye. Figure 3(b) presents a similar comparison for Experiment 2, where the signal changes are smaller relative to the noise and where there is a notable nuisance signal drift. Spatially adaptive regression splines detects some of the task-related signal changes but smooths over others near the drift changepoint. Bayesian adaptive regression splines, on the other hand, captures all of the responses reasonably. Figure 4 displays pointwise 95% high posterior density and conﬁdence intervals for these estimates; the spatially adaptive regression splines conﬁdence intervals were generated with 1000 samples from a parametric bootstrap treating the noise at each time point as independent and identically distributed normals.

(b)

(c)

(a)

600

600

600

500

500

500

400

400

400

300

300

300

0

200

400

600

800

0

200

400

600

800

0

200

400

600

800

Time (sec)

Time (sec)

Time (sec)

Fig. 4. Magnetic resonance example for Experiment 2. (a) and (b) show 95% high posterior density Bayesian adaptive regression splines, and (c) shows 95% conﬁdence spatially adaptive regression splines intervals (all as thin solid lines), for the curve estimate (solid line) superimposed on the signal (thin dotted line) for the estimates of the curve using Bayesian adaptive regression splines with Poisson prior in (a) with mean 20, and (b) with mean 3, and using spatially adaptive regression splines in (c).

To illustrate the method’s role as a semiparametric model component, we use Bayesian adaptive regression splines as part of an additive model with a ﬂexible component for signal drift and a parametric component for task-related signal changes. For example, if we set the prior on the number of knots to a smooth setting, for example Po(3), we obtain the estimate in Fig. 3(b) and Fig. 4(b). Figure 5 shows the semiparametric ﬁt obtained by adding a periodic parametric component to our model. Through the back-ﬁtting algorithm (Hastie & Tibshirani, 1990, Ch. 4) we ﬁt an additive model in which the function is decomposed into a sinusoid of the same period as the experimental design and a smooth component as just described. Figure 5 shows the estimate of the function and the extracted signal drift component, and Fig. 4 shows corresponding 95% high posterior density and conﬁdence intervals. We could also use Bayesian adaptive regression splines for the taskrelated component by ﬁtting each task block with a separate additive term, though at


[Page 12]

600

500

400

300

0

200

400

600

800

Time (sec)

Fig. 5. Magnetic resonance example. The time-course shows the magnetic resonance signal for Experiment 2. Superimposed on the signal, thin dotted line, is a semiparametric ﬁt, solid line, together with the nonparametric estimate of the linear trend, dashed line.

In a recent experiment, the ﬁring of individual neurons in the inferotemporal cortex of a macaque monkey were recorded while he watched images appear on a screen in front of him (Olson & Rollenhagen, 1999). In one experimental condition, Condition 1, a black patterned object was displayed as the stimulus for 600 milliseconds. In a second condition, Condition 2, prior to the display of the stimulus a pair of blue rectangles were displayed and these remained illuminated while the stimulus was displayed. The typical inferotemporal neuronal response to the stimulus was roughly damped-oscillatory ﬁring. In the second condition, however, the oscillation tended to be more pronounced, with higher drop from peak to trough. We use the methodology developed in §§ 2 and 3 to ﬁt the data for one neuron and quantify the comparison of initial peak-to-trough drop in ﬁring rates.

The data consist of neuronal spike counts from 193 repeated trials binned into 10-millisecond intervals. As discussed in a related context by Kass & Ventura (2001) and Ventura et al. (2001), such count data may be expected to be very nearly Poisson, and preliminary examination of the data indicated that this assumption was very reasonable. The model we use, therefore, for the counts {Y i, i = 1,..., n} at time {x i, i = 1,..., n} is as follows:

$$
( Y _ { i } | \beta, k, \xi ) \sim \text {Po} ( \lambda _ { i } ), \ \log ( \lambda _ { i } ) = B ( x _ { i } ) \beta, \quad \beta | k, \xi \sim N ( 0, D ), \ \ p ( k, \xi ),
$$

where D is the matrix from the unit-information prior. We do not have to write down D explicitly because, as explained in §§ 2 and 3, we use the  -based reversible-jump Markov chain Monte Carlo scheme together with importance reweighting. As our importance function for the posterior on b, we have used a Normal approximation based on the maximum likelihood estimates and the observed information matrix. Comparison of the results before and after importance reweighting indicates that the Normal distribution is in fact a good approximation. We did all our computations in S-Plus.


[Page 13]

(a) Condition 1

250

200

150

100

50

0

_

_

_

_

_

795

605

405

205

5

195

395

595

795

Time (msec)

250

(b) Condition 2

200

150

100

50

0

_

795

_

605

_

405

_

205

_

5

Time (msec)

195

395

595

795

Fig. 6. Neuronal ﬁring example. Counts in 10 millisecond bins together with the ﬁtted curves, representing posterior means E{f(t) | y }.


[Page 14]

The resulting Bayesian adaptive regression splines ﬁts for the posterior means E{f(t) | y} are given together with the raw counts in Fig. 6. Bayesian adaptive regression splines nicely adapts to the changing irregularities of the intensity functions producing estimates that are consistent with intuition: the intensities may change sharply on time scales of about 50 milliseconds, but are quite smooth on ﬁner time scales. Table 2 gives the posterior means and posterior standard deviations for the quantities of interest. The maximal ﬁring rate was, for example, deﬁned as g( b, k, j ) = arg max t f(t) j arg max t i B b.The substantive conclusion is that the drops from the ﬁrst, highest peak to the following trough for Conditions 1 and 2 were 131·8 ± 4·4 and 181·8 ± 20·3 spikes per second; Condition 2 had a more pronounced drop, estimated to be 50·0 ± 20·8 spikes per second greater than that for Condition 1, with 95% probability interval (8·4, 91·7).

Table 2. Neuronal ﬁring example. Posterior means of maximal ﬁring rate, local minimal ﬁring rate just after the maximal ﬁring rate, and the drop, i.e. the di V erence between these two ﬁring rates, for each condition. Posterior standard deviations are shown in parentheses

Firing rate

Condition 1

Condition 2

Maximum

166·5 (5·2)

193·0 (20·6)

Local min.

34·8 (1·9)

11·5 (1·5)

Di ﬀ erence

131·8 (4·4)

181·8 (20·4)

Bayesian adaptive regression splines is a fully Bayesian, ﬂexible spline model suitable for both normal and nonnormal data. It provides a mechanism for deriving useful uncertainties in function estimates and can easily be inserted as a component in a larger hierarchical model, as we have demonstrated here in § 5. Balancing against this advantage is the additional computational cost of the simulation: spatially adaptive regression splines is notably faster than Bayesian adaptive regression splines. However, this should not be a serious handicap in applications involving small or moderately large datasets. Key advantages of the method adopted here that distinguish it from the closely related approach applied by Biller (2000) are the placement of knots by a continuous proposal distribution and the introduction of the unit-information prior as a default, so that the chain simulates the approximate marginal posterior of (k, j ) after integrating b ; this increases e ﬃ ciency (Liu et al., 1994).

Bayesian adaptive regression splines results and performance depend to some extent on the choice of knot priors. Thus, user input on the expected number of knots is needed as a kind of smoothing parameter. We used this to our advantage in the functional magnetic resonance imaging example to adapt Bayesian adaptive regression splines to di ﬀ erent tasks. However, for large signal-to-noise ratios, or large samples, Bayesian adaptive regression splines will correctly ﬁnd the appropriate number of knots regardless of the prior.

This paper has focused on estimates and standard errors, but one big advantage of a Bayesian formulation is the ability to estimate a wide range of features for the function of interest. We intend to explore Bayesian adaptive regression splines’ e ﬀ ectiveness as a component of Bayesian hierarchical models in future work.


[Page 15]

This research was partially supported by grants from the U.S. National Science Foundation and National Institutes of Health.

In order to prove that detailed balance holds for this chain, we have to show that

$$
\pi ( M _ { k } ) \, \text {pr} ( M _ { k - 1 } | M _ { k } ) = \pi ( M _ { k - 1 } ) \, \text {pr} ( M _ { k } | M _ { k - 1 } ),
$$

where M k denotes the parameters of the model with k knots: M k = {k, j 1,..., j k }, for k = 1, 2,...and j i µ (0, 1). The p (M k ) density is the target from which we want to draw observations; in our case p (M k ) is the posterior distribution of M k, namely

$$
\pi ( M _ { k } ) = \frac { p ( y | \xi _ { 1 }, \dots, \xi _ { k } ) p ( \xi _ { 1 }, \dots, \xi _ { k } | k ) p ( k ) } { p ( y ) } .
$$

The formula pr (M k − 1 | M k ) is a Markov transition kernel, the transition probability of going from M k to M k − 1.Let

$$
M _ { k } & = \{ k, \xi _ { 1 }, \xi _ { 2 }, \dots, \xi _ { j ^ { * } - 1 }, \xi _ { j ^ { * } }, \xi _ { j ^ { * } + 1 }, \dots, \xi _ { k } \}, \\ M _ { k - 1 } & = \{ k - 1, \xi _ { 1 }, \xi _ { 2 }, \dots, \xi _ { j ^ { * } - 1 }, \xi _ { j ^ { * } + 1 }, \dots, \xi _ { k } \} .
$$

The sets of knots in the two spaces di ﬀ er only in the j* th element. We can now write the transition probabilities as follows:

$$
p r ( M _ { k - 1 } | M _ { k } ) & = \underbrace { \Pr ( k - 1 | k ) \times \underbrace { \Pr ( \text {delete } \xi _ { j } \ast | k ) \times \underbrace { ( \text {acceptance probability} ) } _ { a _ { k } } } _ { 4 } } _ { 4 } \times \underbrace { \underbrace { ( \text {acceptance probability} ) } _ { z _ { a } } } \\ & = d _ { k } \frac { 1 } { k } \min ( 1, A ), \\ & \Pr ( M _ { k } | M _ { k - 1 } ) = \underbrace { \Pr ( k | k - 1 ) \times \underbrace { \Pr ( \text {add } \xi _ { j } \ast | k - 1 ) \times \underbrace { ( \text {acceptance probability} ) } _ { b _ { k - 1 } } } _ { 1 ( k - 1 ) \sum _ { k } \text {h} ( \xi _ { j } \ast | \xi _ { i } ) } } _ { 1 ( k - 1 ) \sum _ { k } \text {h} ( \xi _ { j } \ast | \xi _ { i } ) } \times \underbrace { z _ { b } } \\ & = b _ { k - 1 } \frac { 1 } { k - 1 } \sum _ { i } h _ { B } ( \xi _ { j } \ast | \xi _ { i } ) \min ( 1, B ), \\ \intertext { where }
$$

where

$$
A = \frac { \pi ( M _ { k - 1 } ) } { \pi ( M _ { k } ) } \, \frac { b _ { k - 1 } ( k - 1 ) ^ { - 1 } \sum _ { i } h _ { B } ( \xi _ { j ^ { * } } | \xi _ { i } ) } { d _ { k } k ^ { - 1 } }, \ \ B = \frac { \pi ( M _ { k } ) } { \pi ( M _ { k - 1 } ) } \, \frac { d _ { k } k ^ { - 1 } } { b _ { k - 1 } ( k - 1 ) ^ { - 1 } \sum _ { i } h _ { B } ( \xi _ { j ^ { * } } | \xi _ { i } ) } = 1 / A .
$$

We can now verify (A1). If A < 1, then a d = A and a b = 1, and therefore rewriting (A1) we have that

$$
\pi ( M _ { k } ) \, \text {pr} ( M _ { k - 1 } | M _ { k } ) & = \pi ( M _ { k } ) d _ { k } \, \frac { 1 } { k } \, A = \pi ( M _ { k } ) d _ { k } \, \frac { 1 } { k } \, \frac { \pi ( M _ { k - 1 } ) } { \pi ( M _ { k } ) } \, \frac { b _ { k - 1 } ( k - 1 ) ^ { - 1 } \sum _ { i } h _ { B } ( \xi _ { j ^ { * } } | \xi _ { i } ) } { d _ { k } k ^ { - 1 } } \\ & = \pi ( M _ { k - 1 } ) b _ { k - 1 } \, \frac { 1 } { k - 1 } \sum _ { i } h _ { B } ( \xi _ { j ^ { * } } | \xi _ { i } ) = \pi ( M _ { k - 1 } ) \, \text {pr} ( M _ { k } | M _ { k - 1 } ).\\ \intertext { t h a n s w h a r } \pi ( M _ { k } ) \, \text {pr} ( M _ { k - 1 } | M _ { k } ) & = \pi ( M _ { k } ) \, \Delta _ { k } \, \text { the } \sigma \, \text {self} \, \text { the } \text {dated} \, \text {length} \, \text {condition} \, \text {wher} \, \text {we}
$$

The case when A > 1 is now obvious. Also the proof of the detailed balance condition when we move from M k to M ∞ k, a relocation step, is straightforward.


[Page 16]

Importance sampling

We wish to determine the weight for our problem. If g( b, k, j ) is the functional of interest, we need to compute

$$
\text { need to compute } & & \int \dots \int g ( \beta, \xi, k ) \frac { q ( \beta | y, k, \xi ) } { \hat { q } ( \beta | y, \xi, k ) } \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k \\ & E \{ g ( \beta, \xi, k ) | y \} = \frac { } { \int \dots \int \frac { q ( \beta | y, k, \xi ) } { \hat { q } ( \beta | y, \xi, k ) } \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k } = \frac { A } { B }, \\ \intertext { s a y, $ where }
$$

say, where

Therefore

$$
s y, \text { where } & & 4 = \int \dots \int g ( \beta, k, \xi ) q ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k \\ & = \int \dots \int g ( \beta, k, \xi ) \, \frac { q ( \beta | y, k, \xi ) } { \hat { q } ( \beta | y, k, \xi ) } \, \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k \\ & = \int \dots \int g ( \beta, k, \xi ) \, \frac { p ( y | \beta, k, \xi ) \pi _ { \beta } ( \beta | k, \xi ) } { \hat { p } ( y | \beta, \xi, k ) \pi _ { \beta } ( \beta | \xi, k ) } \, \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k \\ & = \frac { \hat { p } ( y ) } { p ( y ) } \int \dots \int g ( \beta, \xi, k ) \, \frac { p ( y | \beta, k, \xi ) } { \hat { p } ( y | \beta, \xi, k ) } \, \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k, \\ B = \frac { \hat { p } ( y ) } { p ( y ) } \int \dots \int \frac { p ( y | \beta, k, \xi ) } { \hat { p } ( y | \beta, \xi, k ) } \, \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k.\\ \text { Therefore}
$$

$$
\frac { y } { y } \int \dots \int \frac { p ( y | \beta, } { \hat { p } ( y | \beta, }
$$

$$
\text {Therefor} \\ E \{ g ( \beta, \xi, k ) | y \} = \frac { \int \dots \int g ( \beta, \xi, k ) \frac { p ( y | \beta, k, \xi ) } { \hat { p } ( y | \beta, \xi, k ) } \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k } { \int \dots \int \frac { \underline { p ( y | \beta, k, \xi ) } } { \hat { p } ( y | \beta, \xi, k ) } \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k } \\ \simeq \frac { \sum _ { l } g ( \beta ^ { ( \ell ) }, \xi ^ { ( \ell ) }, k ^ { ( \ell ) } ) w ( \beta ^ { ( \ell ) }, \xi ^ { ( \ell ) }, k ^ { ( \ell ) } ) } { \sum _ { l } w ( \beta ^ { ( \ell ) }, \xi ^ { ( \ell ) }, k ^ { ( \ell ) } ) }, \\ \text {where}
$$

where

$$
w ( \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) = \frac { p ( y | \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) } { \hat { p } ( y | \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) },
$$

( j (l), k (l) ) is the pair accepted by the reversible-jump sampler, i.e. is sampled from p(k, j | y), and h (l) is sampled from q @ ( b | y, j (l), k (l) ).

First, we elaborate on the essential property of the  -based approximation we are using. Let p @ (y | k, j ) be the approximation to p(y | k, j ) and assume that k ∏ K for some ﬁxed K. Then, from Laplace’s method, p @ (y | k, j ) = p(y | k, j ){1 + O p (n − 1/2 )} uniformly in (k, j ). Here, O p refers to the sampling distribution of the data. Let us use Pr to denote probabilities under this sampling distribution and let V denote the space of (k, j ) values. It follows by integration that, for any arbitrarily small positive g, there exists a bound M such that, for all measurable subsets A k V and for all


[Page 17]

su ﬃ ciently large n, we have

$$
\Pr \{ | \hat { P } ( A | y ) - P ( A | y ) | < M / \sqrt { n } \} > 1 - \eta,
$$

where P(A | y) and P C (A | y) denote posterior and approximate posterior probabilities of A. This is the formal sense in which the posterior using  approximates the correct posterior. DMS

Secondly, we provide details for our statement that the marginal density p (y | k, j ) is monotonically increasing in k. Let k ∞  k and, given a basis matrix B k, j, generate another, B ∞ k ∞ j ∞, by adding knots. Then

$$
\text {span} ( B _ { k, \xi } ) \subseteq \text {span} ( B ^ { \prime } _ { k ^ { \prime }, \xi ^ { \prime } } ), \quad \max _ { \beta } \, p ( y | \beta, k, \xi ) \leqslant \max _ { \beta ^ { \prime } } \, p ( y | \beta ^ { \prime }, k ^ { \prime }, \xi ^ { \prime } ) .
$$

Therefore, for each (k, j ) there exists (k ∞, j ∞ ) such that p DMS (y | k, j ) ∏ p DMS (y | k ∞, j ∞ ).

B , C.(2000). Adaptive Bayesian regression splines in semiparametric generalized linear models. J. Comp. Graph. Statist. 9, 122–40.

E , M.& S , T.(1995). Methods for approximating integrals in statistics with special emphasis on Bayesian integration problems. Statist. Sci. 10, 254–72.

G , C.R.(2000). A Bayesian time-course model for functional Magnetic Resonance Imaging data. J. Am. Statist. Assoc. 95, 691–719.

H , M.H.& K , C.(2001). Spline adaptation in extended linear models. Statist. Sci.To appear. H , T.J.& T , R.J.(1990). Generalized Additive Models. London: Chapman and Hall. K R E V V

,.. & ,.(2001). A spike train probability model. Neural Comp. 13, 1713–20. K R E W L

,.. & ,.(1995). A reference Bayesian test for nested hypotheses and its relationship to the Schwarz criterion. J. Am. Statist. Assoc. 90, 928–34.

L , M.J.(1999). Penalized estimation of free-knot splines. J. Comp. Graph. Statist. 8, 333–52. L J S W W H K A

,.., ,.. & ,.(1994). Covariance structure of the Gibbs sampler with applications to the comparisons of estimators and augmentation schemes. Biometrika 81, 27–40.

M  C , P.& N , J.A.(1989). Generalized L inear Models, 2nd ed. London: Chapman and Hall. O C R R J E

,.. & ,.. (1999). Low-frequency oscillations in Macaque IT cortex during competitive interactions between stimuli. Soc. Neurosci. Abstr. 25, 916.

P , D.K.(1998). The Schwarz criterion and related methods for normal linear models. Biometrika 85, 13–27.

Z , S.& S , X.(2001). Spatially adaptive regression splines and accurate knot selection schemes. J. Am. Statist. Assoc. 96, 247–59.

[Received February 2000. Revised May 2001]
