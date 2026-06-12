[Page 456]

We can interpret Nk as the effective number of points assigned to cluster k. Note carefully the form of this solution. We see that the mean µk for the kth Gaussian component is obtained by taking a weighted mean of all of the points in the data set, in which the weighting factor for data point xn is given by the posterior probability γ(znk) that component k was responsible for generating xn.

If we set the derivative of lnp(X|π,µ,Σ) with respect to Σk to zero, and follow

a similar line of reasoning, making use of the result for the maximum likelihood Section 2.3.4 solution for the covariance matrix of a single Gaussian, we obtain

�N

1 Nk

Σk =

γ(znk)(xn − µk)(xn − µk)T (9.19)

n=1

which has the same form as the corresponding result for a single Gaussian ﬁtted to the data set, but again with each data point weighted by the corresponding posterior probability and with the denominator given by the effective number of points associated with the corresponding component.

Finally, we maximize lnp(X|π,µ,Σ) with respect to the mixing coefﬁcients πk. Here we must take account of the constraint (9.9), which requires the mixing

Appendix E coefﬁcients to sum to one. This can be achieved using a Lagrange multiplier and

maximizing the following quantity

lnp(X|π,µ,Σ) + λ� K

πk − 1� (9.20)

�

k=1

which gives

�N

N(xn|µk,Σk)

+ λ (9.21)

0 =

�

j πjN(xn|µj,Σj)

n=1

where again we see the appearance of the responsibilities. If we now multiply both sides by πk and sum over k making use of the constraint (9.9), we ﬁnd λ = −N. Using this to eliminate λ and rearranging we obtain

Nk N

πk =

(9.22)

so that the mixing coefﬁcient for the kth component is given by the average responsibility which that component takes for explaining the data points.

It is worth emphasizing that the results (9.17), (9.19), and (9.22) do not constitute a closed-form solution for the parameters of the mixture model because the responsibilities γ(znk) depend on those parameters in a complex way through (9.13). However, these results do suggest a simple iterative scheme for ﬁnding a solution to the maximum likelihood problem, which as we shall see turns out to be an instance of the EM algorithm for the particular case of the Gaussian mixture model. We ﬁrst choose some initial values for the means, covariances, and mixing coefﬁcients. Then we alternate between the following two updates that we shall call the E step
