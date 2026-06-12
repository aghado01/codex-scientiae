[Page 82]

1.17 ( ) www The gamma function is defined by

$$
\Gamma(x) \equiv \int_{0}^{\infty} u^{x - 1} e^{- u} \, d u \tag{1.141}
$$

Using integration by parts, prove the relation $\Gamma(x + 1) = x\Gamma(x)$. Show also that $\Gamma(1) = 1$ and hence that $\Gamma(x + 1) = x!$ when $x$ is an integer.

1.18 ( ) www We can use the result (1.126) to derive an expression for the surface area $S_D$, and the volume $V_D$, of a sphere of unit radius in $D$ dimensions. To do this, consider the following result, which is obtained by transforming from Cartesian to polar coordinates

$$
\prod_{i = 1}^{D} \int_{-\infty}^{\infty} e^{- x_{i}^{2}} \, d x_{i} = S_D \int_{0}^{\infty} e^{- r^{2}} r^{D - 1} \, d r \tag{1.142}
$$

Using the definition (1.141) of the Gamma function, together with (1.126), evaluate both sides of this equation, and hence show that

$$
S_D = \frac{2 \pi^{D / 2}}{\Gamma(D / 2)} \tag{1.143}
$$

Next, by integrating with respect to radius from $0$ to $1$, show that the volume of the unit sphere in $D$ dimensions is given by

$$
V_D = \frac{S_D}{D} \tag{1.144}
$$

Finally, use the results $\Gamma(1) = 1$ and $\Gamma(3/2) = \sqrt{\pi}/2$ to show that (1.143) and (1.144) reduce to the usual expressions for $D = 2$ and $D = 3$.

1.19 ( ) Consider a sphere of radius $a$ in $D$-dimensions together with the concentric hypercube of side $2a$, so that the sphere touches the hypercube at the centres of each of its sides. By using the results of Exercise 1.18, show that the ratio of the volume of the sphere to the volume of the cube is given by

$$
\frac{\text{volume of sphere}}{\text{volume of cube}} = \frac{\pi^{D / 2}}{D 2^{D - 1} \Gamma(D / 2)} \tag{1.145}
$$

Now make use of Stirling’s formula in the form

$$
\Gamma(x + 1) \simeq (2 \pi)^{1 / 2} e^{- x} x^{x + 1 / 2} \tag{1.146}
$$

which is valid for $x \gg 1$, to show that, as $D \to \infty$, the ratio (1.145) goes to zero. Show also that the ratio of the distance from the centre of the hypercube to one of the corners, divided by the perpendicular distance to one of the sides, is $\sqrt{D}$, which therefore goes to $\infty$ as $D \to \infty$. From these results we see that, in a space of high dimensionality, most of the volume of a cube is concentrated in the large number of corners, which themselves become very long ‘spikes’!
