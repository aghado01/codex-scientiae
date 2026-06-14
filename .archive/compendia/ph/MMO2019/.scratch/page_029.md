[Page 29]

![image 5](<MMO2019/imageFile5.png>)

9/10

7/10


5/10


3/10

1/10



Birth

(a)

![The image is a bar chart titled Death. The chart is divided into three sections, each representing a different birth event: birth, birth, and birth. The x-axis represents the birth date, ranging from 0 to 5, while the y-axis represents the death rate. The chart has three bars, each representing a different birth event: 1. **Birth**: The bar for this event is the longest, with a height of 5. 2. **Birth**: The bar for this event is the shortest, with a height of 1. 3. **Birth**: The bar for this event is the shortest, with a height of 0.5. The chart also includes a legend on the right side, which explains the color coding: - The color of the bar for birth is blue. - The color of the bar for birth is green. - The color of the bar for birth is orange. - The](<MMO2019/imageFile6.png>)

9/50000

7/50000


5/50000


3/50000

1/50000

Birth

(b)

Figure 5: Contour maps for (a) the probability hypothesis density associated to the kernel density (Eq. (5.4)) and (b) the kernel density restricted to a single input feature (Eq. (5.5)). The center diagram is indicated by red (upper) and green (lower) points. Scale bars at the right of each plot indicate the range of probability density in each shaded region.

Taking Z = ( ξ 1 ,ξ 2 ) = (( b 1 ,d 2 ) , ( b 2 ,d 2 )), we arrive at a more complex expression for the kernel density when considering 2 input features. From Eq. (4.6), we obtain:

$$
\text {density when considering 2 input features. From Eq. (4.6), we obtain:} \\ K _ { \sigma } ( ( \xi _ { 1 } , \xi _ { 2 } ) , \mathcal { D } ) & = \nu ( 0 ) q ^ { ( 1 ) } q ^ { ( 2 ) } p ^ { ( 1 ) } ( b _ { 1 } , d _ { 1 } ) p ^ { ( 2 ) } ( b _ { 2 } , d _ { 2 } ) \\ & + \nu ( 1 ) \left [ ( 1 - q ^ { ( 2 ) } ) q ^ { ( 1 ) } p ^ { ( 1 ) } ( b _ { 1 } , d _ { 1 } ) + ( 1 - q ^ { ( 1 ) } ) q ^ { ( 2 ) } p ^ { ( 2 ) } ( b _ { 1 } , d _ { 1 } ) \right ] p ^ { \ell } ( b _ { 2 } , d _ { 2 } ) \\ & + \nu ( 2 ) ( 1 - q ^ { ( 1 ) } ) ( 1 - q ^ { ( 2 ) } ) p ^ { \ell } ( b _ { 1 } , d _ { 1 } ) p ^ { \ell } ( b _ { 2 } , d _ { 2 } ) \\ & = 4 . 5 \times 1 0 ^ { - 2 } e ^ { - 2 ( ( b _ { 1 } - 2 ) ^ { 2 } + ( d _ { 1 } - 4 ) ^ { 2 } ) } e ^ { - 2 ( ( b _ { 1 } - 1 ) ^ { 2 } + ( d _ { 1 } - 3 ) ^ { 2 } ) } \\ & + 2 . 1 1 \times 1 0 ^ { - 4 } \left [ e ^ { - 2 ( ( b _ { 1 } - 2 ) ^ { 2 } + ( d _ { 1 } - 4 ) ^ { 2 } ) } + e ^ { - 2 ( ( b _ { 1 } - 1 ) ^ { 2 } + ( d _ { 1 } - 3 ) ^ { 2 } ) } \right ] p ^ { \ell } ( b _ { 2 } , d _ { 2 } ) \\ & + 7 . 3 9 \times 1 0 ^ { - 7 } p ^ { \ell } ( b _ { 1 } , d _ { 1 } ) p ^ { \ell } ( b _ { 2 } , d _ { 2 } ) . \\
$$

Notice that this local kernel also decomposes into terms which describe presence of upper features: one term for both, one term for each of the two upper features, and the last term has no upper features. Contour plots of slices of this local kernel are shown in Fig. 6; a general description of slicing is given in Rmk. 41.

Remark 41 Slices are used to view local pdfs deﬁned on a high dimensional space W N ⊂ R 2 N for N > 1 . To obtain these slices, one ﬁxes features ( b j ,d j ) = ( b j ,d j ) for j = 2 ,...,N , and views the density on the corresponding hyperplane W × { ( b 2 ,d 2 ) } × ... × { ( b N ,d N ) } ⊂ W N . In practice, the ﬁxed features are chosen as modes of earlier (smaller N ) slices in order to view important parts of
