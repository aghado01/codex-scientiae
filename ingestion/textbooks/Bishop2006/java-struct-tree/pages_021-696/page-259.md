[Page 259]

Figure 5.6 In the neighbourhood of a minimum w�, the error function can be approximated by a quadratic. Contours of constant error are then ellipses whose axes are aligned with the eigenvectors ui of the Hessian matrix, with lengths that are inversely proportional to the square roots of the corresponding eigenvectors λi.

w2

λ−2 1/2

u2

w�

u1

λ−1 1/2

w1

Because the eigenvectors {ui} form a complete set, an arbitrary vector v can be written in the form

�

v =

ciui. (5.38)

i

From (5.33) and (5.34), we then have

�

vTHv =

c2iλi (5.39)

i

Exercise 5.10 and so H will be positive deﬁnite if, and only if, all of its eigenvalues are positive. In the new coordinate system, whose basis vectors are given by the eigenvectors

Exercise 5.11 {ui}, the contours of constant E are ellipses centred on the origin, as illustrated in Figure 5.6. For a one-dimensional weight space, a stationary point w� will be a minimum if

� � � �

∂2E ∂w2

> 0. (5.40)

w�

The corresponding result in D-dimensions is that the Hessian matrix, evaluated at Exercise 5.12 w�, should be positive deﬁnite.

5.2.3 Use of gradient information

As we shall see in Section 5.3, it is possible to evaluate the gradient of an error function efﬁciently by means of the backpropagation procedure. The use of this gradient information can lead to signiﬁcant improvements in the speed with which the minima of the error function can be located. We can see why this is so, as follows.

In the quadratic approximation to the error function, given in (5.28), the error surface is speciﬁed by the quantities b and H, which contain a total of W(W +

Exercise 5.13 3)/2 independent elements (because the matrix H is symmetric), where W is the dimensionality of w (i.e., the total number of adaptive parameters in the network). The location of the minimum of this quadratic approximation therefore depends on O(W2) parameters, and we should not expect to be able to locate the minimum until we have gathered O(W2) independent pieces of information. If we do not make use of gradient information, we would expect to have to perform O(W2) function
