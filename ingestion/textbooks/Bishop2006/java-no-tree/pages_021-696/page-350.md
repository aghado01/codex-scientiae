[Page 350]

In Appendix E, we show that a constrained optimization of this form satisﬁes the Karush-Kuhn-Tucker (KKT) conditions, which in this case require that the following three properties hold

an 0 (7.14) tny(xn) − 1 0 (7.15)

an {tny(xn) − 1} = 0. (7.16)

Thus for every data point, either an = 0 or tny(xn) = 1. Any data point for which an = 0 will not appear in the sum in (7.13) and hence plays no role in making predictions for new data points. The remaining data points are called support vectors, and because they satisfy tny(xn) = 1, they correspond to points that lie on the maximum margin hyperplanes in feature space, as illustrated in Figure 7.1. This property is central to the practical applicability of support vector machines. Once the model is trained, a signiﬁcant proportion of the data points can be discarded and only the support vectors retained.

Having solved the quadratic programming problem and found a value for a, we can then determine the value of the threshold parameter b by noting that any support vector xn satisﬁes tny(xn) = 1. Using (7.13) this gives

amtmk(xn,xm) + b = 1 (7.17)

tn

m∈S

where S denotes the set of indices of the support vectors. Although we can solve this equation for b using an arbitrarily chosen support vector xn, a numerically more stable solution is obtained by ﬁrst multiplying through by tn, making use of t2n = 1, and then averaging these equations over all support vectors and solving for b to give

1 NS n∈S

b =

amtmk(xn,xm) (7.18)

tn −

m∈S

where NS is the total number of support vectors.

For later comparison with alternative models, we can express the maximummargin classiﬁer in terms of the minimization of an error function, with a simple quadratic regularizer, in the form

###### N

E∞(y(xn)tn − 1) + λ w 2 (7.19)

n=1

where E∞(z) is a function that is zero if z 0 and ∞ otherwise and ensures that the constraints (7.5) are satisﬁed. Note that as long as the regularization parameter satisﬁes λ > 0, its precise value plays no role.

Figure 7.2 shows an example of the classiﬁcation resulting from training a support vector machine on a simple synthetic data set using a Gaussian kernel of the
