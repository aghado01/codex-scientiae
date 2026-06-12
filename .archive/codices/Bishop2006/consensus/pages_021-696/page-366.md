[Page 366]

where $\beta = \sigma^{-2}$ is the noise precision (inverse noise variance), and the mean is given by a linear model of the form

$$
y(\mathbf{x}) = \sum_{i=1}^M w_i\phi_i(\mathbf{x}) = \mathbf{w}^T\boldsymbol{\phi}(\mathbf{x}) \tag{7.77}
$$

with ﬁxed nonlinear basis functions $\phi_i(\mathbf{x})$, which will typically include a constant term so that the corresponding weight parameter represents a ‘bias’.

The relevance vector machine is a speciﬁc instance of this model, which is intended to mirror the structure of the support vector machine. In particular, the basis functions are given by kernels, with one kernel associated with each of the data points from the training set. The general expression (7.77) then takes the SVM-like form

$$
y(\mathbf{x}) = \sum_{n=1}^N w_nk(\mathbf{x}, \mathbf{x}_n) + b \tag{7.78}
$$

where $b$ is a bias parameter. The number of parameters in this case is $M = N + 1$, and $y(\mathbf{x})$ has the same form as the predictive model (7.64) for the SVM, except that the coefﬁcients $a_n$ are here denoted $w_n$. It should be emphasized that the subsequent analysis is valid for arbitrary choices of basis function, and for generality we shall work with the form (7.77). In contrast to the SVM, there is no restriction to positivedeﬁnite kernels, nor are the basis functions tied in either number or location to the training data points.

Suppose we are given a set of $N$ observations of the input vector $\mathbf{x}$, which we denote collectively by a data matrix $\mathbf{X}$ whose $n^{\text{th}}$ row is $\mathbf{x}_n^T$ with $n = 1, \ldots, N$. The corresponding target values are given by $\mathbf{t} = (t_1, \ldots, t_N)^T$. Thus, the likelihood function is given by

$$
p(\mathbf{t}|\mathbf{X}, \mathbf{w}, \beta) = \prod_{n=1}^N p(t_n|\mathbf{x}_n, \mathbf{w}, \beta^{-1}). \tag{7.79}
$$

Next we introduce a prior distribution over the parameter vector $\mathbf{w}$ and as in Chapter 3, we shall consider a zero-mean Gaussian prior. However, the key difference in the RVM is that we introduce a separate hyperparameter $\alpha_i$ for each of the weight parameters $w_i$ instead of a single shared hyperparameter. Thus the weight prior takes the form

$$
p(\mathbf{w}|\boldsymbol{\alpha}) = \prod_{i=1}^M \mathcal{N}(w_i|0, \alpha_i^{-1}) \tag{7.80}
$$

where $\alpha_i$ represents the precision of the corresponding parameter $w_i$, and $\boldsymbol{\alpha}$ denotes $(\alpha_1, \ldots, \alpha_M)^T$. We shall see that, when we maximize the evidence with respect to these hyperparameters, a signiﬁcant proportion of them go to inﬁnity, and the corresponding weight parameters have posterior distributions that are concentrated at zero. The basis functions associated with these parameters therefore play no role
