[Page 234]

over the parameter vector $\mathbf{w}$ since the posterior distribution is no longer Gaussian. It is therefore necessary to introduce some form of approximation. Later in the book we shall consider a range of techniques based on analytical approximations and numerical sampling. Here we introduce a simple, but widely used, framework called the Laplace approximation, that aims to find a Gaussian approximation to a probability density defined over a set of continuous variables. Consider first the case of a single continuous variable $z$, and suppose the distribution $p(z)$ is defined by

$$
p(z) = \frac{1}{Z} f(z)
\tag{4.125}
$$

where $Z = \int f(z) \, dz$ is the normalization coefficient. We shall suppose that the value of $Z$ is unknown. In the Laplace method the goal is to find a Gaussian approximation $q(z)$ which is centred on a mode of the distribution $p(z)$. The first step is to find a mode of $p(z)$, in other words a point $z_0$ such that $p'(z_0) = 0$, or equivalently

$$
\frac{d f(z)}{d z} \bigg|_{z=z_0} = 0.
\tag{4.126}
$$

A Gaussian distribution has the property that its logarithm is a quadratic function of the variables. We therefore consider a Taylor expansion of $\ln f(z)$ centred on the mode $z_0$ so that

$$
\ln f(z) \simeq \ln f(z_0) - \frac{1}{2} A(z - z_0)^2
\tag{4.127}
$$

where

$$
A = - \frac{d^2}{d z^2} \ln f(z) \bigg|_{z=z_0} .
\tag{4.128}
$$

Note that the first-order term in the Taylor expansion does not appear since $z_0$ is a local maximum of the distribution. Taking the exponential we obtain

$$
f(z) \simeq f(z_0) \exp \left\{ - \frac{A}{2} (z - z_0)^2 \right\} .
\tag{4.129}
$$

We can then obtain a normalized distribution $q(z)$ by making use of the standard result for the normalization of a Gaussian, so that

$$
q(z) = \left( \frac{A}{2\pi} \right)^{1/2} \exp \left\{ - \frac{A}{2} (z - z_0)^2 \right\} .
\tag{4.130}
$$

The Laplace approximation is illustrated in Figure 4.14. Note that the Gaussian approximation will only be well defined if its precision $A > 0$, in other words the stationary point $z_0$ must be a local maximum, so that the second derivative of $f(z)$ at the point $z_0$ is negative.
