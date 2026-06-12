## 10. Approximate Inference

A central task in the application of probabilistic models is the evaluation of the posterior distribution p (Z | X) of the latent variables Z given the observed (visible) data variables X, and the evaluation of expectations computed with respect to this distribution. The model might also contain some deterministic parameters, which we will leave implicit for the moment, or it may be a fully Bayesian model in which any unknown parameters are given prior distributions and are absorbed into the set of latent variables denoted by the vector Z. For instance, in the EM algorithm we need to evaluate the expectation of the complete-data log likelihood with respect to the posterior distribution of the latent variables. For many models of practical interest, it will be infeasible to evaluate the posterior distribution or indeed to compute expectations with respect to this distribution. This could be because the dimensionality of the latent space is too high to work with directly or because the posterior distribution has a highly complex form for which expectations are not analytically tractable. In the case of continuous variables, the required integrations may not have closed-form

In such situations, we need to resort to approximation schemes, and these fall broadly into two classes, according to whether they rely on stochastic or deterministic approximations. Stochastic techniques such as Markov chain Monte Carlo, described in Chapter 11, have enabled the widespread use of Bayesian methods across many domains. They generally have the property that given infinite computational resource, they can generate exact results, and the approximation arises from the use of a finite amount of processor time. In practice, sampling methods can be computationally demanding, often limiting their use to small-scale problems. Also, it can be difficult to know whether a sampling scheme is generating independent samples from the required distribution.

In this chapter, we introduce a range of deterministic approximation schemes, some of which scale well to large applications. These are based on analytical approximations to the posterior distribution, for example by assuming that it factorizes in a particular way or that it has a specific parametric form such as a Gaussian. As such, they can never generate exact results, and so their strengths and weaknesses are complementary to those of sampling methods.

In Section 4.4, we discussed the Laplace approximation, which is based on a local Gaussian approximation to a mode (i.e., a maximum) of the distribution. Here we turn to a family of approximation techniques called variational inference or variational Bayes, which use more global criteria and which have been widely applied. We conclude with a brief introduction to an alternative variational framework known as expectation propagation.

### 10.1 Variational Inference

Variational methods have their origins in the 18 th century with the work of Euler, Lagrange, and others on the calculus of variations. Standard calculus is concerned with finding derivatives of functions. We can think of a function as a mapping that takes the value of a variable as the input and returns the value of the function as the output. The derivative of the function then describes how the output value varies as we make infinitesimal changes to the input value. Similarly, we can define a functional as a mapping that takes a function as the input and that returns the value of the functional as the output. An example would be the entropy H[p], which takes a probability distribution p (x) as the input and returns the quantity

$$
H [p] & =\int p (x)\ln p (x)\, d x
$$

as the output. We can the introduce the concept of a functional derivative, which expresses how the value of the functional changes in response to infinitesimal changes to the input function (Feynman et al., 1964). The rules for the calculus of variations mirror those of standard calculus and are discussed in Appendix D. Many problems can be expressed in terms of an optimization problem in which the quantity being optimized is a functional. The solution is obtained by exploring all possible input functions to find the one that maximizes, or minimizes, the functional. Variational methods have broad applicability and include such areas as finite element methods (Kapur, 1989) and maximum entropy (Schwarz, 1988).

Although there is nothing intrinsically approximate about variational methods, they do naturally lend themselves to finding approximate solutions. This is done by restricting the range of functions over which the optimization is performed, for instance by considering only quadratic functions or by considering functions composed of a linear combination of fixed basis functions in which only the coefficients of the linear combination can vary. In the case of applications to probabilistic inference, the restriction may for example take the form of factorization assumptions (Jordan et al., 1999; Jaakkola, 2001).

Now let us consider in more detail how the concept of variational optimization can be applied to the inference problem. Suppose we have a fully Bayesian model in which all parameters are given prior distributions. The model may also have latent variables as well as parameters, and we shall denote the set of all latent variables and parameters by Z. Similarly, we denote the set of all observed variables by X. For example, we might have a set of N independent, identically distributed data, for which X = { x 1,..., x N } and Z = { z 1,..., z N }. Our probabilistic model specifies the joint distribution p (X, Z), and our goal is to find an approximation for the posterior distribution p (Z | X) as well as for the model evidence p (X). As in our discussion of EM, we can decompose the log marginal probability using

$$
\ln p (X) =\mathcal { L } (q) + K L (q\| p)\\
$$

where we have defined

$$
\text {ve defined}\\\mathcal { L } (q)\ =\\int q (Z)\ln\left\{\frac { p (X, Z) } { q (Z) }\right\}\, d Z\\\\\int _ { X } (\cdot\,) _ { 0 }\quad\int _ { X } (\tau) _ { 0 }\sum _ {\tau = 0 }\left\{\frac { p (Z | X) } { p (Z | X) }\right\} _ {\tau = 0 }\\
$$

$$
&\int ^ { 0 }\L (-) =\left\{\begin{array} { c } q (Z)\end{array}\int ^ { 0 }\L -\\ & K L (q | | p)\ =\ -\int q (Z)\ln\left\{\frac { p (Z | X) } { q (Z) }\right\}\, d Z.\\\intertext { f l e r s }\text {from our discussion of EM only in that the parameter vector }\theta\text { no longer }
$$

This differs from our discussion of EM only in that the parameter vector θ no longer appears, because the parameters are now stochastic variables and are absorbed into Z. Since in this chapter we will mainly be interested in continuous variables we have used integrations rather than summations in formulating this decomposition. However, the analysis goes through unchanged if some or all of the variables are discrete simply by replacing the integrations with summations as required. As before, we can maximize the lower bound L (q) by optimization with respect to the distribution q (Z), which is equivalent to minimizing the KL divergence. If we allow any possible choice for q (Z), then the maximum of the lower bound occurs when the KL divergence vanishes, which occurs when q (Z) equals the posterior distribution p (Z | X).

![image 231](Bishop2006_images/imageFile231.png)

Figure 10.1 Illustration of the variational approximation for the example considered earlier in Figure 4.14. The left-hand plot shows the original distribution (yellow) along with the Laplace (red) and variational (green) approximations, and the right-hand plot shows the negative logarithms of the corresponding curves.

However, we shall suppose the model is such that working with the true posterior distribution is intractable.

We therefore consider instead a restricted family of distributions q (Z) and then seek the member of this family for which the KL divergence is minimized. Our goal is to restrict the family sufficiently that they comprise only tractable distributions, while at the same time allowing the family to be sufficiently rich and flexible that it can provide a good approximation to the true posterior distribution. It is important to emphasize that the restriction is imposed purely to achieve tractability, and that subject to this requirement we should use as rich a family of approximating distributions as possible. In particular, there is no 'over-fitting' associated with highly flexible distributions. Using more flexible approximations simply allows us to approach the true posterior distribution more closely.

One way to restrict the family of approximating distributions is to use a parametric distribution q (Z | ω) governed by a set of parameters ω. The lower bound L (q) then becomes a function of ω, and we can exploit standard nonlinear optimization techniques to determine the optimal values for the parameters. An example of this approach, in which the variational distribution is a Gaussian and we have optimized with respect to its mean and variance, is shown in Figure 10.1.

#### 10.1.1 Factorized distributions

Here we consider an alternative way in which to restrict the family of distributions q (Z). Suppose we partition the elements of Z into disjoint groups that we denote by Z i where i = 1,...,M. We then assume that the q distribution factorizes with respect to these groups, so that

$$
q (Z) =\prod _ { i = 1 } ^ { M } q _ { i } (Z _ { i }).
$$

It should be emphasized that we are making no further assumptions about the distribution. In particular, we place no restriction on the functional forms of the individual factors q i (Z i). This factorized form of variational inference corresponds to an approximation framework developed in physics called mean field theory (Parisi, 1988).

Amongst all distributions q (Z) having the form (10.5), we now seek that distribution for which the lower bound L (q) is largest. We therefore wish to make a free form (variational) optimization of L (q) with respect to all of the distributions q i (Z i), which we do by optimizing with respect to each of the factors in turn. To achieve this, we first substitute (10.5) into (10.3) and then dissect out the dependence on one of the factors q j (Z j). Denoting q j (Z j) by simply q j to keep the notation uncluttered, we then obtain

$$
of the factors q _ { j } (Z _ { j }).\,\text {Denoting}\, q _ { j } (Z _ { j })\,\text {by simply}\, q _ { j }\,\text {to keep the notation uncluttered,}\\\text {we then obtain}\\\\\mathcal { L } (q)\ =\\int\prod _ { i } q _ { i }\left\{\ln p (X, Z) -\sum _ { i }\ln q _ { i }\right\}\, d Z\\\equiv\\int q _ { j }\left\{\int\ln p (X, Z)\prod _ { i\neq j } q _ { i }\, d Z _ { i }\right\}\, d Z _ { j } -\int q _ { j }\ln q _ { j }\, d Z _ { j } +\text {const}\\\equiv\\int q _ { j }\ln\widetilde { p } (X, Z _ { j })\, d Z _ { j } -\int q _ { j }\ln q _ { j }\, d Z _ { j } +\text {const}\\\text {where we have defined a new distribution}\,\widetilde { p } (X, Z _ { j })\, by the relation }\\\ln\widetilde { p } (X, Z _ { j }) =\mathbb { E } _ { i\neq j } [\ln p (X, Z)] +\text {const.}
$$

