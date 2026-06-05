[Page 390]

8.1.4 Linear-Gaussian models

In the previous section, we saw how to construct joint probability distributions over a set of discrete variables by expressing the variables as nodes in a directed acyclic graph. Here we show how a multivariate Gaussian can be expressed as a directed graph corresponding to a linear-Gaussian model over the component variables. This allows us to impose interesting structure on the distribution, with the general Gaussian and the diagonal covariance Gaussian representing opposite extremes. Several widely used techniques are examples of linear-Gaussian models, such as probabilistic principal component analysis, factor analysis, and linear dynamical systems (Roweis and Ghahramani, 1999). We shall make extensive use of the results of this section in later chapters when we consider some of these techniques in detail.

Consider an arbitrary directed acyclic graph over D variables in which node i

represents a single continuous random variable xi having a Gaussian distribution. The mean of this distribution is taken to be a linear combination of the states of its

parent nodes pai of node i

� � � � � �

⎛ ⎝xi

⎞ ⎠ (8.11)

�

p(xi|pai) = N

wijxj + bi,vi

j∈pai

where wij and bi are parameters governing the mean, and vi is the variance of the conditional distribution for xi. The log of the joint distribution is then the log of the product of these conditionals over all nodes in the graph and hence takes the form

�D

lnp(x) =

lnp(xi|pai) (8.12)

i=1

⎛ ⎝xi − �

⎞ ⎠

2

�D

1 2vi

= −

+ const (8.13)

wijxj − bi

j∈pai

i=1

where x = (x1,...,xD)T and ‘const’ denotes terms independent of x. We see that this is a quadratic function of the components of x, and hence the joint distribution p(x) is a multivariate Gaussian.

We can determine the mean and covariance of the joint distribution recursively

as follows. Each variable xi has (conditional on the states of its parents) a Gaussian distribution of the form (8.11) and so

�

wijxj + bi + √vi�i (8.14)

xi =

j∈pai

where �i is a zero mean, unit variance Gaussian random variable satisfying E[�i] = 0 and E[�i�j] = Iij, where Iij is the i,j element of the identity matrix. Taking the expectation of (8.14), we have

�

E[xi] =

wijE[xj] + bi. (8.15)

j∈pai
