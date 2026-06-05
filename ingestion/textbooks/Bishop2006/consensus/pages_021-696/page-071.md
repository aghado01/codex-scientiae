[Page 71]

the number of different ways of allocating the objects to the bins. There are $N$ ways to choose the ﬁrst object, $(N - 1)$ ways to choose the second object, and so on, leading to a total of $N!$ ways to allocate all $N$ objects to the bins, where $N!$ (pronounced ‘factorial $N$’) denotes the product $N \times (N - 1) \times \cdots \times 2 \times 1$. However, we don’t wish to distinguish between rearrangements of objects within each bin. In the $i$th bin there are $n_i!$ ways of reordering the objects, and so the total number of ways of allocating the $N$ objects to the bins is given by

$$
W = \frac{N!}{\prod_i n_i!}. \tag{1.94}
$$

which is called the multiplicity. The entropy is then deﬁned as the logarithm of the multiplicity scaled by an appropriate constant

$$
H = \frac{1}{N} \ln W = \frac{1}{N} \ln N! - \frac{1}{N} \sum_i \ln n_i!. \tag{1.95}
$$

We now consider the limit $N \to \infty$, in which the fractions $n_i/N$ are held ﬁxed, and apply Stirling’s approximation

$$
\ln N! \simeq N \ln N - N. \tag{1.96}
$$

which gives

$$
H = -\lim_{N \to \infty} \sum_i \left(\frac{n_i}{N}\right) \ln \left(\frac{n_i}{N}\right) = -\sum_i p_i \ln p_i. \tag{1.97}
$$

where we have used $\sum_i n_i = N$. Here $p_i = \lim_{N \to \infty}(n_i/N)$ is the probability of an object being assigned to the $i$th bin. In physics terminology, the speciﬁc arrangements of objects in the bins is called a microstate, and the overall distribution of occupation numbers, expressed through the ratios $n_i/N$, is called a macrostate. The multiplicity $W$ is also known as the weight of the macrostate.

We can interpret the bins as the states $x_i$ of a discrete random variable $X$, where $p(X = x_i) = p_i$. The entropy of the random variable $X$ is then

$$
H[p] = -\sum_i p(x_i)\ln p(x_i). \tag{1.98}
$$

Distributions $p(x_i)$ that are sharply peaked around a few values will have a relatively low entropy, whereas those that are spread more evenly across many values will

have higher entropy, as illustrated in Figure 1.30. Because $0 \le p_i \le 1$, the entropy is nonnegative, and it will equal its minimum value of $0$ when one of the $p_i = 1$ and all other $p_j = 0$. The maximum entropy conﬁguration can be found by maximizing $H$ using a Lagrange multiplier to enforce the normalization constraint on the probabilities. Thus we maximize

$$
\widetilde{H} = -\sum_i p(x_i)\ln p(x_i) + \lambda \left(\sum_i p(x_i) - 1\right). \tag{1.99}
$$
