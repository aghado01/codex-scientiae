[Page 278]

# Exercise 5.24

take the form

$$
z _ { j } = h \left ( \sum _ { i } w _ { j i } x _ { i } + w _ { j 0 } \right ) \\ \text {ons of the output units are given by}
$$

while the activations of the output units are given by

$$
y _ { k } = \sum _ { j } w _ { k j } z _ { j } + w _ { k 0 } . \\ \intertext { a l i n e r t o p a t u r $ d x $ } \intertext { i n t h e r $ y _ { k } = \sum _ { j } w _ { k j } z _ { j } + w _ { k 0 } . }
$$

Suppose we perform a linear transformation of the input data of the form

x i → x i = ax i + b. (5.115) Then we can arrange for the mapping performed by the network to be unchanged by making a corresponding linear transformation of the weights and biases from the inputs to the units in the hidden layer of the form

$$
w _ { j i } \rightarrow \widetilde { w } _ { j i } \ = \ \frac { 1 } { a } w _ { j i } \quad \\
$$

$$
w _ { j i } & \rightarrow \widetilde { w } _ { j i } \quad = \quad \frac { 1 } { a } w _ { j i } & & ( 5 . 1 1 6 ) \\ w _ { j 0 } & \rightarrow \widetilde { w } _ { j 0 } \quad = \quad w _ { j 0 } - \frac { b } { a } \sum _ { i } w _ { j i } . & & ( 5 . 1 1 7 ) \\ \text {near transformation of the output variables of the network of the form}
$$

Similarly, a linear transformation of the output variables of the network of the form

y k → y k = cy k + d (5.118) can be achieved by making a transformation of the second-layer weights and biases using

w kj → w kj = cw kj (5.119) w k 0 → w k 0 = cw k 0 + d. (5.120) If we train one network using the original data and one network using data for which the input and/or target variables are transformed by one of the above linear transformations, then consistency requires that we should obtain equivalent networks that differ only by the linear transformation of the weights as given. Any regularizer should be consistent with this property, otherwise it arbitrarily favours one solution over another, equivalent one. Clearly, simple weight decay (5.112), that treats all weights and biases on an equal footing, does not satisfy this property.

We therefore look for a regularizer which is invariant under the linear transformations (5.116), (5.117), (5.119) and (5.120). These require that the regularizer should be invariant to re-scaling of the weights and to shifts of the biases. Such a regularizer is given by

$$
\intertext { n b y } \frac { \lambda _ { 1 } } { 2 } \sum _ { w \in \mathcal { W } _ { 1 } } w ^ { 2 } + \frac { \lambda _ { 2 } } { 2 } \sum _ { w \in \mathcal { W } _ { 2 } } w ^ { 2 } \\ \intertext { s t e s t o f w e i g h t s } \intertext { i n t h e r s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext { w i t h e s } \intertext { s t e d o n t e s } \intertext {
$$

where W 1 denotes the set of weights in the ﬁrst layer, W 2 denotes the set of weights in the second layer, and biases are excluded from the summations. This regularizer
