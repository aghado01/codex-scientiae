[Page 28]

![image 4](<MMO2019/imageFile4.png>)

Figure 4: Cardinality probabilities P [ | D | = N ] for random diagram D distributed according to global pdf K σ ( · , D ) in Ex. 2. In general, we have that 0 ≤ | D u | ≤ | D u | and according to Eq. (5.1), ν ( N )   = 0 for 0 ≤ N ≤ 2   D     . Thus, the cardinality | D | = | D u | +   D     takes on values between 0 and 6 = | D u | + 2 D   .

glyph[negationslash]

Following Def. 24, we project the features of D onto the diagonal to obtain { (1 . 15 , 1 . 15) , (3 . 1 , 3 . 1) } . Relying on Eq. (4.4), the resulting lower density is given by

$$
p ^ { \ell } ( b , d ) = \frac { 2 } { \pi } \left [ e ^ { - \left ( ( b - 1 . 1 5 ) ^ { 2 } + ( d - 1 . 1 5 ) ^ { 2 } \right ) } + e ^ { - \left ( ( b - 3 . 1 ) ^ { 2 } + ( d - 3 . 1 ) ^ { 2 } \right ) } \right ] .
$$

restricted to the wedge W . The coeﬃcient 2 π is obtained by a direct substitution into Eq. (4.4).

Due to the ﬂexible input cardinality, the kernel will be expressed and plotted separately for diﬀerent input cardinalities. For brevity, we present the local kernels on W N ⊂ R 2 N for cardinalities N = 1 , 2 , 3. First, we consider the probability hypothesis density (or PHD, as deﬁned in Eq. (3.8)) along with the kernel density evaluated at a single input feature in Fig. 5. Recall that the integral of the PHD over a region U yields the expected number of features in U (see deﬁnition 18). The kernel’s corresponding PHD is a sum of Gaussians as described in Corollary 28.

$$
K _ { \sigma , P H D } ( ( b , d ) , \mathcal { D } ) & = 2 p ^ { \ell } ( b , d ) + q ^ { ( 1 ) } p ^ { ( 1 ) } ( b , d ) + q ^ { ( 2 ) } p ^ { ( 2 ) } ( b , d ) \\ & = 1 . 2 7 3 \left ( e ^ { - 2 ( ( b - 3 . 1 ) ^ { 2 } + ( d - 3 . 1 ) ^ { 2 } ) } + e ^ { - 2 ( ( b - 1 . 1 5 ) ^ { 2 } + ( d - 1 . 1 5 ) ^ { 2 } ) } \right ) \\ & \quad + 0 . 6 3 5 e ^ { - 2 ( ( b - 2 ) ^ { 2 } + ( d - 4 ) ^ { 2 } ) } + 0 . 6 3 5 e ^ { - 2 ( ( b - 1 ) ^ { 2 } + ( d - 3 ) ^ { 2 } ) } .
$$

Next, for input of cardinality | Z | = 1, we obtain an easily viewable 2-dimensional distribution. Theorem 25 yields the following expression:

$$
K _ { \sigma } ( ( b _ { 1 } , d _ { 1 } ) , \mathcal { D } ) & = \nu ( 0 ) \left [ ( 1 - q ^ { ( 2 ) } ) q ^ { ( 1 ) } p ^ { ( 1 ) } ( b _ { 1 } , d _ { 1 } ) + ( 1 - q ^ { ( 1 ) } ) q ^ { ( 2 ) } p ^ { ( 2 ) } ( b _ { 1 } , d _ { 1 } ) \right ] \\ & + \nu ( 1 ) \left [ ( 1 - q ^ { ( 1 ) } ) ( 1 - q ^ { ( 2 ) } ) p ^ { \ell } ( b _ { 1 } , d _ { 1 } ) \right ] . \\ & = 7 . 7 4 \times 1 0 ^ { - 2 } \left ( e ^ { - 2 ( b _ { 1 } - 2 ) ^ { 2 } + ( d _ { 1 } - 4 ) ^ { 2 } } + e ^ { - 2 ( ( b _ { 1 } - 1 ) ^ { 2 } + ( d _ { 1 } - 3 ) ^ { 2 } ) } \right ) . \\ & + 1 . 6 5 \times 1 0 ^ { - 4 ^ { p ^ { \ell } ( b _ { 1 } , d _ { 1 } ) } } .
$$

The kernel is treated as a global pdf as in Proposition 13 and Rmk. 14; thus, this 2-D density is only a local density for the whole kernel. Each term is a weighted product of the combination of upper features considered (In order: (2 , 4), (1 , 3), or none.). Since the values of q ( j ) are very close to 1, terms which include the upper pdfs p ( j ) have much larger total mass.

Contour plots of the densities expressed in Eqs. (5.4) and (5.5) (restricted to W ) are respectively shown in Figs. 5(a) and 5(b). In Fig. 5(a), the PHD indicates that in general, as many features will appear near the diagonal as will appear near the upper features. According to the local kernel shown in Fig. 5(b), if only a single feature is present, this feature is far more likely to have long persistence. Indeed, the kernel density is defined (see Eq. (4.6)) so that the number of points near the diagonal is fluid (by our choice of ν ), whereas the probability of each feature in the upper diagram is nearly 1. In essence, this demonstrates that the kernel density naturally considers features with long persistence to be stable or prominent in density estimation.
