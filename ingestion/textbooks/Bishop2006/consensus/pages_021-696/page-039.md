[Page 39]

that the probability of $\mathbf{x}$ falling in an inﬁnitesimal volume $\delta\mathbf{x}$ containing the point $\mathbf{x}$ is given by $p(\mathbf{x})\delta\mathbf{x}$. This multivariate probability density must satisfy
$$
\begin{align}
p(\mathbf{x}) &\geq 0 \tag{1.29} \\
\int p(\mathbf{x}) \, d\mathbf{x} &= 1 \tag{1.30}
\end{align}
$$
in which the integral is taken over the whole of $\mathbf{x}$ space. We can also consider joint probability distributions over a combination of discrete and continuous variables.

Note that if $x$ is a discrete variable, then $p(x)$ is sometimes called a probability mass function because it can be regarded as a set of ‘probability masses’ concentrated at the allowed values of $x$.

The sum and product rules of probability, as well as Bayes’ theorem, apply equally to the case of probability densities, or to combinations of discrete and continuous variables. For instance, if $x$ and $y$ are two real variables, then the sum and product rules take the form
$$
\begin{align}
p(x) &= \int p(x,y) \, dy \tag{1.31} \\
p(x,y) &= p(y|x)p(x). \tag{1.32}
\end{align}
$$

A formal justiﬁcation of the sum and product rules for continuous variables (Feller, 1966) requires a branch of mathematics called measure theory and lies outside the scope of this book. Its validity can be seen informally, however, by dividing each real variable into intervals of width $\Delta$ and considering the discrete probability distribution over these intervals. Taking the limit $\Delta \to 0$ then turns sums into integrals and gives the desired result.

### 1.2.2 Expectations and covariances

One of the most important operations involving probabilities is that of ﬁnding weighted averages of functions. The average value of some function $f(x)$ under a probability distribution $p(x)$ is called the expectation of $f(x)$ and will be denoted by $\mathbb{E}[f]$. For a discrete distribution, it is given by
$$
\mathbb{E}[f] = \sum_{x} p(x)f(x) \tag{1.33}
$$
so that the average is weighted by the relative probabilities of the different values of $x$. In the case of continuous variables, expectations are expressed in terms of an integration with respect to the corresponding probability density
$$
\mathbb{E}[f] = \int p(x)f(x) \, dx. \tag{1.34}
$$

In either case, if we are given a ﬁnite number $N$ of points drawn from the probability distribution or probability density, then the expectation can be approximated as a
