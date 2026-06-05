[Page 290]

Recall that the simple weight decay regularizer, given in (5.112), can be viewed as the negative log of a Gaussian prior distribution over the weights. We can encourage the weight values to form several groups, rather than just one group, by consid-

Section 2.3.9 ering instead a probability distribution that is a mixture of Gaussians. The centres and variances of the Gaussian components, as well as the mixing coefﬁcients, will be considered as adjustable parameters to be determined as part of the learning process. Thus, we have a probability density of the form

�

p(w) =

p(wi) (5.136)

i

where

�M

p(wi) =

πjN(wi|µj,σj2) (5.137)

j=1

and πj are the mixing coefﬁcients. Taking the negative logarithm then leads to a regularization function of the form

ln� M

πjN(wi|µj,σj2)�. (5.138)

Ω(w) = −�

�

i

j=1

The total error function is then given by

E�(w) = E(w) + λΩ(w) (5.139)

where λ is the regularization coefﬁcient. This error is minimized both with respect to the weights wi and with respect to the parameters {πj,µj,σj} of the mixture model. If the weights were constant, then the parameters of the mixture model could be determined by using the EM algorithm discussed in Chapter 9. However, the distribution of weights is itself evolving during the learning process, and so to avoid numerical instability, a joint optimization is performed simultaneously over the weights and the mixture-model parameters. This can be done using a standard optimization algorithm such as conjugate gradients or quasi-Newton methods.

In order to minimize the total error function, it is necessary to be able to evaluate its derivatives with respect to the various adjustable parameters. To do this it is convenient to regard the {πj} as prior probabilities and to introduce the corresponding posterior probabilities which, following (2.192), are given by Bayes’ theorem in the form

πjN(w|µj,σj2)

γj(w) =

. (5.140)

�

k πkN(w|µk,σk2)

The derivatives of the total error function with respect to the weights are then given Exercise 5.29 by

+ λ�

∂E� ∂wi

(wi − µj) σj2

∂E ∂wi

=

γj(wi)

. (5.141)

j
