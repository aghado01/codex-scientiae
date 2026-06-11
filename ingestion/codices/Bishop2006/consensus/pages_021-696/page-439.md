[Page 439]

Table 8.2 The joint distribution over three binary variables.

| $a$ | $b$ | $c$ | $p(a,b,c)$ |
|---|---|---|---|
| $0$ | $0$ | $0$ | $0.192$ |
| $0$ | $0$ | $1$ | $0.144$ |
| $0$ | $1$ | $0$ | $0.048$ |
| $0$ | $1$ | $1$ | $0.216$ |
| $1$ | $0$ | $0$ | $0.192$ |
| $1$ | $0$ | $1$ | $0.064$ |
| $1$ | $1$ | $0$ | $0.048$ |
| $1$ | $1$ | $1$ | $0.096$ |

8.3 ($\star$) Consider three binary variables $a,b,c \in \{0,1\}$ having the joint distribution given in Table 8.2. Show by direct evaluation that this distribution has the property that $a$ and $b$ are marginally dependent, so that $p(a,b) \neq p(a)p(b)$, but that they become independent when conditioned on $c$, so that $p(a,b|c) = p(a|c)p(b|c)$ for both $c = 0$ and $c = 1$.

8.4 ($\star$) Evaluate the distributions $p(a)$, $p(b|c)$, and $p(c|a)$ corresponding to the joint distribution given in Table 8.2. Hence show by direct evaluation that $p(a,b,c) = p(a)p(c|a)p(b|c)$. Draw the corresponding directed graph.

8.5 ($\star$) www Draw a directed probabilistic graphical model corresponding to the relevance vector machine described by (7.79) and (7.80).

8.6 ($\star$) For the model shown in Figure 8.13, we have seen that the number of parameters required to specify the conditional distribution $p(y|x_1,\dots,x_M)$, where $x_i \in \{0,1\}$, could be reduced from $2^M$ to $M + 1$ by making use of the logistic sigmoid representation (8.10). An alternative representation (Pearl, 1988) is given by

$$
p(y = 1|x_1, \dots, x_M) = 1 - (1 - \mu_0) \prod_{i=1}^M (1 - \mu_i)^{x_i} \tag{8.104}
$$

where the parameters $\mu_i$ represent the probabilities $p(x_i = 1)$, and $\mu_0$ is an additional parameter satisfying $0 \le \mu_0 \le 1$. The conditional distribution (8.104) is known as the noisy-OR. Show that this can be interpreted as a 'soft' (probabilistic) form of the logical OR function (i.e., the function that gives $y = 1$ whenever at least one of the $x_i = 1$). Discuss the interpretation of $\mu_0$.

8.7 ($\star$) Using the recursion relations (8.15) and (8.16), show that the mean and covariance of the joint distribution for the graph shown in Figure 8.14 are given by (8.17) and (8.18), respectively.

8.8 ($\star$) www Show that $a \perp\!\!\!\perp b,c | d$ implies $a \perp\!\!\!\perp b | d$.

8.9 ($\star$) www Using the d-separation criterion, show that the conditional distribution for a node $x$ in a directed graph, conditioned on all of the nodes in the Markov blanket, is independent of the remaining variables in the graph.