/negationslash

$$
\text {have defined a new distribution }\widetilde { p } (X, Z _ { j })\, b y\,\text {the relation}\\\ln\widetilde { p } (X, Z _ { j }) =\mathbb { E } _ { i\neq j } [\ln p (X, Z)] +\text {const.}\\\text {notation }\mathbb { F }\,\left [\,\dots\,\right]\text {doms on }\text {an}\,\text {notation}\,\text {with }\text {respect}\,\text {to the a distributions}
$$

$$
\text {variables}\, Z _ { i }\,\text {for}\,\imath\neq j,\,\text {so that}\,\\\mathbb { E } _ { i\neq j } [\ln p (X, Z)] =\int\ln p (X, Z)\prod _ { i\neq j } q _ { i }\,\text {d} Z _ { i }.\\
$$

![image 39](Bishop2006_images/imageFile39.png)

#### Leonhard Euler 1707-1783

Euler was a Swiss mathematician and physicist who worked in St. Petersburg and Berlin and who is widely considered to be one of the greatest mathematicians of all time. He is certainly the most prolific, and fill 75 volumes. Amongst his many his collected works fill 75 volumes. Amongst his many contributions, he formulated the modern theory of the function, he developed (together with Lagrange) the calculus of variations, and he discovered the formula e iπ = -1, which relates four of the most important numbers in mathematics. During the last 17 years of his life, he was almost totally blind, and yet he produced nearly half of his results during this period.

divergence, and the minimum occurs when q j (Z j) = p (X, Z j). Thus we obtain a general expression for the optimal solution q j (Z j) given by ln q j (Z j) = E i = j [ln p (X, Z)] + const. (10.9)

$$
\ln q _ { j } ^ { * } (Z _ { j }) =\mathbb { E } _ { i\neq j } [\ln p (X, Z)] + c o n s t.
$$

/negationslash

It is worth taking a few moments to study the form of this solution as it provides the basis for applications of variational methods. It says that the log of the optimal solution for factor q j is obtained simply by considering the log of the joint distribution over all hidden and visible variables and then taking the expectation with respect to all of the other factors { q i } for i = j. The additive constant in (10.9) is set by normalizing the distribution q j (Z j).

/negationslash

The additive constant in (10.9) is set by normalizing the distribution q /star j (Z j). Thus if we take the exponential of both sides and normalize, we have

$$
q _ { j } ^ { * } (Z _ { j }) =\frac {\exp\left (\mathbb { E } _ { i\neq j } [\ln p (X, Z)]\right) } {\int\exp\left (\mathbb { E } _ { i\neq j } [\ln p (X, Z)]\right)\, d Z _ { j } }.\\\int\exp\left (\mathbb { E } _ { i\neq j } [\ln p (X, Z)]\right)\, d Z _ { j }
$$

/negationslash

/negationslash

In practice, we shall find it more convenient to work with the form (10.9) and then reinstate the normalization constant (where required) by inspection. This will become clear from subsequent examples.

The set of equations given by (10.9) for j = 1,...,M represent a set of consistency conditions for the maximum of the lower bound subject to the factorization constraint. However, they do not represent an explicit solution because the expression on the right-hand side of (10.9) for the optimum q j (Z j) depends on expectations computed with respect to the other factors q i (Z i) for i = j. We will therefore seek a consistent solution by first initializing all of the factors q i (Z i) appropriately and then cycling through the factors and replacing each in turn with a revised estimate given by the right-hand side of (10.9) evaluated using the current estimates for all of the other factors. Convergence is guaranteed because bound is convex with respect to each of the factors q i (Z i) (Boyd and Vandenberghe, 2004).

/negationslash

#### 10.1.2 Properties of factorized approximations

Our approach to variational inference is based on a factorized approximation to the true posterior distribution. Let us consider for a moment the problem of approximating a general distribution by a factorized distribution. To begin with, we discuss the problem of approximating a Gaussian distribution using a factorized Gaussian, which will provide useful insight into the types of inaccuracy introduced in using factorized approximations. Consider a Gaussian distribution p (z) = N (z | µ, Λ − 1) over two correlated variables z = (z 1,z 2) in which the mean and precision have elements Λ Λ

$$
\mu & =\begin{pmatrix}\mu _ { 1 }\\\mu _ { 2 }\end{pmatrix},\quad\Lambda =\begin{pmatrix}\Lambda _ { 1 1 } &\Lambda _ { 1 2 }\\\Lambda _ { 2 1 } &\Lambda _ { 2 2 }\end{pmatrix}\\\Lambda _ { 1 3 }\, d e\, t o\, the\,\text {symmetry of the precision matrix}\,\text {, Now suppose we}
$$

and Λ 21 = Λ 12 due to the symmetry of the precision matrix. Now suppose we wish to approximate this distribution using a factorized Gaussian of the form q (z) = q 1 (z 1) q 2 (z 2). We first apply the general result (10.9) to find an expression for the

Exercise 10.2 optimal factor q 1 (z 1). In doing so it is useful to note that on the right-hand side we only need to retain those terms that have some functional dependence on z 1 because all other terms can be absorbed into the normalization constant. Thus we have

$$
\ln q _ { 1 } ^ { * } (z _ { 1 })\ & =\\mathbb { E } _ { z _ { 2 } } [\ln p (z)] +\text {const}\\ & =\\mathbb { E } _ { z _ { 2 } }\left [-\frac { 1 } { 2 } (z _ { 1 } -\mu _ { 1 }) ^ { 2 }\Lambda _ { 1 1 } - (z _ { 1 } -\mu _ { 1 })\Lambda _ { 1 2 } (z _ { 2 } -\mu _ { 2 })\right] +\text {const}\\ & =\\frac { 1 } { 2 } z _ { 1 } ^ { 2 }\Lambda _ { 1 1 } + z _ { 1 }\mu _ { 1 }\Lambda _ { 1 1 } - z _ { 1 }\Lambda _ { 1 2 }\left (\mathbb { E } [z _ { 2 }] -\mu _ { 2 }\right) +\text {const}.\quad (1 0. 1 1)\\\text {Next we observe that the right-hand side of this expression is a quadratic function of}
$$

Next we observe that the right-hand side of this expression is a quadratic function of z 1, and so we can identify q (z 1) as a Gaussian distribution. It is worth emphasizing that we did not assume that q (z i) is Gaussian, but rather we derived this result by variational optimization of the KL divergence over all possible distributions q (z i). Note also that we do not need to consider the additive constant in (10.9) explicitly because it represents the normalization constant that can be found at the end by inspection if required. Using the technique of completing the square, we can identify the mean and precision of this Gaussian, giving

$$
q ^ { * } (z _ { 1 }) =\mathcal { N } (z _ { 1 } | m _ { 1 },\Lambda _ { 1 1 } ^ { - 1 })
$$

where

$$
m _ { 1 } =\mu _ { 1 } -\Lambda _ { 1 1 } ^ { - 1 }\Lambda _ { 1 2 }\left (\mathbb { E } [z _ { 2 }] -\mu _ { 2 }\right).\\ +\tilde { t } (\cdot,\omega)\colon _ { i, j }\L _ {\infty, i j } C _ {\infty, j i }\cdot _ {\omega, i j }\L _ {\infty, j i }\cdot _ {\omega, i j }
$$

By symmetry, q 2 (z 2) is also Gaussian and can be written as

$$
q _ { 2 } ^ { * } (z _ { 2 }) =\mathcal { N } (z _ { 2 } | m _ { 2 },\Lambda _ { 2 2 } ^ { - 1 })
$$

in which

