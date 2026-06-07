[Page 202]

Figure 4.1 Illustration of the geometry of a linear discriminant function in two dimensions. The decision surface, shown in red, is perpendicular to $\mathbf{w}$, and its displacement from the origin is controlled by the bias parameter $w_0$. Also, the signed orthogonal distance of a general point $\mathbf{x}$ from the decision surface is given by $y(\mathbf{x})/\|\mathbf{w}\|$.

![The image depicts a geometric figure with several lines and points. Here is a detailed description of the image: ### Description: - **Lines and Points**: - There are two lines: - Line A is a straight line with a positive slope. - Line B is a straight line with a negative slope. - There are two points: - Point A is located on line A. - Point B is located on line B. - There are two points: - Point C is located on line A. - Point D is located on line B. - There are two points: - Point E is located on line A. - Point F is located on line B. - There are two points: - Point G is located on line A. - Point H is located on line B. - There are two points: - Point J is located on line A. - Point K is located on line](../images/imageFile91.png)

an arbitrary point $\mathbf{x}$ and let $\mathbf{x}_\perp$ be its orthogonal projection onto the decision surface, so that

$$
\mathbf{x} = \mathbf{x}_{\perp} + r \frac{\mathbf{w}}{\|\mathbf{w}\|}.
\tag{4.6}
$$

Multiplying both sides of this result by $\mathbf{w}^T$ and adding $w_0$, and making use of $y(\mathbf{x}) = \mathbf{w}^T\mathbf{x} + w_0$ and $y(\mathbf{x}_\perp) = \mathbf{w}^T\mathbf{x}_\perp + w_0 = 0$, we have

$$
r = \frac{y(\mathbf{x})}{\|\mathbf{w}\|}.
\tag{4.7}
$$

This result is illustrated in Figure 4.1.

As with the linear regression models in Chapter 3, it is sometimes convenient to use a more compact notation in which we introduce an additional dummy 'input' value $x_0 = 1$ and then define $\widetilde{\mathbf{w}} = (w_0, \mathbf{w})$ and $\widetilde{\mathbf{x}} = (x_0, \mathbf{x})$ so that

$$
y(\mathbf{x}) = \widetilde{\mathbf{w}}^T \widetilde{\mathbf{x}}.
\tag{4.8}
$$

In this case, the decision surfaces are $D$-dimensional hyperplanes passing through the origin of the $D + 1$-dimensional expanded input space.

### 4.1.2 Multiple classes

Now consider the extension of linear discriminants to $K > 2$ classes. We might be tempted to build a $K$-class discriminant by combining a number of two-class discriminant functions. However, this leads to some serious difficulties (Duda and Hart, 1973) as we now show.

Consider the use of $K-1$ classifiers each of which solves a two-class problem of separating points in a particular class $\mathcal{C}_k$ from points not in that class. This is known as a one-versus-the-rest classifier. The left-hand example in Figure 4.2 shows an
