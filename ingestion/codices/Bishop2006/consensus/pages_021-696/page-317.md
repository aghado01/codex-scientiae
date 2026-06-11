[Page 317]

omitted. We can see that this is a valid kernel by expanding the square

$$
\|\mathbf{x} - \mathbf{x}'\|^2 = \mathbf{x}^T\mathbf{x} + (\mathbf{x}')^T\mathbf{x}' - 2\mathbf{x}^T\mathbf{x}' \tag{6.24}
$$

to give

$$
k(\mathbf{x},\mathbf{x}') = \exp \left(-\frac{\mathbf{x}^T\mathbf{x}}{2\sigma^2}\right) \exp \left(\frac{\mathbf{x}^T\mathbf{x}'}{\sigma^2}\right) \exp \left(-\frac{(\mathbf{x}')^T\mathbf{x}'}{2\sigma^2}\right) \tag{6.25}
$$

and then making use of (6.14) and (6.16), together with the validity of the linear kernel $k(\mathbf{x},\mathbf{x}') = \mathbf{x}^T\mathbf{x}'$. Note that the feature vector that corresponds to the Gaussian kernel has inﬁnite dimensionality. 

The Gaussian kernel is not restricted to the use of Euclidean distance. If we use kernel substitution in (6.24) to replace $\mathbf{x}^T\mathbf{x}'$ with a nonlinear kernel $\kappa(\mathbf{x},\mathbf{x}')$, we obtain

$$
k(\mathbf{x},\mathbf{x}') = \exp \left\{ -\frac{1}{2\sigma^2} (\kappa(\mathbf{x},\mathbf{x}) + \kappa(\mathbf{x}',\mathbf{x}') - 2\kappa(\mathbf{x},\mathbf{x}')) \right\}. \tag{6.26}
$$

An important contribution to arise from the kernel viewpoint has been the extension to inputs that are symbolic, rather than simply vectors of real numbers. Kernel functions can be deﬁned over objects as diverse as graphs, sets, strings, and text documents. Consider, for instance, a ﬁxed set and deﬁne a nonvectorial space consisting of all possible subsets of this set. If $A_1$ and $A_2$ are two such subsets then one simple choice of kernel would be

$$
k(A_1,A_2) = 2^{|A_1 \cap A_2|} \tag{6.27}
$$

where $A_1 \cap A_2$ denotes the intersection of sets $A_1$ and $A_2$, and $|A|$ denotes the number of subsets in $A$. This is a valid kernel function because it can be shown to correspond to an inner product in a feature space.

One powerful approach to the construction of kernels starts from a probabilistic generative model (Haussler, 1999), which allows us to apply generative models in a discriminative setting. Generative models can deal naturally with missing data and in the case of hidden Markov models can handle sequences of varying length. By contrast, discriminative models generally give better performance on discriminative tasks than generative models. It is therefore of some interest to combine these two approaches (Lasserre et al., 2006). One way to combine them is to use a generative model to deﬁne a kernel, and then use this kernel in a discriminative approach.

Given a generative model $p(\mathbf{x})$ we can deﬁne a kernel by

$$
k(\mathbf{x},\mathbf{x}') = p(\mathbf{x})p(\mathbf{x}'). \tag{6.28}
$$

This is clearly a valid kernel function because we can interpret it as an inner product in the one-dimensional feature space deﬁned by the mapping $p(\mathbf{x})$. It says that two inputs $\mathbf{x}$ and $\mathbf{x}'$ are similar if they both have high probabilities. We can use (6.13) and (6.17) to extend this class of kernels by considering sums over products of different probability distributions, with positive weighting coefﬁcients $p(i)$, of the form

$$
k(\mathbf{x},\mathbf{x}') = \sum_i p(\mathbf{x}|i)p(\mathbf{x}'|i)p(i). \tag{6.29}
$$
