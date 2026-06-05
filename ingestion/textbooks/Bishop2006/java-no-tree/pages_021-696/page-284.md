[Page 284]

will be one-dimensional, and will be parameterized by ξ. Let the vector that results from acting on xn by this transformation be denoted by s(xn,ξ), which is deﬁned so that s(x,0) = x. Then the tangent to the curve M is given by the directional derivative τ = ∂s/∂ξ, and the tangent vector at the point xn is given by

τn =

∂s(xn,ξ) ∂ξ ξ=0

. (5.125)

Under a transformation of the input vector, the network output vector will, in general, change. The derivative of output k with respect to ξ is given by

∂yk ∂ξ ξ=0

=

D

D

∂yk ∂xi

∂xi ∂ξ

=

Jkiτi (5.126)

i=1

i=1

ξ=0

where Jki is the (k,i) element of the Jacobian matrix J, as discussed in Section 5.3.4. The result (5.126) can be used to modify the standard error function, so as to encourage local invariance in the neighbourhood of the data points, by the addition to the original error function E of a regularization function Ω to give a total error function of the form

E = E + λΩ (5.127) where λ is a regularization coefﬁcient and

1 2 n

Ω =

k

∂ynk ∂ξ ξ=0

2

1 2 n

=

k

D

Jnkiτni

i=1

2

. (5.128)

The regularization function will be zero when the network mapping function is invariant under the transformation in the neighbourhood of each pattern vector, and the value of the parameter λ determines the balance between ﬁtting the training data and learning the invariance property.

In a practical implementation, the tangent vector τn can be approximated using ﬁnite differences, by subtracting the original vector xn from the corresponding vector after transformation using a small value of ξ, and then dividing by ξ. This is illustrated in Figure 5.16.

The regularization function depends on the network weights through the Jacobian J. A backpropagation formalism for computing the derivatives of the regu-

- Exercise 5.26 larizer with respect to the network weights is easily obtained by extension of the techniques introduced in Section 5.3.


If the transformation is governed by L parameters (e.g., L = 3 for the case of translations combined with in-plane rotations in a two-dimensional image), then the manifold M will have dimensionality L, and the corresponding regularizer is given by the sum of terms of the form (5.128), one for each transformation. If several transformations are considered at the same time, and the network mapping is made invariant to each separately, then it will be (locally) invariant to combinations of the transformations (Simard et al., 1992).
