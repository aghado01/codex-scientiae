[Page 103]

# Exercise 2.21

where again we have changed variables using z = x − µ . Note that the cross-terms involving µ z T and µ T z will again vanish by symmetry. The term µµ T is constant and can be taken outside the integral, which itself is unity because the Gaussian distribution is normalized. Consider the term involving zz T . Again, we can make use of the eigenvector expansion of the covariance matrix given by (2.45), together with the completeness of the set of eigenvectors, to write

$$
z = \sum _ { j = 1 } ^ { D } y _ { j } u _ { j } & & ( 2 . 6 0 )
$$

where y j = u T j z , which gives

$$
where y _ { j } & = u _ { j } ^ { T } z , \text { which gives} \\ & \frac { 1 } { ( 2 \pi ) ^ { D / 2 } } \frac { 1 } { | \Sigma | ^ { 1 / 2 } } \int \exp \left \{ - \frac { 1 } { 2 } z ^ { T } \Sigma ^ { - 1 } z \right \} z z ^ { T } \, d z \\ & = \frac { 1 } { ( 2 \pi ) ^ { D / 2 } } \frac { 1 } { | \Sigma | ^ { 1 / 2 } } \sum _ { i = 1 } ^ { D } \sum _ { j = 1 } ^ { D } u _ { i } u _ { j } ^ { T } \int \exp \left \{ - \sum _ { k = 1 } ^ { D } \frac { y _ { k } ^ { 2 } } { 2 \lambda _ { k } } \right \} y _ { i j } \, d y \\ & = \sum _ { i = 1 } ^ { D } u _ { i } u _ { i } ^ { T } \lambda _ { i } = \Sigma \\ \intertext { w h e v a d e s u m e } \text { that the integral on the right-hand side of the middle line vanishes by symmetry}
$$

where we have made use of the eigenvector equation (2.45), together with the fact that the integral on the right-hand side of the middle line vanishes by symmetry unless i = j , and in the ﬁnal line we have made use of the results (1.50) and (2.55), together with (2.48). Thus we have

$$
\mathbb { E } [ x x ^ { T } ] = \mu \mu ^ { T } + \Sigma .
$$

For single random variables, we subtracted the mean before taking second moments in order to deﬁne a variance. Similarly, in the multivariate case it is again convenient to subtract off the mean, giving rise to the covariance of a random vector x deﬁned by T

$$
& y & & \text {cov} [ x ] = \mathbb { E } \left [ ( x - \mathbb { E } [ x ] ) ( x - \mathbb { E } [ x ] ) ^ { T } \right ] . & & ( 2 . 6 3 ) \\ & \text {specific case of a Gaussian distribution, we can make use of } \mathbb { E } [ x ] = \mu , \\ & \text {th the result (2.62), to give}
$$

For the speciﬁc case of a Gaussian distribution, we can make use of E [ x ] = µ , together with the result (2.62), to give

$$
c o v [ x ] = \Sigma .
$$

Because the parameter matrix Σ governs the covariance of x under the Gaussian distribution, it is called the covariance matrix.

Although the Gaussian distribution (2.43) is widely used as a density model, it suffers from some significant limitations. Consider the number of free parameters in the distribution. A general symmetric covariance matrix Σ will have D ( D + 1) / 2 independent parameters, and there are another D independent parameters in µ , giving D ( D + 3) / 2 parameters in total. For large D , the total number of parameters therefore grows quadratically with D , and the computational task of manipulating and inverting large matrices can become prohibitive. One way to address this problem is to use restricted forms of the covariance matrix. If we consider covariance matrices that are diagonal , so that Σ = diag( σ 2 i ) , we then have a total of 2 D independent parameters in the density model. The corresponding contours of constant density are given by axis-aligned ellipsoids. We could further restrict the covariance matrix to be proportional to the identity matrix, Σ = σ 2 I , known as an isotropic covariance, giving D +1 independent parameters in the model and spherical surfaces of constant density. The three possibilities of general, diagonal, and isotropic covariance matrices are illustrated in Figure 2.8. Unfortunately, whereas such approaches limit the number of degrees of freedom in the distribution and make inversion of the covariance matrix a much faster operation, they also greatly restrict the form of the probability density and limit its ability to capture interesting correlations in the data.
