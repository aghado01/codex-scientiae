[Page 236]

and Nabney, 2008). Many of the distributions encountered in practice will be multimodal and so there will be different Laplace approximations according to which mode is being considered. Note that the normalization constant Z of the true distribution does not need to be known in order to apply the Laplace method. As a result of the central limit theorem, the posterior distribution for a model is expected to become increasingly better approximated by a Gaussian as the number of observed data points is increased, and so we would expect the Laplace approximation to be most useful in situations where the number of data points is relatively large.

One major weakness of the Laplace approximation is that, since it is based on a Gaussian distribution, it is only directly applicable to real variables. In other cases it may be possible to apply the Laplace approximation to a transformation of the variable. For instance if 0 � τ < ∞ then we can consider a Laplace approximation of lnτ. The most serious limitation of the Laplace framework, however, is that it is based purely on the aspects of the true distribution at a speciﬁc value of the variable, and so can fail to capture important global properties. In Chapter 10 we shall consider alternative approaches which adopt a more global perspective.

4.4.1 Model comparison and BIC

As well as approximating the distribution p(z) we can also obtain an approximation to the normalization constant Z. Using the approximation (4.133) we have

Z = � f(z)dz

� f(z0)� exp�−

(z − z0)TA(z − z0)� dz

1 2

(2π)M/2 |A|1/2

= f(z0)

(4.135)

where we have noted that the integrand is Gaussian and made use of the standard result (2.43) for a normalized Gaussian distribution. We can use the result (4.135) to obtain an approximation to the model evidence which, as discussed in Section 3.4, plays a central role in Bayesian model comparison.

Consider a data set D and a set of models {Mi} having parameters {θi}. For each model we deﬁne a likelihood function p(D|θi,Mi). If we introduce a prior p(θi|Mi) over the parameters, then we are interested in computing the model evidence p(D|Mi) for the various models. From now on we omit the conditioning on Mi to keep the notation uncluttered. From Bayes’ theorem the model evidence is given by

p(D) = � p(D|θ)p(θ)dθ. (4.136)

Identifying f(θ) = p(D|θ)p(θ) and Z = p(D), and applying the result (4.135), we Exercise 4.22 obtain

1 2

M 2

lnp(D) � lnp(D|θMAP) + lnp(θMAP) +

ln|A| � Occam factor�� �

ln(2π) −

(4.137)
