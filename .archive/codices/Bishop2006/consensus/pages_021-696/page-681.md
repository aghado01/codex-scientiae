[Page 681]

form

$$
\begin{aligned}
E &= e^{-\alpha_m/2} \sum_{n \in \mathcal{T}_m} w_n^{(m)} + e^{\alpha_m/2} \sum_{n \in \mathcal{M}_m} w_n^{(m)} \\
&= (e^{\alpha_m/2} - e^{-\alpha_m/2}) \sum_{n=1}^N w_n^{(m)} I(y_m(\mathbf{x}_n) \ne t_n) + e^{-\alpha_m/2} \sum_{n=1}^N w_n^{(m)}.
\end{aligned} \tag{14.23}
$$

When we minimize this with respect to $y_m(\mathbf{x})$, we see that the second term is constant, and so this is equivalent to minimizing (14.15) because the overall multiplicative factor in front of the summation does not affect the location of the minimum. Similarly, minimizing with respect to $\alpha_m$, we obtain (14.17) in which $\epsilon_m$ is deﬁned by (14.16).

From (14.22) we see that, having found $\alpha_m$ and $y_m(\mathbf{x})$, the weights on the data points are updated using

$$
w_n^{(m+1)} = w_n^{(m)} \exp\left\{ -\frac{1}{2} t_n \alpha_m y_m(\mathbf{x}_n) \right\}. \tag{14.24}
$$

Making use of the fact that

$$
t_n y_m(\mathbf{x}_n) = 1 - 2I(y_m(\mathbf{x}_n) \ne t_n) \tag{14.25}
$$

we see that the weights $w_n^{(m)}$ are updated at the next iteration using

$$
w_n^{(m+1)} = w_n^{(m)} \exp(-\alpha_m/2)\exp\{\alpha_m I(y_m(\mathbf{x}_n) \ne t_n)\}. \tag{14.26}
$$

Because the term $\exp(-\alpha_m/2)$ is independent of $n$, we see that it weights all data points by the same factor and so can be discarded. Thus we obtain (14.18).

Finally, once all the base classiﬁers are trained, new data points are classiﬁed by evaluating the sign of the combined function deﬁned according to (14.21). Because the factor of $1/2$ does not affect the sign it can be omitted, giving (14.19).

### 14.3.2 Error functions for boosting

The exponential error function that is minimized by the AdaBoost algorithm differs from those considered in previous chapters. To gain some insight into the nature of the exponential error function, we ﬁrst consider the expected error given by

$$
\mathbb{E}_{\mathbf{x}, t}[\exp\{-ty(\mathbf{x})\}] = \sum_t \int \exp\{-ty(\mathbf{x})\} p(t|\mathbf{x})p(\mathbf{x})\, d\mathbf{x}. \tag{14.27}
$$

If we perform a variational minimization with respect to all possible functions $y(\mathbf{x})$, we obtain

$$
y(\mathbf{x}) = \frac{1}{2} \ln \left\{ \frac{p(t=1|\mathbf{x})}{p(t=-1|\mathbf{x})} \right\} \tag{14.28}
$$
