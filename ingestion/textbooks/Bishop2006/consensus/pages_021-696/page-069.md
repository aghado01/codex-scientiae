[Page 69]

Figure 1.29 Plots of the quantity $L_q = |y - t|^q$ for various values of $q$.

![image 33](../../../../../images/imageFile33.png)

$$
h(x) = -\log_2 p(x). \tag{1.92}
$$

where the negative sign ensures that information is positive or zero. Note that low probability events $x$ correspond to high information content. The choice of basis for the logarithm is arbitrary, and for the moment we shall adopt the convention prevalent in information theory of using logarithms to the base of $2$. In this case, as we shall see shortly, the units of $h(x)$ are bits (‘binary digits’).

Now suppose that a sender wishes to transmit the value of a random variable to a receiver. The average amount of information that they transmit in the process is obtained by taking the expectation of (1.92) with respect to the distribution $p(x)$ and is given by

$$
H[x] = -\sum_x p(x)\log_2 p(x). \tag{1.93}
$$

This important quantity is called the entropy of the random variable $x$. Note that $\lim_{p \to 0} p \ln p = 0$ and so we shall take $p(x)\ln p(x) = 0$ whenever we encounter a value for $x$ such that $p(x) = 0$.

So far we have given a rather heuristic motivation for the deﬁnition of informa-
