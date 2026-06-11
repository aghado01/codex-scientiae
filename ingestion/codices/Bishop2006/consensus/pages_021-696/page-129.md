[Page 129]

![The image depicts two graphs, each with a horizontal axis labeled m and a vertical axis labeled 0.0. The x-axis is labeled m and the y-axis is labeled 0.0. Both graphs have a linear scale of range 0 to 1000 on the x-axis, and a linear scale of range 0 to 10 on the y-axis. The graph on the left has a horizontal line that is slightly higher than the graph on the right.](../images/imageFile62.png)

Figure 2.20 Plot of the Bessel function $I_0(m)$ defined by (2.180), together with the function $A(m)$ defined by (2.186).

Setting the derivative with respect to $\theta_0$ equal to zero gives

$$
\sum_{n=1}^{N} \sin(\theta_n - \theta_0) = 0. \tag{2.182}
$$

To solve for $\theta_0$, we make use of the trigonometric identity

$$
\sin(A - B) = \cos B \sin A - \cos A \sin B \tag{2.183}
$$

from which we obtain

$$
\theta_{0}^{\text{ML}} = \tan^{-1} \left\{ \frac{\sum_n \sin \theta_n}{\sum_n \cos \theta_n} \right\} \tag{2.184}
$$

which we recognize as the result (2.169) obtained earlier for the mean of the observations viewed in a two-dimensional Cartesian space.

Similarly, maximizing (2.181) with respect to $m$, and making use of $I_0'(m) = I_1(m)$ (Abramowitz and Stegun, 1965), we have

$$
A(m) = \frac{1}{N} \sum_{n=1}^{N} \cos(\theta_n - \theta_{0}^{\text{ML}}) \tag{2.185}
$$

where we have substituted for the maximum likelihood solution for $\theta_{0}^{\text{ML}}$ (recalling that we are performing a joint optimization over $\theta$ and $m$), and we have defined

$$
A(m) = \frac{I_1(m)}{I_0(m)}. \tag{2.186}
$$

The function $A(m)$ is plotted in Figure 2.20. Making use of the trigonometric identity (2.178), we can write (2.185) in the form

$$
A(m_{\text{ML}}) = \left( \frac{1}{N} \sum_{n=1}^{N} \cos \theta_n \right) \cos \theta_{0}^{\text{ML}} + \left( \frac{1}{N} \sum_{n=1}^{N} \sin \theta_n \right) \sin \theta_{0}^{\text{ML}}. \tag{2.187}
$$
