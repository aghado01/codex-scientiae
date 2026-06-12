[Page 609]

Exercise 12.27

So far we have assumed that the projected data set given by ¢(x n ) has zero mean, which in general will not be the case. We cannot simply compute and then subtract off the mean, since we wish to avoid working directly in feature space, and so again, we formulate the algorithm purely in-!erms of the kernel function. The projected data points after centralizing, denoted ¢(x n ), are given by

$$
\widetilde { \phi } ( x _ { n } ) = \phi ( x _ { n } ) - \frac { 1 } { N } \sum _ { l = 1 } ^ { N } \phi ( x _ { l } )
$$

and the corresponding elements of the Gram matrix are given by

$$
and the corresponding elements of the Gram matrix are given by \\ & \widetilde { K } _ { n m } \ = \ \widetilde { \phi } ( x _ { n } ) ^ { T } \widetilde { \phi } ( x _ { m } ) \\ & = \ \phi ( x _ { n } ) ^ { T } \phi ( x _ { m } ) - \frac { 1 } { N } \sum _ { l = 1 } ^ { N } \phi ( x _ { n } ) ^ { T } \phi ( x _ { l } ) \\ & - \frac { 1 } { N } \sum _ { l = 1 } ^ { N } \phi ( x _ { l } ) ^ { T } \phi ( x _ { m } ) + \frac { 1 } { N ^ { 2 } } \sum _ { j = 1 } ^ { N } \sum _ { l = 1 } ^ { N } \phi ( x _ { j } ) ^ { T } \phi ( x _ { l } ) \\ & = \ k ( x _ { n } , x _ { m } ) - \frac { 1 } { N } \sum _ { l = 1 } ^ { N } k ( x _ { l } , x _ { m } ) \\ & - \frac { 1 } { N } \sum _ { l = 1 } ^ { N } k ( x _ { n } , x _ { l } ) + \frac { 1 } { N ^ { 2 } } \sum _ { j = 1 } ^ { N } \sum _ { l = 1 } ^ { N } k ( x _ { j } , x _ { l } ) . \\ \intertext { This can be expressed in matrix notation as }
$$

This can be expressed in matrix notation as

$$
( 1 2 . 8 5 )
$$

where IN denotes the N x N matrix in which every element takes the value l/N. ~ ~ Thus we can evaluate K using only the kernel function and then use K to determine the eigenvalues and eigenvectors. Note that the standard PCA algorithm is recovered as a special case if we use a linear kernel k(x, x') = xTx/. Figure 12.17 shows an example of kernel PCA applied to a synthetic data set (Scholkopf et al., 1998). Here a 'Gaussian' kernel of the form

$$
k ( x , x ^ { \prime } ) = \exp ( - \| x - x ^ { \prime } \| ^ { 2 } / 0 . 1 )
$$

is applied to a synthetic data set. The lines correspond to contours along which the projection onto the corresponding principal component, defined by

is constant.

$$
\phi ( x ) ^ { T } v _ { i } = \sum _ { n = 1 } ^ { N } a _ { i n } k ( x , x _ { n } )
$$
