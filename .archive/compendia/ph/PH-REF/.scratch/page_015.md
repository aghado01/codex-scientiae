[Page 15]

## 6.2. Minimax Lower Bound. Let us recall Le Cam’s Lemma.

Lemma 6.5 (Le Cam) . Let Q be a set of probability distributions, and θ : Q → Θ be a parameter of interest, where (Θ ,  ) is a metric space. Then for all Q,Q ∈ Q ,

$$
\inf _ { \hat { \theta } } \sup _ { Q \in \mathcal { Q } } \mathbb { E } _ { Q ^ { n } } \ell ( \theta ( Q ) , \hat { \theta } _ { n } ) \geq \frac { 1 } { 2 } \ell \left ( \theta ( Q ) , \theta ( Q ^ { \prime } ) \right ) \left ( 1 - T V ( Q , Q ^ { \prime } ) \right ) ^ { n } ,
$$

where ˆ θ n = ˆ θ n ( X 1 ,...,X n ) ranges among all the measurable maps ˆ θ n : X n → Θ based on an i.i.d. n -sample.

Theorem 6.6 . Assume that there exists a non isolated point x in M and consider any sequence ( x n ) n ∈ ( M \ { x } ) N such that ρ ( x,x n ) ( an ) − 1 /b . Then for all estimator dgm n = dgm n ( X 1 ,...,X n ) ,

$$
\liminf _ { n \to \infty } \rho ( x , x _ { n } ) ^ { - 1 } \sup _ { \mu \in \mathcal { P } _ { M , a , b } } \mathbb { E } _ { \mu ^ { n } } \left [ d _ { b } ( d g m ( \text {Filt} ( \mathbb { X } _ { \mu } ) ) , \widehat { d g m } _ { n } ) \right ] \geqslant e ^ { - 1 } / 4 .
$$

Remark 6.7. Consequently, the estimator dgm(Filt( X n )) is minimax optimal on the space P M,a,b up to a logarithmic term as soon as we can ﬁnd a non-isolated point in M and a sequence ( x n ) in M such that ρ ( x n ,x ) ∼ ( an ) − 1 /b . This is obviously the case for the Euclidean space R d .

Proof. We will apply Le Cam’s lemma with model Q = P M,a,b , parameter of interest θ ( µ ) = dgm(Filt( X µ )) in the space Θ of persistence diagrams of q-tame modules endowed with distance = d b .

To prove the lower bound, it will be suﬃcient to consider two Dirac distributions. We let µ 0 = δ x be the Dirac distribution on X 0 := { x } . It is clear that µ 0 ∈ P M,a,b . Let µ 1 ,n be the distribution 1 n δ x n + (1 − 1 n ) µ 0 . The support of µ 1 ,n is denoted X 1 ,n := { x,x n } . Note that for all n 2 and r ρ ( x,x n ),

$$
\mu _ { 1 , n } \left ( B ( x , r ) \right ) = 1 - \frac { 1 } { n } \geqslant \frac { 1 } { 2 } \geqslant \frac { 1 } { 2 \rho ( x , x _ { n } ) ^ { b } } r ^ { b } \geqslant a r ^ { b }
$$

and

$$
\mu _ { 1 , n } \left ( B ( x _ { n } , r ) \right ) = \frac { 1 } { n } = \frac { 1 } { n \rho ( x , x _ { n } ) ^ { b } } r ^ { b } \geqslant a r ^ { b } .
$$

Moreover, for r > ρ ( x,x n ), µ 1 ,n (B( x,r )) = µ 1 ,n (B( x n ,r )) = 1. Thus, for all r > 0 and x ∈ X 1 ,n ,

$$
\mu _ { 1 , n } \left ( B ( x , r ) \right ) \geqslant \min \{ a r ^ { b } , 1 \} ,
$$

meaning that µ 1 ,n belongs to P M,a,b .

The probability measure µ 0 is absolutely continuous with respect to µ 1 ,n and the density of µ 0 with respect to µ 1 ,n is p 0 ,n := n n − 1 { x } . Then

$$
\text {the probability measure } \mu _ { 0 } \text { is absolutely continuous with respect to } \\ \text {the density of } \mu _ { 0 } \text { with respect to } \mu _ { 1 , n } \text { is } p _ { 0 , n } \colon = \frac { n } { n - 1 } \mathbb { I } _ { \{ x \} } . \text { Then} \\ \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \
$$

so that (1 -TV( µ 0 , µ 1 ,n )) n = ( 1 -1 n ) n → e -1 as n goes to infinity.

It remains to compute d b (dgm(Filt( X 0 )) , dgm(Filt( X 1 ,n ))). For both X 0 and X 1 ,n , notice that the diagrams induced by the Rips and ˇ Cech filtrations are equal and that these diagrams are non-trivial only for the 0-dimensional homology. Furthermore, dgm 0 (Filt( X 0 )) is the singleton { (0 , + ∞ ) } . On the other hand, dgm 0 (Filt( X 1 ,n )) = { (0 , ∞ ) , (0 , ρ ( x, x n )) } . Thus,
