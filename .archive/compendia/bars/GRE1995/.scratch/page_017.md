[Page 17]

## 6. Partition Models

### 6.1. A Hierarchical Model for Binomial Probabilities

selection in regression and mixture deconvolution; have the common feature that the discrete model-choice problem is equivalent to determining a partition; either of the original data units or of some other labels applying to the data, for example factor levels. Here we describe a general partition sampler; and its application to an ANOVA-like problem for binomial data discussed by Consonni & Veronese 1995).

A partition of a set $I = \{1,2,\ldots,n\}$ is a collection $g = \{S_1, S_2, \ldots, S_a\}$ of subsets of $I$, which we call groups, where the $S_i$ are disjoint with union $I$. The number d of groups into which I is divided by g will be called the degree of g, and written d(g) To emphasise

Suppose we have $n$ responses $Y_1, \ldots, Y_n$ assumed drawn independently from binomial distributions: $Y_i \sim \text{Bin}(w_i, \theta_i)$, where the index parameters $\{w_i\}$ are known and the probabilities $\{\theta_i\}$ unknown. We construct a prior distribution for $\{\theta_i\}$ that acknowledges that these parameters may have similar values within groups defined by a partition $g$ of $I = \{1, 2, \ldots, n\}$. Within each group $S_j(g)$ the $\theta_i$ are drawn independently from beta distributions:

$$
\theta_i \mid g, \alpha_1, \ldots, \alpha_{d(g)}, q
\;\sim\; \mathrm{Beta}\!\left(q\alpha_j,\; q(1-\alpha_j)\right)
\quad \bigl(i \in S_j(g),\; j = 1,\ldots,d(g)\bigr)
$$

The group mean parameters   {%j} are in turn drawn independently from the uniform distribution U(O, 1) while the group precision parameter q is either fixed at a known value, Or drawn from a hyperdensity p(q) This is essentially the model proposed by Consonni & Veronese; except that took a more general beta distribution than U(O, 1) only. It would be routine to modify what follows to deal with this situation. Consonni & Veronese  used conventional numerical techniques to ft their model, and so were constrained to use conjugate distributions; for which these techniques were practicable. With reversible jump Markov chain Monte Carlo computation such constraints need not have been imposed. they

Following Consonni & Veronese; the distribution for g is taken as prior

$$
p(g) \propto \frac{[d(g)]^{-1}}{\#\{g' : d(g') = d(g)\}}
$$
