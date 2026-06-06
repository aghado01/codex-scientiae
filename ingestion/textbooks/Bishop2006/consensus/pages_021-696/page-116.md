[Page 116]

Robbins and Monro (1951). We shall assume that the conditional variance of $z$ is ﬁnite so that

$$
\mathbb{E} \left[ (z - f)^2 | \theta \right] < \infty
\tag{2.128}
$$

and we shall also, without loss of generality, consider the case where $f(\theta) > 0$ for $\theta > \theta^\star$ and $f(\theta) < 0$ for $\theta < \theta^\star$, as is the case in Figure 2.10. The Robbins-Monro procedure then deﬁnes a sequence of successive estimates of the root $\theta^\star$ given by

$$
\theta^{(N)} = \theta^{(N-1)} + a_{N-1} z(\theta^{(N-1)})
\tag{2.129}
$$

where $z(\theta^{(N)})$ is an observed value of $z$ when $\theta$ takes the value $\theta^{(N)}$. The coefﬁcients $\{a_N\}$ represent a sequence of positive numbers that satisfy the conditions

$$
\lim_{N \to \infty} a_N = 0
\tag{2.130}
$$

$$
\sum_{N=1}^{\infty} a_N = \infty
\tag{2.131}
$$

$$
\sum_{N=1}^{\infty} a_N^2 < \infty.
\tag{2.132}
$$

It can then be shown (Robbins and Monro, 1951; Fukunaga, 1990) that the sequence of estimates given by (2.129) does indeed converge to the root with probability one. Note that the ﬁrst condition (2.130) ensures that the successive corrections decrease in magnitude so that the process can converge to a limiting value. The second condition (2.131) is required to ensure that the algorithm does not converge short of the root, and the third condition (2.132) is needed to ensure that the accumulated noise has ﬁnite variance and hence does not spoil convergence.

Now let us consider how a general maximum likelihood problem can be solved sequentially using the Robbins-Monro algorithm. By deﬁnition, the maximum likelihood solution $\theta_{\text{ML}}$ is a stationary point of the log likelihood function and hence satisﬁes

$$
\left. \frac{\partial}{\partial \theta} \left\{ \frac{1}{N} \sum_{n=1}^{N} \ln p(x_n | \theta) \right\} \right|_{\theta_{\text{ML}}} = 0.
\tag{2.133}
$$

Exchanging the derivative and the summation, and taking the limit $N \to \infty$ we have

$$
\lim_{N \to \infty} \frac{1}{N} \sum_{n=1}^{N} \frac{\partial}{\partial \theta} \ln p(x_n | \theta) = \mathbb{E}_x \left[ \frac{\partial}{\partial \theta} \ln p(x | \theta) \right]
\tag{2.134}
$$

and so we see that ﬁnding the maximum likelihood solution corresponds to ﬁnding the root of a regression function. We can therefore apply the Robbins-Monro procedure, which now takes the form

$$
\theta^{(N)} = \theta^{(N-1)} + a_{N-1} \frac{\partial}{\partial \theta^{(N-1)}} \ln p(x_N | \theta^{(N-1)}).
\tag{2.135}
$$
