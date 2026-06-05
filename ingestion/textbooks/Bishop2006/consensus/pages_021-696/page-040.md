[Page 40]

ﬁnite sum over these points

$$
\mathbb{E}[f] \simeq \frac{1}{N} \sum_{n=1}^{N} f(x_n). \tag{1.35}
$$

We shall make extensive use of this result when we discuss sampling methods in Chapter 11. The approximation in (1.35) becomes exact in the limit $N \to \infty$.

Sometimes we will be considering expectations of functions of several variables, in which case we can use a subscript to indicate which variable is being averaged over, so that for instance

$$
\mathbb{E}_x[f(x,y)] \tag{1.36}
$$

denotes the average of the function $f(x,y)$ with respect to the distribution of $x$. Note that $\mathbb{E}_x[f(x,y)]$ will be a function of $y$.

We can also consider a conditional expectation with respect to a conditional distribution, so that

$$
\mathbb{E}_x[f \mid y] = \sum_x p(x \mid y)f(x). \tag{1.37}
$$

with an analogous deﬁnition for continuous variables. The variance of f(x) is deﬁned by

$$
\operatorname{var}[f] = \mathbb{E}\left[(f(x) - \mathbb{E}[f(x)])^2\right]. \tag{1.38}
$$

and provides a measure of how much variability there is in $f(x)$ around its mean value $\mathbb{E}[f(x)]$. Expanding out the square, we see that the variance can also be written

in terms of the expectations of $f(x)$ and $f(x)^2$

$$
\operatorname{var}[f] = \mathbb{E}[f(x)^2] - \mathbb{E}[f(x)]^2. \tag{1.39}
$$

In particular, we can consider the variance of the variable x itself, which is given by

$$
\operatorname{var}[x] = \mathbb{E}[x^2] - \mathbb{E}[x]^2. \tag{1.40}
$$

For two random variables $x$ and $y$, the covariance is deﬁned by

$$
\operatorname{cov}[x,y] = \mathbb{E}_{x,y}[\{x - \mathbb{E}[x]\}\{y - \mathbb{E}[y]\}] = \mathbb{E}_{x,y}[xy] - \mathbb{E}[x]\mathbb{E}[y]. \tag{1.41}
$$

which expresses the extent to which $x$ and $y$ vary together. If $x$ and $y$ are independent, then their covariance vanishes. In the case of two vectors of random variables $x$ and $y$, the covariance is a matrix

$$
\operatorname{cov}[x,y] = \mathbb{E}_{x,y}[\{x - \mathbb{E}[x]\}\{y^{T} - \mathbb{E}[y^{T}]\}] = \mathbb{E}_{x,y}[xy^{T}] - \mathbb{E}[x]\mathbb{E}[y^{T}]. \tag{1.42}
$$

If we consider the covariance of the components of a vector $x$ with each other, then we use a slightly simpler notation $\operatorname{cov}[x] \equiv \operatorname{cov}[x,x]$.
