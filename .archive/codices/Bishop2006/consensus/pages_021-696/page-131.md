[Page 131]

![The image consists of a graph with two lines. The graph is titled p(x), which is a function of x. The graph is represented by two lines, one blue line and the other red line. The blue line is labeled as p(x), and the red line is labeled as p(x). The graph is titled p(x), which means that the graph is a function of x. The graph is a line, and it is defined by the equation: p(x) = x^2 This means that the graph of the function p(x) is a square function. The graph is symmetric about the x-axis, and it is symmetric about the y-axis. The graph is also symmetric about the y-axis, and it is symmetric about the x-axis. This means that the graph of the function p(x) is the same for each pair of points on the graph.](../images/imageFile65.png)

Figure 2.22 Example of a Gaussian mixture distribution in one dimension showing three Gaussians (each scaled by a coefficient) in blue and their sum in red.

the eruption in minutes (horizontal axis) and the time in minutes to the next eruption (vertical axis). We see that the data set forms two dominant clumps, and that a simple Gaussian distribution is unable to capture this structure, whereas a linear superposition of two Gaussians gives a better characterization of the data set.

Such superpositions, formed by taking linear combinations of more basic distributions such as Gaussians, can be formulated as probabilistic models known as mixture distributions (McLachlan and Basford, 1988; McLachlan and Peel, 2000). In Figure 2.22 we see that a linear combination of Gaussians can give rise to very complex densities. By using a sufficient number of Gaussians, and by adjusting their means and covariances as well as the coefficients in the linear combination, almost any continuous density can be approximated to arbitrary accuracy.

We therefore consider a superposition of $K$ Gaussian densities of the form

$$
p(\mathbf{x}) = \sum_{k=1}^K \pi_k \mathcal{N}(\mathbf{x}|\boldsymbol{\mu}_k, \boldsymbol{\Sigma}_k) \tag{2.188}
$$

which is called a mixture of Gaussians. Each Gaussian density $\mathcal{N}(\mathbf{x}|\boldsymbol{\mu}_k, \boldsymbol{\Sigma}_k)$ is called a component of the mixture and has its own mean $\boldsymbol{\mu}_k$ and covariance $\boldsymbol{\Sigma}_k$. Contour and surface plots for a Gaussian mixture having 3 components are shown in Figure 2.23.

In this section we shall consider Gaussian components to illustrate the framework of mixture models. More generally, mixture models can comprise linear combinations of other distributions. For instance, in Section 9.3.3 we shall consider mixtures of Bernoulli distributions as an example of a mixture model for discrete variables.

The parameters $\pi_k$ in (2.188) are called mixing coefficients. If we integrate both sides of (2.188) with respect to $\mathbf{x}$, and note that both $p(\mathbf{x})$ and the individual Gaussian components are normalized, we obtain

$$
\sum_{k=1}^K \pi_k = 1. \tag{2.189}
$$

Also, the requirement that $p(\mathbf{x}) \ge 0$, together with $\mathcal{N}(\mathbf{x}|\boldsymbol{\mu}_k, \boldsymbol{\Sigma}_k) \ge 0$, implies $\pi_k \ge 0$ for all $k$. Combining this with the condition (2.189) we obtain

$$
0 \le \pi_k \le 1. \tag{2.190}
$$
