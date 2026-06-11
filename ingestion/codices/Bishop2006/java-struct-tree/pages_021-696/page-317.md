[Page 317]

omitted. We can see that this is a valid kernel by expanding the square

�x − x��2 = xTx + (x�)Tx� − 2xTx� (6.24) to give

�−xTx/2σ2

�

�

�

�−(x�)Tx�/2σ2

�

k(x,x�) = exp

exp

exp

xTx�/σ2

(6.25)

and then making use of (6.14) and (6.16), together with the validity of the linear kernel k(x,x�) = xTx�. Note that the feature vector that corresponds to the Gaussian

Exercise 6.11 kernel has inﬁnite dimensionality.

The Gaussian kernel is not restricted to the use of Euclidean distance. If we use kernel substitution in (6.24) to replace xTx� with a nonlinear kernel κ(x,x�), we obtain

k(x,x�) = exp�−

(κ(x,x) + κ(x�,x�) − 2κ(x,x�))�. (6.26)

1 2σ2

An important contribution to arise from the kernel viewpoint has been the extension to inputs that are symbolic, rather than simply vectors of real numbers. Kernel functions can be deﬁned over objects as diverse as graphs, sets, strings, and text documents. Consider, for instance, a ﬁxed set and deﬁne a nonvectorial space consisting of all possible subsets of this set. If A1 and A2 are two such subsets then one simple choice of kernel would be

k(A1,A2) = 2|A1∩A2| (6.27)

where A1 ∩ A2 denotes the intersection of sets A1 and A2, and |A| denotes the number of subsets in A. This is a valid kernel function because it can be shown to

Exercise 6.12 correspond to an inner product in a feature space.

One powerful approach to the construction of kernels starts from a probabilistic generative model (Haussler, 1999), which allows us to apply generative models in a discriminative setting. Generative models can deal naturally with missing data and in the case of hidden Markov models can handle sequences of varying length. By contrast, discriminative models generally give better performance on discriminative tasks than generative models. It is therefore of some interest to combine these two approaches (Lasserre et al., 2006). One way to combine them is to use a generative model to deﬁne a kernel, and then use this kernel in a discriminative approach.

Given a generative model p(x) we can deﬁne a kernel by

k(x,x�) = p(x)p(x�). (6.28)

This is clearly a valid kernel function because we can interpret it as an inner product in the one-dimensional feature space deﬁned by the mapping p(x). It says that two inputs x and x� are similar if they both have high probabilities. We can use (6.13) and (6.17) to extend this class of kernels by considering sums over products of different probability distributions, with positive weighting coefﬁcients p(i), of the form

�

k(x,x�) =

p(x|i)p(x�|i)p(i). (6.29)

i
