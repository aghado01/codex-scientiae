[Page 15]

## Appendix 1

### Detailed Balance

In order to prove that detailed balance holds for this chain, we have to show that

$$
\pi(M_k)\,\Pr(M_{k-1} \mid M_k) = \pi(M_{k-1})\,\Pr(M_k \mid M_{k-1}), \tag{A1}
$$

where $M_k$ denotes the parameters of the model with $k$ knots: $M_k = \{k, \xi_1, \ldots, \xi_k\}$, for $k = 1, 2, \ldots$ and $\xi_i \in (0, 1)$. The $\pi(M_k)$ density is the target from which we want to draw observations; in our case $\pi(M_k)$ is the posterior distribution of $M_k$, namely

$$
\pi(M_k) = \frac{p(y \mid \xi_1, \ldots, \xi_k)\,p(\xi_1, \ldots, \xi_k \mid k)\,p(k)}{p(y)}.
$$

The formula $\Pr(M_{k-1} \mid M_k)$ is a Markov transition kernel, the transition probability of going from $M_k$ to $M_{k-1}$. Let

$$
M_k = \{k, \xi_1, \xi_2, \ldots, \xi_{j^*-1}, \xi_{j^*}, \xi_{j^*+1}, \ldots, \xi_k\},
\quad
M_{k-1} = \{k-1, \xi_1, \xi_2, \ldots, \xi_{j^*-1}, \xi_{j^*+1}, \ldots, \xi_k\}.
$$

The sets of knots in the two spaces differ only in the $j^*$th element. We can now write the transition probabilities as follows:

$$
\Pr(M_{k-1} \mid M_k) = d_k\,\frac{1}{k}\,\min(1, A),
\qquad
\Pr(M_k \mid M_{k-1}) = b_{k-1}\,\frac{1}{k-1}\sum_i h_B(\xi_{j^*} \mid \xi_i)\,\min(1, B),
$$

where

$$
A = \frac{\pi(M_{k-1})}{\pi(M_k)}\,\frac{b_{k-1}(k-1)^{-1}\sum_i h_B(\xi_{j^*} \mid \xi_i)}{d_k k^{-1}}, \qquad B = \frac{\pi(M_k)}{\pi(M_{k-1})}\,\frac{d_k k^{-1}}{b_{k-1}(k-1)^{-1}\sum_i h_B(\xi_{j^*} \mid \xi_i)} = 1/A.
$$

We can now verify (A1). If $A < 1$, then $\alpha_d = A$ and $\alpha_b = 1$, and therefore rewriting (A1) we have that

$$
\pi(M_k)\,\Pr(M_{k-1} \mid M_k)
= \pi(M_k) d_k \frac{1}{k} A
= \pi(M_k) d_k \frac{1}{k} \frac{\pi(M_{k-1})}{\pi(M_k)} \frac{b_{k-1}(k-1)^{-1}\sum_i h_B(\xi_{j^*}\mid\xi_i)}{d_k k^{-1}}
= \pi(M_{k-1}) b_{k-1} \frac{1}{k-1} \sum_i h_B(\xi_{j^*}\mid\xi_i)
= \pi(M_{k-1})\,\Pr(M_k \mid M_{k-1})
$$

The case when $A > 1$ is now obvious. Also the proof of the detailed balance condition when we move from $M_k$ to $M_k'$, a relocation step, is straightforward.
