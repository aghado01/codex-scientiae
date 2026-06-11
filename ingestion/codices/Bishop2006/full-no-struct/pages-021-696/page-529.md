[Page 529]

sides of (10.199) by q \ i ( θ ) and integrating to give

$$
q ^ { \prime } ( 6 ) \text { and integer} \, & \text { to give} \\ K = \int \widetilde { f } _ { j } ( \theta ) q ^ { \, \jmath \, j } ( \theta ) \, d \theta \\ \intertext { t h e f a t h } \text { the fact that } q ^ { \text {new} } ( 6 ) \text { is normalized. The value of } K \text { can therefore } \text { } \text { zeroth-order moments}
$$

where we have used the fact that q new ( θ ) is normalized. The value of K can therefore be found by matching zeroth-order moments

$$
& \text {by matching 2erouh-order moments} \\ & \int \widetilde { f } _ { j } ( \theta ) q ^ { \jmath } ( \theta ) \, d \theta = \int f _ { j } ( \theta ) q ^ { \jmath } ( \theta ) \, d \theta . \quad ( 1 0 . 2 1 ) \\ \intertext { g t h i s w i t h } & \text {with } ( 1 0 . 1 7 ) , \text { we then see that } K = Z _ { j } \text { and so can be found by } \\ & \text {the integral in } ( 1 0 , 1 9 7 ) ,
$$

Combining this with (10.197), we then see that K = Z j and so can be found by evaluating the integral in (10.197).

In practice, several passes are made through the set of factors, revising each factor in turn. The posterior distribution p ( θ |D ) is then approximated using (10.191), and the model evidence p ( D ) can be approximated by using (10.190) with the factors f i ( θ ) replaced by their approximations f i ( θ ) . Expectation Propagation

We are given a joint distribution over observed data D and stochastic variables θ in the form of a product of factors

$$
p ( \mathcal { D } , \theta ) = \prod _ { i } f _ { i } ( \theta ) & & ( 1 0 . 2 0 ) \\ \intertext { v i m o t e , t h o s e r } \text {cov} \intertext { o n v i m o t e , t h o s e r } \intertext { i n v i m o t e , t h o s e r } \intertext { o n v i m o t e , t h o s e r } \intertext { v i m o t e , t h o s e r }
$$

and we wish to approximate the posterior distribution p ( θ |D ) by a distribution of the form 1

$$
q ( \theta ) = \frac { 1 } { Z } \prod _ { i } \widetilde { f } _ { i } ( \theta ) . \quad & ( 1 0 . 2 3 ) \\ \text {proximate the model evidence } p ( \mathcal { D } ) .
$$

We also wish to approximate the model evidence p ( D ) .

1. Initialize all of the approximating factors f i ( θ ) . 2. Initialize the posterior approximation by setting

$$
q ( \theta ) \otimes \prod _ { i } \widetilde { f } _ { i } ( \theta ) .
$$

3. Until convergence:

- (a) Choose a factor ˜ f j ( θ ) to refine.
- (b) Remove ˜ f j ( θ ) from the posterior by division

$$
q ^ { \langle j } ( \theta ) = \frac { q ( \theta ) } { \widetilde { f } _ { j } ( \theta ) } .
$$
