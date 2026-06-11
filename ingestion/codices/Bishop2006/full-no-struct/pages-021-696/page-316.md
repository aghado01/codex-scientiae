[Page 316]

# Techniques for Constructing New Kernels.

Given valid kernels k 1 ( x , x ) and k 2 ( x , x ) , the following new kernels will also be valid:

$$
k ( x , x ^ { \prime } ) \ = \ c k _ { 1 } ( x , x ^ { \prime } )
$$

$$
k ( x , x ^ { \prime } ) \ = \ f ( x ) k _ { 1 } ( x , x ^ { \prime } ) f ( x ^ { \prime } )
$$

$$
k ( x , x ^ { \prime } ) \ = \ q \left ( k _ { 1 } ( x , x ^ { \prime } ) \right )
$$

$$
k ( x , x ^ { \prime } ) \ = \ \exp \left ( k _ { 1 } ( x , x ^ { \prime } ) \right )
$$

$$
k ( x , x ^ { \prime } ) \ = \ k _ { 1 } ( x , x ^ { \prime } ) + k _ { 2 } ( x , x ^ { \prime } )
$$

$$
k ( x , x ^ { \prime } ) \ = \ k _ { 1 } ( x , x ^ { \prime } ) k _ { 2 } ( x , x ^ { \prime } )
$$

$$
k ( x , x ^ { \prime } ) \ = \ k _ { 3 } \left ( \phi ( x ) , \phi ( x ^ { \prime } ) \right )
$$

$$
k ( x , x ^ { \prime } ) \ = \ x ^ { \top } A x ^ { \prime }
$$

$$
k ( x , x ^ { \prime } ) \ = \ k _ { a } ( x _ { a } , x _ { a } ^ { \prime } ) + k _ { b } ( x _ { b } , x _ { b } ^ { \prime } )
$$

$$
k ( x , x ^ { \prime } ) \ = \ k _ { a } ( x _ { a } , x _ { a } ^ { \prime } ) k _ { b } ( x _ { b } , x _ { b } ^ { \prime } )
$$

where c > 0 is a constant, f ( · ) is any function, q ( · ) is a polynomial with nonnegative coefﬁcients, φ ( x ) is a function from x to R M , k 3 ( · , · ) is a valid kernel in R M , A is a symmetric positive semideﬁnite matrix, x a and x b are variables (not necessarily disjoint) with x = ( x a , x b ) , and k a and k b are valid kernel functions over their respective spaces.

Equipped with these properties, we can now embark on the construction of more complex kernels appropriate to speciﬁc applications. We require that the kernel k ( x , x ) be symmetric and positive semideﬁnite and that it expresses the appropriate form of similarity between x and x according to the intended application. Here we consider a few common examples of kernel functions. For a more extensive discussion of ‘kernel engineering’, see Shawe-Taylor and Cristianini (2004). 2

We saw that the simple polynomial kernel k ( x , x ) = x T x contains only terms of degree two. If we consider the slightly generalized kernel k ( x , x ) = x T x + c 2 with c > 0 , then the corresponding feature mapping φ ( x ) contains constant and linear terms as well as terms of order two. Similarly, k ( x , x ) = x T x M contains all monomials of order M . For instance, if x and x are two images, then the kernel represents a particular weighted sum of all possible products of M pixels in the ﬁrst image with M pixels in the second image. This can similarly be generalized to include all terms up to degree M by considering k ( x , x ) = x T x + c M with c > 0 . Using the results (6.17) and (6.18) for combining kernels we see that these will all be valid kernel functions.

Another commonly used kernel takes the form

$$
\text {commonly used kernel takes the form} \\ k ( x , x ^ { \prime } ) = \exp \left ( - \| x - x ^ { \prime } \| ^ { 2 } / 2 \sigma ^ { 2 } \right ) \\ \text {called a `Gaussian` kernel.  Note, however, that in this context it is
red as a probability density, and hence the normalization coefficient is


$$

and is often called a ‘Gaussian’ kernel. Note, however, that in this context it is not interpreted as a probability density, and hence the normalization coefﬁcient is
