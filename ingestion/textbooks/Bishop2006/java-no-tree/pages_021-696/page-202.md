[Page 202]

- Figure 4.1 Illustration of the geometry of a linear discriminant function in two dimensions. The decision surface, shown in red, is perpendicular to w, and its displacement from the


origin is controlled by the bias parameter w0. Also, the signed orthogonal distance of a general point x from the decision surface is given by y(x)/ w .

x2

y > 0

y = 0 y < 0

R1

R2

x

w

y(x) w x⊥

x1

−w0 w

an arbitrary point x and let x⊥ be its orthogonal projection onto the decision surface, so that

w w

x = x⊥ + r

. (4.6)

Multiplying both sides of this result by wT and adding w0, and making use of y(x) = wTx + w0 and y(x⊥) = wTx⊥ + w0 = 0, we have

y(x) w

r =

. (4.7)

This result is illustrated in Figure 4.1.

As with the linear regression models in Chapter 3, it is sometimes convenient to use a more compact notation in which we introduce an additional dummy ‘input’ value x0 = 1 and then deﬁne w = (w0,w) and x = (x0,x) so that

###### y(x) = wT x. (4.8)

In this case, the decision surfaces are D-dimensional hyperplanes passing through the origin of the D + 1-dimensional expanded input space.

###### 4.1.2 Multiple classes

Now consider the extension of linear discriminants to K > 2 classes. We might be tempted be to build a K-class discriminant by combining a number of two-class discriminant functions. However, this leads to some serious difﬁculties (Duda and Hart, 1973) as we now show.

Consider the use of K−1 classiﬁers each of which solves a two-class problem of

separating points in a particular class Ck from points not in that class. This is known as a one-versus-the-rest classiﬁer. The left-hand example in Figure 4.2 shows an
