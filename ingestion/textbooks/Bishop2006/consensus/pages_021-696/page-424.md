[Page 424]

Figure 8.46 A fragment of a factor graph illustrating the evaluation of the marginal $p(x)$.

![image 205](../images/imageFile205.png)

$f_s$, and $F_s(x, X_s)$ represents the product of all the factors in the group associated with factor $f_s$.

Substituting (8.62) into (8.61) and interchanging the sums and products, we obtain

$$
\begin{aligned}
p(x) &= \prod_{s \in \text{ne}(x)} \left[ \sum_{X_s} F_s(x, X_s) \right] \\
&= \prod_{s \in \text{ne}(x)} \mu_{f_s \to x}(x).
\end{aligned} \tag{8.63}
$$

Here we have introduced a set of functions $\mu_{f_s \to x}(x)$, deﬁned by

$$
\mu_{f_s \to x}(x) \equiv \sum_{X_s} F_s(x, X_s) \tag{8.64}
$$

which can be viewed as messages from the factor nodes $f_s$ to the variable node $x$. We see that the required marginal $p(x)$ is given by the product of all the incoming messages arriving at node $x$.

In order to evaluate these messages, we again turn to Figure 8.46 and note that each factor $F_s(x, X_s)$ is described by a factor (sub-)graph and so can itself be factorized. In particular, we can write

$$
F_s(x, X_s) = f_s(x, x_1, \ldots, x_M) G_1(x_1, X_{s1}) \cdots G_M(x_M, X_{sM}) \tag{8.65}
$$

where, for convenience, we have denoted the variables associated with factor $f_s$, in addition to $x$, by $x_1, \ldots, x_M$. This factorization is illustrated in Figure 8.47. Note that the set of variables $\{x, x_1, \ldots, x_M\}$ is the set of variables on which the factor $f_s$ depends, and so it can also be denoted $\mathbf{x}_s$, using the notation of (8.59).

Substituting (8.65) into (8.64) we obtain

$$
\begin{aligned}
\mu_{f_s \to x}(x) &= \sum_{x_1} \cdots \sum_{x_M} f_s(x, x_1, \ldots, x_M) \prod_{m \in \text{ne}(f_s) \setminus x} \left[ \sum_{X_{sm}} G_m(x_m, X_{sm}) \right] \\
&= \sum_{x_1} \cdots \sum_{x_M} f_s(x, x_1, \ldots, x_M) \prod_{m \in \text{ne}(f_s) \setminus x} \mu_{x_m \to f_s}(x_m) 
\end{aligned} \tag{8.66}
$$
