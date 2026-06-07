[Page 349]

Eliminating $\mathbf{w}$ and $b$ from $L(\mathbf{w},b,\mathbf{a})$ using these conditions then gives the dual representation of the maximum margin problem in which we maximize

$$
\widetilde{L}(\mathbf{a}) = \sum_{n=1}^N a_n - \frac{1}{2} \sum_{n=1}^N \sum_{m=1}^N a_n a_m t_n t_m k(\mathbf{x}_n,\mathbf{x}_m) \tag{7.10}
$$

with respect to $\mathbf{a}$ subject to the constraints

$$
a_n \geqslant 0, \quad n = 1,\dots,N, \tag{7.11}
$$

$$
\sum_{n=1}^N a_n t_n = 0. \tag{7.12}
$$

Here the kernel function is deﬁned by $k(\mathbf{x},\mathbf{x}') = \boldsymbol{\phi}(\mathbf{x})^T\boldsymbol{\phi}(\mathbf{x}')$. Again, this takes the form of a quadratic programming problem in which we optimize a quadratic function of $\mathbf{a}$ subject to a set of inequality constraints. We shall discuss techniques for solving such quadratic programming problems in Section 7.1.1.

The solution to a quadratic programming problem in $M$ variables in general has computational complexity that is $O(M^3)$. In going to the dual formulation we have turned the original optimization problem, which involved minimizing (7.6) over $M$ variables, into the dual problem (7.10), which has $N$ variables. For a ﬁxed set of basis functions whose number $M$ is smaller than the number $N$ of data points, the move to the dual problem appears disadvantageous. However, it allows the model to be reformulated using kernels, and so the maximum margin classiﬁer can be applied efﬁciently to feature spaces whose dimensionality exceeds the number of data points, including inﬁnite feature spaces. The kernel formulation also makes clear the role of the constraint that the kernel function $k(\mathbf{x},\mathbf{x}')$ be positive deﬁnite, because this ensures that the Lagrangian function $\widetilde{L}(\mathbf{a})$ is bounded below, giving rise to a welldeﬁned optimization problem.

In order to classify new data points using the trained model, we evaluate the sign of $y(\mathbf{x})$ deﬁned by (7.1). This can be expressed in terms of the parameters $\{a_n\}$ and the kernel function by substituting for $\mathbf{w}$ using (7.8) to give

$$
y(\mathbf{x}) = \sum_{n=1}^N a_n t_n k(\mathbf{x},\mathbf{x}_n) + b. \tag{7.13}
$$

![image 31](../images/imageFile31.png)

###### Joseph-Louis Lagrange 1736–1813

Although widely considered to be a French mathematician, Lagrange was born in Turin in Italy. By the age of nineteen, he had already made important contributions mathematics and had been appointed as Professor at the Royal Artillery School in Turin. For many years, Euler worked hard to persuade Lagrange to move to Berlin, which he eventually did in 1766 where he succeeded Euler as Director of Mathematics at the Berlin Academy. Later he moved to Paris, narrowly escaping with his life during the French revolution thanks to the personal intervention of Lavoisier (the French chemist who discovered oxygen) who himself was later executed at the guillotine. Lagrange made key contributions to the calculus of variations and the foundations of dynamics.
