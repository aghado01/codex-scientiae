[Page 278]

take the form

wjixi + wj0� (5.113) while the activations of the output units are given by

zj = h�

�

i

�

yk =

wkjzj + wk0. (5.114)

j

Suppose we perform a linear transformation of the input data of the form

xi → �xi = axi + b. (5.115)

Then we can arrange for the mapping performed by the network to be unchanged by making a corresponding linear transformation of the weights and biases from the

Exercise 5.24 inputs to the units in the hidden layer of the form

1 a

wji → w�ji =

wji (5.116) wj0 → w�j0 = wj0 −

b a �

wji. (5.117)

i

Similarly, a linear transformation of the output variables of the network of the form

yk → �yk = cyk + d (5.118)

can be achieved by making a transformation of the second-layer weights and biases using

wkj → w�kj = cwkj (5.119) wk0 → w�k0 = cwk0 + d. (5.120)

If we train one network using the original data and one network using data for which the input and/or target variables are transformed by one of the above linear transformations, then consistency requires that we should obtain equivalent networks that differ only by the linear transformation of the weights as given. Any regularizer should be consistent with this property, otherwise it arbitrarily favours one solution over another, equivalent one. Clearly, simple weight decay (5.112), that treats all weights and biases on an equal footing, does not satisfy this property.

We therefore look for a regularizer which is invariant under the linear transformations (5.116), (5.117), (5.119) and (5.120). These require that the regularizer should be invariant to re-scaling of the weights and to shifts of the biases. Such a regularizer is given by

2 �

2 �

λ2

λ1

w2 +

w2 (5.121)

w∈W1

w∈W2

where W1 denotes the set of weights in the ﬁrst layer, W2 denotes the set of weights in the second layer, and biases are excluded from the summations. This regularizer
