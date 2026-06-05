[Page 140]

An example of a scale parameter would be the standard deviation σ of a Gaussian distribution, after we have taken account of the location parameter µ, because

�−(�x/σ)2

�

N(x|µ,σ2) ∝ σ−1 exp

(2.240)

where �x = x − µ. As discussed earlier, it is often more convenient to work in terms of the precision λ = 1/σ2 rather than σ itself. Using the transformation rule for densities, we see that a distribution p(σ) ∝ 1/σ corresponds to a distribution over λ of the form p(λ) ∝ 1/λ. We have seen that the conjugate prior for λ was the gamma

Section 2.3 distribution Gam(λ|a0,b0) given by (2.146). The noninformative prior is obtained as the special case a0 = b0 = 0. Again, if we examine the results (2.150) and (2.151) for the posterior distribution of λ, we see that for a0 = b0 = 0, the posterior depends only on terms arising from the data and not from the prior.

2.5. Nonparametric Methods

Throughout this chapter, we have focussed on the use of probability distributions having speciﬁc functional forms governed by a small number of parameters whose values are to be determined from a data set. This is called the parametric approach to density modelling. An important limitation of this approach is that the chosen density might be a poor model of the distribution that generates the data, which can result in poor predictive performance. For instance, if the process that generates the data is multimodal, then this aspect of the distribution can never be captured by a Gaussian, which is necessarily unimodal.

In this ﬁnal section, we consider some nonparametric approaches to density estimation that make few assumptions about the form of the distribution. Here we shall focus mainly on simple frequentist methods. The reader should be aware, however, that nonparametric Bayesian methods are attracting increasing interest (Walker et al., 1999; Neal, 2000; Muller and Quintana, 2004; Teh¨ et al., 2006).

Let us start with a discussion of histogram methods for density estimation, which we have already encountered in the context of marginal and conditional distributions in Figure 1.11 and in the context of the central limit theorem in Figure 2.6. Here we explore the properties of histogram density models in more detail, focussing on the case of a single continuous variable x. Standard histograms simply partition x into distinct bins of width ∆i and then count the number ni of observations of x falling in bin i. In order to turn this count into a normalized probability density, we simply divide by the total number N of observations and by the width ∆i of the bins to obtain probability values for each bin given by

ni N∆i

pi =

(2.241)

�

p(x)dx = 1. This gives a model for the density p(x) that is constant over the width of each bin, and often the bins are chosen to have the same width ∆i = ∆.

for which it is easily seen that
