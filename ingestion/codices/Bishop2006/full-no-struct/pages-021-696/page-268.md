[Page 268]

$$
\Delta y _ { k } \simeq \sum _ { i } \frac { \partial y _ { k } } { \partial x _ { i } } \Delta x _ { i } & & ( 5 . 7 2 ) \\ \intertext { d e f t h e l $ \left | \Delta x _ { i } \right | \text { are small. In general, the network mapping rep-} }
$$

which is valid provided the | ∆ x i | are small. In general, the network mapping represented by a trained neural network will be nonlinear, and so the elements of the Jacobian matrix will not be constants but will depend on the particular input vector used. Thus (5.72) is valid only for small perturbations of the inputs, and the Jacobian itself must be re-evaluated for each new input vector.

The Jacobian matrix can be evaluated using a backpropagation procedure that is similar to the one derived earlier for evaluating the derivatives of an error function with respect to the weights. We start by writing the element J ki in the form

$$
\text {the weights. We start by writing the element } J _ { k i } \text { in the form } \\ J _ { k i } = \frac { \partial y _ { k } } { \partial x _ { i } } \ = \ \sum _ { j } \frac { \partial y _ { k } } { \partial a _ { j } } \frac { \partial a _ { j } } { \partial x _ { i } } \\ = \ \sum _ { j } w _ { j i } \frac { \partial y _ { k } } { \partial a _ { j } } & & ( 5 . 7 3 ) \\ \text {made use of } ( 5 . 4 8 ) . \text { The sum in } ( 5 . 7 3 ) \ r u n s \, o r \, a l l \, u n i t s \ j \, t o \, \text {which}
$$

where we have made use of (5.48). The sum in (5.73) runs over all units j to which the input unit i sends connections (for example, over all units in the ﬁrst hidden layer in the layered topology considered earlier). We now write down a recursive backpropagation formula to determine the derivatives ∂y k /∂a j

$$
\text {formula to determine the derivatives $\partial y_{k}/\partial a_{j}$} \\ \frac { \partial y _ { k } } { \partial a _ { j } } & \ = \ \sum _ { l } \frac { \partial y _ { k } } { \partial a _ { l } } \frac { \partial a _ { l } } { \partial a _ { j } } \\ & = \ \ h ^ { \prime } ( a _ { j } ) \sum _ { l } w _ { l j } \frac { \partial y _ { k } } { \partial a _ { l } } \\ \intertext { s u n s o r e a l l u n i s l t o w i c h u i n t j s e n d s e n c t i o n s ( c o r r e s p o n d i g }
$$

where the sum runs over all units l to which unit j sends connections (corresponding to the ﬁrst index of w lj ). Again, we have made use of (5.48) and (5.49). This backpropagation starts at the output units for which the required derivatives can be found directly from the functional form of the output-unit activation function. For instance, if we have individual sigmoidal activation functions at each output unit, then ∂y

$$
\frac { \partial y _ { k } } { \partial a _ { j } } = \delta _ { k j } \sigma ^ { \prime } ( a _ { j } )
$$

whereas for softmax outputs we have

$$
\frac { \partial y _ { k } } { \partial a _ { j } } = \delta _ { k j } y _ { k } - y _ { k } y _ { j } .
$$

We can summarize the procedure for evaluating the Jacobian matrix as follows. Apply the input vector corresponding to the point in input space at which the Jacobian matrix is to be found, and forward propagate in the usual way to obtain the
