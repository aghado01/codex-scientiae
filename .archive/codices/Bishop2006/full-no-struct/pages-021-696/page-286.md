[Page 286]

$$
\text {defined over this expanded data set can be written as} \\ & \widetilde { E } = \frac { 1 } { 2 } \iint \{ y ( s ( x , \xi ) ) - t \} ^ { 2 } p ( t | x ) p ( x ) p ( \xi ) \, d x \, d t \, d \xi . \\ \intertext { We now assume that the distribution p ( \xi ) has zero mean with small variance, so that } \text {we are only considering small transformations of the original input vectors. We can}
$$

We now assume that the distribution p ( ξ ) has zero mean with small variance, so that we are only considering small transformations of the original input vectors. We can then expand the transformation function as a Taylor series in powers of ξ to give

$$
\text { then expand the transformation function as a Taylor series in powers of $\xi$ to give} \\ s ( x , \xi ) \ = \ s ( x , 0 ) + \xi \ \frac { \partial } { \partial \xi } s ( x , \xi ) \Big | _ { \xi = 0 } + \frac { \xi ^ { 2 } } { 2 } \ \frac { \partial ^ { 2 } } { \partial \xi ^ { 2 } } s ( x , \xi ) \Big | _ { \xi = 0 } + O ( \xi ^ { 3 } ) \\ = \ x + \xi \tau + \frac { 1 } { 2 } \xi ^ { 2 } \tau ^ { \prime } + O ( \xi ^ { 3 } )
$$

where τ denotes the second derivative of s ( x ,ξ ) with respect to ξ evaluated at ξ = 0 . This allows us to expand the model function to give

$$
y ( s ( x , \xi ) ) = y ( x ) + \xi \tau ^ { T } \nabla y ( x ) + \frac { \xi ^ { 2 } } { 2 } \left [ ( \tau ^ { \prime } ) ^ { T } \nabla y ( x ) + \tau ^ { T } \nabla \nabla y ( x ) \tau \right ] + O ( \xi ^ { 3 } ) . \\ \\ \text {Substituting into the mean error function } ( 5 . 1 3 0 ) \text { and expanding, we then have}
$$

Substituting into the mean error function (5.130) and expanding, we then have

$$
\text {Substituting into the mean error function (5.130) and expanding, we then have} \\ \widetilde { E } \ = \ \frac { 1 } { 2 } \iint \{ y ( x ) - t \} ^ { 2 } p ( t | x ) p ( x ) \, d x \, d t \\ + \quad \mathbb { E } [ \xi ] \iint \{ y ( x ) - t \} \tau ^ { T } \nabla y ( x ) p ( t | x ) p ( x ) \, d x \, d t \\ + \quad \mathbb { E } [ \xi ^ { 2 } ] \iint \left [ \{ y ( x ) - t \} \frac { 1 } { 2 } \left \{ ( \tau ^ { \prime } ) ^ { T } \nabla y ( x ) + \tau ^ { T } \nabla y ( x ) \tau \right \} \\ + \left ( \tau ^ { T } \nabla y ( x ) \right ) ^ { 2 } \right ] p ( t | x ) p ( x ) \, d x \, d t + O ( \xi ^ { 3 } ) . \\ \\ \text {Because the distribution of transformations has zero mean we have } \mathbb { E } [ \xi ] = 0 . \text { Also,} \\ \text {we shall denote } \mathbb { E } [ \xi ^ { 2 } ] \text { by } \lambda . \text { Omitting terms of } O ( \xi ^ { 3 } ) , \text { the average error function then} \\
$$

Because the distribution of transformations has zero mean we have E [ ξ ] = 0 . Also, we shall denote E [ ξ 2 ] by λ . Omitting terms of O ( ξ 3 ) , the average error function then becomes

E = E + λ Ω (5.131) where E is the original sum-of-squares error, and the regularization term Ω takes the form

$$
\text {form} \\ \Omega \ = \ \int \left [ \{ y ( x ) - \mathbb { E } [ t | x ] \} \frac { 1 } { 2 } \left \{ ( \tau ^ { \prime } ) ^ { T } \nabla y ( x ) + \tau ^ { T } \nabla \nabla y ( x ) \tau \right \} \right ] \\ + ( \tau ^ { T } \nabla y ( x ) ) ^ { 2 } \right ] p ( x ) \, d x \\ \int \text {which we have performed the integration over} .
$$

in which we have performed the integration over t .
