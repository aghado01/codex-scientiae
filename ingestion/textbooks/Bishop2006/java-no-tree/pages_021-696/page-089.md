[Page 89]

where 0 µ 1, from which it follows that p(x = 0|µ) = 1 − µ. The probability distribution over x can therefore be written in the form

###### Bern(x|µ) = µx(1 − µ)1−x (2.2)

- Exercise 2.1 which is known as the Bernoulli distribution. It is easily veriﬁed that this distribution is normalized and that it has mean and variance given by


E[x] = µ (2.3) var[x] = µ(1 − µ). (2.4)

Now suppose we have a data set D = {x1,...,xN} of observed values of x. We can construct the likelihood function, which is a function of µ, on the assumption that the observations are drawn independently from p(x|µ), so that

N

N

p(xn|µ) =

n(1 − µ)1−xn. (2.5)

p(D|µ) =

µx

n=1

n=1

In a frequentist setting, we can estimate a value for µ by maximizing the likelihood function, or equivalently by maximizing the logarithm of the likelihood. In the case of the Bernoulli distribution, the log likelihood function is given by

N

lnp(xn|µ) =

lnp(D|µ) =

n=1

N

{xn lnµ + (1 − xn)ln(1 − µ)}. (2.6)

n=1

At this point, it is worth noting that the log likelihood function depends on the N observations xn only through their sum n xn. This sum provides an example of a sufﬁcient statistic for the data under this distribution, and we shall study the impor-

Section 2.4 tant role of sufﬁcient statistics in some detail. If we set the derivative of lnp(D|µ)

with respect to µ equal to zero, we obtain the maximum likelihood estimator

1 N

µML =

N

xn (2.7)

n=1

###### Jacob Bernoulli

![image 20](../../../../../images/imageFile20.png)

his time, including Boyle and Hooke in England. When he returned to Switzerland, he taught mechanics and became Professor of Mathematics at Basel in 1687. Unfortunately, rivalry between Jacob and his younger brother Johann turned an initially productive collaboration into a bitter and public dispute. Jacob’s most signiﬁcant contributions to mathematics appeared in The Art of Conjecturepublished in 1713, eight years after his death, which deals with topics in probability theory including what has become known as the Bernoulli distribution.

###### 1654–1705

Jacob Bernoulli, also known as Jacques or James Bernoulli, was a Swiss mathematician and was the ﬁrst of many in the Bernoulli family to pursue a career in science and mathematics. Although compelled

to study philosophy and theology against his will by his parents, he travelled extensively after graduating in order to meet with many of the leading scientists of
