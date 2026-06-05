[Page 681]

form

�

�

wn(m) + eα

E = e−α

m/2

m/2

wn(m)

n∈Tm

n∈Mm

�N

�N

= (eα

m/2)

wn(m)I(ym(xn) �= tn) + e−α

m/2 − e−α

m/2

wn(m).

n=1

n=1

(14.23)

When we minimize this with respect to ym(x), we see that the second term is constant, and so this is equivalent to minimizing (14.15) because the overall multiplicative factor in front of the summation does not affect the location of the minimum. Similarly, minimizing with respect to αm, we obtain (14.17) in which �m is deﬁned

Exercise 14.6 by (14.16).

From (14.22) we see that, having found αm and ym(x), the weights on the data points are updated using

wn(m+1) = wn(m) exp�−

tnαmym(xn)�. (14.24)

1 2

Making use of the fact that

tnym(xn) = 1 − 2I(ym(xn) �= tn) (14.25) we see that the weights wn(m) are updated at the next iteration using

wn(m+1) = wn(m) exp(−αm/2)exp{αmI(ym(xn) �= tn)}. (14.26)

Because the term exp(−αm/2) is independent of n, we see that it weights all data points by the same factor and so can be discarded. Thus we obtain (14.18).

Finally, once all the base classiﬁers are trained, new data points are classiﬁed by evaluating the sign of the combined function deﬁned according to (14.21). Because the factor of 1/2 does not affect the sign it can be omitted, giving (14.19).

14.3.2 Error functions for boosting

The exponential error function that is minimized by the AdaBoost algorithm differs from those considered in previous chapters. To gain some insight into the nature of the exponential error function, we ﬁrst consider the expected error given by

� exp{−ty(x)}p(t|x)p(x)dx. (14.27)

�

Ex,t [exp{−ty(x)}] =

t

If we perform a variational minimization with respect to all possible functions y(x), Exercise 14.7 we obtain

ln�

� (14.28)

p(t = 1|x) p(t = −1|x)

1 2

y(x) =
