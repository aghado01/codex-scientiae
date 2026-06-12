[Page 126]

Figure 2.17 Illustration of the representation of values $\theta_n$ of a periodic variable as twodimensional vectors $\mathbf{x}_n$ living on the unit circle. Also shown is the average $\bar{\mathbf{x}}$ of those vectors.

![The image depicts a geometric diagram with several points and lines. Here's a detailed description of the image: ### Description of the Image: - **Center of the Circle**: The center of the circle is marked as point ( \omega ). - **Radius of the Circle**: The radius of the circle is marked as ( r ). - **Diameter of the Circle**: The diameter of the circle is marked as ( d ). - **Angles and Lines**: - **Radius Line**: The radius of the circle is marked as ( r ). - **Diameter Line**: The diameter of the circle is marked as ( d ). - **Angles**: There are two angles labeled: ( \angle A ) and ( \angle B ). - **Lines**: There are two lines: ( \omega ) and ( \lambda ). - **Angles](../images/imageFile58.png)

instead to give
$$
\bar{\mathbf{x}} = \frac{1}{N} \sum_{n=1}^{N} \mathbf{x}_{n} \tag{2.167}
$$
and then find the corresponding angle $\bar{\theta}$ of this average. Clearly, this definition will ensure that the location of the mean is independent of the origin of the angular coordinate. Note that $\bar{\mathbf{x}}$ will typically lie inside the unit circle. The Cartesian coordinates of the observations are given by $\mathbf{x}_n = (\cos\theta_n,\sin\theta_n)$, and we can write the Cartesian coordinates of the sample mean in the form $\bar{\mathbf{x}} = (\bar{r} \cos\bar{\theta},\bar{r} \sin\bar{\theta})$. Substituting into (2.167) and equating the $x_1$ and $x_2$ components then gives
$$
\bar{r} \cos \bar{\theta} = \frac{1}{N} \sum_{n=1}^{N} \cos \theta_{n}, \quad \bar{r} \sin \bar{\theta} = \frac{1}{N} \sum_{n=1}^{N} \sin \theta_{n}. \tag{2.168}
$$
Taking the ratio, and using the identity $\tan\theta = \sin\theta/\cos\theta$, we can solve for $\bar{\theta}$ to give
$$
\bar{\theta} = \tan^{-1} \left\{ \frac{\sum_{n} \sin \theta_{n}}{\sum_{n} \cos \theta_{n}} \right\} . \tag{2.169}
$$
Shortly, we shall see how this result arises naturally as the maximum likelihood estimator for an appropriately defined distribution over a periodic variable.

We now consider a periodic generalization of the Gaussian called the von Mises distribution. Here we shall limit our attention to univariate distributions, although periodic distributions can also be found over hyperspheres of arbitrary dimension. For an extensive discussion of periodic distributions, see Mardia and Jupp (2000).

By convention, we will consider distributions $p(\theta)$ that have period $2\pi$. Any probability density $p(\theta)$ defined over $\theta$ must not only be nonnegative and integrate