$$
m _ { 2 } =\mu _ { 2 } -\Lambda _ { 2 2 } ^ { - 1 }\Lambda _ { 2 1 }\left (\mathbb { E } [z _ { 1 }] -\mu _ { 1 }\right).\\\\\intertext { m _ { 2 } =\mu _ { 2 } -\Lambda _ { 2 2 } ^ { - 1 }\Lambda _ { 2 1 }\left (\mathbb { E } [z _ { 1 }] -\mu _ { 1 }\right). }
$$

Note that these solutions are coupled, so that q (z 1) depends on expectations computed with respect to q (z 2) and vice versa. In general, we address this by treating the variational solutions as re-estimation equations and cycling through the variables in turn updating them until some convergence criterion is satisfied. We shall see an example of this shortly. Here, however, we note that the problem is sufficiently simple that a closed form solution can be found. In particular, because E [z 1] = m 1 and E [z 2] = m 2, we see that the two equations are satisfied if we take E [z 1] = µ 1 and E [z 2] = µ 2, and it is easily shown that this is the only solution provided the distribution is nonsingular. This result is illustrated in Figure 10.2(a). We see that the mean is correctly captured but that the variance of q (z) is controlled by the direction of smallest variance of p (z), and that the variance along the orthogonal direction is significantly under-estimated. It is a general result that a factorized variational approximation tends to give approximations to the posterior distribution that are too compact.

By way of comparison, suppose instead that we had been minimizing the reverse Kullback-Leibler divergence KL(p q). As we shall see, this form of KL divergence

Figure 10.2 Comparison of the two alternative forms for the Kullback-Leibler divergence. The green contours corresponding to 1, 2, and 3 standard deviations for a correlated Gaussian distribution p (z) over two variables z 1 and z 2, and the red contours represent the corresponding levels for an approximating distribution q (z) over the same variables given by the product of two independent univariate Gaussian distributions whose parameters are obtained by minimization of (a) the KullbackLeibler divergence KL(q p), and (b) the reverse Kullback-Leibler divergence KL(p q).

![image 233](Bishop2006_images/imageFile233.png)

(a)

![image 234](Bishop2006_images/imageFile234.png)

(b)

