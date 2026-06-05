[Page 598]

are assumed independent, the complete-data log likelihood function takes the form

$$
\ln p \left ( X , Z | \mu , \mathbb { W } , \sigma ^ { 2 } \right ) = \sum _ { n = 1 } ^ { N } \{ \ln p ( x _ { n } | z _ { n } ) + \ln p ( z _ { n } ) \}
$$

where the nth row of the matrix Z is given by Zn. We already know that the exact maximum likelihood solution for JL is given by the sample mean x defined by (12.1), and it is convenient to substitute for JL at this stage. Making use of the expressions (12.31) and (12.32) for the latent and conditional distributions, respectively, and taking the expectation with respect to the posterior distribution over the latent variables, we obtain

$$
\mathbb { E } [ \ln p \left ( X , Z | \mu , W , \sigma ^ { 2 } \right ) ] & = - \sum _ { n = 1 } ^ { N } \left \{ \frac { D } { 2 } \ln ( 2 \pi \sigma ^ { 2 } ) + \frac { 1 } { 2 } \text {Tr} \left ( \mathbb { E } [ z _ { n } z _ { n } ^ { T } ] \right ) \\ & + \frac { 1 } { 2 \sigma ^ { 2 } } \| x _ { n } - \mu \| ^ { 2 } - \frac { 1 } { \sigma ^ { 2 } } \mathbb { E } [ z _ { n } ] ^ { 1 } W ^ { 1 } ( x _ { n } - \mu ) \\ & + \frac { 1 } { 2 \sigma ^ { 2 } } \text {Tr} \left ( \mathbb { E } [ z _ { n } z _ { n } ^ { T } ] W ^ { T } W \right ) \right \} . \\ \intertext { e t s depend s o n t h e p o r t i o n d i v e r $ d o w h a t h e s t i c t i s }
$$

Note that this depends on the posterior distribution only through the sufficient statistics of the Gaussian. Thus in the E step, we use the old parameter values to evaluate

$$
\begin{array} { r l r } { \mathbb { E } [ z _ { n } ] } & = } & { M ^ { - 1 } W ^ { T } ( x _ { n } - \overline { x } _ { n } ) } \end{array}
$$

$$
\AA ] \ = \ M ^ { - 1 } W ^ { T } ( x _ { n } - \overline { x } )
$$

$$
[ z _ { n } z _ { n } ^ { T } ] \ = \ \sigma ^ { 2 } M ^ { - 1 } + \mathbb { E } [ z _ { n } ] \mathbb { E } [ z _ { n } ] ^ { T }
$$

which follow directly from the posterior distribution (12.42) together with the standard result lE[znz~] = cov[zn] + JE[zn]JE[zn]T. Here M is defined by (12.41).

In the M step, we maximize with respect to Wand (J2, keeping the posterior statistics fixed. Maximization with respect to (T2 is straightforward. For the maximization with respect to W we make use of (C.24), and obtain the M-step equations

$$
W _ { n e w } \, = \, \left [ \sum _ { n = 1 } ^ { N } ( x _ { n } - \overline { x } ) \mathbb { E } [ z _ { n } ] ^ { T } \right ] \left [ \sum _ { n = 1 } ^ { N } \mathbb { E } [ z _ { n } z _ { n } ^ { T } ] \right ] ^ { - 1 } \,
$$

$$
\sigma _ { n e w } ^ { 2 } \, = \, \frac { 1 } { N D } \sum _ { n = 1 } ^ { N } \{ \| x _ { n } - \overline { x } \| ^ { 2 } - 2 \mathbb { E } [ z _ { n } ] ^ { T } W _ { n e w } ^ { T } ( x _ { n } - \overline { x } ) \\ + \text {Tr} \left ( \mathbb { E } [ z _ { n } z _ { n } ^ { T } ] W _ { n e w } ^ { T } W _ { n e w } \right ) \} .
$$

The EM algorithm for probabilistic PCA proceeds by initializing the parameters and then alternately computing the sufficient statistics of the latent space posterior distribution using (12.54) and (12.55) in the E step and revising the parameter values using (12.56) and (12.57) in the M step.

One of the benefits of the EM algorithm for PCA is computational efficiency for large-scale applications (Roweis, 1998). Unlike conventional PCA based on an eigenvector decomposition of the sample covariance matrix, the EM approach is iterative and so might appear to be less attractive. However, each cycle of the EM algorithm can be computationally much more efficient than conventional PCA in spaces of high dimensionality. To see this, we note that the eigendecomposition of the covariance matrix requires O(D 3 ) computation. Often we are interested only in the first M eigenvectors and their corresponding eigenvalues, in which case we can use algorithms that are 0 (M D 2 ). However, the evaluation of the covariance matrix itself takes 0 (ND 2 ) computations, where N is the number of data points. Algorithms such as the snapshot method (Sirovich, 1987), which assume that the eigenvectors are linear combinations of the data vectors, avoid direct evaluation of the covariance matrix but are O(N 3 ) and hence unsuited to large data sets. The EM algorithm described here also does not construct the covariance matrix explicitly. Instead, the most computationally demanding steps are those involving sums over the data set that are 0 (NDM). For large D, and M « D, this can be a significant saving compared to 0 (ND 2 ) and can offset the iterative nature of the EM algorithm.
