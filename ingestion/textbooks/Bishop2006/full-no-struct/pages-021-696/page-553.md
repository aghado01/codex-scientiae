[Page 553]

$$
d r a w n \, f o r \, q ( z ) \\ \mathbb { E } [ f ] \ = \ \int f ( z ) p ( z ) \, d z \\ \ = \ \int f ( z ) \frac { p ( z ) } { q ( z ) } q ( z ) \, d z \\ \simeq \ \frac { 1 } { L } \sum _ { l = 1 } ^ { L } \frac { p ( z ^ { ( l ) } ) } { q ( z ^ { ( l ) } ) } f ( z ^ { ( l ) } ) . \\ r _ { l } = p ( z ^ { ( l ) } ) / q ( z ^ { ( l ) } ) \, \text {are known as importance weights} , \, \text {and they cor-} \\ \text {trevoid} \, \text {by sampling from the wrong distribution} \, . \, \text {Note that} \, \text { unlike}
$$

The quantities r l = p ( z ( l ) ) /q ( z ( l ) ) are known as importance weights , and they correct the bias introduced by sampling from the wrong distribution. Note that, unlike rejection sampling, all of the samples generated are retained.

It will often be the case that the distribution p ( z ) can only be evaluated up to a normalization constant, so that p ( z ) = p ( z ) /Z p where p ( z ) can be evaluated easily, whereas Z p is unknown. Similarly, we may wish to use an importance sampling distribution q ( z ) = q ( z ) /Z q , which has the same property. We then have E [ f ] = f ( z ) p ( z )d z

$$
\int \lim i t s _ { \widetilde { Z } } \, \text { Similarly, we may wish to use an importance sampling} \\ ( z ) & = \widetilde { q } ( z ) / Z _ { q } , \text { which has the same property. We then have} \\ & \in \mathbb { E } [ f ] \quad = \quad \int f ( z ) p ( z ) \, d z \\ & = \quad \frac { Z _ { q } } { Z _ { p } } \int \int _ { f ( z ) } \widetilde { \widetilde { q } } ( z ) q ( z ) \, d z \\ & \simeq \quad \frac { Z _ { q } } { Z _ { p } } \frac { 1 } { L } \sum _ { l = 1 } ^ { L } \widetilde { r } _ { l } f ( z ^ { ( l ) } ) . \\ \widetilde { q } ( z ^ { ( l ) } ) / \widetilde { q } ( z ^ { ( l ) } ) . \text { We can use the same sample set to evaluate the ratio} \\ \text {the result}
$$

where r l = p ( z ( l ) ) / q ( z ( l ) ) . We can use the same sample set to evaluate the ratio Z p /Z q with the result Z p = 1 p ( z )d z = p ( z ) q ( z )d z

$$
\text {with the result} \\ \frac { Z _ { p } } { Z _ { q } } \ = \ \frac { 1 } { Z _ { q } } \int _ { \widetilde { r } } \widetilde { p } ( z ) \, d z = \int _ { \widetilde { q } ( z ) } \frac { \widetilde { p } ( z ) } { q ( z ) } q ( z ) \, d z \\ \simeq \ \frac { 1 } { L } \sum _ { l = 1 } ^ { L } \widetilde { r } _ { l } \\ \\ \mathbb { E } \\ \mathbb { E } [ f ] _ { l } \, \sigma _ { l } \sum _ { l = 1 } ^ { L } \sigma _ { l } \, f ( \sigma _ { l } ( l ) )
$$

and hence

$$
\mathbb { E } [ f ] \simeq \sum _ { l = 1 } ^ { L } w _ { l } f ( z ^ { ( l ) } )
$$

where we have deﬁned

$$
w _ { l } = \frac { \widetilde { r } _ { l } } { \sum _ { m } \widetilde { r } _ { m } } = \frac { \widetilde { p } ( z ^ { ( l ) } ) / q ( z ^ { ( l ) } ) } { \sum _ { m } \widetilde { p } ( z ^ { ( m ) } ) / q ( z ^ { ( m ) } ) } . \\ \intertext { t h e r e jection sampling, the success of the importance sampling approach } \text {curally on how well the sampling distribution } q ( z ) \text { matches the desired }
$$

˜ ˜ As with rejection sampling, the success of the importance sampling approach depends crucially on how well the sampling distribution q ( z ) matches the desired distribution p ( z ) . If, as is often the case, p ( z ) f ( z ) is strongly varying and has a significant proportion of its mass concentrated over relatively small regions of z space, then the set of importance weights { r l } may be dominated by a few weights having large values, with the remaining weights being relatively insignificant. Thus the effective sample size can be much smaller than the apparent sample size L . The problem is even more severe if none of the samples falls in the regions where p ( z ) f ( z ) is large. In that case, the apparent variances of r l and r l f ( z ( l ) ) may be small even though the estimate of the expectation may be severely wrong. Hence a major drawback of the importance sampling method is the potential to produce results that are arbitrarily in error and with no diagnostic indication. This also highlights a key requirement for the sampling distribution q ( z ) , namely that it should not be small or zero in regions where p ( z ) may be significant.
