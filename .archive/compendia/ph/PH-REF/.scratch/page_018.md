[Page 18]

idea is to extract many subsamples, to compute the landscape for each subsample and then to combine the information. T

We assume that the diameter of M is ﬁnite and upper bounded by 2 , where T is the same constant as in the deﬁnition of persistence landscapes in Section 7.1. For ease of exposition, we focus on the case k = 1, and set λ ( t ) = λ (1 ,t ). However, the results we present in this section hold for k > 1.

For any positive integer m , let X = { x 1 , ··· ,x m } ⊂ X µ be a sample of m points from µ . The corresponding persistence landscape is λ X and we denote by Ψ m µ the measure induced by µ ⊗ m on the space of persistence landscapes. Note that the persistence landscape λ X can be seen as a single draw from the measure Ψ m µ . The point-wise expectations of the (random) persistence landscape under this measure is deﬁned by E Ψ m µ [ λ X ( t )] ,t ∈ [0 ,T ]. The average landscape E Ψ m µ [ λ X ] has a natural empirical counterpart, which can be used as its unbiased estimator. Let S m 1 ,...,S m be independent samples of size m from µ ⊗ m . We deﬁne the empirical average landscape as

$$
\overline { \lambda _ { \ell } ^ { m } } ( t ) = \frac { 1 } { b } \sum _ { i = 1 } ^ { b } \lambda _ { S _ { i } ^ { m } } ( t ) , \quad \text {for all } t \in [ 0 , T ] ,
$$

and propose to use λ m to estimate λ X µ .

Remark 7.5. (i) Note that computing the persistent homology of X n is O (exp( n )), whereas computing the average landscape is O ( b exp( m )).

(ii) Another motivation for this subsampling approach is that it can be also applied when µ is a discrete measure with support X N = { x 1 ,...,x N } ⊂ M . This framework can be very common in practice, when a continuous (but unknown measure) is approximated by a discrete uniform measure µ N on X N .

The average landscape E Ψ m µ [ λ X ] is an interesting quantity on its own, since it carries some stable topological information about the underlying measure µ , from which the data are generated. In particular, we can compare the average landscapes corresponding to two measures that are close to each other in the Wasserstein metric. The average behavior of the landscapes of sets of m points sampled according to any measure µ is stable with respect to the Wasserstein distance:

Theorem 7.6 . Let X ∼ µ ⊗ m and Y ∼ ν ⊗ m , where µ and ν are two probability measures on M . For any p 1 we have

$$
\left \| \mathbb { E } _ { \Psi _ { \mu } ^ { m } } [ \lambda _ { X } ] - \mathbb { E } _ { \Psi _ { \nu } ^ { m } } [ \lambda _ { Y } ] \right \| _ { \infty } \leqslant 2 m ^ { \frac { 1 } { p } } \ W _ { p } ( \mu , \nu ) ,
$$

 where W p stands for the p th Wasserstein distance on M , deﬁned by

$$
W _ { p } ( \mu , \nu ) = \inf _ { \pi \in \Pi ( \mu , \nu ) } \left ( \int _ { M \times M } \rho ( x , y ) ^ { p } \pi ( d x , d y ) \right ) ^ { \frac { 1 } { \frac { p } { p } } } ,
$$

where Π( µ,ν ) is the set of probability measures on M × M with marginal distributions µ and ν ,

$$
\text { See } [ \text {CFL} ^ { + } 1 5 , \text { Thereom 5} ] & & \Box
$$

Proof. See [CFL +
