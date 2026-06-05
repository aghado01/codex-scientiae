[Page 72]

0.5

probabilities

0.25

H = 1.77

0.5

probabilities

0.25

H = 3.09

0

0

Figure 1.30 Histograms of two probability distributions over 30 bins illustrating the higher value of the entropy H for the broader distribution. The largest entropy would arise from a uniform distribution that would give H = − ln(1/30) = 3.40.

from which we ﬁnd that all of the p(xi) are equal and are given by p(xi) = 1/M where M is the total number of states xi. The corresponding value of the entropy is then H = lnM. This result can also be derived from Jensen’s inequality (to be

Exercise 1.29 discussed shortly). To verify that the stationary point is indeed a maximum, we can

evaluate the second derivative of the entropy, which gives

∂H� ∂p(xi)∂p(xj)

1 pi

= −Iij

(1.100)

where Iij are the elements of the identity matrix.

We can extend the deﬁnition of entropy to include distributions p(x) over continuous variables x as follows. First divide x into bins of width ∆. Then, assuming p(x) is continuous, the mean value theorem (Weisstein, 1999) tells us that, for each such bin, there must exist a value xi such that

� (i+1)∆

p(x)dx = p(xi)∆. (1.101)

i∆

We can now quantize the continuous variable x by assigning any value x to the value xi whenever x falls in the ith bin. The probability of observing the value xi is then p(xi)∆. This gives a discrete distribution for which the entropy takes the form

H∆ = −�

p(xi)∆ln(p(xi)∆) = −�

p(xi)∆lnp(xi) − ln∆ (1.102)

i

i

�

i p(xi)∆ = 1, which follows from (1.101). We now omit the second term −ln∆ on the right-hand side of (1.102) and then consider the limit

where we have used
