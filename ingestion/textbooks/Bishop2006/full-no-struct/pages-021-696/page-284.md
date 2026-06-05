[Page 284]

# Exercise 5.26

will be one-dimensional, and will be parameterized by ξ . Let the vector that results from acting on x n by this transformation be denoted by s ( x n ,ξ ) , which is deﬁned so that s ( x , 0) = x . Then the tangent to the curve M is given by the directional derivative τ = ∂ s /∂ξ , and the tangent vector at the point x n is given by

$$
\xi , \, \text {and the tangent vector at the point} \, x _ { n } \text { is given by} \\ \tau _ { n } = \frac { \partial s ( x _ { n } , \xi ) } { \partial \xi } \Big | _ { \xi = 0 } \quad . \\ \intertext { o n o f the input vector, the network output vector will, in general, } \text {e of output } k \text { with respect to } \xi \text { is given by}
$$

Under a transformation of the input vector, the network output vector will, in general, change. The derivative of output k with respect to ξ is given by

$$
& \text {the derivative of output } k \text { with respect to } \xi \text { is given by} \\ & \quad \frac { \partial y _ { k } } { \partial \xi } \Big | _ { \xi = 0 } = \sum _ { i = 1 } ^ { D } \frac { \partial y _ { k } } { \partial x _ { i } } \frac { \partial x _ { i } } { \partial \xi } \Big | _ { \xi = 0 } = \sum _ { i = 1 } ^ { D } J _ { k i } \tau _ { i } \\ & \text {is the } ( k , i ) \text { element of the Jacobian matrix } J , \text { as discussed in Section } 5 . 3 . 4 . \\ & ( 5 . 1 2 6 ) \text { can be used to modify the standard error function, so as to encour-}
$$

where J ki is the ( k,i ) element of the Jacobian matrix J , as discussed in Section 5.3.4. The result (5.126) can be used to modify the standard error function, so as to encourage local invariance in the neighbourhood of the data points, by the addition to the original error function E of a regularization function Ω to give a total error function of the form

$$
\widetilde { E } = E + \lambda \Omega \\ \text { coefficient and} \\
$$

where λ is a regularization coefﬁcient and

$$
\text {where } x \, \text { is a regularisation coefficient and} \\ \Omega = \frac { 1 } { 2 } \sum _ { n } \sum _ { k } \left ( \frac { \partial y _ { n k } } { \partial \xi } \Big | _ { \xi = 0 } \right ) ^ { 2 } = \frac { 1 } { 2 } \sum _ { n } \sum _ { k } \left ( \sum _ { i = 1 } ^ { D } J _ { n k i } \tau _ { n i } \right ) ^ { 2 } . \quad ( 5 . 1 8 ) \\ \text {The regularization function will be zero when the network mapping function is in-
variant under the transformation in the neighbourhood of each pattern vector, and}
$$

The regularization function will be zero when the network mapping function is invariant under the transformation in the neighbourhood of each pattern vector, and the value of the parameter λ determines the balance between ﬁtting the training data and learning the invariance property.

In a practical implementation, the tangent vector τ n can be approximated using ﬁnite differences, by subtracting the original vector x n from the corresponding vector after transformation using a small value of ξ , and then dividing by ξ . This is illustrated in Figure 5.16.

The regularization function depends on the network weights through the Jacobian J . A backpropagation formalism for computing the derivatives of the regularizer with respect to the network weights is easily obtained by extension of the techniques introduced in Section 5.3.

If the transformation is governed by L parameters (e.g., L = 3 for the case of translations combined with in-plane rotations in a two-dimensional image), then the manifold M will have dimensionality L , and the corresponding regularizer is given by the sum of terms of the form (5.128), one for each transformation. If several transformations are considered at the same time, and the network mapping is made invariant to each separately, then it will be (locally) invariant to combinations of the transformations (Simard et al. , 1992).
