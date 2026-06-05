[Page 555]

value for k in that any value that is sufﬁciently large to guarantee a bound on the desired distribution will lead to impractically small acceptance rates.

As in the case of rejection sampling, the sampling-importance-resampling (SIR) approach also makes use of a sampling distribution q(z) but avoids having to determine the constant k. There are two stages to the scheme. In the ﬁrst stage, L samples z(1),...,z(L) are drawn from q(z). Then in the second stage, weights w1,...,wL are constructed using (11.23). Finally, a second set of L samples is drawn from the discrete distribution (z(1),...,z(L)) with probabilities given by the weights (w1,...,wL).

The resulting L samples are only approximately distributed according to p(z), but the distribution becomes correct in the limit L → ∞. To see this, consider the univariate case, and note that the cumulative distribution of the resampled values is given by

�

p(z � a) =

wl

l:z(l)�a

= �

l I(z(l) � a)�p(z(l))/q(z(l))

(11.25)

�

l �p(z(l))/q(z(l))

where I(.) is the indicator function (which equals 1 if its argument is true and 0 otherwise). Taking the limit L → ∞, and assuming suitable regularity of the distributions, we can replace the sums by integrals weighted according to the original sampling distribution q(z)

� I(z � a){�p(z)/q(z)}q(z)dz

p(z � a) =

� {�p(z)/q(z)}q(z)dz

� I(z � a)�p(z)dz �

=

�p(z)dz

= � I(z � a)p(z)dz (11.26)

which is the cumulative distribution function of p(z). Again, we see that the normalization of p(z) is not required.

For a ﬁnite value of L, and a given initial sample set, the resampled values will only approximately be drawn from the desired distribution. As with rejection sampling, the approximation improves as the sampling distribution q(z) gets closer to the desired distribution p(z). When q(z) = p(z), the initial samples (z(1),...,z(L)) have the desired distribution, and the weights wn = 1/L so that the resampled values also have the desired distribution.

If moments with respect to the distribution p(z) are required, then they can be
