[Page 530]

- (c) Evaluate the new posterior by setting the sufﬁcient statistics (moments) of q new ( θ ) equal to those of q \ j ( θ ) f j ( θ ) , including evaluation of the normalization constant

$$
\text {constant} \\ Z _ { j } = \int q ^ { \langle j } ( \theta ) f _ { j } ( \theta ) \, d \theta . & & ( 1 0 . 2 0 6 ) \\ \intertext { s o r t } \text {store the new factor}
$$

- (d) Evaluate and store the new factor

$$
\widetilde { f } _ { j } ( \theta ) = Z _ { j } \frac { q ^ { n e w } ( \theta ) } { q ^ { \wedge j } ( \theta ) } . \\ \text {mation to the model evidence}
$$

4. Evaluate the approximation to the model evidence

$$
\text {proximation to the model evidence} \\ p ( \mathcal { D } ) \simeq \int \lim i t s _ { i } ^ { \widetilde { f } _ { i } ( \theta ) \, d \theta } \quad ( 1 0 . 2 0 8 ) \\ P , \, \text {known as assumed density filtering} \, ( \text {ADF} ) \, \text { or momentum}
$$

A special case of EP, known as assumed density ﬁltering (ADF) or moment matching (Maybeck, 1982; Lauritzen, 1992; Boyen and Koller, 1998; Opper and Winther, 1999), is obtained by initializing all of the approximating factors except the ﬁrst to unity and then making one pass through the factors updating each of them once. Assumed density ﬁltering can be appropriate for on-line learning in which data points are arriving in a sequence and we need to learn from each data point and then discard it before considering the next point. However, in a batch setting we have the opportunity to re-use the data points many times in order to achieve improved accuracy, and it is this idea that is exploited in expectation propagation. Furthermore, if we apply ADF to batch data, the results will have an undesirable dependence on the (arbitrary) order in which the data points are considered, which again EP can overcome.

One disadvantage of expectation propagation is that there is no guarantee that the iterations will converge. However, for approximations q ( θ ) in the exponential family, if the iterations do converge, the resulting solution will be a stationary point of a particular energy function (Minka, 2001a), although each iteration of EP does not necessarily decrease the value of this energy function. This is in contrast to variational Bayes, which iteratively maximizes a lower bound on the log marginal likelihood, in which each iteration is guaranteed not to decrease the bound. It is possible to optimize the EP cost function directly, in which case it is guaranteed to converge, although the resulting algorithms can be slower and more complex to implement.

Another difference between variational Bayes and EP arises from the form of KL divergence that is minimized by the two algorithms, because the former minimizes KL( q p ) whereas the latter minimizes KL( p q ) . As we saw in Figure 10.3, for distributions p ( θ ) which are multimodal, minimizing KL( p q ) can lead to poor approximations. In particular, if EP is applied to mixtures the results are not sensible because the approximation tries to capture all of the modes of the posterior distribution. Conversely, in logistic-type models, EP often out-performs both local variational methods and the Laplace approximation (Kuss and Rasmussen, 2006).
