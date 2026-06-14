[Page 21]

Equation (17) describes the probability density of H at x ∈ W   for y ∈ W ﬁxed. Substituting Equation (17) for the Janossy density in Equation (1) and applying Corollary 2.1 gives the intensity function for the point process H X | D Y i whenever λ H Y ( y )   = 0 for any y ∈ D Y i ,

glyph[negationslash]

$$
\lambda _ { \mathcal { H } _ { X } | D _ { Y _ { i } } } ( x ) = \sum _ { y \in D _ { Y ^ { i } } } \frac { \alpha ( x ) \lambda _ { \mathcal { D } _ { X } } ( x ) \ell ( y | x ) 1 _ { x \in W } + \lambda _ { D _ { Y _ { S } } } ( y ) 1 _ { x = \Delta } } { \lambda _ { \mathcal { H } _ { Y } } ( y ) } , \ \lambda _ { \mathcal { H } _ { Y } } ( y ) \neq 0
$$

glyph[negationslash]

Restricting Equations (15) and (16) to W × W , we obtain

p ( x | y ) λ H Y ( y ) =   ( y | x ) α ( x ) λ D X ( x ). Thus,   ( y | x ) α ( x ) λ D X ( x ) = 0

whenever λ H Y ( y ) = 0, from which we conclude λ H Y ( y ) = 0 a.s. . Hence, restricting Equation (18) to W × W yields

glyph[negationslash]

$$
\lambda _ { \mathcal { D } _ { X _ { O } } | D _ { Y _ { i } } } ( x ) = \sum _ { y \in D _ { Y ^ { i } } } \frac { \alpha ( x ) \lambda _ { \mathcal { D } _ { X } } ( x ) \ell ( y | x ) } { \lambda _ { \mathcal { H } _ { Y } } ( y ) } , \quad a . s .
$$

Notice that H Y is the same PP as D Y O ∪D Y S . Theorems 2.2 and 2.3 imply that D Y O is a Poisson PP, and D Y S is a Poisson PP by (M3), so by Theorem 2.1, λ H Y = λ D Y O + λ D Y S , where λ D Y O ( y ) = λ ( D X O , D Y O ) ( W × y ) =   W α ( u ) λ D X O ( u )   ( y | u ) du by Theorem 2.3. Employing Equation (19) one gets that

$$
\lambda _ { \mathcal { D } _ { X _ { O } } | D _ { Y i } } ( x ) = \alpha ( x ) \sum _ { y \in D _ { Y ^ { i } } } \frac { \ell ( y | x ) \lambda _ { \mathcal { D } _ { X } } ( x ) } { \lambda _ { \mathcal { D } _ { Y _ { S } } } ( y ) + \int _ { \mathbb { W } } \ell ( y | u ) \alpha ( u ) \lambda _ { \mathcal { D } _ { X } } ( u ) d u } ,
$$

which proves Theorem 3.1 after substituting into Equation (12).

glyph[squaresolid]

## Acknowledgments

Research has been partially funded by the Army Research Oﬃce, W911NF-17-1-0313, the National Science Foundation, MCB-1715794, and DMS-1821241, and Thor Industries/Army Research Lab, W911NF-17-20141.

## References

- [1] H. Adams and et. al. , Persistence images: A stable vector representation of persistent homology , Journal of Machine Learning Research, 18 (2017), pp. 218–252, http://jmlr.org/papers/v18/16-337. html .
- [2] A. Adcock, E. Carlsson, and G. Carlsson , The ring of algebraic functions on persistence bar codes , Homology, Homotopy and Applications, 18 (2016), pp. 381–402, https://doi.org/10.4310/ HHA.2016.v18.n1.a21 .
- [3] A. Babichev and Y. Dabaghian , Persistent memories in transient networks , Emergent Complexity from Nonlinearity, in Physics, Engineering and the Life Sciences, 191 (2017), pp. 179–188.
- [4] P. Bendich, J. S. Marron, E. Miller, A. Pieloch, and S. Skwerer , Persistent homology analysis of brain artery trees , The Annals of Applied Statistics, 10 (2016), pp. 198–218, https://doi. org/10.1214/15-AOAS886 .
- [5] C. Biscio and J. Møller , The accumulated persistence function, a new useful functional summary statistic for topological data analysis, with a view to brain artery trees and spatial point process applications , Journal of Computational and Graphical Statistics, (2019), pp. 1537–2715, https: //doi.org/10.1080/10618600.2019.1573686 .
