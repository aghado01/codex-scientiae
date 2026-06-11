[Page 295]

directly by the network output activations

$$
\mu _ { k j } ( x ) = a _ { k j } ^ { \mu } .
$$

The adaptive parameters of the mixture density network comprise the vector w of weights and biases in the neural network, that can be set by maximum likelihood, or equivalently by minimizing an error function deﬁned to be the negative logarithm of the likelihood. For independent data, this error function takes the form

$$
0 \text { or } \text {IncnumDec. For } & \text {independent data, thus error function takes the form } \\ E ( w ) = - \sum _ { n = 1 } ^ { N } \ln \left \{ \sum _ { k = 1 } ^ { k } \pi _ { k } ( x _ { n } , w ) \mathcal { N } \left ( t _ { n } | \mu _ { k } ( x _ { n } , w ) , \sigma _ { k } ^ { 2 } ( x _ { n } , w ) \right ) \right \} \\ \text {where we have made the dependencies on } w \text { explicit.}
$$

where we have made the dependencies on w explicit.

In order to minimize the error function, we need to calculate the derivatives of the error E ( w ) with respect to the components of w . These can be evaluated by using the standard backpropagation procedure, provided we obtain suitable expressions for the derivatives of the error with respect to the output-unit activations. These represent error signals δ for each pattern and for each output unit, and can be backpropagated to the hidden units and the error function derivatives evaluated in the usual way. Because the error function (5.153) is composed of a sum of terms, one for each training data point, we can consider the derivatives for a particular pattern n and then ﬁnd the derivatives of E by summing over all patterns.

Because we are dealing with mixture distributions, it is convenient to view the mixing coefﬁcients π k ( x ) as x -dependent prior probabilities and to introduce the corresponding posterior probabilities given by

$$
\gamma _ { k } ( t | x ) = \frac { \pi _ { k } \mathcal { N } _ { n k } } { \sum _ { l = 1 } ^ { K } \pi _ { l } \mathcal { N } _ { n l } } \\ \mathcal { N } ( t _ { n } | \mu _ { k } ( x _ { n } ) , \sigma _ { k } ^ { 2 } ( x _ { n } ) ) .
$$

where N nk denotes N ( t n | µ k ( x n ) , σ 2 k ( x n )) .

The derivatives with respect to the network output activations governing the mixing coefficients are given by

$$
\frac { \partial E _ { n } } { \partial a _ { k } ^ { \pi } } = \pi _ { k } - \gamma _ { k } .
$$

Similarly, the derivatives with respect to the output activations controlling the component means are given by Exercise 5.35

$$
\frac { \partial E _ { n } } { \partial a _ { k l } ^ { \mu } } = \gamma _ { k } \left \{ \frac { \mu _ { k l } - t _ { l } } { \sigma _ { k } ^ { 2 } } \right \} .
$$

Finally, the derivatives with respect to the output activations controlling the component variances are given by Exercise 5.36

$$
\frac { \partial E _ { n } } { \partial a _ { k } ^ { \sigma } } = - \gamma _ { k } \left \{ \frac { \| t - \mu _ { k } \| ^ { 2 } } { \sigma _ { k } ^ { 3 } } - \frac { 1 } { \sigma _ { k } } \right \} .
$$
