[Page 390]

# 8.1.4 Linear-Gaussian models

In the previous section, we saw how to construct joint probability distributions over a set of discrete variables by expressing the variables as nodes in a directed acyclic graph. Here we show how a multivariate Gaussian can be expressed as a directed graph corresponding to a linear-Gaussian model over the component variables. This allows us to impose interesting structure on the distribution, with the general Gaussian and the diagonal covariance Gaussian representing opposite extremes. Several widely used techniques are examples of linear-Gaussian models, such as probabilistic principal component analysis, factor analysis, and linear dynamical systems (Roweis and Ghahramani, 1999). We shall make extensive use of the results of this section in later chapters when we consider some of these techniques in detail.

Consider an arbitrary directed acyclic graph over D variables in which node i represents a single continuous random variable x i having a Gaussian distribution. The mean of this distribution is taken to be a linear combination of the states of its parent nodes pa i of node i

$$
\text {nodes} \, \text {pa} _ { i } \, \text { of node } i \\ p ( x _ { i } | \text {pa} _ { i } ) = \mathcal { N } \left ( x _ { i } \Big | \sum _ { j \in \text {pa} _ { i } } w _ { i j } x _ { j } + b _ { i } , v _ { i } \right ) \\ \intertext { i j } \text { and } b _ { i } \text { are parameters governing the mean, and } v _ { i } \text { is the variance of the } \\ \text {all distribution for } x _ { i } . \text { The log of the joint distribution is then the log of the }
$$

p x i | i N ⎝ x i j ∈ pa i w ij x j b i ,v i ⎠ where w ij and b i are parameters governing the mean, and v i is the variance of the conditional distribution for x i . The log of the joint distribution is then the log of the product of these conditionals over all nodes in the graph and hence takes the form

$$
\ln p ( x ) \ = \ \sum _ { i = 1 } ^ { D } \ln p ( x _ { i } | \text {pa} _ { i } )
$$

$$
& \text {duals over all nodes in the graph and hence tab} \\ & = \sum \ln p ( x _ { i } | \text {pa} _ { i } ) \\ & = \sum _ { i = 1 } ^ { D } \frac { 1 } { 2 v _ { i } } \left ( x _ { i } - \sum _ { j \in \text {pa} _ { i } } w _ { i j } x _ { j } - b _ { i } \right ) ^ { 2 } + \text {co} \\ & , x _ { D } ) ^ { T } \text { and } \L ^ { \text {const} } \text { denotes terms independent of} \\ & \text {function of the components of } x , \text { and hence the join}
$$

$$
& \quad = \ - \sum _ { i = 1 } ^ { D } \frac { 1 } { 2 v _ { i } } \left ( x _ { i } - \sum _ { j \in \mathbb { P } ^ { a _ { i } } } w _ { i j } x _ { j } - b _ { i } \right ) ^ { 2 } + \text {const}
$$

where x = ( x 1 ,...,x D ) T and ‘const’ denotes terms independent of x . We see that this is a quadratic function of the components of x , and hence the joint distribution p ( x ) is a multivariate Gaussian.

We can determine the mean and covariance of the joint distribution recursively as follows. Each variable x i has (conditional on the states of its parents) a Gaussian distribution of the form (8.11) and so

$$
\text {the form (8.11) and so} \\ x _ { i } = \sum _ { j \in \mathbb { P } _ { i } } w _ { i j } x _ { j } + b _ { i } + \sqrt { v _ { i } } \epsilon _ { i } \\ \intertext { t h e m e n , u n i t v a r i v e G u s i s y n o r d o m m a n t i v i g h e r }
$$

where i is a zero mean, unit variance Gaussian random variable satisfying E [ i ] = 0 and E [ i j ] = I ij , where I ij is the i,j element of the identity matrix. Taking the expectation of (8.14), we have

$$
\mathbb { E } [ x _ { i } ] = \sum _ { j \in \text {pa} _ { i } } w _ { i j } \mathbb { E } [ x _ { j } ] + b _ { i } .
$$
