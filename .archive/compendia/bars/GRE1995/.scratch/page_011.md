[Page 11]

$$
\min \left \{ 1 , ( \text {likelihood ratio} ) \times \frac { ( s _ { j + 1 } - s _ { j } ) ( s _ { j } - s _ { j - 1 } ) } { ( s _ { j + 1 } - s _ { j } ) ( s _ { j } - s _ { j - 1 } ) } \right \} .
$$

The details for a birth of a step are more complicated, and follow the prescription in 8 3.3. We first choose a position $* for the proposed new step, uniformly distributed on [0L] This must lie, with probability 1, within an If accepted, Sj+1 will be set to s* and Sj+1, Sj+2, Sk will be relabelled as Sj+2, Sj+3, 8k+1, with corresponding changes to the labelling of heights. We wish to propose new heights hj, hj+1 for the step function on the subintervals (Sj, s* and (s*, Sj+1) which recognise that the current height hj on the union of these two intervals is typically well-supported in the posterior distribution; and should therefore not be completely discarded.  Thus the new heights h;, hj+1 should be perturbed in either direction from h; in such a way that h; is a compromise between them. To preserve positivity and maintain simplicity in the acceptance ratio calculations; we use a weighted geometric mean for this compromise; so that step

$$
(s^* - s_j)\log(h'_j) + (s_{j+1} - s^*)\log(h'_{j+1}) = (s_{j+1} - s_j)\log(h_j)
$$

and define the perturbation to be such that

$$
\frac{h'_{j+1}}{h'_j} = u
$$

with u drawn uniformly from [0,1]

Following the analysis of $ 3-3, the acceptance probability for this proposal has to be calculated to achieve detailed balance with the corresponding death move, which we must therefore first specify . Dimension matching is achieved by reversing the above calculation; weighted geometric mean satisfying

$$
(s_{j+1} - s_j)\log(h_j) + (s_{j+2} - s_{j+1})\log(h_{j+1}) = (s_{j+2} - s_j)\log(h'_j)
$$

The $s_{j+1}$ that is proposed for removal is simply drawn at random from $s_1, s_2, \ldots, s_k$.

The of birth and death moves thus defined satisfies the dimension-matching requirement. The birth increases the dimensionality from 2k +1 to 2k + 3, the difference accounted for by two continuous variables, the new position s* and the u used to separate hj and hj+1. pair being

In deriving an expression for the acceptance probability of the birth proposal, it is helpful to re-write (8) in the form

min {1, (likelihood ratio) x (prior ratio) x (proposal ratio) x (Jacobian)} ,

noting that p(xly) = p(ylx)p(x)/p(y). In the present context; the likelihood ratio is straightforward, using (9); the ratio, which was previously p(2, 0(2)/p(1, 0(1)), becomes prior

$$
\frac{p(k+1)}{p(k)}\,\frac{2(k+1)(2k+3)}{L^2}\,\frac{(s^*-s_j)(s_{j+1}-s^*)}{s_{j+1}-s_j}
\times \frac{\beta^\alpha}{\Gamma(\alpha)}\left(\frac{h'_j h'_{j+1}}{h_j}\right)^{\alpha-1}
\exp\{-\beta(h'_j + h'_{j+1} - h_j)\}
$$
