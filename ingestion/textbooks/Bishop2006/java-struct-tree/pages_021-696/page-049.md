[Page 49]

Figure 1.16 Schematic illustration of a Gaussian conditional distribution for t given x given by (1.60), in which the mean is given by the polynomial function y(x, w), and the precision is given by the parameter β, which is related to the variance by β−1 = σ2.

t

y(x,w)

y(x0,w) 2σ

p(t|x0,w,β)

x0 x

We now use the training data {x,t} to determine the values of the unknown parameters w and β by maximum likelihood. If the data are assumed to be drawn independently from the distribution (1.60), then the likelihood function is given by

�N

N �

�

tn|y(xn,w),β−1

p(t|x,w,β) =

. (1.61)

n=1

As we did in the case of the simple Gaussian distribution earlier, it is convenient to maximize the logarithm of the likelihood function. Substituting for the form of the Gaussian distribution, given by (1.46), we obtain the log likelihood function in the form

�N

N 2

β 2

N 2

{y(xn,w) − tn}2 +

lnβ −

ln(2π). (1.62)

lnp(t|x,w,β) = −

n=1

Consider ﬁrst the determination of the maximum likelihood solution for the polynomial coefﬁcients, which will be denoted by wML. These are determined by maximizing (1.62) with respect to w. For this purpose, we can omit the last two terms on the right-hand side of (1.62) because they do not depend on w. Also, we note that scaling the log likelihood by a positive constant coefﬁcient does not alter the location of the maximum with respect to w, and so we can replace the coefﬁcient β/2 with 1/2. Finally, instead of maximizing the log likelihood, we can equivalently minimize the negative log likelihood. We therefore see that maximizing likelihood is equivalent, so far as determining w is concerned, to minimizing the sum-of-squares error function deﬁned by (1.2). Thus the sum-of-squares error function has arisen as a consequence of maximizing likelihood under the assumption of a Gaussian noise distribution.

We can also use maximum likelihood to determine the precision parameter β of the Gaussian conditional distribution. Maximizing (1.62) with respect to β gives

�N

1 N

1 βML

{y(xn,wML) − tn}2 . (1.63)

=

n=1
