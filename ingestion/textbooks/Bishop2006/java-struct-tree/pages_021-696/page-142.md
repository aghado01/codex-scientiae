[Page 142]

this neighbourhood property was deﬁned by the bins, and there is a natural ‘smoothing’ parameter describing the spatial extent of the local region, in this case the bin width. Second, the value of the smoothing parameter should be neither too large nor too small in order to obtain good results. This is reminiscent of the choice of model complexity in polynomial curve ﬁtting discussed in Chapter 1 where the degree M of the polynomial, or alternatively the value α of the regularization parameter, was optimal for some intermediate value, neither too large nor too small. Armed with these insights, we turn now to a discussion of two widely used nonparametric techniques for density estimation, kernel estimators and nearest neighbours, which have better scaling with dimensionality than the simple histogram model.

2.5.1 Kernel density estimators

Let us suppose that observations are being drawn from some unknown probability density p(x) in some D-dimensional space, which we shall take to be Euclidean, and we wish to estimate the value of p(x). From our earlier discussion of locality, let us consider some small region R containing x. The probability mass associated with this region is given by

P = �

p(x)dx. (2.242)

R

Now suppose that we have collected a data set comprising N observations drawn from p(x). Because each data point has a probability P of falling within R, the total number K of points that lie inside R will be distributed according to the binomial

Section 2.1 distribution

N! K!(N − K)!

PK(1 − P)1−K. (2.243)

Bin(K|N,P) =

Using (2.11), we see that the mean fraction of points falling inside the region is E[K/N] = P, and similarly using (2.12) we see that the variance around this mean is var[K/N] = P(1 − P)/N. For large N, this distribution will be sharply peaked around the mean and so

K � NP. (2.244)

If, however, we also assume that the region R is sufﬁciently small that the probability density p(x) is roughly constant over the region, then we have

P � p(x)V (2.245)

where V is the volume of R. Combining (2.244) and (2.245), we obtain our density estimate in the form

K NV

p(x) =

. (2.246)

Note that the validity of (2.246) depends on two contradictory assumptions, namely that the region R be sufﬁciently small that the density is approximately constant over the region and yet sufﬁciently large (in relation to the value of that density) that the number K of points falling inside the region is sufﬁcient for the binomial distribution to be sharply peaked.
