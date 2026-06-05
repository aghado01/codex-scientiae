[Page 545]

11. SAMPLING METHODS 525

straightforward to sample from the joint distribution (assuming that it is possible to sample from the conditional distributions at each node) using the following ancestral sampling approach, discussed brieﬂy in Section 8.1.2. The joint distribution is speciﬁed by

�M

p(z) =

p(zi|pai) (11.4)

i=1

where zi are the set of variables associated with node i, and pai denotes the set of variables associated with the parents of node i. To obtain a sample from the joint

distribution, we make one pass through the set of variables in the order z1,...,zM sampling from the conditional distributions p(zi|pai). This is always possible because at each step all of the parent values will have been instantiated. After one pass through the graph, we will have obtained a sample from the joint distribution.

Now consider the case of a directed graph in which some of the nodes are instantiated with observed values. We can in principle extend the above procedure, at least in the case of nodes representing discrete variables, to give the following logic sampling approach (Henrion, 1988), which can be seen as a special case of importance sampling discussed in Section 11.1.4. At each step, when a sampled value is obtained for a variable zi whose value is observed, the sampled value is compared to the observed value, and if they agree then the sample value is retained and the algorithm proceeds to the next variable in turn. However, if the sampled value and the observed value disagree, then the whole sample so far is discarded and the algorithm starts again with the ﬁrst node in the graph. This algorithm samples correctly from the posterior distribution because it corresponds simply to drawing samples from the joint distribution of hidden variables and data variables and then discarding those samples that disagree with the observed data (with the slight saving of not continuing with the sampling from the joint distribution as soon as one contradictory value is observed). However, the overall probability of accepting a sample from the posterior decreases rapidly as the number of observed variables increases and as the number of states that those variables can take increases, and so this approach is rarely used in practice.

In the case of probability distributions deﬁned by an undirected graph, there is no one-pass sampling strategy that will sample even from the prior distribution with no observed variables. Instead, computationally more expensive techniques must be employed, such as Gibbs sampling, which is discussed in Section 11.3.

As well as sampling from conditional distributions, we may also require samples from a marginal distribution. If we already have a strategy for sampling from a joint distribution p(u,v), then it is straightforward to obtain samples from the marginal distribution p(u) simply by ignoring the values for v in each sample.

There are numerous texts dealing with Monte Carlo methods. Those of particular interest from the statistical inference perspective include Chen et al. (2001), Gamerman (1997), Gilks et al. (1996), Liu (2001), Neal (1996), and Robert and Casella (1999). Also there are review articles by Besag et al. (1995), Brooks (1998), Diaconis and Saloff-Coste (1998), Jerrum and Sinclair (1996), Neal (1993), Tierney (1994), and Andrieu et al. (2003) that provide additional information on sampling
