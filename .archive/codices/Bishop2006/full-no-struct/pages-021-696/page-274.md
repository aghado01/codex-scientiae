[Page 274]

Exercise 5.23

- 2. Both weights in the ﬁrst layer:

$$
\frac { \partial ^ { 2 } E _ { n } } { \partial w _ { j i } ^ { ( 1 ) } \partial w _ { j ^ { \prime } i ^ { \prime } } ^ { ( 1 ) } } & = x _ { i } x _ { i ^ { \prime } } h ^ { \prime \prime } ( a _ { j ^ { \prime } } ) I _ { j j ^ { \prime } } \sum _ { k } w _ { k j ^ { \prime } } ^ { ( 2 ) } \delta _ { k } \\ & + x _ { i } x _ { i ^ { \prime } } h ^ { \prime } ( a _ { j ^ { \prime } } ) h ^ { \prime } ( a _ { j } ) \sum _ { k } \sum _ { k ^ { \prime } } w _ { k ^ { \prime } j ^ { \prime } } ^ { ( 2 ) } w _ { k j } ^ { ( 2 ) } M _ { k k ^ { \prime } } . \\
$$

- 3. One weight in each layer:

$$
3 . \text { One weight in each layer} . \\ \frac { \partial ^ { 2 } E _ { n } } { \partial w _ { j i } ^ { ( 1 ) } \partial w _ { k j ^ { \prime } } ^ { ( 2 ) } } = x _ { i } h ^ { \prime } ( a _ { j ^ { \prime } } ) \left \{ \delta _ { k } I _ { j j ^ { \prime } } + z _ { j } \sum _ { k ^ { \prime } } w _ { k ^ { \prime } j ^ { \prime } } ^ { ( 2 ) } H _ { k k ^ { \prime } } \right \} .
$$

Here I jj is the j,j element of the identity matrix. If one or both of the weights is a bias term, then the corresponding expressions are obtained simply by setting the appropriate activation(s) to 1 . Inclusion of skip-layer connections is straightforward.

# 5.4.6 Fast multiplication by the Hessian

For many applications of the Hessian, the quantity of interest is not the Hessian matrix H itself but the product of H with some vector v . We have seen that the evaluation of the Hessian takes O ( W 2 ) operations, and it also requires storage that is O ( W 2 ) . The vector v T H that we wish to calculate, however, has only W elements, so instead of computing the Hessian as an intermediate step, we can instead try to ﬁnd an efﬁcient approach to evaluating v T H directly in a way that requires only O ( W ) operations.

To do this, we ﬁrst note that

$$
v ^ { T } H = v ^ { T } \nabla ( \nabla E )
$$

where ∇ denotes the gradient operator in weight space. We can then write down the standard forward-propagation and backpropagation equations for the evaluation of ∇ E and apply (5.96) to these equations to give a set of forward-propagation and backpropagation equations for the evaluation of v T H (Møller, 1993; Pearlmutter, 1994). This corresponds to acting on the original forward-propagation and backpropagation equations with a differential operator v T ∇ . Pearlmutter (1994) used the notation R{·} to denote the operator v T ∇ , and we shall follow this convention. The analysis is straightforward and makes use of the usual rules of differential calculus, together with the result

$$
\mathcal { R } \{ w \} & = v . & ( 5 . 9 7 ) \\ \intertext { w l } \Omega ( w ) & = \Omega ^ { 2 } . & 1 + \Omega ^ { 2 }
$$

The technique is best illustrated with a simple example, and again we choose a two-layer network of the form shown in Figure 5.1, with linear output units and a sum-of-squares error function. As before, we consider the contribution to the error function from one pattern in the data set. The required vector is then obtained as
