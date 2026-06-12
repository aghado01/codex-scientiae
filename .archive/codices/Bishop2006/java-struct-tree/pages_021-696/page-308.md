[Page 308]

components of the weight vector parallel to the eigenvectors of the Hessian satisfy

wj(τ) � wj� when ηj � (ρτ)−1 (5.199) |wj(τ)| � |wj�| when ηj � (ρτ)−1. (5.200)

Compare this result with the discussion in Section 3.5.3 of regularization with simple weight decay, and hence show that (ρτ)−1 is analogous to the regularization parameter λ. The above results also show that the effective number of parameters in the network, as deﬁned by (3.91), grows as the training progresses.

5.26 (��) Consider a multilayer perceptron with arbitrary feed-forward topology, which is to be trained by minimizing the tangent propagation error function (5.127) in which the regularizing function is given by (5.128). Show that the regularization term Ω can be written as a sum over patterns of terms of the form

1 2 �

(Gyk)2 (5.201)

Ωn =

k

where G is a differential operator deﬁned by

G ≡ �

∂ ∂xi

. (5.202)

τi

i

By acting on the forward propagation equations

�

zj = h(aj), aj =

wjizi (5.203)

i

with the operator G, show that Ωn can be evaluated by forward propagation using the following equations:

�

αj = h�(aj)βj, βj =

wjiαi. (5.204)

i

where we have deﬁned the new variables

αj ≡ Gzj, βj ≡ Gaj. (5.205)

Now show that the derivatives of Ωn with respect to a weight wrs in the network can be written in the form

�

∂Ωn ∂wrs

=

αk {φkrzs + δkrαs} (5.206)

k

where we have deﬁned

∂yk ∂ar

, φkr ≡ Gδkr. (5.207)

δkr ≡

Write down the backpropagation equations for δkr, and hence derive a set of backpropagation equations for the evaluation of the φkr.
