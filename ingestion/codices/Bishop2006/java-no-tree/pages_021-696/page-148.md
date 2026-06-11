[Page 148]

Use this result to prove by induction the following result

N

(1 + x)N =

m=0

N m

xm (2.263)

which is known as the binomial theorem, and which is valid for all real values of x. Finally, show that the binomial distribution is normalized, so that

###### N

m=0

N m

µm(1 − µ)N−m = 1 (2.264)

which can be done by ﬁrst pulling out a factor (1 − µ)N out of the summation and then making use of the binomial theorem.

- 2.4 ( ) Show that the mean of the binomial distribution is given by (2.11). To do this, differentiate both sides of the normalization condition (2.264) with respect to µ and then rearrange to obtain an expression for the mean of n. Similarly, by differentiating (2.264) twice with respect to µ and making use of the result (2.11) for the mean of the binomial distribution prove the result (2.12) for the variance of the binomial.
- 2.5 ( ) www In this exercise, we prove that the beta distribution, given by (2.13), is correctly normalized, so that (2.14) holds. This is equivalent to showing that

1

0

µa−1(1 − µ)b−1 dµ =

Γ(a)Γ(b) Γ(a + b)

. (2.265)

From the deﬁnition (1.141) of the gamma function, we have

Γ(a)Γ(b) =

∞

0

exp(−x)xa−1 dx

∞

0

exp(−y)yb−1 dy. (2.266)

Use this expression to prove (2.265) as follows. First bring the integral over y inside the integrand of the integral over x, next make the change of variable t = y + x where x is ﬁxed, then interchange the order of the x and t integrations, and ﬁnally make the change of variable x = tµ where t is ﬁxed.

- 2.6 ( ) Make use of the result (2.265) to show that the mean, variance, and mode of the beta distribution (2.13) are given respectively by


E[µ] =

var[µ] =

mode[µ] =

a a + b

(2.267)

ab (a + b)2(a + b + 1)

(2.268)

a − 1 a + b − 2

. (2.269)
