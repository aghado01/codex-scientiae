[Page 665]

###### 13.3.4 Particle ﬁlters

For dynamical systems which do not have a linear-Gaussian, for example, if

- Chapter 11 they use a non-Gaussian emission density, we can turn to sampling methods in order to ﬁnd a tractable inference algorithm. In particular, we can apply the samplingimportance-resampling formalism of Section 11.1.5 to obtain a sequential Monte Carlo algorithm known as the particle ﬁlter.


Consider the class of distributions represented by the graphical model in Figure 13.5, and suppose we are given the observed values Xn = (x1,...,xn) and we wish to draw L samples from the posterior distribution p(zn|Xn). Using Bayes’ theorem, we have

E[f(zn)] = f(zn)p(zn|Xn)dzn

= f(zn)p(zn|xn,Xn−1)dzn

=

f(zn)p(xn|zn)p(zn|Xn−1)dzn

p(xn|zn)p(zn|Xn−1)dzn

L

wn(l)f(z(nl)) (13.117)

l=1

where {z(nl)} is a set of samples drawn from p(zn|Xn−1) and we have made use of the conditional independence property p(xn|zn,Xn−1) = p(xn|zn), which follows from the graph in Figure 13.5. The sampling weights {wn(l)} are deﬁned by

p(xn|z(nl))

wn(l) =

(13.118)

L m=1 p(xn|z(nm))

where the same samples are used in the numerator as in the denominator. Thus the posterior distribution p(zn|xn) is represented by the set of samples {z(nl)} together with the corresponding weights {wn(l)}. Note that these weights satisfy 0 wn(l)1 and l wn(l) = 1.

Because we wish to ﬁnd a sequential sampling scheme, we shall suppose that a set of samples and weights have been obtained at time step n, and that we have subsequently observed the value of xn+1, and we wish to ﬁnd the weights and samples at time step n + 1. We ﬁrst sample from the distribution p(zn+1|Xn). This is
