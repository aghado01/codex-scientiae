[Page 609]

![image 146](../../../../../images/imageFile146.png)

###### 12.3. Kernel PCA 589

So far we have assumed that the projected data set given by ¢(xn ) has zero mean, which in general will not be the case. We cannot simply compute and then subtract off the mean, since we wish to avoid working directly in feature space, and so again, we formulate the algorithm purely in-!erms of the kernel function. The projected data points after centralizing, denoted ¢(xn ), are given by

- (12.83)
- (12.84)
- (12.85)


and the corresponding elements of the Gram matrix are given by

Knm = ¢(xn)T¢(xm )

1 N

¢(xn)T¢(xm ) - N L ¢(xn)T¢(xZ)

Z=l

1 N 1 N N

- N L¢(XZ)T¢(Xm ) + N2 LL¢(Xj)T¢(xZ)

Z=l j=l Z=l

1 N

k(xn,xm ) - N L k(xz, xm )

Z=l

1 N 1 N N

- N Lk(xn,xz) + N2 LLk(Xj,Xl)'

Z=l j=l 1=1

This can be expressed in matrix notation as

where IN denotes the N x N matrix in which every element takes the value l/N.

~ ~

Thus we can evaluate K using only the kernel function and then use K to determine the eigenvalues and eigenvectors. Note that the standard PCA algorithm is recovered as a special case if we use a linear kernel k(x, x') = xTx/. Figure 12.17 shows an example of kernel PCA applied to a synthetic data set (Scholkopf et al., 1998). Here a 'Gaussian' kernel of the form

- Exercise 12.27


###### k(x, x') = exp(-llx - x/112/0.1) (12.86)

is applied to a synthetic data set. The lines correspond to contours along which the projection onto the corresponding principal component, defined by

N

¢(X?Vi = L aink(X, xn) n=l

(12.87)

is constant.
