[Page 537]

We recognize this as the sum-product rule in the form in which messages from variable nodes to factor nodes have been eliminated, as illustrated by the example shown in Figure 8.50. The quantity f�jm(θm) corresponds to the message µf

j→θm(θm), which factor node j sends to variable node m, and the product over k in (10.240) is over all factors that depend on the variables θm that have variables (other than variable θl) in common with factor fj(θj). In other words, to compute the outgoing message from a factor node, we take the product of all the incoming messages from other factor nodes, multiply by the local factor, and then marginalize.

Thus, the sum-product algorithm arises as a special case of expectation propagation if we use an approximating distribution that is fully factorized. This suggests that more ﬂexible approximating distributions, corresponding to partially disconnected graphs, could be used to achieve higher accuracy. Another generalization is to group factors fi(θi) together into sets and to reﬁne all the factors in a set together at each iteration. Both of these approaches can lead to improvements in accuracy (Minka, 2001b). In general, the problem of choosing the best combination of grouping and disconnection is an open research issue.

We have seen that variational message passing and expectation propagation optimize two different forms of the Kullback-Leibler divergence. Minka (2005) has shown that a broad range of message passing algorithms can be derived from a common framework involving minimization of members of the alpha family of divergences, given by (10.19). These include variational message passing, loopy belief propagation, and expectation propagation, as well as a range of other algorithms, which we do not have space to discuss here, such as tree-reweighted message passing (Wainwright et al., 2005), fractional belief propagation (Wiegerinck and Heskes, 2003), and power EP (Minka, 2004).

Exercises

10.1 (�) www Verify that the log marginal distribution of the observed data lnp(X) can be decomposed into two terms in the form (10.2) where L(q) is given by (10.3) and KL(q�p) is given by (10.4).

10.2 (�) Use the properties E[z1] = m1 and E[z2] = m2 to solve the simultaneous equations (10.13) and (10.15), and hence show that, provided the original distribution p(z) is nonsingular, the unique solution for the means of the factors in the approximation distribution is given by E[z1] = µ1 and E[z2] = µ2.

10.3 (��) www Consider a factorized variational distribution q(Z) of the form (10.5). By using the technique of Lagrange multipliers, verify that minimization of the Kullback-Leibler divergence KL(p�q) with respect to one of the factors qi(Zi), keeping all other factors ﬁxed, leads to the solution (10.17).

10.4 (��) Suppose that p(x) is some ﬁxed distribution and that we wish to approximate it using a Gaussian distribution q(x) = N(x|µ,Σ). By writing down the form of the KL divergence KL(p�q) for a Gaussian q(x) and then differentiating, show that
