[Page 370]

###### t

|2<br><br>C|t|
|---|---|
| |t|


1

###### t

|2<br><br>C<br><br>ϕ|t|
|---|---|
| |t|


1

- Figure 7.10 Illustration of the mechanism for sparsity in a Bayesian linear regression model, showing a training set vector of target values given by t = (t1, t2)T, indicated by the cross, for a model with one basis vector


ϕ = (φ(x1), φ(x2))T, which is poorly aligned with the target data vector t. On the left we see a model having only isotropic noise, so that C = β−1I, corresponding to α = ∞, with β set to its most probable value. On the right we see the same model but with a ﬁnite value of α. In each case the red ellipse corresponds to unit Mahalanobis distance, with |C| taking the same value for both plots, while the dashed green circle shows the contrition arising from the noise term β−1. We see that any ﬁnite value of α reduces the probability of the observed data, and so for the most probable solution the basis vector is removed.

the mechanism of sparsity in the context of the relevance vector machine. In the process, we will arrive at a signiﬁcantly faster procedure for optimizing the hyperparameters compared to the direct techniques given above.

Before proceeding with a mathematical analysis, we ﬁrst give some informal insight into the origin of sparsity in Bayesian linear models. Consider a data set comprising N = 2 observations t1 and t2, together with a model having a single basis function φ(x), with hyperparameter α, along with isotropic noise having precision β. From (7.85), the marginal likelihood is given by p(t|α,β) = N(t|0,C) in which the covariance matrix takes the form

1 α

1 β

I +

C =

ϕϕT (7.92)

where ϕ denotes the N-dimensional vector (φ(x1),φ(x2))T, and similarly t = (t1,t2)T. Notice that this is just a zero-mean Gaussian process model over t with covariance C. Given a particular observation for t, our goal is to ﬁnd α and β by maximizing the marginal likelihood. We see from Figure 7.10 that, if there is a poor alignment between the direction of ϕ and that of the training data vector t, then the corresponding hyperparameter α will be driven to ∞, and the basis vector will be pruned from the model. This arises because any ﬁnite value for α will always assign a lower probability to the data, thereby decreasing the value of the density at t, provided that β is set to its optimal value. We see that any ﬁnite value for α would cause the distribution to be elongated in a direction away from the data, thereby increasing the probability mass in regions away from the observed data and hence reducing the value of the density at the target data vector itself. For the more general case of M
