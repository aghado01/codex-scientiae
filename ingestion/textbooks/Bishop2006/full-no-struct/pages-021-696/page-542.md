[Page 542]

where Z j is the normalization constant deﬁned by (10.197). By applying this result recursively, and initializing with p 0 ( D ) = 1 , derive the result

$$
p ( \mathcal { D } ) \simeq \prod _ { j } Z _ { j } .
$$

10.37 ( ) www Consider the expectation propagation algorithm from Section 10.7, and suppose that one of the factors f 0 ( θ ) in the deﬁnition (10.188) has the same exponential family functional form as the approximating distribution q ( θ ) . Show that if the factor f 0 ( θ ) is initialized to be f 0 ( θ ) , then an EP update to reﬁne f 0 ( θ ) leaves f 0 ( θ ) unchanged. This situation typically arises when one of the factors is the prior p ( θ ) , and so we see that the prior factor can be incorporated once exactly and does not need to be reﬁned.

10.38 ( ) In this exercise and the next, we shall verify the results (10.214)–(10.224) for the expectation propagation algorithm applied to the clutter problem. Begin by using the division formula (10.205) to derive the expressions (10.214) and (10.215) by completing the square inside the exponential to identify the mean and variance. Also, show that the normalization constant Z n , deﬁned by (10.206), is given for the clutter problem by (10.216). This can be done by making use of the general result (2.115).

10.39 ( ) Show that the mean and variance of q new ( θ ) for EP applied to the clutter problem are given by (10.217) and (10.218). To do this, ﬁrst prove the following results for the expectations of θ and θθ T under q new ( θ )

$$
\mathbb { E } [ \theta ] \ = \ \mathbf m ^ { \langle n } + v ^ { \langle n } \nabla _ { m ^ { \langle n } } \ln Z _ { n } & & ( 1 0 . 2 4 4 ) \\ \mathbb { F } [ \theta ^ { T } \theta ] \ = \ \mathcal { 2 } ( v ^ { \langle n } ) ^ { 2 } \nabla _ { \xi } \, \cdot \, \ln Z _ { n } \, & & \mathbb { W } [ \theta ] ^ { T } _ { m } \langle n \, \rangle _ { | m | } \, \| \mathbf m ^ { \langle n } \| ^ { 2 } \, & & ( 1 0 . 2 4 5 )
$$

$$
\mathbb { E } [ \theta ^ { T } \theta ] \ = \ 2 ( v ^ { \wedge n } ) ^ { 2 } \nabla _ { v ^ { \wedge n } } \ln Z _ { n } + 2 \mathbb { E } [ \theta ] ^ { T } m ^ { \wedge n } - \| m ^ { \wedge n } \| ^ { 2 } \quad ( 1 0 . 2 4 5 )
$$

and then make use of the result (10.216) for Z n . Next, prove the results (10.220)– (10.222) by using (10.207) and completing the square in the exponential. Finally, use (10.208) to derive the result (10.223).
