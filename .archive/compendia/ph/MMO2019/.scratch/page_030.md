[Page 30]

If we consider the density evaluated along slices as K σ ((( b,d ) , (1 , 3)) , D ) or K σ ((( b,d ) , (2 , 4)) , D ) (Fig. 6 (a) or (b), respectively), the restricted plot is a Gaussian centered at the other upper feature. If the ﬁxed feature is instead close to the diagonal, as in Fig. 6 (c), the density slice is close to a mixture between the two upper Gaussians p (1) and p (2) .




Birth

(a)

9/500

7/500

5/500

3/500

1/500

![The image depicts a geometric diagram with three triangles labeled as Death, Birth, and Death. Each triangle is divided into four smaller triangles, each of which is labeled with a different number. The triangles are arranged in a specific pattern, with the Death triangle at the top, the Birth triangle at the bottom, and the Death triangle at the bottom. Here is a detailed description of the image: ### Detailed Description: 1. **Title and Labels**: - The title of the image is Death, and it is located at the top center. - The label Birth is located below Death and is located at the bottom left. - The label Death is located at the top center. 2. **Triangles**: - The diagram consists of three triangles labeled Death, Birth, and Death. - Each triangle is divided into four smaller triangles, each of which is](<MMO2019/imageFile7.png>)

9/500

7/500

5/500


3/500

1/500

Birth

(b)




Birth

(c)

9/10000

7/10000

5/10000

3/10000

1/10000

Figure 6: Contour maps for slices of the kernel density K σ (( ξ,ξ 2 ) , D ) with input cardinality 2. A single feature ξ 2 , indicated by white crosshairs, is ﬁxed to restrict to a 2D subspace as follows: (a) ξ 2 = (1 , 3) (b) ξ 2 = (2 , 4) and (c) ξ 2 = (2 . 5 , 2 . 7). The center diagram is indicated by red (upper) and green (lower) points. Scale bars at the right of each plot indicate the range of probability density in each shaded region.

In a similar fashion, we also express the kernel density with input cardinality | Z | = 3. Since there are only 2 upper features in D , this and further expressions are not markedly more complicated than Eq. (5.6). From Eq. (4.6), we obtain:

$$
that E q . \ ( 5 . 6 ) \, \text { From Eq. } \ ( 4 . 6 ) , \, \text { we obtain:} \\ K _ { \sigma } ( ( \xi _ { 1 } , \xi _ { 2 } , \xi _ { 3 } ) , \mathcal { D } ) & = \nu ( 1 ) \left [ q ^ { ( 1 ) } q ^ { ( 2 ) } p ^ { ( 1 ) } ( b _ { 1 } , d _ { 1 } ) p ^ { ( 2 ) } ( b _ { 2 } , d _ { 2 } ) \right ] p ^ { \ell } ( b _ { 3 } , d _ { 3 } ) \\ & + \nu ( 2 ) ( 1 - q ^ { ( 2 ) } ) q ^ { ( 1 ) } p ^ { ( 1 ) } ( b _ { 1 } , d _ { 1 } ) p ^ { \ell } ( b _ { 2 } , d _ { 2 } ) p ^ { \ell } ( b _ { 3 } , d _ { 3 } ) \\ & + \nu ( 2 ) ( 1 - q ^ { ( 1 ) } ) q ^ { ( 2 ) } p ^ { ( 2 ) } ( b _ { 1 } , d _ { 1 } ) p ^ { \ell } ( b _ { 2 } , d _ { 2 } ) p ^ { \ell } ( b _ { 3 } , d _ { 3 } ) \\ & + \nu ( 3 ) ( 1 - q ^ { ( 1 ) } ) ( 1 - q ^ { ( 2 ) } ) p ^ { ( 2 ) } ( b _ { 1 } , d _ { 1 } ) p ^ { \ell } ( b _ { 2 } , d _ { 2 } ) p ^ { \ell } ( b _ { 3 } , d _ { 3 } ) . \\ & = \ 9 . 0 1 \times 1 0 ^ { - 2 } \ell ^ { \ell } ( b _ { 3 } , d _ { 3 } ) e ^ { - 2 ( ( b _ { 1 } - 1 ) ^ { 2 } + ( d _ { 1 } - 3 ) ^ { 2 } ) } e ^ { - 2 ( ( b _ { 2 } - 2 ) ^ { 2 } + ( d _ { 2 } - 4 ) ^ { 2 } ) } \\ & + 4 . 9 6 \times 1 0 ^ { - 4 } \ell ^ { p ^ { \ell } } ( b _ { 2 } , d _ { 2 } ) p ^ { ( 3 ) } ( b _ { 3 } , d _ { 3 } ) e ^ { - 2 ( ( b _ { 1 } - 2 ) ^ { 2 } + ( d _ { 1 } - 4 ) ^ { 2 } ) } \\ & + 4 . 9 6 \times 1 0 ^ { - 4 } \ell ^ { p ^ { \ell } } ( b _ { 2 } , d _ { 2 } ) p ^ { ( 3 , b _ { 3 } ) } d _ { 3 } ) e ^ { - 2 ( ( b _ { 1 } - 1 ) ^ { 2 } + ( d _ { 1 } - 3 ) ^ { 2 } ) } \\ & + 1 . 2 2 \times 1 0 ^ { - 6 } \ell ^ { p ^ { \ell } } ( b _ { 1 } , d _ { 1 } ) p ^ { ( 2 ) } ( b _ { 2 } , d _ { 2 } ) p ^ { \ell } ( b _ { 3 } , d _ { 3 } ) . \\ & \text {One may notice that } E q . \ ( 5 . 7 ) \, \text { has the same } 4 \, \text { terms as } E q . \ ( 5 . 6 ) , \, \text { but with another factor of } \\
$$

One may notice that Eq. (5.7) has the same 4 terms as Eq. (5.6), but with another factor of p glyph[lscript] in each term. Indeed, the local kernels for input cardinality N = 4 , 5 , 6 appear very similar as well, and with progressively more factors of p glyph[lscript] . Contour plot slices of this local kernel are shown in Fig. 7, following Rmk. 41. In this case, since the local pdf is defined in W 3 , we must fix a pair of features in order to view a slice in W ×{ ( b ′ 2 , d ′ 2 ) } × { ( b ′ 3 , d ′ 3 ) } . In Eq. (5.7), the heaviest weighted term consists of both upper features' densities as well as the lower density p glyph[lscript] ( b 3 , d 3 ). Indeed, Fig. 7(a) shows the slice K σ ((( b, d ) , (1 , 3) , (2 , 4)) , D ), which leaves both upper features fixed, and the resulting slice is nearly proportional to the lower density p glyph[lscript] . Fig. 7 (b) shows the slice K σ ((( b, d ) , (1 , 3) , (2 . 5 , 3 . 5)) , D ), which fixes one of the upper features of D as well as a feature of moderate persistence. This slice does not go through a mode of the local kernel, and so the geometry of the dataspace W 3 / Π 3 makes the slice look multi-modal, depending on whether (2 . 5 , 3 . 5) is assigned to p (2) or p glyph[lscript] . Other assignments have negligible mass. Thus, Fig. 7 (b) resembles a mixture of these two densities.
