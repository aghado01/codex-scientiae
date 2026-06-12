[Page 499]

Appendix B

Section 10.4.1

Section 3.4

Exercise 10.15

where we have introduced deﬁnitions of Λ k and π k , and ψ ( · ) is the digamma function deﬁned by (B.25), with α = k α k . The results (10.65) and (10.66) follow from the standard properties of the Wishart and Dirichlet distributions. If we substitute (10.64), (10.65), and (10.66) into (10.46) and make use of (10.49), we obtain the following result for the responsibilities

If we substitute (10.64), (10.65), and (10.66) into (10.46) and make use of (10.49), we obtain the following result for the responsibilities

$$
( 1 0 . 4 ) , \, & \text {we obtain the following result for the responsibilities} \\ & r _ { n k } \, \alpha \, \widetilde { \pi } _ { k } \widetilde { \Lambda } _ { k } ^ { 1 / 2 } \exp \left \{ - \frac { D } { 2 \beta _ { k } } - \frac { \nu _ { k } } { 2 } ( x _ { n } - m _ { k } ) ^ { T } W _ { k } ( x _ { n } - m _ { k } ) \right \} . \\ & \text {Notice the similarity to the corresponding result for the responsibilities in maximum} \\ & \text {likelihood EM, which from (9.13) can be written in the form}
$$

Notice the similarity to the corresponding result for the responsibilities in maximum likelihood EM, which from (9.13) can be written in the form

$$
\text {improved} E , \text { which in } ( 9 . 1 5 ) \text { can be written in the form } \\ r _ { n k } \in \pi _ { k } | \Lambda _ { k } | ^ { 1 / 2 } \exp \left \{ - \frac { 1 } { 2 } ( x _ { n } - \mu _ { k } ) ^ { T } \Lambda _ { k } ( x _ { n } - \mu _ { k } ) \right \} \\ \intertext { w h o r v o h v o s u d t h o r v i o n v o p i s e d t h o w h e v i n g h t b o t h i l l }
$$

where we have used the precision in place of the covariance to highlight the similarity to (10.67).

Thus the optimization of the variational posterior distribution involves cycling between two stages analogous to the E and M steps of the maximum likelihood EM algorithm. In the variational equivalent of the E step, we use the current distributions over the model parameters to evaluate the moments in (10.64), (10.65), and (10.66) and hence evaluate E [ z nk ] = r nk . Then in the subsequent variational equivalent of the M step, we keep these responsibilities ﬁxed and use them to re-compute the variational distribution over the parameters using (10.57) and (10.59). In each case, we see that the variational posterior distribution has the same functional form as the corresponding factor in the joint distribution (10.41). This is a general result and is a consequence of the choice of conjugate distributions.

Figure 10.6 shows the results of applying this approach to the rescaled Old Faithful data set for a Gaussian mixture model having K = 6 components. We see that after convergence, there are only two components for which the expected values of the mixing coefﬁcients are numerically distinguishable from their prior values. This effect can be understood qualitatively in terms of the automatic trade-off in a Bayesian model between ﬁtting the data and the complexity of the model, in which the complexity penalty arises from components whose parameters are pushed away from their prior values. Components that take essentially no responsibility for explaining the data points have r nk 0 and hence N k 0 . From (10.58), we see that α k α 0 and from (10.60)–(10.63) we see that the other parameters revert to their prior values. In principle such components are ﬁtted slightly to the data points, but for broad priors this effect is too small to be seen numerically. For the variational Gaussian mixture model the expected values of the mixing coefﬁcients in the posterior distribution are given by

$$
\mathbb { E } [ \pi _ { k } ] = \frac { \alpha _ { k } + N _ { k } } { K \alpha _ { 0 } + N } .
$$

Consider a component for which N k 0 and α k α 0 . If the prior is broad so that α 0 → 0 , then E [ π k ] → 0 and the component plays no role in the model, whereas if
