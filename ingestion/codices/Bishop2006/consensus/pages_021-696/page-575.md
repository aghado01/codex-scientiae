[Page 575]

where $\{\mathbf{z}^{(l)}\}$ are samples drawn from the distribution deﬁned by $p_G(\mathbf{z})$. If the distribution $p_G$ is one for which the partition function can be evaluated analytically, for example a Gaussian, then the absolute value of $Z_E$ can be obtained.

This approach will only yield accurate results if the importance sampling distribution $p_G$ is closely matched to the distribution $p_E$, so that the ratio $p_E/p_G$ does not have wide variations. In practice, suitable analytically speciﬁed importance sampling distributions cannot readily be found for the kinds of complex models considered in this book.

An alternative approach is therefore to use the samples obtained from a Markov chain to deﬁne the importance-sampling distribution. If the transition probability for the Markov chain is given by $T(\mathbf{z}, \mathbf{z}')$, and the sample set is given by $\mathbf{z}^{(1)}, \dots, \mathbf{z}^{(L)}$, then the sampling distribution can be written as

$$
\frac{1}{Z_G} \exp(-G(\mathbf{z})) = \frac{1}{L} \sum_{l=1}^L T(\mathbf{z}^{(l)}, \mathbf{z}) \tag{11.73}
$$

which can be used directly in (11.72).

Methods for estimating the ratio of two partition functions require for their success that the two corresponding distributions be reasonably closely matched. This is especially problematic if we wish to ﬁnd the absolute value of the partition function for a complex distribution because it is only for relatively simple distributions that the partition function can be evaluated directly, and so attempting to estimate the ratio of partition functions directly is unlikely to be successful. This problem can be tackled using a technique known as chaining (Neal, 1993; Barber and Bishop, 1997), which involves introducing a succession of intermediate distributions $p_2, \dots, p_{M-1}$ that interpolate between a simple distribution $p_1(\mathbf{z})$ for which we can evaluate the normalization coefﬁcient $Z_1$ and the desired complex distribution $p_M(\mathbf{z})$. We then have

$$
\frac{Z_M}{Z_1} = \frac{Z_2}{Z_1} \frac{Z_3}{Z_2} \cdots \frac{Z_M}{Z_{M-1}} \tag{11.74}
$$

in which the intermediate ratios can be determined using Monte Carlo methods as discussed above. One way to construct such a sequence of intermediate systems is to use an energy function containing a continuous parameter $0 \leqslant \alpha \leqslant 1$ that interpolates between the two distributions

$$
E_\alpha(\mathbf{z}) = (1 - \alpha)E_1(\mathbf{z}) + \alpha E_M(\mathbf{z}). \tag{11.75}
$$

If the intermediate ratios in (11.74) are to be found using Monte Carlo, it may be more efﬁcient to use a single Markov chain run than to restart the Markov chain for each ratio. In this case, the Markov chain is run initially for the system $p_1$ and then after some suitable number of steps moves on to the next distribution in the sequence. Note, however, that the system must remain close to the equilibrium distribution at each stage.
