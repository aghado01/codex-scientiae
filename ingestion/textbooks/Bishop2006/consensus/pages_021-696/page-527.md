[Page 527]

be described by a ﬁnite set of sufﬁcient statistics. For example, if each of the $\widetilde{f}_i(\boldsymbol{\theta})$ is a Gaussian, then the overall approximation $q(\boldsymbol{\theta})$ will also be Gaussian.

Ideally we would like to determine the $\widetilde{f}_i(\boldsymbol{\theta})$ by minimizing the Kullback-Leibler divergence between the true posterior and the approximation given by

$$
\text{KL}(p || q) = \text{KL} \left( \frac{1}{p(\mathcal{D})} \prod_i f_i(\boldsymbol{\theta}) \Big\| \frac{1}{Z} \prod_i \widetilde{f}_i(\boldsymbol{\theta}) \right). \tag{10.192}
$$

Note that this is the reverse form of KL divergence compared with that used in variational inference. In general, this minimization will be intractable because the KL divergence involves averaging with respect to the true distribution. As a rough approximation, we could instead minimize the KL divergences between the corresponding pairs $f_i(\boldsymbol{\theta})$ and $\widetilde{f}_i(\boldsymbol{\theta})$ of factors. This represents a much simpler problem to solve, and has the advantage that the algorithm is noniterative. However, because each factor is individually approximated, the product of the factors could well give a poor approximation.

Expectation propagation makes a much better approximation by optimizing each factor in turn in the context of all of the remaining factors. It starts by initializing the factors $\widetilde{f}_i(\boldsymbol{\theta})$, and then cycles through the factors reﬁning them one at a time. This is similar in spirit to the update of factors in the variational Bayes framework considered earlier. Suppose we wish to reﬁne factor $\widetilde{f}_j(\boldsymbol{\theta})$. We ﬁrst remove this factor from the product to give $\prod_{i \neq j} \widetilde{f}_i(\boldsymbol{\theta})$. Conceptually, we will now determine a revised form of the factor $\widetilde{f}_j(\boldsymbol{\theta})$ by ensuring that the product

$$
q^{\text{new}}(\boldsymbol{\theta}) \propto \widetilde{f}_j(\boldsymbol{\theta}) \prod_{i \neq j} \widetilde{f}_i(\boldsymbol{\theta}) \tag{10.193}
$$

is as close as possible to

$$
f_j(\boldsymbol{\theta}) \prod_{i \neq j} \widetilde{f}_i(\boldsymbol{\theta}) \tag{10.194}
$$

in which we keep ﬁxed all of the factors $\widetilde{f}_i(\boldsymbol{\theta})$ for $i \neq j$. This ensures that the approximation is most accurate in the regions of high posterior probability as deﬁned by the remaining factors. We shall see an example of this effect when we apply EP to the ‘clutter problem’. To achieve this, we ﬁrst remove the factor $\widetilde{f}_j(\boldsymbol{\theta})$ from the current approximation to the posterior by deﬁning the unnormalized distribution

$$
q^{\setminus j}(\boldsymbol{\theta}) = \frac{q(\boldsymbol{\theta})}{\widetilde{f}_j(\boldsymbol{\theta})}. \tag{10.195}
$$

Note that we could instead ﬁnd $q^{\setminus j}(\boldsymbol{\theta})$ from the product of factors $i \neq j$, although in practice division is usually easier. This is now combined with the factor $f_j(\boldsymbol{\theta})$ to give a distribution

$$
\frac{1}{Z_j} f_j(\boldsymbol{\theta}) q^{\setminus j}(\boldsymbol{\theta}) \tag{10.196}
$$
