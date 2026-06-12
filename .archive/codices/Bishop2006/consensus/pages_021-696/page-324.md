[Page 324]

tic discriminative models, leading to the framework of Gaussian processes. We shall thereby see how kernels arise naturally in a Bayesian setting.

In Chapter 3, we considered linear regression models of the form $y(\mathbf{x},\mathbf{w}) = \mathbf{w}^T\boldsymbol{\phi}(\mathbf{x})$ in which $\mathbf{w}$ is a vector of parameters and $\boldsymbol{\phi}(\mathbf{x})$ is a vector of ﬁxed nonlinear basis functions that depend on the input vector $\mathbf{x}$. We showed that a prior distribution over $\mathbf{w}$ induced a corresponding prior distribution over functions $y(\mathbf{x},\mathbf{w})$. Given a training data set, we then evaluated the posterior distribution over $\mathbf{w}$ and thereby obtained the corresponding posterior distribution over regression functions, which in turn (with the addition of noise) implies a predictive distribution $p(t|\mathbf{x})$ for new input vectors $\mathbf{x}$.

In the Gaussian process viewpoint, we dispense with the parametric model and instead deﬁne a prior probability distribution over functions directly. At ﬁrst sight, it might seem difﬁcult to work with a distribution over the uncountably inﬁnite space of functions. However, as we shall see, for a ﬁnite training set we only need to consider the values of the function at the discrete set of input values $\mathbf{x}_n$ corresponding to the training set and test set data points, and so in practice we can work in a ﬁnite space.

Models equivalent to Gaussian processes have been widely studied in many different ﬁelds. For instance, in the geostatistics literature Gaussian process regression is known as kriging (Cressie, 1993). Similarly, ARMA (autoregressive moving average) models, Kalman ﬁlters, and radial basis function networks can all be viewed as forms of Gaussian process models. Reviews of Gaussian processes from a machine learning perspective can be found in MacKay (1998), Williams (1999), and MacKay (2003), and a comparison of Gaussian process models with alternative approaches is given in Rasmussen (1996). See also Rasmussen and Williams (2006) for a recent textbook on Gaussian processes.

###### 6.4.1 Linear regression revisited

In order to motivate the Gaussian process viewpoint, let us return to the linear regression example and re-derive the predictive distribution by working in terms of distributions over functions $y(\mathbf{x},\mathbf{w})$. This will provide a speciﬁc example of a Gaussian process.

Consider a model deﬁned in terms of a linear combination of $M$ ﬁxed basis functions given by the elements of the vector $\boldsymbol{\phi}(\mathbf{x})$ so that

$$
y(\mathbf{x}) = \mathbf{w}^T\boldsymbol{\phi}(\mathbf{x}) \tag{6.49}
$$

where $\mathbf{x}$ is the input vector and $\mathbf{w}$ is the $M$-dimensional weight vector. Now consider a prior distribution over $\mathbf{w}$ given by an isotropic Gaussian of the form

$$
p(\mathbf{w}) = \mathcal{N}(\mathbf{w}|\mathbf{0},\alpha^{-1}\mathbf{I}) \tag{6.50}
$$

governed by the hyperparameter $\alpha$, which represents the precision (inverse variance) of the distribution. For any given value of $\mathbf{w}$, the deﬁnition (6.49) deﬁnes a particular function of $\mathbf{x}$. The probability distribution over $\mathbf{w}$ deﬁned by (6.50) therefore induces a probability distribution over functions $y(\mathbf{x})$. In practice, we wish to evaluate this function at speciﬁc values of $\mathbf{x}$, for example at the training data points
