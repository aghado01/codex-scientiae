[Page 40]

finite sum over these points
$$
\mathbb{E}[f] \simeq \frac{1}{N} \sum_{n=1}^{N} f(x_{n}). \tag{1.35}
$$
We shall make extensive use of this result when we discuss sampling methods in Chapter 11. The approximation in (1.35) becomes exact in the limit $N \to \infty$.

Sometimes we will be considering expectations of functions of several variables, in which case we can use a subscript to indicate which variable is being averaged over, so that for instance
$$
\mathbb{E}_{x}[f(x, y)] \tag{1.36}
$$
denotes the average of the function $f(x, y)$ with respect to the distribution of $x$. Note that $\mathbb{E}_{x}[f(x, y)]$ will be a function of $y$.

We can also consider a conditional expectation with respect to a conditional distribution, so that
$$
\mathbb{E}_{x}[f|y] = \sum_{x} p(x|y)f(x) \tag{1.37}
$$
with an analogous definition for continuous variables. The variance of $f(x)$ is defined by
$$
\text{var}[f] = \mathbb{E}\left[ (f(x) - \mathbb{E}[f(x)])^{2} \right] \tag{1.38}
$$
and provides a measure of how much variability there is in $f(x)$ around its mean value $\mathbb{E}[f(x)]$. Expanding out the square, we see that the variance can also be written in terms of the expectations of $f(x)$ and $f(x)^{2}$
$$
\text{var}[f] = \mathbb{E}[f(x)^{2}] - \mathbb{E}[f(x)]^{2}. \tag{1.39}
$$

In particular, we can consider the variance of the variable $x$ itself, which is given by
$$
\text{var}[x] = \mathbb{E}[x^{2}] - \mathbb{E}[x]^{2}. \tag{1.40}
$$
For two random variables $x$ and $y$, the covariance is defined by
$$
\begin{aligned}
\text{cov}[x, y] &= \mathbb{E}_{x,y}[\{x - \mathbb{E}[x]\}\{y - \mathbb{E}[y]\}] \\
&= \mathbb{E}_{x,y}[xy] - \mathbb{E}[x]\mathbb{E}[y]
\end{aligned} \tag{1.41}
$$
which expresses the extent to which $x$ and $y$ vary together. If $x$ and $y$ are independent, then their covariance vanishes.

In the case of two vectors of random variables $\mathbf{x}$ and $\mathbf{y}$, the covariance is a matrix
$$
\begin{aligned}
\text{cov}[\mathbf{x}, \mathbf{y}] &= \mathbb{E}_{\mathbf{x},\mathbf{y}}[\{\mathbf{x} - \mathbb{E}[\mathbf{x}]\}\{\mathbf{y}^{\text{T}} - \mathbb{E}[\mathbf{y}^{\text{T}}]\}] \\
&= \mathbb{E}_{\mathbf{x},\mathbf{y}}[\mathbf{x}\mathbf{y}^{\text{T}}] - \mathbb{E}[\mathbf{x}]\mathbb{E}[\mathbf{y}^{\text{T}}].
\end{aligned} \tag{1.42}
$$
If we consider the covariance of the components of a vector $\mathbf{x}$ with each other, then we use a slightly simpler notation $\text{cov}[\mathbf{x}] \equiv \text{cov}[\mathbf{x}, \mathbf{x}]$.
