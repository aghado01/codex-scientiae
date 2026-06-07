[Page 415]

The joint distribution for this graph takes the form

$$
p(\mathbf{x}) = \frac{1}{Z} \psi_{1,2}(x_1, x_2)\psi_{2,3}(x_2, x_3) \cdots \psi_{N-1,N}(x_{N-1}, x_N). \tag{8.49}
$$

We shall consider the speciﬁc case in which the $N$ nodes represent discrete variables each having $K$ states, in which case each potential function $\psi_{n-1,n}(x_{n-1}, x_n)$ comprises an $K \times K$ table, and so the joint distribution has $(N - 1)K^2$ parameters.

Let us consider the inference problem of ﬁnding the marginal distribution $p(x_n)$ for a speciﬁc node $x_n$ that is part way along the chain. Note that, for the moment, there are no observed nodes. By deﬁnition, the required marginal is obtained by summing the joint distribution over all variables except $x_n$, so that

$$
p(x_n) = \sum_{x_1} \cdots \sum_{x_{n-1}} \sum_{x_{n+1}} \cdots \sum_{x_N} p(\mathbf{x}). \tag{8.50}
$$

In a naive implementation, we would ﬁrst evaluate the joint distribution and then perform the summations explicitly. The joint distribution can be represented as a set of numbers, one for each possible value for $\mathbf{x}$. Because there are $N$ variables each with $K$ states, there are $K^N$ values for $\mathbf{x}$ and so evaluation and storage of the joint distribution, as well as marginalization to obtain $p(x_n)$, all involve storage and computation that scale exponentially with the length $N$ of the chain.

We can, however, obtain a much more efﬁcient algorithm by exploiting the conditional independence properties of the graphical model. If we substitute the factorized expression (8.49) for the joint distribution into (8.50), then we can rearrange the order of the summations and the multiplications to allow the required marginal to be evaluated much more efﬁciently. Consider for instance the summation over $x_N$. The potential $\psi_{N-1,N}(x_{N-1}, x_N)$ is the only one that depends on $x_N$, and so we can perform the summation

$$
\sum_{x_N} \psi_{N-1,N}(x_{N-1}, x_N) \tag{8.51}
$$

ﬁrst to give a function of $x_{N-1}$. We can then use this to perform the summation over $x_{N-1}$, which will involve only this new function together with the potential $\psi_{N-2,N-1}(x_{N-2}, x_{N-1})$, because this is the only other place that $x_{N-1}$ appears. Similarly, the summation over $x_1$ involves only the potential $\psi_{1,2}(x_1, x_2)$ and so can be performed separately to give a function of $x_2$, and so on. Because each summation effectively removes a variable from the distribution, this can be viewed as the removal of a node from the graph.

If we group the potentials and summations together in this way, we can express
