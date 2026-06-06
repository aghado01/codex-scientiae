[Page 34]

from (1.5) and (1.6), we have

$$
p(X = x_i) = \sum_{j=1}^L p(X = x_i, Y = y_j) \tag{1.7}
$$

which is the sum rule of probability. Note that $p(X = x_i)$ is sometimes called the marginal probability, because it is obtained by marginalizing, or summing out, the other variables (in this case $Y$).

If we consider only those instances for which $X = x_i$, then the fraction of such instances for which $Y = y_j$ is written $p(Y = y_j|X = x_i)$ and is called the conditional probability of $Y = y_j$ given $X = x_i$. It is obtained by ﬁnding the fraction of those points in column $i$ that fall in cell $i,j$ and hence is given by

$$
p(Y = y_j|X = x_i) = \frac{n_{ij}}{c_i} \tag{1.8}
$$

From (1.5), (1.6), and (1.8), we can then derive the following relationship

$$
\begin{align*}
p(X = x_i, Y = y_j) &= \frac{n_{ij}}{N} = \frac{n_{ij}}{c_i} \cdot \frac{c_i}{N} \\
&= p(Y = y_j|X = x_i) p(X = x_i) \tag{1.9}
\end{align*}
$$

which is the product rule of probability.

So far we have been quite careful to make a distinction between a random variable, such as the box $B$ in the fruit example, and the values that the random variable can take, for example $r$ if the box were the red one. Thus the probability that $B$ takes the value $r$ is denoted $p(B = r)$. Although this helps to avoid ambiguity, it leads to a rather cumbersome notation, and in many cases there will be no need for such pedantry. Instead, we may simply write $p(B)$ to denote a distribution over the random variable $B$, or $p(r)$ to denote the distribution evaluated for the particular value $r$, provided that the interpretation is clear from the context.

With this more compact notation, we can write the two fundamental rules of probability theory in the following form.

**The Rules of Probability**

$$
\text{sum rule} \quad p(X) = \sum_Y p(X, Y) \tag{1.10}
$$

$$
\text{product rule} \quad p(X, Y) = p(Y|X) p(X) \tag{1.11}
$$

Here $p(X, Y)$ is a joint probability and is verbalized as "the probability of $X$ and $Y$". Similarly, the quantity $p(Y|X)$ is a conditional probability and is verbalized as "the probability of $Y$ given $X$", whereas the quantity $p(X)$ is a marginal probability
