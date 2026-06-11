[Page 547]

![Figure 11.2](../images/imageFile254.png)

Figure 11.2 Geometrical interpretation of the transformation method for generating nonuniformly distributed random numbers. $h(y)$ is the indeﬁnite integral of the desired distribution $p(y)$. If a uniformly distributed random variable $z$ is transformed using $y = h^{-1}(z)$, then $y$ will be distributed according to $p(y)$.

Another example of a distribution to which the transformation method can be applied is given by the Cauchy distribution

$$
p(y) = \frac{1}{\pi} \frac{1}{1 + y^2}. \tag{11.8}
$$

In this case, the inverse of the indeﬁnite integral can be expressed in terms of the 'tan' function.

The generalization to multiple variables is straightforward and involves the Jacobian of the change of variables, so that

$$
p(y_1, \dots, y_M) = p(z_1, \dots, z_M) \left| \frac{\partial(z_1, \dots, z_M)}{\partial(y_1, \dots, y_M)} \right|. \tag{11.9}
$$

As a ﬁnal example of the transformation method we consider the Box-Muller method for generating samples from a Gaussian distribution. First, suppose we generate pairs of uniformly distributed random numbers $z_1, z_2 \in (-1, 1)$, which we can do by transforming a variable distributed uniformly over $(0,1)$ using $z \to 2z - 1$. Next we discard each pair unless it satisﬁes $z_1^2 + z_2^2 \leqslant 1$. This leads to a uniform distribution of points inside the unit circle with $p(z_1, z_2) = 1/\pi$, as illustrated in Figure 11.3. Then, for each pair $z_1, z_2$ we evaluate the quantities

![Figure 11.3](../images/imageFile255.png)

Figure 11.3 The Box-Muller method for generating Gaussian distributed random numbers starts by generating samples from a uniform distribution inside the unit circle.
