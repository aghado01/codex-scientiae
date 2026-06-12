[Page 322]

$$
\text {variable, which is given by} \\ y ( x ) \ = \ \mathbb { E } [ t | x ] = \int _ { - \infty } ^ { \infty } t p ( t | x ) \, d t \\ = \ \frac { \int _ { \ } t p ( x , t ) \, d t } { \int p ( x , t ) \, d t } \\ \sum _ { m } \int _ { \ } t f ( x - x _ { n } , t - t _ { n } ) \, d t \\ = \ \frac { n } { \sum _ { m } \int f ( x - x _ { m } , t - t _ { m } ) \, d t } . \\
$$

We now assume for simplicity that the component density functions have zero mean so that ∞

$$
\int _ { - \infty } ^ { \infty } f ( x , t ) t \, d t & = 0 \\ \int a \, \text {simple change of variable} \, \text {, we then obtain}
$$

for all values of x . Using a simple change of variable, we then obtain

$$
\text {. Using a simple change of variable, we then obtain} \\ \sum _ { n } g ( x - x _ { n } ) t _ { n } \\ y ( x ) \ = \ \frac { n } { \sum _ { m } g ( x - x _ { m } ) } \\ = \ \sum _ { n } k ( x , x _ { n } ) t _ { n } \\ \dots , N \text { and the kernel function } k ( x , x _ { n } ) \text { is given by}
$$

where n,m = 1 ,...,N and the kernel function k ( x , x n ) is given by

$$
k ( x , x _ { n } ) = \frac { g ( x - x _ { n } ) } { \sum _ { m } g ( x - x _ { m } ) }
$$

and we have deﬁned

$$
g ( x ) & = \int _ { - \infty } ^ { \infty } f ( x , t ) \, d t . \\ \text {known as the Nadaraya-Watson model, or kernel regression}
$$

The result (6.45) is known as the Nadaraya-Watson model, or kernel regression (Nadaraya, 1964; Watson, 1964). For a localized kernel function, it has the property of giving more weight to the data points x n that are close to x . Note that the kernel (6.46) satisﬁes the summation constraint

$$
\sum _ { n = 1 } ^ { N } k ( x , x _ { n } ) = 1 .
$$
