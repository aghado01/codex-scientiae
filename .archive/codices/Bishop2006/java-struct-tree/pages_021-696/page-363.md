[Page 363]

an = �an = 0. We again have a sparse solution, and the only terms that have to be evaluated in the predictive model (7.64) are those that involve the support vectors.

The parameter b can be found by considering a data point for which 0 < an < C, which from (7.67) must have ξn = 0, and from (7.65) must therefore satisfy � + yn − tn = 0. Using (7.1) and solving for b, we obtain

b = tn − � − wTφ(xn)

�N

(am − �am)k(xn,xm) (7.69)

= tn − � −

m=1

where we have used (7.57). We can obtain an analogous result by considering a point for which 0 < �an < C. In practice, it is better to average over all such estimates of b.

As with the classiﬁcation case, there is an alternative formulation of the SVM for regression in which the parameter governing complexity has a more intuitive interpretation (Scholkopf¨ et al., 2000). In particular, instead of ﬁxing the width � of the insensitive region, we ﬁx instead a parameter ν that bounds the fraction of points lying outside the tube. This involves maximizing

1 2

L�(a,�a) = −

+

subject to the constraints

�N

�N

(an − �an)(am − �am)k(xn,xm)

n=1

m=1

�N

(an − �an)tn (7.70)

n=1

0 � an � C/N (7.71) 0 � �an � C/N (7.72) �N

(an − �an) = 0 (7.73) �N

n=1

(an + �an) � νC. (7.74)

n=1

It can be shown that there are at most νN data points falling outside the insensitive tube, while at least νN data points are support vectors and so lie either on the tube or outside it.

The use of a support vector machine to solve a regression problem is illustrated

Appendix A using the sinusoidal data set in Figure 7.8. Here the parameters ν and C have been chosen by hand. In practice, their values would typically be determined by crossvalidation.
