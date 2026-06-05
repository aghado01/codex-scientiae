[Page 51]

In the curve ﬁtting problem, we are given the training data $\mathbf{x}$ and $\mathbf{t}$, along with a new test point $x$, and our goal is to predict the value of $t$. We therefore wish to evaluate the predictive distribution $p(t \mid x, \mathbf{x}, \mathbf{t})$. Here we shall assume that the parameters $\alpha$ and $\beta$ are ﬁxed and known in advance (in later chapters we shall discuss how such parameters can be inferred from data in a Bayesian setting).

A Bayesian treatment simply corresponds to a consistent application of the sum and product rules of probability, which allow the predictive distribution to be written in the form

$$
p(t \mid x, \mathbf{x}, \mathbf{t}) = \int p(t \mid x, \mathbf{w})p(\mathbf{w} \mid \mathbf{x}, \mathbf{t})\,d\mathbf{w}. \tag{1.68}
$$

Here $p(t \mid x, \mathbf{w})$ is given by (1.60), and we have omitted the dependence on $\alpha$ and $\beta$ to simplify the notation. Here $p(\mathbf{w} \mid \mathbf{x}, \mathbf{t})$ is the posterior distribution over parameters, and can be found by normalizing the right-hand side of (1.66). We shall see in Section 3.3 that, for problems such as the curve-ﬁtting example, this posterior distribution is a Gaussian and can be evaluated analytically. Similarly, the integration in (1.68) can also be performed analytically with the result that the predictive distribution is given by a Gaussian of the form

$$
p(t \mid x, \mathbf{x}, \mathbf{t}) = \mathcal{N}(t \mid m(x), s^2(x)). \tag{1.69}
$$

where the mean and variance are given by

$$
m(x) = \beta \phi(x)^{T} S \sum_{n=1}^{N} \phi(x_n)t_n. \tag{1.70}
$$

$$
s^2(x) = \beta^{-1} + \phi(x)^{T} S \phi(x). \tag{1.71}
$$

Here the matrix $S$ is given by

$$
S^{-1} = \alpha I + \beta \sum_{n=1}^{N} \phi(x_n)\phi(x_n)^{T}. \tag{1.72}
$$

where $I$ is the unit matrix, and we have deﬁned the vector $\phi(x)$ with elements $\phi_i(x) = x^i$ for $i = 0, \ldots, M$.

We see that the variance, as well as the mean, of the predictive distribution in (1.69) is dependent on $x$. The ﬁrst term in (1.71) represents the uncertainty in the predicted value of $t$ due to the noise on the target variables and was expressed already in the maximum likelihood predictive distribution (1.64) through $\beta_{\mathrm{ML}}^{-1}$. However, the second term arises from the uncertainty in the parameters $\mathbf{w}$ and is a consequence of the Bayesian treatment. The predictive distribution for the synthetic sinusoidal regression problem is illustrated in Figure 1.17.
