[Page 555]

The resulting $L$ samples are only approximately distributed according to $p(\mathbf{z})$, but the distribution becomes correct in the limit $L \to \infty$. To see this, consider the univariate case, and note that the cumulative distribution of the resampled values is given by

$$
p(z \leqslant a) = \sum_{l:z^{(l)} \leqslant a} w_l = \frac{\sum_l I(z^{(l)} \leqslant a) \widetilde{p}(z^{(l)})/q(z^{(l)})}{\sum_l \widetilde{p}(z^{(l)})/q(z^{(l)})} \tag{11.25}
$$

where $I(\cdot)$ is the indicator function (which equals 1 if its argument is true and 0 otherwise). Taking the limit $L \to \infty$, and assuming suitable regularity of the distributions, we can replace the sums by integrals weighted according to the original sampling distribution $q(z)$

$$
p(z \leqslant a) = \frac{\int I(z \leqslant a) \{\widetilde{p}(z)/q(z)\} q(z) dz}{\int \{\widetilde{p}(z)/q(z)\} q(z) dz} = \frac{\int I(z \leqslant a) \widetilde{p}(z) dz}{\int \widetilde{p}(z) dz} = \int I(z \leqslant a) p(z) dz \tag{11.26}
$$

which is the cumulative distribution function of $p(z)$. Again, we see that the normalization of $p(z)$ is not required.

For a ﬁnite value of $L$, and a given initial sample set, the resampled values will only approximately be drawn from the desired distribution. As with rejection sampling, the approximation improves as the sampling distribution $q(\mathbf{z})$ gets closer to the desired distribution $p(\mathbf{z})$. When $q(\mathbf{z}) = p(\mathbf{z})$, the initial samples $(\mathbf{z}^{(1)}, \dots, \mathbf{z}^{(L)})$ have the desired distribution, and the weights $w_n = 1/L$ so that the resampled values also have the desired distribution.

If moments with respect to the distribution $p(\mathbf{z})$ are required, then they can be evaluated directly using the original samples together with the weights, because

$$
\mathbb{E}[f(\mathbf{z})] = \int f(\mathbf{z})p(\mathbf{z}) d\mathbf{z} = \frac{\int f(\mathbf{z}) [\widetilde{p}(\mathbf{z})/q(\mathbf{z})] q(\mathbf{z}) d\mathbf{z}}{\int [\widetilde{p}(\mathbf{z})/q(\mathbf{z})] q(\mathbf{z}) d\mathbf{z}} \simeq \sum_{l=1}^L w_l f(\mathbf{z}^{(l)}). \tag{11.27}
$$
