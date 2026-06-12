[Page 268]

associated with the inputs to be propagated through the trained network in order to estimate their contribution ∆yk to the errors at the outputs, through the relation

∆yk

i

∂yk ∂xi

∆xi (5.72)

which is valid provided the |∆xi| are small. In general, the network mapping represented by a trained neural network will be nonlinear, and so the elements of the Jacobian matrix will not be constants but will depend on the particular input vector used. Thus (5.72) is valid only for small perturbations of the inputs, and the Jacobian itself must be re-evaluated for each new input vector.

The Jacobian matrix can be evaluated using a backpropagation procedure that is similar to the one derived earlier for evaluating the derivatives of an error function with respect to the weights. We start by writing the element Jki in the form

∂yk ∂xi

Jki =

=

=

j

j

∂aj ∂xi

∂yk ∂aj

∂yk ∂aj

wji

(5.73)

where we have made use of (5.48). The sum in (5.73) runs over all units j to which the input unit i sends connections (for example, over all units in the ﬁrst hidden layer in the layered topology considered earlier). We now write down a recursive backpropagation formula to determine the derivatives ∂yk/∂aj

∂yk ∂aj

∂yk ∂al

∂al ∂aj

=

l

∂yk ∂al

= h (aj)

wlj

l

(5.74)

where the sum runs over all units l to which unit j sends connections (corresponding to the ﬁrst index of wlj). Again, we have made use of (5.48) and (5.49). This backpropagation starts at the output units for which the required derivatives can be found directly from the functional form of the output-unit activation function. For instance, if we have individual sigmoidal activation functions at each output unit, then

∂yk ∂aj

= δkjσ (aj) (5.75) whereas for softmax outputs we have

∂yk ∂aj

= δkjyk − ykyj. (5.76)

We can summarize the procedure for evaluating the Jacobian matrix as follows. Apply the input vector corresponding to the point in input space at which the Jacobian matrix is to be found, and forward propagate in the usual way to obtain the
