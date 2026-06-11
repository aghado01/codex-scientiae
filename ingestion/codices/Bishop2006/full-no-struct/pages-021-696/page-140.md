[Page 140]

Section 2.3

An example of a scale parameter would be the standard deviation σ of a Gaussian distribution, after we have taken account of the location parameter µ , because

$$
& \quad \mathcal { N } ( x | \mu , \sigma ^ { 2 } ) \, \alpha \, \sigma ^ { - 1 } \exp \left \{ - ( \widetilde { x } / \sigma ) ^ { 2 } \right \} \\ & - \mu . \, \text {As discussed earlier, it is often more convenient to work in terms } \\ \text {ion} \, \rangle \, - \, 1 / \sigma ^ { 2 } \, \text {rather than } \, \sigma \, \text { itself.} \, \text {Using the transformation rule for }
$$

N ( x | µ,σ 2 ) ∝ σ − 1 exp − ( x/σ ) 2 (2.240) where x = x − µ . As discussed earlier, it is often more convenient to work in terms of the precision λ = 1 /σ 2 rather than σ itself. Using the transformation rule for densities, we see that a distribution p ( σ ) ∝ 1 /σ corresponds to a distribution over λ of the form p ( λ ) ∝ 1 /λ . We have seen that the conjugate prior for λ was the gamma distribution Gam( λ | a 0 ,b 0 ) given by (2.146). The noninformative prior is obtained as the special case a 0 = b 0 = 0 . Again, if we examine the results (2.150) and (2.151) for the posterior distribution of λ , we see that for a 0 = b 0 = 0 , the posterior depends only on terms arising from the data and not from the prior.

# 2.5. Nonparametric Methods

Throughout this chapter, we have focussed on the use of probability distributions having speciﬁc functional forms governed by a small number of parameters whose values are to be determined from a data set. This is called the parametric approach to density modelling. An important limitation of this approach is that the chosen density might be a poor model of the distribution that generates the data, which can result in poor predictive performance. For instance, if the process that generates the data is multimodal, then this aspect of the distribution can never be captured by a Gaussian, which is necessarily unimodal.

In this ﬁnal section, we consider some nonparametric approaches to density estimation that make few assumptions about the form of the distribution. Here we shall focus mainly on simple frequentist methods. The reader should be aware, however, that nonparametric Bayesian methods are attracting increasing interest (Walker et al. , 1999; Neal, 2000; M¨ uller and Quintana, 2004; Teh et al. , 2006).

Let us start with a discussion of histogram methods for density estimation, which we have already encountered in the context of marginal and conditional distributions in Figure 1.11 and in the context of the central limit theorem in Figure 2.6. Here we explore the properties of histogram density models in more detail, focussing on the case of a single continuous variable x . Standard histograms simply partition x into distinct bins of width ∆ i and then count the number n i of observations of x falling in bin i . In order to turn this count into a normalized probability density, we simply divide by the total number N of observations and by the width ∆ i of the bins to obtain probability values for each bin given by

$$
p _ { i } = \frac { n _ { i } } { N \Delta _ { i } }
$$

i for which it is easily seen that p ( x )d x = 1 . This gives a model for the density p ( x ) that is constant over the width of each bin, and often the bins are chosen to have the same width ∆ i = ∆ .
