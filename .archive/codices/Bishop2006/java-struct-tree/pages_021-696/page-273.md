[Page 273]

Again, by using a symmetrical central differences formulation, we ensure that the residual errors are O(�2) rather than O(�). Because there are W2 elements in the Hessian matrix, and because the evaluation of each element requires four forward propagations each needing O(W) operations (per pattern), we see that this approach will require O(W3) operations to evaluate the complete Hessian. It therefore has poor scaling properties, although in practice it is very useful as a check on the software implementation of backpropagation methods.

A more efﬁcient version of numerical differentiation can be found by applying central differences to the ﬁrst derivatives of the error function, which are themselves calculated using backpropagation. This gives

�

(wlk − �)� + O(�2). (5.91)

1 2�

∂2E ∂wji∂wlk

∂E ∂wji

∂E ∂wji

=

(wlk + �) −

Because there are now only W weights to be perturbed, and because the gradients can be evaluated in O(W) steps, we see that this method gives the Hessian in O(W2) operations.

5.4.5 Exact evaluation of the Hessian

So far, we have considered various approximation schemes for evaluating the Hessian matrix or its inverse. The Hessian can also be evaluated exactly, for a network of arbitrary feed-forward topology, using extension of the technique of backpropagation used to evaluate ﬁrst derivatives, which shares many of its desirable features including computational efﬁciency (Bishop, 1991; Bishop, 1992). It can be applied to any differentiable error function that can be expressed as a function of the network outputs and to networks having arbitrary differentiable activation functions. The number of computational steps needed to evaluate the Hessian scales like O(W2). Similar algorithms have also been considered by Buntine and Weigend (1993).

Here we consider the speciﬁc case of a network having two layers of weights,

Exercise 5.22 for which the required equations are easily derived. We shall use indices i and i� to denote inputs, indices j and j� to denoted hidden units, and indices k and k� to denote outputs. We ﬁrst deﬁne

∂2En ∂ak∂ak�

∂En ∂ak

δk =

, Mkk� ≡

(5.92)

where En is the contribution to the error from data point n. The Hessian matrix for this network can then be considered in three separate blocks as follows.

1. Both weights in the second layer:

∂2En ∂wkj(2)∂wk(2)�j�

= zjzj�Mkk�. (5.93)
