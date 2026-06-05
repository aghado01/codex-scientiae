[Page 469]

where the likelihood p(t|w,β) and the prior p(w|α) are given by (3.10) and (3.52), respectively, and y(x,w) is given by (3.3). Taking the expectation with respect to the posterior distribution of w then gives

ln�

�

ln� α 2π� −

�

�

M 2

α 2

N 2

β 2π

E[lnp(t,w|α,β)] =

+

wTw

E

�N

�

�

β 2

(tn − wTφn)2

. (9.62)

−

E

n=1

Setting the derivatives with respect to α to zero, we obtain the M step re-estimation Exercise 9.20 equation

M E[wTw]

M mTNmN + Tr(SN)

α =

=

. (9.63) Exercise 9.21 An analogous result holds for β.

Note that this re-estimation equation takes a slightly different form from the corresponding result (3.92) derived by direct evaluation of the evidence function. However, they each involve computation and inversion (or eigen decomposition) of an M × M matrix and hence will have comparable computational cost per iteration.

These two approaches to determining α should of course converge to the same result (assuming they ﬁnd the same local maximum of the evidence function). This can be veriﬁed by ﬁrst noting that the quantity γ is deﬁned by

�M

1 λi + α

= M − αTr(SN). (9.64)

γ = M − α

i=1

At a stationary point of the evidence function, the re-estimation equation (3.92) will be self-consistently satisﬁed, and hence we can substitute for γ to give

αmTNmN = γ = M − αTr(SN) (9.65) and solving for α we obtain (9.63), which is precisely the EM re-estimation equation.

As a ﬁnal example, we consider a closely related model, namely the relevance vector machine for regression discussed in Section 7.2.1. There we used direct maximization of the marginal likelihood to derive re-estimation equations for the hyperparameters α and β. Here we consider an alternative approach in which we view the weight vector w as a latent variable and apply the EM algorithm. The E step involves ﬁnding the posterior distribution over the weights, and this is given by (7.81). In the M step we maximize the expected complete-data log likelihood, which is deﬁned by

Ew [lnp(t|X,w,β)p(w|α)] (9.66)

where the expectation is taken with respect to the posterior distribution computed using the ‘old’ parameter values. To compute the new parameter values we maximize

Exercise 9.22 with respect to α and β to give
