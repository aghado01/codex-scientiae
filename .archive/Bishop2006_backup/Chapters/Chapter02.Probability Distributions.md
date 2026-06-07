## 2. Probability Distributions

In Chapter 1, we emphasized the central role played by probability theory in the solution of pattern recognition problems. We turn now to an exploration of some particular examples of probability distributions and their properties. As well as being of great interest in their own right, these distributions can form building blocks for more complex models and will be used extensively throughout the book. The distributions introduced in this chapter will also serve another important purpose, namely to provide us with the opportunity to discuss some key statistical concepts, such as Bayesian inference, in the context of simple models before we encounter them in more complex situations in later chapters.

One role for the distributions discussed in this chapter is to model the probability distribution p (x) of a random variable x, given a finite set x 1,..., x N of observations. This problem is known as density estimation. For the purposes of this chapter, we shall assume that the data points are independent and identically distributed. It should be emphasized that the problem of density estimation is fun- damentally ill-posed, because there are infinitely many probability distributions that could have given rise to the observed finite data set. Indeed, any distribution p (x) that is nonzero at each of the data points x 1,..., x N is a potential candidate. The issue of choosing an appropriate distribution relates to the problem of model selection that has already been encountered in the context of polynomial curve fitting in Chapter 1 and that is a central issue in pattern recognition.

We begin by considering the binomial and multinomial distributions for discrete random variables and the Gaussian distribution for continuous random variables. These are specific examples of parametric distributions, so-called because they are governed by a small number of adaptive parameters, such as the mean and variance in the case of a Gaussian for example. To apply such models to the problem of density estimation, we need a procedure for determining suitable values for the parameters, given an observed data set. In a frequentist treatment, we choose specific values for the parameters by optimizing some criterion, such as the likelihood function. By contrast, in a Bayesian treatment we introduce prior distributions over the parameters and then use Bayes' theorem to compute the corresponding posterior distribution given the observed data.

We shall see that an important role is played by conjugate priors, that lead to posterior distributions having the same functional form as the prior, and that therefore lead to a greatly simplified Bayesian analysis. For example, the conjugate prior for the parameters of the multinomial distribution is called the Dirichlet distribution, while the conjugate prior for the mean of a Gaussian is another Gaussian. All of these distributions are examples of the exponential family of distributions, which possess a number of important properties, and which will be discussed in some detail.

One limitation of the parametric approach is that it assumes a specific functional form for the distribution, which may turn out to be inappropriate for a particular application. An alternative approach is given by nonparametric density estimation methods in which the form of the distribution typically depends on the size of the data set. Such models still contain parameters, but these control the model complexity rather than the form of the distribution. We end this chapter by considering three nonparametric methods based respectively on histograms, nearest-neighbours, and kernels.

### 2.1 Binary Variables

We begin by considering a single binary random variable x ∈ { 0, 1 }. For example, x might describe the outcome of flipping a coin, with x = 1 representing 'heads', and x = 0 representing 'tails'. We can imagine that this is a damaged coin so that the probability of landing heads is not necessarily the same as that of landing tails. The probability of x = 1 will be denoted by the parameter µ so that

$$
p (x = 1 |\mu) =\mu
$$

Exercise 2.1 where 0 µ 1, from which it follows that p (x = 0 | µ) = 1 − µ. The probability distribution over x can therefore be written in the form

$$
\ B e r n (x |\mu) & =\mu ^ { x } (1 -\mu) ^ { 1 - x } & (2. 2)\\\\
$$

which is known as the Bernoulli distribution. It is easily verified that this distribution is normalized and that it has mean and variance given by

$$
\mathbb { E } [x]\ =\\mu
$$

$$
\ v a r [x]\ =\\mu (1 -\mu).\\
$$

Now suppose we have a data set D = { x 1,...,x N } of observed values of x. We can construct the likelihood function, which is a function of µ, on the assumption that the observations are drawn independently from p (x | µ), so that

$$
p (\mathcal { D } |\mu) =\prod _ { n = 1 } ^ { N } p (x _ { n } |\mu) =\prod _ { n = 1 } ^ { N }\mu ^ { x _ { n } } (1 -\mu) ^ { 1 - x _ { n } }.\\\text {request}\, t i n g t s e c k e a n d e s i m a t e a v i l e f o r\mu\, b y\,\max i m i z i n g h e t l i k h o o d
$$

In a frequentist setting, we can estimate a value for µ by maximizing the likelihood function, or equivalently by maximizing the logarithm of the likelihood. In the case of the Bernoulli distribution, the log likelihood function is given by

