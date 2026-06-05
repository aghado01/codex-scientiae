[Page 317]

# Exercise 6.11

# Exercise 6.12

omitted. We can see that this is a valid kernel by expanding the square

$$
\| x - x ^ { \prime } \| ^ { 2 } = x ^ { \top } x + ( x ^ { \prime } ) ^ { \top } x ^ { \prime } - 2 x ^ { \top } x ^ { \prime }
$$

to give

$$
l o g v e & & k ( x , x ^ { \prime } ) = \exp \left ( - x ^ { T } x / 2 \sigma ^ { 2 } \right ) \exp \left ( x ^ { T } x ^ { \prime } / 2 \sigma ^ { 2 } \right ) \exp \left ( - ( x ^ { \prime } ) ^ { T } x ^ { \prime } / 2 \sigma ^ { 2 } \right ) \\ & & \text {and then making use of } ( 6 . 1 4 ) \text { and } ( 6 . 1 6 ) , \text { together with the validity of the linear } \\ \text {kernel} k ( x , x ^ { \prime } ) & = x ^ { T } x ^ { \prime } , \text { Note that the feature vector that corresponds to the Gaussian }
$$

and then making use of (6.14) and (6.16), together with the validity of the linear kernel k ( x , x ) = x T x . Note that the feature vector that corresponds to the Gaussian kernel has inﬁnite dimensionality.

The Gaussian kernel is not restricted to the use of Euclidean distance. If we use kernel substitution in (6.24) to replace x T x with a nonlinear kernel κ ( x , x ) , we obtain

$$
\text {obtain} \\ k ( x , x ^ { \prime } ) & = \exp \left \{ - \frac { 1 } { 2 \sigma ^ { 2 } } \left ( \kappa ( x , x ) + \kappa ( x ^ { \prime } , x ^ { \prime } ) - 2 \kappa ( x , x ^ { \prime } ) \right ) \right \} . \\ \\ \text {An important contribution to arise from the kernel viewpoint has been the extent-}
$$

An important contribution to arise from the kernel viewpoint has been the extension to inputs that are symbolic, rather than simply vectors of real numbers. Kernel functions can be deﬁned over objects as diverse as graphs, sets, strings, and text documents. Consider, for instance, a ﬁxed set and deﬁne a nonvectorial space consisting of all possible subsets of this set. If A 1 and A 2 are two such subsets then one simple choice of kernel would be

$$
k ( A _ { 1 } , A _ { 2 } ) = 2 ^ { | A _ { 1 } \cap A _ { 2 } | }
$$

where A 1 ∩ A 2 denotes the intersection of sets A 1 and A 2 , and | A | denotes the number of subsets in A . This is a valid kernel function because it can be shown to correspond to an inner product in a feature space.

One powerful approach to the construction of kernels starts from a probabilistic generative model (Haussler, 1999), which allows us to apply generative models in a discriminative setting. Generative models can deal naturally with missing data and in the case of hidden Markov models can handle sequences of varying length. By contrast, discriminative models generally give better performance on discriminative tasks than generative models. It is therefore of some interest to combine these two approaches (Lasserre et al. , 2006). One way to combine them is to use a generative model to deﬁne a kernel, and then use this kernel in a discriminative approach.

Given a generative model p ( x ) we can deﬁne a kernel by

$$
k ( x , x ^ { \prime } ) = p ( x ) p ( x ^ { \prime } ) .
$$

This is clearly a valid kernel function because we can interpret it as an inner product in the one-dimensional feature space deﬁned by the mapping p ( x ) . It says that two inputs x and x are similar if they both have high probabilities. We can use (6.13) and (6.17) to extend this class of kernels by considering sums over products of different probability distributions, with positive weighting coefﬁcients p ( i ) , of the form

$$
k ( x , x ^ { \prime } ) = \sum _ { i } p ( x | i ) p ( x ^ { \prime } | i ) p ( i ) .
$$
