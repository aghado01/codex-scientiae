[Page 295]

directly by the network output activations

###### µkj(x) = aµkj. (5.152)

The adaptive parameters of the mixture density network comprise the vector w of weights and biases in the neural network, that can be set by maximum likelihood, or equivalently by minimizing an error function deﬁned to be the negative logarithm of the likelihood. For independent data, this error function takes the form

N

ln

E(w) = −

n=1

k

πk(xn,w)N tn|µk(xn,w),σk2(xn,w) (5.153)

k=1

where we have made the dependencies on w explicit.

In order to minimize the error function, we need to calculate the derivatives of the error E(w) with respect to the components of w. These can be evaluated by using the standard backpropagation procedure, provided we obtain suitable expressions for the derivatives of the error with respect to the output-unit activations. These represent error signals δ for each pattern and for each output unit, and can be backpropagated to the hidden units and the error function derivatives evaluated in the usual way. Because the error function (5.153) is composed of a sum of terms, one for each training data point, we can consider the derivatives for a particular pattern n and then ﬁnd the derivatives of E by summing over all patterns.

Because we are dealing with mixture distributions, it is convenient to view the

mixing coefﬁcients πk(x) as x-dependent prior probabilities and to introduce the corresponding posterior probabilities given by

πkNnk K l=1 πlNnl

γk(t|x) =

(5.154)

where Nnk denotes N (tn|µk(xn),σk2(xn)). The derivatives with respect to the network output activations governing the mix-

- Exercise 5.34 ing coefﬁcients are given by ∂En

∂aπk

= πk − γk. (5.155) Similarly, the derivatives with respect to the output activations controlling the com-

- Exercise 5.35 ponent means are given by ∂En

∂aµkl

= γk

µkl − tl σk2

. (5.156)

Finally, the derivatives with respect to the output activations controlling the compo-

- Exercise 5.36 nent variances are given by


∂En ∂aσk

= −γk

1 σk

t − µk 2

σk3 −

. (5.157)
