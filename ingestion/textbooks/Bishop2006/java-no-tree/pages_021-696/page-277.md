[Page 277]

|M = 1<br><br>|
|---|


|M = 3<br><br>|
|---|


|M = 10<br><br>|
|---|


- 0
- 1


- 0
- 1


- 0
- 1


−1

−1

−1

0 1

0 1

0 1

Figure 5.9 Examples of two-layer networks trained on 10 data points drawn from the sinusoidal data set. The graphs show the result of ﬁtting networks having M = 1, 3 and 10 hidden units, respectively, by minimizing a sum-of-squares error function using a scaled conjugate-gradient algorithm.

of the form

λ 2

E(w) = E(w) +

wTw. (5.112)

This regularizer is also known as weight decay and has been discussed at length in Chapter 3. The effective model complexity is then determined by the choice of the regularization coefﬁcient λ. As we have seen previously, this regularizer can be interpreted as the negative logarithm of a zero-mean Gaussian prior distribution over the weight vector w.

###### 5.5.1 Consistent Gaussian priors

One of the limitations of simple weight decay in the form (5.112) is that is inconsistent with certain scaling properties of network mappings. To illustrate this, consider a multilayer perceptron network having two layers of weights and linear output units, which performs a mapping from a set of input variables {xi} to a set of output variables {yk}. The activations of the hidden units in the ﬁrst hidden layer

Figure 5.10 Plot of the sum-of-squares test-set error for the polynomial data set versus the number of hidden units in the network, with 30 random starts for each network size, showing the effect of local minima. For each new start, the weight vector was initialized by sampling from an isotropic Gaussian distribution having a mean of zero and a variance of 10.

| |
|---|


160

140

120

100

80

60

0 2 4 6 8 10
