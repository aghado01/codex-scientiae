[Page 80]

1.12 ($\star$) www Using the results (1.49) and (1.50), show that

$$
\mathbb{E}[x_n x_m] = \mu^2 + I_{nm}\sigma^2 \tag{1.130}
$$

where $x_n$ and $x_m$ denote data points sampled from a Gaussian distribution with mean $\mu$ and variance $\sigma^2$, and $I_{nm}$ satisﬁes $I_{nm} = 1$ if $n = m$ and $I_{nm} = 0$ otherwise. Hence prove the results (1.57) and (1.58).

1.13 ($\star$) Suppose that the variance of a Gaussian is estimated using the result (1.56) but with the maximum likelihood estimate $\mu_{\text{ML}}$ replaced with the true value $\mu$ of the mean. Show that this estimator has the property that its expectation is given by the true variance $\sigma^2$.

1.14 ($\star\star$) Show that an arbitrary square matrix with elements $w_{ij}$ can be written in the form $w_{ij} = w_{ij}^S + w_{ij}^A$ where $w_{ij}^S$ and $w_{ij}^A$ are symmetric and anti-symmetric matrices, respectively, satisfying $w_{ij}^S = w_{ji}^S$ and $w_{ij}^A = -w_{ji}^A$ for all $i$ and $j$. Now consider the second order term in a higher order polynomial in $D$ dimensions, given by

$$
\sum_{i=1}^D \sum_{j=1}^D w_{ij}x_ix_j. \tag{1.131}
$$

Show that

$$
\sum_{i=1}^D \sum_{j=1}^D w_{ij}x_ix_j = \sum_{i=1}^D \sum_{j=1}^D w_{ij}^S x_ix_j \tag{1.132}
$$

so that the contribution from the anti-symmetric matrix vanishes. We therefore see that, without loss of generality, the matrix of coefﬁcients $w_{ij}$ can be chosen to be symmetric, and so not all of the $D^2$ elements of this matrix can be chosen independently. Show that the number of independent parameters in the matrix $w_{ij}^S$ is given by $D(D + 1)/2$.

1.15 ($\star\star$) www In this exercise and the next, we explore how the number of independent parameters in a polynomial grows with the order $M$ of the polynomial and with the dimensionality $D$ of the input space. We start by writing down the $M^{\text{th}}$ order term for a polynomial in $D$ dimensions in the form

$$
\sum_{i_1=1}^D \sum_{i_2=1}^D \cdots \sum_{i_M=1}^D w_{i_1 i_2 \cdots i_M} x_{i_1} x_{i_2} \cdots x_{i_M}. \tag{1.133}
$$

The coefﬁcients $w_{i_1 i_2 \cdots i_M}$ comprise $D^M$ elements, but the number of independent parameters is signiﬁcantly fewer due to the many interchange symmetries of the factor $x_{i_1} x_{i_2} \cdots x_{i_M}$. Begin by showing that the redundancy in the coefﬁcients can be removed by rewriting this $M^{\text{th}}$ order term in the form

$$
\sum_{i_1=1}^D \sum_{i_2=1}^{i_1} \cdots \sum_{i_M=1}^{i_{M-1}} \widetilde{w}_{i_1 i_2 \cdots i_M} x_{i_1} x_{i_2} \cdots x_{i_M}. \tag{1.134}
$$
