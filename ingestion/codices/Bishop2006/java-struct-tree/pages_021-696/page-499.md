[Page 499]

where we have introduced deﬁnitions of Λ�k and π�k, and ψ(·) is the digamma function deﬁned by (B.25), with α� =

�

k αk. The results (10.65) and (10.66) follow from Appendix B the standard properties of the Wishart and Dirichlet distributions.

If we substitute (10.64), (10.65), and (10.66) into (10.46) and make use of (10.49), we obtain the following result for the responsibilities

rnk ∝ π�kΛ�1k/2 exp�−

(xn − mk)TWk(xn − mk)�. (10.67)

D 2βk −

νk 2

Notice the similarity to the corresponding result for the responsibilities in maximum likelihood EM, which from (9.13) can be written in the form

rnk ∝ πk|Λk|1/2 exp�−

(xn − µk)TΛk(xn − µk)� (10.68)

1 2

where we have used the precision in place of the covariance to highlight the similarity to (10.67).

Thus the optimization of the variational posterior distribution involves cycling between two stages analogous to the E and M steps of the maximum likelihood EM algorithm. In the variational equivalent of the E step, we use the current distributions over the model parameters to evaluate the moments in (10.64), (10.65), and (10.66) and hence evaluate E[znk] = rnk. Then in the subsequent variational equivalent of the M step, we keep these responsibilities ﬁxed and use them to re-compute the variational distribution over the parameters using (10.57) and (10.59). In each case, we see that the variational posterior distribution has the same functional form as the corresponding factor in the joint distribution (10.41). This is a general result and is

Section 10.4.1 a consequence of the choice of conjugate distributions.

Figure 10.6 shows the results of applying this approach to the rescaled Old Faithful data set for a Gaussian mixture model having K = 6 components. We see that after convergence, there are only two components for which the expected values of the mixing coefﬁcients are numerically distinguishable from their prior values. This effect can be understood qualitatively in terms of the automatic trade-off in a

Section 3.4 Bayesian model between ﬁtting the data and the complexity of the model, in which the complexity penalty arises from components whose parameters are pushed away from their prior values. Components that take essentially no responsibility for explaining the data points have rnk � 0 and hence Nk � 0. From (10.58), we see that αk � α0 and from (10.60)–(10.63) we see that the other parameters revert to their prior values. In principle such components are ﬁtted slightly to the data points, but for broad priors this effect is too small to be seen numerically. For the variational Gaussian mixture model the expected values of the mixing coefﬁcients in the

Exercise 10.15 posterior distribution are given by

αk + Nk Kα0 + N

E[πk] =

. (10.69)

Consider a component for which Nk � 0 and αk � α0. If the prior is broad so that α0 → 0, then E[πk] → 0 and the component plays no role in the model, whereas if
