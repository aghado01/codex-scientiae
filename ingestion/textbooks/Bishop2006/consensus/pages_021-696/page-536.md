[Page 536]

These are precisely the messages obtained using belief propagation in which messages from variable nodes to factor nodes have been folded into the messages from factor nodes to variable nodes. In particular, $\widetilde{f}_{b2}(x_2)$ corresponds to the message $\mu_{f_b \to x_2}(x_2)$ sent by factor node $f_b$ to variable node $x_2$ and is given by (8.81). Similarly, if we substitute (8.78) into (8.79), we obtain (10.235) in which $\widetilde{f}_{a2}(x_2)$ corresponds to $\mu_{f_a \to x_2}(x_2)$ and $\widetilde{f}_{c2}(x_2)$ corresponds to $\mu_{f_c \to x_2}(x_2)$, giving the message $\widetilde{f}_{b3}(x_3)$ which corresponds to $\mu_{f_b \to x_3}(x_3)$.

This result differs slightly from standard belief propagation in that messages are passed in both directions at the same time. We can easily modify the EP procedure to give the standard form of the sum-product algorithm by updating just one of the factors at a time, for instance if we reﬁne only $\widetilde{f}_{b3}(x_3)$, then $\widetilde{f}_{b2}(x_2)$ is unchanged by deﬁnition, while the reﬁned version of $\widetilde{f}_{b3}(x_3)$ is again given by (10.235). If we are reﬁning only one term at a time, then we can choose the order in which the reﬁnements are done as we wish. In particular, for a tree-structured graph we can follow a two-pass update scheme, corresponding to the standard belief propagation schedule, which will result in exact inference of the variable and factor marginals. The initialization of the approximation factors in this case is unimportant.

Now let us consider a general factor graph corresponding to the distribution

$$
p(\boldsymbol{\theta}) = \prod_i f_i(\boldsymbol{\theta}_i) \tag{10.236}
$$

where $\boldsymbol{\theta}_i$ represents the subset of variables associated with factor $f_i$. We approximate this using a fully factorized distribution of the form

$$
q(\boldsymbol{\theta}) \propto \prod_i \prod_k \widetilde{f}_{ik}(\theta_k) \tag{10.237}
$$

where $\theta_k$ corresponds to an individual variable node. Suppose that we wish to reﬁne the particular term $\widetilde{f}_{jl}(\theta_l)$ keeping all other terms ﬁxed. We ﬁrst remove the term $\widetilde{f}_j(\boldsymbol{\theta}_j)$ from $q(\boldsymbol{\theta})$ to give

$$
q^{\setminus j}(\boldsymbol{\theta}) \propto \prod_{i \neq j} \prod_k \widetilde{f}_{ik}(\theta_k) \tag{10.238}
$$

and then multiply by the exact factor $f_j(\boldsymbol{\theta}_j)$. To determine the reﬁned term $\widetilde{f}_{jl}(\theta_l)$, we need only consider the functional dependence on $\theta_l$, and so we simply ﬁnd the corresponding marginal of

$$
q^{\setminus j}(\boldsymbol{\theta}) f_j(\boldsymbol{\theta}_j). \tag{10.239}
$$

Up to a multiplicative constant, this involves taking the marginal of $f_j(\boldsymbol{\theta}_j)$ multiplied by any terms from $q^{\setminus j}(\boldsymbol{\theta})$ that are functions of any of the variables in $\boldsymbol{\theta}_j$. Terms that correspond to other factors $f_i(\boldsymbol{\theta}_i)$ for $i \neq j$ will cancel between numerator and denominator when we subsequently divide by $q^{\setminus j}(\boldsymbol{\theta})$. We therefore obtain

$$
\widetilde{f}_{jl}(\theta_l) \propto \sum_{\boldsymbol{\theta}_j \setminus \theta_l} f_j(\boldsymbol{\theta}_j) \prod_{m \neq l} \prod_{k \neq j} \widetilde{f}_{km}(\theta_m). \tag{10.240}
$$
