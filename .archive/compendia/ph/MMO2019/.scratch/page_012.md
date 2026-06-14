[Page 12]

0.12

0.08


0.04




![The image is a graph that shows the relationship between two variables. The x-axis represents the values of the variables, while the y-axis represents the values of the variables. The graph is labeled as f(x) = 0.035. The graph shows a downward trend in the values of the variables as the x-axis increases. The y-axis shows the values of the variables, with a value of 0.005. The graph shows a negative correlation between the two variables, with the negative correlation coefficient being -0.3. ### Analysis and Description: - **x-axis**: The x-axis represents the values of the variables, with a value of 0.035. - **y-axis**: The y-axis represents the values of the variables, with a value of 0.005. ### Interpretation: - **Positive correlation**: The graph shows](<MMO2019/imageFile2.png>)




0.035

0.025


0.015

0.005

23-2-1 0



Figure 2: Left: Plot of the local density f 1 ( x ) in Eq. (3.13a). Right: Contour plot of the local density f 2 ( x,y ) in Eq. (3.13b). These pdfs cover the diﬀerent possible input dimensions and are symmetric under permutations of the input.

f 0 = P [ | D | = 0] = (1 − q (1) )(1 − q (2) ) = 0 . 08, f 1 = f D   R , and f 2 = f D   R 2 . We sum over permutations and divide by N ! ( N = 1 , 2 is the input cardinality) to obtain a symmetric global pdf.

$$
f _ { 1 } ( x ) & = ( 1 - q ^ { ( 2 ) } ) q ^ { ( 1 ) } p ^ { ( 1 ) } ( x ) + ( 1 - q ^ { ( 1 ) } ) q ^ { ( 2 ) } p ^ { ( 2 ) } ( x ) \\ & = \frac { 0 . 1 2 } { \sqrt { 2 \pi } } e ^ { - ( x + 1 ) ^ { 2 } / 2 } + \frac { 0 . 3 2 } { \sqrt { 2 \pi } } e ^ { - ( x - 1 ) ^ { 2 } / 2 } ,
$$

$$
f _ { 2 } ( x , y ) & = \frac { q ^ { ( 1 ) } q ^ { ( 2 ) } } { 2 } \left [ p ^ { ( 1 ) } ( x ) p ^ { ( 2 ) } ( y ) + p ^ { ( 1 ) } ( y ) p ^ { ( 2 ) } ( x ) \right ] \\ & = \frac { 0 . 2 4 } { 2 \pi } \left ( e ^ { - ( ( x - 1 ) ^ { 2 } + ( y + 1 ) ^ { 2 } ) / 2 } + e ^ { - ( ( x + 1 ) ^ { 2 } + ( y - 1 ) ^ { 2 } ) / 2 } \right ) .
$$

Accounting for each cardinality and following Eq. (3.13a) and Eq. (3.13b), the total probability adds up to

$$
\mathbb { P } [ | D | = 0 ] + \mathbb { P } [ | D | = 1 ] + \mathbb { P } [ | D | = 2 ] & = f _ { 0 } + \int _ { \mathbb { R } } f _ { 1 } ( x ) d x + \int _ { \mathbb { R } ^ { 2 } } f _ { 2 } ( x , y ) d x d y \\ & = ( 0 . 0 8 ) + ( 0 . 1 2 + 0 . 3 2 ) + ( 0 . 2 4 + 0 . 2 4 ) = 1 ,
$$

as desired. The local densities in Eq. (3.13a) and Eq. (3.13b) are plotted in Fig. 2. Though f 1 ( x ) is the sum of two Gaussians, in Fig. 2 (Left) we see that the Gaussian centered at x = 1 dominates, while the Gaussian centered at x = − 1 is only indicated by a heavy left tail. This behavior occurs because q (2) = 0 . 8 is very close to 1.

## 4. Kernel Density Estimation

Lemma 3.2 yields a deﬁnition of global pdf for a random persistence diagram that considers all features individually; however, as seen in Example 1, the computation of Eq. (3.9) can be rather formidable if one considers persistence diagrams with more than two points. To that end, our goal is the construction of a kernel density centered at a persistence diagram D with a bandwidth σ > 0 that reduces computational burden by treating some features individually and others collectively.
