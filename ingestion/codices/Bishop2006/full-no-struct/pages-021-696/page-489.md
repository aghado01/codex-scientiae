[Page 489]

![The image consists of three panels. Each panel contains a diagram with a red and blue color scheme. The diagram in each panel is a circular shape with a spiral pattern. The red color is used to represent the spiral pattern, while the blue color is used to represent the center of the spiral. The diagram in the first panel is a red circle with a spiral pattern. The red color is used to represent the spiral pattern, while the blue color is used to represent the center of the spiral. The diagram in the second panel is a red circle with a spiral pattern. The red color is used to represent the spiral pattern, while the blue color is used to represent the center of the spiral. The diagram in the third panel is a red circle with a spiral pattern. The red color is used to represent the spiral pattern, while the blue color is used to represent the center of the spiral. Each panel has a title at the bottom, which reads 2](../images/imageFile235.png)

(a)

(b)

(c)

Figure 10.3 Another comparison of the two alternative forms for the Kullback-Leibler divergence. (a) The blue contours show a bimodal distribution p ( Z ) given by a mixture of two Gaussians, and the red contours correspond to the single Gaussian distribution q ( Z ) that best approximates p ( Z ) in the sense of minimizing the KullbackLeibler divergence KL( p q ) . (b) As in (a) but now the red contours correspond to a Gaussian distribution q ( Z ) found by numerical minimization of the Kullback-Leibler divergence KL( q p ) . (c) As in (b) but showing a different local minimum of the Kullback-Leibler divergence.

Section 10.7

from regions of Z space in which p ( Z ) is near zero unless q ( Z ) is also close to zero. Thus minimizing this form of KL divergence leads to distributions q ( Z ) that avoid regions in which p ( Z ) is small. Conversely, the Kullback-Leibler divergence KL( p q ) is minimized by distributions q ( Z ) that are nonzero in regions where p ( Z ) is nonzero.

We can gain further insight into the different behaviour of the two KL divergences if we consider approximating a multimodal distribution by a unimodal one, as illustrated in Figure 10.3. In practical applications, the true posterior distribution will often be multimodal, with most of the posterior mass concentrated in some number of relatively small regions of parameter space. These multiple modes may arise through nonidentiﬁability in the latent space or through complex nonlinear dependence on the parameters. Both types of multimodality were encountered in Chapter 9 in the context of Gaussian mixtures, where they manifested themselves as multiple maxima in the likelihood function, and a variational treatment based on the minimization of KL( q p ) will tend to ﬁnd one of these modes. By contrast, if we were to minimize KL( p q ) , the resulting approximations would average across all of the modes and, in the context of the mixture model, would lead to poor predictive distributions (because the average of two good parameter values is typically itself not a good parameter value). It is possible to make use of KL( p q ) to deﬁne a useful inference procedure, but this requires a rather different approach to the one discussed here, and will be considered in detail when we discuss expectation propagation.

The two forms of Kullback-Leibler divergence are members of the alpha family
