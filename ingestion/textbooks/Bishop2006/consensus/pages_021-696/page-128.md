[Page 128]

![The image is a graph that shows the relationship between two variables, represented by the red and blue lines. The x-axis represents the values of the variables, while the y-axis represents the values of the variables. The graph shows a downward trend, with the blue line decreasing as the red line increases. The red line is a straight line, which means it is a straight line that does not have any bends or curves. The blue line is a curved line, which means it has a more complex and irregular shape. The graph is labeled with the variables m and s, which are likely the values of the variables in the graph. The x-axis is labeled x, and the y-axis is labeled y. The graph is drawn on a white background, which makes the lines and their colors stand out clearly. The graph is not labeled, but it is clear that the variables are related. The red line is a straight line,](../images/imageFile60.png)

![In this image, we can see a diagram with two lines and a circle. We can also see some text on the image.](../images/imageFile61.png)

Figure 2.19 The von Mises distribution plotted for two different parameter values, shown as a Cartesian plot on the left and as the corresponding polar plot on the right.

where 'const' denotes terms independent of $\theta$, and we have made use of the following trigonometrical identities
$$
\cos^{2} A + \sin^{2} A = 1 \tag{2.177}
$$
$$
\cos A \cos B + \sin A \sin B = \cos(A - B) . \tag{2.178}
$$

If we now deﬁne $m = r_0/\sigma^2$, we obtain our ﬁnal expression for the distribution of $p(\theta)$ along the unit circle $r = 1$ in the form
$$
p(\theta|\theta_0,m) = \frac{1}{2\pi I_0(m)} \exp\{m\cos(\theta - \theta_0)\} \tag{2.179}
$$

which is called the von Mises distribution, or the circular normal. Here the parameter $\theta_0$ corresponds to the mean of the distribution, while $m$, which is known as the concentration parameter, is analogous to the inverse variance (precision) for the Gaussian. The normalization coefﬁcient in (2.179) is expressed in terms of $I_0(m)$, which is the zeroth-order Bessel function of the ﬁrst kind (Abramowitz and Stegun, 1965) and is deﬁned by
$$
I_0(m) = \frac{1}{2\pi} \int_{0}^{2\pi} \exp\{m\cos\theta\} \, d\theta. \tag{2.180}
$$

For large $m$, the distribution becomes approximately Gaussian. The von Mises distribution is plotted in Figure 2.19, and the function $I_0(m)$ is plotted in Figure 2.20.

Now consider the maximum likelihood estimators for the parameters $\theta_0$ and $m$ for the von Mises distribution. The log likelihood function is given by
$$
\ln p(\mathcal{D}|\theta_0,m) = -N \ln(2\pi) - N \ln I_0(m) + m \sum_{n=1}^{N} \cos(\theta_n - \theta_0) . \tag{2.181}
$$
