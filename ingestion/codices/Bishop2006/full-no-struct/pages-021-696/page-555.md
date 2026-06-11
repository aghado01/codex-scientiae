[Page 555]

As in the case of rejection sampling, the sampling-importance-resampling (SIR) approach also makes use of a sampling distribution q ( z ) but avoids having to determine the constant k . There are two stages to the scheme. In the ﬁrst stage, L samples z (1) ,..., z ( L ) are drawn from q ( z ) . Then in the second stage, weights w 1 ,...,w L are constructed using (11.23). Finally, a second set of L samples is drawn from the discrete distribution ( z (1) ,..., z ( L ) ) with probabilities given by the weights ( w 1 ,...,w L ) . ( z )

The resulting L samples are only approximately distributed according to p , but the distribution becomes correct in the limit L → ∞ . To see this, consider the univariate case, and note that the cumulative distribution of the resampled values is given by

$$
p ( z \leqslant a ) \ = \ \sum _ { l \colon z ^ { ( l ) } \leqslant a } w _ { l } \\ = \ \frac { \sum _ { l } I ( z ^ { ( l ) } \leqslant a ) p ( z ^ { ( l ) } ) / q ( z ^ { ( l ) } ) } { \sum _ { l } \widetilde { p } ( z ^ { ( l ) } ) / q ( z ^ { ( l ) } ) } \\ I ( . ) \, \text { is the indicator function (which equals 1 if its argument is true and 0
ise). } \, \text { Taking the limit } L \to \infty , \, \text {and assuming suitable regularity of the dis-}
$$

= l l p ( z ( l ) ) /q ( z ( l ) ) (11.25) where I ( . ) is the indicator function (which equals 1 if its argument is true and 0 otherwise). Taking the limit L → ∞ , and assuming suitable regularity of the distributions, we can replace the sums by integrals weighted according to the original sampling distribution q ( z )

$$
x _ { \ } s u m & \leq a ) \ = \ \frac { \int I ( z \leq a ) \left \{ \widetilde { p } ( z ) / q ( z ) \right \} q ( z ) \, d z } { \int \{ \widetilde { p } ( z ) / q ( z ) \} q ( z ) \, d z } \\ & = \ \frac { \int I ( z \leq a ) \widetilde { p } ( z ) \, d z } { \int \widetilde { p } ( z ) \, d z } \\ & = \ \int I ( z \leq a ) p ( z ) \, d z \\ \intertext { h i s t h e c u m u l a t i v e d i r b u r i o n f u c t i o n f o p ( a ) . $ A g a i n , w e s e t h a t h e n o r m a l $ } \int o f p ( z ) \, i s n o t r i e d .
$$

which is the cumulative distribution function of p ( z ) . Again, we see that the normalization of p ( z ) is not required.

For a ﬁnite value of L , and a given initial sample set, the resampled values will only approximately be drawn from the desired distribution. As with rejection sampling, the approximation improves as the sampling distribution q ( z ) gets closer to the desired distribution p ( z ) . When q ( z ) = p ( z ) , the initial samples ( z (1) ,..., z ( L ) ) have the desired distribution, and the weights w n = 1 /L so that the resampled values also have the desired distribution.

If moments with respect to the distribution p ( z ) are required, then they can be
