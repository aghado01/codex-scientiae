[Page 259]

Figure 5.6

In the neighbourhood of a minimum w , the error function can be approximated by a quadratic. Contours of constant error are then ellipses whose axes are aligned with the eigenvectors u i of the Hessian matrix, with lengths that are inversely proportional to the square roots of the corresponding eigenvectors λ i .

w

![The image depicts a circular diagram with a central point labeled as W. This point is positioned at the center of the circle. The diagram is labeled with the following labels: - W: The point where the line segment W intersects the circle. - (\alpha_1): The angle between the line segment W and the radius of the circle. - (\alpha_2): The angle between the line segment W and the radius of the circle. - (\alpha_3): The angle between the line segment W and the radius of the circle. - (\alpha_4): The angle between the line segment W and the radius of the circle. - (\alpha_5): The angle between the line segment W and the radius of the circle. - (\alpha_6): The angle between the line segment W and the radius of the circle. - (\alpha_7): The angle between](../images/imageFile112.png)

2

2

u

1

u

/star

-

/

1

2

w

λ

2

-

/

1

2

λ

1

w

1

Because the eigenvectors { u i } form a complete set, an arbitrary vector v can be written in the form

$$
v = \sum _ { i } c _ { i } u _ { i } . \\ \intertext { t h e n t h a v e }
$$

From (5.33) and (5.34), we then have

$$
v ^ { T } H v = \sum _ { i } c _ { i } ^ { 2 } \lambda _ { i } \\ \intertext { v $ ^ { T } H v = \sum _ { i } c _ { i } ^ { 2 } \lambda _ { i } } \text { give definite if and only if all of its eigenvalues are positive}
$$

and so H will be positive deﬁnite if, and only if, all of its eigenvalues are positive. Exercise 5.10 In the new coordinate system, whose basis vectors are given by the eigenvectors { u i } , the contours of constant E are ellipses centred on the origin, as illustrated Exercise 5.11 in Figure 5.6. For a one-dimensional weight space, a stationary point w will be a minimum if ∂ 2 E

$$
\begin{smallmatrix} \text {dimensional weight space, a stationary point} \, w ^ { \prime } & \text {will be a} \\ \frac { \partial ^ { 2 } E } { \partial w ^ { 2 } } & > 0 . \end{smallmatrix}
$$

∂w 2 w > 0 . (5.40) The corresponding result in D -dimensions is that the Hessian matrix, evaluated at w , should be positive deﬁnite.

Exercise 5.12

Exercise 5.13

# 5.2.3 Use of gradient information

As we shall see in Section 5.3, it is possible to evaluate the gradient of an error function efﬁciently by means of the backpropagation procedure. The use of this gradient information can lead to signiﬁcant improvements in the speed with which the minima of the error function can be located. We can see why this is so, as follows.

In the quadratic approximation to the error function, given in (5.28), the error surface is speciﬁed by the quantities b and H , which contain a total of W ( W + 3) / 2 independent elements (because the matrix H is symmetric), where W is the dimensionality of w (i.e., the total number of adaptive parameters in the network). The location of the minimum of this quadratic approximation therefore depends on O ( W 2 ) parameters, and we should not expect to be able to locate the minimum until we have gathered O ( W 2 ) independent pieces of information. If we do not make use of gradient information, we would expect to have to perform O ( W 2 ) function
