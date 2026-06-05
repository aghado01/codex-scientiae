[Page 494]

of (10.35), and then subsequently determining the q ( m ) using (10.36). After normalization the resulting values for q ( m ) can be used for model selection or model averaging in the usual way.

# 10.2. Illustration: Variational Mixture of Gaussians

We now return to our discussion of the Gaussian mixture model and apply the variational inference machinery developed in the previous section. This will provide a good illustration of the application of variational methods and will also demonstrate how a Bayesian treatment elegantly resolves many of the difﬁculties associated with the maximum likelihood approach (Attias, 1999b). The reader is encouraged to work through this example in detail as it provides many insights into the practical application of variational methods. Many Bayesian models, corresponding to much more sophisticated distributions, can be solved by straightforward extensions and generalizations of this analysis.

Our starting point is the likelihood function for the Gaussian mixture model, illustrated by the graphical model in Figure 9.6. For each observation x n we have a corresponding latent variable z n comprising a 1-ofK binary vector with elements z nk for k = 1 ,...,K . As before we denote the observed data set by X = { x 1 ,..., x N } , and similarly we denote the latent variables by Z = { z 1 ,..., z N } . From (9.10) we can write down the conditional distribution of Z , given the mixing coefﬁcients π , in the form

$$
p ( Z | \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } . \\ \intertext { l } \intertext { a } \intertext { w e } \intertext { c a n w i t e d o w } \intertext { n }
$$

Similarly, from (9.11), we can write down the conditional distribution of the observed data vectors, given the latent variables and the component parameters

$$
p ( X | Z , \mu , \Lambda ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \mathcal { N } \left ( x _ { n } | \mu _ { k } , \Lambda _ { k } ^ { - 1 } \right ) ^ { z _ { n k } } \\ \mu = \{ \mu _ { k } \} \text { and } \Lambda = \{ \Lambda _ { k } \} . \text { Note that we are working in terms of precision }
$$

where µ = { µ k } and Λ = { Λ k } . Note that we are working in terms of precision matrices rather than covariance matrices as this somewhat simpliﬁes the mathematics.

Next we introduce priors over the parameters µ , Λ and π . The analysis is considerably simpliﬁed if we use conjugate prior distributions. We therefore choose a Dirichlet distribution over the mixing coefﬁcients π

$$
p ( \pi ) = \text {Dir} ( \pi | \alpha _ { 0 } ) = C ( \alpha _ { 0 } ) \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { \alpha _ { 0 } - 1 } \\ \text {symmetry we have chosen the same parameter $\alpha_{0}$ for each of the compo-}
$$

where by symmetry we have chosen the same parameter α 0 for each of the components, and C ( α 0 ) is the normalization constant for the Dirichlet distribution deﬁned
