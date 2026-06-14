[Page 20]

## Appendix A-Proof of Theorem 3.1

Proof. By Theorem 2.1, we decompose λ D X | D Y 1: m to write

$$
\lambda _ { \mathcal { D } _ { X } | D _ { Y ^ { 1 \colon m } } } = \lambda _ { \mathcal { D } _ { X _ { V } } | D _ { Y ^ { 1 \colon m } } } + \lambda _ { \mathcal { D } _ { X _ { O } } | D _ { Y ^ { 1 \colon m } } } = ( 1 - \alpha ( x ) ) \lambda _ { \mathcal { D } _ { X } } + \lambda _ { \mathcal { D } _ { X _ { O } } | D _ { Y ^ { 1 \colon m } } } ,
$$

where the second equality follows because D X V is independent of D Y . Theorem 2.1 allows us to express λ D X O as the average of intensity functions λ D X i O for i = 1 , ··· ,m , where the D X i O are independent and equal in distribution to D X O . That is, λ D X O = 1 m m i =1 λ D X i O , and by conditioning we have, 1 m

$$
\int \nolimits _ { X _ { O } } \Delta _ { X _ { O } } \int _ { m } \Delta _ { X _ { O } ^ { i } } \int _ { m } \int _ { X _ { O } ^ { i } } ^ { X _ { O } } \int _ { m } \\ \lambda _ { \mathcal { D } _ { X _ { O } } | D _ { Y _ { 1 } ; m } } = \frac { 1 } { m } \sum _ { i = 1 } ^ { \int } \lambda _ { \mathcal { D } _ { X _ { i } } | D _ { Y _ { i } } } .
$$

So to expand Equation (12) it suﬃces to compute λ D X i O | D Y i for ﬁxed i . First, we express the ﬁnite PP ( D X , D Y ) as a marked Poisson PP. To this end, we adopt a construction from [53], the augmented space W   := W ∪ { ∆ } , where ∆ is a dummy set used for labeling points in D Y S . Next, we deﬁne the random set, H = H W ∪ H ∆ such that

$$
\mathcal { H } \coloneqq \left \{ ( x , y ) \in ( \mathcal { D } _ { X _ { O } } , \mathcal { D } _ { Y _ { O } } ) \right \} \bigcup \left \{ ( \Delta , y ) | y \in \mathcal { D } _ { Y _ { S } } \right \} .
$$

One can observe that H is the superposition of two marked Poisson PPs H W and H ∆ , taking values in W × W and ∆ × W , respectively. Moreover, it directly follows from ( M 2) and ( M 3)( i ) that H W has marginal intensity function α ( x ) λ D X ( x ) on W and stochastic kernel density   ( y | x ) while ( M 3)( ii ) shows that H ∆ has marginal intensity function λ D Y S ( W ) on { ∆ } with stochastic kernel density λ D Y S ( y ) λ D Y S ( W ) . By Theorem 2.3, the intensity functions for H W and H ∆ are α ( x ) λ D X ( x )   ( y | x ) and λ D Y S ( y ), respectively. Hence, applying Theorem 2.1 to Equation (14) reveals that the intensity function for H , λ H , is given by

$$
\lambda _ { \mathcal { H } } ( x , y ) = \alpha ( x ) \lambda _ { \mathcal { D } _ { X } } ( x ) \ell ( y | x ) \mathbb { 1 } _ { x \in \mathbb { W } } + \lambda _ { D _ { Y _ { S } } } ( y ) \mathbb { 1 } _ { x = \Delta } .
$$

Let H Y := { y : ( x,y ) ∈ H} , H X := { x : ( x,y ) ∈ H} be the projections of H onto its ﬁrst and second coordinates, respectively. It immediately follows from Theorem 2.2 that H Y is a Poisson PP on W since it is the image of H under a projection. Therefore, by treating the ﬁrst coordinates of H as marks, we may express H as a marked Poisson PP having intensity function λ H Y on W and stochastic kernel density p ( x | y ) from W to W   . Another application of Theorem 2.3 then implies

$$
\lambda _ { \mathcal { H } } ( x , y ) = \lambda _ { \mathcal { H } _ { Y } } ( y ) p ( x | y ) .
$$

From Equations (15) and (16), we obtain the identity

$$
p ( x | y ) = \frac { \alpha ( x ) \lambda _ { \mathcal { D } _ { X } } ( x ) \ell ( y | x ) 1 _ { x \in W } + \lambda _ { D _ { Y _ { S } } } ( y ) 1 _ { x = \Delta } } { \lambda _ { \mathcal { H } _ { Y } } ( y ) } , \ \lambda _ { \mathcal { H } _ { Y } } ( y ) \neq 0 .
$$

glyph[negationslash]
