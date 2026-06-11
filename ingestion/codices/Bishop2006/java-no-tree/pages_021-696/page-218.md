[Page 218]

Note that in (4.57) we have simply rewritten the posterior probabilities in an equivalent form, and so the appearance of the logistic sigmoid may seem rather vacuous. However, it will have signiﬁcance provided a(x) takes a simple functional form. We shall shortly consider situations in which a(x) is a linear function of x, in which case the posterior probability is governed by a generalized linear model.

For the case of K > 2 classes, we have

p(Ck|x) =

=

p(x|Ck)p(Ck) j p(x|Cj)p(Cj)

exp(ak) j exp(aj)

(4.62)

which is known as the normalized exponential and can be regarded as a multiclass generalization of the logistic sigmoid. Here the quantities ak are deﬁned by

ak = lnp(x|Ck)p(Ck). (4.63)

The normalized exponential is also known as the softmax function, as it represents a smoothed version of the ‘max’ function because, if ak aj for all j = k, then p(Ck|x) 1, and p(Cj|x) 0.

We now investigate the consequences of choosing speciﬁc forms for the classconditional densities, looking ﬁrst at continuous input variables x and then discussing brieﬂy the case of discrete inputs.

###### 4.2.1 Continuous inputs

Let us assume that the class-conditional densities are Gaussian and then explore the resulting form for the posterior probabilities. To start with, we shall assume that all classes share the same covariance matrix. Thus the density for class Ck is given by

1 |Σ|1/2

1 (2π)D/2

1 2

(x − µk)TΣ−1(x − µk) . (4.64) Consider ﬁrst the case of two classes. From (4.57) and (4.58), we have

p(x|Ck) =

exp −

p(C1|x) = σ(wTx + w0) (4.65) where we have deﬁned

w = Σ−1(µ1 − µ2) (4.66) w0 = −

p(C1) p(C2)

1 2

1 2

µT1 Σ−1µ1 +

µT2 Σ−1µ2 + ln

. (4.67)

We see that the quadratic terms in x from the exponents of the Gaussian densities have cancelled (due to the assumption of common covariance matrices) leading to a linear function of x in the argument of the logistic sigmoid. This result is illustrated for the case of a two-dimensional input space x in Figure 4.10. The resulting
