[Page 456]

# Section 2.3.4

Appendix E

We can interpret N k as the effective number of points assigned to cluster k . Note carefully the form of this solution. We see that the mean µ k for the k th Gaussian component is obtained by taking a weighted mean of all of the points in the data set, in which the weighting factor for data point x n is given by the posterior probability γ ( z nk ) that component k was responsible for generating x n . If we set the derivative of ln ( X Σ ) with respect to Σ to zero, and follow

p | π , µ , k a similar line of reasoning, making use of the result for the maximum likelihood solution for the covariance matrix of a single Gaussian, we obtain

$$
\Sigma _ { k } = \frac { 1 } { N _ { k } } \sum _ { n = 1 } ^ { N } \gamma ( z _ { n k } ) ( x _ { n } - \mu _ { k } ) ( x _ { n } - \mu _ { k } ) ^ { T } \\ \text {as the same form as the corresponding result for a single Gaussian fitted to}
$$

which has the same form as the corresponding result for a single Gaussian ﬁtted to the data set, but again with each data point weighted by the corresponding posterior probability and with the denominator given by the effective number of points associated with the corresponding component.

Finally, we maximize ln p ( X | π , µ , Σ ) with respect to the mixing coefﬁcients π k . Here we must take account of the constraint (9.9), which requires the mixing coefﬁcients to sum to one. This can be achieved using a Lagrange multiplier and maximizing the following quantity

$$
\text {Inc} \text { for } \text {quint} y \\ \ln p ( X | \pi , \mu , \Sigma ) + \lambda \left ( \sum _ { k = 1 } ^ { K } \pi _ { k } - 1 \right )
$$

which gives

$$
0 = \sum _ { n = 1 } ^ { N } \frac { \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) } { \sum _ { j } \pi _ { j } \mathcal { N } ( x _ { n } | \mu _ { j } , \Sigma _ { j } ) } + \lambda \\ \text {we see the appearance of the responsibilities. If we now multiply both} \\ \text {and sum over $k$ making use of the constraint $(9,9)$, we find $\lambda = - N$.}
$$

where again we see the appearance of the responsibilities. If we now multiply both sides by π k and sum over k making use of the constraint (9.9), we ﬁnd λ = − N . Using this to eliminate λ and rearranging we obtain

$$
\pi _ { k } = \frac { N _ { k } } { N }
$$

so that the mixing coefﬁcient for the k th component is given by the average responsibility which that component takes for explaining the data points.

It is worth emphasizing that the results (9.17), (9.19), and (9.22) do not constitute a closed-form solution for the parameters of the mixture model because the responsibilities γ ( z nk ) depend on those parameters in a complex way through (9.13). However, these results do suggest a simple iterative scheme for ﬁnding a solution to the maximum likelihood problem, which as we shall see turns out to be an instance of the EM algorithm for the particular case of the Gaussian mixture model. We ﬁrst choose some initial values for the means, covariances, and mixing coefﬁcients. Then we alternate between the following two updates that we shall call the E step
