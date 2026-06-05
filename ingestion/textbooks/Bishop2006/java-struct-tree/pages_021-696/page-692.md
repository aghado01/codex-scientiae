[Page 692]

The M step involves maximization of this function with respect to θ, keeping θold, and hence γnk, ﬁxed. Maximization with respect to πk can be done in the usual way, with a Lagrange multiplier to enforce the summation constraint

�

k πk = 1, giving the familiar result

�N

1 N

πk =

γnk. (14.50)

n=1

To determine the {wk}, we note that the Q(θ,θold) function comprises a sum over terms indexed by k each of which depends only on one of the vectors wk, so that the different vectors are decoupled in the M step of the EM algorithm. In other words, the different components interact only via the responsibilities, which are ﬁxed during the M step. Note that the M step does not have a closed-form solution and must be solved iteratively using, for instance, the iterative reweighted least squares

Section 4.3.3 (IRLS) algorithm. The gradient and the Hessian for the vector wk are given by

�N

∇kQ =

γnk(tn − ynk)φn (14.51)

n=1

�N

Hk = −∇k∇kQ =

γnkynk(1 − ynk)φnφTn (14.52)

n=1

where ∇k denotes the gradient with respect to wk. For ﬁxed γnk, these are independent of {wj} for j �= k and so we can solve for each wk separately using the IRLS

Section 4.3.3 algorithm. Thus the M-step equations for component k correspond simply to ﬁtting a single logistic regression model to a weighted data set in which data point n carries a weight γnk. Figure 14.10 shows an example of the mixture of logistic regression models applied to a simple classiﬁcation problem. The extension of this model to a

Exercise 14.16 mixture of softmax models for more than two classes is straightforward.

14.5.3 Mixtures of experts

In Section 14.5.1, we considered a mixture of linear regression models, and in Section 14.5.2 we discussed the analogous mixture of linear classiﬁers. Although these simple mixtures extend the ﬂexibility of linear models to include more complex (e.g., multimodal) predictive distributions, they are still very limited. We can further increase the capability of such models by allowing the mixing coefﬁcients themselves to be functions of the input variable, so that

�K

πk(x)pk(t|x). (14.53)

p(t|x) =

k=1

This is known as a mixture of experts model (Jacobs et al., 1991) in which the mixing coefﬁcients πk(x) are known as gating functions and the individual component densities pk(t|x) are called experts. The notion behind the terminology is that different components can model the distribution in different regions of input space (they
