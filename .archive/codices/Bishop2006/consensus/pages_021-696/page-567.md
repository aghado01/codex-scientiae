[Page 567]

![Figure 11.13](../images/imageFile266.png)

Figure 11.13 Illustration of slice sampling. (a) For a given value $z^{(\tau)}$, a value of $u$ is chosen uniformly in the region $0 \leqslant u \leqslant \widetilde{p}(z^{(\tau)})$, which then deﬁnes a ‘slice’ through the distribution, shown by the solid horizontal lines. (b) Because it is infeasible to sample directly from a slice, a new sample of $z$ is drawn from a region $z_{\text{min}} \leqslant z \leqslant z_{\text{max}}$, which contains the previous value $z^{(\tau)}$.

given by

$$
\widehat{p}(z, u) = \begin{cases} 1/Z_p & \text{if } 0 \leqslant u \leqslant \widetilde{p}(z) \\ 0 & \text{otherwise} \end{cases} \tag{11.51}
$$

where $Z_p = \int \widetilde{p}(z) dz$. The marginal distribution over $z$ is given by

$$
\int \widehat{p}(z, u) du = \int_0^{\widetilde{p}(z)} \frac{1}{Z_p} du = \frac{\widetilde{p}(z)}{Z_p} = p(z) \tag{11.52}
$$

and so we can sample from $p(z)$ by sampling from $\widehat{p}(z, u)$ and then ignoring the $u$ values. This can be achieved by alternately sampling $z$ and $u$. Given the value of $z$ we evaluate $\widetilde{p}(z)$ and then sample $u$ uniformly in the range $0 \leqslant u \leqslant \widetilde{p}(z)$, which is straightforward. Then we ﬁx $u$ and sample $z$ uniformly from the ‘slice’ through the distribution deﬁned by $\{z : \widetilde{p}(z) > u\}$. This is illustrated in Figure 11.13(a).

In practice, it can be difﬁcult to sample directly from a slice through the distribution and so instead we deﬁne a sampling scheme that leaves the uniform distribution under $\widehat{p}(z, u)$ invariant, which can be achieved by ensuring that detailed balance is satisﬁed. Suppose the current value of $z$ is denoted $z^{(\tau)}$ and that we have obtained a corresponding sample $u$. The next value of $z$ is obtained by considering a region $z_{\text{min}} \leqslant z \leqslant z_{\text{max}}$ that contains $z^{(\tau)}$. It is in the choice of this region that the adaptation to the characteristic length scales of the distribution takes place. We want the region to encompass as much of the slice as possible so as to allow large moves in $z$ space while having as little as possible of this region lying outside the slice, because this makes the sampling less efﬁcient.

One approach to the choice of region involves starting with a region containing $z^{(\tau)}$ having some width $w$ and then testing each of the end points to see if they lie within the slice. If either end point does not, then the region is extended in that direction by increments of value $w$ until the end point lies outside the region. A candidate value $z'$ is then chosen uniformly from this region, and if it lies within the slice, then it forms $z^{(\tau+1)}$. If it lies outside the slice, then the region is shrunk such that $z'$ forms an end point and such that the region still contains $z^{(\tau)}$. Then another