$$
\ln p (\mathcal { D } |\mu) =\sum _ { n = 1 } ^ { N }\ln p (x _ { n } |\mu) =\sum _ { n = 1 } ^ { N }\{ x _ { n }\ln\mu + (1 - x _ { n })\ln (1 -\mu)\}\,.\quad (2. 6)\\\intertext { a t h i s p o n t i s w h o r $ t h i s p o w n o w $ }\At t h i s p o w n o w\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext { a t h i s p o w n o w }\intertext
$$

At this point, it is worth noting that the log likelihood function depends on the N observations x n only through their sum n x n. This sum provides an example of a sufficient statistic for the data under this distribution, and we shall study the important role of sufficient statistics in some detail. If we set the derivative of ln p (D| µ) with respect to µ equal to zero, we obtain the maximum likelihood estimator

$$
\mu _ { M L } =\frac { 1 } { N }\sum _ { n = 1 } ^ { N } x _ { n }
$$

![image 10](Bishop2006_images/imageFile10.png)

#### Jacob Bernoulli 1654-1705

Jacob Bernoulli, also known as Jacques or James Bernoulli, was a Swiss mathematician and was the first of many in the Bernoulli family to pursue a career in science and mathematics. Although compelled and theology against his will by to study philosophy his parents, he travelled extensively after graduating in order to meet with many of the leading scientists of his time, including Boyle and Hooke in England. When he returned to Switzerland, he taught mechanics and became Professor of Mathematics at Basel in 1687. Unfortunately, rivalry between Jacob and his younger brother Johann turned an initially productive collaboration into a bitter and public dispute. Jacob's most significant contributions to mathematics appeared in The Art of Conjecture published in 1713, eight years after his death, which deals with topics in probability theory including what has become known as the Bernoulli distribution.

Figure 2.1 Histogram plot of the binomial distribution (2.9) as a function of m for N = 10 and µ = 0. 25.

![image 40](Bishop2006_images/imageFile40.png)

$$
\mu _ { M L } =\frac { m } { N }
$$

so that the probability of landing heads is given, in this maximum likelihood framework, by the fraction of observations of heads in the data set.

Now suppose we flip a coin, say, 3 times and happen to observe 3 heads. Then N = m = 3 and µ ML = 1. In this case, the maximum likelihood result would predict that all future observations should give heads. Common sense tells us that this is unreasonable, and in fact this is an extreme example of the over-fitting associated with maximum likelihood. We shall see shortly how to arrive at more sensible conclusions through the introduction of a prior distribution over µ.

We can also work out the distribution of the number m of observations of x = 1, given that the data set has size N. This is called the binomial distribution, and from (2.5) we see that it is proportional to µ m (1 − µ) N − m. In order to obtain the normalization coefficient we note that out of N coin flips, we have to add up all of the possible ways of obtaining m heads, so that the binomial distribution can be written

$$
\text {Bin} (m | N,\mu) =\binom { N } { m }\mu ^ { m } (1 -\mu) ^ { N - m }
$$

where

$$
\begin{pmatrix} N\\ m\end{pmatrix}\equiv\frac { N! } { (N - m)! m! } & (2. 1 0)\\\intertext { s o f s o i n g s i n g m o b i c t e s o u t o f a t o l a t o l $ N $ i d e n t i c a l $ o b i c t e s. }
$$

is the number of ways of choosing m objects out of a total of N identical objects. Figure 2.1 shows a plot of the binomial distribution for N = 10 and µ = 0. 25.

The mean and variance of the binomial distribution can be found by using the result of Exercise 1.10, which shows that for independent events the mean of the sum is the sum of the means, and the variance of the sum is the sum of the variances. Because m = x 1 +... + x N, and for each observation the mean and variance are given by (2.3) and (2.4), respectively, we have

$$
\mathbb { E } [m] &\equiv\sum _ { m = 0 } ^ { N } m\sin (m | N,\mu)\ =\ N\mu\\
$$

$$
var [m] &\equiv\sum _ { m = 0 } ^ { N } (m -\mathbb { E } [m]) ^ { 2 }\,\text {Bin} (m | N,\mu)\ =\ N\mu (1 -\mu).\quad (2. 1 2)\\\text {These results can also be proved directly using calculus.}
$$

These results can also be proved directly using calculus. Exercise 2.4

#### 2.1.1 The beta distribution

We have seen in (2.8) that the maximum likelihood setting for the parameter µ in the Bernoulli distribution, and hence in the binomial distribution, is given by the fraction of the observations in the data set having x = 1. As we have already noted, this can give severely over-fitted results for small data sets. In order to develop a Bayesian treatment for this problem, we need to introduce a prior distribution p (µ) over the parameter µ. Here we consider a form of prior distribution that has a simple interpretation as well as some useful analytical properties. To motivate this prior, we note that the likelihood function takes the form of the product of factors of the form µ x (1 − µ) 1 − x. If we choose a prior to be proportional to powers of µ and (1 − µ), then the posterior distribution, which is proportional to the product of the prior and the likelihood function, will have the same functional form as the prior. This property is called conjugacy and we will see several examples of it later in this chapter. We therefore choose a prior, called the beta distribution, given by

