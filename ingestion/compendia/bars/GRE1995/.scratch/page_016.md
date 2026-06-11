[Page 16]

$$
h _ { i } ^ { \prime } = \{ h _ { i } ^ { s _ { i } + t _ { i } } ( h ^ { * } ) ^ { - s _ { i } } \} ^ { 1 / t _ { i } } .
$$

The motivation for making these particular assignments is that the integral of h over the whole unit square is thereby left unchanged, while the height assigned to the new tile is a compromise between the heights previously assigned to points in that tile; modified by For the death transition corresponding to this birth; a randomly chosen generating point is deleted; and the points in its tile re-assigned to neighbours. Using ti and Si + t; to denote the old and new areas for neighbouring tile i, its height is changed to log

$$
\{ h _ { i } ^ { t _ { i } } ( h ^ { * } ) ^ { s _ { i } } \} ^ { 1 / ( s _ { i } + t _ { i } ) } ,
$$

which has the effect of reversing the birth move exactly.

With this of proposal mechanisms; it turns out after some straightforward algebra that the acceptance ratio for the birth is min(1, R) and for the death min(1, R-1), where pair

$$
R = (\text{likelihood ratio})
\times \lambda\,\frac{\beta^\alpha}{\Gamma(\alpha)}(h^*)^{\alpha-1}
\prod_{i \in \mathcal{I}}\!\left(\frac{h'_i}{h_i}\right)^{\alpha-1}
\exp\!\left[-\beta\!\left\{h^* + \sum_{i \in \mathcal{I}}(h'_i - h_i)\right\}\right]
\times \frac{d_{k+1}}{b_k(k+1)f(v)}
\times \tilde{h}\sum_{i \in \mathcal{I}}\!\left\{\frac{(s_i+t_i)h'_i}{t_i h_i}\right\}
$$

using (8).

Figure 5 displays results from one simple example testing this methodology; based on synthetic data. A 'true' image consisting of a disc of intensity 20 against a background of a lower intensity 05 was degraded with additive Gaussian noise, independently at each pixel on a $50 \times 50$ grid, with standard deviation $0.7$. Note that a disc cannot be perfectly fitted a finite union of Voronoi polygons: The hyperparameters were fixed at $\lambda = \alpha = 10$ and $\beta = 10$. Figure 5 shows, on the left, the data y(u, v) and, on the right; the posterior mean surface E{x(u; v)ly}, estimated from a run of the sampling method described above, 20 000 sweeps  after a burn-in period of 4000 sweeps. by prior kmax Notwithstanding the apparent complexity of the geometrical calculations to maintain the tessellation and its modifications; and of the computations described in the paragraphs above; the entire sampler runs quickly. On a Sun Sparc 2 workstation, the run described above takes approximately 260 seconds. quite

**Fig. 5.** Synthetic segmentation problem: on the left, noisy data; on the right, estimated posterior mean. Upper plots show perspective views of the same surfaces displayed as images below.
