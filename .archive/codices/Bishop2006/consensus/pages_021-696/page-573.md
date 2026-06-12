[Page 573]

![Figure 11.14](../images/imageFile268.png)

Figure 11.14 Each step of the leapfrog algorithm (11.64)–(11.66) modiﬁes either a position variable $z_i$ or a momentum variable $r_i$. Because the change to one variable is a function only of the other, any region in phase space will be sheared without change of volume.

region $\mathcal{R}'$ and integrating backwards in time to end up in region $\mathcal{R}$ is given by

$$
\frac{1}{Z_H} \exp(-H(\mathcal{R}')) \delta V \frac{1}{2} \min\left(1, \exp\{-H(\mathcal{R}') + H(\mathcal{R})\}\right). \tag{11.69}
$$

It is easily seen that the two probabilities (11.68) and (11.69) are equal, and hence detailed balance holds. Note that this proof ignores any overlap between the regions $\mathcal{R}$ and $\mathcal{R}'$ but is easily generalized to allow for such overlap.

It is not difﬁcult to construct examples for which the leapfrog algorithm returns to its starting position after a ﬁnite number of iterations. In such cases, the random replacement of the momentum values before each leapfrog integration will not be sufﬁcient to ensure ergodicity because the position variables will never be updated. Such phenomena are easily avoided by choosing the magnitude of the step size $\epsilon$ at random from some small interval, before each leapfrog integration.

We can gain some insight into the behaviour of the hybrid Monte Carlo algorithm by considering its application to a multivariate Gaussian. For convenience, consider a Gaussian distribution $p(\mathbf{z})$ with independent components, for which the Hamiltonian is given by

$$
H(\mathbf{z}, \mathbf{r}) = \frac{1}{2} \sum_i \frac{1}{\sigma_i^2} z_i^2 + \frac{1}{2} \sum_i r_i^2. \tag{11.70}
$$

Our conclusions will be equally valid for a Gaussian distribution having correlated components because the hybrid Monte Carlo algorithm exhibits rotational isotropy. During the leapfrog integration, each pair of phase-space variables $z_i, r_i$ evolves independently. However, the acceptance or rejection of the candidate point is based on the value of $H$, which depends on the values of all of the variables. Thus, a signiﬁcant integration error in any one of the variables could lead to a high probability of rejection. In order that the discrete leapfrog integration be a reasonably
