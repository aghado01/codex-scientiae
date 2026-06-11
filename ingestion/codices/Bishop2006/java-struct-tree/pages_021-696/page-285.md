[Page 285]

Figure 5.16 Illustration showing (a) the original image x of a handwritten digit, (b) the tangent vector τ corresponding to an inﬁnitesimal clockwise rotation, (c) the result of adding a small contribution from the tangent vector to the original image giving x + �τ with � = 15 degrees, and (d) the true image rotated for comparison.

![image 76](../../../../../images/imageFile76.png)

![image 77](../../../../../images/imageFile77.png)

(a) (b)

![image 78](../../../../../images/imageFile78.png)

![image 79](../../../../../images/imageFile79.png)

(c) (d)

A related technique, called tangent distance, can be used to build invariance properties into distance-based methods such as nearest-neighbour classiﬁers (Simard et al., 1993).

5.5.5 Training with transformed data

We have seen that one way to encourage invariance of a model to a set of transformations is to expand the training set using transformed versions of the original input patterns. Here we show that this approach is closely related to the technique of tangent propagation (Bishop, 1995b; Leen, 1995).

As in Section 5.5.4, we shall consider a transformation governed by a single parameter ξ and described by the function s(x,ξ), with s(x,0) = x. We shall also consider a sum-of-squares error function. The error function for untransformed inputs can be written (in the inﬁnite data set limit) in the form

�� {y(x) − t}2p(t|x)p(x)dxdt (5.129)

1 2

E =

as discussed in Section 1.5.5. Here we have considered a network having a single output, in order to keep the notation uncluttered. If we now consider an inﬁnite number of copies of each data point, each of which is perturbed by the transformation
