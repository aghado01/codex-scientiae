[Page 83]

###### 1.20 ($\star$) www In this exercise, we explore the behaviour of the Gaussian distribution in high-dimensional spaces. Consider a Gaussian distribution in $D$ dimensions given by

$$
p(\mathbf{x}) = \frac{1}{(2\pi\sigma^2)^{D/2}} \exp \left( - \frac{\|\mathbf{x}\|^2}{2\sigma^2} \right) . \tag{1.147}
$$

We wish to ﬁnd the density with respect to radius in polar coordinates in which the direction variables have been integrated out. To do this, show that the integral of the probability density over a thin shell of radius $r$ and thickness $\epsilon$, where $\epsilon \ll 1$, is given by $p(r)\epsilon$ where

$$
p(r) = \frac{S_D r^{D-1}}{(2\pi\sigma^2)^{D/2}} \exp \left( - \frac{r^2}{2\sigma^2} \right) \tag{1.148}
$$

where $S_D$ is the surface area of a unit sphere in $D$ dimensions. Show that the function $p(r)$ has a single stationary point located, for large $D$, at $\widehat{r} \simeq \sqrt{D}\sigma$. By considering $p(\widehat{r} + \epsilon)$ where $\epsilon \ll \widehat{r}$, show that for large $D$,

$$
p(\widehat{r} + \epsilon) = p(\widehat{r}) \exp \left( - \frac{\epsilon^2}{2\sigma^2} \right) \tag{1.149}
$$

which shows that $\widehat{r}$ is a maximum of the radial probability density and also that $p(r)$ decays exponentially away from its maximum at $\widehat{r}$ with length scale $\sigma$. We have already seen that $\sigma \ll \widehat{r}$ for large $D$, and so we see that most of the probability mass is concentrated in a thin shell at large radius. Finally, show that the probability density $p(\mathbf{x})$ is larger at the origin than at the radius $\widehat{r}$ by a factor of $\exp(D/2)$. We therefore see that most of the probability mass in a high-dimensional Gaussian distribution is located at a different radius from the region of high probability density. This property of distributions in spaces of high dimensionality will have important consequences when we consider Bayesian inference of model parameters in later chapters.

###### 1.21 ($\star$) Consider two nonnegative numbers $a$ and $b$, and show that, if $a \leqslant b$, then $a \leqslant (ab)^{1/2}$. Use this result to show that, if the decision regions of a two-class classiﬁcation problem are chosen to minimize the probability of misclassiﬁcation, this probability will satisfy

$$
p(\text{mistake}) \leqslant \int \{ p(\mathbf{x}, \mathcal{C}_1) p(\mathbf{x}, \mathcal{C}_2) \}^{1/2} \,\mathrm{d}\mathbf{x} . \tag{1.150}
$$

###### 1.22 ($\star$) www Given a loss matrix with elements $L_{kj}$, the expected risk is minimized if, for each $\mathbf{x}$, we choose the class that minimizes (1.81). Verify that, when the loss matrix is given by $L_{kj} = 1 - I_{kj}$, where $I_{kj}$ are the elements of the identity matrix, this reduces to the criterion of choosing the class having the largest posterior probability. What is the interpretation of this form of loss matrix?

###### 1.23 ($\star$) Derive the criterion for minimizing the expected loss when there is a general loss matrix and general prior probabilities for the classes.
