[Page 278]

take the form

$$
z_j = h \left( \sum_i w_{ji} x_i + w_{j0} \right) \tag{5.113}
$$

while the activations of the output units are given by

$$
y_k = \sum_j w_{kj} z_j + w_{k0}. \tag{5.114}
$$

Suppose we perform a linear transformation of the input data of the form

$$
x_i \rightarrow \widetilde{x}_i = a x_i + b. \tag{5.115}
$$

Then we can arrange for the mapping performed by the network to be unchanged by making a corresponding linear transformation of the weights and biases from the inputs to the units in the hidden layer of the form

$$
w_{ji} \rightarrow \widetilde{w}_{ji} = \frac{1}{a} w_{ji} \tag{5.116}
$$

$$
w_{j0} \rightarrow \widetilde{w}_{j0} = w_{j0} - \frac{b}{a} \sum_i w_{ji}. \tag{5.117}
$$

Similarly, a linear transformation of the output variables of the network of the form

$$
y_k \rightarrow \widetilde{y}_k = c y_k + d \tag{5.118}
$$

can be achieved by making a transformation of the second-layer weights and biases using

$$
w_{kj} \rightarrow \widetilde{w}_{kj} = c w_{kj} \tag{5.119}
$$

$$
w_{k0} \rightarrow \widetilde{w}_{k0} = c w_{k0} + d. \tag{5.120}
$$

If we train one network using the original data and one network using data for which the input and/or target variables are transformed by one of the above linear transformations, then consistency requires that we should obtain equivalent networks that differ only by the linear transformation of the weights as given. Any regularizer should be consistent with this property, otherwise it arbitrarily favours one solution over another, equivalent one. Clearly, simple weight decay (5.112), that treats all weights and biases on an equal footing, does not satisfy this property.

We therefore look for a regularizer which is invariant under the linear transformations (5.116), (5.117), (5.119) and (5.120). These require that the regularizer should be invariant to re-scaling of the weights and to shifts of the biases. Such a regularizer is given by

$$
\frac{\lambda_1}{2} \sum_{w \in \mathcal{W}_1} w^2 + \frac{\lambda_2}{2} \sum_{w \in \mathcal{W}_2} w^2 \tag{5.121}
$$

where $\mathcal{W}_1$ denotes the set of weights in the ﬁrst layer, $\mathcal{W}_2$ denotes the set of weights in the second layer, and biases are excluded from the summations. This regularizer