$$
\text {written in the form}\\ K L (p | | q) = -\int p (Z)\left [\sum _ { i = 1 } ^ { M }\ln q _ { i } (Z _ { i })\right]\, d Z +\text {const}\quad (1 0. 1 6)\\\intertext { r e\, t h e\,\text {constant term is simply the entropy of } p (Z)\,\text { and so does not depend on}
$$

where the constant term is simply the entropy of p (Z) and so does not depend on q (Z). We can now optimize with respect to each of the factors q j (Z j), which is easily done using a Lagrange multiplier to give

$$
\text {using a Lagrange multiplier to give} &\text {gc}\\ q _ { j } ^ { * } (Z _ { j }) =\int p (Z)\prod _ { i\neq j }\, d Z _ { i } = p (Z _ { j }). & (1 0. 1 7)\\
$$

/negationslash

In this case, we find that the optimal solution for q j (Z j) is just given by the corresponding marginal distribution of p (Z). Note that this is a closed-form solution and so does not require iteration.

To apply this result to the illustrative example of a Gaussian distribution p (z) over a vector z we can use (2.98), which gives the result shown in Figure 10.2(b). We see that once again the mean of the approximation is correct, but that it places significant probability mass in regions of variable space that have very low probability.

The difference between these two results can be understood by noting that there is a large positive contribution to the Kullback-Leibler divergence

$$
K L (q\| p) = -\int q (Z)\ln\left\{\frac { p (Z) } { q (Z) }\right\}\, d Z\quad (1 0. 1 8)
$$

![image 235](Bishop2006_images/imageFile235.png)

(a)

(b)

(c)

Figure 10.3 Another comparison of the two alternative forms for the Kullback-Leibler divergence. (a) The blue contours show a bimodal distribution p (Z) given by a mixture of two Gaussians, and the red contours correspond to the single Gaussian distribution q (Z) that best approximates p (Z) in the sense of minimizing the KullbackLeibler divergence KL(p q). (b) As in (a) but now the red contours correspond to a Gaussian distribution q (Z) found by numerical minimization of the Kullback-Leibler divergence KL(q p). (c) As in (b) but showing a different local minimum of the Kullback-Leibler divergence.

from regions of Z space in which p (Z) is near zero unless q (Z) is also close to zero. Thus minimizing this form of KL divergence leads to distributions q (Z) that avoid regions in which p (Z) is small. Conversely, the Kullback-Leibler divergence KL(p q) is minimized by distributions q (Z) that are nonzero in regions where p (Z) is nonzero.

We can gain further insight into the different behaviour of the two KL divergences if we consider approximating a multimodal distribution by a unimodal one, as illustrated in Figure 10.3. In practical applications, the true posterior distribution will often be multimodal, with most of the posterior mass concentrated in some number of relatively small regions of parameter space. These multiple modes may arise through nonidentifiability in the latent space or through complex nonlinear dependence on the parameters. Both types of multimodality were encountered in Chapter 9 in the context of Gaussian mixtures, where they manifested themselves as multiple maxima in the likelihood function, and a variational treatment based on the minimization of KL(q p) will tend to find one of these modes. By contrast, if we were to minimize KL(p q), the resulting approximations would average across all of the modes and, in the context of the mixture model, would lead to poor predictive distributions (because the average of two good parameter values is typically itself not a good parameter value). It is possible to make use of KL(p q) to define a useful inference procedure, but this requires a rather different approach to the one discussed here, and will be considered in detail when we discuss expectation propagation.

The two forms of Kullback-Leibler divergence are members of the alpha family

Exercise 10.6

Exercise 2.44 of divergences (Ali and Silvey, 1966; Amari, 1985; Minka, 2005) defined by

$$
0\,\text { and }\, &\sin (1 +\sin (y), 1), 2, 1,\sin (x), 2\,\text { and }\, 0\,\text { by }\\ & D _ {\alpha } (p | | q) =\frac { 4 } { 1 -\alpha ^ { 2 } }\left (1 -\int p (x) ^ { (1 +\alpha) / 2 } q (x) ^ { (1 -\alpha) / 2 }\, d x\right)\\ &\text {where }\,\alpha\,\leq\,\alpha\,\cdot\,\sin\alpha\,\text { among }\,\text { The }\, K\,\text {wall}\,\text { such }\,\text { light}\,\text { div $n$}\,\text { divergence}\,\text { }\\
$$

where −∞ < α < ∞ is a continuous parameter. The Kullback-Leibler divergence KL(p q) corresponds to the limit α → 1, whereas KL(q p) corresponds to the limit α → − 1. For all values of α we have D α (p q) 0, with equality if, and only if, p (x) = q (x). Suppose p (x) is a fixed distribution, and we minimize D α (p q) with respect to some set of distributions q (x). Then for α − 1 the divergence is zero forcing, so that any values of x for which p (x) = 0 will have q (x) = 0, and typically q (x) will under-estimate the support of p (x) and will tend to seek the mode with the largest mass. Conversely for α 1 the divergence is zero-avoiding, so that values of x for which p (x) > 0 will have q (x) > 0, and typically q (x) will stretch to cover all of p (x), and will over-estimate the support of p (x). When α = 0 we obtain a symmetric divergence that is linearly related to the Hellinger distance given by

$$
\text {degree that is nearly related to the Heller integer distance given by}\\ D _ { H } (p | | q) =\int\left (p (x) ^ { 1 / 2 } - q (x) ^ { 1 / 2 }\right)\, d x.\\\intertext { o r t o f the Hellinger distance is a valid distance metric. }
$$

The square root of the Hellinger distance is a valid distance metric.

#### 10.1.3 Example: The univariate Gaussian

We now illustrate the factorized variational approximation using a Gaussian distribution over a single variable x (MacKay, 2003). Our goal is to infer the posterior distribution for the mean µ and precision τ, given a data set D = { x 1,...,x N } of observed values of x which are assumed to be drawn independently from the Gaussian. The likelihood function is given by

$$
p (\mathcal { D } |\mu,\tau) =\left (\frac {\tau } { 2\pi }\right) ^ { N / 2 }\exp\left\{ -\frac {\tau } { 2 }\sum _ { n = 1 } ^ { N } (x _ { n } -\mu) ^ { 2 }\right\}.
$$

We now introduce conjugate prior distributions for µ and τ given by

$$
\ p (\mu |\tau)\ & =\\mathcal { N }\left (\mu |\mu _ { 0 }, (\lambda _ { 0 }\tau) ^ { - 1 }\right)\\\ p (\tau)\ & =\\ G a m (\tau | a _ { 0 }, b _ { 0 })\\
$$

where Gam(τ | a 0,b 0) is the gamma distribution defined by (2.146). Together these distributions constitute a Gaussian-Gamma conjugate prior distribution.

For this simple problem the posterior distribution can be found exactly, and again takes the form of a Gaussian-gamma distribution. However, for tutorial purposes we will consider a factorized variational approximation to the posterior distribution given by

$$
q (\mu,\tau) = q _ {\mu } (\mu) q _ {\tau } (\tau).
$$

Exercise 10.7

Exercise 10.8

Note that the true posterior distribution does not factorize in this way. The optimum factors q µ (µ) and q τ (τ) can be obtained from the general result (10.9) as follows. For q µ (µ) we have

$$
\ln q _ {\mu } ^ { * } (\mu)\ =\\mathbb { E } _ {\tau }\left [\ln p (\mathcal { D } |\mu,\tau) +\ln p (\mu |\tau)\right] +\text {const}\\ =\ -\frac {\mathbb { E } [\tau] } { 2 }\left\{\lambda _ { 0 } (\mu -\mu _ { 0 }) ^ { 2 } +\sum _ { n = 1 } ^ { N } (x _ { n } -\mu) ^ { 2 }\right\} +\text {const. }\left (1 0. 2\right)\\\\\text {Completing the square over }\mu\text { we see that } q _ {\mu } (\mu)\text { is a Gaussian }\mathcal { N }\left (\mu |\mu _ { N },\lambda _ { N } ^ { - 1 }\right)\text { with}
$$

n =1 Completing the square over µ we see that q µ (µ) is a Gaussian N µ | µ N,λ − 1 N with mean and precision given by λ µ + N x

$$
\mu _ { N }\ =\\frac {\lambda _ { 0 }\mu _ { 0 } + N\overline { x } } {\lambda _ { 0 } + N } & & (1 0. 2 6)
$$

$$
\lambda _ { N }\ =\ (\lambda _ { 0 } + N)\mathbb { E } [\tau].
$$

Note that for N → ∞ this gives the maximum likelihood result in which µ N = x and the precision is infinite.

Similarly, the optimal solution for the factor q τ (τ) is given by

$$
\text { Similarly, the optimal solution for the factor or } q _ {\tau } (\tau)\text { is given by}\\\ln q _ {\tau } ^ { * } (\tau)\ =\\mathbb { E } _ {\mu }\left [\ln p (\mathcal { D } |\mu,\tau) +\ln p (\mu |\tau)\right] +\ln p (\tau) +\text {const}\\\equiv\quad (a _ { 0 } - 1)\ln\tau - b _ { 0 }\tau +\frac { N } { 2 }\ln\tau\\ -\frac {\tau } { 2 }\mathbb { E } _ {\mu }\left [\sum _ { n = 1 } ^ { N } (x _ { n } -\mu) ^ { 2 } +\lambda _ { 0 } (\mu -\mu _ { 0 }) ^ { 2 }\right] +\text {const}\quad (1 0. 2 8)\\\intertext { a n d h e n c $ q _ {\tau } (\tau)\text { is a gamma distribution Game} (\tau | a _ { N }, b _ { N })\text { with parameters} }
$$

and hence q τ (τ) is a gamma distribution Gam(τ | a N,b N) with parameters

$$
a _ { N }\ =\ a _ { 0 } +\frac { N } { 2 } & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & &
$$

$$
a _ { N }\ =\ a _ { 0 } +\frac { } { 2 }\frac { } { 2 }\\ b _ { N }\ =\ b _ { 0 } +\frac { 1 } { 2 }\mathbb { E } _ {\mu }\left [\sum _ { n = 1 } ^ { N } (x _ { n } -\mu) ^ { 2 } +\lambda _ { 0 } (\mu -\mu _ { 0 }) ^ { 2 }\right].\quad\\\text { again this exists the expected behaviour when } N\to\infty.
$$

Again this exhibits the expected behaviour when N → ∞. It should be emphasized that we did not assume these specific functional forms for the optimal distributions q µ (µ) and q τ (τ). They arose naturally from the structure of the likelihood function and the corresponding conjugate priors.

Thus we have expressions for the optimal distributions q µ (µ) and q τ (τ) each of which depends on moments evaluated with respect to the other distribution. One approach to finding a solution is therefore to make an initial guess for, say, the moment E [τ] and use this to re-compute the distribution q µ (µ). Given this revised distribution we can then extract the required moments E [µ] and E [µ 2], and use these to recompute the distribution q τ (τ), and so on. Since the space of hidden variables for this example is only two dimensional, we can illustrate the variational approximation to the posterior distribution by plotting contours of both the true posterior and the factorized approximation, as illustrated in Figure 10.4.

![image 236](Bishop2006_images/imageFile236.png)

(a)

(b)

(c)

(d)

Figure 10.4 Illustration of variational inference for the mean µ and precision τ of a univariate Gaussian distribution. Contours of the true posterior distribution p (µ, τ | D) are shown in green. (a) Contours of the initial factorized approximation q µ (µ) q τ (τ) are shown in blue. (b) After re-estimating the factor q µ (µ). (c) After re-estimating the factor q τ (τ). (d) Contours of the optimal factorized approximation, to which the iterative scheme converges, are shown in red.

Appendix B

In general, we will need to use an iterative approach such as this in order to solve for the optimal factorized posterior distribution. For the very simple example we are considering here, however, we can find an explicit solution by solving the simultaneous equations for the optimal factors q µ (µ) and q τ (τ). Before doing this, we can simplify these expressions by considering broad, noninformative priors in which µ 0 = a 0 = b 0 = λ 0 = 0. Although these parameter settings correspond to improper priors, we see that the posterior distribution is still well defined. Using the standard result E [τ] = a N /b N for the mean of a gamma distribution, together with (10.29) and (10.30), we have

$$
(1 0. 2 9)\,\text {and}\, (1 0. 3 0),\,\text {we have}\\\frac { 1 } {\mathbb { E } [\tau] } =\mathbb { E }\left [\frac { 1 } { N }\sum _ { n = 1 } ^ { N } (x _ { n } -\mu) ^ { 2 }\right] =\overline { x ^ { 2 } } - 2\overline { x }\mathbb { E } [\mu] +\mathbb { E } [\mu ^ { 2 }].\quad (1 0. 3 1)\\\text {Then using } (1 0. 2 6)\,\text {and}\, (1 0. 2 7)\,\text { we obtain the first and second order moments of}
$$

Then, using (10.26) and (10.27), we obtain the first and second order moments of q µ (µ) in the form

$$
\mathbb { E } [\mu] =\overline { x },\quad\mathbb { E } [\mu ^ { 2 }] =\overline { x } ^ { 2 } +\frac { 1 } { N\mathbb { E } [\tau] }.
$$

We can now substitute these moments into (10.31) and then solve for E [τ] Exercise 10.9 to give

$$
\frac { 1 } {\mathbb { E } [\tau] }\ & =\\frac { 1 } { N - 1 } (\overline { x ^ { 2 } } -\overline { x } ^ { 2 })\\ & =\\frac { 1 } { N - 1 }\sum _ { n = 1 } ^ { N } (x _ { n } -\overline { x }) ^ { 2 }.\\\intertext { c h e r g h i t h a n d s e }\ The right-hand side a s the f a m i l i a r u n b i a s e d e s t i m a t o r f e t h e v a r i a n c e
$$

We recognize the right-hand side as the familiar unbiased estimator for the variance of a univariate Gaussian distribution, and so we see that the use of a Bayesian approach has avoided the bias of the maximum likelihood solution.

Exercise 10.10

Exercise 10.11

#### 10.1.4 Model comparison

As well as performing inference over the hidden variables Z, we may also wish to compare a set of candidate models, labelled by the index m, and having prior probabilities p (m). Our goal is then to approximate the posterior probabilities p (m | X), where X is the observed data. This is a slightly more complex situation than that considered so far because different models may have different structure and indeed different dimensionality for the hidden variables Z. We cannot therefore simply consider a factorized approximation q (Z) q (m), but must instead recognize that the posterior over Z must be conditioned on m, and so we must consider q (Z,m) = q (Z | m) q (m). We can readily verify the following decomposition based on this variational distribution

$$
o n\text { this variational distribution}\\\ln p (X) =\mathcal { C } _ { m } -\sum _ { m }\sum _ { Z } q (Z | m) q (m)\ln\left\{\frac { p (Z, m | X) } { q (Z | m) q (m) }\right\}\\\\\text {where the }\mathcal { C } _ { m }\text { is a lower bound on }\ln p (X)\text { and is given by }
$$

where the L m is a lower bound on ln p (X) and is given by

$$
\L _ { m } =\sum _ { m }\sum _ { z } q (Z | m) q (m)\ln\left\{\frac { p (Z, X, m) } { q (Z | m) q (m) }\right\}.\quad (1 0. 3 5)\\\text {we are assuming discrete}\, Z\text {, but the same analysis applies to continuous latent}
$$

Here we are assuming discrete Z, but the same analysis applies to continuous latent variables provided the summations are replaced with integrations. We can maximize L m with respect to the distribution q (m) using a Lagrange multiplier, with the result

$$
q (m)\,\infty\, p (m)\exp\{\mathcal { L } _ { m }\}.
$$

However, if we maximize L m with respect to the q (Z | m), we find that the solutions for different m are coupled, as we expect because they are conditioned on m. We proceed instead by first optimizing each of the q (Z | m) individually by optimization of (10.35), and then subsequently determining the q (m) using (10.36). After normalization the resulting values for q (m) can be used for model selection or model averaging in the usual way.

### 10.2 Illustration: Variational Mixture of Gaussians

We now return to our discussion of the Gaussian mixture model and apply the variational inference machinery developed in the previous section. This will provide a good illustration of the application of variational methods and will also demonstrate how a Bayesian treatment elegantly resolves many of the difficulties associated with the maximum likelihood approach (Attias, 1999b). The reader is encouraged to work through this example in detail as it provides many insights into the practical application of variational methods. Many Bayesian models, corresponding to much more sophisticated distributions, can be solved by straightforward extensions and generalizations of this analysis.

Our starting point is the likelihood function for the Gaussian mixture model, illustrated by the graphical model in Figure 9.6. For each observation x n we have a corresponding latent variable z n comprising a 1-ofK binary vector with elements z nk for k = 1,...,K. As before we denote the observed data set by X = { x 1,..., x N }, and similarly we denote the latent variables by Z = { z 1,..., z N }. From (9.10) we can write down the conditional distribution of Z, given the mixing coefficients π, in the form

$$
p (Z |\pi) =\prod _ { n = 1 } ^ { N }\prod _ { k = 1 } ^ { K }\pi _ { k } ^ { z _ { n k } }.\\\intertext { l }\intertext { a }\intertext { w e }\intertext { c a n w i t e d o w }\intertext { n }
$$

Similarly, from (9.11), we can write down the conditional distribution of the observed data vectors, given the latent variables and the component parameters

$$
p (X | Z,\mu,\Lambda) =\prod _ { n = 1 } ^ { N }\prod _ { k = 1 } ^ { K }\mathcal { N }\left (x _ { n } |\mu _ { k },\Lambda _ { k } ^ { - 1 }\right) ^ { z _ { n k } }\\\mu =\{\mu _ { k }\}\text { and }\Lambda =\{\Lambda _ { k }\}.\text { Note that we are working in terms of precision }
$$

where µ = { µ k } and Λ = { Λ k }. Note that we are working in terms of precision matrices rather than covariance matrices as this somewhat simplifies the mathematics.

Next we introduce priors over the parameters µ, Λ and π. The analysis is considerably simplified if we use conjugate prior distributions. We therefore choose a Dirichlet distribution over the mixing coefficients π

$$
p (\pi) =\text {Dir} (\pi |\alpha _ { 0 }) = C (\alpha _ { 0 })\prod _ { k = 1 } ^ { K }\pi _ { k } ^ {\alpha _ { 0 } - 1 }\\\text {symmetry we have chosen the same parameter $\alpha_{0}$ for each of the compo-}
$$

where by symmetry we have chosen the same parameter α 0 for each of the components, and C (α 0) is the normalization constant for the Dirichlet distribution defined

Directed acyclic graph representing the Bayesian mixture of Gaussians model, in which the box (plate) denotes a set of N i.i.d. observations. Here µ denotes { µ k } and Λ denotes { Λ k }.

{ k } { }

![image 237](Bishop2006_images/imageFile237.png)

by (B.23). As we have seen, the parameter α 0 can be interpreted as the effective prior number of observations associated with each component of the mixture. If the value of α 0 is small, then the posterior distribution will be influenced primarily by the data rather than by the prior.

Similarly, we introduce an independent Gaussian-Wishart prior governing the mean and precision of each Gaussian component, given by

$$
p (\mu,\Lambda)\ =\ p (\mu |\Lambda) p (\Lambda)\\ =\\prod _ { k = 1 } ^ { K }\mathcal { N }\left (\mu _ { k } | m _ { 0 }, (\beta _ { 0 }\Lambda _ { k }) ^ { - 1 }\right)\,\mathcal { W } (\Lambda _ { k } |\mathbb { W } _ { 0 },\nu _ { 0 })\quad (1 0. 4 0)\\\intertext { b a c u s h e c k i n s }\text { because this represents the conjugate prior distribution when both the mean and pre-}
$$

because this represents the conjugate prior distribution when both the mean and precision are unknown. Typically we would choose m 0 = 0 by symmetry.

The resulting model can be represented as a directed graph as shown in Figure 10.5. Note that there is a link from Λ to µ since the variance of the distribution over µ in (10.40) is a function of Λ.

This example provides a nice illustration of the distinction between latent variables and parameters. Variables such as z n that appear inside the plate are regarded as latent variables because the number of such variables grows with the size of the data set. By contrast, variables such as µ that are outside the plate are fixed in number independently of the size of the data set, and so are regarded as parameters. From the perspective of graphical models, however, there is really no fundamental difference between them.

#### 10.2.1 Variational distribution

In order to formulate a variational treatment of this model, we next write down the joint distribution of all of the random variables, which is given by

$$
p (X, Z,\pi,\mu,\Lambda) = p (X | Z,\mu,\Lambda) p (Z |\pi) p (\pi) p (\mu |\Lambda) p (\Lambda)
$$

in which the various factors are defined above. The reader should take a moment to verify that this decomposition does indeed correspond to the probabilistic graphical model shown in Figure 10.5. Note that only the variables X = { x 1,..., x N } are observed.

Exercise 10.12

We now consider a variational distribution which factorizes between the latent variables and the parameters so that

$$
q (Z,\pi,\mu,\Lambda) = q (Z) q (\pi,\mu,\Lambda).
$$

It is remarkable that this is the only assumption that we need to make in order to obtain a tractable practical solution to our Bayesian mixture model. In particular, the functional form of the factors q (Z) and q (π, µ, Λ) will be determined automatically by optimization of the variational distribution. Note that we are omitting the subscripts on the q distributions, much as we do with the p distributions in (10.41), and are relying on the arguments to distinguish the different distributions.

The corresponding sequential update equations for these factors can be easily derived by making use of the general result (10.9). Let us consider the derivation of the update equation for the factor q (Z). The log of the optimized factor is given by

$$
\ln q ^ { * } (Z) =\mathbb { E } _ {\pi,\mu,\Lambda } [\ln p (X, Z,\pi,\mu,\Lambda)] +\text {const}.
$$

We now make use of the decomposition (10.41). Note that we are only interested in the functional dependence of the right-hand side on the variable Z. Thus any terms that do not depend on Z can be absorbed into the additive normalization constant, giving

$$
\ln q ^ { * } (Z) =\mathbb { E } _ {\pi } [\ln p (Z |\pi)] +\mathbb { E } _ {\mu,\Lambda } [\ln p (X | Z,\mu,\Lambda)] +\text {const.}\\
$$

Substituting for the two conditional distributions on the right-hand side, and again absorbing any terms that are independent of Z into the additive constant, we have

$$
\ln q ^ { * } (Z) =\sum _ { n = 1 } ^ { N }\sum _ { k = 1 } ^ { K } z _ { n k }\ln\rho _ { n k } +\text {const}\quad (1 0. 4 5)
$$

where we have defined

$$
\ln\rho _ { n k }\ =\ &\mathbb { E } [\ln\pi _ { k }] +\frac { 1 } { 2 }\mathbb { E }\left [\ln |\Lambda _ { k } |\right] -\frac { D } { 2 }\ln (2\pi)\\ & -\frac { 1 } { 2 }\mathbb { E } _ {\mu _ { k },\Lambda _ { k } }\left [(x _ { n } -\mu _ { k }) ^ { T }\Lambda _ { k } (x _ { n } -\mu _ { k })\right]\\\intertext { s e r $ D $ i s the dimensionality of the data variable x. $ T a k i n g t h e x p o n e n t i o n $ f o r $ both }
$$

where D is the dimensionality of the data variable x. Taking the exponential of both sides of (10.45) we obtain

$$
q ^ { * } (Z)\infty\prod _ { n = 1 } ^ { N }\prod _ { k = 1 } ^ { K }\rho _ { n k } ^ { z _ { n k } }.
$$

Requiring that this distribution be normalized, and noting that for each value of n the quantities z nk are binary and sum to 1 over all values of k, we obtain

$$
q ^ { * } (Z) =\prod _ { n = 1 } ^ { N }\prod _ { k = 1 } ^ { K } r _ { n k } ^ { z _ { n k } }
$$

where

$$
r _ { n k } =\frac {\rho _ { n k } } { K }. & & (1 0. 4 9)\\\sum _ { j = 1 } ^ { K }\rho _ { n j } & &\\\sum _ { j = 1 } ^ { 2 }
$$

We see that the optimal solution for the factor q (Z) takes the same functional form as the prior p (Z | π). Note that because ρ nk is given by the exponential of a real quantity, the quantities r nk will be nonnegative and will sum to one, as required. For the discrete distribution (Z) we have the standard result

For the discrete distribution q /star (Z) we have the standard result

$$
\mathbb { E } [z _ { n k }] = r _ { n k }
$$

from which we see that the quantities r nk are playing the role of responsibilities. Note that the optimal solution for q (Z) depends on moments evaluated with respect to the distributions of other variables, and so again the variational update equations are coupled and must be solved iteratively.

At this point, we shall find it convenient to define three statistics of the observed data set evaluated with respect to the responsibilities, given by

$$
N _ { k }\ =\\sum _ { n = 1 } ^ { N } r _ { n k } & & (1 0. 5 1)
$$

$$
\bar { x } _ { k }\ =\\frac { 1 } { N _ { k } }\sum _ { n = 1 } ^ { N } r _ { n k } x _ { n } & & (1 0. 5 2)\\
$$

$$
S _ { k }\ =\\frac { 1 } { N _ { k } }\sum _ { n = 1 } ^ { N } r _ { n k } (x _ { n } -\bar { x } _ { k }) (x _ { n } -\bar { x } _ { k }) ^ { T }.\\\intertext { t h e s e a n a l o g o u s t o q u n t i o n s e v a l u d e i n t i o n the maximum l i k e l h i o o d E M }
$$

Note that these are analogous to quantities evaluated in the maximum likelihood EM algorithm for the Gaussian mixture model.

Now let us consider the factor q (π, µ, Λ) in the variational posterior distribution. Again using the general result (10.9) we have

$$
\text {.}\text { Again using the general result (10.9) we have}\\\ln q ^ { * } (\pi,\mu,\Lambda) =\ln p (\pi) +\sum _ { k = 1 } ^ { K }\ln p (\mu _ { k },\Lambda _ { k }) +\mathbb { E } _ { Z }\left [\ln p (Z |\pi)\right]\\ +\sum _ { k = 1 } ^ { K }\sum _ { n = 1 } ^ { N }\mathbb { E } [z _ { n k }]\ln\mathcal { N }\left (x _ { n } |\mu _ { k },\Lambda _ { k } ^ { - 1 }\right) +\text {const.}\quad (1 0. 5 4)\\\text {observe that the right-hand side of this expression decomposes into a sum of}\\\text {ns involying only }\pi\text { together with terms only involying }\mu\text { and }\Lambda\text { which implies}
$$

We observe that the right-hand side of this expression decomposes into a sum of terms involving only π together with terms only involving µ and Λ, which implies that the variational posterior q (π, µ, Λ) factorizes to give q (π) q (µ, Λ). Furthermore, the terms involving µ and Λ themselves comprise a sum over k of terms involving µ k and Λ k leading to the further factorization

$$
q (\pi,\mu,\Lambda) = q (\pi)\prod _ { k = 1 } ^ { K } q (\mu _ { k },\Lambda _ { k }).
$$

Exercise 10.13

Exercise 10.14

Identifying the terms on the right-hand side of (10.54) that depend on π, we have

$$
\ln q ^ { * } (\pi) & = (\alpha _ { 0 } - 1)\sum _ { k = 1 } ^ { K }\ln\pi _ { k } +\sum _ { k = 1 } ^ { K }\sum _ { n = 1 } ^ { N } r _ { n k }\ln\pi _ { k } +\text {const}\quad (1 0. 5)\\\intertext { w h e v e h a v e u d (1 0. 5), $\ }\text {taking the exponential of both sides, we recognize}
$$

where we have used (10.50). Taking the exponential of both sides, we recognize q (π) as a Dirichlet distribution

$$
q ^ { * } (\pi) =\text {Dir} (\pi |\alpha)\\\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\qu
$$

where α has components α k given by

$$
\alpha _ { k } =\alpha _ { 0 } + N _ { k }.
$$

Finally, the variational posterior distribution q (µ k, Λ k) does not factorize into the product of the marginals, but we can always use the product rule to write it in the form q (µ k, Λ k) = q (µ k | Λ k) q (Λ k). The two factors can be found by inspecting (10.54) and reading off those terms that involve µ k and Λ k. The result, as expected, is a Gaussian-Wishart distribution and is given by

$$
&\text {is a Gaussian-Wishart distribution and is given by}\\ &\quad q ^ { * } (\mu _ { k },\Lambda _ { k }) =\mathcal { N }\left (\mu _ { k } | m _ { k }, (\beta _ { k }\Lambda _ { k }) ^ { - 1 }\right)\,\mathcal { W } (\Lambda _ { k } |\mathbf W _ { k },\nu _ { k })\\ &\text {where we have defined}
$$

where we have defined

$$
\beta _ { k }\ =\\beta _ { 0 } + N _ { k }
$$

$$
m _ { k }\ =\\frac { 1 } {\beta _ { k } }\left (\beta _ { 0 } m _ { 0 } + N _ { k }\overline { x } _ { k }\right)
$$

$$
W _ { k } ^ { - 1 }\ =\ W _ { 0 } ^ { - 1 } + N _ { k } S _ { k } +\frac {\beta _ { 0 } N _ { k } } {\beta _ { 0 } + N _ { k } } (\bar { x } _ { k } - m _ { 0 }) (\bar { x } _ { k } - m _ { 0 }) ^ { T }\quad (1 0. 6 2)
$$

$$
\nu _ { k }\ =\\nu _ { 0 } + N _ { k }.
$$

These update equations are analogous to the M-step equations of the EM algorithm for the maximum likelihood solution of the mixture of Gaussians. We see that the computations that must be performed in order to update the variational posterior distribution over the model parameters involve evaluation of the same sums over the data set, as arose in the maximum likelihood treatment.

In order to perform this variational M step, we need the expectations E [z nk] = r nk representing the responsibilities. These are obtained by normalizing the ρ nk that are given by (10.46). We see that this expression involves expectations with respect to the variational distributions of the parameters, and these are easily evaluated to give

$$
\mathbb { E } _ {\mu _ { k },\Lambda _ { k } }\left [(x _ { n } -\mu _ { k }) ^ { T }\Lambda _ { k } (x _ { n } -\mu _ { k })\right]\\ =\ D\beta _ { k } ^ { - 1 } +\nu _ { k } (x _ { n } - m _ { k }) ^ { T } W _ { k } (x _ { n } - m _ { k })\quad (1 0. 6 4)\\\infty
$$

$$
\begin{array} { r l r } { = } & { D\beta _ { k } ^ { 2 } +\nu _ { k } (x _ { n } - m _ { k }) ^ { 2 } W _ { k } (x _ { n } - m _ { k }) } & { (1 0. 6 4) }\\ {\ln\widetilde {\Lambda } _ { k }\equiv\mathbb { E }\left [\ln |\Lambda _ { k } |\right] } & { = } & {\sum _ { i = 1 } ^ { D }\psi\left (\frac {\nu _ { k } + 1 - i } { 2 }\right) + D\ln 2 +\ln | W _ { k } | } & { (1 0. 6 5) }\\ {\ln\widetilde {\pi } _ { k }\equiv\mathbb { E }\left [\ln\pi _ { k }\right] } & { = } & {\psi (\alpha _ { k }) -\psi (\widehat {\alpha }) }\end{array}
$$

$$
\ln\widetilde {\pi } _ { k }\equiv\mathbb { E }\left [\ln\pi _ { k }\right]\ =\\psi (\alpha _ { k }) -\psi (\widehat {\alpha })\quad\\
$$

Appendix B

Exercise 10.15 where we have introduced definitions of Λ k and π k, and ψ (·) is the digamma function defined by (B.25), with α = k α k. The results (10.65) and (10.66) follow from the standard properties of the Wishart and Dirichlet distributions. If we substitute (10.64), (10.65), and (10.66) into (10.46) and make use of (10.49), we obtain the following result for the responsibilities

If we substitute (10.64), (10.65), and (10.66) into (10.46) and make use of (10.49), we obtain the following result for the responsibilities

$$
(1 0. 4),\, &\text {we obtain the following result for the responsibilities}\\ & r _ { n k }\,\alpha\,\widetilde {\pi } _ { k }\widetilde {\Lambda } _ { k } ^ { 1 / 2 }\exp\left\{ -\frac { D } { 2\beta _ { k } } -\frac {\nu _ { k } } { 2 } (x _ { n } - m _ { k }) ^ { T } W _ { k } (x _ { n } - m _ { k })\right\}.\\ &\text {Notice the similarity to the corresponding result for the responsibilities in maximum}\\ &\text {likelihood EM, which from (9.13) can be written in the form}
$$

Notice the similarity to the corresponding result for the responsibilities in maximum likelihood EM, which from (9.13) can be written in the form

$$
\text {improved} E,\text { which in } (9. 1 5)\text { can be written in the form }\\ r _ { n k }\in\pi _ { k } |\Lambda _ { k } | ^ { 1 / 2 }\exp\left\{ -\frac { 1 } { 2 } (x _ { n } -\mu _ { k }) ^ { T }\Lambda _ { k } (x _ { n } -\mu _ { k })\right\}\\\intertext { w h o r v o h v o s u d t h o r v i o n v o p i s e d t h o w h e v i n g h t b o t h i l l }
$$

where we have used the precision in place of the covariance to highlight the similarity to (10.67).

Thus the optimization of the variational posterior distribution involves cycling between two stages analogous to the E and M steps of the maximum likelihood EM algorithm. In the variational equivalent of the E step, we use the current distributions over the model parameters to evaluate the moments in (10.64), (10.65), and (10.66) and hence evaluate E [z nk] = r nk. Then in the subsequent variational equivalent of the M step, we keep these responsibilities fixed and use them to re-compute the variational distribution over the parameters using (10.57) and (10.59). In each case, we see that the variational posterior distribution has the same functional form as the corresponding factor in the joint distribution (10.41). This is a general result and is a consequence of the choice of conjugate distributions.

Figure 10.6 shows the results of applying this approach to the rescaled Old Faithful data set for a Gaussian mixture model having K = 6 components. We see that after convergence, there are only two components for which the expected values of the mixing coefficients are numerically distinguishable from their prior values. This effect can be understood qualitatively in terms of the automatic trade-off in a Bayesian model between fitting the data and the complexity of the model, in which the complexity penalty arises from components whose parameters are pushed away from their prior values. Components that take essentially no responsibility for explaining the data points have r nk 0 and hence N k 0. From (10.58), we see that α k α 0 and from (10.60)-(10.63) we see that the other parameters revert to their prior values. In principle such components are fitted slightly to the data points, but for broad priors this effect is too small to be seen numerically. For the variational Gaussian mixture model the expected values of the mixing coefficients in the posterior distribution are given by

$$
\mathbb { E } [\pi _ { k }] =\frac {\alpha _ { k } + N _ { k } } { K\alpha _ { 0 } + N }.
$$

Consider a component for which N k 0 and α k α 0. If the prior is broad so that α 0 → 0, then E [π k] → 0 and the component plays no role in the model, whereas if

Figure 10.6 Variational Bayesian mixture of K = 6 Gaussians applied to the Old Faithful data set, in which the ellipses denote the one standard-deviation density contours for each of the components, and the density of red ink inside each ellipse corresponds to the mean value of the mixing coefficient for each component. The number in the top left of each diagram shows the number of iterations of variational inference. Components whose expected mixing coefficient are numerically indistinguishable from zero are not plotted.

![image 238](Bishop2006_images/imageFile238.png)

In Figure 10.6, the prior over the mixing coefficients is a Dirichlet of the form (10.39). Recall from Figure 2.5 that for α 0 < 1 the prior favours solutions in which some of the mixing coefficients are zero. Figure 10.6 was obtained using α 0 = 10 − 3, and resulted in two components having nonzero mixing coefficients. If instead we choose α 0 = 1 we obtain three components with nonzero mixing coefficients, and for α = 10 all six components have nonzero mixing coefficients.

As we have seen there is a close similarity between the variational solution for the Bayesian mixture of Gaussians and the EM algorithm for maximum likelihood. In fact if we consider the limit N → ∞ then the Bayesian treatment converges to the maximum likelihood EM algorithm. For anything other than very small data sets, the dominant computational cost of the variational algorithm for Gaussian mixtures arises from the evaluation of the responsibilities, together with the evaluation and inversion of the weighted data covariance matrices. These computations mirror precisely those that arise in the maximum likelihood EM algorithm, and so there is little computational overhead in using this Bayesian approach as compared to the traditional maximum likelihood one. There are, however, some substantial advantages. First of all, the singularities that arise in maximum likelihood when a Gaussian component 'collapses' onto a specific data point are absent in the Bayesian treatment.

Exercise 10.16

Indeed, these singularities are removed if we simply introduce a prior and then use a MAP estimate instead of maximum likelihood. Furthermore, there is no over-fitting if we choose a large number K of components in the mixture, as we saw in Figure 10.6. Finally, the variational treatment opens up the possibility of determining the optimal number of components in the mixture without resorting to techniques such as cross validation.

#### 10.2.2 Variational lower bound

We can also straightforwardly evaluate the lower bound (10.3) for this model. In practice, it is useful to be able to monitor the bound during the re-estimation in order to test for convergence. It can also provide a valuable check on both the mathematical expressions for the solutions and their software implementation, because at each step of the iterative re-estimation procedure the value of this bound should not decrease. We can take this a stage further to provide a deeper test of the correctness of both the mathematical derivation of the update equations and of their software implementation by using finite differences to check that each update does indeed give a (constrained) maximum of the bound (Svens´ en and Bishop, 2004).

For the variational mixture of Gaussians, the lower bound (10.3) is given by

$$
\text {For the variational mixture of Gaussians, the lower bound (10.3) is given by}\\\mathcal { L }\ =\\sum _ { Z }\iint q (Z,\pi,\mu,\Lambda)\ln\left\{\frac { p (X, Z,\pi,\mu,\Lambda) } { q (Z,\pi,\mu,\Lambda) }\right\}\, d\pi d\mu d\Lambda\\\equiv\\mathbb { E } [\ln p (X, Z,\pi,\mu,\Lambda)] -\mathbb { E } [\ln q (Z,\pi,\mu,\Lambda)]\\\equiv\\mathbb { E } [\ln p (X | Z,\mu,\Lambda)] +\mathbb { E } [\ln p (Z |\pi)] +\mathbb { E } [\ln p (\mu,\Lambda)]\\ -\mathbb { E } [\ln q (Z)] -\mathbb { E } [\ln q (\pi)] -\mathbb { E } [\ln q (\mu,\Lambda)]\\\quad\text {where, to keep the notation uncluttered, we have omitted the * superscript on the}
$$

where, to keep the notation uncluttered, we have omitted the superscript on the q distributions, along with the subscripts on the expectation operators because each expectation is taken with respect to all of the random variables in its argument. The various terms in the bound are easily evaluated to give the following results

$$
\text { various terms in the bound are easily evaluated to give the following results}\\\mathbb { E } [\ln p (X | Z,\mu,\Lambda)] =\frac { 1 } { 2 }\sum _ { k = 1 } ^ { K } N _ { k }\left\{\ln\widetilde {\Lambda } _ { k } - D\beta _ { k } ^ { - 1 } -\nu _ { k }\text {Tr} (S _ { k } W _ { k })\\ -\nu _ { k } (\bar { x } _ { k } - m _ { k }) ^ { T } W _ { k } (\bar { x } _ { k } - m _ { k }) - D\ln (2\pi)\right\} (1 0. 7 1)\\\mathbb { E } [\ln\rho (Z | +)]\sum _ { k = 1 } ^ { N }\sum _ {\substack { k = 1\\\sum\rho (k) = 0 } }\ln\widetilde {\rho } _ { k }\sim\widetilde {\rho } _ { k }\\
$$

$$
\mathbb { E } [\ln p (Z |\pi)]\ =\\sum _ { n = 1 } ^ { N }\sum _ { k = 1 } ^ { K } r _ { n k }\ln\widetilde {\pi } _ { k }\\\mathbb { E } [\ln p (\pi)]\ =\\ln C (\alpha _ { 0 }) + (\alpha _ { 0 } - 1)\sum _ { k = 1 } ^ { K }\ln\widetilde {\pi } _ { k }
$$

$$
\mathbb { E } [\ln p (\pi)]\ =\\ln C (\alpha _ { 0 }) + (\alpha _ { 0 } - 1)\sum _ { k = 1 } ^ { K }\ln\widetilde {\pi } _ { k }
$$

Exercise 10.18

$$
\mathbb { F }\max &\inf [N _ { k }\text { } (m _ { k } - m _ { 0 }) ^ { T } W _ { k } (m _ { k } - m _ { 0 })\Big\} + K\ln B (W _ { 0 },\nu _ { 0 })\\ & +\frac { (\nu _ { 0 } - D - 1) } { 2 }\sum _ { k = 1 } ^ { K }\ln\widetilde {\Lambda } _ { k } -\frac { 1 } { 2 }\sum _ { k = 1 } ^ { K }\nu _ { k }\text {Tr} (W _ { 0 } ^ { - 1 } W _ { k })\\ &\mathbb { F } [\ln\alpha (Z)] -\sum _ { k = 1 } ^ { N }\sum _ { k = 1 } ^ { K } m _ { k } - m _ { 0 }
$$

$$
\mathbb { E } [\ln q (Z)] & =\sum _ { n = 1 } ^ { N }\sum _ { k = 1 } ^ { K } r _ { n k }\ln r _ { n k }
$$

$$
&\mathbb { N } ^ { 1 }\kappa = 1\\ &\mathbb { E } [\ln q (\pi)] =\sum _ { k = 1 } ^ { K } (\alpha _ { k } - 1)\ln\widetilde {\pi } _ { k } +\ln C (\alpha)\\\\\mathbb { E } [\ln q (\mu,\Lambda)] & =\sum _ { k = 1 } ^ { K }\left\{\frac { 1 } { 2 }\ln\widetilde {\Lambda } _ { k } +\frac { D } { 2 }\ln\left (\frac {\beta _ { k } } { 2\pi }\right) -\frac { D } { 2 } - H\left [q (\Lambda _ { k })\right]\right\}\\
$$

$$
\mathbb { E } [\ln q (\mu,\Lambda)]\, =\,\sum _ { k = 1 } ^ { K }\left\{\frac { 1 } { 2 }\ln\widetilde {\Lambda } _ { k } +\frac { D } { 2 }\ln\left (\frac {\beta _ { k } } { 2\pi }\right) -\frac { D } { 2 } - H\left [q (\Lambda _ { k })\right]\right\}\, (1 0. 7 7)\\\intertext { w h e r D i s t h e d i m e n s i o n a l i t y o f x, H [q (\Lambda _ { k })] i s t h e t r o p y o f t h e W i s h art d i r b u - }
$$

where D is the dimensionality of x, H[q (Λ k)] is the entropy of the Wishart distribution given by (B.82), and the coefficients C (α) and B (W,ν) are defined by (B.23) and (B.79), respectively. Note that the terms involving expectations of the logs of the q distributions simply represent the negative entropies of those distributions. Some simplifications and combination of terms can be performed when these expressions are summed to give the lower bound. However, we have kept the expressions separate for ease of understanding.

Finally, it is worth noting that the lower bound provides an alternative approach for deriving the variational re-estimation equations obtained in Section 10.2.1. To do this we use the fact that, since the model has conjugate priors, the functional form of the factors in the variational posterior distribution is known, namely discrete for Z, Dirichlet for π, and Gaussian-Wishart for (µ k, Λ k). By taking general parametric forms for these distributions we can derive the form of the lower bound as a function of the parameters of the distributions. Maximizing the bound with respect to these parameters then gives the required re-estimation equations.

#### 10.2.3 Predictive density

In applications of the Bayesian mixture of Gaussians model we will often be interested in the predictive density for a new value x of the observed variable. Associated with this observation will be a corresponding latent variable z, and the predictive density is then given by (x X) = (x z Λ) (z) (Λ X)d d d Λ (10.78)

$$
\text {directive density is then given by}\\ p (\widehat { x } | X) =\sum _ {\widehat { z } }\iint p (\widehat { x } |\widehat { z },\mu,\Lambda) p (\widehat { z } |\pi) p (\pi,\mu,\Lambda | X)\, d\pi\, d\mu\, d\Lambda\\
$$

Exercise 10.19

Exercise 10.20

Exercise 10.21 where p (π, µ, Λ | X) is the (unknown) true posterior distribution of the parameters. Using (10.37) and (10.38) we can first perform the summation over z to give

$$
w h e r e & p (\pi,\mu,\Lambda | X)\,\text { is the (unknown) true posterior distribution of the parameters.}\\\text {Using (10.37) and (10.38) we can first perform the summation over\widehat { z } to give\\ &\quad p (\widehat { x } | X) =\sum _ { k = 1 } ^ { K }\iint\pi _ { k }\mathcal { N }\left (\widehat { x } |\mu _ { k },\Lambda _ { k } ^ { - 1 }\right) p (\pi,\mu,\Lambda | X)\, d\pi\, d\mu\, d\Lambda.\quad (10. 79)\\\text {Because the remaining integrations are intracutable, we approximate the predictive }\\\text {density by replacing the true posterior distribution } p (\pi,\mu,\Lambda | X)\,\text { with its variational }
$$

Because the remaining integrations are intractable, we approximate the predictive density by replacing the true posterior distribution p (π, µ, Λ | X) with its variational approximation q (π) q (µ, Λ) to give

$$
\text {app}\alpha\text {maided} q (\mu,\L _ { k })\text {,} &\in g\text {c}\\ p (\widehat { x } | X) =\sum _ { k = 1 } ^ { K }\iint\pi _ { k }\mathcal { N }\left (\widehat { x } |\mu _ { k },\Lambda _ { k } ^ { - 1 }\right) q (\pi) q (\mu _ { k },\Lambda _ { k })\, d\pi\, d\mu _ { k }\, d\Lambda _ { k }\quad (1 0. 8 0)\\\text {where we have made use of the factorization } (1 0. 5 5)\text { and in each term we have im-}\\\text {PLICITly integrated out all variables }\{\mu _ { i },\Lambda _ { i }\}\text { for } j\neq k\text { The remaining integrations}
$$

where we have made use of the factorization (10.55) and in each term we have implicitly integrated out all variables { µ j, Λ j } for j = k The remaining integrations can now be evaluated analytically giving a mixture of Student's t-distributions

/negationslash

$$
p (\widehat { x } | X) & =\frac { 1 } {\widehat {\alpha } }\sum _ { k = 1 } ^ { K }\alpha _ { k } S t (\widehat { x } | m _ { k }, L _ { k },\nu _ { k } + 1 - D)\\\intertext { c h e t h }\text { } &\quad (\nu _ { k } + 1 - D)\beta _ { k }
$$

in which the k th component has mean m k, and the precision is given by

$$
L _ { k } =\frac { (\nu _ { k } + 1 - D)\beta _ { k } } { (1 +\beta _ { k }) }\mathbf W _ { k }
$$

in which ν k is given by (10.63). When the size N of the data set is large the predictive distribution (10.81) reduces to a mixture of Gaussians.

#### 10.2.4 Determining the number of components

We have seen that the variational lower bound can be used to determine a posterior distribution over the number K of components in the mixture model. There is, however, one subtlety that needs to be addressed. For any given setting of the parameters in a Gaussian mixture model (except for specific degenerate settings), there will exist other parameter settings for which the density over the observed variables will be identical. These parameter values differ only through a re-labelling of the components. For instance, consider a mixture of two Gaussians and a single observed variable x, in which the parameters have the values π 1 = a, π 2 = b, µ 1 = c, µ 2 = d, σ 1 = e, σ 2 = f. Then the parameter values π 1 = b, π 2 = a, µ 1 = d, µ 2 = c, σ 1 = f, σ 2 = e, in which the two components have been exchanged, will by symmetry give rise to the same value of p (x). If we have a mixture model comprising K components, then each parameter setting will be a member of a family of K! equivalent settings.

In the context of maximum likelihood, this redundancy is irrelevant because the parameter optimization algorithm (for example EM) will, depending on the initialization of the parameters, find one specific solution, and the other equivalent solutions play no role. In a Bayesian setting, however, we marginalize over all possible

Figure 10.7

Plot of the variational lower bound L versus the number K of components in the Gaussian mixture model, for the Old Faithful data, showing a distinct peak at K = 2 components. For each value of K, the model is trained from 100 different random starts, and the results shown as ' + ' symbols plotted with small random horizontal perturbations so that they can be distinguished. Note that some solutions find suboptimal local maxima, but that this happens infrequently.

p (D| K)

![image 239](Bishop2006_images/imageFile239.png)

