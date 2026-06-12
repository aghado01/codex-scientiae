[Page 160]

![The image consists of a graph with three different lines. The graph has a blue background with a white grid. The lines are depicted as curves, each with different colors. The lines are connected by a series of points, which are represented by the x-axis and the y-axis. The x-axis is labeled with the values 0, 1, and 2, while the y-axis is labeled with the values 0, 1, and 2, respectively. The lines in the graph are: - The first line is blue and has a value of 0.5. - The second line is green and has a value of 0.5. - The third line is red and has a value of 0.5. The graph is labeled as follows: - The first line is labeled as 0.5 - The second line is labeled as 0.5 - The third line is](../images/imageFile73.png)

Figure 3.1 Examples of basis functions, showing polynomials on the left, Gaussians of the form (3.4) in the centre, and sigmoidal of the form (3.5) on the right.

on a regular lattice, such as the successive time points in a temporal sequence, or the pixels in an image. Useful texts on wavelets include Ogden (1997), Mallat (1999), and Vidakovic (1999).

Most of the discussion in this chapter, however, is independent of the particular choice of basis function set, and so for most of our discussion we shall not specify the particular form of the basis functions, except for the purposes of numerical illustration. Indeed, much of our discussion will be equally applicable to the situation in which the vector $\boldsymbol{\phi}(\mathbf{x})$ of basis functions is simply the identity $\boldsymbol{\phi}(\mathbf{x}) = \mathbf{x}$. Furthermore, in order to keep the notation simple, we shall focus on the case of a single target variable $t$. However, in Section 3.1.5, we consider briefly the modifications needed to deal with multiple target variables.

### 3.1.1 Maximum likelihood and least squares

In Chapter 1, we fitted polynomial functions to data sets by minimizing a sum-of-squares error function. We also showed that this error function could be motivated as the maximum likelihood solution under an assumed Gaussian noise model. Let us return to this discussion and consider the least squares approach, and its relation to maximum likelihood, in more detail.

As before, we assume that the target variable $t$ is given by a deterministic function $y(\mathbf{x}, \mathbf{w})$ with additive Gaussian noise so that

$$
t = y(\mathbf{x}, \mathbf{w}) + \epsilon \tag{3.7}
$$

where $\epsilon$ is a zero mean Gaussian random variable with precision (inverse variance) $\beta$. Thus we can write

$$
p(t|\mathbf{x}, \mathbf{w}, \beta) = \mathcal{N}(t|y(\mathbf{x}, \mathbf{w}), \beta^{-1}). \tag{3.8}
$$

Recall that, if we assume a squared loss function, then the optimal prediction, for a new value of $\mathbf{x}$, will be given by the conditional mean of the target variable. In the case of a Gaussian conditional distribution of the form (3.8), the conditional mean
