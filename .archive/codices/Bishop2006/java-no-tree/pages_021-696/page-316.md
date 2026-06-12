[Page 316]

###### Techniques for Constructing New Kernels.

Given valid kernels k1(x,x ) and k2(x,x ), the following new kernels will also be valid:

k(x,x ) = ck1(x,x ) (6.13) k(x,x ) = f(x)k1(x,x )f(x ) (6.14) k(x,x ) = q (k1(x,x )) (6.15) k(x,x ) = exp(k1(x,x )) (6.16) k(x,x ) = k1(x,x ) + k2(x,x ) (6.17) k(x,x ) = k1(x,x )k2(x,x ) (6.18) k(x,x ) = k3 (φ(x),φ(x )) (6.19) k(x,x ) = xTAx (6.20) k(x,x ) = ka(xa,x a) + kb(xb,x b) (6.21) k(x,x ) = ka(xa,x a)kb(xb,x b) (6.22)

where c > 0 is a constant, f(·) is any function, q(·) is a polynomial with nonnegative coefﬁcients, φ(x) is a function from x to RM, k3(·,·) is a valid kernel in RM, A is a symmetric positive semideﬁnite matrix, xa and xb are variables (not necessarily disjoint) with x = (xa,xb), and ka and kb are valid kernel functions over their respective spaces.

Equipped with these properties, we can now embark on the construction of more complex kernels appropriate to speciﬁc applications. We require that the kernel k(x,x ) be symmetric and positive semideﬁnite and that it expresses the appropriate form of similarity between x and x according to the intended application. Here we consider a few common examples of kernel functions. For a more extensive discussion of ‘kernel engineering’, see Shawe-Taylor and Cristianini (2004).

We saw that the simple polynomial kernel k(x,x ) = xTx 2 contains only terms of degree two. If we consider the slightly generalized kernel k(x,x ) =

xTx + c 2 with c > 0, then the corresponding feature mapping φ(x) contains constant and linear terms as well as terms of order two. Similarly, k(x,x ) = xTx M contains all monomials of order M. For instance, if x and x are two images, then the kernel represents a particular weighted sum of all possible products of M pixels in the ﬁrst image with M pixels in the second image. This can similarly be generalized to include all terms up to degree M by considering k(x,x ) = xTx + c M with c > 0. Using the results (6.17) and (6.18) for combining kernels we see that these will all be valid kernel functions.

Another commonly used kernel takes the form

###### k(x,x ) = exp − x − x 2/2σ2 (6.23)

and is often called a ‘Gaussian’ kernel. Note, however, that in this context it is not interpreted as a probability density, and hence the normalization coefﬁcient is