$$
\ B e t a (\mu | a, b) =\frac {\Gamma (a + b) } {\Gamma (a)\Gamma (b) }\mu ^ { a - 1 } (1 -\mu) ^ { b - 1 }
$$

where Γ(x) is the gamma function defined by (1.141), and the coefficient in (2.13) ensures that the beta distribution is normalized, so that

Exercise 2.5

$$
a\,\text {distribution is normalized, so that}\\\int _ { 0 } ^ { 1 }\, B\,\alpha (\mu | a, b)\, d\mu = 1.\\\intertext { c o n s e f t h e\, b e t a\, d i s t r i b u t i o n are g i v e n b y }
$$

The mean and variance of the beta distribution are given by Exercise 2.6

$$
\mathbb { E } [\mu]\ =\\frac { a } { a + b }\quad\\
$$

$$
v a r [\mu]\ =\\frac { a b } { (a + b) ^ { 2 } (a + b + 1) }.
$$

The parameters a and b are often called hyperparameters because they control the distribution of the parameter µ. Figure 2.2 shows plots of the beta distribution for various values of the hyperparameters.

The posterior distribution of µ is now obtained by multiplying the beta prior (2.13) by the binomial likelihood function (2.9) and normalizing. Keeping only the factors that depend on µ, we see that this posterior distribution has the form

$$
p (\mu | m, l, a, b)\,\infty\,\mu ^ { m + a - 1 } (1 -\mu) ^ { l + b - 1 }
$$

![image 41](Bishop2006_images/imageFile41.png)

Figure 2.2 Plots of the beta distribution Beta(µ | a, b) given by (2.13) as a function of µ for various values of the hyperparameters a and b.

where l = N − m, and therefore corresponds to the number of 'tails' in the coin example. We see that (2.17) has the same functional dependence on µ as the prior distribution, reflecting the conjugacy properties of the prior with respect to the likelihood function. Indeed, it is simply another beta distribution, and its normalization coefficient can therefore be obtained by comparison with (2.13) to give

$$
p (\mu | m, l, a, b) =\frac {\Gamma (m + a + l + b) } {\Gamma (m + a)\Gamma (l + b) }\mu ^ { m + a - 1 } (1 -\mu) ^ { l + b - 1 }.
$$

We see that the effect of observing a data set of m observations of x = 1 and l observations of x = 0 has been to increase the value of a by m, and the value of b by l, in going from the prior distribution to the posterior distribution. This allows us to provide a simple interpretation of the hyperparameters a and b in the prior as an effective number of observations of x = 1 and x = 0, respectively. Note that a and b need not be integers. Furthermore, the posterior distribution can act as the prior if we subsequently observe additional data. To see this, we can imagine taking observations one at a time and after each observation updating the current posterior

![image 42](Bishop2006_images/imageFile42.png)

Figure 2.3 Illustration of one step of sequential Bayesian inference. The prior is given by a beta distribution with parameters a = 2, b = 2, and the likelihood function, given by (2.9) with N = m = 1, corresponds to a single observation of x = 1, so that the posterior is given by a beta distribution with parameters a = 3, b = 2.

We see that this sequential approach to learning arises naturally when we adopt a Bayesian viewpoint. It is independent of the choice of prior and of the likelihood function and depends only on the assumption of i.i.d. data. Sequential methods make use of observations one at a time, or in small batches, and then discard them before the next observations are used. They can be used, for example, in real-time learning scenarios where a steady stream of data is arriving, and predictions must be made before all of the data is seen. Because they do not require the whole data set to be stored or loaded into memory, sequential methods are also useful for large data sets. Maximum likelihood methods can also be cast into a sequential framework.

If our goal is to predict, as best we can, the outcome of the next trial, then we must evaluate the predictive distribution of x, given the observed data set D. From the sum and product rules of probability, this takes the form

$$
1\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text
$$

Using the result (2.18) for the posterior distribution p (µ |D), together with the result (2.15) for the mean of the beta distribution, we obtain

$$
p (x = 1 |\mathcal { D }) =\frac { m + a } { m + a + l + b }
$$

which has a simple interpretation as the total fraction of observations (both real observations and fictitious prior observations) that correspond to x = 1. Note that in the limit of an infinitely large data set m,l → ∞ the result (2.20) reduces to the maximum likelihood result (2.8). As we shall see, it is a very general property that the Bayesian and maximum likelihood results will agree in the limit of an infinitely

